
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type)
  (SELECT 'pwd_pwnedPasswordsURL', 1, 'The URL for the location of a passwords-sha1.txt file containing Pwned password.', 0 FROM DUAL
    WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='pwd_pwnedPasswordsURL'));

