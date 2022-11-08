.PHONY: checker_setup checker fixer_diff fixer reset_admin_password

checker_setup:
	bin/phpcs --config-set installed_paths ../../escapestudios/symfony2-coding-standard
	bin/phpcs --config-set default_standard ruleset.xml
	bin/phpcs --config-set show_warnings 0
	bin/phpcs --config-set php_version 70116

checker:
	bin/phpcs -s --colors src/

fixer_diff:
	bin/php-cs-fixer fix --dry-run --diff

fixer:
	bin/php-cs-fixer fix

php-cs-fixer:
	bin/php-cs-fixer-fix.sh

reset_admin_password:
	bin/console fos:user:change-password admin@mostbet.prod admin@mostbet.prod

init_dev:
	composer install
	bin/console doctrine:database:drop --force
	bin/console doctrine:database:create
	bin/console doctrine:migration:migrate -n
	bin/console hautelook_alice:doctrine:fixtures:load -n

docker_update_dev_full d-upd-dev-full: update_parameters init_db after_bugs_fix docker_update_dev front_dev

update_dev: front
	composer install
	bin/console doctrine:migration:migrate -n

run_ci:
	/bin/bash bin/create-tag.sh

show_diff:
	/bin/bash bin/show-diff.sh

deploy:
	echo "Deploying ${branch} to ${host} ${app}..."
	ansible-playbook --forks 10 -i app/config/deploy/inventory app/config/deploy/deploy_dev_com.yml -e "variable_host=${host} variable_branch=${branch} skip_translations=${skip_translations} variable_app=${app} variable_lock=${variable_lock} warmup_prod=${warmup_prod}"

deploy_ru:
	echo "Deploying ${branch} to ${host} ${app}..."
	ansible-playbook --forks 10 -i app/config/deploy/inventory app/config/deploy/deploy_dev_ru.yml -e "variable_host=${host} variable_branch=${branch} skip_translations=${skip_translations} variable_app=ru variable_lock=${variable_lock} warmup_prod=${warmup_prod}"

deploy_dev:
	ansible-playbook --forks 10 -i app/config/deploy/inventory app/config/deploy/deploy_dev_com.yml -e "variable_host=dev variable_branch=staging skip_translations=${skip_translations} warmup_prod=${warmup_prod}"

deploy_dev2:
	ansible-playbook --forks 10 -i app/config/deploy/inventory app/config/deploy/deploy_dev_com.yml -e "variable_host=dev2 variable_branch=staging skip_translations=${skip_translations} warmup_prod=${warmup_prod}"

deploy_dev3:
	ansible-playbook --forks 10 -i app/config/deploy/inventory app/config/deploy/deploy_dev_com.yml -e "variable_host=dev3 variable_branch=staging skip_translations=${skip_translations} warmup_prod=${warmup_prod}"

deploy_pps_dev:
	ansible-playbook --forks 10 -i app/config/deploy/inventory app/config/deploy/deploy_dev_pps.yml -e "variable_host=${host} variable_branch=${branch} skip_translations=${skip_translations} variable_app=${app} warmup_prod=${warmup_prod}"


deploy_PREPRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_preprod app/config/deploy/deploy_preprod.yml -e "variable_branch=${branch} variable_host=${host}"

deploy_PRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_prod -f 35 app/config/deploy/deploy_prod_com.yml -e variable_branch=${tag}

deploy_RU_PRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_prod app/config/deploy/deploy_prod_ru.yml -e variable_branch=${tag}

deploy_PPS_PRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_prod app/config/deploy/deploy_prod_pps.yml -e variable_branch=${tag}

.PHONY: rollback_deploy_PRODUCTION
rollback_deploy_PRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_prod -f 35 app/config/deploy/rollback_prod_com.yml

.PHONY: rollback_deploy_RU_PRODUCTION
rollback_deploy_RU_PRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_prod app/config/deploy/rollback_prod_ru.yml

.PHONY: rollback_deploy_PPS_PRODUCTION
rollback_deploy_PPS_PRODUCTION:
	ansible-playbook -i app/config/deploy/inventory_prod app/config/deploy/rollback_prod_pps.yml

