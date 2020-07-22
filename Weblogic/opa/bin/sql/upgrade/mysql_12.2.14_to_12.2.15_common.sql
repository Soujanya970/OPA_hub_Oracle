-- 12.2.15 data upgrade for MySQL
DROP PROCEDURE IF EXISTS OPAAddColumnIfNotExists;
DROP PROCEDURE IF EXISTS OPAAddIndexIfNotExists;

DELIMITER ;PROC;
CREATE PROCEDURE OPAAddColumnIfNotExists(
    tableName VARCHAR(64),
    colName VARCHAR(64),
    colDef VARCHAR(2048)
)
DETERMINISTIC
BEGIN
    DECLARE colExists INT;
    DECLARE dbName VARCHAR(64);
    SELECT database() INTO dbName;
    SELECT COUNT(1) INTO colExists
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = convert(dbName USING utf8) COLLATE utf8_general_ci
            AND TABLE_NAME = convert(tableName USING utf8) COLLATE utf8_general_ci
            AND COLUMN_NAME = convert(colName USING utf8) COLLATE utf8_general_ci;
    IF colExists = 0 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' ADD COLUMN ', colName, ' ', colDef);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
    END IF;
END;
;PROC;

CREATE PROCEDURE OPAAddIndexIfNotExists(
	tableName VARCHAR(64),
	indexName VARCHAR(64),
	indexDef VARCHAR(2048)
)
DETERMINISTIC
  BEGIN
    DECLARE indexExists INT;
    DECLARE dbName VARCHAR(64);
    SELECT database() INTO dbName;
    
    SELECT COUNT(1) INTO indexExists
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = convert(dbName USING utf8) COLLATE utf8_general_ci
    AND TABLE_NAME = convert(tableName USING utf8) COLLATE utf8_general_ci
    AND INDEX_NAME = convert(indexName USING utf8) COLLATE utf8_general_ci;
    
    IF indexExists = 0 THEN
      SET @sql = CONCAT('ALTER TABLE ', tableName, ' ADD INDEX ', indexName, ' ', indexDef);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
    END IF;
  END;
;PROC;

DELIMITER ;

DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_chat_service_enabled';
DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_webservice_datasource';
DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_analytics_enabled';

CALL OPAAddIndexIfNotExists('PROJECT_VERSION','project_version_project_idx', '(project_id)');
CALL OPAAddIndexIfNotExists('PROJECT_VERSION', 'project_version_snapshot_idx', '(project_snapshot_id)');
CALL OPAAddIndexIfNotExists('DEPLOYMENT_VERSION', 'deployment_version_deployment_idx', '(deployment_id)');
CALL OPAAddIndexIfNotExists('DEPLOYMENT_VERSION', 'deployment_version_snapshot_idx', '(snapshot_id)');
CALL OPAAddIndexIfNotExists('DEPLOYMENT_ACTIVATION_HISTORY', 'deployment_activation_history_deployment_idx', '(deployment_id)');

-- New table for statistics tracking
CREATE TABLE IF NOT EXISTS SESSION_STATS_UID (
    session_uid VARCHAR(36) NOT NULL PRIMARY KEY,
    session_stats_log_id BIGINT NOT NULL
) ENGINE = InnoDB;

-- New column for tracking project versions
CALL OPAAddColumnIfNotExists('PROJECT_VERSION', 'version_uuid', 'VARCHAR(36) NULL');
CALL OPAAddColumnIfNotExists('PROJECT_VERSION', 'activatable', 'SMALLINT DEFAULT 0 NOT NULL');
CALL OPAAddIndexIfNotExists('PROJECT_VERSION', 'version_uuid_idx', '(version_uuid)');

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('feature_new_hub_ui', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental New Hub UI')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('site_type', 0, 1, 1, 'The site type for this OPA Site. 0=Production, 1=Test, 2=Development')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;
