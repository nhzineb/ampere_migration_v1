# ==============================================================================
# GOLD ARCHITECTURE V2 — BASE VIEWS (strict many_to_one design)
# views/gold_v2/g2_views.view.lkml
# 4 canonical dimensions (with pre-aggregated child attributes + STRUCT/ARRAY
# filter-only columns), 4 fact tables. No one_to_many join anywhere.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. g2_dim_requirement (PK Req_Id)
# ------------------------------------------------------------------------------
view: g2_dim_requirement {
  sql_table_name: `ampere_sdv_ivv.gold_dim_requirement` ;;
  label: "Requirement"

  dimension: req_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.Req_Id ;;
    label: "Requirement ID"
    value_format_name: id
  }
  dimension: req_name { type: string sql: ${TABLE}.Req_Name ;; label: "Requirement Name" }
  dimension: req_type { type: string sql: ${TABLE}.Req_Type ;; label: "Requirement Type" }
  dimension: req_status { type: string sql: ${TABLE}.Req_Status ;; label: "Requirement Status" }
  dimension: req_final_status { type: string sql: ${TABLE}.Req_FinalStatus ;; label: "Requirement Final Status" }
  dimension: req_tracker { type: string sql: ${TABLE}.Req_Tracker ;; label: "Tracker" }
  dimension: req_domain { type: string sql: ${TABLE}.Req_Domain ;; label: "Domain" group_label: "Ownership" }
  dimension: req_sub_domain { type: string sql: ${TABLE}.Req_Sub_Domain ;; label: "Sub-Domain" group_label: "Ownership" }
  dimension: req_system_owner { type: string sql: ${TABLE}.Req_System_Owner ;; label: "System Owner" group_label: "Ownership" }
  dimension: req_engineering_level { type: string sql: ${TABLE}.Req_Engineering_Level ;; label: "Engineering Level" group_label: "Ownership" }
  dimension: req_allocation { type: string sql: ${TABLE}.Req_Allocation ;; label: "Allocation" group_label: "Ownership" }
  dimension: req_asil { type: string sql: ${TABLE}.Req_ASIL ;; label: "ASIL" group_label: "Safety" }
  dimension: req_safety_related { type: string sql: ${TABLE}.Req_Safety_Related ;; label: "Safety Related" group_label: "Safety" }
  dimension: req_regulation { type: string sql: ${TABLE}.Req_Regulation ;; label: "Regulation" group_label: "Safety" }
  dimension: req_cyber { type: string sql: ${TABLE}.Req_Cyber ;; label: "Cyber" group_label: "Safety" }
  dimension: req_vehicle_project { type: string sql: ${TABLE}.Req_Vehicle_Project ;; label: "Vehicle Project" group_label: "Project" }
  dimension: req_feature { type: string sql: ${TABLE}.Req_Feature ;; label: "Feature" group_label: "Project" }
  dimension: req_baseline { type: string sql: ${TABLE}.Req_Baseline ;; label: "Baseline (primary)" group_label: "Project" }
  dimension: req_baselines_display { type: string sql: ${TABLE}.req_baselines_display ;; label: "Baselines (all)" group_label: "Project" }
  dimension: req_mysf { type: string sql: ${TABLE}.Req_MySF ;; label: "MySF (primary)" group_label: "Project" }
  dimension: req_mysf_name { type: string sql: ${TABLE}.Req_MySF_Name ;; label: "MySF Name" group_label: "Project" }

  # STRUCT isp
  dimension: isp_id { type: string sql: ${TABLE}.isp.id ;; label: "ISP ID" group_label: "ISP" }
  dimension: isp_status { type: string sql: ${TABLE}.isp.status ;; label: "ISP Status" group_label: "ISP" }
  dimension: isp_resolution { type: string sql: ${TABLE}.isp.resolution ;; label: "ISP Resolution" group_label: "ISP" }
  dimension: isp_fix_version { type: string sql: ${TABLE}.isp.fix_version ;; label: "ISP Fix Version" group_label: "ISP" }
  dimension: isp_committed_sprint { type: string sql: ${TABLE}.isp.committed_sprint ;; label: "ISP Committed Sprint" group_label: "ISP" }

  # Pre-aggregated from traceability fact
  dimension: covering_tc_count { type: number sql: ${TABLE}.covering_tc_count ;; label: "# Covering Test Cases" group_label: "Coverage (pre-aggregated)" }
  dimension: is_covered_by_tc { type: yesno sql: ${TABLE}.is_covered_by_tc ;; label: "Is Covered by a TC?" group_label: "Coverage (pre-aggregated)" }
  dimension: is_false_req { type: yesno sql: ${TABLE}.is_false_req ;; label: "Is False Requirement?" }
  dimension: req_parent_id { type: number sql: ${TABLE}.Req_Requirement_Parent_Id ;; label: "Parent Requirement ID" value_format_name: id }
  dimension_group: req_updated { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.Req_Updated ;; label: "Updated" }

  # Filter-only ARRAY<STRING> columns (never joined / unnested in an Explore)
  dimension: req_baselines_list { hidden: yes sql: ${TABLE}.req_baselines_list ;; }
  dimension: req_mysf_list { hidden: yes sql: ${TABLE}.req_mysf_list ;; }

  filter: baseline_filter {
    type: string
    label: "Baseline (any)"
    group_label: "Project"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.req_baselines_list) b WHERE {% condition baseline_filter %} b {% endcondition %}) ;;
  }
  filter: mysf_filter {
    type: string
    label: "MySF (any)"
    group_label: "Project"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.req_mysf_list) m WHERE {% condition mysf_filter %} m {% endcondition %}) ;;
  }
}