.PHONY: rollback_deploy_PRODUCTION_WITH_MIGRATIONS
rollback_deploy_PRODUCTION_WITH_MIGRATIONS:
	ansible-playbook -i app/config/deploy/inventory_prod app/config/deploy/rollback_prod_pps.yml -f 35 app/config/deploy/rollback_prod_com.yml -e "migrations=true"

.PHONY: rollback_deploy_RU_PRODUCTION_WITH_MIGRATIONS
rollback_deploy_RU_PRODUCTION_WITH_MIGRATIONS:
	ansible-playbook -i app/config/deploy/inventory_prod app/config/deploy/rollback_prod_pps.yml app/config/deploy/rollback_prod_ru.yml -e "migrations=true"

cache_clear_dev:
	ssh mostbet@dev-mostbet /var/www/mostbet/current/bin/console cache:clear --env=stage

cache_clear_dev2:
	ssh mostbet@dev2-mostbet /var/www/mostbet/current/bin/console cache:clear --env=stage

cache_clear_PRODUCTION:
	ssh mostbet@h1-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod
	ssh mostbet@h2-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod
	ssh mostbet@h3-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod
	ssh mostbet@h4-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod
	ssh mostbet@h5-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod
	ssh mostbet@h6-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod
	ssh mostbet@h7-mostbet /var/www/mostbet/current/bin/console cache:clear --env=prod

docker_up d-up: disable_thp
	docker-compose up -d --build

docker_up_monitoring d-up-monitoring:
	docker-compose -f docker-compose-monitoring.yml up -d

docker_down_monitoring d-down-monitoring:
	docker-compose -f docker-compose-monitoring.yml down

docker_all da: docker_compose_dist dotenv_dist rm_cache docker_up docker_update_dev_full install_assets spa_local

docker_all_mac da-mac: docker_compose_dist dotenv_dist docker_compose_mac_dist rm_cache nfs_docker_osx docker_up docker_update_dev_full install_assets spa_local

docker_set_hosts:
	sudo /bin/bash app/config/docker/set_hosts.sh

docker_update_dev_com:
	docker-compose exec --user=www-data php php -dxdebug.remote_enable=0 /usr/bin/composer install
	docker-compose exec --user=www-data php php -dxdebug.remote_enable=0 bin/console doctrine:migration:migrate -n

docker_update_dev_ru:
	docker-compose exec --user=www-data php_ru php -dxdebug.remote_enable=0 /usr/bin/composer install
	docker-compose exec --user=www-data php_ru php -dxdebug.remote_enable=0 bin/console doctrine:migration:migrate -n

docker_update_dev: elastic docker_update_dev_com docker_update_dev_ru

d-shell docker_php_shell:
	docker-compose exec --user=www-data php /bin/bash

docker_php_ru_shell:
	docker-compose exec --user=www-data php_ru /bin/bash

docker_php_pps_shell:
	docker-compose exec --user=www-data php_pps /bin/bash

docker_stop:
	docker-compose stop

docker_down:
	docker-compose down

download_prod_database:
	ssh h2-mostbet "mysqldump mostbet --set-gtid-purged=OFF --single-transaction | gzip -cf -5" | gzip -dc | pv | mysql mostbet

copy_prod_database_to_stage:
	ssh h2-mostbet "mysqldump mostbet --set-gtid-purged=OFF --single-transaction | gzip -cf -5" | pv | ssh dev-mostbet "gzip -dc | mysql mostbet"

run_bg:
	@docker-compose $$(docker-machine config | xargs) up --build -d

run:
	@docker-compose $$(docker-machine config | xargs) up --build

backend:
	@docker-compose $$(docker-machine config | xargs) exec --user www-data php /bin/bash

redis:
	@docker-compose $$(docker-machine config | xargs) exec redis /bin/bash

front_desktop_dev:
	docker run --rm -it -v "`pwd`:/usr/src/app" -w /usr/src/app reg.8adm.com/mostbet/node:6.14.4-slim /bin/bash frontend.sh desktop
.PHONY: front_desktop_dev

front_desktop_prod:
	docker run --rm -it -v "`pwd`:/usr/src/app" -w /usr/src/app reg.8adm.com/mostbet/node:6.14.4-slim /bin/bash frontend.sh desktop prod
