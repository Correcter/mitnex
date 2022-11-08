#!/usr/bin/env bash

AGE="-mtime +7"
#AGE="-mmin +1"

sleep 25

if test `find ~/ru.sql.tar.gz $AGE` ||  test `find ~/com.sql.tar.gz $AGE` ||  test `find ~/pps.sql.tar.gz $AGE`; then
    echo -en "- Cloning new dumps...\n"
    scp mostbet@dev-mostbet:/var/www/mostbet/dump/com.sql.tar.gz ~/com.sql.tar.gz
    scp mostbet@dev-mostbet:/var/www/mostbet/dump/ru.sql.tar.gz ~/ru.sql.tar.gz
    scp mostbet@dev-mostbet:/var/www/mostbet/dump/pps.sql.tar.gz ~/pps.sql.tar.gz
fi

echo -en "- Droping old DBs 'mostbet' and 'mostbet_ru' and 'pps'...\n"
docker-compose exec db mysql -uroot -proot -e "drop schema mostbet_ru;"
docker-compose exec db mysql -uroot -proot -e "drop schema mostbet;"
docker-compose exec db mysql -uroot -proot -e "drop schema pps;"

echo -en "- Creating DBs and granding privileges for 'mostbet' and 'mostbet_ru' and 'pps'...\n"
docker-compose exec db mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS mostbet; GRANT ALL ON mostbet.* TO 'mostbet'@'%';"
docker-compose exec db mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS mostbet_ru; GRANT ALL ON mostbet_ru.* TO 'mostbet'@'%';"
docker-compose exec db mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS pps; GRANT ALL ON pps.* TO 'mostbet'@'%';"

echo -en "- Restoring DB for 'com' from dump ...\n"
tar xzOf ~/com.sql.tar.gz | docker exec -i db  mysql -uroot -proot -hdb -P 3306 mostbet

echo -en "- Restoring DB for 'ru' from dump ...\n"
tar xzOf ~/ru.sql.tar.gz | docker exec -i db  mysql -uroot -proot -hdb -P 3306 mostbet_ru

echo -en "- Restoring DB for 'pps' from dump ...\n"
tar xzOf ~/pps.sql.tar.gz | docker exec -i db  mysql -uroot -proot -hdb -P 3306 pps
