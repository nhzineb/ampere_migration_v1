# ==============================================================================
# EXPERIMENT 2 (GREEN LAYER): LAYER 3 EXPLORE
# (explores/sdv_tc_runs_green_layer.explore.lkml)
# Normalized Bridge/Snowflake Schema starting from green_dim_tc (1 row per TC_Id)
# and joining all 7 Green Layer LV2 Bridge & Resolved Attribute tables
# + LV1 Raw Entity tables (TS, TR, Req, Issues, TC_AutoRequests).
# ==============================================================================

include: "/views/green_layer/green_core_views.view.lkml"
include: "/views/green_layer/+green_core_kpis.view.lkml"

explore: sdv_tc_runs_green_layer {
  label: "Experiment 2 — SDV TC Runs (Green Layer Normalized Bridges)"
  description: "Migrated from Spotfire SDV_TC_Runs__Foundation.dxp using the 7 Green Layer LV2 Bridge & Attribute tables (New_Core_TC_TS, New_Core_Req_TC_Feature, TC_EngLVL, TC_System, Req_Baseline, Req_MySF, TS_Baseline) + LV1 Entity tables."
  view_name: green_dim_tc

  access_filter: {
    field: green_dim_tc.tc_domain
    user_attribute: allowed_sdv_domains
  }

  # Green LV2 Resolved TC Attributes (1:1 with TC_Id)
  join: green_tc_eng_lvl {
    view_label: "1. Green LV2 — TC Resolved Attributes"
    type: left_outer
    relationship: one_to_one
    sql_on: ${green_dim_tc.tc_id} = ${green_tc_eng_lvl.tc_id} ;;
  }

  join: green_tc_system {
    view_label: "1. Green LV2 — TC Resolved Attributes"
    type: left_outer
    relationship: one_to_one
    sql_on: ${green_dim_tc.tc_id} = ${green_tc_system.tc_id} ;;
  }

  # Green LV2 Bridge 1: TC <-> TS (TBL_from_VW_CB_SDV_Dataset_New_Core_TC_TS)
  join: green_bridge_tc_ts {
    view_label: "2. Green LV2 — TC <-> TS Bridge"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_dim_tc.tc_id} = ${green_bridge_tc_ts.tc_id} ;;
  }

  join: green_dim_ts {
    view_label: "3. Test Set (LV1 Dim TS)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${green_bridge_tc_ts.ts_id} = ${green_dim_ts.ts_id} ;;
  }

  join: green_ts_baseline {
    view_label: "3. Test Set (LV1 Dim TS)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_dim_ts.ts_id} = ${green_ts_baseline.ts_id} ;;
  }

  # LV1 Raw Test Runs + Green Computed Run Ranking Derived Table
  join: green_fact_tr {
    view_label: "4. Test Run (LV1 Fact TR)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_bridge_tc_ts.tc_id} = ${green_fact_tr.tc_id}
      AND ${green_bridge_tc_ts.ts_id} = ${green_fact_tr.ts_id} ;;
  }

  join: green_tr_ranked_derived {
    view_label: "4. Test Run (LV1 Fact TR)"
    type: left_outer
    relationship: one_to_one
    sql_on: ${green_fact_tr.tr_id} = ${green_tr_ranked_derived.tr_id} ;;
  }

  join: green_dim_issues {
    view_label: "5. Issues (LV1 Dim Issues)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${green_fact_tr.issue_cb_id} = ${green_dim_issues.codebeamer} ;;
  }

  # Green LV2 Bridge 2: Req <-> TC <-> Feature (TBL_from_VW_CB_SDV_Dataset_New_Core_Req_TC_Feature)
  join: green_bridge_req_tc_feature {
    view_label: "6. Green LV2 — Req <-> TC <-> Feature Bridge"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_dim_tc.tc_id} = ${green_bridge_req_tc_feature.tc_id} ;;
  }

  join: green_dim_req {
    view_label: "7. Requirement (LV1 Dim Req + Green LV2 Baselines)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${green_bridge_req_tc_feature.req_id} = ${green_dim_req.req_id} ;;
  }

  join: green_req_baseline {
    view_label: "7. Requirement (LV1 Dim Req + Green LV2 Baselines)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_dim_req.req_id} = ${green_req_baseline.req_id} ;;
  }

  join: green_req_mysf {
    view_label: "7. Requirement (LV1 Dim Req + Green LV2 Baselines)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_dim_req.req_id} = ${green_req_mysf.req_id} ;;
  }

  # LV1 Automation Requests
  join: green_dim_auto_requests {
    view_label: "8. Automation Requests (LV1 Auto)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${green_dim_tc.tc_id} = ${green_dim_auto_requests.automation_tc_id} ;;
  }
}

test: green_tc_pk_is_unique {
  explore_source: sdv_tc_runs_green_layer {
    column: tc_id { field: green_dim_tc.tc_id }
    column: row_count { field: green_dim_tc.unique_tc_count }
    sorts: [green_dim_tc.unique_tc_count: desc]
    limit: 1
  }
  assert: pk_has_no_duplicates {
    expression: ${green_dim_tc.unique_tc_count} <= 1 ;;
  }
}
