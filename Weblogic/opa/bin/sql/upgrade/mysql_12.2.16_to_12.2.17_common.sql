CALL OPADropColumnIfExists('DEPLOYMENT', 'activated_embedjs');
CALL OPADropColumnIfExists('DEPLOYMENT_ACTIVATION_HISTORY', 'status_embedjs');
CALL OPADropColumnIfExists('DEPLOYMENT_CHANNEL_DEFAULT', 'default_embedjs');

DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_embeddable_models_enabled';

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('osvc_asynchronous_checkpoints', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling will perform set and delete checkpoint operations asynchronously to interview progression')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

-- Flag to skip the duplicate email check in OSvC submits
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('osvc_allow_duplicate_emails', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling will skip email uniqueness checks before Submit')
	ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_str_value, config_property_type, config_property_public, config_property_description)
    VALUES ('osvc_connect_api_version', 'v1_2', 0, 1, 'The version of the Connect API to use for OSvC connections')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

-- RENAME INDEX deployment_version_deployment_idx TO deployment_ver_deployment_idx;
CALL OPADropIndexIfExists('DEPLOYMENT_VERSION', 'deployment_version_deployment_idx');
CALL OPAAddIndexIfNotExists('DEPLOYMENT_VERSION', 'deployment_ver_deployment_idx', '(deployment_id)');

-- RENAME INDEX deployment_version_snapshot_idx TO deployment_ver_snapshot_idx;
CALL OPADropIndexIfExists('DEPLOYMENT_VERSION', 'deployment_version_snapshot_idx');
CALL OPAAddIndexIfNotExists('DEPLOYMENT_VERSION', 'deployment_ver_snapshot_idx', '(snapshot_id)');

-- Change deployment_activation_history_id Primary key field of table
-- This only works because there are no foreign keys to this field
-- NEED A Stored procedure for this.
CALL OPARenameColumnIfExists('DEPLOYMENT_ACTIVATION_HISTORY', 'deployment_activation_history_id', 'deployment_activation_hist_id', 'INT NOT NULL AUTO_INCREMENT');
-- ALTER TABLE DEPLOYMENT_ACTIVATION_HISTORY CHANGE deployment_activation_history_id deployment_activation_hist_id INT NOT NULL AUTO_INCREMENT;

CALL OPADropIndexIfExists('DEPLOYMENT_ACTIVATION_HISTORY', 'deployment_activation_history_deployment_idx');
CALL OPAAddIndexIfNotExists('DEPLOYMENT_ACTIVATION_HISTORY', 'deployment_act_hist_depl_idx', '(deployment_id)');

-- unique constraints become indexes
CALL OPADropIndexIfExists('DEPLOYMENT_RULEBASE_REPOS', 'deployment_rulebase_repos_unique');
CALL OPAAddConstraintIfNotExists('DEPLOYMENT_RULEBASE_REPOS', 'deployment_rb_repos_unique', 'UNIQUE(deployment_version_id, chunk_sequence)');

CALL OPADropIndexIfExists('MODULE', 'module_name_idx');

DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_new_hub_ui';

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('feature_offer_anon_assess', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling allows users to turn off assess authentication')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

CALL OPAAddColumnIfNotExists('MODULE_VERSION', 'snapshot_id', 'INT NULL');
CALL OPAAddColumnIfNotExists('MODULE_VERSION', 'fingerprint_sha256', 'VARCHAR(65) NOT NULL');
CAll OPAAddConstraintIfNotExists('MODULE_VERSION', 'mv_snapshot_id_fk', 'FOREIGN KEY(snapshot_id) REFERENCES SNAPSHOT(snapshot_id)');

ALTER TABLE MODULE_VERSION MODIFY COLUMN version_number INT;

CREATE TABLE IF NOT EXISTS MODULE_COLL (
  module_id INT NOT NULL REFERENCES MODULE(module_id),
  collection_id INT NOT NULL REFERENCES COLLECTION(collection_id),
  CONSTRAINT module_coll_unique_ids UNIQUE (module_id, collection_id)
) Engine=INNODB;

CALL OPAAddColumnIfNotExists('DATA_SERVICE', 'cookie_param', 'varchar(255) CHARACTER SET utf8 NULL');
