INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('audit_max_download', 1, 'Maximum number of audit entries that can be downloaded in the hub. Valid value is from 1 to 10,000 and default value is 500.', 1, 500);
INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('audit_max_service', 1, 'Maximum number of audit entries that can be retrieved in the REST service. Valid value is from 1 to 10,000 and default value is 500.', 1, 500);
