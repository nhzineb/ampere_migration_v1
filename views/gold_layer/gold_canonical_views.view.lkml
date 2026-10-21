# ==============================================================================
# BASE VIEWS: gold_canonical_views.view.lkml
# Gold Canonical Architecture (4 Enriched Dimensions + 2 Decoupled Facts + 1 Bridge)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. GOLD_DIM_REQUIREMENT (PK: Req_Id — 1 row per Requirement)
# ------------------------------------------------------------------------------
view: gold_dim_requirement {
  sql_table_name: `ampere_sdv_ivv.gold_dim_requirement` ;;
  label: "Requirement (Canonical Dimension)"

  dimension: req_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.Req_Id ;;
    label: "Requirement ID"
    description: "Unique Codebeamer Requirement identifier (1 row per Req_Id)"
  }

  dimension: req_name {
    type: string
    sql: ${TABLE}.Req_Name ;;
    label: "Requirement Name"
  }

  dimension: req_type {
    type: string
    sql: ${TABLE}.Req_Type ;;
    label: "Requirement Type"
  }

  dimension: req_status {
    type: string
    sql: ${TABLE}.Req_Status ;;
    label: "Requirement Status"
  }

  dimension: req_final_status {
    type: string
    sql: ${TABLE}.Req_FinalStatus ;;
    label: "Requirement Final Status"
  }

  dimension: req_tracker {
    type: string
    sql: ${TABLE}.Req_Tracker ;;
    label: "Requirement Tracker"
  }

  dimension: req_domain {
    type: string
    sql: ${TABLE}.Req_Domain ;;
    label: "Requirement Domain"
  }

  dimension: req_sub_domain {
    type: string
    sql: ${TABLE}.Req_Sub_Domain ;;
    label: "Requirement Sub-Domain"
  }

  dimension: req_system_owner {
    type: string
    sql: ${TABLE}.Req_System_Owner ;;
    label: "Requirement System Owner"
  }

  dimension: req_engineering_level {
    type: string
    sql: ${TABLE}.Req_Engineering_Level ;;
    label: "Requirement Engineering Level"
  }

  dimension: req_asil {
    type: string
    sql: ${TABLE}.Req_ASIL ;;
    label: "Requirement ASIL"
  }

  dimension: req_safety_related {
    type: string
    sql: ${TABLE}.Req_Safety_Related ;;
    label: "Requirement Safety Related"
  }

  dimension: req_regulation {
    type: string
    sql: ${TABLE}.Req_Regulation ;;
    label: "Requirement Regulation"
  }

  dimension: req_cyber {
    type: string
    sql: ${TABLE}.Req_Cyber ;;
    label: "Requirement Cyber"
  }

  dimension: req_validation_methods {
    type: string
    sql: ${TABLE}.Req_ValidationMethods ;;
    label: "Requirement Validation Methods"
  }

  dimension: req_requirement_category {
    type: string
    sql: ${TABLE}.Req_RequirementCategory ;;
    label: "Requirement Category"
  }

  dimension: req_supplier {
    type: string
    sql: ${TABLE}.Req_Supplier ;;
    label: "Requirement Supplier"
  }

  dimension: req_vehicle_project {
    type: string
    sql: ${TABLE}.Req_Vehicle_Project ;;
    label: "Requirement Vehicle Project"
  }

  dimension: req_baseline {
    type: string
    sql: ${TABLE}.Req_Baseline ;;
    label: "Requirement Baseline (Resolved LV2)"
    description: "Authoritative Requirement Baseline resolved from LV2 New_Core_Req_Baseline"
  }

  dimension: req_mysf {
    type: string
    sql: ${TABLE}.Req_MySF ;;
    label: "Requirement MySF (Resolved LV2)"
    description: "Authoritative My System/Software Function (MySF) resolved from LV2 New_Core_Req_MySF"
  }

  dimension: req_mysf_name {
    type: string
    sql: ${TABLE}.Req_MySF_Name ;;
    label: "Requirement MySF Name"
  }

  dimension: is_false_req {
    type: yesno
    sql: ${TABLE}.is_false_req ;;
    label: "Is False Requirement?"
  }
}

