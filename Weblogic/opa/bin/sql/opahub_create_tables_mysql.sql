
CREATE TABLE AUTHENTICATION (
  authentication_id INT AUTO_INCREMENT NOT NULL,
  user_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  full_name VARCHAR(255) CHARACTER SET utf8,
  email VARCHAR(255) CHARACTER SET utf8,
  status SMALLINT DEFAULT 0 NOT NULL,
  change_password SMALLINT DEFAULT 0 NOT NULL,
  invalid_logins INT DEFAULT 0 NOT NULL,
  last_login_timestamp DATETIME,
  hub_admin SMALLINT DEFAULT 0 NOT NULL,
  user_type SMALLINT DEFAULT 0 NOT NULL,
  last_locked_timestamp DATETIME,
  CONSTRAINT authentication_pk PRIMARY KEY (authentication_id),
  CONSTRAINT authentication_status_check CHECK (status >= 0 AND status <= 3),
  CONSTRAINT change_password_chk CHECK (change_password >= 0 AND change_password <= 1),
  CONSTRAINT hub_admin_check CHECK (hub_admin >= 0 AND hub_admin <= 1),
  CONSTRAINT auth_unique_user_name UNIQUE (user_name)
) Engine=INNODB;


CREATE TABLE AUTHENTICATION_PWD (
  authentication_pwd_id INT AUTO_INCREMENT NOT NULL,
  authentication_id INT NOT NULL REFERENCES AUTHENTICATION(authentication_id),
  password VARCHAR(512) CHARACTER SET utf8,
  created_date DATETIME NOT NULL,
  status SMALLINT DEFAULT 1 NOT NULL,
  CONSTRAINT authentication_pwd_pk PRIMARY KEY (authentication_pwd_id),
  CONSTRAINT auth_pwd_status_check CHECK (status >= 0 AND status <= 2)
) Engine=INNODB;


CREATE TABLE SECURITY_TOKEN (
  security_token_id INT AUTO_INCREMENT NOT NULL,
  authentication_id INT,
  token_value VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  issue_date DATETIME NOT NULL,
  verified_date DATETIME NOT NULL,
  is_long_term SMALLINT DEFAULT 0 NOT NULL,
  CONSTRAINT security_token_pk PRIMARY KEY (security_token_id),
  CONSTRAINT sec_unique_token_value UNIQUE (token_value),
  CONSTRAINT is_long_term_check CHECK (is_long_term >= 0 AND is_long_term <= 1)
) Engine=INNODB;


CREATE TABLE ROLE (
  role_id INT AUTO_INCREMENT NOT NULL,
  role_name VARCHAR(63) CHARACTER SET utf8 NOT NULL,
  CONSTRAINT role_pk PRIMARY KEY (role_id),
  CONSTRAINT role_unique_role_name UNIQUE (role_name)
) Engine=INNODB;


CREATE TABLE COLLECTION (
  collection_id INT AUTO_INCREMENT NOT NULL,
  collection_name VARCHAR(127) CHARACTER SET utf8 NOT NULL,
  collection_status INT NOT NULL,
  collection_description VARCHAR(255) CHARACTER SET utf8,
  deleted_timestamp DATETIME,
  CONSTRAINT collection_pk PRIMARY KEY (collection_id),
  CONSTRAINT collection_unique_coll_name UNIQUE (collection_name),
  CONSTRAINT collection_status_check CHECK (collection_status >= 0 AND collection_status <= 2)
) Engine=INNODB;


CREATE TABLE AUTH_ROLE_COLL (
  authentication_id INT NOT NULL REFERENCES AUTHENTICATION(authentication_id),
  role_id INT NOT NULL REFERENCES ROLE(role_id),
  collection_id INT NOT NULL REFERENCES COLLECTION(collection_id),
  CONSTRAINT auth_coll_unique_ids UNIQUE (authentication_id, role_id, collection_id)
) Engine=INNODB;


CREATE TABLE CONFIG_PROPERTY (
  config_property_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  config_property_int_value INT,
  config_property_str_value VARCHAR(2048) CHARACTER SET utf8,
  config_property_type INT,
  config_property_public SMALLINT DEFAULT 0 NOT NULL,
  config_property_description VARCHAR(1024) CHARACTER SET utf8,
  CONSTRAINT config_property_pk PRIMARY KEY (config_property_name)
) Engine=INNODB;


