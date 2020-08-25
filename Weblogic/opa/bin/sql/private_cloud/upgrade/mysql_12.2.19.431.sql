INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('ec_auto_version_select', 1, '0 = disabled, 1 = enabled. If enabled EC connections will automatically upgrade to the latest available advertized version.', 1, 1);
INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_str_value) VALUES ('ec_default_version', 1, 'The version set for new EC connections when available versions are not advertized in Topology Manager responses, or when ec_auto_version_select is set to false.', 0, '12.2.13');


update CONFIG_PROPERTY SET config_property_int_value=0 WHERE config_property_name='ec_auto_version_select';

update CONFIG_PROPERTY SET config_property_str_value='12.2.5' WHERE config_property_name='ec_default_version';
