# ==============================================================================
# MODEL: ampere_sdv_gold_architecture.model.lkml
# Gold Canonical Architecture — 2 Decoupled Explores (Traceability + Execution)
# ==============================================================================

connection: "default_bigquery_connection"
label: "Ampere SDV IVV — Gold Canonical Architecture (2 Explores)"

include: "/explores/sdv_gold_architecture.explore.lkml"
include: "/dashboards/sdv_gold_traceability_and_execution.dashboard.lookml"