# ------------------------------------------------------------------------------
# 2. GOLD_DIM_TEST_CASE (PK: TC_Id — 1 row per Test Case)
# ------------------------------------------------------------------------------
view: gold_dim_test_case {
  sql_table_name: `ampere_sdv_ivv.gold_dim_test_case` ;;
  label: "Test Case (Canonical Dimension)"

  dimension: tc_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
    label: "Test Case ID"
    description: "Unique Codebeamer Test Case identifier (1 row per TC_Id)"
  }

  dimension: tc_uid {
    type: string
    sql: ${TABLE}.TC_UID ;;
    label: "Test Case UID"
  }

  dimension: tc_name {
    type: string
    sql: ${TABLE}.TC_Name ;;
    label: "Test Case Name"
  }

  dimension: tc_type {
    type: string
    sql: ${TABLE}.TC_Type ;;
    label: "Test Case Type"
  }

  dimension: tc_status {
    type: string
    sql: ${TABLE}.TC_Status ;;
    label: "Test Case Status"
  }

  dimension: tc_domain {
    type: string
    sql: ${TABLE}.TC_Domain ;;
    label: "Test Case Domain"
  }

  dimension: tc_sub_domain {
    type: string
    sql: ${TABLE}.TC_Sub_Domain ;;
    label: "Test Case Sub-Domain"
  }

  dimension: tc_validation_team {
    type: string
    sql: ${TABLE}.TC_Validation_Team ;;
    label: "Test Case Validation Team"
  }

  dimension: tc_domain_leader {
    type: string
    sql: ${TABLE}.TC_Domain_Leader ;;
    label: "Test Case Domain Leader"
  }

  dimension: tc_validation_leader {
    type: string
    sql: ${TABLE}.TC_Validation_Leader ;;
    label: "Test Case Validation Leader"
  }

  dimension: tc_system_owner {
    type: string
    sql: ${TABLE}.TC_System_Owner ;;
    label: "Test Case System Owner (Resolved LV2)"
  }

  dimension: tc_engineering_level {
    type: string
    sql: ${TABLE}.TC_Engineering_Level ;;
    label: "Test Case Engineering Level (Resolved LV2)"
  }

  dimension: tc_execution_organization {
    type: string
    sql: ${TABLE}.TC_Execution_Organization ;;
    label: "Test Case Execution Organization"
  }

  dimension: tc_bench_type {
    type: string
    sql: ${TABLE}.TC_Bench_Type ;;
    label: "Test Case Bench Type"
  }

  dimension: tc_vehicle_project {
    type: string
    sql: ${TABLE}.TC_Vehicle_Project ;;
    label: "Test Case Vehicle Project"
  }

  dimension: tc_feature {
    type: string
    sql: ${TABLE}.TC_Feature ;;
    label: "Test Case Feature"
  }

  dimension: tc_estimated_duration {
    type: number
    sql: ${TABLE}.TC_Estimated_Duration ;;
    label: "Test Case Estimated Duration"
  }

  dimension: automation_id {
    type: number
    sql: ${TABLE}.Automation_Id ;;
    label: "Automation Request ID"
  }

  dimension: automation_status {
    type: string
    sql: ${TABLE}.Automation_Status ;;
    label: "Automation Status"
  }

  dimension: automation_framework {
    type: string
    sql: ${TABLE}.Automation_Framework ;;
    label: "Automation Framework"
  }
}

