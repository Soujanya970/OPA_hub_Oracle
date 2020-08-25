
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value)
  (SELECT 'feature_embedded_fastpath', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental embedded loader', 1, 0 FROM DUAL
    WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='feature_embedded_fastpath'));

