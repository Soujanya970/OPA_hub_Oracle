
CREATE TABLE AUTHENTICATION (
  authentication_id number(11) NOT NULL,
  user_name VARCHAR2(255 CHAR) NOT NULL,
  full_name VARCHAR2(255 CHAR),
  email VARCHAR2(255 CHAR),
  status NUMBER(5) DEFAULT 0 NOT NULL,
  change_password NUMBER(5) DEFAULT 0 NOT NULL,
  invalid_logins number(11) DEFAULT 0 NOT NULL,
  last_login_timestamp DATE,
  hub_admin NUMBER(5) DEFAULT 0 NOT NULL,
  user_type NUMBER(5) DEFAULT 0 NOT NULL,
  last_locked_timestamp DATE,
  CONSTRAINT authentication_pk PRIMARY KEY (authentication_id),
  CONSTRAINT authentication_status_check CHECK (status >= 0 AND status <= 3),
  CONSTRAINT change_password_chk CHECK (change_password >= 0 AND change_password <= 1),
  CONSTRAINT hub_admin_check CHECK (hub_admin >= 0 AND hub_admin <= 1),
  CONSTRAINT auth_unique_user_name UNIQUE (user_name)
);

CREATE SEQUENCE authentication_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE AUTHENTICATION_PWD (
  authentication_pwd_id number(11) NOT NULL,
  authentication_id number(11) NOT NULL,
  password VARCHAR2(512 CHAR),
  created_date DATE NOT NULL,
  status NUMBER(5) DEFAULT 1 NOT NULL,
  CONSTRAINT authentication_pwd_pk PRIMARY KEY (authentication_pwd_id),
  CONSTRAINT auth_pwd_status_check CHECK (status >= 0 AND status <= 2)
);

CREATE SEQUENCE authentication_pwd_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE SECURITY_TOKEN (
  security_token_id number(11) NOT NULL,
  authentication_id number(11),
  token_value VARCHAR2(255 CHAR) NOT NULL,
  issue_date DATE NOT NULL,
  verified_date DATE NOT NULL,
  is_long_term NUMBER(5) DEFAULT 0 NOT NULL,
  CONSTRAINT security_token_pk PRIMARY KEY (security_token_id),
  CONSTRAINT sec_unique_token_value UNIQUE (token_value),
  CONSTRAINT is_long_term_check CHECK (is_long_term >= 0 AND is_long_term <= 1)
);

CREATE SEQUENCE security_token_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE ROLE (
  role_id number(11) NOT NULL,
  role_name VARCHAR2(63 CHAR) NOT NULL,
  CONSTRAINT role_pk PRIMARY KEY (role_id),
  CONSTRAINT role_unique_role_name UNIQUE (role_name)
);

CREATE SEQUENCE role_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE COLLECTION (
  collection_id number(11) NOT NULL,
  collection_name VARCHAR2(127 CHAR) NOT NULL,
  collection_status number(11) NOT NULL,
  collection_description VARCHAR2(255 CHAR),
  deleted_timestamp DATE,
  CONSTRAINT collection_pk PRIMARY KEY (collection_id),
  CONSTRAINT collection_unique_coll_name UNIQUE (collection_name),
  CONSTRAINT collection_status_check CHECK (collection_status >= 0 AND collection_status <= 2)
);

CREATE SEQUENCE collection_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE AUTH_ROLE_COLL (
  authentication_id number(11) NOT NULL,
  role_id number(11) NOT NULL,
  collection_id number(11) NOT NULL,
  CONSTRAINT auth_coll_unique_ids UNIQUE (authentication_id, role_id, collection_id)
);


CREATE TABLE CONFIG_PROPERTY (
  config_property_name VARCHAR2(255 CHAR) NOT NULL,
  config_property_int_value number(11),
  config_property_str_value VARCHAR2(2048 CHAR),
  config_property_type number(11),
  config_property_public NUMBER(5) DEFAULT 0 NOT NULL,
  config_property_description VARCHAR2(1024 CHAR),
  CONSTRAINT config_property_pk PRIMARY KEY (config_property_name)
);


CREATE TABLE DATA_SERVICE (
  data_service_id number(11) NOT NULL,
  service_name VARCHAR2(255 CHAR) NOT NULL,
  service_type VARCHAR2(255 CHAR) NOT NULL,
  version VARCHAR2(20 CHAR),
  url VARCHAR2(1024 CHAR),
  last_updated DATE NOT NULL,
  service_user VARCHAR2(255 CHAR),
  service_pass VARCHAR2(255 CHAR),
  use_wss NUMBER(5) DEFAULT 0 NOT NULL,
  wss_use_timestamp NUMBER(5),
  shared_secret VARCHAR2(255 CHAR),
  rn_shared_secret VARCHAR2(255 CHAR),
  cx_site_name VARCHAR2(255 CHAR),
  bearer_token_param VARCHAR2(255 CHAR),
  status NUMBER(5) DEFAULT 0 NOT NULL,
  soap_action_pattern VARCHAR2(255 CHAR),
  metadata CLOB,
  use_trust_store NUMBER(5) DEFAULT 0 NOT NULL,
  ssl_private_key VARCHAR2(80 CHAR),
  assoc_client_id number(11),
  cookie_param VARCHAR2(255 CHAR),
  CONSTRAINT data_service_pk PRIMARY KEY (data_service_id),
  CONSTRAINT service_name_unique UNIQUE (service_name),
  CONSTRAINT use_trust_store_check CHECK (use_trust_store >= 0 AND use_trust_store <= 1)
);

