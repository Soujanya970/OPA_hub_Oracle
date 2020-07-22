-- delim /

create or replace procedure opa_drop_column_if_exists (
    tableName IN VARCHAR2,
    colName IN VARCHAR2
) as
begin 
  declare
    column_not_exists exception;
    pragma exception_init (column_not_exists , -00904);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' DROP COLUMN ' || colName;
  exception 
    when column_not_exists then null;
  end;
end;
/

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

create or replace procedure opa_add_constr_if_not_exists (
    tableName IN VARCHAR2,
    constraintName IN VARCHAR2,
    constraintDecl IN VARCHAR2
) as
begin
  declare
    constraint_exists exception;
    pragma exception_init (constraint_exists , -02275);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' ADD CONSTRAINT ' || constraintName || ' ' || constraintDecl;
  exception
    when constraint_exists then null;
  end;
end;
/

-- delim ;

CALL opa_drop_column_if_exists('DEPLOYMENT', 'activated_embedjs');
CALL opa_drop_column_if_exists('DEPLOYMENT_ACTIVATION_HISTORY', 'status_embedjs');
CALL opa_drop_column_if_exists('DEPLOYMENT_CHANNEL_DEFAULT', 'default_embedjs');

DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_embeddable_models_enabled';

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'osvc_asynchronous_checkpoints', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling will perform set and delete checkpoint operations asynchronously to interview progression' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='osvc_asynchronous_checkpoints'));

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'osvc_allow_duplicate_emails', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling will skip email uniqueness checks before Submit' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='osvc_allow_duplicate_emails'));

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_str_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'osvc_connect_api_version', 'v1_2', 0, 1, 'The version of the Connect API to use for OSvC connections' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='osvc_connect_api_version'));

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'feature_offer_anon_assess', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling allows users to turn off assess authentication' FROM DUAL
     WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='feature_offer_anon_assess'));


ALTER TABLE AUDIT_LOG MODIFY audit_id NUMBER(19);
ALTER TABLE SESSION_STATS_LOG MODIFY last_modified_year NUMBER(19);
ALTER TABLE SESSION_STATS_LOG MODIFY last_modified_month NUMBER(19);

DELETE FROM CONFIG_PROPERTY WHERE config_property_name = 'feature_new_hub_ui';

CALL opa_create_obj_if_not_exists('CREATE TABLE MODULE ('
  || ' module_id NUMBER(9) NOT NULL,'
  || ' module_name VARCHAR2(127 CHAR) NOT NULL,'
  || ' CONSTRAINT module_pk PRIMARY KEY (module_id),'
  || ' CONSTRAINT module_name_unique UNIQUE (module_name) )');
  
CALL opa_create_obj_if_not_exists('CREATE SEQUENCE module_seq START WITH 1 INCREMENT BY 1');

CALL opa_create_obj_if_not_exists('CREATE TABLE MODULE_VERSION ('
  || ' module_version_id NUMBER(9) NOT NULL,'
  || ' module_id NUMBER(9) NOT NULL,'
  || ' version_number NUMBER(9),'
  || ' create_timestamp DATE NOT NULL,'
  || ' is_draft NUMBER(5) DEFAULT 0 NOT NULL,'
  || ' snapshot_id NUMBER(9),'
  || ' fingerprint_sha256 VARCHAR2(65 CHAR) NOT NULL,'
  || ' definition CLOB NOT NULL,'
  || ' rulebase_deployable NUMBER(5) DEFAULT 0 NOT NULL,'
  || ' CONSTRAINT module_version_pk PRIMARY KEY (module_version_id),'
  || ' CONSTRAINT version_number_unique UNIQUE (module_id, version_number) )');

CALL opa_create_obj_if_not_exists('CREATE SEQUENCE module_version_seq START WITH 1 INCREMENT BY 1');

CALL opa_create_obj_if_not_exists('CREATE TABLE MODULE_COLL ('
|| '  module_id NUMBER(9) NOT NULL,'
|| '  collection_id NUMBER(9) NOT NULL,'
|| '  CONSTRAINT module_coll_unique_ids UNIQUE (module_id, collection_id) )');


CAll opa_add_constr_if_not_exists('MODULE_VERSION', 'module_id_fk', 'FOREIGN KEY (module_id) REFERENCES MODULE(module_id)');
CAll opa_add_constr_if_not_exists('MODULE_VERSION', 'mv_snapshot_id_fk', 'FOREIGN KEY (snapshot_id) REFERENCES SNAPSHOT(snapshot_id)');
CAll opa_add_constr_if_not_exists('MODULE_COLL', 'module_coll_coll_id_fk', 'FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id)');
CAll opa_add_constr_if_not_exists('MODULE_COLL', 'module_coll_deploy_id_fk', 'FOREIGN KEY (module_id) REFERENCES MODULE(module_id)');

CALL opa_add_column_if_not_exists('DATA_SERVICE', 'cookie_param', 'VARCHAR2(255 CHAR)');
