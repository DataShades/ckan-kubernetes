#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE $CKAN_USER NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD '$CKAN_PASSWORD';
    CREATE DATABASE $CKAN_DB OWNER $CKAN_USER ENCODING 'utf-8';
    CREATE ROLE $DS_USER NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD '$DS_PASSWORD';
    CREATE DATABASE $DS_DB OWNER $CKAN_USER ENCODING 'utf-8';
    GRANT ALL PRIVILEGES ON DATABASE $DS_DB TO $CKAN_USER;
    CREATE EXTENSION POSTGIS;
    ALTER VIEW geometry_columns OWNER TO $CKAN_USER;
    ALTER TABLE spatial_ref_sys OWNER TO $CKAN_USER;
    \connect $DS_DB;
    REVOKE CREATE ON SCHEMA public FROM PUBLIC;
    REVOKE USAGE ON SCHEMA public FROM PUBLIC;
    GRANT CREATE ON SCHEMA public TO $CKAN_USER;
    GRANT USAGE ON SCHEMA public TO $CKAN_USER;
    GRANT CREATE ON SCHEMA public TO $CKAN_USER;
    GRANT USAGE ON SCHEMA public TO $CKAN_USER;
    REVOKE CONNECT ON DATABASE $CKAN_DB FROM $DS_USER;
    GRANT CONNECT ON DATABASE $DS_DB TO $DS_USER;
    GRANT USAGE ON SCHEMA public TO $DS_USER;
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO $DS_USER;
    ALTER DEFAULT PRIVILEGES FOR USER $CKAN_USER IN SCHEMA public
    GRANT SELECT ON TABLES TO $DS_USER;
    CREATE OR REPLACE VIEW "_table_metadata" AS
        SELECT DISTINCT
            substr(md5(dependee.relname || COALESCE(dependent.relname, '')), 0, 17) AS "_id",
            dependee.relname AS name,
            dependee.oid AS oid,
            dependent.relname AS alias_of
            -- dependent.oid AS oid
        FROM
            pg_class AS dependee
            LEFT OUTER JOIN pg_rewrite AS r ON r.ev_class = dependee.oid
            LEFT OUTER JOIN pg_depend AS d ON d.objid = r.oid
            LEFT OUTER JOIN pg_class AS dependent ON d.refobjid = dependent.oid
        WHERE
            (dependee.oid != dependent.oid OR dependent.oid IS NULL) AND
            (dependee.relname IN (SELECT tablename FROM pg_catalog.pg_tables)
                OR dependee.relname IN (SELECT viewname FROM pg_catalog.pg_views)) AND
            dependee.relnamespace = (SELECT oid FROM pg_namespace WHERE nspname='public')
        ORDER BY dependee.oid DESC;
    ALTER VIEW "_table_metadata" OWNER TO $CKAN_USER;
    GRANT SELECT ON "_table_metadata" TO $DS_USER;
EOSQL