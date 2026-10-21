# ==============================================================================
# LAYER 1: BASE VIEWS (lookml/views/base/sdv_tc_runs_base.view.lkml)
# Generated from Spotfire workbook: SDV_TC_Runs__Foundation.dxp (63 columns)
# ==============================================================================

view: sdv_tc_runs_base {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Spotfire_New_TC_Runs` ;;

  # Verified Unique Primary Key (prevents fanout via Looker Symmetric Aggregates)
  dimension: tc_run_grain_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.tc_run_grain_pk ;;
  }

  # --- Test Case (TC) Core Dimensions ---
  dimension: tc_id {
    label: "TC ID"
    type: string
    sql: ${TABLE}.tc_id ;;
  }

  dimension: tc_name {
    label: "TC Name"
    type: string
    sql: ${TABLE}.tc_name ;;
  }

  dimension: tc_status {
    label: "TC Status"
    type: string
    sql: ${TABLE}.tc_status ;;
  }

  dimension: tc_type {
    label: "TC Type"
    type: string
    sql: ${TABLE}.tc_type ;;
  }

  dimension: tc_domain {
    label: "TC Domain"
    type: string
    sql: ${TABLE}.tc_domain ;;
  }

  dimension: tc_execution_organization {
    label: "TC Execution Organization"
    type: string
    sql: ${TABLE}.tc_execution_organization ;;
  }

  dimension: tc_validation_team {
    label: "TC Validation Team"
    type: string
    sql: ${TABLE}.tc_validation_team ;;
  }

  dimension: tc_validation_leader {
    label: "TC Validation Leader"
    type: string
    sql: ${TABLE}.tc_validation_leader ;;
  }

  dimension: tc_engineering_level {
    label: "TC Engineering Level"
    type: string
    sql: ${TABLE}.tc_engineering_level ;;
  }

  dimension: tc_system_owner {
    label: "TC System Owner"
    type: string
    sql: ${TABLE}.tc_system_owner ;;
  }

  dimension: tc_cb_project_name {
    label: "TC Codebeamer Project"
    type: string
    sql: ${TABLE}.tc_cb_project_name ;;
  }

  dimension: tc_dut {
    label: "TC DUT"
    type: string
    sql: ${TABLE}.tc_dut ;;
  }

  dimension: tc_additional_information {
    label: "TC Additional Information"
    type: string
    sql: ${TABLE}.tc_additional_information ;;
  }

  dimension: automation_id {
    label: "Automation ID"
    type: string
    sql: ${TABLE}.automation_id ;;
  }

  # Hidden raw ARRAY<STRING> columns for on-demand LEFT JOIN UNNEST in Explore
  dimension: tc_feature_raw {
    hidden: yes
    sql: ${TABLE}.tc_feature_raw ;;
  }

  dimension: tc_bench_type_raw {
    hidden: yes
    sql: ${TABLE}.tc_bench_type_raw ;;
  }

  dimension: sweet_raw {
    hidden: yes
    sql: ${TABLE}.sweet_raw ;;
  }

  # --- Test Set (TS) Dimensions ---
  dimension: ts_id {
    label: "TS ID"
    type: string
    sql: ${TABLE}.ts_id ;;
  }

  dimension: ts_baseline {
    label: "TS Baseline"
    type: string
    sql: ${TABLE}.ts_baseline ;;
  }

  dimension: ts_status {
    label: "TS Status"
    type: string
    sql: ${TABLE}.ts_status ;;
  }

  dimension: ts_domain {
    label: "TS Domain"
    type: string
    sql: ${TABLE}.ts_domain ;;
  }

  dimension: ts_validation_team {
    label: "TS Validation Team"
    type: string
    sql: ${TABLE}.ts_validation_team ;;
  }

  dimension: ts_vehicle_project {
    label: "TS Vehicle Project"
    type: string
    sql: ${TABLE}.ts_vehicle_project ;;
  }

  dimension: ts_type {
    label: "TS Type"
    type: string
    sql: ${TABLE}.ts_type ;;
  }

  dimension: ts_isp_id {
    label: "TS ISP ID"
    type: string
    sql: ${TABLE}.ts_isp_id ;;
  }

  dimension: ts_milestone {
    label: "TS Milestone"
    type: string
    sql: ${TABLE}.ts_milestone ;;
  }

  dimension: valid_baseline {
    label: "Valid Baseline"
    type: string
    sql: ${TABLE}.valid_baseline ;;
  }

  dimension: ts_pcu_releases {
    label: "TS PCU Releases"
    type: string
    sql: ${TABLE}.ts_pcu_releases ;;
  }

  dimension: ts_piu_releases {
    label: "TS PIU Releases"
    type: string
    sql: ${TABLE}.ts_piu_releases ;;
  }

  dimension: ts_ivc_releases {
    label: "TS IVC Releases"
    type: string
    sql: ${TABLE}.ts_ivc_releases ;;
  }

  dimension: ts_cdc_releases {
    label: "TS CDC Releases"
    type: string
    sql: ${TABLE}.ts_cdc_releases ;;
  }

  dimension: ts_other_releases {
    label: "TS Other Releases"
    type: string
    sql: ${TABLE}.ts_other_releases ;;
  }

  # --- Test Run (TR) Dimensions ---
  dimension: tr_id {
    label: "TR ID"
    type: string
    sql: ${TABLE}.tr_id ;;
  }

  dimension: tr_result {
    label: "TR Result"
    type: string
    sql: ${TABLE}.tr_result ;;
  }

  dimension: tr_run_week {
    label: "TR Run Week"
    type: string
    sql: ${TABLE}.tr_run_week ;;
  }

  dimension: tr_relevant_status {
    label: "TR Relevant Status"
    type: number
    sql: ${TABLE}.tr_relevant_status ;;
  }

  dimension: tr_relevant_run {
    label: "TR Relevant Run"
    type: string
    sql: ${TABLE}.tr_relevant_run ;;
  }

  dimension: tr_last_relevant {
    label: "TR Last Relevant"
    type: string
    sql: ${TABLE}.tr_last_relevant ;;
  }

  dimension_group: tr_run {
    label: "TR Run"
    type: time
    timeframes: [raw, date, month, quarter, year]
    sql: ${TABLE}.tr_run_date ;;
  }

  dimension_group: tr_last_run {
    label: "TR Last Run"
    type: time
    timeframes: [raw, date, week, month, year]
    sql: ${TABLE}.tr_last_run_date ;;
  }

  dimension: tr_regression {
    label: "TR Regression"
    type: string
    sql: ${TABLE}.tr_regression ;;
  }

  dimension: is_first_run {
    label: "Is First Run"
    type: yesno
    sql: ${TABLE}.is_first_run ;;
  }

  # --- Requirement (Req) & Issue Dimensions ---
  dimension: req_id {
    label: "Requirement ID"
    type: string
    sql: ${TABLE}.req_id ;;
  }

  dimension: req_mysf {
    label: "Req MySF"
    type: string
    sql: ${TABLE}.req_mysf ;;
  }

  dimension: req_asil {
    label: "Req ASIL"
    type: string
    sql: ${TABLE}.req_asil ;;
  }

  dimension: req_safety_related {
    label: "Req Safety Related"
    type: string
    sql: ${TABLE}.req_safety_related ;;
  }

  dimension: req_validation_methods {
    label: "Req Validation Methods"
    type: string
    sql: ${TABLE}.req_validation_methods ;;
  }

  dimension: req_requirement_category {
    label: "Req Category"
    type: string
    sql: ${TABLE}.req_requirement_category ;;
  }

  dimension: req_supplier {
    label: "Req Supplier"
    type: string
    sql: ${TABLE}.req_supplier ;;
  }

  dimension: req_baseline {
    label: "Req Baseline"
    type: string
    sql: ${TABLE}.req_baseline ;;
  }

  dimension: req_regulation {
    label: "Req Regulation"
    type: string
    sql: ${TABLE}.req_regulation ;;
  }

  dimension: issue_cb_id {
    label: "Issue CB ID"
    type: string
    sql: ${TABLE}.issue_cb_id ;;
  }

  dimension: issue_id {
    label: "Issue ID"
    type: string
    sql: ${TABLE}.issue_id ;;
  }

  dimension: issue_status {
    label: "Issue Status"
    type: string
    sql: ${TABLE}.issue_status ;;
  }

  dimension: issue_criticity {
    label: "Issue Criticity"
    type: string
    sql: ${TABLE}.issue_criticity ;;
  }

  dimension: issue_resolution {
    label: "Issue Resolution"
    type: string
    sql: ${TABLE}.issue_resolution ;;
  }

  dimension: issue_fix_version {
    label: "Issue Fix Version"
    type: string
    sql: ${TABLE}.issue_fix_version ;;
  }

  # --- Pre-Computed Dataform Columns from Spotfire Calculated Columns ---
  dimension: admin_rank {
    label: "Admin Rank (Spotfire Last Run Rank)"
    type: number
    sql: ${TABLE}.admin_rank ;;
  }

  dimension: qua_tc_in_ts {
    label: "QUA TC in TS"
    type: string
    sql: ${TABLE}.qua_tc_in_ts ;;
  }

  dimension: qua_tc_not_ready {
    label: "QUA TC Not Ready"
    type: string
    sql: ${TABLE}.qua_tc_not_ready ;;
  }

  dimension: qua_tr_without_issues {
    label: "QUA TR Without Issues"
    type: string
    sql: ${TABLE}.qua_tr_without_issues ;;
  }

  dimension: auto_ts_runs {
    label: "Auto TS Runs"
    type: string
    sql: ${TABLE}.auto_ts_runs ;;
  }
}

# ==============================================================================
# DYNAMIC LAST-RUN DEDUPLICATION VIEW (Replaces Rank([Admin_Rank],[TC_Id]) = 1)
# Dynamically evaluates the #1 ranked run per TC_Id within the user's active
# date/project/domain filters using BigQuery QUALIFY ROW_NUMBER().
# ==============================================================================
view: fact_tc_dynamic_last_run {
  derived_table: {
    sql:
      SELECT
        tc_id,
        tr_id AS last_run_tr_id,
        ts_id AS last_run_ts_id,
        tr_result AS last_run_result,
        tr_run_date AS last_run_date,
        tr_run_week AS last_run_week,
        admin_rank,
        TRUE AS is_dynamic_last_run
      FROM `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Spotfire_New_TC_Runs`
      WHERE {% condition sdv_tc_runs_base.tr_run_date %} tr_run_date {% endcondition %}
        AND {% condition sdv_tc_runs_base.ts_vehicle_project %} ts_vehicle_project {% endcondition %}
        AND {% condition sdv_tc_runs_base.tc_domain %} tc_domain {% endcondition %}
        AND {% condition sdv_tc_runs_base.ts_milestone %} ts_milestone {% endcondition %}
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY tc_id
        ORDER BY admin_rank ASC, tr_run_date DESC
      ) = 1 ;;
  }

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.tc_id ;;
  }

  dimension: last_run_tr_id {
    label: "Dynamic Last Run TR ID"
    type: string
    sql: ${TABLE}.last_run_tr_id ;;
  }

  dimension: last_run_result {
    label: "Dynamic Last Run Result"
    type: string
    sql: ${TABLE}.last_run_result ;;
  }

  dimension: last_run_week {
    label: "Dynamic Last Run Week"
    type: string
    sql: ${TABLE}.last_run_week ;;
  }

  dimension: is_dynamic_last_run {
    label: "Is Dynamic Last Run (Rank=1)"
    type: yesno
    sql: ${TABLE}.is_dynamic_last_run ;;
  }
}

# Virtual views for on-demand LEFT JOIN UNNEST of multi-valued array columns
view: tc_feature_unnest {
  dimension: tc_feature_item {
    primary_key: yes
    label: "TC Feature (Unnested)"
    type: string
    sql: tc_feature_item ;;
  }
}

view: tc_bench_type_unnest {
  dimension: tc_bench_type_item {
    primary_key: yes
    label: "TC Bench Type (Unnested)"
    type: string
    sql: tc_bench_type_item ;;
  }
}

view: sweet_unnest {
  dimension: sweet_milestone {
    primary_key: yes
    label: "SWEET Milestone (Unnested)"
    type: string
    sql: sweet_milestone ;;
  }
}
