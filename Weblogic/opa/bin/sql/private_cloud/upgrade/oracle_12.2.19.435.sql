
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value)
  (SELECT 'cloud_batch_shared_thread_count', 1, 'Maximum number of shared threads that batch assess will use (0=single threaded with no shared pool).', 1, 0 FROM DUAL
    WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='cloud_batch_shared_thread_count'));

