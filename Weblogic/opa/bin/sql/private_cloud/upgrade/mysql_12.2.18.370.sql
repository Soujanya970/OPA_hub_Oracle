CALL OPAAddColumnIfNotExists('DEPLOYMENT_VERSION', 'snapshot_id', 'INT');
CALL OPAAddColumnIfNotExists('DEPLOYMENT_VERSION', 'deployment_version_kind', 'SMALLINT DEFAULT 0 NOT NULL');
CALL OPAAddColumnIfNotExists('DEPLOYMENT_VERSION', 'module_version_id', 'INT');

-- foreign keys
CALL OPAAddConstraintIfNotExists('DEPLOYMENT_VERSION', 'module_version_id_fk', 'FOREIGN KEY (module_version_id) REFERENCES MODULE_VERSION(module_version_id)');
