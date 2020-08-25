CALL opa_add_column_if_not_exists('DEPLOYMENT_VERSION', 'snapshot_id', 'number(11)');
CALL opa_add_column_if_not_exists('DEPLOYMENT_VERSION', 'deployment_version_kind', 'NUMBER(5) DEFAULT 0 NOT NULL');
CALL opa_add_column_if_not_exists('DEPLOYMENT_VERSION', 'module_version_id', 'number(11)');

-- foreign keys
CALL opa_add_constr_if_not_exists('DEPLOYMENT_VERSION', 'module_version_id_fk', 'FOREIGN KEY (module_version_id) REFERENCES MODULE_VERSION(module_version_id)');
