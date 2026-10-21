# ==============================================================================
# EXPERIMENT 1 (YELLOW LAYER): LAYER 1 BASE VIEWS
# (views/yellow_layer/yellow_core_views.view.lkml)
# Sourced from Yellow Layer LV7 (TBL_from_VW_CB_SDV_Dataset_New_Core_Init)
# + 4 Yellow Layer LV5 Helper Tables (AlreadyInTS, Nb_FixVersions, nbIssuesClosed, nbIssuesInvalid)
# + Supporting LV1 Entity Dimension Tables (TC, TS, Req, TC_AutoRequests)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Yellow Layer LV7 Core Fact Table: TBL_from_VW_CB_SDV_Dataset_New_Core_Init (34 cols)
# ------------------------------------------------------------------------------
view: yellow_core_init {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_Init` ;;

  dimension: yellow_core_grain_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(
      CAST(${TABLE}.TC_Id AS STRING), '-',
      COALESCE(CAST(${TABLE}.TS_Id AS STRING), 'NA'), '-',
      COALESCE(CAST(${TABLE}.TR_Id AS STRING), 'NA'), '-',
      COALESCE(CAST(${TABLE}.Req_Id AS STRING), 'NA'), '-',
      COALESCE(${TABLE}.Issue_Id, 'NA')
    ) ;;
  }

  dimension: analyse {
    label: "Analyse"
    type: string
    sql: ${TABLE}.analyse ;;
  }

  dimension: req_id {
    label: "Requirement ID (FK)"
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  dimension: req_baseline {
    label: "Req Baseline (Core Init)"
    type: string
    sql: ${TABLE}.Req_Baseline ;;
  }

  dimension: nb_req_baseline {
    label: "Nb Req Baseline"
    type: number
    sql: ${TABLE}.nb_Req_Baseline ;;
  }

  dimension: sdv_baseline {
    label: "SDV Baseline"
    type: string
    sql: ${TABLE}.SDV_Baseline ;;
  }

  dimension: tc_id {
    label: "TC ID (FK)"
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: valid_baseline {
    label: "Valid Baseline"
    type: string
    sql: ${TABLE}.Valid_Baseline ;;
  }

  dimension: nb_valid_baseline {
    label: "Nb Valid Baseline"
    type: number
    sql: ${TABLE}.nb_Valid_Baseline ;;
  }

  dimension: ts_id {
    label: "TS ID (FK)"
    type: number
    sql: ${TABLE}.TS_Id ;;
  }

  dimension: tr_id {
    label: "TR ID"
    type: number
    sql: ${TABLE}.TR_Id ;;
  }

  dimension: tr_tracker_id {
    label: "TR Tracker ID"
    type: number
    sql: ${TABLE}.TR_Tracker_Id ;;
  }

  dimension_group: tr_run {
    label: "TR Run"
    type: time
    datatype: datetime
    timeframes: [raw, date, month, quarter, year]
    sql: ${TABLE}.TR_RunDate ;;
  }

  dimension: tr_last_run_date {
    label: "TR Last Run Date"
    type: string
    sql: ${TABLE}.TR_LastRunDate ;;
  }

  dimension: tr_run_week {
    label: "TR Run Week"
    type: string
    sql: ${TABLE}.TR_RunWeek ;;
  }

  dimension: issue_cb_id {
    label: "Issue CB ID"
    type: number
    sql: ${TABLE}.Issue_CBId ;;
  }

  dimension: tr_result {
    label: "TR Result"
    type: string
    sql: ${TABLE}.TR_Result ;;
  }

  dimension: tr_relevant_status {
    label: "TR Relevant Status"
    type: number
    sql: ${TABLE}.TR_Relevant_Status ;;
  }

  dimension: tr_first_relevant_status {
    label: "TR First Relevant Status"
    type: number
    sql: ${TABLE}.TR_First_Relevant_Status ;;
  }

  dimension: tr_last_relevant {
    label: "TR Last Relevant"
    type: string
    sql: ${TABLE}.TR_LastRevelant ;;
  }

  dimension: tr_relevant_run {
    label: "TR Relevant Run"
    type: number
    sql: ${TABLE}.TR_Relevant_Run ;;
  }

  dimension: tr_last_relevant_before {
    label: "TR Last Relevant Before"
    type: string
    sql: ${TABLE}.TR_LastRevelantBefore ;;
  }

  dimension: is_last_run {
    label: "Is Last Run (Pre-Computed Yellow Layer)"
    type: yesno
    sql: ${TABLE}.isLastRun ;;
  }

  dimension: is_first_run {
    label: "Is First Run (Pre-Computed Yellow Layer)"
    type: yesno
    sql: ${TABLE}.isFirstRun ;;
  }

  dimension: issue_id {
    label: "Issue ID"
    type: string
    sql: ${TABLE}.Issue_Id ;;
  }

  dimension: issue_status {
    label: "Issue Status"
    type: string
    sql: ${TABLE}.Issue_Status ;;
  }

  dimension: issue_criticity {
    label: "Issue Criticity"
    type: string
    sql: ${TABLE}.Issue_Criticity ;;
  }

  dimension: issue_resolution {
    label: "Issue Resolution"
    type: string
    sql: ${TABLE}.Issue_Resolution ;;
  }

  dimension: issue_fix_version {
    label: "Issue Fix Version"
    type: string
    sql: ${TABLE}.Issue_Fix_Version ;;
  }

  dimension: tr_nb_issues_invalid {
    label: "TR Nb Issues Invalid (Inlined)"
    type: number
    sql: ${TABLE}.TR_nbIssuesInvalid ;;
  }

  dimension: tr_nb_issues_closed {
    label: "TR Nb Issues Closed (Inlined)"
    type: number
    sql: ${TABLE}.TR_nbIssuesClosed ;;
  }

  dimension: tr_regression {
    label: "TR Regression"
    type: string
    sql: ${TABLE}.TR_Regression ;;
  }

  dimension: tc_already_in_ts {
    label: "TC Already In TS (Inlined)"
    type: string
    sql: ${TABLE}.TC_AlreadyInTS ;;
  }

  dimension: tc_nb_fix_versions {
    label: "TC Nb Fix Versions (Inlined)"
    type: number
    sql: ${TABLE}.TC_Nb_FixVersions ;;
  }

  dimension: tc_nb_regressions {
    label: "TC Nb Regressions"
    type: number
    sql: ${TABLE}.TC_nbRegressions ;;
  }
}

# ------------------------------------------------------------------------------
# 2. Yellow Layer LV5 Helper Tables (4 Pre-Aggregated KPI Views)
# ------------------------------------------------------------------------------
view: yellow_tc_already_in_ts {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS_TR_AlreadyInTS` ;;

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: tc_already_in_ts {
    label: "LV5 — TC Already in TS"
    type: string
    sql: ${TABLE}.TC_AlreadyInTS ;;
  }
}