.PHONY: front_desktop_prod

front_mobile_dev:
	docker run --rm -it -v "`pwd`:/usr/src/app" -w /usr/src/app reg.8adm.com/mostbet/node:6.14.4-slim /bin/bash frontend.sh mobile
.PHONY: front_mobile_dev

front_mobile_prod:
	docker run --rm -it -v "`pwd`:/usr/src/app" -w /usr/src/app reg.8adm.com/mostbet/node:6.14.4-slim /bin/bash frontend.sh mobile prod
.PHONY: front_mobile_prod

front_desktop: front_desktop_dev front_desktop_prod
.PHONY: front_desktop

front_mobile: front_mobile_dev front_mobile_prod
.PHONY: front_mobile

front_dev: front_desktop_dev front_mobile_dev
.PHONY: front_dev

front_prod: front_desktop_prod front_mobile_prod
.PHONY: front_prod

front: front_desktop_dev front_desktop_prod front_mobile_dev front_mobile_prod
.PHONY: front

grep_mostbet_com:
	grep --color -rniw \
	 --exclude-dir=var --exclude-dir=tmp --exclude-dir=build --exclude-dir=rr-cache \
	 --exclude=app/config/app_com/parameters.yml \
	 'mostbet.com' *

disable_thp:
	/bin/bash bin/disable_thp.sh

nfs_docker_osx:
	/bin/bash bin/nfs_docker_osx.sh

init_db:
	/bin/bash bin/init_db.sh

after_bugs_fix:
	/bin/bash bin/after_bugs_fix.sh

elastic:
	/bin/bash bin/docker/elastic.sh

docker_compose_dist:
	cp docker-compose.yml.dist docker-compose.yml

docker_compose_mac_dist:
	cp docker-compose.override.yml.dist docker-compose.override.yml

dotenv_dist:
	cp -n .env.dist .env

update_parameters:
	/bin/bash bin/update_parameters.sh

rm_cache:
	/bin/bash bin/rm_cache.sh

cache_clear:
	docker-compose exec --user=www-data php php -dxdebug.remote_enable=0 bin/console cache:clear --no-warmup || rm -rf var/cache/*/app_com

cache_clear_ru:
	docker-compose exec --user=www-data php_ru php -dxdebug.remote_enable=0 bin/console cache:clear --no-warmup || rm -rf var/cache/*/app_ru

cc: cache_clear cache_clear_ru

cache_warmup: cache_clear
	docker-compose exec --user=www-data php php -dxdebug.remote_enable=0 bin/console cache:warmup || echo "cannot warmup the cache (needs symfony/console)"

cache_warmup_ru: cache_clear_ru
	docker-compose exec --user=www-data php_ru php -dxdebug.remote_enable=0 bin/console cache:warmup || echo "cannot warmup the cache (needs symfony/console)"

cw: cache_warmup cache_warmup_ru

install_assets:
	docker-compose exec --user=www-data php bin/console assets:install

docker_mac_update:
	docker-compose exec php-cli composer install --ignore-platform-reqs
	docker-compose exec php-cli bash -c 'echo "y" | bin/console doctrine:migrations:migrate'
	docker cp php:/usr/share/nginx/mostbet/vendor ./
	docker cp var/jwt php:/usr/share/nginx/mostbet/var/
	docker-compose exec php chown -R www-data:dialout var

docker_mac_update_ru:
	docker-compose exec php_ru composer install
	docker cp php_ru:/usr/share/nginx/mostbet/vendor ./
	docker-compose exec php_ru bin/console cache:clear
	docker cp var/jwt php_ru:/usr/share/nginx/mostbet/var/
	docker-compose exec php_ru chown -R www-data:dialout var

docker_phpunit d-pu:
	docker-compose exec --user=www-data php bin/phpunit ${test}

docker_phpunit_fast:
	docker-compose exec --user=www-data php bin/phpunit --no-coverage

grafana_label:
	ansible-playbook -i app/config/deploy/inventory app/config/deploy/grafana/label.yml

generate-sdk-local:
	bin/generate-sdk-local.sh ${version} ${codegenFile}

spa_local:
	bin/spa.sh
