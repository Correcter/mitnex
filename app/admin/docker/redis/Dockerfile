FROM redis:latest

LABEL maintainer="mitnex <correcter@inbox.ru>"

USER root
RUN mkdir -p /usr/local/etc/redis
COPY conf/redis.conf /usr/local/etc/redis/redis.conf
RUN chmod 644 /usr/local/etc/redis/redis.conf
CMD chmod 777 /data

#RUN chmod.sh

VOLUME /data

EXPOSE 6379

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
