INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_web_interviews_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental Web Interviews feature', 1, 0);

CALL OPAAddColumnIfNotExists('MODULE', 'module_kind', 'SMALLINT DEFAULT 1 NOT NULL');