CREATE TABLE DATA_SERVICE (
  data_service_id INT AUTO_INCREMENT NOT NULL,
  service_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  service_type VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  version VARCHAR(20) CHARACTER SET utf8,
  url VARCHAR(1024) CHARACTER SET utf8,
  last_updated DATETIME NOT NULL,
  service_user VARCHAR(255) CHARACTER SET utf8,
  service_pass VARCHAR(255) CHARACTER SET utf8,
  use_wss SMALLINT DEFAULT 0 NOT NULL,
  wss_use_timestamp SMALLINT,
  shared_secret VARCHAR(255) CHARACTER SET utf8,
  rn_shared_secret VARCHAR(255) CHARACTER SET utf8,
  cx_site_name VARCHAR(255) CHARACTER SET utf8,
  bearer_token_param VARCHAR(255) CHARACTER SET utf8,
  status SMALLINT DEFAULT 0 NOT NULL,
  soap_action_pattern VARCHAR(255) CHARACTER SET utf8,
  metadata LONGTEXT CHARACTER SET utf8,
  use_trust_store SMALLINT DEFAULT 0 NOT NULL,
  ssl_private_key VARCHAR(80) CHARACTER SET utf8,
  assoc_client_id INT,
  cookie_param VARCHAR(255) CHARACTER SET utf8,
  CONSTRAINT data_service_pk PRIMARY KEY (data_service_id),
  CONSTRAINT service_name_unique UNIQUE (service_name),
  CONSTRAINT use_trust_store_check CHECK (use_trust_store >= 0 AND use_trust_store <= 1)
) Engine=INNODB;


CREATE TABLE DATA_SERVICE_COLL (
  data_service_id INT NOT NULL REFERENCES DATA_SERVICE(data_service_id),
  collection_id INT NOT NULL REFERENCES COLLECTION(collection_id),
  CONSTRAINT data_service_coll_unique_ids UNIQUE (data_service_id, collection_id)
) Engine=INNODB;


CREATE TABLE LOG_ENTRY (
  log_entry_id INT AUTO_INCREMENT NOT NULL,
  entry_timestamp DATETIME NOT NULL,
  entry_type VARCHAR(15) CHARACTER SET utf8 NOT NULL,
  code VARCHAR(15) CHARACTER SET utf8 NOT NULL,
  message LONGTEXT CHARACTER SET utf8 NOT NULL,
  origin VARCHAR(30) CHARACTER SET utf8,
  CONSTRAINT log_entry_primary_key PRIMARY KEY (log_entry_id)
) Engine=INNODB;

CREATE INDEX entry_timestamp_idx ON LOG_ENTRY(entry_timestamp);

CREATE TABLE SNAPSHOT (
  snapshot_id INT AUTO_INCREMENT NOT NULL,
  uploaded_date DATETIME NOT NULL,
  fingerprint_sha256 VARCHAR(65) CHARACTER SET utf8,
  scan_status SMALLINT DEFAULT 0 NOT NULL,
  scan_message VARCHAR(255) CHARACTER SET utf8,
  CONSTRAINT snapshot_id_pk PRIMARY KEY (snapshot_id)
) Engine=INNODB;


CREATE TABLE SNAPSHOT_CHUNK (
  snapshot_id INT NOT NULL,
  chunk_sequence INT NOT NULL,
  chunk_slice LONGTEXT CHARACTER SET utf8 NOT NULL,
  CONSTRAINT snapshot_chunk_unique PRIMARY KEY (snapshot_id, chunk_sequence)
) Engine=INNODB;


CREATE TABLE PROJECT (
  project_id INT AUTO_INCREMENT NOT NULL,
  project_name VARCHAR(127) CHARACTER SET utf8 NOT NULL,
  project_description VARCHAR(255) CHARACTER SET utf8,
  last_updated DATETIME NOT NULL,
  latest_version INT,
  deleted_timestamp DATETIME,
  CONSTRAINT project_id_pk PRIMARY KEY (project_id),
  CONSTRAINT project_name_unique UNIQUE (project_name)
) Engine=INNODB;


CREATE TABLE PROJECT_VERSION (
  project_version_id INT AUTO_INCREMENT NOT NULL,
  project_id INT NOT NULL REFERENCES PROJECT(project_id),
  project_version INT NOT NULL,
  project_snapshot_id INT NOT NULL REFERENCES SNAPSHOT(snapshot_id),
  version_uuid VARCHAR(36) CHARACTER SET utf8,
  activatable SMALLINT DEFAULT 0 NOT NULL,
  user_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  opa_version VARCHAR(15) CHARACTER SET utf8 NOT NULL,
  description VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  creation_date DATETIME NOT NULL,
  deleted_timestamp DATETIME,
  CONSTRAINT project_version_pk PRIMARY KEY (project_version_id)
) Engine=INNODB;

CREATE INDEX project_version_project_idx ON PROJECT_VERSION(project_id);
CREATE INDEX project_version_snapshot_idx ON PROJECT_VERSION(project_snapshot_id);
CREATE INDEX version_uuid_idx ON PROJECT_VERSION(version_uuid);

