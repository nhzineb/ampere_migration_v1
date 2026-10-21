# ==============================================================================
# GOLD ARCHITECTURE V2 — EXPLORES (strict many_to_one)
# explores/sdv_gold_architecture_v2.explore.lkml
#   1. sdv_traceability_coverage  (base: g2_fact_req_tc_traceability)
#   2. sdv_test_execution         (base: g2_fact_tc_ts_execution)
#   3. sdv_status_history         (base: g2_fact_entity_weekly_snapshot)
#   4. sdv_defects                (base: g2_fact_tr_issue)
# ==============================================================================

include: "/views/gold_v2/g2_views.view.lkml"
include: "/views/gold_v2/+g2_kpis.view.lkml"

datagroup: g2_daily_datagroup {
  sql_trigger: SELECT MAX(TR_RunDate) FROM `ampere_sdv_ivv.gold_fact_tc_ts_execution` ;;
  max_cache_age: "24 hours"
  label: "Gold v2 Daily Refresh"
}

# ------------------------------------------------------------------------------
explore: sdv_traceability_coverage {
  from: g2_fact_req_tc_traceability
  view_name: g2_fact_req_tc_traceability
  label: "1. Traceability & Coverage (Req x TC)"
  description: "Requirement-to-Test-Case coverage incl. uncovered requirements and orphan test cases. All joins many_to_one."
  persist_with: g2_daily_datagroup

  join: g2_dim_requirement {
    view_label: "Requirement"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_req_tc_traceability.req_id} = ${g2_dim_requirement.req_id} ;;
  }
  join: g2_dim_test_case {
    view_label: "Test Case"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_req_tc_traceability.tc_id} = ${g2_dim_test_case.tc_id} ;;
  }
  join: g2_parent_requirement {
    from: g2_dim_requirement
    view_label: "Parent Requirement"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_dim_requirement.req_parent_id} = ${g2_parent_requirement.req_id} ;;
    fields: [req_id, req_name, req_status, req_engineering_level, req_domain]
  }
}

# ------------------------------------------------------------------------------
explore: sdv_test_execution {
  from: g2_fact_tc_ts_execution
  view_name: g2_fact_tc_ts_execution
  label: "2. Test Execution & Latest Run (TC x TS x TR)"
  description: "Run history, campaign latest-run status (1 row per TC x TS), regressions. Requirement attributes come pre-aggregated on Test Case. All joins many_to_one."
  persist_with: g2_daily_datagroup

  join: g2_dim_test_case {
    view_label: "Test Case"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_tc_ts_execution.tc_id} = ${g2_dim_test_case.tc_id} ;;
  }
  join: g2_dim_test_set {
    view_label: "Test Set"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_tc_ts_execution.ts_id} = ${g2_dim_test_set.ts_id} ;;
  }

  # Re-enable once a temp dataset is configured on default_bigquery_connection
  # aggregate_table: agg_g2_latest_run_by_ts {
  #   query: {
  #     dimensions: [g2_dim_test_set.ts_vehicle_project, g2_dim_test_set.ts_bench_type, g2_dim_test_set.ts_baseline, g2_dim_test_case.tc_domain, g2_fact_tc_ts_execution.tr_result]
  #     measures: [g2_fact_tc_ts_execution.latest_executed, g2_fact_tc_ts_execution.latest_not_run, g2_fact_tc_ts_execution.latest_passed, g2_fact_tc_ts_execution.latest_failed, g2_fact_tc_ts_execution.latest_blocked]
  #     filters: [g2_fact_tc_ts_execution.is_last_run_in_ts: "Yes"]
  #   }
  #   materialization: { datagroup_trigger: g2_daily_datagroup }
  # }
}

# ------------------------------------------------------------------------------
explore: sdv_status_history {
  from: g2_fact_entity_weekly_snapshot
  view_name: g2_fact_entity_weekly_snapshot
  label: "3. Weekly Status History (Req / TC / Issue)"
  description: "Periodic weekly snapshots replacing the *_History_N tables. Partition-pruned by snapshot week. All joins many_to_one."
  persist_with: g2_daily_datagroup
  always_filter: { filters: [g2_fact_entity_weekly_snapshot.snapshot_date: "12 weeks"] }

  join: g2_dim_requirement {
    view_label: "Requirement"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_entity_weekly_snapshot.entity_type} = 'REQ'
      AND ${g2_fact_entity_weekly_snapshot.entity_id} = CAST(${g2_dim_requirement.req_id} AS STRING) ;;
  }
  join: g2_dim_test_case {
    view_label: "Test Case"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_entity_weekly_snapshot.entity_type} = 'TC'
      AND ${g2_fact_entity_weekly_snapshot.entity_id} = CAST(${g2_dim_test_case.tc_id} AS STRING) ;;
  }
  join: g2_dim_issue {
    view_label: "Issue"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_entity_weekly_snapshot.entity_type} = 'ISSUE'
      AND ${g2_fact_entity_weekly_snapshot.entity_id} = ${g2_dim_issue.issue_id} ;;
  }
}

# ------------------------------------------------------------------------------
explore: sdv_defects {
  from: g2_fact_tr_issue
  view_name: g2_fact_tr_issue
  label: "4. Defects (Test Run x Issue)"
  description: "Issue detail per test run. Anchored on the finest grain so every join is many_to_one."
  persist_with: g2_daily_datagroup

  join: g2_fact_tc_ts_execution {
    view_label: "Test Run"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_tr_issue.tr_id} = ${g2_fact_tc_ts_execution.tr_id} ;;
  }
  join: g2_dim_issue {
    view_label: "Issue"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_tr_issue.issue_id} = ${g2_dim_issue.issue_id} ;;
  }
  join: g2_dim_test_case {
    view_label: "Test Case"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_tr_issue.tc_id} = ${g2_dim_test_case.tc_id} ;;
  }
  join: g2_dim_test_set {
    view_label: "Test Set"
    type: left_outer
    relationship: many_to_one
    sql_on: ${g2_fact_tr_issue.ts_id} = ${g2_dim_test_set.ts_id} ;;
  }
}

# ------------------------------------------------------------------------------
# Data tests (require temp dataset on the connection)
# ------------------------------------------------------------------------------
test: g2_tr_id_is_unique_in_execution {
  explore_source: sdv_test_execution {
    column: tr_id { field: g2_fact_tc_ts_execution.tr_id }
    column: rows { field: g2_fact_tc_ts_execution.planned_tc_ts_pairs }
    filters: [g2_fact_tc_ts_execution.is_executed: "yes"]
    sorts: [g2_fact_tc_ts_execution.planned_tc_ts_pairs: desc]
    limit: 1
  }
  assert: one_tc_ts_per_tr { expression: ${g2_fact_tc_ts_execution.planned_tc_ts_pairs} <= 1 ;; }
}
