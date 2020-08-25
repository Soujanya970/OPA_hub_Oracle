CALL OPADropForeignKeyIfExists('MODULE_VERSION', 'mv_snapshot_id_fk');
CALL OPADropColumnIfExists('MODULE_VERSION', 'snapshot_id');
CALL OPADropColumnIfExists('MODULE_VERSION', 'is_draft');

UPDATE CONFIG_PROPERTY SET config_property_int_value = 2 WHERE config_property_name = 'web_service_api_status' AND config_property_int_value=0;

ALTER TABLE DEPLOYMENT_VERSION CHANGE COLUMN snapshot_id snapshot_id INT(11);