CREATE TABLE PROJECT_VERSION_CHANGE (
  project_version_change_id INT AUTO_INCREMENT NOT NULL,
  project_version_id INT NOT NULL REFERENCES PROJECT_VERSION(project_version_id),
  object_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  change_type SMALLINT NOT NULL,
  CONSTRAINT project_version_change_pk PRIMARY KEY (project_version_change_id),
  CONSTRAINT project_version_change_unique UNIQUE (project_version_id, object_name)
) Engine=INNODB;


CREATE TABLE PROJECT_OBJECT_STATUS (
  project_object_status_id INT AUTO_INCREMENT NOT NULL,
  project_id INT NOT NULL REFERENCES PROJECT(project_id),
  object_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  lock_machine VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  lock_folder VARCHAR(1024) CHARACTER SET utf8 NOT NULL,
  lock_user INT NOT NULL REFERENCES AUTHENTICATION(authentication_id),
  lock_timestamp DATETIME NOT NULL,
  CONSTRAINT project_object_status_id_pk PRIMARY KEY (project_object_status_id),
  CONSTRAINT project_object_unique UNIQUE (project_id, object_name)
) Engine=INNODB;


CREATE TABLE PROJECT_COLL (
  project_id INT NOT NULL REFERENCES PROJECT(project_id),
  collection_id INT NOT NULL REFERENCES COLLECTION(collection_id),
  CONSTRAINT project_coll_unique_ids UNIQUE (project_id, collection_id)
) Engine=INNODB;


CREATE TABLE DEPLOYMENT (
  deployment_id INT AUTO_INCREMENT NOT NULL,
  deployment_name VARCHAR(127) CHARACTER SET utf8 NOT NULL,
  deployment_description VARCHAR(255) CHARACTER SET utf8,
  last_updated DATETIME NOT NULL,
  activated_version_id INT REFERENCES DEPLOYMENT_VERSION(deployment_version_id),
  activated_interview SMALLINT DEFAULT 0 NOT NULL,
  activated_webservice SMALLINT DEFAULT 0 NOT NULL,
  activated_interviewservice SMALLINT DEFAULT 0 NOT NULL,
  activated_chatservice SMALLINT DEFAULT 0 NOT NULL,
  activated_mobile SMALLINT DEFAULT 0 NOT NULL,
  compatibility_mode SMALLINT DEFAULT 0 NOT NULL,
  user_name VARCHAR(255) CHARACTER SET utf8,
  deleted_timestamp DATETIME,
  CONSTRAINT deployment_id_pk PRIMARY KEY (deployment_id),
  CONSTRAINT deployment_name_unique UNIQUE (deployment_name)
) Engine=INNODB;


CREATE TABLE DEPLOYMENT_VERSION (
  deployment_version_id INT AUTO_INCREMENT NOT NULL,
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  deployment_version INT NOT NULL,
  deployment_version_kind SMALLINT DEFAULT 0 NOT NULL,
  snapshot_id INT REFERENCES SNAPSHOT(snapshot_id),
  module_version_id INT,
  user_name VARCHAR(255) CHARACTER SET utf8,
  opa_version VARCHAR(15) CHARACTER SET utf8 NOT NULL,
  description VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  activatable SMALLINT DEFAULT 1 NOT NULL,
  snapshot_date DATETIME NOT NULL,
  snapshot_deleted_timestamp DATETIME,
  mapping_type VARCHAR(32) CHARACTER SET utf8,
  data_service_id INT,
  data_service_used SMALLINT DEFAULT 0 NOT NULL,
  CONSTRAINT deployment_version_pk PRIMARY KEY (deployment_version_id),
  CONSTRAINT activatable_check CHECK (activatable >= 0 AND activatable <= 1),
  CONSTRAINT data_service_used_check CHECK (data_service_used >= 0 AND data_service_used <= 2)
) Engine=INNODB;

CREATE INDEX deployment_ver_deployment_idx ON DEPLOYMENT_VERSION(deployment_id);
CREATE INDEX deployment_ver_snapshot_idx ON DEPLOYMENT_VERSION(snapshot_id);

CREATE TABLE DEPLOYMENT_ACTIVATION_HISTORY (
  deployment_activation_hist_id INT AUTO_INCREMENT NOT NULL,
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  deployment_version_id INT NOT NULL REFERENCES DEPLOYMENT_VERSION(deployment_version_id),
  activation_date DATETIME NOT NULL,
  status_interview SMALLINT DEFAULT 0 NOT NULL,
  status_webservice SMALLINT DEFAULT 0 NOT NULL,
  status_interviewservice SMALLINT DEFAULT 0 NOT NULL,
  status_chatservice SMALLINT DEFAULT 0 NOT NULL,
  status_mobile SMALLINT DEFAULT 0 NOT NULL,
  user_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  CONSTRAINT deployment_act_history_pk PRIMARY KEY (deployment_activation_hist_id)
) Engine=INNODB;

CREATE INDEX deployment_act_hist_depl_idx ON DEPLOYMENT_ACTIVATION_HISTORY(deployment_id);