# ------------------------------------------------------------------------------
# 2. g2_dim_test_case (PK TC_Id)
# ------------------------------------------------------------------------------
view: g2_dim_test_case {
  sql_table_name: `ampere_sdv_ivv.gold_dim_test_case` ;;
  label: "Test Case"

  dimension: tc_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
    label: "Test Case ID"
    value_format_name: id
  }
  dimension: tc_uid { type: string sql: ${TABLE}.TC_UID ;; label: "Test Case UID" }
  dimension: tc_name { type: string sql: ${TABLE}.TC_Name ;; label: "Test Case Name" }
  dimension: tc_type { type: string sql: ${TABLE}.TC_Type ;; label: "Type" }
  dimension: tc_status { type: string sql: ${TABLE}.TC_Status ;; label: "Status" }
  dimension: tc_category { type: string sql: ${TABLE}.TC_Category ;; label: "Category" }
  dimension: tc_domain { type: string sql: ${TABLE}.TC_Domain ;; label: "Domain" group_label: "Ownership" }
  dimension: tc_sub_domain { type: string sql: ${TABLE}.TC_Sub_Domain ;; label: "Sub-Domain" group_label: "Ownership" }
  dimension: tc_validation_team { type: string sql: ${TABLE}.TC_Validation_Team ;; label: "Validation Team" group_label: "Ownership" }
  dimension: tc_domain_leader { type: string sql: ${TABLE}.TC_Domain_Leader ;; label: "Domain Leader" group_label: "Ownership" }
  dimension: tc_validation_leader { type: string sql: ${TABLE}.TC_Validation_Leader ;; label: "Validation Leader" group_label: "Ownership" }
  dimension: tc_system_owner { type: string sql: ${TABLE}.TC_System_Owner ;; label: "System Owner" group_label: "Ownership" }
  dimension: tc_engineering_level { type: string sql: ${TABLE}.TC_Engineering_Level ;; label: "Engineering Level" group_label: "Ownership" }
  dimension: tc_execution_organization { type: string sql: ${TABLE}.TC_Execution_Organization ;; label: "Execution Organization" }
  dimension: tc_bench_type { type: string sql: ${TABLE}.TC_Bench_Type ;; label: "Bench Type" }
  dimension: tc_vehicle_project { type: string sql: ${TABLE}.TC_Vehicle_Project ;; label: "Vehicle Project" }
  dimension: tc_feature { type: string sql: ${TABLE}.TC_Feature ;; label: "Feature (primary)" }
  dimension: tc_estimated_duration { type: number sql: ${TABLE}.TC_Estimated_Duration ;; label: "Estimated Duration" }
  dimension_group: tc_updated { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.TC_Updated ;; label: "Updated" }

  # STRUCT automation
  dimension: automation_id { type: number sql: ${TABLE}.automation.id ;; label: "Automation ID" group_label: "Automation" value_format_name: id }
  dimension: automation_status { type: string sql: ${TABLE}.automation.status ;; label: "Automation Status" group_label: "Automation" }
  dimension: automation_framework { type: string sql: ${TABLE}.automation.framework ;; label: "Automation Framework" group_label: "Automation" }
  dimension: automation_bench_type { type: string sql: ${TABLE}.automation.bench_type ;; label: "Automation Bench Type" group_label: "Automation" }
  dimension: is_automated {
    type: yesno
    sql: ${TABLE}.automation.status IN ('Automated', 'Done', 'Validated') ;;
    label: "Is Automated?"
    group_label: "Automation"
  }

  # Pre-aggregated from traceability fact (replaces the 1:N join to requirements)
  dimension: covered_req_count { type: number sql: ${TABLE}.covered_req_count ;; label: "# Covered Requirements" group_label: "Requirements (pre-aggregated)" }
  dimension: is_linked_to_req { type: yesno sql: ${TABLE}.is_linked_to_req ;; label: "Is Linked to a Requirement?" group_label: "Requirements (pre-aggregated)" }
  dimension: req_asil_max { type: string sql: ${TABLE}.req_asil_max ;; label: "Highest ASIL of Covered Reqs" group_label: "Requirements (pre-aggregated)" }
  dimension: req_has_regulation { type: yesno sql: ${TABLE}.req_has_regulation ;; label: "Covers a Regulated Req?" group_label: "Requirements (pre-aggregated)" }
  dimension: req_mysf_display { type: string sql: ${TABLE}.req_mysf_display ;; label: "Covered Req MySF (all)" group_label: "Requirements (pre-aggregated)" }

  # Pre-aggregated from execution fact
  dimension: ts_assignment_count { type: number sql: ${TABLE}.ts_assignment_count ;; label: "# Test Set Assignments" group_label: "Execution (pre-aggregated)" }
  dimension: global_last_run_result { type: string sql: ${TABLE}.global_last_run_result ;; label: "Global Last Run Result" group_label: "Execution (pre-aggregated)" }
  dimension_group: global_last_run { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.global_last_run_date ;; label: "Global Last Run" group_label: "Execution (pre-aggregated)" }

  # Filter-only arrays
  dimension: req_mysf_list { hidden: yes sql: ${TABLE}.req_mysf_list ;; }
  dimension: req_baselines_list { hidden: yes sql: ${TABLE}.req_baselines_list ;; }
  dimension: tc_features_list { hidden: yes sql: ${TABLE}.tc_features_list ;; }
  dimension: tc_brands_list { hidden: yes sql: ${TABLE}.tc_brands_list ;; }

  filter: req_mysf_filter {
    type: string
    label: "Covered Req MySF (any)"
    group_label: "Requirements (pre-aggregated)"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.req_mysf_list) m WHERE {% condition req_mysf_filter %} m {% endcondition %}) ;;
  }
  filter: req_baseline_filter {
    type: string
    label: "Covered Req Baseline (any)"
    group_label: "Requirements (pre-aggregated)"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.req_baselines_list) b WHERE {% condition req_baseline_filter %} b {% endcondition %}) ;;
  }
  filter: feature_filter {
    type: string
    label: "Feature (any)"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.tc_features_list) f WHERE {% condition feature_filter %} f {% endcondition %}) ;;
  }
  filter: brand_filter {
    type: string
    label: "Brand (any)"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.tc_brands_list) b WHERE {% condition brand_filter %} b {% endcondition %}) ;;
  }
}

