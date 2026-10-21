# ==============================================================================
# GOLD ARCHITECTURE V2 — KPI REFINEMENTS
# views/gold_v2/+g2_kpis.view.lkml
# ==============================================================================

include: "/views/gold_v2/g2_views.view.lkml"

# ------------------------------------------------------------------------------
# Explore 1 KPIs — Traceability & Coverage
# ------------------------------------------------------------------------------
view: +g2_fact_req_tc_traceability {
  measure: total_requirements { type: count_distinct sql: ${req_id} ;; label: "Requirements" }
  measure: covered_requirements { type: count_distinct sql: ${req_id} ;; filters: [is_req_covered_by_tc: "yes"] label: "Covered Requirements" }
  measure: uncovered_requirements { type: count_distinct sql: ${req_id} ;; filters: [is_req_covered_by_tc: "no"] label: "Uncovered Requirements" }
  measure: coverage_rate {
    type: number
    sql: SAFE_DIVIDE(${covered_requirements}, NULLIF(${total_requirements}, 0)) ;;
    value_format_name: percent_1
    label: "Requirement Coverage Rate"
  }
  measure: total_test_cases { type: count_distinct sql: ${tc_id} ;; label: "Test Cases" }
  measure: orphan_test_cases { type: count_distinct sql: ${tc_id} ;; filters: [is_tc_linked_to_req: "no"] label: "Orphan Test Cases" }
  measure: traceability_links { type: count filters: [is_req_covered_by_tc: "yes", is_tc_linked_to_req: "yes"] label: "Req-TC Links" }
}

# ------------------------------------------------------------------------------
# Explore 2 KPIs — Execution & Latest Run
# ------------------------------------------------------------------------------
view: +g2_fact_tc_ts_execution {

  parameter: horizontal_axis_selector {
    type: unquoted
    label: "Horizontal Axis"
    allowed_value: { label: "Run Week" value: "run_week" }
    allowed_value: { label: "Validation Baseline" value: "valid_baseline" }
    allowed_value: { label: "Run Result" value: "tr_result" }
    default_value: "run_week"
  }
  dimension: dynamic_horizontal_axis {
    type: string
    label_from_parameter: horizontal_axis_selector
    sql:
      {% if horizontal_axis_selector._parameter_value == 'run_week' %} ${cb_run_week}
      {% elsif horizontal_axis_selector._parameter_value == 'valid_baseline' %} ${valid_baseline}
      {% else %} ${tr_result} {% endif %} ;;
  }

  parameter: items_count_selector {
    type: unquoted
    label: "Items Count Metric"
    allowed_value: { label: "Distinct Test Cases" value: "distinct_tc" }
    allowed_value: { label: "Distinct Test Runs" value: "distinct_tr" }
    allowed_value: { label: "Distinct Test Sets" value: "distinct_ts" }
    default_value: "distinct_tc"
  }

  measure: planned_tc_ts_pairs { type: count_distinct sql: CONCAT(CAST(${tc_id} AS STRING), '_', CAST(${ts_id} AS STRING)) ;; label: "Planned (TC x TS)" }
  measure: distinct_test_cases { type: count_distinct sql: ${tc_id} ;; label: "Distinct Test Cases" }
  measure: distinct_test_sets { type: count_distinct sql: ${ts_id} ;; label: "Distinct Test Sets" }
  measure: total_test_runs { type: count_distinct sql: ${tr_id} ;; label: "Test Runs" }
  measure: dynamic_items_count {
    type: number
    label_from_parameter: items_count_selector
    sql:
      {% if items_count_selector._parameter_value == 'distinct_tc' %} ${distinct_test_cases}
      {% elsif items_count_selector._parameter_value == 'distinct_tr' %} ${total_test_runs}
      {% else %} ${distinct_test_sets} {% endif %} ;;
  }

  # Campaign latest run (grain TC x TS) — rows are unique, plain counts are safe
  measure: latest_executed { type: count filters: [is_last_run_in_ts: "yes", is_executed: "yes"] label: "Latest Run — Executed" }
  measure: latest_not_run { type: count filters: [is_last_run_in_ts: "yes", is_executed: "no"] label: "Latest Run — Not Run" }
  measure: latest_passed {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "Passed"]
    label: "Latest Run — Passed"
    link: { label: "Defects for these runs" url: "/explore/ampere_sdv_gold_architecture_v2/sdv_defects?f[g2_fact_tr_issue.is_last_run_in_ts]=Yes" }
  }
  measure: latest_failed {
    type: count
    filters: [is_last_run_in_ts: "yes", tr_result: "Failed"]
    label: "Latest Run — Failed"
    link: { label: "Defects for these runs" url: "/explore/ampere_sdv_gold_architecture_v2/sdv_defects?f[g2_fact_tr_issue.is_last_run_in_ts]=Yes&f[g2_fact_tr_issue.tr_result]=Failed" }
  }
  measure: latest_blocked { type: count filters: [is_last_run_in_ts: "yes", tr_result: "Blocked"] label: "Latest Run — Blocked" }
  measure: campaign_execution_rate {
    type: number
    sql: SAFE_DIVIDE(${latest_executed}, NULLIF(${latest_executed} + ${latest_not_run}, 0)) ;;
    value_format_name: percent_1
    label: "Campaign Execution Rate"
  }
  measure: campaign_pass_rate {
    type: number
    sql: SAFE_DIVIDE(${latest_passed}, NULLIF(${latest_executed}, 0)) ;;
    value_format_name: percent_1
    label: "Campaign Pass Rate"
  }

  # Global latest run per TC
  measure: global_latest_passed_tcs { type: count_distinct sql: ${tc_id} ;; filters: [is_global_last_run_for_tc: "yes", tr_result: "Passed"] label: "Global Latest — Passed TCs" }
  measure: global_latest_failed_tcs { type: count_distinct sql: ${tc_id} ;; filters: [is_global_last_run_for_tc: "yes", tr_result: "Failed"] label: "Global Latest — Failed TCs" }

  # First run & regressions
  measure: first_run_passed { type: count filters: [is_first_run_in_ts: "yes", tr_result: "Passed"] label: "First Run — Passed" }
  measure: regression_runs { type: count filters: [tr_regression: "Regression"] label: "Regression Runs" }

  # Pre-aggregated defect counts (no join to issues needed)
  measure: issues_on_latest_runs { type: sum sql: ${tr_nb_issues_total} ;; filters: [is_last_run_in_ts: "yes"] label: "Issues on Latest Runs" }
  measure: closed_issues_on_latest_runs { type: sum sql: ${tr_nb_issues_closed} ;; filters: [is_last_run_in_ts: "yes"] label: "Closed Issues on Latest Runs" }
  measure: invalid_issues_on_latest_runs { type: sum sql: ${tr_nb_issues_invalid} ;; filters: [is_last_run_in_ts: "yes"] label: "Invalid Issues on Latest Runs" }
}

