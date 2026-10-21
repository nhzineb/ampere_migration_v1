# ==============================================================================
# STAGE 4: LOOKER 26.4+ NATIVE TABBED DASHBOARD
# (dashboards/sdv_tc_runs_foundation.dashboard.lookml)
# Migrated from Spotfire workbook: SDV_TC_Runs__Foundation.dxp
# (All 19 visualizations from the 7 Spotfire Pages consolidated into Looker's
#  maximum 5 native LookML dashboard tabs)
# ==============================================================================

- dashboard: sdv_tc_runs_foundation
  title: "SDV TC Runs — Foundation (Spotfire Migration)"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Migrated from Spotfire SDV_TC_Runs__Foundation.dxp. Replaces Spotfire Pages with Looker native tabs (max 5 tabs per LookML dashboard), Markings (1–3) with Cross-Filtering + bottom Detailed View tables, and Document Properties with LookML parameters."

  # Looker Native Built-In Dashboard Tabs (LookML validator max: 5 tabs)
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
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs_base.ts_vehicle_project
      ui_config:
        type: tag_list
        display: popover

    - name: tc_domain
      title: "TC Domain"
      type: field_filter
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs_base.tc_domain
      ui_config:
        type: tag_list
        display: popover

    - name: ts_milestone
      title: "TS Milestone"
      type: field_filter
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs_base.ts_milestone
      listens_to_filters: [vehicle_project]
      ui_config:
        type: dropdown_menu
        display: inline

    - name: horizontal_axis_selector
      title: "Horizontal Axis (Spotfire tr.horizontalAxis)"
      type: field_filter
      default_value: "ts_vehicle_project"
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs_base.tr_horizontal_axis_selector
      ui_config:
        type: dropdown_menu
        display: inline

    - name: items_count_selector
      title: "Items Count Metric (Spotfire ItemsCount)"
      type: field_filter
      default_value: "ts_id"
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs_base.items_count_selector
      ui_config:
        type: dropdown_menu
        display: inline

  elements:
    # --------------------------------------------------------------------------
    # TAB 1: TC LAST RUNS Results (Spotfire Page 1)
    # --------------------------------------------------------------------------
    - name: last_runs_results_bar
      title: "LAST Runs Results (by Dynamic Axis)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.dynamic_horizontal_axis]
      measures: [
        sdv_tc_runs_base.last_run_passed_tc_count,
        sdv_tc_runs_base.last_run_failed_tc_count,
        sdv_tc_runs_base.last_run_blocked_tc_count,
        sdv_tc_runs_base.last_run_not_executed_tc_count
      ]
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
        horizontal_axis_selector: sdv_tc_runs_base.tr_horizontal_axis_selector
      row: 0
      col: 0
      width: 12
      height: 8

    - name: last_runs_results_pie
      title: "LAST Runs Results (Share by Status)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_pie
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [fact_tc_dynamic_last_run.last_run_result]
      measures: [sdv_tc_runs_base.last_run_total_tc_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 12
      width: 6
      height: 8

    - name: last_run_week_bar
      title: "Last Run Week Evolution"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [fact_tc_dynamic_last_run.last_run_week, fact_tc_dynamic_last_run.last_run_result]
      pivots: [fact_tc_dynamic_last_run.last_run_result]
      measures: [sdv_tc_runs_base.last_run_total_tc_count]
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 18
      width: 6
      height: 8

    - name: last_runs_detailed_view_grid
      title: "LAST Runs Results - Detailed View (Cross-Filtered Details-on-Demand)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_grid
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_name,
        sdv_tc_runs_base.tc_domain,
        sdv_tc_runs_base.ts_id,
        sdv_tc_runs_base.ts_vehicle_project,
        fact_tc_dynamic_last_run.last_run_tr_id,
        fact_tc_dynamic_last_run.last_run_result,
        fact_tc_dynamic_last_run.last_run_week
      ]
      measures: [sdv_tc_runs_base.failed_last_run_issues_list]
      filters:
        fact_tc_dynamic_last_run.is_dynamic_last_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 8
      col: 0
      width: 24
      height: 8

    # --------------------------------------------------------------------------
    # TAB 2: TC ALL & First Runs (Spotfire Pages 2 & 3)
    # --------------------------------------------------------------------------
    - name: all_runs_week_bar
      title: "All Runs per Week (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
     #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tr_run_week, sdv_tc_runs_base.tr_result]
      pivots: [sdv_tc_runs_base.tr_result]
      measures: [sdv_tc_runs_base.unique_tr_count]
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 0
      width: 9
      height: 8

    - name: first_runs_week_bar
      title: "First Runs per Week (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      ##model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tr_run_week, sdv_tc_runs_base.tr_result]
      pivots: [sdv_tc_runs_base.tr_result]
      measures: [sdv_tc_runs_base.unique_tc_count]
      filters:
        sdv_tc_runs_base.is_first_run: "yes"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 9
      width: 9
      height: 8

    - name: first_runs_pie
      title: "First Runs Breakdown (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_pie
      ##model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tr_result]
      measures: [sdv_tc_runs_base.unique_tc_count]
      filters:
        sdv_tc_runs_base.is_first_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 18
      width: 6
      height: 8

    - name: all_runs_detailed_view_grid
      title: "ALL Runs Results - Detailed View (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tr_id,
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_name,
        sdv_tc_runs_base.ts_id,
        sdv_tc_runs_base.tr_result,
        sdv_tc_runs_base.tr_run_date,
        sdv_tc_runs_base.issue_id
      ]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 8
      col: 0
      width: 12
      height: 8

    - name: first_runs_detailed_view_grid
      title: "First Runs Results - Detailed View (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_name,
        sdv_tc_runs_base.tr_id,
        sdv_tc_runs_base.tr_result,
        sdv_tc_runs_base.tr_run_week
      ]
      filters:
        sdv_tc_runs_base.is_first_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 8
      col: 12
      width: 12
      height: 8

    # --------------------------------------------------------------------------
    # TAB 3: Automation & Runs (Spotfire Page 4)
    # --------------------------------------------------------------------------
    - name: auto_req_in_ts_bar
      title: "TC with an Auto Request in a TS or not"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.auto_ts_runs, sdv_tc_runs_base.tc_domain]
      pivots: [sdv_tc_runs_base.auto_ts_runs]
      measures: [sdv_tc_runs_base.unique_tc_count]
      filters:
        sdv_tc_runs_base.automation_id: "-NULL"
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 0
      width: 12
      height: 8

    - name: auto_req_last_runs_bar
      title: "LAST Runs Results for TC with an Auto Request"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tc_domain]
      measures: [
        sdv_tc_runs_base.last_run_passed_tc_count,
        sdv_tc_runs_base.last_run_failed_tc_count,
        sdv_tc_runs_base.last_run_blocked_tc_count
      ]
      filters:
        sdv_tc_runs_base.automation_id: "-NULL"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 12
      width: 12
      height: 8

    - name: auto_requests_detailed_view_grid
      title: "Automation Requests - Detailed View"
      tab_name: tab_3_automation_and_runs
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_name,
        sdv_tc_runs_base.automation_id,
        sdv_tc_runs_base.auto_ts_runs,
        sdv_tc_runs_base.tc_type,
        sdv_tc_runs_base.tc_domain
      ]
      filters:
        sdv_tc_runs_base.automation_id: "-NULL"
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 8
      col: 0
      width: 24
      height: 8

    # --------------------------------------------------------------------------
    # TAB 4: QUALITY 1/3 & 2/3 (Spotfire Pages 5 & 6 — Issues & TS Readiness)
    # --------------------------------------------------------------------------
    - name: quality_1_no_issue_bar
      title: "Quality 1/3 — Failed / Blocked Not Linked to an Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tc_domain]
      measures: [sdv_tc_runs_base.failed_blocked_without_issue_tc_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 0
      width: 8
      height: 8

    - name: quality_1_closed_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Closed Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tc_domain]
      measures: [sdv_tc_runs_base.failed_blocked_closed_issue_tc_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 8
      width: 8
      height: 8

    - name: quality_1_derogated_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Derogated Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tc_domain]
      measures: [sdv_tc_runs_base.failed_blocked_derogated_issue_tc_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 0
      col: 16
      width: 8
      height: 8

    - name: quality_1_detailed_view_grid
      title: "Quality 1/3 — Failed / Blocked & Issue Linkage Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_domain,
        fact_tc_dynamic_last_run.last_run_tr_id,
        fact_tc_dynamic_last_run.last_run_result,
        sdv_tc_runs_base.qua_tr_without_issues,
        sdv_tc_runs_base.issue_id,
        sdv_tc_runs_base.issue_status,
        sdv_tc_runs_base.issue_criticity
      ]
      filters:
        fact_tc_dynamic_last_run.is_dynamic_last_run: "yes"
        fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked"
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 8
      col: 0
      width: 24
      height: 8

    - name: quality_2_tc_not_in_ts_bar
      title: "Quality 2/3 — TC Not in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tc_domain]
      measures: [sdv_tc_runs_base.tc_not_in_ts_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 16
      col: 0
      width: 12
      height: 8

    - name: quality_2_tc_not_ready_bar
      title: "Quality 2/3 — TC Not Ready in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.tc_domain]
      measures: [sdv_tc_runs_base.tc_not_ready_in_ts_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 16
      col: 12
      width: 12
      height: 8

    - name: quality_2_detailed_view_grid
      title: "Quality 2/3 — TC Not in a TS / Not Ready Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_name,
        sdv_tc_runs_base.tc_status,
        sdv_tc_runs_base.tc_domain,
        sdv_tc_runs_base.ts_id,
        sdv_tc_runs_base.qua_tc_in_ts,
        sdv_tc_runs_base.qua_tc_not_ready
      ]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 24
      col: 0
      width: 24
      height: 8

    # --------------------------------------------------------------------------
    # TAB 5: QUALITY 3/3 (Spotfire Page 7 — Dynamic CrossTable & All Data)
    # --------------------------------------------------------------------------
    - name: quality_3_dynamic_crosstable
      title: "Quality 3/3 — Dynamic CrossTable (RowsAxis x ColumnAxis x ItemsCount)"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs_base.dynamic_rows_axis, sdv_tc_runs_base.dynamic_column_axis]
      pivots: [sdv_tc_runs_base.dynamic_column_axis]
      measures: [sdv_tc_runs_base.dynamic_items_unique_count]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
        items_count_selector: sdv_tc_runs_base.items_count_selector
      row: 0
      col: 0
      width: 24
      height: 8

    - name: quality_3_all_data_grid
      title: "All Data - Detailed View"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      #model: ampere_sdv_ivv
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs_base.tc_id,
        sdv_tc_runs_base.tc_name,
        sdv_tc_runs_base.tc_status,
        sdv_tc_runs_base.tc_domain,
        sdv_tc_runs_base.ts_id,
        sdv_tc_runs_base.ts_vehicle_project,
        sdv_tc_runs_base.tr_id,
        sdv_tc_runs_base.tr_result,
        sdv_tc_runs_base.tr_run_week,
        sdv_tc_runs_base.req_id,
        sdv_tc_runs_base.issue_id
      ]
      listen:
        vehicle_project: sdv_tc_runs_base.ts_vehicle_project
        tc_domain: sdv_tc_runs_base.tc_domain
        ts_milestone: sdv_tc_runs_base.ts_milestone
      row: 8
      col: 0
      width: 24
      height: 8
