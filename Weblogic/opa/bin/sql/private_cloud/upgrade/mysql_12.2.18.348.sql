CALL OPAAddColumnIfNotExists('SESSION_STATS_LOG_V2', 'data_service_id', 'INT');
CALL OPAAddColumnIfNotExists('SESSION_STATS_LOG_V2', 'data_service_type', 'INT');
CALL OPAAddColumnIfNotExists('SESSION_STATS_LOG_V2', 'data_service_version', 'VARCHAR(25) CHARACTER SET utf8');
CALL OPAAddColumnIfNotExists('SESSION_SCREEN_LOG_V2', 'data_service_id', 'INT');
CALL OPAAddColumnIfNotExists('SESSION_SCREEN_LOG_V2', 'data_service_type', 'INT');
CALL OPAAddColumnIfNotExists('SESSION_SCREEN_LOG_V2', 'data_service_version', 'VARCHAR(25) CHARACTER SET utf8');
