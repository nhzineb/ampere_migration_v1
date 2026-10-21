# ==============================================================================
# EXPERIMENT 2 (GREEN LAYER): LAYER 1 BASE VIEWS
# (views/green_layer/green_core_views.view.lkml)
# Sourced from the 7 Green Layer LV2 Bridge & Resolved Attribute Tables:
#   1. TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS
#   2. TBL_from_VW_CB_SDV_Dataset_New_Core_Req_TC_Feature
#   3. TBL_from_VW_CB_SDV_Dataset_New_Core_TC_EngLVL
#   4. TBL_from_VW_CB_SDV_Dataset_New_Core_TC_System
#   5. TBL_from_VW_CB_SDV_Dataset_New_Core_Req_Baseline
#   6. TBL_from_VW_CB_SDV_Dataset_New_Core_Req_MySF
#   7. TBL_from_VW_CB_SDV_Dataset_New_Core_TS_Baseline
# + Dark Green LV8 (TBL_from_VW_CB_SDV_Dataset_New_Core_Merged)
# + LV1 Raw Entity Tables (TC, TS, TR, Req, Issues, TC_AutoRequests)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Base Root Entity View: green_dim_tc (TBL_from_VW_CB_SDV_Dataset_TC — 1 row per TC_Id)
# ------------------------------------------------------------------------------
view: green_dim_tc {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TC` ;;

  dimension: tc_id {
    primary_key: yes
    label: "TC ID"
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
}

# ------------------------------------------------------------------------------
# 2. The 7 Green Layer (LV2) Bridge & Resolved Attribute Views
# ------------------------------------------------------------------------------

# LV2 Green Table 1: TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS (M:N Bridge TC <-> TS)
view: green_bridge_tc_ts {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS` ;;

  dimension: tc_ts_bridge_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.TC_Id AS STRING), '-', COALESCE(CAST(${TABLE}.TS_Id AS STRING), 'NA')) ;;
  }

  dimension: tc_id {
    label: "TC ID (Bridge)"
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: ts_id {
    label: "TS ID (Bridge)"
    type: number
    sql: ${TABLE}.TS_Id ;;
  }

  dimension: system_source {
    label: "Green LV2 — TC-TS System Source"
    type: string
    sql: ${TABLE}.System_Source ;;
  }
}

# LV2 Green Table 2: TBL_from_VW_CB_SDV_Dataset_New_Core_Req_TC_Feature (Bridge Req <-> TC <-> Feature)
view: green_bridge_req_tc_feature {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_Req_TC_Feature` ;;

  dimension: req_tc_feature_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(
      COALESCE(CAST(${TABLE}.Req_Id AS STRING), 'NA'), '-',
      COALESCE(CAST(${TABLE}.TC_Id AS STRING), 'NA'), '-',
      COALESCE(${TABLE}.SDV_Feature_Id, 'NA')
    ) ;;
  }

  dimension: req_id {
    label: "Req ID (Green Bridge)"
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  dimension: tc_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: sdv_feature_id {
    label: "Green LV2 — SDV Feature ID"
    type: string
    sql: ${TABLE}.SDV_Feature_Id ;;
  }

  dimension: feature_source {
    label: "Green LV2 — Feature Source"
    type: string
    sql: ${TABLE}.Feature_Source ;;
  }

  dimension: req_feature_id {
    label: "Green LV2 — Req Feature ID"
    type: string
    sql: ${TABLE}.Req_Feature_Id ;;
  }

  dimension: tc_feature_id {
    label: "Green LV2 — TC Feature ID"
    type: string
    sql: ${TABLE}.TC_Feature_Id ;;
  }
}

# LV2 Green Table 3: TBL_from_VW_CB_SDV_Dataset_New_Core_TC_EngLVL
view: green_tc_eng_lvl {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_EngLVL` ;;

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: tc_engineering_level {
    label: "Green LV2 — TC Engineering Level (Resolved)"
    type: string
    sql: ${TABLE}.TC_Engineering_Level ;;
  }

  dimension: nb_level {
    label: "Green LV2 — Engineering Level Count"
    type: number
    sql: ${TABLE}.nb_Level ;;
  }

  dimension: level_source {
    label: "Green LV2 — Engineering Level Source"
    type: number
    sql: ${TABLE}.Level_Source ;;
  }
}

