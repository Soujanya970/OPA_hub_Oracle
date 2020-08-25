CALL opa_drop_constraint_if_exists('MODULE_VERSION', 'mv_snapshot_id_fk');
CALL opa_drop_column_if_exists('MODULE_VERSION', 'snapshot_id');
CALL opa_drop_column_if_exists('MODULE_VERSION', 'is_draft');

UPDATE CONFIG_PROPERTY SET config_property_int_value = 2 WHERE config_property_name = 'web_service_api_status' AND config_property_int_value=0;

CALL opa_modify_column_accepts_null('DEPLOYMENT_VERSION', 'snapshot_id');