# ------------------------------------------------------------------------------
# 3. GOLD_DIM_TEST_SET (PK: TS_Id — 1 row per Test Set / Campaign)
# ------------------------------------------------------------------------------
view: gold_dim_test_set {
  sql_table_name: `ampere_sdv_ivv.gold_dim_test_set` ;;
  label: "Test Set (Canonical Dimension)"

  dimension: ts_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.TS_Id ;;
    label: "Test Set ID"
    description: "Unique Codebeamer Test Set identifier (1 row per TS_Id)"
  }

  dimension: ts_name {
    type: string
    sql: ${TABLE}.TS_Name ;;
    label: "Test Set Name"
  }

  dimension: ts_status {
    type: string
    sql: ${TABLE}.TS_Status ;;
    label: "Test Set Status"
  }

  dimension: ts_type {
    type: string
    sql: ${TABLE}.TS_Type ;;
    label: "Test Set Type"
  }

  dimension: ts_domain {
    type: string
    sql: ${TABLE}.TS_Domain ;;
    label: "Test Set Domain"
  }

  dimension: ts_validation_team {
    type: string
    sql: ${TABLE}.TS_Validation_Team ;;
    label: "Test Set Validation Team"
  }

  dimension: ts_vehicle_project {
    type: string
    sql: ${TABLE}.TS_Vehicle_Project ;;
    label: "Vehicle Project (Test Set)"
  }

  dimension: ts_bench_type {
    type: string
    sql: ${TABLE}.TS_Bench_Type ;;
    label: "Test Set Bench Type"
  }

  dimension: ts_baseline {
    type: string
    sql: ${TABLE}.TS_Baseline ;;
    label: "Test Set Baseline (Resolved LV2)"
  }

  dimension: ts_mysf {
    type: string
    sql: ${TABLE}.TS_MySF ;;
    label: "Test Set MySF (Resolved LV2)"
  }

  dimension: ts_pcu_releases {
    type: string
    sql: ${TABLE}.TS_PCU_Releases ;;
    label: "PCU Releases"
  }

  dimension: ts_piu_releases {
    type: string
    sql: ${TABLE}.TS_PIU_Releases ;;
    label: "PIU Releases"
  }

  dimension: ts_ivc_releases {
    type: string
    sql: ${TABLE}.TS_IVC_Releases ;;
    label: "IVC Releases"
  }

  dimension: ts_cdc_releases {
    type: string
    sql: ${TABLE}.TS_CDC_Releases ;;
    label: "CDC Releases"
  }
}

# ------------------------------------------------------------------------------
# 4. GOLD_DIM_ISSUE (PK: Issue_Id — 1 row per Defect / Issue)
# ------------------------------------------------------------------------------
view: gold_dim_issue {
  sql_table_name: `ampere_sdv_ivv.gold_dim_issue` ;;
  label: "Issue / Defect (Canonical Dimension)"

  dimension: issue_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Issue_Id ;;
    label: "Issue ID"
  }

  dimension: issue_summary {
    type: string
    sql: ${TABLE}.Issue_Summary ;;
    label: "Issue Summary"
  }

  dimension: issue_status {
    type: string
    sql: ${TABLE}.Issue_Status ;;
    label: "Issue Status"
  }

  dimension: issue_criticity {
    type: string
    sql: ${TABLE}.Issue_Criticity ;;
    label: "Issue Criticity"
  }

  dimension: issue_resolution {
    type: string
    sql: ${TABLE}.Issue_Resolution ;;
    label: "Issue Resolution"
  }

  dimension: issue_fix_version {
    type: string
    sql: ${TABLE}.Issue_Fix_Version ;;
    label: "Issue Fix Version"
  }

  dimension: issue_is_valid {
    type: yesno
    sql: ${TABLE}.Issue_isValid ;;
    label: "Is Valid Issue?"
  }
}

# ------------------------------------------------------------------------------
# 5. GOLD_FACT_REQ_TC_TRACEABILITY (World 1: Traceability & Coverage Fact)
# ------------------------------------------------------------------------------
view: gold_fact_req_tc_traceability {
  sql_table_name: `ampere_sdv_ivv.gold_fact_req_tc_traceability` ;;
  label: "Traceability & Coverage Fact (Req <-> TC)"

  dimension: traceability_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.traceability_pk ;;
  }

  dimension: req_id {
    hidden: yes
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  dimension: tc_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: sdv_feature_id {
    type: string
    sql: ${TABLE}.SDV_Feature_Id ;;
    label: "SDV Feature ID"
  }

  dimension: feature_source {
    type: string
    sql: ${TABLE}.Feature_Source ;;
    label: "Feature Traceability Source"
  }

  dimension: is_req_covered_by_tc {
    type: yesno
    sql: ${TABLE}.is_req_covered_by_tc ;;
    label: "Is Requirement Covered by TC?"
  }

  dimension: is_tc_linked_to_req {
    type: yesno
    sql: ${TABLE}.is_tc_linked_to_req ;;
    label: "Is Test Case Linked to Requirement?"
  }
}

