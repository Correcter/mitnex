#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE main;
    GRANT ALL PRIVILEGES ON DATABASE main TO postgres;
EOSQL