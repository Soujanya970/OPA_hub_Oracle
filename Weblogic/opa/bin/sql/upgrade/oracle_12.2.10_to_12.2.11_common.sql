-- 12.2.11 upgrade script for Oracle
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

-- delim ;

-- Add new column
CALL opa_add_column_if_not_exists('SNAPSHOT', 'fingerprint_sha256', 'VARCHAR2(65 CHAR)');
CALL opa_add_column_if_not_exists('SNAPSHOT', 'scan_status', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('SNAPSHOT', 'scan_message', 'VARCHAR2(255 CHAR)');
CALL opa_add_column_if_not_exists('DEPLOYMENT', 'activated_embedjs', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('DEPLOYMENT_ACTIVATION_HISTORY', 'status_embedjs', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('DEPLOYMENT_CHANNEL_DEFAULT', 'default_embedjs', 'NUMBER(5) DEFAULT 0 NOT NULL');

-- New configuration property
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_str_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'clamd_location', null, 0, 1, 'The clamd location, either local path or TCP socket, for virus scanning deployment or project data.' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='clamd_location'));