CREATE SEQUENCE data_service_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE DATA_SERVICE_COLL (
  data_service_id number(11) NOT NULL,
  collection_id number(11) NOT NULL,
  CONSTRAINT data_service_coll_unique_ids UNIQUE (data_service_id, collection_id)
);


CREATE TABLE LOG_ENTRY (
  log_entry_id number(11) NOT NULL,
  entry_timestamp DATE NOT NULL,
  entry_type VARCHAR2(15 CHAR) NOT NULL,
  code VARCHAR2(15 CHAR) NOT NULL,
  message CLOB NOT NULL,
  origin VARCHAR2(30 CHAR),
  CONSTRAINT log_entry_primary_key PRIMARY KEY (log_entry_id)
);

CREATE SEQUENCE log_entry_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX entry_timestamp_idx ON LOG_ENTRY(entry_timestamp);

CREATE TABLE SNAPSHOT (
  snapshot_id number(11) NOT NULL,
  uploaded_date DATE NOT NULL,
  fingerprint_sha256 VARCHAR2(65 CHAR),
  scan_status NUMBER(5) DEFAULT 0 NOT NULL,
  scan_message VARCHAR2(255 CHAR),
  CONSTRAINT snapshot_id_pk PRIMARY KEY (snapshot_id)
);

CREATE SEQUENCE snapshot_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE SNAPSHOT_CHUNK (
  snapshot_id number(11) NOT NULL,
  chunk_sequence number(11) NOT NULL,
  chunk_slice CLOB NOT NULL,
  CONSTRAINT snapshot_chunk_unique PRIMARY KEY (snapshot_id, chunk_sequence)
);


CREATE TABLE PROJECT (
  project_id number(11) NOT NULL,
  project_name VARCHAR2(127 CHAR) NOT NULL,
  project_description VARCHAR2(255 CHAR),
  last_updated DATE NOT NULL,
  latest_version number(11),
  deleted_timestamp DATE,
  CONSTRAINT project_id_pk PRIMARY KEY (project_id),
  CONSTRAINT project_name_unique UNIQUE (project_name)
);

CREATE SEQUENCE project_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE PROJECT_VERSION (
  project_version_id number(11) NOT NULL,
  project_id number(11) NOT NULL,
  project_version number(11) NOT NULL,
  project_snapshot_id number(11) NOT NULL,
  version_uuid VARCHAR2(36 CHAR),
  activatable NUMBER(5) DEFAULT 0 NOT NULL,
  user_name VARCHAR2(255 CHAR) NOT NULL,
  opa_version VARCHAR2(15 CHAR) NOT NULL,
  description VARCHAR2(255 CHAR) NOT NULL,
  creation_date DATE NOT NULL,
  deleted_timestamp DATE,
  CONSTRAINT project_version_pk PRIMARY KEY (project_version_id)
);

CREATE SEQUENCE project_version_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX project_version_project_idx ON PROJECT_VERSION(project_id);
CREATE INDEX project_version_snapshot_idx ON PROJECT_VERSION(project_snapshot_id);
CREATE INDEX version_uuid_idx ON PROJECT_VERSION(version_uuid);

CREATE TABLE PROJECT_VERSION_CHANGE (
  project_version_change_id number(11) NOT NULL,
  project_version_id number(11) NOT NULL,
  object_name VARCHAR2(255 CHAR) NOT NULL,
  change_type NUMBER(5) NOT NULL,
  CONSTRAINT project_version_change_pk PRIMARY KEY (project_version_change_id),
  CONSTRAINT project_version_change_unique UNIQUE (project_version_id, object_name)
);

CREATE SEQUENCE project_change_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE PROJECT_OBJECT_STATUS (
  project_object_status_id number(11) NOT NULL,
  project_id number(11) NOT NULL,
  object_name VARCHAR2(255 CHAR) NOT NULL,
  lock_machine VARCHAR2(255 CHAR) NOT NULL,
  lock_folder VARCHAR2(1024 CHAR) NOT NULL,
  lock_user number(11) NOT NULL,
  lock_timestamp DATE NOT NULL,
  CONSTRAINT project_object_status_id_pk PRIMARY KEY (project_object_status_id),
  CONSTRAINT project_object_unique UNIQUE (project_id, object_name)
);

CREATE SEQUENCE project_object_status_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE PROJECT_COLL (
  project_id number(11) NOT NULL,
  collection_id number(11) NOT NULL,
  CONSTRAINT project_coll_unique_ids UNIQUE (project_id, collection_id)
);


