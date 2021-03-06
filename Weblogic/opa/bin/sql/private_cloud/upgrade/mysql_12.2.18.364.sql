CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'usage_trend_v2', '(deployment_id, created_hour)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'sessions_by_created_year_v2', '(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_year)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'sessions_by_created_month_v2', '(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_month)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'sessions_by_created_day_v2', '(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_day)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'sessions_by_created_hour_v2', '(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, created_hour)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'sessions_by_duration_min_v2', '(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, duration_min)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'sessions_by_screens_visited_v2', '(deployment_id, deployment_version_id, product_function_code, agent, created_timestamp, screens_visited)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'agents_by_created_year_v2', '(deployment_id, deployment_version_id, agent, created_timestamp, created_year)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'agents_by_created_month_v2', '(deployment_id, deployment_version_id, agent, created_timestamp, created_month)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'agents_by_created_day_v2', '(deployment_id, deployment_version_id, agent, created_timestamp, created_day)');
CALL OPAAddIndexIfNotExists('SESSION_STATS_LOG_V2', 'agents_by_created_hour_v2', '(deployment_id, deployment_version_id, agent, created_timestamp, created_hour)');
CALL OPAAddIndexIfNotExists('SESSION_SCREEN_LOG_V2', 'screen_by_session_state_v2', '(deployment_id, deployment_version_id, product_function_code, agent, session_created_timestamp, session_stats_log_v2_id, screen_id, screen_action_code)');
CALL OPAAddIndexIfNotExists('SESSION_SCREEN_LOG_V2', 'screen_by_session_duration_v2', '(deployment_id, deployment_version_id, product_function_code, agent, session_created_timestamp, session_stats_log_v2_id, screen_id, duration_millis)');
