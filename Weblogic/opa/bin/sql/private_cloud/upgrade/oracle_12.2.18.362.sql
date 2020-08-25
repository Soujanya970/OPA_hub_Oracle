CALL opa_add_column_if_not_exists('SESSION_STATS_LOG_V2', 'agent', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('SESSION_SCREEN_LOG_V2', 'agent', 'NUMBER(5) DEFAULT 0 NOT NULL');
