-- 12.2.16 data upgrade for MySQL
DROP PROCEDURE IF EXISTS OPAAddColumnIfNotExists;

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

DELIMITER ;


CREATE TABLE IF NOT EXISTS RULE_ELEMENT (
    rule_element_id INT NOT NULL AUTO_INCREMENT,
    rule_element_name VARCHAR(255) CHARACTER SET UTF8 NOT NULL,
    CONSTRAINT RULE_ELEMENT_PK PRIMARY KEY (rule_element_id),
    CONSTRAINT RULE_ELEMENT_UQ UNIQUE KEY (rule_element_name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RULE_ELEMENT_STATS_LOG (
    rule_element_stats_log_id INT NOT NULL AUTO_INCREMENT,
    rule_element_id INT NOT NULL REFERENCES RULE_ELEMENT (rule_element_id),
    deployment_id INT NOT NULL,
    deployment_version_id INT NOT NULL,
    reference_count INT NOT NULL,
    CONSTRAINT RULE_ELEMENT_STATS_LOG_PK PRIMARY KEY (rule_element_stats_log_id),
    CONSTRAINT RULE_ELEMENT_STATS_LOG_UQ UNIQUE KEY (rule_element_id, deployment_id, deployment_version_id),
    INDEX RULE_ELEMENT_DEPL_VERS_REF_IDX (rule_element_id, deployment_id, deployment_version_id, reference_count)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS OPERATION
(
    operation_id INT NOT NULL AUTO_INCREMENT,
    operation_name VARCHAR(255) CHARACTER SET UTF8 NOT NULL,
    operation_type INT NOT NULL,
    operation_state INT NOT NULL,
    operation_version INT NOT NULL,
    operation_model LONGTEXT CHARACTER SET UTF8 NOT NULL,
    invoke_url VARCHAR(1024) CHARACTER SET UTF8 NULL,
    status_url VARCHAR(1024) CHARACTER SET UTF8 NULL,
    query_param_names VARCHAR(1024) CHARACTER SET UTF8 NULL,
    CONSTRAINT operation_pk PRIMARY KEY (operation_id),
    CONSTRAINT operation_name_unique UNIQUE (operation_name),
    INDEX operation_type_state(operation_type, operation_state)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS DEPLOYMENT_VERSION_OPERATION
(
    deployment_version_id INT NOT NULL REFERENCES DEPLOYMENT_VERSION (deployment_version_id) ON DELETE CASCADE,
    operation_id INT NOT NULL REFERENCES OPERATION (operation_id) ON DELETE CASCADE,
    CONSTRAINT depl_vers_operation_unique UNIQUE (deployment_version_id, operation_id)
) ENGINE=InnoDB;


INSERT into CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('db_message_log_enabled', 1, 1, 1, '0 = disabled, 1 = enabled. Enable logging to LOG_ENTRY table')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('feature_auto_data_maintenance', 1, 1, 1, '0 = disabled, 1 = enabled. Enabling turns on the Auto Data Maintenance feature')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

CALL OPAAddColumnIfNotExists('DATA_SERVICE', 'assoc_client_id', 'INT NULL');
CAll OPAAddConstraintIfNotExists('DATA_SERVICE', 'data_service_client_id_fk', 'FOREIGN KEY(assoc_client_id) REFERENCES AUTHENTICATION(authentication_id)');
