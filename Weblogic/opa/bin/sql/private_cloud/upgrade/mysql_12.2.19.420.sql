INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('connection_cache_refresh_interval', 1, 'The period, in seconds, between tests for liveness of a data connection. Range from 5 seconds to 24 hours (86,400 seconds).', 1, 300);