# ------------------------------------------------------------------------------
# 3. g2_dim_test_set (PK TS_Id)
# ------------------------------------------------------------------------------
view: g2_dim_test_set {
  sql_table_name: `ampere_sdv_ivv.gold_dim_test_set` ;;
  label: "Test Set"

  dimension: ts_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.TS_Id ;;
    label: "Test Set ID"
    value_format_name: id
  }
  dimension: ts_name { type: string sql: ${TABLE}.TS_Name ;; label: "Test Set Name" }
  dimension: ts_status { type: string sql: ${TABLE}.TS_Status ;; label: "Status" }
  dimension: ts_type { type: string sql: ${TABLE}.TS_Type ;; label: "Type" }
  dimension: ts_domain { type: string sql: ${TABLE}.TS_Domain ;; label: "Domain" }
  dimension: ts_validation_team { type: string sql: ${TABLE}.TS_Validation_Team ;; label: "Validation Team" }
  dimension: ts_vehicle_project { type: string sql: ${TABLE}.TS_Vehicle_Project ;; label: "Vehicle Project" }
  dimension: ts_bench_type { type: string sql: ${TABLE}.TS_Bench_Type ;; label: "Bench Type" }
  dimension: ts_bench { type: string sql: ${TABLE}.TS_Bench ;; label: "Bench" }
  dimension: ts_baseline { type: string sql: ${TABLE}.TS_Baseline ;; label: "Baseline (primary)" }
  dimension: ts_mysf { type: string sql: ${TABLE}.TS_MySF ;; label: "MySF" }
  dimension_group: ts_updated { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.TS_Updated ;; label: "Updated" }

  # STRUCT releases
  dimension: release_sw { type: string sql: ${TABLE}.releases.sw ;; label: "SW Release" group_label: "Releases" }
  dimension: release_pcu { type: string sql: ${TABLE}.releases.pcu ;; label: "PCU Release" group_label: "Releases" }
  dimension: release_piu { type: string sql: ${TABLE}.releases.piu ;; label: "PIU Release" group_label: "Releases" }
  dimension: release_ivc { type: string sql: ${TABLE}.releases.ivc ;; label: "IVC Release" group_label: "Releases" }
  dimension: release_cdc { type: string sql: ${TABLE}.releases.cdc ;; label: "CDC Release" group_label: "Releases" }
  dimension: release_other { type: string sql: ${TABLE}.releases.other ;; label: "Other Release" group_label: "Releases" }

  # STRUCT isp
  dimension: isp_id { type: string sql: ${TABLE}.isp.id ;; label: "ISP ID" group_label: "ISP" }
  dimension: isp_status { type: string sql: ${TABLE}.isp.status ;; label: "ISP Status" group_label: "ISP" }
  dimension: isp_resolution { type: string sql: ${TABLE}.isp.resolution ;; label: "ISP Resolution" group_label: "ISP" }

  # Pre-aggregated from execution fact
  dimension: planned_tc_count { type: number sql: ${TABLE}.planned_tc_count ;; label: "# Planned TCs" group_label: "Execution (pre-aggregated)" }
  dimension: executed_tc_count { type: number sql: ${TABLE}.executed_tc_count ;; label: "# Executed TCs" group_label: "Execution (pre-aggregated)" }

  dimension: ts_baselines_list { hidden: yes sql: ${TABLE}.ts_baselines_list ;; }
  filter: ts_baseline_filter {
    type: string
    label: "Baseline (any)"
    sql: EXISTS (SELECT 1 FROM UNNEST(${TABLE}.ts_baselines_list) b WHERE {% condition ts_baseline_filter %} b {% endcondition %}) ;;
  }
}

