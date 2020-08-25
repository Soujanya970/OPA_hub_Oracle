
CREATE TABLE IF NOT EXISTS SESSION_STATS_LOG_V2 (
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
  CONSTRAINT session_stats_log_v2_pk PRIMARY KEY (session_stats_log_v2_id)
) Engine=INNODB;


CREATE TABLE IF NOT EXISTS SESSION_SCREEN_LOG_V2 (
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
  CONSTRAINT session_screen_log_v2_pk PRIMARY KEY (session_screen_log_v2_id)
) Engine=INNODB;

CALL OPAAddIndexIfNotExists('SESSION_SCREEN_LOG_V2', 'screen_by_session_v2_id', '(session_stats_log_v2_id)');

CREATE TABLE IF NOT EXISTS SESSION_STATS_UID_V2 (
  session_uid VARCHAR(36) CHARACTER SET utf8 NOT NULL,
  session_stats_log_v2_id BIGINT NOT NULL,
  CONSTRAINT SESSION_STATS_UID_V2_PK PRIMARY KEY (session_uid)
) Engine=INNODB;

