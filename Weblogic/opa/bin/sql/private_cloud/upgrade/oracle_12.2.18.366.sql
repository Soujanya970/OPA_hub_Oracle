
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value)
  (SELECT 'use_local_jet_files', 1, '0 = disabled, 1 = enabled. If enabled the Hub will use local Oracle Jet files rather than from CDN.', 1, 0 FROM DUAL
    WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='use_local_jet_files'));

