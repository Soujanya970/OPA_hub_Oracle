CALL opa_add_column_if_not_exists('SESSION_STATS_LOG_V2', 'data_service_id', 'number(11)');
CALL opa_add_column_if_not_exists('SESSION_STATS_LOG_V2', 'data_service_type', 'number(11)');
CALL opa_add_column_if_not_exists('SESSION_STATS_LOG_V2', 'data_service_version', 'VARCHAR2(25 CHAR)');
CALL opa_add_column_if_not_exists('SESSION_SCREEN_LOG_V2', 'data_service_id', 'number(11)');
CALL opa_add_column_if_not_exists('SESSION_SCREEN_LOG_V2', 'data_service_type', 'number(11)');
CALL opa_add_column_if_not_exists('SESSION_SCREEN_LOG_V2', 'data_service_version', 'VARCHAR2(25 CHAR)');
