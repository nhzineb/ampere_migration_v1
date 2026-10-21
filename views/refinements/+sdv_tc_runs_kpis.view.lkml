# ==============================================================================
# LAYER 2: CERTIFIED KPI & PARAMETER REFINEMENTS
# (lookml/views/refinements/+sdv_tc_runs_kpis.view.lkml)
# Translates all 38 Spotfire Calculations, OVER/Rank formulas & Document
# Properties from SDV_TC_Runs__Foundation.dxp into governed LookML.
# ==============================================================================

include: "/views/base/sdv_tc_runs_base.view.lkml"

view: +sdv_tc_runs_base {

  # ----------------------------------------------------------------------------
  # 1. Drill Set for Spotfire "Details-on-Demand" Modal Inspection
  # ----------------------------------------------------------------------------
  set: sdv_tc_run_drill_details {
    fields: [
      tc_id,
      tc_name,
      tc_status,
      tc_domain,
      tc_validation_team,
      ts_id,
      ts_vehicle_project,
      ts_milestone,
      tr_id,
      tr_result,
      tr_run_date,
      tr_run_week,
      issue_id,
      issue_status,
      issue_criticity,
      req_id
    ]
  }

  # ----------------------------------------------------------------------------
  # 2. Spotfire Document Properties -> Native LookML Parameters + Liquid
  # ----------------------------------------------------------------------------
  parameter: tr_horizontal_axis_selector {
    label: "Horizontal Axis Selector (Spotfire tr.horizontalAxis)"
    type: unquoted
    default_value: "ts_vehicle_project"
    allowed_value: { label: "Vehicle Project" value: "ts_vehicle_project" }
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TS Domain" value: "ts_domain" }
    allowed_value: { label: "TS Milestone" value: "ts_milestone" }
    allowed_value: { label: "Validation Team" value: "tc_validation_team" }
  }

  dimension: dynamic_horizontal_axis {
    label_from_parameter: tr_horizontal_axis_selector
    type: string
    sql:
      {% if tr_horizontal_axis_selector._parameter_value == 'ts_vehicle_project' %}
        ${ts_vehicle_project}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'ts_domain' %}
        ${ts_domain}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'ts_milestone' %}
        ${ts_milestone}
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
        ${ts_domain}
      {% elsif column_axis_selector._parameter_value == 'tc_status' %}
        ${tc_status}
      {% elsif column_axis_selector._parameter_value == 'tr_result' %}
        ${tr_result}
      {% else %}
        ${ts_vehicle_project}
      {% endif %} ;;
  }

  parameter: rows_axis_selector {
    label: "CrossTable Row Axis (Spotfire RowsAxis)"
    type: unquoted
    default_value: "tc_domain"
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TC Validation Team" value: "tc_validation_team" }
    allowed_value: { label: "TS Milestone" value: "ts_milestone" }
  }

  dimension: dynamic_rows_axis {
    label_from_parameter: rows_axis_selector
    type: string
    sql:
      {% if rows_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif rows_axis_selector._parameter_value == 'tc_validation_team' %}
        ${tc_validation_team}
      {% else %}
        ${ts_milestone}
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
    description: "Replaces Spotfire UniqueCount($esc(${ItemsCount})) on QUALITY 3/3."
    type: number
    sql:
      {% if items_count_selector._parameter_value == 'ts_id' %}
        COUNT(DISTINCT ${ts_id})
      {% elsif items_count_selector._parameter_value == 'tc_id' %}
        COUNT(DISTINCT ${tc_id})
      {% elsif items_count_selector._parameter_value == 'tr_id' %}
        COUNT(DISTINCT ${tr_id})
      {% else %}
        COUNT(DISTINCT ${req_id})
      {% endif %} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # ----------------------------------------------------------------------------
  # 3. Core Hub Measures (Symmetric Aggregates replacing Rank(RowId(),...)=1)
  # ----------------------------------------------------------------------------
  measure: unique_tc_count {
    label: "Total Unique Test Cases (TC)"
    description: "Replaces Spotfire UniqueCount([TC_Id])."
    type: count_distinct
    sql: ${tc_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_tr_count {
    label: "Total Unique Test Runs (TR)"
    description: "Replaces Spotfire UniqueCount([TR_Id])."
    type: count_distinct
    sql: ${tr_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_ts_count {
    label: "Total Unique Test Sets (TS)"
    type: count_distinct
    sql: ${ts_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # ----------------------------------------------------------------------------
  # 4. Page 1 ("TC LAST RUNS Results") Bespoke Spoke Measures
  #    Replaces UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result]='...' then [TC_Id] end)
  # ----------------------------------------------------------------------------
  measure: last_run_total_tc_count {
    label: "Last Run — Total TCs"
    description: "Replaces UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [fact_tc_dynamic_last_run.is_dynamic_last_run: "yes"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_passed_tc_count {
    label: "Last Run — Passed TCs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Passed') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Passed"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_failed_tc_count {
    label: "Last Run — Failed TCs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Failed') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_blocked_tc_count {
    label: "Last Run — Blocked TCs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Blocked') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Blocked"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_not_executed_tc_count {
    label: "Last Run — Not Executed TCs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Not Executed') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Not Executed"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # Replaces Spotfire UniqueConcatenate(Concatenate([Issue_Id],' (',[Issue_Criticity],', ',[Issue_Status],')'))
  dimension: formatted_failed_issue_summary {
    hidden: yes
    type: string
    sql:
      CASE
        WHEN ${issue_id} IS NOT NULL
          AND ${fact_tc_dynamic_last_run.is_dynamic_last_run}
          AND ${fact_tc_dynamic_last_run.last_run_result} = 'Failed'
        THEN CONCAT(${issue_id}, ' (', COALESCE(${issue_criticity}, 'NA'), ', ', COALESCE(${issue_status}, 'NA'), ')')
        ELSE NULL
      END ;;
  }

  measure: failed_last_run_issues_list {
    label: "Failed Last Run Issues (Concatenated)"
    description: "Replaces Spotfire UniqueConcatenate(Concatenate([Issue_Id],' (',[Issue_Criticity],', ',[Issue_Status],')'))."
    type: list
    list_field: formatted_failed_issue_summary
  }

  # ----------------------------------------------------------------------------
  # 5. Page 5 & Page 6 ("QUALITY 1/3" & "QUALITY 2/3") Measures
  # ----------------------------------------------------------------------------
  measure: failed_blocked_without_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Without Issue"
    description: "Replaces Spotfire UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result] in ('Failed','Blocked') and [Issue_Id] is null then [TC_Id] end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked",
      issue_id: "NULL"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: failed_blocked_closed_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Linked to Closed Issue"
    description: "Replaces Spotfire UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result] in ('Failed','Blocked') and [Issue_Status] in ('Closed','Verified','Integrated','Invalid') then [TC_Id] end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked",
      issue_status: "Closed, Verified, Integrated, Invalid"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: failed_blocked_derogated_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Linked to Derogated Issue"
    description: "Replaces Spotfire UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result] in ('Failed','Blocked') and [Issue_Status] in ('Derogated') then [TC_Id] end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked",
      issue_status: "Derogated"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: tc_not_in_ts_count {
    label: "Quality 2/3 — TCs Not in a Test Set"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [qua_tc_in_ts: "not in a Test Set"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: tc_not_ready_in_ts_count {
    label: "Quality 2/3 — TCs Not Ready in a Test Set"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [qua_tc_in_ts: "In a Test Set", qua_tc_not_ready: "TC not Ready"]
    drill_fields: [sdv_tc_run_drill_details*]
  }
}
