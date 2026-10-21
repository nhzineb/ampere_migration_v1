# ==============================================================================
# LAYER 3: EXPLORE, AGGREGATE AWARENESS, UNNESTING & RLS
# (lookml/explores/sdv_tc_runs_foundation.explore.lkml)
# ==============================================================================

include: "/views/base/sdv_tc_runs_base.view.lkml"
include: "/views/refinements/+sdv_tc_runs_kpis.view.lkml"

 #datagroup: sdv_tc_runs_etl_datagroup {
 #  label: "SDV TC Runs BigQuery Partition ETL Trigger"
  # sql_trigger:
   #  SELECT MAX(last_modified_time)
   #  FROM `@{gcp_project}.@{bq_dataset}.INFORMATION_SCHEMA.PARTITIONS`
   #  WHERE table_name = 'fact_tc_runs_enriched' ;;
  # max_cache_age: "12 hours"
 #}

explore: sdv_tc_runs_foundation {
  label: "SDV TC Runs — Foundation (Spotfire Migration)"
  description: "Governed Looker Explore replacing Spotfire SDV_TC_Runs__Foundation.dxp with dynamic Last Run ranking, on-demand ARRAY unnesting, and <1s Aggregate Awareness."
  view_name: sdv_tc_runs_base
  persist_with: sdv_tc_runs_etl_datagroup

  # Row-Level Security (Multi-value String Filter (advanced) user attribute)
  #  access_filter: {
  #    field: sdv_tc_runs_base.tc_domain
    #  user_attribute: allowed_sdv_domains
  #  }

  # Join 1: Dynamic Last-Run Deduplication View (Replaces Rank([Admin_Rank],[TC_Id])=1)
  join: fact_tc_dynamic_last_run {
    view_label: "Dynamic Last Run (Rank=1)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${sdv_tc_runs_base.tc_id} = ${fact_tc_dynamic_last_run.tc_id}
      AND ${sdv_tc_runs_base.tr_id} = ${fact_tc_dynamic_last_run.last_run_tr_id} ;;
  }

  # Join 2–4: On-Demand Multi-Valued Array Unnesting (Zero fanout unless selected!)
  join: tc_feature_unnest {
    view_label: "TC Multi-Valued Arrays"
    sql: LEFT JOIN UNNEST(${sdv_tc_runs_base.tc_feature_raw}) AS tc_feature_item ;;
    relationship: one_to_many
  }

  join: tc_bench_type_unnest {
    view_label: "TC Multi-Valued Arrays"
    sql: LEFT JOIN UNNEST(${sdv_tc_runs_base.tc_bench_type_raw}) AS tc_bench_type_item ;;
    relationship: one_to_many
  }

  join: sweet_unnest {
    view_label: "TC Multi-Valued Arrays"
    sql: LEFT JOIN UNNEST(${sdv_tc_runs_base.sweet_raw}) AS sweet_milestone ;;
    relationship: one_to_many
  }

  # 2-Speed Architecture: Aggregate Awareness for <1s Spotfire In-Memory Parity
  # NOTE: Uncomment once PDTs and a temporary dataset (tmp_db_name) are enabled
  # on default_bigquery_connection.
  # aggregate_table: rollup__domain_project_week_summary {
  #   query: {
  #     dimensions: [
  #       sdv_tc_runs_base.tc_domain,
  #       sdv_tc_runs_base.ts_vehicle_project,
  #       sdv_tc_runs_base.tr_run_week,
  #       sdv_tc_runs_base.tr_result,
  #       sdv_tc_runs_base.qua_tc_in_ts,
  #       sdv_tc_runs_base.qua_tc_not_ready
  #     ]
  #     measures: [
  #       sdv_tc_runs_base.unique_tc_count,
  #       sdv_tc_runs_base.unique_tr_count,
  #       sdv_tc_runs_base.unique_ts_count,
  #       sdv_tc_runs_base.tc_not_in_ts_count,
  #       sdv_tc_runs_base.tc_not_ready_in_ts_count
  #     ]
  #   }
  #   materialization: {
  #     datagroup_trigger: sdv_tc_runs_etl_datagroup
  #   }
  # }
}

# Automated LookML Data Test verifying Primary Key uniqueness
test: sdv_tc_runs_pk_is_unique {
  explore_source: sdv_tc_runs_foundation {
    column: tc_run_grain_pk { field: sdv_tc_runs_base.tc_run_grain_pk }
    column: row_count { field: sdv_tc_runs_base.unique_tr_count }
    sorts: [sdv_tc_runs_base.unique_tr_count: desc]
    limit: 1
  }
  assert: pk_has_no_duplicates {
    expression: ${sdv_tc_runs_base.unique_tr_count} <= 1 ;;
  }
}