# LV2 Green Table 4: TBL_from_VW_CB_SDV_Dataset_New_Core_TC_System
view: green_tc_system {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TC_System` ;;

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: tc_system_owner {
    label: "Green LV2 — TC System Owner (Resolved)"
    type: string
    sql: ${TABLE}.TC_System_Owner ;;
  }

  dimension: nb_level {
    label: "Green LV2 — System Owner Count"
    type: number
    sql: ${TABLE}.nb_Level ;;
  }

  dimension: level_source {
    label: "Green LV2 — System Owner Source"
    type: string
    sql: ${TABLE}.Level_Source ;;
  }
}

# LV2 Green Table 5: TBL_from_VW_CB_SDV_Dataset_New_Core_Req_Baseline
view: green_req_baseline {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_Req_Baseline` ;;

  dimension: req_bl_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.Req_Id AS STRING), '-', COALESCE(${TABLE}.BL_Name, 'NA')) ;;
  }

  dimension: req_id {
    hidden: yes
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  dimension: bl_name {
    label: "Green LV2 — Req BL Name"
    type: string
    sql: ${TABLE}.BL_Name ;;
  }

  dimension: req_baseline {
    label: "Green LV2 — Req Baseline (Resolved)"
    type: string
    sql: ${TABLE}.Req_Baseline ;;
  }

  dimension: nb_req_baseline {
    label: "Green LV2 — Nb Req Baseline"
    type: number
    sql: ${TABLE}.nb_Req_Baseline ;;
  }

  dimension: bl_rank {
    label: "Green LV2 — Req BL Rank"
    type: number
    sql: ${TABLE}.BL_Rank ;;
  }
}

# LV2 Green Table 6: TBL_from_VW_CB_SDV_Dataset_New_Core_Req_MySF
view: green_req_mysf {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_Req_MySF` ;;

  dimension: req_mysf_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.Req_Id AS STRING), '-', COALESCE(${TABLE}.MySF_Name, 'NA')) ;;
  }

  dimension: req_id {
    hidden: yes
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  dimension: mysf_name {
    label: "Green LV2 — Req MySF Name"
    type: string
    sql: ${TABLE}.MySF_Name ;;
  }

  dimension: req_mysf {
    label: "Green LV2 — Req MySF (Resolved)"
    type: string
    sql: ${TABLE}.Req_MySF ;;
  }

  dimension: nb_req_mysf {
    label: "Green LV2 — Nb Req MySF"
    type: number
    sql: ${TABLE}.nb_Req_MySF ;;
  }

  dimension: mysf_rank {
    label: "Green LV2 — Req MySF Rank"
    type: number
    sql: ${TABLE}.MySF_Rank ;;
  }
}

# LV2 Green Table 7: TBL_from_VW_CB_SDV_Dataset_New_Core_TS_Baseline
view: green_ts_baseline {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_New_Core_TS_Baseline` ;;

  dimension: ts_bl_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.TS_Id AS STRING), '-', COALESCE(${TABLE}.BL_Name, 'NA')) ;;
  }

  dimension: ts_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TS_Id ;;
  }

  dimension: bl_name {
    label: "Green LV2 — TS BL Name"
    type: string
    sql: ${TABLE}.BL_Name ;;
  }

  dimension: ts_baseline {
    label: "Green LV2 — TS Baseline (Resolved)"
    type: string
    sql: ${TABLE}.TS_Baseline ;;
  }

  dimension: nb_ts_baseline {
    label: "Green LV2 — Nb TS Baseline"
    type: number
    sql: ${TABLE}.nb_TS_Baseline ;;
  }

  dimension: bl_rank {
    label: "Green LV2 — TS BL Rank"
    type: number
    sql: ${TABLE}.BL_Rank ;;
  }
}

# ------------------------------------------------------------------------------
# 3. Supporting LV1 Raw Entity Tables Joined via the Green Layer Bridges
# ------------------------------------------------------------------------------
view: green_dim_ts {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TS` ;;

  dimension: ts_id {
    primary_key: yes
    label: "TS ID"
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

view: green_fact_tr {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TR` ;;

  dimension: tr_id {
    primary_key: yes
    label: "TR ID"
    type: number
    sql: ${TABLE}.TR_Id ;;
  }

  dimension: tc_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TC_ID ;;
  }

  dimension: ts_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TS_ID ;;
  }

  dimension: tr_name {
    label: "TR Name"
    type: string
    sql: ${TABLE}.TR_Name ;;
  }

  dimension: tr_status {
    label: "TR Status"
    type: string
    sql: ${TABLE}.TR_Status ;;
  }

  dimension: tr_result {
    label: "TR Result"
    type: string
    sql: ${TABLE}.TR_Result ;;
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
    label: "Issue CB ID (FK)"
    type: number
    sql: ${TABLE}.Issue_CBId ;;
  }

  dimension: tr_validity {
    label: "TR Validity"
    type: string
    sql: ${TABLE}.TR_Validity ;;
  }
}

