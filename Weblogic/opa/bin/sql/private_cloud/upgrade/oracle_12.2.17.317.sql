
CALL opa_create_obj_if_not_exists('CREATE TABLE SITEKEY ('
  || 'kid VARCHAR2(36 CHAR) NOT NULL, ' 
  || 'status NUMBER(5) DEFAULT 0 NOT NULL, ' 
  || 'last_modified DATE NOT NULL, ' 
  || 'contents CLOB NOT NULL, ' 
  || 'CONSTRAINT key_kid_pk PRIMARY KEY (kid), ' 
  || 'CONSTRAINT key_status_chk CHECK (status >= 0 AND status <= 1) )');


INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type)
  (SELECT 'application_identity', 0 FROM DUAL
    WHERE NOT EXISTS (SELECT * FROM CONFIG_PROPERTY WHERE config_property_name='application_identity'));