CREATE TABLE DEPLOYMENT (
  deployment_id number(11) NOT NULL,
  deployment_name VARCHAR2(127 CHAR) NOT NULL,
  deployment_description VARCHAR2(255 CHAR),
  last_updated DATE NOT NULL,
  activated_version_id number(11),
  activated_interview NUMBER(5) DEFAULT 0 NOT NULL,
  activated_webservice NUMBER(5) DEFAULT 0 NOT NULL,
  activated_interviewservice NUMBER(5) DEFAULT 0 NOT NULL,
  activated_chatservice NUMBER(5) DEFAULT 0 NOT NULL,
  activated_mobile NUMBER(5) DEFAULT 0 NOT NULL,
  compatibility_mode NUMBER(5) DEFAULT 0 NOT NULL,
  user_name VARCHAR2(255 CHAR),
  deleted_timestamp DATE,
  CONSTRAINT deployment_id_pk PRIMARY KEY (deployment_id),
  CONSTRAINT deployment_name_unique UNIQUE (deployment_name)
);

CREATE SEQUENCE deployment_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE DEPLOYMENT_VERSION (
  deployment_version_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version number(11) NOT NULL,
  deployment_version_kind NUMBER(5) DEFAULT 0 NOT NULL,
  snapshot_id number(11),
  module_version_id number(11),
  user_name VARCHAR2(255 CHAR),
  opa_version VARCHAR2(15 CHAR) NOT NULL,
  description VARCHAR2(255 CHAR) NOT NULL,
  activatable NUMBER(5) DEFAULT 1 NOT NULL,
  snapshot_date DATE NOT NULL,
  snapshot_deleted_timestamp DATE,
  mapping_type VARCHAR2(32 CHAR),
  data_service_id number(11),
  data_service_used NUMBER(5) DEFAULT 0 NOT NULL,
  CONSTRAINT deployment_version_pk PRIMARY KEY (deployment_version_id),
  CONSTRAINT activatable_check CHECK (activatable >= 0 AND activatable <= 1),
  CONSTRAINT data_service_used_check CHECK (data_service_used >= 0 AND data_service_used <= 2)
);

CREATE SEQUENCE deployment_version_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX deployment_ver_deployment_idx ON DEPLOYMENT_VERSION(deployment_id);
CREATE INDEX deployment_ver_snapshot_idx ON DEPLOYMENT_VERSION(snapshot_id);

CREATE TABLE DEPLOYMENT_ACTIVATION_HISTORY (
  deployment_activation_hist_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  activation_date DATE NOT NULL,
  status_interview NUMBER(5) DEFAULT 0 NOT NULL,
  status_webservice NUMBER(5) DEFAULT 0 NOT NULL,
  status_interviewservice NUMBER(5) DEFAULT 0 NOT NULL,
  status_chatservice NUMBER(5) DEFAULT 0 NOT NULL,
  status_mobile NUMBER(5) DEFAULT 0 NOT NULL,
  user_name VARCHAR2(255 CHAR) NOT NULL,
  CONSTRAINT deployment_act_history_pk PRIMARY KEY (deployment_activation_hist_id)
);

CREATE SEQUENCE deployment_activation_hist_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX deployment_act_hist_depl_idx ON DEPLOYMENT_ACTIVATION_HISTORY(deployment_id);

CREATE TABLE DEPLOYMENT_RULEBASE_REPOS (
  id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  chunk_sequence number(11) NOT NULL,
  chunk_slice CLOB NOT NULL,
  uploaded_date DATE NOT NULL,
  CONSTRAINT deployment_rb_repos_pk PRIMARY KEY (id),
  CONSTRAINT deployment_rb_repos_unique UNIQUE (deployment_version_id, chunk_sequence)
);

CREATE SEQUENCE deployment_rulebase_repos_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE DEPLOYMENT_COLL (
  deployment_id number(11) NOT NULL,
  collection_id number(11) NOT NULL,
  CONSTRAINT deployment_coll_unique_ids UNIQUE (deployment_id, collection_id)
);


CREATE TABLE DEPLOYMENT_CHANNEL_DEFAULT (
  channel_default_id number(11) NOT NULL,
  collection_id number(11) NOT NULL,
  default_interview NUMBER(5) DEFAULT 0 NOT NULL,
  default_webservice NUMBER(5) DEFAULT 0 NOT NULL,
  default_interviewservice NUMBER(5) DEFAULT 0 NOT NULL,
  default_mobile NUMBER(5) DEFAULT 0 NOT NULL,
  default_chatservice NUMBER(5) DEFAULT 0 NOT NULL,
  defaults_can_override NUMBER(5) DEFAULT 1 NOT NULL,
  CONSTRAINT channel_default_idx PRIMARY KEY (channel_default_id),
  CONSTRAINT default_interview_check CHECK (default_interview >= 0 AND default_interview <= 1),
  CONSTRAINT default_webservice_check CHECK (default_webservice >= 0 AND default_webservice <= 1),
  CONSTRAINT default_mobile_check CHECK (default_mobile >= 0 AND default_mobile <= 1),
  CONSTRAINT default_chatservice_check CHECK (default_chatservice >= 0 AND default_chatservice <= 1),
  CONSTRAINT default_override_check CHECK (defaults_can_override >= 0 AND defaults_can_override <= 1)
);

CREATE SEQUENCE deployment_channel_default_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX collection_id_uq ON DEPLOYMENT_CHANNEL_DEFAULT(collection_id);