view: green_dim_issues {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_Issues` ;;

  dimension: issue_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${TABLE}.Issue_Id, 'NA'), '-', COALESCE(CAST(${TABLE}.codebeamer AS STRING), 'NA')) ;;
  }

  dimension: codebeamer {
    hidden: yes
    type: number
    sql: ${TABLE}.codebeamer ;;
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

  dimension: issue_summary {
    label: "Issue Summary"
    type: string
    sql: ${TABLE}.Issue_Summary ;;
  }
}

view: green_dim_req {
  sql_table_name: `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_Req` ;;

  dimension: req_id {
    primary_key: yes
    label: "Req ID"
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
}

view: green_dim_auto_requests {
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
}

# ------------------------------------------------------------------------------
# 4. Run-Ranking Derived Table Required at the Green Layer (Recomputing First/Last Run)
#    Because LV2 Green tables do not yet have isFirstRun / isLastRun / Admin_Rank,
#    this Derived Table computes them from TBL_from_VW_CB_SDV_Dataset_TR.
# ------------------------------------------------------------------------------
view: green_tr_ranked_derived {
  derived_table: {
    sql:
      SELECT
        tr.TR_Id AS tr_id,
        tr.TC_ID AS tc_id,
        tr.TS_ID AS ts_id,
        tr.TR_Result AS tr_result,
        tr.TR_RunWeek AS tr_run_week,
        ROW_NUMBER() OVER (
          PARTITION BY tr.TC_ID
          ORDER BY COALESCE(tr.TR_RunDate, DATETIME('9999-12-31 00:00:00')) ASC
        ) = 1 AS is_first_run,
        ROW_NUMBER() OVER (
          PARTITION BY tr.TC_ID
          ORDER BY
            CASE WHEN tr.TR_Result IN ('Passed', 'Failed', 'Blocked') THEN 0 ELSE 1 END ASC,
            COALESCE(tr.TR_RunDate, DATETIME('0001-01-01 00:00:00')) DESC
        ) = 1 AS is_dynamic_last_run
      FROM `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TR` AS tr
      LEFT JOIN `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TC` AS tc
        ON tr.TC_ID = tc.TC_Id
      LEFT JOIN `@{gcp_project}.@{bq_dataset}.TBL_from_VW_CB_SDV_Dataset_TS` AS ts
        ON tr.TS_ID = ts.TS_Id
      WHERE {% condition green_fact_tr.tr_run_date %} tr.TR_RunDate {% endcondition %}
        AND {% condition green_dim_ts.ts_vehicle_project %} ts.TS_Vehicle_Project {% endcondition %}
        AND {% condition green_dim_tc.tc_domain %} tc.TC_Domain {% endcondition %} ;;
  }

  dimension: tr_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.tr_id ;;
  }

  dimension: tc_id {
    hidden: yes
    type: number
    sql: ${TABLE}.tc_id ;;
  }

  dimension: last_run_tr_id {
    label: "Green Computed Last Run TR ID"
    type: number
    sql: CASE WHEN ${TABLE}.is_dynamic_last_run THEN ${TABLE}.tr_id ELSE NULL END ;;
  }

  dimension: last_run_result {
    label: "Green Computed Last Run Result"
    type: string
    sql: CASE WHEN ${TABLE}.is_dynamic_last_run THEN ${TABLE}.tr_result ELSE NULL END ;;
  }

  dimension: last_run_week {
    label: "Green Computed Last Run Week"
    type: string
    sql: CASE WHEN ${TABLE}.is_dynamic_last_run THEN ${TABLE}.tr_run_week ELSE NULL END ;;
  }

  dimension: is_first_run {
    label: "Is First Run (Computed from Green/LV1 TR)"
    type: yesno
    sql: ${TABLE}.is_first_run ;;
  }

  dimension: is_dynamic_last_run {
    label: "Is Dynamic Last Run (Rank=1 Computed from Green/LV1 TR)"
    type: yesno
    sql: ${TABLE}.is_dynamic_last_run ;;
  }
}