CREATE TABLE DEPLOYMENT_RULEBASE_REPOS (
  id INT AUTO_INCREMENT NOT NULL,
  deployment_version_id INT NOT NULL REFERENCES DEPLOYMENT_VERSION(deployment_version_id),
  chunk_sequence INT NOT NULL,
  chunk_slice LONGTEXT CHARACTER SET utf8 NOT NULL,
  uploaded_date DATETIME NOT NULL,
  CONSTRAINT deployment_rb_repos_pk PRIMARY KEY (id),
  CONSTRAINT deployment_rb_repos_unique UNIQUE (deployment_version_id, chunk_sequence)
) Engine=INNODB;


CREATE TABLE DEPLOYMENT_COLL (
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  collection_id INT NOT NULL REFERENCES COLLECTION(collection_id),
  CONSTRAINT deployment_coll_unique_ids UNIQUE (deployment_id, collection_id)
) Engine=INNODB;


CREATE TABLE DEPLOYMENT_CHANNEL_DEFAULT (
  channel_default_id INT AUTO_INCREMENT NOT NULL,
  collection_id INT NOT NULL,
  default_interview SMALLINT DEFAULT 0 NOT NULL,
  default_webservice SMALLINT DEFAULT 0 NOT NULL,
  default_interviewservice SMALLINT DEFAULT 0 NOT NULL,
  default_mobile SMALLINT DEFAULT 0 NOT NULL,
  default_chatservice SMALLINT DEFAULT 0 NOT NULL,
  defaults_can_override SMALLINT DEFAULT 1 NOT NULL,
  CONSTRAINT channel_default_idx PRIMARY KEY (channel_default_id),
  CONSTRAINT default_interview_check CHECK (default_interview >= 0 AND default_interview <= 1),
  CONSTRAINT default_webservice_check CHECK (default_webservice >= 0 AND default_webservice <= 1),
  CONSTRAINT default_mobile_check CHECK (default_mobile >= 0 AND default_mobile <= 1),
  CONSTRAINT default_chatservice_check CHECK (default_chatservice >= 0 AND default_chatservice <= 1),
  CONSTRAINT default_override_check CHECK (defaults_can_override >= 0 AND defaults_can_override <= 1)
) Engine=INNODB;

CREATE INDEX collection_id_uq ON DEPLOYMENT_CHANNEL_DEFAULT(collection_id);

CREATE TABLE OPERATION (
  operation_id INT AUTO_INCREMENT NOT NULL,
  operation_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  operation_type INT NOT NULL,
  operation_state INT NOT NULL,
  operation_version INT NOT NULL,
  operation_model LONGTEXT CHARACTER SET utf8 NOT NULL,
  invoke_url VARCHAR(1024) CHARACTER SET utf8,
  status_url VARCHAR(1024) CHARACTER SET utf8,
  query_param_names VARCHAR(1024) CHARACTER SET utf8,
  CONSTRAINT operation_pk PRIMARY KEY (operation_id),
  CONSTRAINT operation_name_unique UNIQUE (operation_name)
) Engine=INNODB;

CREATE INDEX operation_type_state ON OPERATION(operation_type, operation_state);

CREATE TABLE DEPLOYMENT_VERSION_OPERATION (
  deployment_version_id INT NOT NULL REFERENCES DEPLOYMENT_VERSION(deployment_version_id),
  operation_id INT NOT NULL REFERENCES OPERATION(operation_id),
  CONSTRAINT depl_vers_operation_unique UNIQUE (deployment_version_id, operation_id)
) Engine=INNODB;


CREATE TABLE SESSION_STATS_TEMPLATE (
  session_stats_template_id INT AUTO_INCREMENT NOT NULL,
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  deployment_version_id INT NOT NULL REFERENCES DEPLOYMENT_VERSION(deployment_version_id),
  CONSTRAINT session_stats_template_pk PRIMARY KEY (session_stats_template_id),
  CONSTRAINT session_stats_template_uq UNIQUE (deployment_id, deployment_version_id)
) Engine=INNODB;


CREATE TABLE SESSION_SCREEN_TEMPLATE (
  session_screen_template_id INT AUTO_INCREMENT NOT NULL,
  session_stats_template_id INT NOT NULL REFERENCES SESSION_STATS_TEMPLATE(session_stats_template_id),
  screen_id VARCHAR(50) CHARACTER SET utf8 NOT NULL,
  screen_title VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  screen_action_code INT NOT NULL,
  screen_order INT NOT NULL,
  CONSTRAINT session_screen_template_pk PRIMARY KEY (session_screen_template_id),
  CONSTRAINT session_screen_template_uk UNIQUE (session_stats_template_id, screen_id)
) Engine=INNODB;