CREATE TABLE OPERATION (
  operation_id number(11) NOT NULL,
  operation_name VARCHAR2(255 CHAR) NOT NULL,
  operation_type number(11) NOT NULL,
  operation_state number(11) NOT NULL,
  operation_version number(11) NOT NULL,
  operation_model CLOB NOT NULL,
  invoke_url VARCHAR2(1024 CHAR),
  status_url VARCHAR2(1024 CHAR),
  query_param_names VARCHAR2(1024 CHAR),
  CONSTRAINT operation_pk PRIMARY KEY (operation_id),
  CONSTRAINT operation_name_unique UNIQUE (operation_name)
);

CREATE SEQUENCE operation_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX operation_type_state ON OPERATION(operation_type, operation_state);

CREATE TABLE DEPLOYMENT_VERSION_OPERATION (
  deployment_version_id number(11) NOT NULL,
  operation_id number(11) NOT NULL,
  CONSTRAINT depl_vers_operation_unique UNIQUE (deployment_version_id, operation_id)
);


CREATE TABLE SESSION_STATS_TEMPLATE (
  session_stats_template_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  CONSTRAINT session_stats_template_pk PRIMARY KEY (session_stats_template_id),
  CONSTRAINT session_stats_template_uq UNIQUE (deployment_id, deployment_version_id)
);

CREATE SEQUENCE session_stats_template_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE SESSION_SCREEN_TEMPLATE (
  session_screen_template_id number(11) NOT NULL,
  session_stats_template_id number(11) NOT NULL,
  screen_id VARCHAR2(50 CHAR) NOT NULL,
  screen_title VARCHAR2(255 CHAR) NOT NULL,
  screen_action_code number(11) NOT NULL,
  screen_order number(11) NOT NULL,
  CONSTRAINT session_screen_template_pk PRIMARY KEY (session_screen_template_id),
  CONSTRAINT session_screen_template_uk UNIQUE (session_stats_template_id, screen_id)
);

CREATE SEQUENCE session_screen_template_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE SESSION_STATS_LOG (
  session_stats_log_id NUMBER(19) NOT NULL,
  session_stats_template_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  product_code number(11) NOT NULL,
  product_version VARCHAR2(25 CHAR) NOT NULL,
  product_function_code number(11) NOT NULL,
  product_function_version VARCHAR2(25 CHAR),
  created_timestamp DATE,
  created_year number(11) NOT NULL,
  created_month number(11) NOT NULL,
  created_day number(11) NOT NULL,
  created_hour number(11) NOT NULL,
  last_modified_timestamp DATE,
  last_modified_year number(11) NOT NULL,
  last_modified_month number(11) NOT NULL,
  last_modified_day number(11) NOT NULL,
  last_modified_hour number(11) NOT NULL,
  duration_millis NUMBER(19) NOT NULL,
  duration_sec number(11) NOT NULL,
  duration_min number(11) NOT NULL,
  screens_visited number(11) NOT NULL,
  auth_id RAW(16),
  authenticated NUMBER(5) NOT NULL,
  completed NUMBER(5) NOT NULL,
  CONSTRAINT session_stats_log_pk PRIMARY KEY (session_stats_log_id)
);

CREATE SEQUENCE session_stats_log_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX usage_trend ON SESSION_STATS_LOG(created_hour, deployment_id);
CREATE INDEX obsolete_api_usage ON SESSION_STATS_LOG(deployment_id, created_timestamp, product_function_version, product_function_code, product_code);
CREATE INDEX sessions_by_year ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_year);
CREATE INDEX sessions_by_month ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_month);
CREATE INDEX sessions_by_day ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_day);
CREATE INDEX sessions_by_hour ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, created_hour);
CREATE INDEX sessions_by_duration_min ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, duration_min);
CREATE INDEX sessions_by_screens_visited ON SESSION_STATS_LOG(product_function_code, auth_id, created_timestamp, deployment_id, deployment_version_id, screens_visited);

CREATE TABLE SESSION_SCREEN_LOG (
  session_screen_log_id NUMBER(19) NOT NULL,
  session_stats_log_id NUMBER(19) NOT NULL,
  session_stats_template_id NUMBER(19) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  product_code number(11) NOT NULL,
  product_version VARCHAR2(25 CHAR) NOT NULL,
  product_function_code number(11) NOT NULL,
  session_created_timestamp DATE,
  auth_id RAW(16),
  authenticated NUMBER(5) NOT NULL,
  screen_id VARCHAR2(50 CHAR) NOT NULL,
  screen_order number(11) NOT NULL,
  screen_action_code number(11) NOT NULL,
  screen_sequence number(11) NOT NULL,
  entry_transition_code NUMBER(5) NOT NULL,
  entry_timestamp DATE,
  submit_timestamp DATE,
  exit_transition_code NUMBER(5),
  exit_timestamp DATE,
  duration_millis NUMBER(19) NOT NULL,
  duration_sec number(11) NOT NULL,
  duration_min number(11) NOT NULL,
  CONSTRAINT session_screen_log_pk PRIMARY KEY (session_screen_log_id)
);

CREATE SEQUENCE session_screen_log_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX screen_by_session_id ON SESSION_SCREEN_LOG(session_stats_log_id);
CREATE INDEX screen_by_vers_id_action ON SESSION_SCREEN_LOG(deployment_version_id, session_created_timestamp, screen_id, screen_action_code);

CREATE TABLE SESSION_STATS_UID (
  session_uid VARCHAR2(36 CHAR) NOT NULL,
  session_stats_log_id NUMBER(19) NOT NULL,
  CONSTRAINT SESSION_STATS_UID_PK PRIMARY KEY (session_uid)
);


