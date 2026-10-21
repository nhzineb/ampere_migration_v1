# ==============================================================================
# STAGE 4: EXPERIMENT 1 (YELLOW LAYER) LOOKER NATIVE TABBED DASHBOARD
# (dashboards/sdv_tc_runs_yellow_layer.dashboard.lookml)
# ==============================================================================

- dashboard: sdv_tc_runs_yellow_layer
  title: "Experiment 1 — SDV TC Runs (Yellow Layer Star Schema)"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Experiment 1: Migrated from Spotfire SDV_TC_Runs__Foundation.dxp using the Yellow Layer tables (New_Core_Init + 4 LV5 Yellow helpers joined to normalized TC, TS, Req, and Automation dimensions)."

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
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      field: yellow_dim_ts.ts_vehicle_project
      ui_config:
        type: tag_list
        display: popover

    - name: tc_domain
      title: "TC Domain"
      type: field_filter
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      field: yellow_dim_tc.tc_domain
      ui_config:
        type: tag_list
        display: popover

    - name: horizontal_axis_selector
      title: "Horizontal Axis (Spotfire tr.horizontalAxis)"
      type: field_filter
      default_value: "ts_vehicle_project"
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      field: yellow_core_init.tr_horizontal_axis_selector
      ui_config:
        type: dropdown_menu
        display: inline

    - name: items_count_selector
      title: "Items Count Metric (Spotfire ItemsCount)"
      type: field_filter
      default_value: "ts_id"
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      field: yellow_core_init.items_count_selector
      ui_config:
        type: dropdown_menu
        display: inline

  elements:
    # TAB 1: TC LAST RUNS Results
    - name: y_last_runs_results_bar
      title: "LAST Runs Results (by Dynamic Axis)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_core_init.dynamic_horizontal_axis]
      measures: [
        yellow_core_init.last_run_passed_tc_count,
        yellow_core_init.last_run_failed_tc_count,
        yellow_core_init.last_run_blocked_tc_count,
        yellow_core_init.last_run_not_executed_tc_count
      ]
      stacking: normal
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
        horizontal_axis_selector: yellow_core_init.tr_horizontal_axis_selector
      row: 0
      col: 0
      width: 12
      height: 8

    - name: y_last_runs_results_pie
      title: "LAST Runs Results (Share by Status)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_pie
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dynamic_last_run.last_run_result]
      measures: [yellow_core_init.last_run_total_tc_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 12
      width: 6
      height: 8

    - name: y_last_run_week_bar
      title: "Last Run Week Evolution"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dynamic_last_run.last_run_week, yellow_dynamic_last_run.last_run_result]
      pivots: [yellow_dynamic_last_run.last_run_result]
      measures: [yellow_core_init.last_run_total_tc_count]
      stacking: normal
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 18
      width: 6
      height: 8

    - name: y_last_runs_detailed_view_grid
      title: "LAST Runs Results - Detailed View (Yellow Layer)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_name,
        yellow_dim_tc.tc_domain,
        yellow_core_init.ts_id,
        yellow_dim_ts.ts_vehicle_project,
        yellow_dynamic_last_run.last_run_tr_id,
        yellow_dynamic_last_run.last_run_result,
        yellow_dynamic_last_run.last_run_week
      ]
      measures: [yellow_core_init.failed_last_run_issues_list]
      filters:
        yellow_dynamic_last_run.is_dynamic_last_run: "yes"
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8

    # TAB 2: TC ALL & First Runs
    - name: y_all_runs_week_bar
      title: "All Runs per Week (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_core_init.tr_run_week, yellow_core_init.tr_result]
      pivots: [yellow_core_init.tr_result]
      measures: [yellow_core_init.unique_tr_count]
      stacking: normal
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 0
      width: 9
      height: 8

    - name: y_first_runs_week_bar
      title: "First Runs per Week (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_core_init.tr_run_week, yellow_core_init.tr_result]
      pivots: [yellow_core_init.tr_result]
      measures: [yellow_core_init.unique_tc_count]
      filters:
        yellow_core_init.is_first_run: "yes"
      stacking: normal
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 9
      width: 9
      height: 8

    - name: y_first_runs_pie
      title: "First Runs Breakdown (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_pie
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_core_init.tr_result]
      measures: [yellow_core_init.unique_tc_count]
      filters:
        yellow_core_init.is_first_run: "yes"
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 18
      width: 6
      height: 8

    - name: y_all_runs_detailed_view_grid
      title: "ALL Runs Results - Detailed View (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tr_id,
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_name,
        yellow_core_init.ts_id,
        yellow_core_init.tr_result,
        yellow_core_init.tr_run_date,
        yellow_core_init.issue_id
      ]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 8
      col: 0
      width: 12
      height: 8

    - name: y_first_runs_detailed_view_grid
      title: "First Runs Results - Detailed View (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_name,
        yellow_core_init.tr_id,
        yellow_core_init.tr_result,
        yellow_core_init.tr_run_week
      ]
      filters:
        yellow_core_init.is_first_run: "yes"
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 8
      col: 12
      width: 12
      height: 8

    # TAB 3: Automation & Runs
    - name: y_auto_req_in_ts_bar
      title: "TC with an Auto Request in a TS or not"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_core_init.auto_ts_runs, yellow_dim_tc.tc_domain]
      pivots: [yellow_core_init.auto_ts_runs]
      measures: [yellow_core_init.unique_tc_count]
      filters:
        yellow_dim_auto_requests.automation_id: "NOT NULL"
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 0
      width: 12
      height: 8

    - name: y_auto_req_last_runs_bar
      title: "LAST Runs Results for TC with an Auto Request"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dim_tc.tc_domain]
      measures: [
        yellow_core_init.last_run_passed_tc_count,
        yellow_core_init.last_run_failed_tc_count,
        yellow_core_init.last_run_blocked_tc_count
      ]
      filters:
        yellow_dim_auto_requests.automation_id: "NOT NULL"
      stacking: normal
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 12
      width: 12
      height: 8

    - name: y_auto_requests_detailed_view_grid
      title: "Automation Requests - Detailed View"
      tab_name: tab_3_automation_and_runs
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_name,
        yellow_dim_auto_requests.automation_id,
        yellow_core_init.auto_ts_runs,
        yellow_dim_tc.tc_type,
        yellow_dim_tc.tc_domain
      ]
      filters:
        yellow_dim_auto_requests.automation_id: "NOT NULL"
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8

    # TAB 4: QUALITY 1/3 & 2/3
    - name: y_quality_1_no_issue_bar
      title: "Quality 1/3 — Failed / Blocked Not Linked to an Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dim_tc.tc_domain]
      measures: [yellow_core_init.failed_blocked_without_issue_tc_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 0
      width: 8
      height: 8

    - name: y_quality_1_closed_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Closed Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dim_tc.tc_domain]
      measures: [yellow_core_init.failed_blocked_closed_issue_tc_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 8
      width: 8
      height: 8

    - name: y_quality_1_derogated_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Derogated Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dim_tc.tc_domain]
      measures: [yellow_core_init.failed_blocked_derogated_issue_tc_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 0
      col: 16
      width: 8
      height: 8

    - name: y_quality_1_detailed_view_grid
      title: "Quality 1/3 — Failed / Blocked & Issue Linkage Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_domain,
        yellow_dynamic_last_run.last_run_tr_id,
        yellow_dynamic_last_run.last_run_result,
        yellow_core_init.qua_tr_without_issues,
        yellow_core_init.issue_id,
        yellow_core_init.issue_status,
        yellow_core_init.issue_criticity,
        yellow_tr_nb_issues_closed.tr_nb_issues_closed,
        yellow_tr_nb_issues_invalid.tr_nb_issues_invalid
      ]
      filters:
        yellow_dynamic_last_run.is_dynamic_last_run: "yes"
        yellow_dynamic_last_run.last_run_result: "Failed, Blocked"
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8

    - name: y_quality_2_tc_not_in_ts_bar
      title: "Quality 2/3 — TC Not in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dim_tc.tc_domain]
      measures: [yellow_core_init.tc_not_in_ts_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 16
      col: 0
      width: 12
      height: 8

    - name: y_quality_2_tc_not_ready_bar
      title: "Quality 2/3 — TC Not Ready in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_dim_tc.tc_domain]
      measures: [yellow_core_init.tc_not_ready_in_ts_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 16
      col: 12
      width: 12
      height: 8

    - name: y_quality_2_detailed_view_grid
      title: "Quality 2/3 — TC Not in a TS / Not Ready Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_name,
        yellow_dim_tc.tc_status,
        yellow_dim_tc.tc_domain,
        yellow_core_init.ts_id,
        yellow_core_init.qua_tc_in_ts,
        yellow_core_init.qua_tc_not_ready,
        yellow_tc_already_in_ts.tc_already_in_ts
      ]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 24
      col: 0
      width: 24
      height: 8

    # TAB 5: QUALITY 3/3
    - name: y_quality_3_dynamic_crosstable
      title: "Quality 3/3 — Dynamic CrossTable (RowsAxis x ColumnAxis x ItemsCount)"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [yellow_core_init.dynamic_rows_axis, yellow_core_init.dynamic_column_axis]
      pivots: [yellow_core_init.dynamic_column_axis]
      measures: [yellow_core_init.dynamic_items_unique_count]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
        items_count_selector: yellow_core_init.items_count_selector
      row: 0
      col: 0
      width: 24
      height: 8

    - name: y_quality_3_all_data_grid
      title: "All Data - Detailed View (Yellow Layer)"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      model: ampere_sdv_yellow_layer
      explore: sdv_tc_runs_yellow_layer
      dimensions: [
        yellow_core_init.tc_id,
        yellow_dim_tc.tc_name,
        yellow_dim_tc.tc_status,
        yellow_dim_tc.tc_domain,
        yellow_core_init.ts_id,
        yellow_dim_ts.ts_vehicle_project,
        yellow_core_init.tr_id,
        yellow_core_init.tr_result,
        yellow_core_init.tr_run_week,
        yellow_core_init.req_id,
        yellow_core_init.issue_id
      ]
      listen:
        vehicle_project: yellow_dim_ts.ts_vehicle_project
        tc_domain: yellow_dim_tc.tc_domain
      row: 8
      col: 0
      width: 24
      height: 8
