# ==============================================================================
# STAGE 4: EXPERIMENT 2 (GREEN LAYER) LOOKER NATIVE TABBED DASHBOARD
# (dashboards/sdv_tc_runs_green_layer.dashboard.lookml)
# ==============================================================================

- dashboard: sdv_tc_runs_green_layer
  title: "Experiment 2 — SDV TC Runs (Green Layer Normalized Bridges)"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Experiment 2: Migrated from Spotfire SDV_TC_Runs__Foundation.dxp using the 7 Green Layer LV2 Bridge & Resolved Attribute tables + LV1 Entity tables."

  tabs:
    - name: tab_1_tc_last_runs_results
      label: "1. TC LAST RUNS Results"
    - name: tab_2_tc_all_and_first_runs
      label: "2. TC ALL & First Runs"
    - name: tab_3_automation_and_runs
      label: "3. Automation & Runs"
    - name: tab_4_quality_issues_and_readiness
      label: "4. QUALITY 1/3 & 2/3 (Issues & Readiness)"
    - name: tab_5_quality_crosstable_all_data
      label: "5. QUALITY 3/3 (CrossTable & All Data)"

  filters:
    - name: vehicle_project
      title: "Vehicle Project (TS_Vehicle_Project)"
      type: field_filter
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      field: green_dim_ts.ts_vehicle_project
      ui_config:
        type: tag_list
        display: popover

    - name: tc_domain
      title: "TC Domain"
      type: field_filter
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      field: green_dim_tc.tc_domain
      ui_config:
        type: tag_list
        display: popover

    - name: horizontal_axis_selector
      title: "Horizontal Axis (Spotfire tr.horizontalAxis)"
      type: field_filter
      default_value: "ts_vehicle_project"
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      field: green_dim_tc.tr_horizontal_axis_selector
      ui_config:
        type: dropdown_menu
        display: inline

    - name: items_count_selector
      title: "Items Count Metric (Spotfire ItemsCount)"
      type: field_filter
      default_value: "ts_id"
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      field: green_dim_tc.items_count_selector
      ui_config:
        type: dropdown_menu
        display: inline

  elements:
    # TAB 1: TC LAST RUNS Results
    - name: g_last_runs_results_bar
      title: "LAST Runs Results (by Dynamic Axis)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.dynamic_horizontal_axis]
      measures: [
        green_dim_tc.last_run_passed_tc_count,
        green_dim_tc.last_run_failed_tc_count,
        green_dim_tc.last_run_blocked_tc_count,
        green_dim_tc.last_run_not_executed_tc_count
      ]
      stacking: normal
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
        horizontal_axis_selector: green_dim_tc.tr_horizontal_axis_selector
      row: 0
      col: 0
      width: 12
      height: 8

    - name: g_last_runs_results_pie
      title: "LAST Runs Results (Share by Status)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_pie
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_tr_ranked_derived.last_run_result]
      measures: [green_dim_tc.last_run_total_tc_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 12
      width: 6
      height: 8

    - name: g_last_run_week_bar
      title: "Last Run Week Evolution"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_tr_ranked_derived.last_run_week, green_tr_ranked_derived.last_run_result]
      pivots: [green_tr_ranked_derived.last_run_result]
      measures: [green_dim_tc.last_run_total_tc_count]
      stacking: normal
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 18
      width: 6
      height: 8

    - name: g_last_runs_detailed_view_grid
      title: "LAST Runs Results - Detailed View (Green Layer)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_dim_tc.tc_id,
        green_dim_tc.tc_name,
        green_dim_tc.tc_domain,
        green_tc_eng_lvl.tc_engineering_level,
        green_tc_system.tc_system_owner,
        green_bridge_tc_ts.ts_id,
        green_dim_ts.ts_vehicle_project,
        green_tr_ranked_derived.last_run_tr_id,
        green_tr_ranked_derived.last_run_result,
        green_tr_ranked_derived.last_run_week
      ]
      measures: [green_dim_tc.failed_last_run_issues_list]
      filters:
        green_tr_ranked_derived.is_dynamic_last_run: "yes"
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8

    # TAB 2: TC ALL & First Runs
    - name: g_all_runs_week_bar
      title: "All Runs per Week (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_fact_tr.tr_run_week, green_fact_tr.tr_result]
      pivots: [green_fact_tr.tr_result]
      measures: [green_dim_tc.unique_tr_count]
      stacking: normal
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 0
      width: 9
      height: 8

    - name: g_first_runs_week_bar
      title: "First Runs per Week (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_fact_tr.tr_run_week, green_fact_tr.tr_result]
      pivots: [green_fact_tr.tr_result]
      measures: [green_dim_tc.unique_tc_count]
      filters:
        green_tr_ranked_derived.is_first_run: "yes"
      stacking: normal
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 9
      width: 9
      height: 8

    - name: g_first_runs_pie
      title: "First Runs Breakdown (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_pie
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_fact_tr.tr_result]
      measures: [green_dim_tc.unique_tc_count]
      filters:
        green_tr_ranked_derived.is_first_run: "yes"
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 18
      width: 6
      height: 8

    - name: g_all_runs_detailed_view_grid
      title: "ALL Runs Results - Detailed View (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_fact_tr.tr_id,
        green_dim_tc.tc_id,
        green_dim_tc.tc_name,
        green_bridge_tc_ts.ts_id,
        green_fact_tr.tr_result,
        green_fact_tr.tr_run_date,
        green_dim_issues.issue_id
      ]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 8
      col: 0
      width: 12
      height: 8

    - name: g_first_runs_detailed_view_grid
      title: "First Runs Results - Detailed View (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_dim_tc.tc_id,
        green_dim_tc.tc_name,
        green_fact_tr.tr_id,
        green_fact_tr.tr_result,
        green_fact_tr.tr_run_week
      ]
      filters:
        green_tr_ranked_derived.is_first_run: "yes"
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 8
      col: 12
      width: 12
      height: 8

    # TAB 3: Automation & Runs
    - name: g_auto_req_in_ts_bar
      title: "TC with an Auto Request in a TS or not"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.auto_ts_runs, green_dim_tc.tc_domain]
      pivots: [green_dim_tc.auto_ts_runs]
      measures: [green_dim_tc.unique_tc_count]
      filters:
        green_dim_auto_requests.automation_id: "NOT NULL"
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 0
      width: 12
      height: 8

    - name: g_auto_req_last_runs_bar
      title: "LAST Runs Results for TC with an Auto Request"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.tc_domain]
      measures: [
        green_dim_tc.last_run_passed_tc_count,
        green_dim_tc.last_run_failed_tc_count,
        green_dim_tc.last_run_blocked_tc_count
      ]
      filters:
        green_dim_auto_requests.automation_id: "NOT NULL"
      stacking: normal
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 12
      width: 12
      height: 8

    - name: g_auto_requests_detailed_view_grid
      title: "Automation Requests - Detailed View"
      tab_name: tab_3_automation_and_runs
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_dim_tc.tc_id,
        green_dim_tc.tc_name,
        green_dim_auto_requests.automation_id,
        green_dim_tc.auto_ts_runs,
        green_dim_tc.tc_type,
        green_dim_tc.tc_domain
      ]
      filters:
        green_dim_auto_requests.automation_id: "NOT NULL"
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8

    # TAB 4: QUALITY 1/3 & 2/3
    - name: g_quality_1_no_issue_bar
      title: "Quality 1/3 — Failed / Blocked Not Linked to an Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.tc_domain]
      measures: [green_dim_tc.failed_blocked_without_issue_tc_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 0
      width: 8
      height: 8

    - name: g_quality_1_closed_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Closed Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.tc_domain]
      measures: [green_dim_tc.failed_blocked_closed_issue_tc_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 8
      width: 8
      height: 8

    - name: g_quality_1_derogated_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Derogated Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.tc_domain]
      measures: [green_dim_tc.failed_blocked_derogated_issue_tc_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 0
      col: 16
      width: 8
      height: 8

    - name: g_quality_1_detailed_view_grid
      title: "Quality 1/3 — Failed / Blocked & Issue Linkage Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_dim_tc.tc_id,
        green_dim_tc.tc_domain,
        green_tr_ranked_derived.last_run_tr_id,
        green_tr_ranked_derived.last_run_result,
        green_dim_tc.qua_tr_without_issues,
        green_dim_issues.issue_id,
        green_dim_issues.issue_status,
        green_dim_issues.issue_criticity
      ]
      filters:
        green_tr_ranked_derived.is_dynamic_last_run: "yes"
        green_tr_ranked_derived.last_run_result: "Failed, Blocked"
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8

    - name: g_quality_2_tc_not_in_ts_bar
      title: "Quality 2/3 — TC Not in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.tc_domain]
      measures: [green_dim_tc.tc_not_in_ts_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 16
      col: 0
      width: 12
      height: 8

    - name: g_quality_2_tc_not_ready_bar
      title: "Quality 2/3 — TC Not Ready in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.tc_domain]
      measures: [green_dim_tc.tc_not_ready_in_ts_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 16
      col: 12
      width: 12
      height: 8

    - name: g_quality_2_detailed_view_grid
      title: "Quality 2/3 — TC Not in a TS / Not Ready Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_dim_tc.tc_id,
        green_dim_tc.tc_name,
        green_dim_tc.tc_status,
        green_dim_tc.tc_domain,
        green_bridge_tc_ts.ts_id,
        green_dim_tc.qua_tc_in_ts,
        green_dim_tc.qua_tc_not_ready
      ]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 24
      col: 0
      width: 24
      height: 8

    # TAB 5: QUALITY 3/3
    - name: g_quality_3_dynamic_crosstable
      title: "Quality 3/3 — Dynamic CrossTable (RowsAxis x ColumnAxis x ItemsCount)"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [green_dim_tc.dynamic_rows_axis, green_dim_tc.dynamic_column_axis]
      pivots: [green_dim_tc.dynamic_column_axis]
      measures: [green_dim_tc.dynamic_items_unique_count]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
        items_count_selector: green_dim_tc.items_count_selector
      row: 0
      col: 0
      width: 24
      height: 8

    - name: g_quality_3_all_data_grid
      title: "All Data - Detailed View (Green Layer)"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      model: ampere_sdv_green_layer
      explore: sdv_tc_runs_green_layer
      dimensions: [
        green_dim_tc.tc_id,
        green_dim_tc.tc_name,
        green_dim_tc.tc_status,
        green_dim_tc.tc_domain,
        green_bridge_tc_ts.ts_id,
        green_dim_ts.ts_vehicle_project,
        green_ts_baseline.ts_baseline,
        green_fact_tr.tr_id,
        green_fact_tr.tr_result,
        green_fact_tr.tr_run_week,
        green_bridge_req_tc_feature.req_id,
        green_req_baseline.req_baseline,
        green_req_mysf.req_mysf,
        green_dim_issues.issue_id
      ]
      listen:
        vehicle_project: green_dim_ts.ts_vehicle_project
        tc_domain: green_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8