CREATE TABLE SESSION_STATS_LOG_V2 (
  session_stats_log_v2_id NUMBER(19) NOT NULL,
  session_stats_template_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  product_code number(11) NOT NULL,
  product_version VARCHAR2(25 CHAR) NOT NULL,
  product_function_code number(11) NOT NULL,
  product_function_version VARCHAR2(25 CHAR),
  created_timestamp DATE,
  created_year NUMBER(19) NOT NULL,
  created_month NUMBER(19) NOT NULL,
  created_day NUMBER(19) NOT NULL,
  created_hour NUMBER(19) NOT NULL,
  last_modified_timestamp DATE,
  last_modified_year NUMBER(19) NOT NULL,
  last_modified_month NUMBER(19) NOT NULL,
  last_modified_day NUMBER(19) NOT NULL,
  last_modified_hour NUMBER(19) NOT NULL,
  duration_millis NUMBER(19) NOT NULL,
  duration_sec NUMBER(19) NOT NULL,
  duration_min NUMBER(19) NOT NULL,
  screens_visited number(11) NOT NULL,
  auth_id RAW(16),
  auth_role NUMBER(5) NOT NULL,
  completed NUMBER(5) NOT NULL,
  data_service_id number(11),
  data_service_type number(11),
  data_service_version VARCHAR2(25 CHAR),
  agent NUMBER(5) DEFAULT 0 NOT NULL,
  CONSTRAINT session_stats_log_v2_pk PRIMARY KEY (session_stats_log_v2_id)
);

CREATE SEQUENCE session_stats_log_v2_seq START WITH 1 INCREMENT BY 1;
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
  session_screen_log_v2_id NUMBER(19) NOT NULL,
  session_stats_log_v2_id NUMBER(19) NOT NULL,
  session_stats_template_id NUMBER(19) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  product_code number(11) NOT NULL,
  product_version VARCHAR2(25 CHAR) NOT NULL,
  product_function_code number(11) NOT NULL,
  session_created_timestamp DATE,
  auth_id RAW(16),
  auth_role NUMBER(5) NOT NULL,
  screen_id VARCHAR2(50 CHAR) NOT NULL,
  screen_order number(11) NOT NULL,
  screen_action_code number(11) NOT NULL,
  screen_sequence number(11) NOT NULL,
  entry_transition_code NUMBER(5) NOT NULL,
  entry_timestamp DATE,
  submit_timestamp DATE,
  exit_transition_code NUMBER(5),
  exit_timestamp DATE,
  duration_millis NUMBER(19) NOT NULL,
  duration_sec NUMBER(19) NOT NULL,
  duration_min NUMBER(19) NOT NULL,
  data_service_id number(11),
  data_service_type number(11),
  data_service_version VARCHAR2(25 CHAR),
  agent NUMBER(5) DEFAULT 0 NOT NULL,
  CONSTRAINT session_screen_log_v2_pk PRIMARY KEY (session_screen_log_v2_id)
);

CREATE SEQUENCE session_screen_log_v2_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX screen_by_session_v2_id ON SESSION_SCREEN_LOG_V2(session_stats_log_v2_id);
CREATE INDEX screen_by_session_state_v2 ON SESSION_SCREEN_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, session_created_timestamp, session_stats_log_v2_id, screen_id, screen_action_code);
CREATE INDEX screen_by_session_duration_v2 ON SESSION_SCREEN_LOG_V2(deployment_id, deployment_version_id, product_function_code, agent, session_created_timestamp, session_stats_log_v2_id, screen_id, duration_millis);

CREATE TABLE SESSION_STATS_UID_V2 (
  session_uid VARCHAR2(36 CHAR) NOT NULL,
  session_stats_log_v2_id NUMBER(19) NOT NULL,
  CONSTRAINT SESSION_STATS_UID_V2_PK PRIMARY KEY (session_uid)
);


CREATE TABLE STATISTICS_CHART (
  statistics_chart_id number(11) NOT NULL,
  chart_type VARCHAR2(30 CHAR) NOT NULL,
  chart_data CLOB NOT NULL,
  CONSTRAINT statistics_chart_pk PRIMARY KEY (statistics_chart_id)
);

CREATE SEQUENCE statistics_chart_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE DEPLOYMENT_STATS_CHART (
  deployment_stats_chart_id number(11) NOT NULL,
  statistics_chart_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  chart_number number(11) NOT NULL,
  CONSTRAINT deployment_stats_chart_pk PRIMARY KEY (deployment_stats_chart_id),
  CONSTRAINT deployment_stats_chart_uq UNIQUE (deployment_id, chart_number)
);

CREATE SEQUENCE deployment_stats_chart_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE OVERVIEW_STATS_CHART (
  overview_stats_chart_id number(11) NOT NULL,
  statistics_chart_id number(11) NOT NULL,
  chart_number number(11) NOT NULL,
  CONSTRAINT overview_stats_chart_pk PRIMARY KEY (overview_stats_chart_id),
  CONSTRAINT overview_stats_chart_uq UNIQUE (chart_number)
);

