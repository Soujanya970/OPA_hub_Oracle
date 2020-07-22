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

-- delim ;

CALL opa_create_obj_if_not_exists(
    'CREATE TABLE ASSESSMENT_STATS_LOG (' ||
        'assessment_stats_log_id NUMBER(19) NOT NULL, ' ||
        'deployment_id NUMBER(9) NOT NULL, ' ||
        'deployment_version_id NUMBER(9) NOT NULL, ' ||
        'product_code NUMBER(9) NOT NULL, ' ||
        'product_version VARCHAR(25) NOT NULL, ' ||
        'product_function_code NUMBER(9) NOT NULL, ' ||
        'product_function_version VARCHAR(25), ' ||
        'created_timestamp TIMESTAMP NOT NULL, ' ||
        'created_year NUMBER(9) NOT NULL, ' ||
        'created_month NUMBER(9) NOT NULL, ' ||
        'created_day NUMBER(19) NOT NULL, ' ||
        'created_hour NUMBER(19) NOT NULL, ' ||
        'duration_millis NUMBER(19) NOT NULL, ' ||
        'duration_sec NUMBER(9) NOT NULL, ' ||
        'duration_min NUMBER(9) NOT NULL, ' ||
        'cases_read NUMBER(9) NOT NULL, ' ||
        'cases_processed NUMBER(9) NOT NULL, ' ||
        'auth_id RAW(16) NULL, ' ||
        'authenticated NUMBER(5) NOT NULL, ' ||
        'CONSTRAINT ASSESSMENT_STATS_LOG_PK PRIMARY KEY (assessment_stats_log_id))'
);

CALL opa_create_obj_if_not_exists('CREATE INDEX ASSESSMENT_USAGE_TREND ON ASSESSMENT_STATS_LOG (deployment_id, created_hour, cases_read)');
CALL opa_create_obj_if_not_exists('CREATE INDEX ASSESSMENTS_BY_YEAR ON ASSESSMENT_STATS_LOG (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_year, cases_read)');
CALL opa_create_obj_if_not_exists('CREATE INDEX ASSESSMENTS_BY_MONTH ON ASSESSMENT_STATS_LOG (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_month, cases_read)');
CALL opa_create_obj_if_not_exists('CREATE INDEX ASSESSMENTS_BY_DAY ON ASSESSMENT_STATS_LOG (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_day, cases_read)');
CALL opa_create_obj_if_not_exists('CREATE INDEX ASSESSMENTS_BY_HOUR ON ASSESSMENT_STATS_LOG (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_hour, cases_read)');

CALL opa_create_obj_if_not_exists('CREATE SEQUENCE assessment_stats_log_seq START WITH 1 INCREMENT BY 1');

-- New feature flag for the Interactions By Date statistics chart
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'feature_interaction_statistics', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling turns on the Interaction Statistics feature' FROM DUAL
     WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='feature_interaction_statistics'));

-- New configuration property defining the ratio of assessment cases to interactions
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    (SELECT 'deployment_stats_cases_per_interaction', 20, 1, 0, 'The number of cases to be used to calculate assessment interactions in deployment statistics' FROM DUAL
     WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='deployment_stats_cases_per_interaction'));
