CALL OPAAddColumnIfNotExists('SESSION_STATS_LOG_V2', 'agent', 'SMALLINT DEFAULT 0 NOT NULL');
CALL OPAAddColumnIfNotExists('SESSION_SCREEN_LOG_V2', 'agent', 'SMALLINT DEFAULT 0 NOT NULL');