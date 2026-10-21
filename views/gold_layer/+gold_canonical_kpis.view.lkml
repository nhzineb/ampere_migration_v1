# ==============================================================================
# REFINEMENT VIEWS: +gold_canonical_kpis.view.lkml
# Governed KPIs, Dynamic Selectors & Drill Sets for Gold 2-Explore Architecture
# ==============================================================================

include: "/views/gold_layer/gold_canonical_views.view.lkml"

# ------------------------------------------------------------------------------
# 1. TRACEABILITY & COVERAGE KPIS (World 1: sdv_traceability_coverage)
# ------------------------------------------------------------------------------
view: +gold_fact_req_tc_traceability {

  measure: total_distinct_requirements {
    type: count_distinct
    sql: ${req_id} ;;
    label: "Total Distinct Requirements"
    description: "Count of distinct Requirements (Req_Id)"
  }

  measure: covered_requirements_count {
    type: count_distinct
    sql: ${req_id} ;;
    filters: [is_req_covered_by_tc: "yes"]
    label: "Covered Requirements (with >=1 TC)"
    description: "Count of distinct Requirements linked to at least one Test Case"
  }

  measure: uncovered_requirements_count {
    type: count_distinct
    sql: ${req_id} ;;
    filters: [is_req_covered_by_tc: "no"]
    label: "Uncovered Requirements (0 TC)"
    description: "Count of distinct Requirements with no linked Test Case"
  }

  measure: requirement_coverage_rate {
    type: number
    sql: SAFE_DIVIDE(${covered_requirements_count}, NULLIF(${total_distinct_requirements}, 0)) ;;
    value_format_name: percent_1
    label: "Requirement Test Coverage Rate (%)"
    description: "Percentage of Requirements covered by at least one Test Case"
  }

  measure: total_distinct_test_cases {
    type: count_distinct
    sql: ${tc_id} ;;
    label: "Total Distinct Test Cases"
    description: "Count of distinct Test Cases (TC_Id)"
  }

  measure: orphan_test_cases_count {
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [is_tc_linked_to_req: "no"]
    label: "Orphan Test Cases (No Linked Req)"
    description: "Count of distinct Test Cases not linked to any Requirement"
  }
}

