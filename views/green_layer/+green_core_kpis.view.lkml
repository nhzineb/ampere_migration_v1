# ==============================================================================
# EXPERIMENT 2 (GREEN LAYER): LAYER 2 CERTIFIED KPI & PARAMETER REFINEMENTS
# (views/green_layer/+green_core_kpis.view.lkml)
# ==============================================================================

include: "/views/green_layer/green_core_views.view.lkml"

view: +green_dim_tc {

  set: green_drill_details {
    fields: [
      tc_id,
      tc_name,
      tc_status,
      tc_domain,
      tc_validation_team,
      green_tc_eng_lvl.tc_engineering_level,
      green_tc_system.tc_system_owner,
      green_bridge_tc_ts.ts_id,
      green_dim_ts.ts_vehicle_project,
      green_fact_tr.tr_id,
      green_fact_tr.tr_result,
      green_fact_tr.tr_run_date,
      green_fact_tr.tr_run_week,
      green_dim_issues.issue_id,
      green_dim_issues.issue_status,
      green_dim_issues.issue_criticity,
      green_bridge_req_tc_feature.req_id
    ]
  }

  # --- Spotfire Calculated Columns Recomputed Across Green Layer Bridges ---
  dimension: qua_tc_in_ts {
    label: "QUA TC in TS (Green Layer Bridge)"
    type: string
    sql:
      CASE
        WHEN ${green_bridge_tc_ts.ts_id} IS NULL THEN 'not in a Test Set'
        ELSE 'In a Test Set'
      END ;;
  }

  dimension: qua_tc_not_ready {
    label: "QUA TC Not Ready (Green Layer Bridge)"
    type: string
    sql:
      CASE
        WHEN ${green_bridge_tc_ts.ts_id} IS NOT NULL AND ${tc_status} IN ('Accepted', 'Approved') THEN 'Ok'
        ELSE 'TC not Ready'
      END ;;
  }

  dimension: qua_tr_without_issues {
    label: "QUA TR Without Issues (Green Layer)"
    type: string
    sql:
      CASE
        WHEN ${green_fact_tr.tr_result} IN ('Failed', 'Blocked') AND ${green_fact_tr.issue_cb_id} IS NULL THEN 'No Issue linked'
        WHEN ${green_fact_tr.tr_result} IN ('Failed', 'Blocked') AND ${green_fact_tr.issue_cb_id} IS NOT NULL THEN 'Issue linked'
        ELSE NULL
      END ;;
  }

  dimension: auto_ts_runs {
    label: "Auto TS Runs (Green Layer Bridge)"
    type: string
    sql:
      CASE
        WHEN ${green_bridge_tc_ts.ts_id} IS NOT NULL THEN 'In a TS'
        ELSE 'Not in a TS'
      END ;;
  }

  # --- Spotfire Document Properties -> Native LookML Parameters + Liquid ---
  parameter: tr_horizontal_axis_selector {
    label: "Horizontal Axis Selector (Spotfire tr.horizontalAxis)"
    type: unquoted
    default_value: "ts_vehicle_project"
    allowed_value: { label: "Vehicle Project" value: "ts_vehicle_project" }
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TS Domain" value: "ts_domain" }
    allowed_value: { label: "Validation Team" value: "tc_validation_team" }
  }

  dimension: dynamic_horizontal_axis {
    label_from_parameter: tr_horizontal_axis_selector
    type: string
    sql:
      {% if tr_horizontal_axis_selector._parameter_value == 'ts_vehicle_project' %}
        ${green_dim_ts.ts_vehicle_project}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'ts_domain' %}
        ${green_dim_ts.ts_domain}
      {% else %}
        ${tc_validation_team}
      {% endif %} ;;
  }

  parameter: column_axis_selector {
    label: "CrossTable Column Axis (Spotfire ColumnAxis)"
    type: unquoted
    default_value: "ts_domain"
    allowed_value: { label: "TS Domain" value: "ts_domain" }
    allowed_value: { label: "TC Status" value: "tc_status" }
    allowed_value: { label: "TR Result" value: "tr_result" }
    allowed_value: { label: "TS Vehicle Project" value: "ts_vehicle_project" }
  }

  dimension: dynamic_column_axis {
    label_from_parameter: column_axis_selector
    type: string
    sql:
      {% if column_axis_selector._parameter_value == 'ts_domain' %}
        ${green_dim_ts.ts_domain}
      {% elsif column_axis_selector._parameter_value == 'tc_status' %}
        ${tc_status}
      {% elsif column_axis_selector._parameter_value == 'tr_result' %}
        ${green_fact_tr.tr_result}
      {% else %}
        ${green_dim_ts.ts_vehicle_project}
      {% endif %} ;;
  }

  parameter: rows_axis_selector {
    label: "CrossTable Row Axis (Spotfire RowsAxis)"
    type: unquoted
    default_value: "tc_domain"
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TC Validation Team" value: "tc_validation_team" }
  }

  dimension: dynamic_rows_axis {
    label_from_parameter: rows_axis_selector
    type: string
    sql:
      {% if rows_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% else %}
        ${tc_validation_team}
      {% endif %} ;;
  }

  parameter: items_count_selector {
    label: "Items Count Entity Selector (Spotfire ItemsCount)"
    type: unquoted
    default_value: "ts_id"
    allowed_value: { label: "Unique Test Sets (TS_Id)" value: "ts_id" }
    allowed_value: { label: "Unique Test Cases (TC_Id)" value: "tc_id" }
    allowed_value: { label: "Unique Test Runs (TR_Id)" value: "tr_id" }
    allowed_value: { label: "Unique Requirements (Req_Id)" value: "req_id" }
  }

  measure: dynamic_items_unique_count {
    label_from_parameter: items_count_selector
    type: number
    sql:
      {% if items_count_selector._parameter_value == 'ts_id' %}
        COUNT(DISTINCT ${green_bridge_tc_ts.ts_id})
      {% elsif items_count_selector._parameter_value == 'tc_id' %}
        COUNT(DISTINCT ${tc_id})
      {% elsif items_count_selector._parameter_value == 'tr_id' %}
        COUNT(DISTINCT ${green_fact_tr.tr_id})
      {% else %}
        COUNT(DISTINCT ${green_bridge_req_tc_feature.req_id})
      {% endif %} ;;
    drill_fields: [green_drill_details*]
  }

  # --- Core Hub Measures ---
  measure: unique_tc_count {
    label: "Total Unique Test Cases (TC)"
    type: count_distinct
    sql: ${tc_id} ;;
    drill_fields: [green_drill_details*]
  }

  measure: unique_tr_count {
    label: "Total Unique Test Runs (TR)"
    type: count_distinct
    sql: ${green_fact_tr.tr_id} ;;
    drill_fields: [green_drill_details*]
  }

  measure: unique_ts_count {
    label: "Total Unique Test Sets (TS)"
    type: count_distinct
    sql: ${green_bridge_tc_ts.ts_id} ;;
    drill_fields: [green_drill_details*]
  }

  # --- Page 1: Last Run Measures ---
  measure: last_run_total_tc_count {
    label: "Last Run — Total TCs"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [green_tr_ranked_derived.is_dynamic_last_run: "yes"]
    drill_fields: [green_drill_details*]
  }

  measure: last_run_passed_tc_count {
    label: "Last Run — Passed TCs"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Passed"
    ]
    drill_fields: [green_drill_details*]
  }

  measure: last_run_failed_tc_count {
    label: "Last Run — Failed TCs"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Failed"
    ]
    drill_fields: [green_drill_details*]
  }

  measure: last_run_blocked_tc_count {
    label: "Last Run — Blocked TCs"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Blocked"
    ]
    drill_fields: [green_drill_details*]
  }

  measure: last_run_not_executed_tc_count {
    label: "Last Run — Not Executed TCs"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Not Executed"
    ]
    drill_fields: [green_drill_details*]
  }

  dimension: formatted_failed_issue_summary {
    hidden: yes
    type: string
    sql:
      CASE
        WHEN ${green_dim_issues.issue_id} IS NOT NULL
          AND ${green_tr_ranked_derived.is_dynamic_last_run}
          AND ${green_tr_ranked_derived.last_run_result} = 'Failed'
        THEN CONCAT(${green_dim_issues.issue_id}, ' (', COALESCE(${green_dim_issues.issue_criticity}, 'NA'), ', ', COALESCE(${green_dim_issues.issue_status}, 'NA'), ')')
        ELSE NULL
      END ;;
  }

  measure: failed_last_run_issues_list {
    label: "Failed Last Run Issues (Concatenated)"
    type: list
    list_field: formatted_failed_issue_summary
  }

  # --- Quality 1/3 & 2/3 Measures ---
  measure: failed_blocked_without_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Without Issue"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Failed, Blocked",
      green_dim_issues.issue_id: "NULL"
    ]
    drill_fields: [green_drill_details*]
  }

  measure: failed_blocked_closed_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Linked to Closed Issue"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Failed, Blocked",
      green_dim_issues.issue_status: "Closed, Verified, Integrated, Invalid"
    ]
    drill_fields: [green_drill_details*]
  }

  measure: failed_blocked_derogated_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Linked to Derogated Issue"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      green_tr_ranked_derived.is_dynamic_last_run: "yes",
      green_tr_ranked_derived.last_run_result: "Failed, Blocked",
      green_dim_issues.issue_status: "Derogated"
    ]
    drill_fields: [green_drill_details*]
  }

  measure: tc_not_in_ts_count {
    label: "Quality 2/3 — TCs Not in a Test Set"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [qua_tc_in_ts: "not in a Test Set"]
    drill_fields: [green_drill_details*]
  }

  measure: tc_not_ready_in_ts_count {
    label: "Quality 2/3 — TCs Not Ready in a Test Set"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [qua_tc_in_ts: "In a Test Set", qua_tc_not_ready: "TC not Ready"]
    drill_fields: [green_drill_details*]
  }
}
