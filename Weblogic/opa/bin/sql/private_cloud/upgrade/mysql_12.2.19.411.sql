
DELETE FROM CONFIG_PROPERTY WHERE config_property_name ='hub_news_url';
UPDATE CONFIG_PROPERTY SET config_property_str_value='https://documentation.custhelp.com/euf/assets/devdocs/{0}/IntelligentAdvisor/{1}/Default.htm' WHERE config_property_name='opa_help_url';

