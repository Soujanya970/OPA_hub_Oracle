-- 12.2.16 upgrade script for Oracle
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

create or replace procedure opa_drop_constraint_if_exists (
    tableName IN VARCHAR2,
    constraintName IN VARCHAR2
) as
begin
  declare
    column_not_exists exception;
    pragma exception_init (column_not_exists , -02443);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' DROP CONSTRAINT ' || constraintName;
  exception
    when column_not_exists then null;
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

CALL opa_create_obj_if_not_exists('CREATE TABLE RULE_ELEMENT ( '
    || 'rule_element_id NUMBER(9) NOT NULL, '
    || 'rule_element_name VARCHAR(255) NOT NULL, '
    || 'CONSTRAINT RULE_ELEMENT_PK PRIMARY KEY (rule_element_id), '
    || 'CONSTRAINT RULE_ELEMENT_UQ UNIQUE (rule_element_name)) ');

CALL opa_create_obj_if_not_exists('CREATE TABLE RULE_ELEMENT_STATS_LOG ( '
    || 'rule_element_stats_log_id NUMBER(9) NOT NULL, '
    || 'rule_element_id NUMBER(9) NOT NULL, '
    || 'deployment_id NUMBER(9) NOT NULL, deployment_version_id NUMBER(9) NOT NULL, '
    || 'reference_count NUMBER(9) NOT NULL, '
    || 'CONSTRAINT RULE_ELEMENT_STATS_LOG_PK PRIMARY KEY (rule_element_stats_log_id), '
    || 'CONSTRAINT RULE_ELEMENT_STATS_LOG_UQ UNIQUE (rule_element_id, deployment_id, deployment_version_id), '
    || 'CONSTRAINT RULE_ELEMENT_STATS_LOG_FK FOREIGN KEY (rule_element_id) REFERENCES RULE_ELEMENT(rule_element_id) ) ');

CALL opa_create_obj_if_not_exists('CREATE INDEX RULE_ELEMENT_DEPL_VERS_REF_IDX ON RULE_ELEMENT_STATS_LOG(rule_element_id, deployment_id, deployment_version_id, reference_count)');
CALL opa_create_obj_if_not_exists('CREATE SEQUENCE rule_element_seq START WITH 1 INCREMENT BY 1');
CALL opa_create_obj_if_not_exists('CREATE SEQUENCE rule_element_stats_log_seq START WITH 1 INCREMENT BY 1');

CALL opa_create_obj_if_not_exists('CREATE TABLE OPERATION ('
    || 'operation_id NUMBER(9) NOT NULL, '
    || 'operation_name VARCHAR(255) NOT NULL, '
    || 'operation_type NUMBER(9) NOT NULL, '
    || 'operation_state NUMBER(9) NOT NULL, '
    || 'operation_version NUMBER(9) NOT NULL, '
    || 'operation_model CLOB NOT NULL, '
    || 'invoke_url VARCHAR(1024) NULL, '
    || 'status_url VARCHAR(1024) NULL, '
    || 'query_param_names VARCHAR(1024) NULL, '
    || 'CONSTRAINT operation_pk PRIMARY KEY (operation_id), '
    || 'CONSTRAINT operation_name_unique UNIQUE (operation_name) ) ');

CALL opa_create_obj_if_not_exists('CREATE TABLE DEPLOYMENT_VERSION_OPERATION ('
    || 'deployment_version_id NUMBER(9) NOT NULL, '
    || 'operation_id NUMBER(9) NOT NULL, '
    || 'CONSTRAINT DEPL_VERS_OPERATION_UQ UNIQUE '
    || '(deployment_version_id, operation_id), '
    || 'CONSTRAINT DEPL_VERS_VERSION_ID FOREIGN KEY (deployment_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id), '
    || 'CONSTRAINT DEPL_VERS_OPERATION_ID FOREIGN KEY (operation_id) REFERENCES OPERATION(operation_id) ) ');

CALL opa_create_obj_if_not_exists('CREATE INDEX operation_type_state ON OPERATION(operation_type, operation_state) ');
CALL opa_create_obj_if_not_exists('CREATE SEQUENCE operation_seq START WITH 1 INCREMENT BY 1');

CALL opa_drop_constraint_if_exists('DEPLOYMENT_VERSION', 'data_service_id_version_fk');

CALL opa_add_column_if_not_exists('DATA_SERVICE', 'assoc_client_id', 'NUMBER(9) NULL');
CAll opa_add_constr_if_not_exists('DATA_SERVICE', 'data_service_client_id_fk', 'FOREIGN KEY(assoc_client_id) REFERENCES AUTHENTICATION(authentication_id)');

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'db_message_log_enabled', 1, 1, 1, '0 = disabled, 1 = enabled. Enable logging to LOG_ENTRY table' FROM DUAL
        WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='site_type'));

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'feature_auto_data_maintenance', 1, 1, 1, '0 = disabled, 1 = enabled. Enabling turns on the Auto Data Maintenance feature' FROM DUAL
     WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='feature_auto_data_maintenance'));