# ------------------------------------------------------------------------------
# 4. g2_dim_issue (PK Issue_Id)
# ------------------------------------------------------------------------------
view: g2_dim_issue {
  sql_table_name: `ampere_sdv_ivv.gold_dim_issue` ;;
  label: "Issue"

  dimension: issue_id { primary_key: yes type: string sql: ${TABLE}.Issue_Id ;; label: "Issue ID" }
  dimension: issue_summary { type: string sql: ${TABLE}.Issue_Summary ;; label: "Summary" }
  dimension: issue_type { type: string sql: ${TABLE}.Issue_Type ;; label: "Type" }
  dimension: issue_status { type: string sql: ${TABLE}.Issue_Status ;; label: "Status" }
  dimension: issue_resolution { type: string sql: ${TABLE}.Issue_Resolution ;; label: "Resolution" }
  dimension: issue_priority { type: string sql: ${TABLE}.Issue_Priority ;; label: "Priority" }
  dimension: issue_criticity { type: string sql: ${TABLE}.Issue_Criticity ;; label: "Criticity" }
  dimension: issue_domain_in_charge { type: string sql: ${TABLE}.Issue_Domain_in_charge ;; label: "Domain in Charge" }
  dimension: issue_validation_team { type: string sql: ${TABLE}.Issue_Validation_Team ;; label: "Validation Team" }
  dimension: issue_fix_version { type: string sql: ${TABLE}.Issue_Fix_Version ;; label: "Fix Version" }
  dimension: issue_milestone { type: string sql: ${TABLE}.Issue_Milestone ;; label: "Milestone" }
  dimension: issue_is_valid { type: yesno sql: ${TABLE}.Issue_isValid ;; label: "Is Valid?" }
  dimension: is_open {
    type: yesno
    sql: ${TABLE}.Issue_Status NOT IN ('Closed', 'Done', 'Resolved', 'Rejected') ;;
    label: "Is Open?"
  }
  dimension: linked_tr_count { type: number sql: ${TABLE}.linked_tr_count ;; label: "# Linked Test Runs (pre-aggregated)" }
  dimension_group: issue_created { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.Issue_Created ;; label: "Created" }
  dimension_group: issue_updated { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.Issue_Updated ;; label: "Updated" }
}

