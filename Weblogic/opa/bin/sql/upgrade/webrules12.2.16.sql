DROP PROCEDURE IF EXISTS OPADropColumnIfExists;

DELIMITER ;PROC;
CREATE PROCEDURE OPADropColumnIfExists(
    tableName VARCHAR(64),
    colName VARCHAR(64)
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
    IF colExists = 1 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' DROP COLUMN ', colName);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
    END IF;
END;
;PROC;

ALTER TABLE DEPLOYMENT ADD deployment_endpoint VARCHAR(127) CHARACTER SET utf8 NULL;

ALTER TABLE DEPLOYMENT_VERSION MODIFY snapshot_id INT;
ALTER TABLE DEPLOYMENT_VERSION ADD module_version_id INT NULL REFERENCES MODULE_VERSION(module_version_id);
ALTER TABLE DEPLOYMENT_VERSION ADD module_kind CHAR(1) NULL;
ALTER TABLE DEPLOYMENT_VERSION ADD INDEX deployment_version_module_version_idx (module_version_id);

ALTER TABLE MODULE_VERSION ADD fingerprint_sha256 VARCHAR(65) CHARACTER SET utf8 NOT NULL;
ALTER TABLE MODULE_VERSION ADD snapshot_id INT NULL REFERENCES SNAPSHOT(snapshot_id);

CALL OPADropColumnIfExists('MODULE_VERSION', 'is_draft');
ALTER TABLE MODULE_VERSION
  MODIFY COLUMN version_number int(11) DEFAULT NULL;

create table if not exists MODULE_COLL (
    module_id INT NOT NULL references MODULE(module_id) ON DELETE CASCADE,
    collection_id INT NOT NULL references COLLECTION(collection_id) ON DELETE CASCADE,

    CONSTRAINT module_coll_unique_ids UNIQUE(module_id, collection_id)
)  ENGINE=InnoDB;