# ------------------------------------------------------------------------------
# 6. GOLD_FACT_TC_TS_EXECUTION (World 2: Test Execution & Latest Run Fact)
# Grain: 1 row per (TC_Id, TS_Id, TR_Id nullable) — NEVER duplicated by Issue_Id!
# ------------------------------------------------------------------------------
view: gold_fact_tc_ts_execution {
  sql_table_name: `ampere_sdv_ivv.gold_fact_tc_ts_execution` ;;
  label: "Test Execution & Runs Fact (TC <-> TS <-> TR)"

  dimension: execution_grain_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.execution_grain_pk ;;
  }

  dimension: tc_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: ts_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TS_Id ;;
  }

  dimension: tr_id {
    type: number
    sql: ${TABLE}.TR_Id ;;
    label: "Test Run ID"
  }

  dimension: valid_baseline {
    type: string
    sql: ${TABLE}.Valid_Baseline ;;
    label: "Validation Baseline"
  }

  dimension_group: tr_run {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.TR_RunDate ;;
    label: "Test Run Execution"
  }

  dimension: cb_run_week {
    type: string
    sql: ${TABLE}.TR_RunWeek ;;
    label: "Test Run Week (Codebeamer)"
  }

  dimension: tr_result {
    type: string
    sql: ${TABLE}.TR_Result ;;
    label: "Test Run Result"
  }

  dimension: tr_relevant_status {
    type: number
    sql: ${TABLE}.TR_Relevant_Status ;;
    label: "TR Relevant Status Code"
  }

  dimension: tr_regression {
    type: string
    sql: ${TABLE}.TR_Regression ;;
    label: "Regression Status (TR_Regression)"
  }

  dimension: is_first_run_in_ts {
    type: yesno
    sql: ${TABLE}.is_first_run_in_ts ;;
    label: "Is First Run in Test Set?"
    description: "True if this row is the chronological first run of TC_Id inside TS_Id"
  }

  dimension: is_last_run_in_ts {
    type: yesno
    sql: ${TABLE}.is_last_run_in_ts ;;
    label: "Is Last Run in Test Set? (Campaign Latest Status)"
    description: "True if this row is the latest execution status of TC_Id inside TS_Id (recommended grain for campaign status)"
  }

  dimension: is_global_last_run_for_tc {
    type: yesno
    sql: ${TABLE}.is_global_last_run_for_tc ;;
    label: "Is Global Last Run for Test Case?"
    description: "True if this row is the most recent execution of TC_Id across all Test Sets"
  }

  dimension: tc_already_in_ts {
    type: string
    sql: ${TABLE}.TC_AlreadyInTS ;;
    label: "TC Already in Another TS? (LV5)"
  }

  dimension: tc_nb_fix_versions {
    type: number
    sql: ${TABLE}.TC_Nb_FixVersions ;;
    label: "TC Number of Fix Versions (LV5)"
  }

  dimension: tr_nb_issues_closed {
    type: number
    sql: ${TABLE}.TR_nbIssuesClosed ;;
    label: "TR Closed Issues Count (LV5)"
  }

  dimension: tr_nb_issues_invalid {
    type: number
    sql: ${TABLE}.TR_nbIssuesInvalid ;;
    label: "TR Invalid Issues Count (LV5)"
  }

  dimension: tr_nb_issues_total {
    type: number
    sql: ${TABLE}.TR_nbIssuesTotal ;;
    label: "TR Total Linked Issues Count"
  }
}

# ------------------------------------------------------------------------------
# 7. GOLD_BRIDGE_TR_ISSUE (PK: TR_Id + Issue_Id)
# ------------------------------------------------------------------------------
view: gold_bridge_tr_issue {
  sql_table_name: `ampere_sdv_ivv.gold_bridge_tr_issue` ;;
  label: "Test Run to Issue Bridge"

  dimension: tr_issue_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.tr_issue_pk ;;
  }

  dimension: tr_id {
    hidden: yes
    type: number
    sql: ${TABLE}.TR_Id ;;
  }

  dimension: issue_id {
    hidden: yes
    type: string
    sql: ${TABLE}.Issue_Id ;;
  }
}
