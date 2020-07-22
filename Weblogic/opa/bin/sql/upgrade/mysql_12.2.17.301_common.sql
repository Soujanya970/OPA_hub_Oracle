CREATE TABLE IF NOT EXISTS ASSESSMENT_STATS_LOG (
    assessment_stats_log_id BIGINT NOT NULL AUTO_INCREMENT,
    deployment_id INT NOT NULL,
    deployment_version_id INT NOT NULL,
    product_code INT NOT NULL,
    product_version VARCHAR(25) CHARACTER SET UTF8 NOT NULL,
    product_function_code INT NOT NULL,
    product_function_version VARCHAR(25) CHARACTER SET UTF8 NOT NULL,
    created_timestamp TIMESTAMP NOT NULL,
    created_year INT NOT NULL,
    created_month INT NOT NULL,
    created_day INT NOT NULL,
    created_hour INT NOT NULL,
    duration_millis BIGINT NOT NULL,
    duration_sec INT NOT NULL,
    duration_min INT NOT NULL,
    cases_read INT NOT NULL,
    cases_processed INT NOT NULL,
    auth_id BINARY(16) NULL,
    authenticated SMALLINT NOT NULL,
    CONSTRAINT ASSESSMENT_STATS_LOG_PK PRIMARY KEY (assessment_stats_log_id),
    INDEX ASSESSMENT_USAGE_TREND (deployment_id, created_hour, cases_read),
    INDEX ASSESSMENTS_BY_YEAR (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_year, cases_read),
    INDEX ASSESSMENTS_BY_MONTH (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_month, cases_read),
    INDEX ASSESSMENTS_BY_DAY (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_day, cases_read),
    INDEX ASSESSMENTS_BY_HOUR (deployment_id, deployment_version_id, product_function_code, created_timestamp, created_hour, cases_read)
) ENGINE=InnoDB;

-- New feature flag for interaction statistics chart, disabled by default
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('feature_interaction_statistics', 0, 1, 1, '0 = disabled, 1 = enabled. Enabling turns on the Interaction Statistics feature')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;

-- New configuration property for ratio of assessment cases per interaction.
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_int_value, config_property_type, config_property_public, config_property_description)
    VALUES ('deployment_stats_cases_per_interaction', 20, 1, 0, 'The number of cases to be used to calculate assessment interactions in deployment statistics')
    ON DUPLICATE KEY UPDATE config_property_name = config_property_name;