# ------------------------------------------------------------------------------
# Explore 3 KPIs — Weekly Status History
# ------------------------------------------------------------------------------
view: +g2_fact_entity_weekly_snapshot {
  measure: entities { type: count_distinct sql: ${entity_id} ;; label: "Entities" }
  measure: requirements { type: count_distinct sql: ${entity_id} ;; filters: [entity_type: "REQ"] label: "Requirements" }
  measure: test_cases { type: count_distinct sql: ${entity_id} ;; filters: [entity_type: "TC"] label: "Test Cases" }
  measure: issues { type: count_distinct sql: ${entity_id} ;; filters: [entity_type: "ISSUE"] label: "Issues" }
  measure: avg_weeks_in_status { type: average sql: ${nb_weeks_in_status} ;; value_format_name: decimal_1 label: "Avg Weeks in Status" }
}

# ------------------------------------------------------------------------------
# Explore 4 KPIs — Defects
# ------------------------------------------------------------------------------
view: +g2_fact_tr_issue {
  measure: distinct_issues { type: count_distinct sql: ${issue_id} ;; label: "Distinct Issues" }
  measure: distinct_runs_with_issues { type: count_distinct sql: ${tr_id} ;; label: "Runs with Issues" }
  measure: distinct_tcs_with_issues { type: count_distinct sql: ${tc_id} ;; label: "TCs with Issues" }
  measure: tr_issue_links { type: count label: "Run-Issue Links" }
}

view: +g2_dim_issue {
  measure: open_issues { type: count_distinct sql: ${issue_id} ;; filters: [is_open: "yes"] label: "Open Issues" }
  measure: critical_issues { type: count_distinct sql: ${issue_id} ;; filters: [issue_criticity: "Critical,Blocking,Major"] label: "Critical / Major Issues" }
}

# ------------------------------------------------------------------------------
# Dimension-level inventory measures (safe: dims are joined N:1 everywhere)
# ------------------------------------------------------------------------------
view: +g2_dim_test_case {
  measure: automated_tcs { type: count_distinct sql: ${tc_id} ;; filters: [is_automated: "yes"] label: "Automated Test Cases" }
  measure: tcs_linked_to_req { type: count_distinct sql: ${tc_id} ;; filters: [is_linked_to_req: "yes"] label: "TCs Linked to a Requirement" }
}

view: +g2_dim_requirement {
  measure: requirements_covered { type: count_distinct sql: ${req_id} ;; filters: [is_covered_by_tc: "yes"] label: "Requirements Covered (pre-agg)" }
}
