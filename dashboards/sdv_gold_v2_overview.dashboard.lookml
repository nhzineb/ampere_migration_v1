- dashboard: sdv_gold_v2_overview
  title: "Ampere SDV IVV — Gold Architecture v2 (Traceability · Execution · History · Defects)"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "4-Explore governed dashboard on the strict many_to_one Gold v2 model."

  tabs:
    - name: tab_traceability
      label: "1. Traceability & Coverage"
    - name: tab_execution
      label: "2. Campaign Latest Run & Trends"
    - name: tab_history
      label: "3. Weekly Status History"
    - name: tab_defects
      label: "4. Defects"

  filters:
    - name: vehicle_project
      title: "Vehicle Project (Test Set)"
      type: field_filter
      allow_multiple_values: true
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      field: g2_dim_test_set.ts_vehicle_project
    - name: tc_domain
      title: "Test Case Domain"
      type: field_filter
      allow_multiple_values: true
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      field: g2_dim_test_case.tc_domain
    - name: req_mysf
      title: "Requirement MySF"
      type: field_filter
      allow_multiple_values: true
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_traceability_coverage
      field: g2_dim_requirement.req_mysf
    - name: snapshot_range
      title: "Snapshot Range"
      type: field_filter
      default_value: "12 weeks"
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_status_history
      field: g2_fact_entity_weekly_snapshot.snapshot_date

  elements:
    # ---------------- TAB 1 — TRACEABILITY ----------------
    - name: kpi_coverage_rate
      title: "Requirement Coverage Rate"
      tab: tab_traceability
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_traceability_coverage
      type: single_value
      fields: [g2_fact_req_tc_traceability.coverage_rate, g2_fact_req_tc_traceability.covered_requirements, g2_fact_req_tc_traceability.total_requirements]
      listen: { req_mysf: g2_dim_requirement.req_mysf, tc_domain: g2_dim_test_case.tc_domain }
      row: 0
      col: 0
      width: 8
      height: 4
    - name: kpi_uncovered
      title: "Uncovered Requirements"
      tab: tab_traceability
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_traceability_coverage
      type: single_value
      fields: [g2_fact_req_tc_traceability.uncovered_requirements]
      listen: { req_mysf: g2_dim_requirement.req_mysf }
      row: 0
      col: 8
      width: 8
      height: 4
    - name: kpi_orphan_tcs
      title: "Orphan Test Cases"
      tab: tab_traceability
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_traceability_coverage
      type: single_value
      fields: [g2_fact_req_tc_traceability.orphan_test_cases]
      listen: { tc_domain: g2_dim_test_case.tc_domain }
      row: 0
      col: 16
      width: 8
      height: 4
    - name: chart_coverage_by_mysf_asil
      title: "Coverage by MySF & ASIL"
      tab: tab_traceability
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_traceability_coverage
      type: looker_column
      fields: [g2_dim_requirement.req_mysf, g2_dim_requirement.req_asil, g2_fact_req_tc_traceability.covered_requirements, g2_fact_req_tc_traceability.uncovered_requirements]
      pivots: [g2_dim_requirement.req_asil]
      stacking: normal
      listen: { req_mysf: g2_dim_requirement.req_mysf }
      row: 4
      col: 0
      width: 24
      height: 8

    # ---------------- TAB 2 — EXECUTION ----------------
    - name: kpi_exec_rate
      title: "Campaign Execution Rate"
      tab: tab_execution
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      type: single_value
      fields: [g2_fact_tc_ts_execution.campaign_execution_rate, g2_fact_tc_ts_execution.latest_executed]
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain, req_mysf: g2_dim_test_case.req_mysf_filter }
      row: 0
      col: 0
      width: 8
      height: 4
    - name: kpi_pass_rate
      title: "Campaign Pass Rate"
      tab: tab_execution
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      type: single_value
      fields: [g2_fact_tc_ts_execution.campaign_pass_rate, g2_fact_tc_ts_execution.latest_passed]
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain, req_mysf: g2_dim_test_case.req_mysf_filter }
      row: 0
      col: 8
      width: 8
      height: 4
    - name: kpi_regressions
      title: "Regression Runs"
      tab: tab_execution
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      type: single_value
      fields: [g2_fact_tc_ts_execution.regression_runs]
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain }
      row: 0
      col: 16
      width: 8
      height: 4
    - name: chart_latest_by_domain
      title: "Latest Run Status by TC Domain (TC x TS)"
      tab: tab_execution
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      type: looker_bar
      fields: [g2_dim_test_case.tc_domain, g2_fact_tc_ts_execution.latest_passed, g2_fact_tc_ts_execution.latest_failed, g2_fact_tc_ts_execution.latest_blocked, g2_fact_tc_ts_execution.latest_not_run]
      stacking: normal
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain, req_mysf: g2_dim_test_case.req_mysf_filter }
      row: 4
      col: 0
      width: 12
      height: 8
    - name: chart_runs_by_week
      title: "Test Runs & Regressions by Week"
      tab: tab_execution
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_test_execution
      type: looker_column
      fields: [g2_fact_tc_ts_execution.tr_run_week, g2_fact_tc_ts_execution.total_test_runs, g2_fact_tc_ts_execution.regression_runs]
      sorts: [g2_fact_tc_ts_execution.tr_run_week]
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain }
      row: 4
      col: 12
      width: 12
      height: 8

    # ---------------- TAB 3 — HISTORY ----------------
    - name: chart_tc_status_history
      title: "Test Case Status by Week"
      tab: tab_history
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_status_history
      type: looker_area
      fields: [g2_fact_entity_weekly_snapshot.snapshot_week, g2_fact_entity_weekly_snapshot.simplified_status, g2_fact_entity_weekly_snapshot.test_cases]
      pivots: [g2_fact_entity_weekly_snapshot.simplified_status]
      filters: { g2_fact_entity_weekly_snapshot.entity_type: "TC" }
      stacking: normal
      listen: { snapshot_range: g2_fact_entity_weekly_snapshot.snapshot_date, tc_domain: g2_fact_entity_weekly_snapshot.domain }
      row: 0
      col: 0
      width: 12
      height: 8
    - name: chart_req_status_history
      title: "Requirement Status by Week"
      tab: tab_history
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_status_history
      type: looker_area
      fields: [g2_fact_entity_weekly_snapshot.snapshot_week, g2_fact_entity_weekly_snapshot.simplified_status, g2_fact_entity_weekly_snapshot.requirements]
      pivots: [g2_fact_entity_weekly_snapshot.simplified_status]
      filters: { g2_fact_entity_weekly_snapshot.entity_type: "REQ" }
      stacking: normal
      listen: { snapshot_range: g2_fact_entity_weekly_snapshot.snapshot_date, req_mysf: g2_fact_entity_weekly_snapshot.mysf }
      row: 0
      col: 12
      width: 12
      height: 8

    # ---------------- TAB 4 — DEFECTS ----------------
    - name: kpi_open_issues
      title: "Open Issues on Latest Runs"
      tab: tab_defects
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_defects
      type: single_value
      fields: [g2_dim_issue.open_issues]
      filters: { g2_fact_tr_issue.is_last_run_in_ts: "Yes" }
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain }
      row: 0
      col: 0
      width: 8
      height: 4
    - name: chart_issues_by_criticity
      title: "Issues by Criticity & Status"
      tab: tab_defects
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_defects
      type: looker_column
      fields: [g2_dim_issue.issue_criticity, g2_dim_issue.issue_status, g2_fact_tr_issue.distinct_issues]
      pivots: [g2_dim_issue.issue_status]
      stacking: normal
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain }
      row: 0
      col: 8
      width: 16
      height: 8
    - name: table_defects_detail
      title: "Defects on Failed Latest Runs"
      tab: tab_defects
      model: ampere_sdv_gold_architecture_v2
      explore: sdv_defects
      type: looker_grid
      fields: [g2_dim_test_set.ts_vehicle_project, g2_dim_test_set.ts_name, g2_dim_test_case.tc_uid, g2_dim_test_case.tc_name, g2_fact_tr_issue.tr_result, g2_dim_issue.issue_id, g2_dim_issue.issue_summary, g2_dim_issue.issue_criticity, g2_dim_issue.issue_status, g2_dim_issue.issue_fix_version]
      filters: { g2_fact_tr_issue.is_last_run_in_ts: "Yes", g2_fact_tr_issue.tr_result: "Failed,Blocked" }
      listen: { vehicle_project: g2_dim_test_set.ts_vehicle_project, tc_domain: g2_dim_test_case.tc_domain }
      row: 8
      col: 0
      width: 24
      height: 8
