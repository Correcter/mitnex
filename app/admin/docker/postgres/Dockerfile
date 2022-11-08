ARG ADMIN_POSTGRES_VERSION=14.3
FROM postgres:${ADMIN_POSTGRES_VERSION}

COPY postgresql.conf /etc/postgresql
COPY init.sql /docker-entrypoint-initdb.d/

# Change current user to root
USER root

# Override default postgres config file
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

EXPOSE 5432
