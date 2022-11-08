# syntax=docker/dockerfile:1
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf
COPY supervisor.d/* /etc/supervisor.d/

RUN usermod -u 1000 www-data
RUN mkdir -p /var/log/project_log
RUN chown -R www-data:www-data /var/log/project_log

ENTRYPOINT ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