CREATE TABLE SESSION_STATS_LOG (
  session_stats_log_id BIGINT AUTO_INCREMENT NOT NULL,
  session_stats_template_id INT NOT NULL REFERENCES SESSION_STATS_TEMPLATE(session_stats_template_id),
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  deployment_version_id INT NOT NULL,
  product_code INT NOT NULL,
  product_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  product_function_code INT NOT NULL,
  product_function_version VARCHAR(25) CHARACTER SET utf8,
  created_timestamp TIMESTAMP NULL,
  created_year INT NOT NULL,
  created_month INT NOT NULL,
  created_day INT NOT NULL,
  created_hour INT NOT NULL,
  last_modified_timestamp TIMESTAMP NULL,
  last_modified_year INT NOT NULL,
  last_modified_month INT NOT NULL,
  last_modified_day INT NOT NULL,
  last_modified_hour INT NOT NULL,
  duration_millis BIGINT NOT NULL,
  duration_sec INT NOT NULL,
  duration_min INT NOT NULL,
  screens_visited INT NOT NULL,
  auth_id BINARY(16),
  authenticated SMALLINT NOT NULL,
  completed SMALLINT NOT NULL,
  CONSTRAINT session_stats_log_pk PRIMARY KEY (session_stats_log_id)
) Engine=INNODB;

CREATE INDEX usage_trend ON SESSION_STATS_LOG(created_hour, deployment_id);
CREATE INDEX obsolete_api_usage ON SESSION_STATS_LOG(deployment_id, created_timestamp, product_function_version, product_function_code, product_code);
CREATE INDEX sessions_by_year ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_year);
CREATE INDEX sessions_by_month ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_month);
CREATE INDEX sessions_by_day ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_day);
CREATE INDEX sessions_by_hour ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_hour);
CREATE INDEX sessions_by_duration_min ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, duration_min);
CREATE INDEX sessions_by_screens_visited ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, screens_visited);

CREATE TABLE SESSION_SCREEN_LOG (
  session_screen_log_id BIGINT AUTO_INCREMENT NOT NULL,
  session_stats_log_id BIGINT NOT NULL REFERENCES SESSION_STATS_LOG(session_stats_log_id),
  session_stats_template_id BIGINT NOT NULL REFERENCES SESSION_STATS_TEMPLATE(session_stats_template_id),
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  deployment_version_id INT NOT NULL REFERENCES DEPLOYMENT_VERSION(deployment_version_id),
  product_code INT NOT NULL,
  product_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  product_function_code INT NOT NULL,
  session_created_timestamp TIMESTAMP NULL,
  auth_id BINARY(16),
  authenticated SMALLINT NOT NULL,
  screen_id VARCHAR(50) CHARACTER SET utf8 NOT NULL,
  screen_order INT NOT NULL,
  screen_action_code INT NOT NULL,
  screen_sequence INT NOT NULL,
  entry_transition_code SMALLINT NOT NULL,
  entry_timestamp TIMESTAMP NULL,
  submit_timestamp TIMESTAMP NULL,
  exit_transition_code SMALLINT,
  exit_timestamp TIMESTAMP NULL,
  duration_millis BIGINT NOT NULL,
  duration_sec INT NOT NULL,
  duration_min INT NOT NULL,
  CONSTRAINT session_screen_log_pk PRIMARY KEY (session_screen_log_id)
) Engine=INNODB;

CREATE INDEX screen_by_session_id ON SESSION_SCREEN_LOG(session_stats_log_id);
CREATE INDEX screen_by_vers_id_action ON SESSION_SCREEN_LOG(deployment_version_id, session_created_timestamp, screen_id, screen_action_code);

CREATE TABLE SESSION_STATS_UID (
  session_uid VARCHAR(36) CHARACTER SET utf8 NOT NULL,
  session_stats_log_id BIGINT NOT NULL,
  CONSTRAINT SESSION_STATS_UID_PK PRIMARY KEY (session_uid)
) Engine=INNODB;


CREATE TABLE SESSION_STATS_LOG_V2 (
  session_stats_log_v2_id BIGINT AUTO_INCREMENT NOT NULL,
  session_stats_template_id INT NOT NULL,
  deployment_id INT NOT NULL,
  deployment_version_id INT NOT NULL,
  product_code INT NOT NULL,
  product_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  product_function_code INT NOT NULL,
  product_function_version VARCHAR(25) CHARACTER SET utf8,
  created_timestamp TIMESTAMP NULL,
  created_year BIGINT NOT NULL,
  created_month BIGINT NOT NULL,
  created_day BIGINT NOT NULL,
  created_hour BIGINT NOT NULL,
  last_modified_timestamp TIMESTAMP NULL,
  last_modified_year BIGINT NOT NULL,
  last_modified_month BIGINT NOT NULL,
  last_modified_day BIGINT NOT NULL,
  last_modified_hour BIGINT NOT NULL,
  duration_millis BIGINT NOT NULL,
  duration_sec BIGINT NOT NULL,
  duration_min BIGINT NOT NULL,
  screens_visited INT NOT NULL,
  auth_id BINARY(16),
  auth_role SMALLINT NOT NULL,
  completed SMALLINT NOT NULL,
  data_service_id INT,
  data_service_type INT,
  data_service_version VARCHAR(25) CHARACTER SET utf8,
  agent SMALLINT DEFAULT 0 NOT NULL,
  CONSTRAINT session_stats_log_v2_pk PRIMARY KEY (session_stats_log_v2_id)
) Engine=INNODB;

