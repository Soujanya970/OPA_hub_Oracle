INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('ec_connector_url', 1, 'The url of the EC Connector Service for this site', 0);
UPDATE CONFIG_PROPERTY SET config_property_str_value='https://documentation.custhelp.com/euf/assets/devdocs/{0}/PolicyAutomation/{1}/Default.htm' WHERE config_property_name='opa_help_url';

