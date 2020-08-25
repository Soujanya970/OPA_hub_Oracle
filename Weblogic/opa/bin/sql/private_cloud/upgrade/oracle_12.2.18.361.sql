
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value)
  (SELECT 'feature_web_interviews_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental Web Interviews feature', 1, 0 FROM DUAL
    WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='feature_web_interviews_enabled'));

CALL opa_add_column_if_not_exists('MODULE', 'module_kind', 'NUMBER(5) DEFAULT 1 NOT NULL');