CREATE INDEX usage_trend_v2 ON SESSION_STATS_LOG_V2(deployment_id, created_hour);
CREATE INDEX sessions_by_created_year_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_year);
CREATE INDEX sessions_by_created_month_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_month);
CREATE INDEX sessions_by_created_day_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_day);
CREATE INDEX sessions_by_created_hour_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_hour);
CREATE INDEX sessions_by_duration_min_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, duration_min);
CREATE INDEX sessions_by_screens_visited_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, screens_visited);
CREATE INDEX agents_by_created_year_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, agent, created_timestamp, created_year);
CREATE INDEX agents_by_created_month_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, agent, created_timestamp, created_month);
CREATE INDEX agents_by_created_day_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, agent, created_timestamp, created_day);
CREATE INDEX agents_by_created_hour_v2 ON SESSION_STATS_LOG_V2(deployment_id, deployment_version_id, agent, created_timestamp, created_hour);

CREATE TABLE SESSION_SCREEN_LOG_V2 (
  session_screen_log_v2_id BIGINT AUTO_INCREMENT NOT NULL,
  session_stats_log_v2_id BIGINT NOT NULL,
  session_stats_template_id BIGINT NOT NULL,
  deployment_id INT NOT NULL,
  deployment_version_id INT NOT NULL,
  product_code INT NOT NULL,
  product_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  product_function_code INT NOT NULL,
  session_created_timestamp TIMESTAMP NULL,
  auth_id BINARY(16),
  auth_role SMALLINT NOT NULL,
  screen_id VARCHAR(50) CHARACTER SET utf8 NOT NULL,
  screen_order INT NOT NULL,
  screen_action_code INT NOT NULL,
  screen_sequence INT NOT NULL,
  entry_transition_code SMALLINT NOT NULL,
  entry_timestamp TIMESTAMP NULL,
  submit_timestamp TIMESTAMP NULL,
  exit_transition_code SMALLINT,
  exit_timestamp TIMESTAMP NULL,
  duration_millis BIGINT NOT NULL,
  duration_sec BIGINT NOT NULL,
  duration_min BIGINT NOT NULL,
  data_service_id INT,
  data_service_type INT,
  data_service_version VARCHAR(25) CHARACTER SET utf8,
  agent SMALLINT DEFAULT 0 NOT NULL,
  CONSTRAINT session_screen_log_v2_pk PRIMARY KEY (session_screen_log_v2_id)
) Engine=INNODB;

CREATE INDEX screen_by_session_v2_id ON SESSION_SCREEN_LOG_V2(session_stats_log_v2_id);
CREATE INDEX screen_by_session_state_v2 ON SESSION_SCREEN_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, session_created_timestamp, session_stats_log_v2_id, screen_id, screen_action_code);
CREATE INDEX screen_by_session_duration_v2 ON SESSION_SCREEN_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, session_created_timestamp, session_stats_log_v2_id, screen_id, duration_millis);

CREATE TABLE SESSION_STATS_UID_V2 (
  session_uid VARCHAR(36) CHARACTER SET utf8 NOT NULL,
  session_stats_log_v2_id BIGINT NOT NULL,
  CONSTRAINT SESSION_STATS_UID_V2_PK PRIMARY KEY (session_uid)
) Engine=INNODB;


CREATE TABLE STATISTICS_CHART (
  statistics_chart_id INT AUTO_INCREMENT NOT NULL,
  chart_type VARCHAR(30) CHARACTER SET utf8 NOT NULL,
  chart_data LONGTEXT CHARACTER SET utf8 NOT NULL,
  CONSTRAINT statistics_chart_pk PRIMARY KEY (statistics_chart_id)
) Engine=INNODB;


CREATE TABLE DEPLOYMENT_STATS_CHART (
  deployment_stats_chart_id INT AUTO_INCREMENT NOT NULL,
  statistics_chart_id INT NOT NULL REFERENCES STATISTICS_CHART(statistics_chart_id),
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  chart_number INT NOT NULL,
  CONSTRAINT deployment_stats_chart_pk PRIMARY KEY (deployment_stats_chart_id),
  CONSTRAINT deployment_stats_chart_uq UNIQUE (deployment_id, chart_number)
) Engine=INNODB;


