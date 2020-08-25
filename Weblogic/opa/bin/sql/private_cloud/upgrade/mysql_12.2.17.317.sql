
CREATE TABLE IF NOT EXISTS SITEKEY (
  kid VARCHAR(36) CHARACTER SET utf8 NOT NULL,
  status SMALLINT DEFAULT 0 NOT NULL,
  last_modified TIMESTAMP NOT NULL,
  contents LONGTEXT CHARACTER SET utf8 NOT NULL,
  CONSTRAINT key_kid_pk PRIMARY KEY (kid),
  CONSTRAINT key_status_chk CHECK (status >= 0 AND status <= 1)
) Engine=INNODB;

INSERT IGNORE INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('application_identity', 0);

