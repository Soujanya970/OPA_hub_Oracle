
-- delim /
create or replace procedure opa_create_obj_if_not_exists (
    objectDef IN VARCHAR2
) as
begin
  declare
    object_exists exception;
    pragma exception_init (object_exists, -955);
  begin
      execute immediate objectDef;
  exception
    when object_exists then null;
  end;
end; 
/

create or replace procedure opa_add_column_if_not_exists (
    tableName IN VARCHAR2,
    colName IN VARCHAR2,
    colDef IN VARCHAR2
) as
begin 
  declare
    column_exists exception;
    pragma exception_init (column_exists , -01430);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' ADD ' || colName || ' ' || colDef;
  exception 
    when column_exists then null;
  end;
end;
/

create or replace procedure opa_add_index_if_not_exists (
  tableName in varchar2,
  indexName in varchar2,
  indexDef in varchar2
) as
  begin
    declare
      index_exists exception;
      cols_already_indexed exception;
      pragma exception_init (index_exists, -955);
      pragma exception_init (cols_already_indexed, -1408);
    begin
      execute immediate 'CREATE INDEX ' || indexName || ' ON ' || tableName || ' ' || indexDef;
    exception
      when index_exists then null;
      when cols_already_indexed then null;
    end;
  end;
/

create or replace procedure opa_drop_table_if_exists (
  tableName IN VARCHAR2
) as
  begin
    execute immediate 'DROP TABLE ' || tableName;
    exception
    when others then
    if SQLCODE != -942 then
      RAISE;
    end if;
  end;
/

create or replace procedure opa_drop_sequence_if_exists (
  seqName IN VARCHAR2
) as
  begin
    execute immediate 'DROP SEQUENCE ' || seqName;
    exception
    when others then
    if SQLCODE != -2289 then
      RAISE;
    end if;
  end;
/

create or replace procedure opa_drop_constraint_if_exists (
    tableName IN VARCHAR2,
    constraintName IN VARCHAR2
) as
begin
  declare
    column_not_exists exception;
    pragma exception_init (column_not_exists , -02443);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' DROP CONSTRAINT ' || constraintName;
  exception
    when column_not_exists then null;
  end;
end;
/


create or replace procedure opa_drop_index_if_exists (
    indexName IN VARCHAR2
) as
begin
  declare
    column_not_exists exception;
    pragma exception_init (column_not_exists , -01418);
  begin
    execute immediate 'DROP INDEX ' || indexName;
  exception
    when column_not_exists then null;
  end;
end;
/

create or replace procedure opa_modify_column_accepts_null (
    tableName IN VARCHAR2,
    colName IN VARCHAR2
) as
begin
  declare
    already_null exception;
    pragma exception_init (already_null, -1451);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' MODIFY ' || colName || ' NULL';
  exception
    when already_null then null;
  end;
end; 
/


create or replace procedure opa_drop_column_if_exists (
    tableName IN VARCHAR2,
    colName IN VARCHAR2
) as
begin 
  declare
    column_not_exists exception;
    pragma exception_init (column_not_exists , -00904);
  begin
    execute immediate 'ALTER TABLE ' || tableName || ' DROP COLUMN ' || colName;
  exception 
    when column_not_exists then null;
  end;
end;
/

create or replace procedure OPARenameColumnIfExists (
    tableName IN VARCHAR2,
    colName IN VARCHAR2,
    toName IN VARCHAR2
) as
begin 
  declare
    column_not_exists exception;
    pragma exception_init (column_not_exists , -00957);
  begin
	  execute immediate 'ALTER TABLE ' || tableName || ' RENAME COLUMN ' || colName || ' TO ' || toName;
  exception 
    when column_not_exists then null;
  end;
end;
/
-- delim ;