CREATE TABLE OVERVIEW_STATS_CHART (
  overview_stats_chart_id INT AUTO_INCREMENT NOT NULL,
  statistics_chart_id INT NOT NULL REFERENCES STATISTICS_CHART(statistics_chart_id),
  chart_number INT NOT NULL,
  CONSTRAINT overview_stats_chart_pk PRIMARY KEY (overview_stats_chart_id),
  CONSTRAINT overview_stats_chart_uq UNIQUE (chart_number)
) Engine=INNODB;


CREATE TABLE FUNCTION_STATS_LOG (
  function_stats_log_id INT AUTO_INCREMENT NOT NULL,
  deployment_id INT NOT NULL REFERENCES DEPLOYMENT(deployment_id),
  product_code INT NOT NULL,
  product_function_code INT NOT NULL,
  product_function_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  last_used_timestamp TIMESTAMP NOT NULL,
  CONSTRAINT function_stats_log_pk PRIMARY KEY (function_stats_log_id),
  CONSTRAINT function_stats_log_uq UNIQUE (deployment_id, product_code, product_function_code, product_function_version)
) Engine=INNODB;

CREATE INDEX function_usage_obsolete ON FUNCTION_STATS_LOG(last_used_timestamp, product_code, product_function_code, product_function_version, deployment_id);

CREATE TABLE RULE_ELEMENT (
  rule_element_id INT AUTO_INCREMENT NOT NULL,
  rule_element_name VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  CONSTRAINT RULE_ELEMENT_PK PRIMARY KEY (rule_element_id),
  CONSTRAINT RULE_ELEMENT_UQ UNIQUE (rule_element_name)
) Engine=INNODB;


CREATE TABLE RULE_ELEMENT_STATS_LOG (
  rule_element_stats_log_id INT AUTO_INCREMENT NOT NULL,
  rule_element_id INT NOT NULL REFERENCES RULE_ELEMENT(rule_element_id),
  deployment_id INT NOT NULL,
  deployment_version_id INT NOT NULL,
  reference_count INT NOT NULL,
  CONSTRAINT RULE_ELEMENT_STATS_LOG_PK PRIMARY KEY (rule_element_stats_log_id),
  CONSTRAINT RULE_ELEMENT_STATS_LOG_UQ UNIQUE (rule_element_id, deployment_id, deployment_version_id)
) Engine=INNODB;

CREATE INDEX RULE_ELEMENT_DEPL_VERS_REF_IDX ON RULE_ELEMENT_STATS_LOG(rule_element_id, deployment_id, deployment_version_id, reference_count);

CREATE TABLE ASSESSMENT_STATS_LOG (
  assessment_stats_log_id INT AUTO_INCREMENT NOT NULL,
  deployment_id INT NOT NULL,
  deployment_version_id INT NOT NULL,
  product_code INT NOT NULL,
  product_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  product_function_code INT NOT NULL,
  product_function_version VARCHAR(25) CHARACTER SET utf8 NOT NULL,
  created_timestamp TIMESTAMP NOT NULL,
  created_year BIGINT NOT NULL,
  created_month BIGINT NOT NULL,
  created_day BIGINT NOT NULL,
  created_hour BIGINT NOT NULL,
  duration_millis BIGINT NOT NULL,
  duration_sec BIGINT NOT NULL,
  duration_min BIGINT NOT NULL,
  cases_read INT NOT NULL,
  cases_processed INT NOT NULL,
  auth_id BINARY(16),
  authenticated SMALLINT NOT NULL,
  CONSTRAINT assessment_stats_log_pk PRIMARY KEY (assessment_stats_log_id)
) Engine=INNODB;

CREATE INDEX assessment_usage_trend ON ASSESSMENT_STATS_LOG(deployment_id, created_hour, cases_read);
CREATE INDEX assessments_by_year ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_year, cases_read);
CREATE INDEX assessments_by_month ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_month, cases_read);
CREATE INDEX assessments_by_day ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_day, cases_read);
CREATE INDEX assessments_by_hour ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_hour, cases_read);

CREATE TABLE SSL_PUBLIC_CERTIFICATE (
  ssl_certificate_id INT AUTO_INCREMENT NOT NULL,
  cert_alias VARCHAR(80) CHARACTER SET utf8 NOT NULL,
  certificate LONGTEXT CHARACTER SET utf8,
  last_updated DATETIME,
  fingerprint_sha256 VARCHAR(100) CHARACTER SET utf8,
  fingerprint_sha1 VARCHAR(60) CHARACTER SET utf8,
  issuer VARCHAR(255) CHARACTER SET utf8,
  subject VARCHAR(255) CHARACTER SET utf8,
  valid_from DATETIME,
  valid_to DATETIME,
  CONSTRAINT ssl_public_certificate_pk PRIMARY KEY (ssl_certificate_id)
) Engine=INNODB;

