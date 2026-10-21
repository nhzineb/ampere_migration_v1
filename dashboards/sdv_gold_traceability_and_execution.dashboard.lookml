- dashboard: sdv_gold_traceability_and_execution
  title: "Ampere SDV IVV — Gold Canonical Architecture (Traceability & Execution)"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Best-practice 2-Explore dashboard combining World 1 (Requirement Traceability & Coverage) and World 2 (Campaign Latest Run, Historical Execution Trends & Defect Drill-down)."

  tabs:
    - name: tab_1_traceability_coverage
      label: "1. World 1 — Requirement Traceability & Coverage"
    - name: tab_2_campaign_latest_run
      label: "2. World 2 — Campaign Latest Run (TC x TS)"
    - name: tab_3_execution_history_and_defects
      label: "3. World 2 — Execution History, Regressions & Defects"

  filters:
    - name: vehicle_project_filter
      title: "Vehicle Project (Test Set)"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      field: gold_dim_test_set.ts_vehicle_project

    - name: tc_domain_filter
      title: "Test Case Domain"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      field: gold_dim_test_case.tc_domain

    - name: req_mysf_filter
      title: "Requirement MySF (System/SW Function)"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      model: ampere_sdv_gold_architecture
      explore: sdv_traceability_coverage
      field: gold_dim_requirement.req_mysf

    - name: horizontal_axis_selector
      title: "Dynamic Horizontal Axis"
      type: field_filter
      default_value: "run_week"
      allow_multiple_values: false
      required: false
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      field: gold_fact_tc_ts_execution.tr_horizontal_axis_selector

  elements:
    # --- WORLD 1: TRACEABILITY & COVERAGE (sdv_traceability_coverage) ---
    - name: kpi_req_coverage_rate
      title: "Requirement Test Coverage Rate (%)"
      model: ampere_sdv_gold_architecture
      explore: sdv_traceability_coverage
      type: single_value
      fields:
        - gold_fact_req_tc_traceability.requirement_coverage_rate
        - gold_fact_req_tc_traceability.covered_requirements_count
        - gold_fact_req_tc_traceability.total_distinct_requirements
      listen:
        req_mysf_filter: gold_dim_requirement.req_mysf
      row: 0
      col: 0
      width: 6
      height: 4

    - name: kpi_uncovered_requirements
      title: "Uncovered Requirements (0 Linked TC)"
      model: ampere_sdv_gold_architecture
      explore: sdv_traceability_coverage
      type: single_value
      fields:
        - gold_fact_req_tc_traceability.uncovered_requirements_count
      listen:
        req_mysf_filter: gold_dim_requirement.req_mysf
      row: 0
      col: 6
      width: 6
      height: 4

    # --- WORLD 2: CAMPAIGN LATEST RUN & EXECUTION (sdv_test_execution) ---
    - name: kpi_campaign_execution_rate
      title: "Campaign Latest Run Execution Rate (%)"
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      type: single_value
      fields:
        - gold_fact_tc_ts_execution.latest_run_execution_rate
        - gold_fact_tc_ts_execution.latest_run_executed_count
      listen:
        vehicle_project_filter: gold_dim_test_set.ts_vehicle_project
        tc_domain_filter: gold_dim_test_case.tc_domain
      row: 0
      col: 12
      width: 6
      height: 4

    - name: kpi_campaign_pass_rate
      title: "Campaign Latest Run Pass Rate (%)"
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      type: single_value
      fields:
        - gold_fact_tc_ts_execution.latest_run_pass_rate
        - gold_fact_tc_ts_execution.latest_run_passed_count
      listen:
        vehicle_project_filter: gold_dim_test_set.ts_vehicle_project
        tc_domain_filter: gold_dim_test_case.tc_domain
      row: 0
      col: 18
      width: 6
      height: 4

    - name: chart_traceability_by_mysf_asil
      title: "World 1 (Traceability) — Requirement Coverage by MySF & ASIL"
      model: ampere_sdv_gold_architecture
      explore: sdv_traceability_coverage
      type: looker_column
      fields:
        - gold_dim_requirement.req_mysf
        - gold_dim_requirement.req_asil
        - gold_fact_req_tc_traceability.covered_requirements_count
        - gold_fact_req_tc_traceability.uncovered_requirements_count
      pivots:
        - gold_dim_requirement.req_asil
      stacking: normal
      listen:
        req_mysf_filter: gold_dim_requirement.req_mysf
      row: 4
      col: 0
      width: 12
      height: 8

    - name: chart_latest_run_by_domain_and_result
      title: "World 2 (Execution Latest Run) — Campaign Status by TC Domain (is_last_run_in_ts = Yes)"
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      type: looker_bar
      fields:
        - gold_dim_test_case.tc_domain
        - gold_fact_tc_ts_execution.latest_run_passed_count
        - gold_fact_tc_ts_execution.latest_run_failed_count
        - gold_fact_tc_ts_execution.latest_run_blocked_count
        - gold_fact_tc_ts_execution.latest_run_not_run_count
      stacking: normal
      listen:
        vehicle_project_filter: gold_dim_test_set.ts_vehicle_project
        tc_domain_filter: gold_dim_test_case.tc_domain
      row: 4
      col: 12
      width: 12
      height: 8

    - name: chart_historical_runs_dynamic_axis
      title: "World 2 (Execution History) — Test Runs & Regressions by Dynamic Axis"
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      type: looker_column
      fields:
        - gold_fact_tc_ts_execution.dynamic_horizontal_axis
        - gold_fact_tc_ts_execution.total_test_runs_count
        - gold_fact_tc_ts_execution.regression_runs_count
      listen:
        vehicle_project_filter: gold_dim_test_set.ts_vehicle_project
        tc_domain_filter: gold_dim_test_case.tc_domain
        horizontal_axis_selector: gold_fact_tc_ts_execution.tr_horizontal_axis_selector
      row: 12
      col: 0
      width: 12
      height: 8

    - name: table_defects_and_regressions
      title: "World 2 (Defects & Regressions) — Failed Latest Runs & Linked Issues"
      model: ampere_sdv_gold_architecture
      explore: sdv_test_execution
      type: looker_grid
      fields:
        - gold_dim_test_set.ts_vehicle_project
        - gold_dim_test_set.ts_name
        - gold_dim_test_case.tc_uid
        - gold_dim_test_case.tc_name
        - gold_fact_tc_ts_execution.tr_result
        - gold_fact_tc_ts_execution.tr_regression
        - gold_fact_tc_ts_execution.total_closed_issues_on_latest_runs
        - gold_fact_tc_ts_execution.total_invalid_issues_on_latest_runs
        - gold_dim_issue.distinct_issues_count
      filters:
        gold_fact_tc_ts_execution.is_last_run_in_ts: "Yes"
      listen:
        vehicle_project_filter: gold_dim_test_set.ts_vehicle_project
        tc_domain_filter: gold_dim_test_case.tc_domain
      row: 12
      col: 12
      width: 12
      height: 8