# ------------------------------------------------------------------------------
# 5. g2_fact_req_tc_traceability — grain (Req_Id, TC_Id, SDV_Feature_Id)
# ------------------------------------------------------------------------------
view: g2_fact_req_tc_traceability {
  sql_table_name: `ampere_sdv_ivv.gold_fact_req_tc_traceability` ;;
  label: "Traceability (Req x TC)"

  dimension: traceability_pk { primary_key: yes hidden: yes type: string sql: ${TABLE}.traceability_pk ;; }
  dimension: req_id { hidden: yes type: number sql: ${TABLE}.Req_Id ;; }
  dimension: tc_id { hidden: yes type: number sql: ${TABLE}.TC_Id ;; }
  dimension: sdv_feature_id { type: string sql: ${TABLE}.SDV_Feature_Id ;; label: "SDV Feature ID" }
  dimension: feature_source { type: string sql: ${TABLE}.Feature_Source ;; label: "Feature Source" }
  dimension: is_req_covered_by_tc { type: yesno sql: ${TABLE}.is_req_covered_by_tc ;; label: "Req Covered by TC?" }
  dimension: is_tc_linked_to_req { type: yesno sql: ${TABLE}.is_tc_linked_to_req ;; label: "TC Linked to Req?" }
}

# ------------------------------------------------------------------------------
# 6. g2_fact_tc_ts_execution — grain (TC_Id, TS_Id, TR_Id | NOT_RUN); TR_Id unique
# ------------------------------------------------------------------------------
view: g2_fact_tc_ts_execution {
  sql_table_name: `ampere_sdv_ivv.gold_fact_tc_ts_execution` ;;
  label: "Execution (TC x TS x TR)"

  dimension: execution_grain_pk { primary_key: yes hidden: yes type: string sql: ${TABLE}.execution_grain_pk ;; }
  dimension: tc_id { hidden: yes type: number sql: ${TABLE}.TC_Id ;; }
  dimension: ts_id { hidden: yes type: number sql: ${TABLE}.TS_Id ;; }
  dimension: tr_id { type: number sql: ${TABLE}.TR_Id ;; label: "Test Run ID" value_format_name: id }
  dimension: valid_baseline { type: string sql: ${TABLE}.Valid_Baseline ;; label: "Validation Baseline" }
  dimension_group: tr_run {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.TR_RunDate ;;
    label: "Run"
  }
  dimension: cb_run_week { type: string sql: ${TABLE}.TR_RunWeek ;; label: "Run Week (Codebeamer)" }
  dimension: tr_result { type: string sql: ${TABLE}.TR_Result ;; label: "Run Result" }
  dimension: tr_relevant_status { type: number sql: ${TABLE}.TR_Relevant_Status ;; label: "Relevant Status Code" }
  dimension: tr_regression { type: string sql: ${TABLE}.TR_Regression ;; label: "Regression" }
  dimension: is_first_run_in_ts { type: yesno sql: ${TABLE}.is_first_run_in_ts ;; label: "Is First Run in TS?" }
  dimension: is_last_run_in_ts { type: yesno sql: ${TABLE}.is_last_run_in_ts ;; label: "Is Last Run in TS?" }
  dimension: is_global_last_run_for_tc { type: yesno sql: ${TABLE}.is_global_last_run_for_tc ;; label: "Is Global Last Run for TC?" }
  dimension: is_executed { type: yesno sql: ${TABLE}.TR_Id IS NOT NULL ;; label: "Is Executed?" }
  dimension: tc_already_in_ts { type: string sql: ${TABLE}.TC_AlreadyInTS ;; label: "TC Already in Another TS?" }
  dimension: tc_nb_fix_versions { type: number sql: ${TABLE}.TC_Nb_FixVersions ;; label: "# Fix Versions (TC)" }
  dimension: tr_nb_issues_total { type: number sql: ${TABLE}.TR_nbIssuesTotal ;; label: "# Issues (run)" group_label: "Issues (pre-aggregated)" }
  dimension: tr_nb_issues_closed { type: number sql: ${TABLE}.TR_nbIssuesClosed ;; label: "# Closed Issues (run)" group_label: "Issues (pre-aggregated)" }
  dimension: tr_nb_issues_invalid { type: number sql: ${TABLE}.TR_nbIssuesInvalid ;; label: "# Invalid Issues (run)" group_label: "Issues (pre-aggregated)" }
  dimension: tr_issue_ids_display { type: string sql: ${TABLE}.tr_issue_ids_display ;; label: "Linked Issue IDs" group_label: "Issues (pre-aggregated)" }
}

