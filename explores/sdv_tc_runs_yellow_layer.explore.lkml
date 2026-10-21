# ==============================================================================
# EXPERIMENT 1 (YELLOW LAYER): LAYER 3 EXPLORE
# (explores/sdv_tc_runs_yellow_layer.explore.lkml)
# Star Schema joining Yellow Layer LV7 Core (yellow_core_init) + 4 LV5 Helper
# Tables + LV1 Entity Dimension Tables (TC, TS, Req, TC_AutoRequests).
# ==============================================================================

include: "/views/yellow_layer/yellow_core_views.view.lkml"
include: "/views/yellow_layer/+yellow_core_kpis.view.lkml"

explore: sdv_tc_runs_yellow_layer {
  label: "Experiment 1 — SDV TC Runs (Yellow Layer Star Schema)"
  description: "Migrated from Spotfire SDV_TC_Runs__Foundation.dxp using the Yellow Layer tables (TBL_from_VW_CB_SDV_Dataset_New_Core_Init + 4 LV5 Yellow helper tables) joined to normalized TC, TS, Req, and Automation dimension tables."
  view_name: yellow_core_init

  access_filter: {
    field: yellow_dim_tc.tc_domain
    user_attribute: allowed_sdv_domains
  }

  # Supporting LV1 Entity Dimension Joins (many_to_one from Yellow Core Fact)
  join: yellow_dim_tc {
    view_label: "1. Test Case (LV1 Dim TC)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.tc_id} = ${yellow_dim_tc.tc_id} ;;
  }

  join: yellow_dim_ts {
    view_label: "2. Test Set (LV1 Dim TS)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.ts_id} = ${yellow_dim_ts.ts_id} ;;
  }

  join: yellow_dim_req {
    view_label: "3. Requirement (LV1 Dim Req)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.req_id} = ${yellow_dim_req.req_id} ;;
  }

  join: yellow_dim_auto_requests {
    view_label: "4. Automation Requests (LV1 Auto)"
    type: left_outer
    relationship: one_to_many
    sql_on: ${yellow_core_init.tc_id} = ${yellow_dim_auto_requests.automation_tc_id} ;;
  }

  # Yellow Layer LV5 Helper Table Joins (many_to_one on TC_Id or TR_Id)
  join: yellow_tc_already_in_ts {
    view_label: "5. Yellow LV5 Pre-Aggregated Helpers"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.tc_id} = ${yellow_tc_already_in_ts.tc_id} ;;
  }

  join: yellow_tc_nb_fix_versions {
    view_label: "5. Yellow LV5 Pre-Aggregated Helpers"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.tc_id} = ${yellow_tc_nb_fix_versions.tc_id} ;;
  }

  join: yellow_tr_nb_issues_closed {
    view_label: "5. Yellow LV5 Pre-Aggregated Helpers"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.tr_id} = ${yellow_tr_nb_issues_closed.tr_id} ;;
  }

  join: yellow_tr_nb_issues_invalid {
    view_label: "5. Yellow LV5 Pre-Aggregated Helpers"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.tr_id} = ${yellow_tr_nb_issues_invalid.tr_id} ;;
  }

  # Dynamic Last-Run Deduplication View
  join: yellow_dynamic_last_run {
    view_label: "6. Dynamic Last Run (Rank=1)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${yellow_core_init.tc_id} = ${yellow_dynamic_last_run.tc_id}
      AND ${yellow_core_init.tr_id} = ${yellow_dynamic_last_run.last_run_tr_id} ;;
  }
}

test: yellow_core_pk_is_unique {
  explore_source: sdv_tc_runs_yellow_layer {
    column: yellow_core_grain_pk { field: yellow_core_init.yellow_core_grain_pk }
    column: row_count { field: yellow_core_init.unique_tr_count }
    sorts: [yellow_core_init.unique_tr_count: desc]
    limit: 1
  }
  assert: pk_has_no_duplicates {
    expression: ${yellow_core_init.unique_tr_count} <= 1 ;;
  }
}