view: yellow_tc_nb_fix_versions {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS_TR_Nb_FixVersions` ;;

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: tc_nb_fix_versions {
    label: "LV5 — TC Nb Fix Versions"
    type: number
    sql: ${TABLE}.TC_Nb_FixVersions ;;
  }
}

view: yellow_tr_nb_issues_closed {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS_TR_nbIssuesClosed` ;;

  dimension: tr_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TR_Id ;;
  }

  dimension: tr_nb_issues_closed {
    label: "LV5 — TR Nb Issues Closed"
    type: number
    sql: ${TABLE}.TR_nbIssuesClosed ;;
  }
}

view: yellow_tr_nb_issues_invalid {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS_TR_nbIssuesInvalid` ;;

  dimension: tr_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TR_Id ;;
  }

  dimension: tr_nb_issues_invalid {
    label: "LV5 — TR Nb Issues Invalid"
    type: number
    sql: ${TABLE}.TR_nbIssuesInvalid ;;
  }
}

# ------------------------------------------------------------------------------
# 3. Supporting LV1 Entity Dimension Views (Joined in Yellow Layer Star Schema)
# ------------------------------------------------------------------------------
view: yellow_dim_tc {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TC` ;;

  dimension: tc_id {
    primary_key: yes
    label: "TC ID (Dim)"
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: tc_name {
    label: "TC Name"
    type: string
    sql: ${TABLE}.TC_Name ;;
  }

  dimension: tc_status {
    label: "TC Status"
    type: string
    sql: ${TABLE}.TC_Status ;;
  }

  dimension: tc_type {
    label: "TC Type"
    type: string
    sql: ${TABLE}.TC_Type ;;
  }

  dimension: tc_domain {
    label: "TC Domain"
    type: string
    sql: ${TABLE}.TC_Domain ;;
  }

  dimension: tc_sub_domain {
    label: "TC Sub-Domain"
    type: string
    sql: ${TABLE}.TC_Sub_Domain ;;
  }

  dimension: tc_execution_organization {
    label: "TC Execution Organization"
    type: string
    sql: ${TABLE}.TC_Execution_Organization ;;
  }

  dimension: tc_validation_team {
    label: "TC Validation Team"
    type: string
    sql: ${TABLE}.TC_Validation_Team ;;
  }

  dimension: tc_validation_leader {
    label: "TC Validation Leader"
    type: string
    sql: ${TABLE}.TC_Validation_Leader ;;
  }

  dimension: tc_domain_leader {
    label: "TC Domain Leader"
    type: string
    sql: ${TABLE}.TC_Domain_Leader ;;
  }

  dimension: tc_engineering_level {
    label: "TC Engineering Level"
    type: string
    sql: ${TABLE}.TC_Engineering_Level ;;
  }

  dimension: tc_system_owner {
    label: "TC System Owner"
    type: string
    sql: ${TABLE}.TC_System_Owner ;;
  }

  dimension: tc_cb_project_name {
    label: "TC Codebeamer Project"
    type: string
    sql: ${TABLE}.TC_CBProjectName ;;
  }

  dimension: tc_bench_type {
    label: "TC Bench Type"
    type: string
    sql: ${TABLE}.TC_Bench_Type ;;
  }

  dimension: tc_items_under_test {
    label: "TC Items Under Test (DUT)"
    type: string
    sql: ${TABLE}.TC_Items_Under_Test ;;
  }

  dimension: tc_feature {
    label: "TC Feature"
    type: string
    sql: ${TABLE}.TC_Feature ;;
  }

  dimension: tc_sweet {
    label: "TC SWEET"
    type: string
    sql: ${TABLE}.TC_SWEET ;;
  }

  dimension: tc_brand_raw {
    hidden: yes
    sql: ${TABLE}.TC_Brand ;;
  }
}

view: yellow_dim_ts {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TS` ;;

  dimension: ts_id {
    primary_key: yes
    label: "TS ID (Dim)"
    type: number
    sql: ${TABLE}.TS_Id ;;
  }

  dimension: ts_name {
    label: "TS Name"
    type: string
    sql: ${TABLE}.TS_Name ;;
  }

  dimension: ts_status {
    label: "TS Status"
    type: string
    sql: ${TABLE}.TS_Status ;;
  }

  dimension: ts_domain {
    label: "TS Domain"
    type: string
    sql: ${TABLE}.TS_Domain ;;
  }

  dimension: ts_validation_team {
    label: "TS Validation Team"
    type: string
    sql: ${TABLE}.TS_Validation_Team ;;
  }

  dimension: ts_vehicle_project {
    label: "TS Vehicle Project"
    type: string
    sql: ${TABLE}.TS_Vehicle_Project ;;
  }

  dimension: ts_type {
    label: "TS Type"
    type: string
    sql: ${TABLE}.TS_Type ;;
  }

  dimension: ts_isp_id {
    label: "TS ISP ID"
    type: number
    sql: ${TABLE}.TS_ISP_Id ;;
  }

  dimension: ts_planned_for {
    label: "TS Planned For (Milestone)"
    type: number
    sql: ${TABLE}.TS_PlannedFor ;;
  }

  dimension: ts_mysf {
    label: "TS MySF"
    type: string
    sql: ${TABLE}.TS_MySF ;;
  }

  dimension: ts_pcu_releases {
    label: "TS PCU Releases"
    type: string
    sql: ${TABLE}.TS_PCU_Releases ;;
  }

  dimension: ts_piu_releases {
    label: "TS PIU Releases"
    type: string
    sql: ${TABLE}.TS_PIU_Releases ;;
  }

  dimension: ts_ivc_releases {
    label: "TS IVC Releases"
    type: string
    sql: ${TABLE}.TS_IVC_Releases ;;
  }

  dimension: ts_cdc_releases {
    label: "TS CDC Releases"
    type: string
    sql: ${TABLE}.TS_CDC_Releases ;;
  }

  dimension: ts_other_releases {
    label: "TS Other Releases"
    type: string
    sql: ${TABLE}.TS_Other_Releases ;;
  }
}

view: yellow_dim_req {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_Req` ;;

  dimension: req_id {
    primary_key: yes
    label: "Req ID (Dim)"
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  dimension: req_name {
    label: "Req Name"
    type: string
    sql: ${TABLE}.Req_Name ;;
  }

  dimension: req_asil {
    label: "Req ASIL"
    type: string
    sql: ${TABLE}.Req_ASIL ;;
  }

  dimension: req_safety_related {
    label: "Req Safety Related"
    type: string
    sql: ${TABLE}.Req_Safety_Related ;;
  }

  dimension: req_regulation {
    label: "Req Regulation"
    type: string
    sql: ${TABLE}.Req_Regulation ;;
  }

  dimension: req_validation_methods {
    label: "Req Validation Methods"
    type: string
    sql: ${TABLE}.Req_ValidationMethods ;;
  }

  dimension: req_requirement_category {
    label: "Req Requirement Category"
    type: string
    sql: ${TABLE}.Req_RequirementCategory ;;
  }

  dimension: req_supplier {
    label: "Req Supplier"
    type: string
    sql: ${TABLE}.Req_Supplier ;;
  }

  dimension: req_mysf_name {
    label: "Req MySF Name"
    type: string
    sql: ${TABLE}.Req_MySF_Name ;;
  }
}

view: yellow_dim_auto_requests {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TC_AutoRequests` ;;

  dimension: automation_id {
    primary_key: yes
    label: "Automation ID"
    type: number
    sql: ${TABLE}.Automation_Id ;;
  }

  dimension: automation_tc_id {
    hidden: yes
    type: number
    sql: ${TABLE}.Automation_TC_Id ;;
  }

  dimension: automation_name {
    label: "Automation Name"
    type: string
    sql: ${TABLE}.Automation_Name ;;
  }

  dimension: automation_status {
    label: "Automation Status"
    type: string
    sql: ${TABLE}.Automation_Status ;;
  }

  dimension: automation_bench_type {
    label: "Automation Bench Type"
    type: string
    sql: ${TABLE}.Automation_Bench_Type ;;
  }

  dimension: automation_framework {
    label: "Automation Framework"
    type: string
    sql: ${TABLE}.Automation_Framework ;;
  }
}

# ------------------------------------------------------------------------------
# 4. Filter-Aware Dynamic Last Run Derived Table on Yellow Layer
# ------------------------------------------------------------------------------
view: yellow_dynamic_last_run {
  derived_table: {
    sql:
      SELECT
        y.TC_Id AS tc_id,
        y.TR_Id AS last_run_tr_id,
        y.TS_Id AS last_run_ts_id,
        y.TR_Result AS last_run_result,
        y.TR_RunDate AS last_run_date,
        y.TR_RunWeek AS last_run_week,
        TRUE AS is_dynamic_last_run
      FROM `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_Init` AS y
      LEFT JOIN `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TC` AS tc
        ON y.TC_Id = tc.TC_Id
      LEFT JOIN `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TS` AS ts
        ON y.TS_Id = ts.TS_Id
      WHERE {% condition yellow_core_init.tr_run_date %} y.TR_RunDate {% endcondition %}
        AND {% condition yellow_dim_ts.ts_vehicle_project %} ts.TS_Vehicle_Project {% endcondition %}
        AND {% condition yellow_dim_tc.tc_domain %} tc.TC_Domain {% endcondition %}
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY y.TC_Id
        ORDER BY
          CASE WHEN IFNULL(y.TR_Relevant_Status, 0) = 0 THEN 1 ELSE 0 END ASC,
          COALESCE(y.TR_RunDate, DATETIME('0001-01-01 00:00:00')) DESC
      ) = 1 ;;
  }

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.tc_id ;;
  }

  dimension: last_run_tr_id {
    label: "Dynamic Last Run TR ID"
    type: number
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