CREATE INDEX fingerprint_sha256_uq ON SSL_PUBLIC_CERTIFICATE(fingerprint_sha256);
CREATE INDEX fingerprint_sha1_uq ON SSL_PUBLIC_CERTIFICATE(fingerprint_sha1);
CREATE INDEX ssl_cert_alias_uq ON SSL_PUBLIC_CERTIFICATE(cert_alias);

CREATE TABLE SITEKEY (
  kid VARCHAR(36) CHARACTER SET utf8 NOT NULL,
  status SMALLINT DEFAULT 0 NOT NULL,
  last_modified TIMESTAMP NOT NULL,
  contents LONGTEXT CHARACTER SET utf8 NOT NULL,
  CONSTRAINT key_kid_pk PRIMARY KEY (kid),
  CONSTRAINT key_status_chk CHECK (status >= 0 AND status <= 1)
) Engine=INNODB;


CREATE TABLE AUDIT_LOG (
  audit_id INT AUTO_INCREMENT NOT NULL,
  audit_date DATETIME NOT NULL,
  auth_id INT,
  auth_name VARCHAR(100) CHARACTER SET utf8,
  description LONGTEXT CHARACTER SET utf8,
  object_type VARCHAR(50) CHARACTER SET utf8,
  object_id INT,
  operation VARCHAR(50) CHARACTER SET utf8,
  result INT,
  extension LONGTEXT CHARACTER SET utf8,
  CONSTRAINT audit_primary_key PRIMARY KEY (audit_id)
) Engine=INNODB;

CREATE INDEX audit_date_idx ON AUDIT_LOG(audit_date);

CREATE TABLE SSL_PRIVATE_KEY (
  ssl_private_key_id INT AUTO_INCREMENT NOT NULL,
  key_name VARCHAR(80) CHARACTER SET utf8 NOT NULL,
  keystore LONGTEXT CHARACTER SET utf8,
  last_updated DATETIME,
  fingerprint_sha256 VARCHAR(100) CHARACTER SET utf8,
  fingerprint_sha1 VARCHAR(60) CHARACTER SET utf8,
  issuer VARCHAR(255) CHARACTER SET utf8,
  subject VARCHAR(255) CHARACTER SET utf8,
  valid_from DATETIME,
  valid_to DATETIME,
  CONSTRAINT ssl_private_key_pk PRIMARY KEY (ssl_private_key_id)
) Engine=INNODB;

CREATE INDEX priv_fingerprint_sha256_uq ON SSL_PRIVATE_KEY(fingerprint_sha256);
CREATE INDEX priv_fingerprint_sha1_uq ON SSL_PRIVATE_KEY(fingerprint_sha1);
CREATE INDEX ssl_key_name_uq ON SSL_PRIVATE_KEY(key_name);

CREATE TABLE MODULE (
  module_id INT AUTO_INCREMENT NOT NULL,
  module_name VARCHAR(127) CHARACTER SET utf8 NOT NULL,
  module_kind SMALLINT DEFAULT 1 NOT NULL,
  CONSTRAINT module_pk PRIMARY KEY (module_id),
  CONSTRAINT module_name_unique UNIQUE (module_name)
) Engine=INNODB;


CREATE TABLE MODULE_VERSION (
  module_version_id INT AUTO_INCREMENT NOT NULL,
  module_id INT NOT NULL REFERENCES MODULE(module_id),
  version_number INT,
  create_timestamp DATETIME NOT NULL,
  user_name VARCHAR(255) CHARACTER SET utf8,
  fingerprint_sha256 VARCHAR(65) CHARACTER SET utf8 NOT NULL,
  definition LONGTEXT CHARACTER SET utf8 NOT NULL,
  CONSTRAINT module_version_pk PRIMARY KEY (module_version_id),
  CONSTRAINT version_number_unique UNIQUE (module_id, version_number)
) Engine=INNODB;

CREATE INDEX version_number_idx ON MODULE_VERSION(module_version_id, version_number);

CREATE TABLE MODULE_COLL (
  module_id INT NOT NULL REFERENCES MODULE(module_id),
  collection_id INT NOT NULL REFERENCES COLLECTION(collection_id),
  CONSTRAINT module_coll_unique_ids UNIQUE (module_id, collection_id)
) Engine=INNODB;


-- foreign keys
ALTER TABLE DATA_SERVICE ADD CONSTRAINT data_service_client_id_fk FOREIGN KEY (assoc_client_id) REFERENCES AUTHENTICATION(authentication_id);
ALTER TABLE DEPLOYMENT_VERSION ADD CONSTRAINT module_version_id_fk FOREIGN KEY (module_version_id) REFERENCES MODULE_VERSION(module_version_id);
ALTER TABLE DEPLOYMENT_CHANNEL_DEFAULT ADD CONSTRAINT collection_channel_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
