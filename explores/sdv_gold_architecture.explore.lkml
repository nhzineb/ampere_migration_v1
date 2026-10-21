# ==============================================================================
# EXPLORES: sdv_gold_architecture.explore.lkml
# Gold Canonical Architecture — 2 Decoupled, Governed Explores:
#   1. sdv_traceability_coverage (World 1: Requirement <-> Test Case Coverage)
#   2. sdv_test_execution        (World 2: Test Execution History + Latest Run)
# ==============================================================================

include: "/views/gold_layer/gold_canonical_views.view.lkml"
include: "/views/gold_layer/+gold_canonical_kpis.view.lkml"

datagroup: sdv_gold_daily_datagroup {
  sql_trigger: SELECT MAX(TR_RunDate) FROM `ampere_sdv_ivv.gold_fact_tc_ts_execution` ;;
  max_cache_age: "24 hours"
  label: "SDV Gold Daily Refresh"
}

# ------------------------------------------------------------------------------
# EXPLORE 1: TRACEABILITY & COVERAGE (Replaces New_Req_Status & New_TC_Status)
# Zero fan-out from Test Sets, Test Runs, or Issues!
# ------------------------------------------------------------------------------
explore: sdv_traceability_coverage {
  from: gold_fact_req_tc_traceability
  view_name: gold_fact_req_tc_traceability
  label: "1. SDV Traceability & Coverage (Gold — Req <-> TC)"
  description: "Horizontal & vertical traceability between Requirements, MySF, Baselines, and Test Cases (includes uncovered Requirements and orphan Test Cases)."
  persist_with: sdv_gold_daily_datagroup

  join: gold_dim_requirement {
    view_label: "1. Requirement (Canonical Dimension)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gold_fact_req_tc_traceability.req_id} = ${gold_dim_requirement.req_id} ;;
  }

  join: gold_dim_test_case {
    view_label: "2. Test Case (Canonical Dimension)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gold_fact_req_tc_traceability.tc_id} = ${gold_dim_test_case.tc_id} ;;
  }

  # Note: Uncomment aggregate_table once temp_schema is configured on default_bigquery_connection:
  # aggregate_table: agg_gold_traceability_by_domain_mysf {
  #   query: {
  #     dimensions: [gold_dim_requirement.req_domain, gold_dim_requirement.req_asil, gold_dim_requirement.req_mysf, gold_dim_requirement.req_baseline]
  #     measures: [gold_fact_req_tc_traceability.total_distinct_requirements, gold_fact_req_tc_traceability.covered_requirements_count, gold_fact_req_tc_traceability.uncovered_requirements_count, gold_fact_req_tc_traceability.total_distinct_test_cases]
  #   }
  #   materialization: { datagroup_trigger: sdv_gold_daily_datagroup }
  # }
}

# ------------------------------------------------------------------------------
# EXPLORE 2: TEST EXECUTION & LATEST RUN (Replaces New_TC_Runs & New_Req_Runs)
# Unifies Historical Runs (Explore B) + Campaign Latest Run (Explore C) via
# pre-computed is_last_run_in_ts flag + Aggregate Awareness materialization!
# ------------------------------------------------------------------------------
explore: sdv_test_execution {
  from: gold_fact_tc_ts_execution
  view_name: gold_fact_tc_ts_execution
  label: "2. SDV Test Execution & Latest Run (Gold — TC <-> TS <-> TR)"
  description: "Historical test run trends, campaign latest-run status (1 row per TC x TS), regressions, and defect drill-down without Issue fan-out."
  persist_with: sdv_gold_daily_datagroup

  # Core Star-Schema N:1 Dimension Joins (Zero Fan-Out, Automatic Join Pruning)
  join: gold_dim_test_case {
    view_label: "1. Test Case (Canonical Dimension)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gold_fact_tc_ts_execution.tc_id} = ${gold_dim_test_case.tc_id} ;;
  }

  join: gold_dim_test_set {
    view_label: "2. Test Set (Canonical Dimension)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gold_fact_tc_ts_execution.ts_id} = ${gold_dim_test_set.ts_id} ;;
  }

  # Optional 1:N Bridge to Requirements (Pruned unless user filters/groups by Req/MySF)
  join: gold_fact_req_tc_traceability {
    view_label: "3. Traceability Bridge (Req <-> TC)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${gold_fact_tc_ts_execution.tc_id} = ${gold_fact_req_tc_traceability.tc_id} ;;
  }

  join: gold_dim_requirement {
    view_label: "4. Requirement (Filter by MySF / Baseline / ASIL)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gold_fact_req_tc_traceability.req_id} = ${gold_dim_requirement.req_id} ;;
  }

  # Optional 1:N Bridge to Defects/Issues (Pruned unless user drills into Issue details)
  join: gold_bridge_tr_issue {
    view_label: "5. Defect Bridge (TR <-> Issue)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${gold_fact_tc_ts_execution.tr_id} = ${gold_bridge_tr_issue.tr_id} ;;
  }

  join: gold_dim_issue {
    view_label: "5. Defect / Issue (Canonical Dimension)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gold_bridge_tr_issue.issue_id} = ${gold_dim_issue.issue_id} ;;
  }

  # Note: Uncomment aggregate_table blocks once temp_schema is configured on default_bigquery_connection:
  # aggregate_table: agg_gold_latest_run_by_ts {
  #   query: {
  #     dimensions: [gold_dim_test_set.ts_vehicle_project, gold_dim_test_set.ts_bench_type, gold_dim_test_set.ts_baseline, gold_dim_test_case.tc_domain, gold_fact_tc_ts_execution.tr_result]
  #     measures: [gold_fact_tc_ts_execution.latest_run_executed_count, gold_fact_tc_ts_execution.latest_run_not_run_count, gold_fact_tc_ts_execution.latest_run_passed_count, gold_fact_tc_ts_execution.latest_run_failed_count, gold_fact_tc_ts_execution.latest_run_blocked_count]
  #     filters: [gold_fact_tc_ts_execution.is_last_run_in_ts: "Yes"]
  #   }
  #   materialization: { datagroup_trigger: sdv_gold_daily_datagroup }
  # }
}

test: gold_execution_grain_pk_is_unique {
  explore_source: sdv_test_execution {
    column: execution_grain_pk { field: gold_fact_tc_ts_execution.execution_grain_pk }
    column: tr_count { field: gold_fact_tc_ts_execution.total_test_runs_count }
    sorts: [gold_fact_tc_ts_execution.total_test_runs_count: desc]
    limit: 1
  }
  assert: pk_has_no_issue_or_req_duplication {
    expression: ${gold_fact_tc_ts_execution.total_test_runs_count} <= 1 ;;
  }
}
