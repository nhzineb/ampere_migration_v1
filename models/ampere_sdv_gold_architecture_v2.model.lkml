# ==============================================================================
# MODEL: ampere_sdv_gold_architecture_v2.model.lkml
# Gold Architecture v2 — strict many_to_one, 4 governed Explores
# ==============================================================================

connection: "default_bigquery_connection"
label: "Ampere SDV IVV — Gold Architecture v2 (strict N:1, 4 Explores)"

include: "/explores/sdv_gold_architecture_v2.explore.lkml"
include: "/dashboards/sdv_gold_v2_overview.dashboard.lookml"