CREATE SEQUENCE overview_stats_chart_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE FUNCTION_STATS_LOG (
  function_stats_log_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  product_code number(11) NOT NULL,
  product_function_code number(11) NOT NULL,
  product_function_version VARCHAR2(25 CHAR) NOT NULL,
  last_used_timestamp DATE NOT NULL,
  CONSTRAINT function_stats_log_pk PRIMARY KEY (function_stats_log_id),
  CONSTRAINT function_stats_log_uq UNIQUE (deployment_id, product_code, product_function_code, product_function_version)
);

CREATE SEQUENCE function_stats_log_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX function_usage_obsolete ON FUNCTION_STATS_LOG(last_used_timestamp, product_code, product_function_code, product_function_version, deployment_id);

CREATE TABLE RULE_ELEMENT (
  rule_element_id number(11) NOT NULL,
  rule_element_name VARCHAR2(255 CHAR) NOT NULL,
  CONSTRAINT RULE_ELEMENT_PK PRIMARY KEY (rule_element_id),
  CONSTRAINT RULE_ELEMENT_UQ UNIQUE (rule_element_name)
);

CREATE SEQUENCE rule_element_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE RULE_ELEMENT_STATS_LOG (
  rule_element_stats_log_id number(11) NOT NULL,
  rule_element_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  reference_count number(11) NOT NULL,
  CONSTRAINT RULE_ELEMENT_STATS_LOG_PK PRIMARY KEY (rule_element_stats_log_id),
  CONSTRAINT RULE_ELEMENT_STATS_LOG_UQ UNIQUE (rule_element_id, deployment_id, deployment_version_id)
);

CREATE SEQUENCE rule_element_stats_log_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX RULE_ELEMENT_DEPL_VERS_REF_IDX ON RULE_ELEMENT_STATS_LOG(rule_element_id, deployment_id, deployment_version_id, reference_count);

CREATE TABLE ASSESSMENT_STATS_LOG (
  assessment_stats_log_id number(11) NOT NULL,
  deployment_id number(11) NOT NULL,
  deployment_version_id number(11) NOT NULL,
  product_code number(11) NOT NULL,
  product_version VARCHAR2(25 CHAR) NOT NULL,
  product_function_code number(11) NOT NULL,
  product_function_version VARCHAR2(25 CHAR) NOT NULL,
  created_timestamp DATE NOT NULL,
  created_year NUMBER(19) NOT NULL,
  created_month NUMBER(19) NOT NULL,
  created_day NUMBER(19) NOT NULL,
  created_hour NUMBER(19) NOT NULL,
  duration_millis NUMBER(19) NOT NULL,
  duration_sec NUMBER(19) NOT NULL,
  duration_min NUMBER(19) NOT NULL,
  cases_read number(11) NOT NULL,
  cases_processed number(11) NOT NULL,
  auth_id RAW(16),
  authenticated NUMBER(5) NOT NULL,
  CONSTRAINT assessment_stats_log_pk PRIMARY KEY (assessment_stats_log_id)
);

CREATE SEQUENCE assessment_stats_log_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX assessment_usage_trend ON ASSESSMENT_STATS_LOG(deployment_id, created_hour, cases_read);
CREATE INDEX assessments_by_year ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_year, cases_read);
CREATE INDEX assessments_by_month ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_month, cases_read);
CREATE INDEX assessments_by_day ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_day, cases_read);
CREATE INDEX assessments_by_hour ON ASSESSMENT_STATS_LOG(deployment_id, deployment_version_id, product_function_code, created_timestamp, created_hour, cases_read);

CREATE TABLE SSL_PUBLIC_CERTIFICATE (
  ssl_certificate_id number(11) NOT NULL,
  cert_alias VARCHAR2(80 CHAR) NOT NULL,
  certificate CLOB,
  last_updated DATE,
  fingerprint_sha256 VARCHAR2(100 CHAR),
  fingerprint_sha1 VARCHAR2(60 CHAR),
  issuer VARCHAR2(255 CHAR),
  subject VARCHAR2(255 CHAR),
  valid_from DATE,
  valid_to DATE,
  CONSTRAINT ssl_public_certificate_pk PRIMARY KEY (ssl_certificate_id)
);

CREATE SEQUENCE ssl_certificate_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX fingerprint_sha256_uq ON SSL_PUBLIC_CERTIFICATE(fingerprint_sha256);
CREATE INDEX fingerprint_sha1_uq ON SSL_PUBLIC_CERTIFICATE(fingerprint_sha1);
CREATE INDEX ssl_cert_alias_uq ON SSL_PUBLIC_CERTIFICATE(cert_alias);

CREATE TABLE SITEKEY (
  kid VARCHAR2(36 CHAR) NOT NULL,
  status NUMBER(5) DEFAULT 0 NOT NULL,
  last_modified DATE NOT NULL,
  contents CLOB NOT NULL,
  CONSTRAINT key_kid_pk PRIMARY KEY (kid),
  CONSTRAINT key_status_chk CHECK (status >= 0 AND status <= 1)
);


CREATE TABLE AUDIT_LOG (
  audit_id number(11) NOT NULL,
  audit_date DATE NOT NULL,
  auth_id number(11),
  auth_name VARCHAR2(100 CHAR),
  description CLOB,
  object_type VARCHAR2(50 CHAR),
  object_id number(11),
  operation VARCHAR2(50 CHAR),
  result number(11),
  extension CLOB,
  CONSTRAINT audit_primary_key PRIMARY KEY (audit_id)
);

CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX audit_date_idx ON AUDIT_LOG(audit_date);

CREATE TABLE SSL_PRIVATE_KEY (
  ssl_private_key_id number(11) NOT NULL,
  key_name VARCHAR2(80 CHAR) NOT NULL,
  keystore CLOB,
  last_updated DATE,
  fingerprint_sha256 VARCHAR2(100 CHAR),
  fingerprint_sha1 VARCHAR2(60 CHAR),
  issuer VARCHAR2(255 CHAR),
  subject VARCHAR2(255 CHAR),
  valid_from DATE,
  valid_to DATE,
  CONSTRAINT ssl_private_key_pk PRIMARY KEY (ssl_private_key_id)
);

CREATE SEQUENCE ssl_private_key_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX priv_fingerprint_sha256_uq ON SSL_PRIVATE_KEY(fingerprint_sha256);
CREATE INDEX priv_fingerprint_sha1_uq ON SSL_PRIVATE_KEY(fingerprint_sha1);
CREATE INDEX ssl_key_name_uq ON SSL_PRIVATE_KEY(key_name);

CREATE TABLE MODULE (
  module_id number(11) NOT NULL,
  module_name VARCHAR2(127 CHAR) NOT NULL,
  module_kind NUMBER(5) DEFAULT 1 NOT NULL,
  CONSTRAINT module_pk PRIMARY KEY (module_id),
  CONSTRAINT module_name_unique UNIQUE (module_name)
);

CREATE SEQUENCE module_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE MODULE_VERSION (
  module_version_id number(11) NOT NULL,
  module_id number(11) NOT NULL,
  version_number number(11),
  create_timestamp DATE NOT NULL,
  user_name VARCHAR2(255 CHAR),
  fingerprint_sha256 VARCHAR2(65 CHAR) NOT NULL,
  definition CLOB NOT NULL,
  CONSTRAINT module_version_pk PRIMARY KEY (module_version_id),
  CONSTRAINT version_number_unique UNIQUE (module_id, version_number)
);

CREATE SEQUENCE module_version_seq START WITH 1 INCREMENT BY 1;
CREATE INDEX version_number_idx ON MODULE_VERSION(module_version_id, version_number);

CREATE TABLE MODULE_COLL (
  module_id number(11) NOT NULL,
  collection_id number(11) NOT NULL,
  CONSTRAINT module_coll_unique_ids UNIQUE (module_id, collection_id)
);


