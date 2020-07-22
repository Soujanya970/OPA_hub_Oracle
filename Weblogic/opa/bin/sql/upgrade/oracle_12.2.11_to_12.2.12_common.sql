-- 12.2.12 upgrade script for Oracle
-- delim /
create or replace procedure opa_create_obj_if_not_exists (
	objectDef IN VARCHAR2
) as
begin
  declare
    object_exists exception;
    pragma exception_init (object_exists, -955);
  begin
	  execute immediate objectDef;
  exception
    when object_exists then null;
  end;
end; 
/

create or replace procedure opa_add_column_if_not_exists (
    tableName IN VARCHAR2,
    colName IN VARCHAR2,
    colDef IN VARCHAR2
) as
begin 
  declare
    column_exists exception;
    pragma exception_init (column_exists , -01430);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' ADD ' || colName || ' ' || colDef;
  exception 
    when column_exists then null;
  end;
end;
/

create or replace procedure opa_add_index_if_not_exists (
  tableName in varchar2,
  indexName in varchar2,
  indexDef in varchar2
) as
  begin
    declare
      index_exists exception;
      cols_already_indexed exception;
      pragma exception_init (index_exists, -955);
      pragma exception_init (cols_already_indexed, -1408);
    begin
	  execute immediate 'CREATE INDEX ' || indexName || ' ON ' || tableName || ' ' || indexDef;
	exception
	  when index_exists then null;
	  when cols_already_indexed then null;
	end;
  end;
/

create or replace procedure opa_drop_table_if_exists (
  tableName IN VARCHAR2
) as
  begin
    execute immediate 'DROP TABLE ' || tableName;
    exception
    when others then
    if SQLCODE != -942 then
      RAISE;
    end if;
  end;
/

create or replace procedure opa_drop_sequence_if_exists (
  seqName IN VARCHAR2
) as
  begin
    execute immediate 'DROP SEQUENCE ' || seqName;
    exception
    when others then
    if SQLCODE != -2289 then
      RAISE;
    end if;
  end;
/

create or replace procedure opa_create_func_stats_table as
begin
  declare 
    tbl LONG;
    idx LONG;
    seq LONG;
  begin
	tbl := 'CREATE TABLE FUNCTION_STATS_LOG (function_stats_log_id NUMBER(9) NOT NULL, deployment_id NUMBER(9) NOT NULL, product_code NUMBER(9) NOT NULL, product_function_code NUMBER(9) NOT NULL, product_function_version VARCHAR(25) NOT NULL, last_used_timestamp DATE NOT NULL, CONSTRAINT FUNCTION_STATS_LOG_PK PRIMARY KEY (function_stats_log_id), CONSTRAINT FUNCTION_STATS_LOG_UQ UNIQUE (deployment_id, product_code, product_function_code, product_function_version), CONSTRAINT FUNCTION_STATS_DEPLOY_FK FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id) ) ';
	idx := 'CREATE INDEX FUNCTION_USAGE_OBSOLETE_IDX ON FUNCTION_STATS_LOG(last_used_timestamp, product_code, product_function_code, product_function_version, deployment_id) ';
	seq := 'CREATE SEQUENCE function_stats_log_seq START WITH 1 INCREMENT BY 1';
	
	opa_create_obj_if_not_exists(tbl);
	opa_create_obj_if_not_exists(idx);
	opa_create_obj_if_not_exists(seq);
  end;
end;
/

-- delim ;

-- Add new column

CALL opa_add_column_if_not_exists('AUTHENTICATION', 'last_locked_timestamp', 'DATE NULL');


-- Add new configuration properties
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public)
	(SELECT 'pwd_invalidLockMinutes', 0, 1, 0 FROM DUAL
		WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='pwd_invalidLockMinutes'));

CALL opa_add_column_if_not_exists('DEPLOYMENT', 'activated_interviewservice', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('DEPLOYMENT_ACTIVATION_HISTORY', 'status_interviewservice', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('DEPLOYMENT_CHANNEL_DEFAULT', 'default_interviewservice', 'NUMBER(5) DEFAULT 0 NOT NULL');

-- update data for deployments
UPDATE DEPLOYMENT
	SET activated_interviewservice = 1
	WHERE activated_webservice = 1;

UPDATE DEPLOYMENT_ACTIVATION_HISTORY
	SET status_interviewservice = 1
	WHERE status_webservice = 1;

UPDATE DEPLOYMENT_CHANNEL_DEFAULT
	SET default_interviewservice = 1
	WHERE default_webservice = 1;

-- table for Auditing
CALL opa_create_obj_if_not_exists('CREATE TABLE AUDIT_LOG ( audit_id NUMBER(9) NOT NULL, audit_date DATE NOT NULL, auth_id NUMBER(9) NULL, auth_name VARCHAR(100 CHAR) NULL, description CLOB NULL, object_type VARCHAR(50 CHAR) NULL, object_id NUMBER(9) NULL, operation VARCHAR(50 CHAR) NULL, result NUMBER(9) NULL, extension CLOB NULL, CONSTRAINT audit_primary_key PRIMARY KEY (audit_id)) ');
CALL opa_create_obj_if_not_exists('CREATE INDEX audit_date_idx ON AUDIT_LOG(audit_date) ');
CALL opa_create_obj_if_not_exists('CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1');
	
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'audit_enabled', 1, 1, 1,  '0 = disabled, 1 = enabled. Enabling turns on the audit writing' FROM DUAL
		WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='audit_enabled'));

-- Create new table for functional statistics
CALL opa_create_func_stats_table();		
