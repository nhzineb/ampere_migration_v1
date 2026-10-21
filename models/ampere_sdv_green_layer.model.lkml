# ==============================================================================
# MODEL: ampere_sdv_green_layer.model.lkml (Experiment 2 — Green Layer)
# ==============================================================================

connection: "default_bigquery_connection"
label: "Ampere SDV IVV — Experiment 2 (Green Layer)"

include: "/explores/sdv_tc_runs_green_layer.explore.lkml"
include: "/dashboards/sdv_tc_runs_green_layer.dashboard.lookml"
