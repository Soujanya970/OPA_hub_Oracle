-- 12.2.15 upgrade script for Oracle
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

-- delim ;

DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_chat_service_enabled';
DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_webservice_datasource';
DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_analytics_enabled';

CALL opa_create_obj_if_not_exists('CREATE TABLE SESSION_STATS_UID ( '
    || 'session_uid VARCHAR(36) NOT NULL, '
    || 'session_stats_log_id NUMBER(19) NOT NULL, '
    || 'CONSTRAINT SESSION_STATS_UID_PK PRIMARY KEY (session_uid) )');

CALL opa_add_column_if_not_exists('PROJECT_VERSION', 'version_uuid', 'VARCHAR(36) NULL');
CALL opa_add_column_if_not_exists('PROJECT_VERSION', 'activatable', 'SMALLINT DEFAULT 0 NOT NULL');
CALL opa_add_index_if_not_exists('PROJECT_VERSION', 'version_uuid_idx', '(version_uuid)');

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'feature_new_hub_ui', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental New Hub UI' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='feature_new_hub_ui'));
        
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'site_type', 0, 1, 1, 'The site type for this OPA Site. 0=Production, 1=Test, 2=Development' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='site_type'));

-- delim /

begin
   execute immediate 'drop procedure opa_create_func_stats_table';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

-- delim ;