#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE admin;
    GRANT ALL PRIVILEGES ON DATABASE admin TO postgres;
EOSQL