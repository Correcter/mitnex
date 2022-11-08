ARG POSTGRES_VERSION=14.3
FROM postgres:${POSTGRES_VERSION}

COPY postgresql.conf /etc/postgresql
COPY init.sql /docker-entrypoint-initdb.d/

# Change current user to www
USER root

# Override default postgres config file
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

EXPOSE 5432
