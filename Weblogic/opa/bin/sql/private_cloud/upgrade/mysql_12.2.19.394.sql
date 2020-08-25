INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('det_server_decision_node_limit', 1, 'Maximum number of nodes that the decision reporter visits before an error occurs.', 1, 10000);


update CONFIG_PROPERTY SET config_property_int_value=0 WHERE config_property_name='det_server_decision_node_limit';
