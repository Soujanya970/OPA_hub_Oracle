INSERT INTO ROLE (role_name, role_id) VALUES ('Project Admin', role_seq.NEXTVAL);
INSERT INTO ROLE (role_name, role_id) VALUES ('Project Author', role_seq.NEXTVAL);
INSERT INTO ROLE (role_name, role_id) VALUES ('Web Service API', role_seq.NEXTVAL);
INSERT INTO ROLE (role_name, role_id) VALUES ('Mobile User', role_seq.NEXTVAL);
INSERT INTO ROLE (role_name, role_id) VALUES ('Chat Service', role_seq.NEXTVAL);

INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('schema_version', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_str_value) VALUES ('opa_app_version', 1, 'Latest version of the Hub that can access this schema', 0, '12.2.3');
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('site_type', 1, 'The site type for this OPA Site. 0=Production, 1=Test, 2=Development', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_invalidLogins', 1, 5);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_invalidLockMinutes', 1, 30);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_passwordExpireIntervalDays', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_passwordExpireGraceDays', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_passwordExpireWarnDays', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_minPasswordLength', 1, 8);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_maxCharacterRepetitions', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_maxCharacterOccurrences', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_minLowercaseChars', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_minUppercaseChars', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_minSpecialChars', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_minNumbersAndSpecialChars', 1, 2);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('pwd_previousPasswordsNoRepeat', 1, 3);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('pwd_pwnedPasswordsURL', 1, 'The URL for the location of a passwords-sha1.txt file containing Pwned password.', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('opm_deploymentModel', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('deployment_max_size_mb', 1, 'Maximum size of any project or deployment that can be uploaded, in millions of bytes.', 1, 64);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('runtime_disabled_for_sessions', '0 = enabled, 1 = disabled. If disabled, opa runtime will not be enabled for RN Sessions (customer portal).', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('runtime_disabled_for_users', '0 = enabled, 1 = disabled. If disabled, opa runtime will not be enabled for RN users (Agent Desktop).', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('runtime_enabled_for_employees', '0 = disabled, 1 = enabled. If enabled, interviews are allowed only for employees. Ignored if runtime_disabled_for_users is zero.', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_str_value) VALUES ('log_level', 1, 'Sets the log level. Valid values: ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF', 0, 'WARN');
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('memcached_enabled', 1, 'Enables/disables Memcached 0 = disabled, 1 = enabled', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('memcached_serverList', 1, 'memcached server list', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('memcached_keyPrefix', 1, 'memcached key prefix for this opa deployment', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_str_value) VALUES ('opa_help_url', 1, 'url for hub news', 0, 'https://documentation.custhelp.com/euf/assets/devdocs/{0}/IntelligentAdvisor/{1}/Default.htm');
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('web_service_api_status', '0 = unrestricted (for compatibility), 1 = restricted, 2 = unrestricted. When restricted, only users with Web Service API role have access to ODS.', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_repository_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the Repository feature', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_mobile_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on ability to deploy to Mobile', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_web_rules_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental Web Rules feature', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_web_interviews_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental Web Interviews feature', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_interview_hub_auth_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental interview hub auth feature', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_live_projects_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental live projects feature', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_deployment_stats_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on Deployment Statistics feature', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_compatibility_mode_enabled', '0 = disabled, 1 = enabled. Enabling makes compatibility mode an option for deployments.  Compatibility mode runtime must be installed.', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_assess_api_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on Assess API feature.', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_gse_operations_enabled', '0 = disabled, 1 = enabled. Enabling turns on GSE operations for a demo site. Has no effect on Non-demo sites', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_auto_data_maintenance', 1, '0 = disabled, 1 = enabled. Enabling turns on the Auto Data Maintenance feature', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_offer_anon_assess', 1, '0 = disabled, 1 = enabled. Enabling allows users to turn off assess authentication', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_interaction_statistics', 1, '0 = disabled, 1 = enabled. Enabling turns on the Interaction Statistics feature', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_embedded_fastpath', 1, '0 = disabled, 1 = enabled. Enabling turns on the experimental embedded loader', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('feature_metrics_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the Metrics collection and export feature.', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('file_attach_max_mb_single', 1, 'Maximum allowed size in megabytes for a single attachment excluding generated forms', 1, 10);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('file_attach_max_mb_total', 1, 'Maximum allowed total size in megabytes for session attachments excluding generated forms', 1, 50);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('file_attach_name_max_chars', 1, 'Maximum number of characters allowed in a file attachment name', 1, 100);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('osvc_allow_duplicate_emails', 1, '0 = disabled, 1 = enabled. Enabling will skip email uniqueness checks before Submit', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('osvc_asynchronous_checkpoints', 1, '0 = disabled, 1 = enabled. Enabling will perform set and delete checkpoint operations asynchronously to interview progression', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_str_value) VALUES ('osvc_connect_api_version', 1, 'The version of the Connect API to use for Service Cloud connections', 0, 'v1_2');
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('osvc_max_enum_list_length', 1, 'Maximum allowed number of entries in a Service Cloud enumerated field response', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('osvc_req_timeout_for_enum_values', 1, 'Read timeout in seconds for each Service Cloud enum (menu field) values request. Multiple requests are made per Hub Model Refresh operation.', 1, 20);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('osvc_req_timeout_for_metadata', 1, 'Read timeout in seconds for each Service Cloud metadata request. One request is made per Hub Model Refresh operation.', 1, 20);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('wsc_req_timeout_for_metadata', 1, 'Read timeout in seconds for each Web Service metadata request. One request is made per Hub Model Refresh operation.', 1, 120);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('log_billingId', 1, 'billing id sent to the ACS logging system when a loggable event occurs', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('log_instanceId', 1, 'instance id sent to the ACS logging system when a loggable event occurs', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('log_trackingHost', 1, 'tracking host sent to the ACS logging system when a loggable event occurs', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('log_enabled', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_outputDirectory', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_outputRecordPerFile', 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_outputRolloverInterval', 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_productFamily', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_engagementRequestSecure', 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_ipForwarderPropertyFile', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('log_ipForwarderPropertyKey', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('max_active_deployments', 1, 'The maximum number of active deployments (interview and web service). 0 = no limit', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('det_server_request_validation', 1, 'Enables/disables the validation of Determinations Server requests', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('det_server_response_validation', 1, 'Enables/disables the validation of Determinations Server responses', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('det_server_batch_request_max_mb', 1, 'Maximum allowed size in megabytes for an Assess API batch request', 1, 10);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('det_server_decision_node_limit', 1, 'Maximum number of nodes that the decision reporter visits before an error occurs.', 1, 10000);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type, config_property_int_value) VALUES ('deployment_stats_logging_interval', 1, 60);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('deployment_stats_cases_per_interaction', 'The number of cases to be used to calculate assessment interactions in deployment statistics', 1, 20);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('interview_timeout_warning_enabled', 1, '0 = disable, 1 = enabled. Enabling turns on user warnings about session expiry for interviews', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('externally_managed_identity', 1, '0 = internally managed, 1 = externally managed by app server, 2 = externally managed by IDCS', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('external_logout_url', 1, 'Used for logging out of externally managed opa site', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('interview_cors_whitelist', 1, 'A list of whitelisted servers able to make cross site requests to Web Determinations.', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('hub_cors_whitelist', 1, 'A list of whitelisted servers able to make cross site requests to OPA-Hub.', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('det_server_cors_whitelist', 1, 'A list of whitelisted servers able to make cross site requests to Determinations Server.', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('idcs_url', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('idcs_audience', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('idcs_client_id', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('idcs_client_sec', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('clamd_location', 1, 'The clamd location, either local path or TCP socket, for virus scanning deployment or project data.', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('audit_enabled', 1, '0 = disabled, 1 = enabled. Enabling turns on the audit writing', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('audit_max_download', 1, 'Maximum number of audit entries that can be downloaded in the hub. Valid value is from 1 to 10,000 and default value is 500.', 1, 500);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('audit_max_service', 1, 'Maximum number of audit entries that can be retrieved in the REST service. Valid value is from 1 to 10,000 and default value is 500.', 1, 500);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('cloud_batch_concurrent_limit_enabled', '0 = Disabled, 1 = Enabled. Enabling turns on limiting for Batch Assess API requests', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('cloud_batch_concurrent_proc_max', 'Maximum number of Batch Assess API request to be processed concurrently per server', 1, 4);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_description, config_property_type, config_property_int_value) VALUES ('cloud_batch_concurrent_queue_max', 'Maximum number of Batch Assess API requests to be queued concurrently per server', 1, 12);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('cloud_batch_shared_thread_count', 1, 'Maximum number of shared threads that batch assess will use (0=single threaded with no shared pool).', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('db_message_log_enabled', 1, '0 = disabled, 1 = enabled. Enable logging to LOG_ENTRY table', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_type) VALUES ('application_identity', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type) VALUES ('ec_connector_url', 1, 'The url of the EC Connector Service for this site', 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('use_local_jet_files', 1, '0 = disabled, 1 = enabled. If enabled the Hub will use local Oracle Jet files rather than from CDN.', 1, 0);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('connection_cache_refresh_interval', 1, 'The period, in seconds, between tests for liveness of a data connection. Range from 5 seconds to 24 hours (86,400 seconds).', 1, 300);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_int_value) VALUES ('ec_auto_version_select', 1, '0 = disabled, 1 = enabled. If enabled EC connections will automatically upgrade to the latest available advertized version.', 1, 1);
INSERT INTO CONFIG_PROPERTY (config_property_name, config_property_public, config_property_description, config_property_type, config_property_str_value) VALUES ('ec_default_version', 1, 'The version set for new EC connections when available versions are not advertized in Topology Manager responses, or when ec_auto_version_select is set to false.', 0, '12.2.13');


INSERT INTO COLLECTION (collection_name, collection_status, collection_description, collection_id) VALUES ('Default Collection', 0, 'The default collection', collection_seq.NEXTVAL);


INSERT INTO AUTHENTICATION (user_name, status, hub_admin, user_type, full_name, authentication_id) VALUES ('admin', 0, 1, 0, 'Default admin user', authentication_seq.NEXTVAL);

INSERT INTO AUTH_ROLE_COLL (collection_id, role_id, authentication_id) VALUES ((SELECT collection_id FROM COLLECTION WHERE collection_name = 'Default Collection'),
    (SELECT role_id FROM ROLE WHERE role_name = 'Project Admin'),
    (SELECT authentication_id FROM AUTHENTICATION WHERE user_name = 'admin'));

INSERT INTO AUTH_ROLE_COLL (collection_id, role_id, authentication_id) VALUES ((SELECT collection_id FROM COLLECTION WHERE collection_name = 'Default Collection'),
    (SELECT role_id FROM ROLE WHERE role_name = 'Project Author'),
    (SELECT authentication_id FROM AUTHENTICATION WHERE user_name = 'admin'));

INSERT INTO AUTHENTICATION (user_name, status, hub_admin, user_type, full_name, authentication_id) VALUES ('author', 1, 0, 0, 'Example project Author/Admin', authentication_seq.NEXTVAL);

INSERT INTO AUTH_ROLE_COLL (collection_id, role_id, authentication_id) VALUES ((SELECT collection_id FROM COLLECTION WHERE collection_name = 'Default Collection'),
    (SELECT role_id FROM ROLE WHERE role_name = 'Project Admin'),
    (SELECT authentication_id FROM AUTHENTICATION WHERE user_name = 'author'));

INSERT INTO AUTH_ROLE_COLL (collection_id, role_id, authentication_id) VALUES ((SELECT collection_id FROM COLLECTION WHERE collection_name = 'Default Collection'),
    (SELECT role_id FROM ROLE WHERE role_name = 'Project Author'),
    (SELECT authentication_id FROM AUTHENTICATION WHERE user_name = 'author'));

INSERT INTO AUTHENTICATION (user_name, status, hub_admin, user_type, full_name, authentication_id) VALUES ('apiuser', 1, 0, 1, 'Example Determinations/Web API user', authentication_seq.NEXTVAL);

INSERT INTO AUTH_ROLE_COLL (collection_id, role_id, authentication_id) VALUES ((SELECT collection_id FROM COLLECTION WHERE collection_name = 'Default Collection'),
    (SELECT role_id FROM ROLE WHERE role_name = 'Web Service API'),
    (SELECT authentication_id FROM AUTHENTICATION WHERE user_name = 'apiuser'));
