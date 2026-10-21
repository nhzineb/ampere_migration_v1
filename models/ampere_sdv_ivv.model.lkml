# ==============================================================================
# MODEL: ampere_sdv_ivv.model.lkml
# ==============================================================================

connection: "default_bigquery_connection"
label: "Ampere SDV IVV — Test Case & Run Traceability"

include: "/explores/sdv_tc_runs_foundation.explore.lkml"
include: "/dashboards/sdv_tc_runs_foundation.dashboard.lookml"
