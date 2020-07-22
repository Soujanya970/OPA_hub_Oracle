
-- drop procedures in case they already exist
DROP PROCEDURE IF EXISTS OPAAddColumnIfNotExists;
DROP PROCEDURE IF EXISTS OPAAddIndexIfNotExists;
DROP PROCEDURE IF EXISTS OPAAddConstraintIfNotExists;
DROP PROCEDURE IF EXISTS OPADropColumnIfExists;
DROP PROCEDURE IF EXISTS OPADropIndexIfExists;
DROP PROCEDURE IF EXISTS OPARenameColumnIfExists;
DROP PROCEDURE IF EXISTS OPADropForeignKeyIfExists;

DELIMITER ;PROC;

CREATE PROCEDURE OPAAddColumnIfNotExists(
    tableName VARCHAR(64),
    colName VARCHAR(64),
    colDef VARCHAR(2048)
)
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

CREATE PROCEDURE OPADropIndexIfExists(
    tableName VARCHAR(64),
    indexName VARCHAR(128) )
DETERMINISTIC
BEGIN
    DECLARE colExists INT;
    DECLARE dbName VARCHAR(64);
    SELECT database() INTO dbName;

    select COUNT(1) INTO colExists 
        FROM INFORMATION_SCHEMA.STATISTICS 
        WHERE TABLE_SCHEMA = convert(dbName USING utf8) COLLATE utf8_general_ci
            AND TABLE_NAME = convert(tableName USING utf8) COLLATE utf8_general_ci
            AND INDEX_NAME = convert(indexName USING utf8) COLLATE utf8_general_ci;
            
    IF colExists > 0 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' DROP INDEX ' ,indexName);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
    END IF;
END;
;PROC;

CREATE PROCEDURE OPAAddConstraintIfNotExists(
    tableName VARCHAR(64),
    conName VARCHAR(64),
    conDef VARCHAR(2048)
)
BEGIN
    DECLARE conExists INT;
    DECLARE dbName VARCHAR(64);
    
    SELECT database() INTO dbName;
    SELECT COUNT(1) INTO conExists 
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
        WHERE TABLE_SCHEMA = convert(dbName USING utf8) COLLATE utf8_general_ci 
            AND TABLE_NAME = convert(tableName USING utf8) COLLATE utf8_general_ci  
            AND CONSTRAINT_NAME = convert(conName USING utf8) COLLATE utf8_general_ci;
    IF conExists = 0 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' ADD CONSTRAINT ', conName, ' ', conDef);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
    END IF;
END;
;PROC;

CREATE PROCEDURE OPARenameColumnIfExists(
    tableName VARCHAR(64),
    colName VARCHAR(64),
    colNewName VARCHAR(64),
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
    IF colExists = 1 THEN
        SET @sql = CONCAT('ALTER TABLE ', tableName, ' CHANGE ', colName, ' ', colNewName, ' ', colDef);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
    END IF;
END;
;PROC;

CREATE PROCEDURE OPADropForeignKeyIfExists(
	tableName VARCHAR(64),
    fkName VARCHAR(64)
)
DETERMINISTIC
BEGIN
    DECLARE fkExists INT;
    DECLARE dbName VARCHAR(64);
    SELECT database() INTO dbName;
    SELECT COUNT(1) INTO fkExists 
		FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
			WHERE TABLE_SCHEMA = convert(dbName USING utf8) COLLATE utf8_general_ci 
			AND TABLE_NAME = convert(tableName USING utf8) COLLATE utf8_general_ci  
			AND CONSTRAINT_NAME = convert(fkName USING utf8) COLLATE utf8_general_ci
			AND CONSTRAINT_TYPE = 'FOREIGN KEY';
	IF fkExists = 1 THEN
		SET @sql = CONCAT('ALTER TABLE ', tableName, ' DROP FOREIGN KEY ', fkName);
		PREPARE stmt FROM @sql; 
		EXECUTE stmt; 
	END IF;
END;
;PROC;

DELIMITER ;