# ------------------------------------------------------------------------------
# 2. EXECUTION, LAST RUN & DEFECT KPIS (World 2: sdv_test_execution)
# ------------------------------------------------------------------------------
view: +gold_fact_tc_ts_execution {

  # --- Interactive Spotfire Selector Parameters ---
  parameter: tr_horizontal_axis_selector {
    type: unquoted
    label: "Dynamic Horizontal Axis Selector"
    description: "Replaces Spotfire Document Property ${TRHorizontalAxis}"
    allowed_value: { label: "Run Week" value: "run_week" }
    allowed_value: { label: "Validation Baseline" value: "valid_baseline" }
    allowed_value: { label: "Test Run Result" value: "tr_result" }
    default_value: "run_week"
  }

  dimension: dynamic_horizontal_axis {
    type: string
    label_from_parameter: tr_horizontal_axis_selector
    sql:
      {% if tr_horizontal_axis_selector._parameter_value == 'run_week' %}
        ${cb_run_week}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'valid_baseline' %}
        ${valid_baseline}
      {% else %}
        ${tr_result}
      {% endif %} ;;
  }

  parameter: items_count_selector {
    type: unquoted
    label: "Dynamic KPI Metric Selector"
    description: "Replaces Spotfire Document Property ${ItemsCount}"
    allowed_value: { label: "Distinct Test Cases" value: "distinct_tc" }
    allowed_value: { label: "Distinct Test Runs" value: "distinct_tr" }
    allowed_value: { label: "Distinct Test Sets" value: "distinct_ts" }
    default_value: "distinct_tc"
  }

  # --- Core Inventory & Execution Volume Measures ---
  measure: planned_tc_ts_pairs_count {
    type: count_distinct
    sql: CONCAT(CAST(${tc_id} AS STRING), '_', CAST(${ts_id} AS STRING)) ;;
    label: "Planned (TC x TS) Campaign Scope"
    description: "Total distinct (Test Case, Test Set) assignments"
  }

  measure: distinct_test_cases_count {
    type: count_distinct
    sql: ${tc_id} ;;
    label: "Distinct Test Cases (TC)"
  }

  measure: distinct_test_sets_count {
    type: count_distinct
    sql: ${ts_id} ;;
    label: "Distinct Test Sets (TS)"
  }

  measure: total_test_runs_count {
    type: count_distinct
    sql: ${tr_id} ;;
    label: "Total Historical Test Runs (TR)"
    description: "Total distinct Test Runs executed (all runs history)"
  }

  measure: dynamic_items_count {
    type: number
    label_from_parameter: items_count_selector
    sql:
      {% if items_count_selector._parameter_value == 'distinct_tc' %}
        ${distinct_test_cases_count}
      {% elsif items_count_selector._parameter_value == 'distinct_tr' %}
        ${total_test_runs_count}
      {% else %}
        ${distinct_test_sets_count}
      {% endif %} ;;
  }

  # --- Latest Run in Test Set (Campaign-Level Current Status — Recommended Grain) ---
  measure: latest_run_executed_count {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "-Not Run"]
    label: "Latest Run — Executed (TC x TS)"
    description: "Number of (TC, TS) assignments executed at least once (evaluated on is_last_run_in_ts)"
  }

  measure: latest_run_not_run_count {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "Not Run"]
    label: "Latest Run — Not Run (TC x TS)"
    description: "Number of planned (TC, TS) assignments with zero executions"
  }

  measure: latest_run_passed_count {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "Passed"]
    label: "Latest Run — Passed (TC x TS)"
    description: "Number of (TC, TS) assignments whose latest run Passed"
  }

  measure: latest_run_failed_count {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "Failed"]
    label: "Latest Run — Failed (TC x TS)"
    description: "Number of (TC, TS) assignments whose latest run Failed"
  }

  measure: latest_run_blocked_count {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "Blocked"]
    label: "Latest Run — Blocked (TC x TS)"
    description: "Number of (TC, TS) assignments whose latest run is Blocked"
  }

  measure: latest_run_execution_rate {
    type: number
    sql: SAFE_DIVIDE(${latest_run_executed_count}, NULLIF(${latest_run_executed_count} + ${latest_run_not_run_count}, 0)) ;;
    value_format_name: percent_1
    label: "Campaign Execution Rate (%)"
    description: "Executed (TC, TS) pairs divided by total planned (TC, TS) pairs"
  }

  measure: latest_run_pass_rate {
    type: number
    sql: SAFE_DIVIDE(${latest_run_passed_count}, NULLIF(${latest_run_executed_count}, 0)) ;;
    value_format_name: percent_1
    label: "Campaign Latest Run Pass Rate (%)"
    description: "Passed latest runs divided by total executed (TC, TS) pairs"
  }

  # --- Global Latest Run per Test Case (1 per TC_Id across all campaigns) ---
  measure: global_latest_tc_passed_count {
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [is_global_last_run_for_tc: "yes", tr_result: "Passed"]
    label: "Global Latest TC — Passed"
    description: "Distinct TCs whose global most recent run across all Test Sets Passed"
  }

  measure: global_latest_tc_failed_count {
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [is_global_last_run_for_tc: "yes", tr_result: "Failed"]
    label: "Global Latest TC — Failed"
  }

  # --- First Run & Regression KPIs ---
  measure: first_run_passed_count {
    type: count
    filters: [is_first_run_in_ts: "yes", tr_result: "Passed"]
    label: "First Run — Passed (First Time Right)"
  }

  measure: regression_runs_count {
    type: count
    filters: [tr_regression: "Regression"]
    label: "Regression Runs Count"
    description: "Runs where status regressed from Passed to Failed/Blocked"
  }

  # --- Pre-Aggregated Defect & Fix Version KPIs (Zero Issue Fan-Out) ---
  measure: total_closed_issues_on_latest_runs {
    type: sum
    sql: ${tr_nb_issues_closed} ;;
    filters: [is_last_run_in_ts: "yes"]
    label: "Closed Issues on Latest Runs (LV5)"
  }

  measure: total_invalid_issues_on_latest_runs {
    type: sum
    sql: ${tr_nb_issues_invalid} ;;
    filters: [is_last_run_in_ts: "yes"]
    label: "Invalid Issues on Latest Runs (LV5)"
  }
}

# ------------------------------------------------------------------------------
# 3. DIMENSION & DEFECT DRILL MEASURES
# ------------------------------------------------------------------------------
view: +gold_dim_test_case {
  measure: automated_tc_count {
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [automation_status: "Automated,Done,Validated"]
    label: "Automated Test Cases Count"
  }
}

view: +gold_dim_issue {
  measure: distinct_issues_count {
    type: count_distinct
    sql: ${issue_id} ;;
    label: "Distinct Linked Issues Count"
  }
}