-- foreign keys
ALTER TABLE AUTHENTICATION_PWD ADD CONSTRAINT authentication_pwd_id_fk FOREIGN KEY (authentication_id) REFERENCES AUTHENTICATION(authentication_id);
ALTER TABLE AUTH_ROLE_COLL ADD CONSTRAINT auth_role_coll_coll_id_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
ALTER TABLE AUTH_ROLE_COLL ADD CONSTRAINT auth_role_coll_role_id_fk FOREIGN KEY (role_id) REFERENCES ROLE(role_id);
ALTER TABLE AUTH_ROLE_COLL ADD CONSTRAINT auth_role_coll_auth_id_fk FOREIGN KEY (authentication_id) REFERENCES AUTHENTICATION(authentication_id);
ALTER TABLE DATA_SERVICE ADD CONSTRAINT data_service_client_id_fk FOREIGN KEY (assoc_client_id) REFERENCES AUTHENTICATION(authentication_id);
ALTER TABLE DATA_SERVICE_COLL ADD CONSTRAINT data_service_coll_coll_id_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
ALTER TABLE DATA_SERVICE_COLL ADD CONSTRAINT data_service_coll_ds_id_fk FOREIGN KEY (data_service_id) REFERENCES DATA_SERVICE(data_service_id);
ALTER TABLE PROJECT_VERSION ADD CONSTRAINT project_version_id_fk FOREIGN KEY (project_id) REFERENCES PROJECT(project_id);
ALTER TABLE PROJECT_VERSION ADD CONSTRAINT project_version_snapshot_fk FOREIGN KEY (project_snapshot_id) REFERENCES SNAPSHOT(snapshot_id);
ALTER TABLE PROJECT_VERSION_CHANGE ADD CONSTRAINT project_version_change_id_fk FOREIGN KEY (project_version_id) REFERENCES PROJECT_VERSION(project_version_id);
ALTER TABLE PROJECT_OBJECT_STATUS ADD CONSTRAINT project_object_id_fk FOREIGN KEY (project_id) REFERENCES PROJECT(project_id);
ALTER TABLE PROJECT_OBJECT_STATUS ADD CONSTRAINT lock_user_fk FOREIGN KEY (lock_user) REFERENCES AUTHENTICATION(authentication_id);
ALTER TABLE PROJECT_COLL ADD CONSTRAINT project_coll_coll_id_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
ALTER TABLE PROJECT_COLL ADD CONSTRAINT project_coll_project_id_fk FOREIGN KEY (project_id) REFERENCES PROJECT(project_id);
ALTER TABLE DEPLOYMENT ADD CONSTRAINT activated_version_fk FOREIGN KEY (activated_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id);
ALTER TABLE DEPLOYMENT_VERSION ADD CONSTRAINT deployment_version_id_fk FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE DEPLOYMENT_VERSION ADD CONSTRAINT deployment_snapshot_id_fk FOREIGN KEY (snapshot_id) REFERENCES SNAPSHOT(snapshot_id);
ALTER TABLE DEPLOYMENT_VERSION ADD CONSTRAINT module_version_id_fk FOREIGN KEY (module_version_id) REFERENCES MODULE_VERSION(module_version_id);
ALTER TABLE DEPLOYMENT_ACTIVATION_HISTORY ADD CONSTRAINT deployment_act_history_id_fk FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE DEPLOYMENT_ACTIVATION_HISTORY ADD CONSTRAINT deployment_act_version_id_fk FOREIGN KEY (deployment_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id);
ALTER TABLE DEPLOYMENT_RULEBASE_REPOS ADD CONSTRAINT deployment_rb_version_fk FOREIGN KEY (deployment_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id);
ALTER TABLE DEPLOYMENT_COLL ADD CONSTRAINT deployment_coll_coll_id_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
ALTER TABLE DEPLOYMENT_COLL ADD CONSTRAINT deployment_coll_deploy_id_fk FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE DEPLOYMENT_CHANNEL_DEFAULT ADD CONSTRAINT collection_channel_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
ALTER TABLE DEPLOYMENT_VERSION_OPERATION ADD CONSTRAINT DEPL_VERS_VERSION_ID FOREIGN KEY (deployment_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id);
ALTER TABLE DEPLOYMENT_VERSION_OPERATION ADD CONSTRAINT DEPL_VERS_OPERATION_ID FOREIGN KEY (operation_id) REFERENCES OPERATION(operation_id);
ALTER TABLE SESSION_STATS_TEMPLATE ADD CONSTRAINT SESS_STATS_TEMPL_DEPLOY_ID FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE SESSION_STATS_TEMPLATE ADD CONSTRAINT SESS_STATS_TEMPL_VERSION_ID FOREIGN KEY (deployment_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id);
ALTER TABLE SESSION_SCREEN_TEMPLATE ADD CONSTRAINT SESS_SCR_TEMPL_SESS_TEMPL_FK FOREIGN KEY (session_stats_template_id) REFERENCES SESSION_STATS_TEMPLATE(session_stats_template_id);
ALTER TABLE SESSION_STATS_LOG ADD CONSTRAINT SESS_STATS_LOG_TEMPL_FK FOREIGN KEY (session_stats_template_id) REFERENCES SESSION_STATS_TEMPLATE(session_stats_template_id);
ALTER TABLE SESSION_STATS_LOG ADD CONSTRAINT SESS_STATS_DEPLOYMENT_FK FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE SESSION_SCREEN_LOG ADD CONSTRAINT SESSION_SCREEN_STATS_LOG_FK FOREIGN KEY (session_stats_log_id) REFERENCES SESSION_STATS_LOG(session_stats_log_id);
ALTER TABLE SESSION_SCREEN_LOG ADD CONSTRAINT SESSION_SCREEN_STATS_TEMPL_FK FOREIGN KEY (session_stats_template_id) REFERENCES SESSION_STATS_TEMPLATE(session_stats_template_id);
ALTER TABLE SESSION_SCREEN_LOG ADD CONSTRAINT SESSION_SCREEN_DEPLOYMENT_FK FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE SESSION_SCREEN_LOG ADD CONSTRAINT SESSION_SCREEN_DEPL_VERS_FK FOREIGN KEY (deployment_version_id) REFERENCES DEPLOYMENT_VERSION(deployment_version_id);
ALTER TABLE DEPLOYMENT_STATS_CHART ADD CONSTRAINT DEPL_CHART_STAT_CHART_FK FOREIGN KEY (statistics_chart_id) REFERENCES STATISTICS_CHART(statistics_chart_id);
ALTER TABLE DEPLOYMENT_STATS_CHART ADD CONSTRAINT DEPL_CHART_DEPLOYMENT_FK FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE OVERVIEW_STATS_CHART ADD CONSTRAINT OVER_CHART_STAT_CHART_FK FOREIGN KEY (statistics_chart_id) REFERENCES STATISTICS_CHART(statistics_chart_id);
ALTER TABLE FUNCTION_STATS_LOG ADD CONSTRAINT FUNCTION_STATS_DEPLOY_FK FOREIGN KEY (deployment_id) REFERENCES DEPLOYMENT(deployment_id);
ALTER TABLE RULE_ELEMENT_STATS_LOG ADD CONSTRAINT RULE_ELEMENT_STATS_LOG_FK FOREIGN KEY (rule_element_id) REFERENCES RULE_ELEMENT(rule_element_id);
ALTER TABLE MODULE_VERSION ADD CONSTRAINT module_id_fk FOREIGN KEY (module_id) REFERENCES MODULE(module_id);
ALTER TABLE MODULE_COLL ADD CONSTRAINT module_coll_coll_id_fk FOREIGN KEY (collection_id) REFERENCES COLLECTION(collection_id);
ALTER TABLE MODULE_COLL ADD CONSTRAINT module_coll_deploy_id_fk FOREIGN KEY (module_id) REFERENCES MODULE(module_id);