# ------------------------------------------------------------------------------
# 7. g2_fact_tr_issue — grain (TR_Id, Issue_Id) with denormalized TC_Id / TS_Id
# ------------------------------------------------------------------------------
view: g2_fact_tr_issue {
  sql_table_name: `ampere_sdv_ivv.gold_fact_tr_issue` ;;
  label: "Defects (TR x Issue)"

  dimension: tr_issue_pk { primary_key: yes hidden: yes type: string sql: ${TABLE}.tr_issue_pk ;; }
  dimension: tr_id { hidden: yes type: number sql: ${TABLE}.TR_Id ;; }
  dimension: issue_id { hidden: yes type: string sql: ${TABLE}.Issue_Id ;; }
  dimension: tc_id { hidden: yes type: number sql: ${TABLE}.TC_Id ;; }
  dimension: ts_id { hidden: yes type: number sql: ${TABLE}.TS_Id ;; }
  dimension_group: tr_run { type: time timeframes: [date, week, month] datatype: datetime sql: ${TABLE}.TR_RunDate ;; label: "Run" }
  dimension: tr_result { type: string sql: ${TABLE}.TR_Result ;; label: "Run Result" }
  dimension: is_last_run_in_ts { type: yesno sql: ${TABLE}.is_last_run_in_ts ;; label: "On Last Run in TS?" }
}

# ------------------------------------------------------------------------------
# 8. g2_fact_entity_weekly_snapshot — grain (snapshot_week, entity_type, entity_id)
# ------------------------------------------------------------------------------
view: g2_fact_entity_weekly_snapshot {
  sql_table_name: `ampere_sdv_ivv.gold_fact_entity_weekly_snapshot` ;;
  label: "Weekly Status Snapshot"

  dimension: snapshot_pk { primary_key: yes hidden: yes type: string sql: ${TABLE}.snapshot_pk ;; }
  dimension_group: snapshot { type: time timeframes: [date, week, month, quarter] datatype: date sql: ${TABLE}.snapshot_week ;; label: "Snapshot" }
  dimension: entity_type { type: string sql: ${TABLE}.entity_type ;; label: "Entity Type" }
  dimension: entity_id { hidden: yes type: string sql: ${TABLE}.entity_id ;; }
  dimension: status { type: string sql: ${TABLE}.status ;; label: "Status" }
  dimension: simplified_status { type: string sql: ${TABLE}.simplified_status ;; label: "Simplified Status" }
  dimension: domain { type: string sql: ${TABLE}.domain ;; label: "Domain" }
  dimension: engineering_level { type: string sql: ${TABLE}.engineering_level ;; label: "Engineering Level" }
  dimension: system_owner { type: string sql: ${TABLE}.system_owner ;; label: "System Owner" }
  dimension: validation_team { type: string sql: ${TABLE}.validation_team ;; label: "Validation Team" }
  dimension: mysf { type: string sql: ${TABLE}.mysf ;; label: "MySF" }
  dimension: baseline { type: string sql: ${TABLE}.baseline ;; label: "Baseline" }
  dimension: nb_weeks_in_status { type: number sql: ${TABLE}.nb_weeks_in_status ;; label: "Weeks in Status" }
}
