# ==============================================================================
# MODEL: ampere_sdv_yellow_layer.model.lkml (Experiment 1 — Yellow Layer)
# ==============================================================================

connection: "default_bigquery_connection"
label: "Ampere SDV IVV — Experiment 1 (Yellow Layer)"

include: "/explores/sdv_tc_runs_yellow_layer.explore.lkml"
include: "/dashboards/sdv_tc_runs_yellow_layer.dashboard.lookml"
