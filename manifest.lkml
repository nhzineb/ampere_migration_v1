# ==============================================================================
# PROJECT MANIFEST (manifest.lkml)
# Central constants for Ampere SDV IVV Spotfire-to-Looker Migration
# ==============================================================================

project_name: "ampere-spotfire-migration"

constant: connection_name {
  value: "default_bigquery_connection"
  export: override_optional
}

constant: gcp_project {
  value: "zineb-sandbox"
  export: override_optional
}

constant: bq_dataset {
  value: "sdv_ivv_gold"
  export: override_optional
}
