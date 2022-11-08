## Deployment process

The current description is in [Setting up the development environment](https://confluence.8adm.com/pages/viewpage.action?pageId=623217318 )

### Docker (there is a shortcut to confluence)

Work with docker in three commands, run everything from a local computer:

    # launch docker
    make docker_up

    # update the project (DB, fixtures, etc.) - run in all incomprehensible situations
    make docker_update_dev

    # log into PHP container
    make docker_php_shell
    or
    make docker_php_ru_shell

    # stop containers
    make docker_stop

    # stop and delete containers
    make docker_down

The site is available at http://localhost or http://127.0.0.1 and also http://mostbet.local and http://mostbet-ru.local

### PHP Code Sniffer

#### Connection Instructions

    $ composer install
    $ make checker_setup

Check: the output of the `bin/phpcs -i` command should mention the `Symfony` standard

#### Setting up automatic code validation in PhpStorm

* In the settings (`Settings / Languages and Frameworks / PHP / Code Sniffer`) specify the path to `bin/phpcs`
* Configure the `PHP Code Sniffer validation` inspection by specifying `Custom` as the standard

### php-cs-fixer - running on commit is mandatory!!! on all new files

#### Instructions for use in PhpStorm

In PhpStorm` 'php-cs-fixer` can be used as an external tool.

* In the settings (`Settings / Tools / External Tools`) add a new tool with the following settings:
  * Program: `bin/php-cs-fixer`
  * Parameters: `fix "$FilePath$"`
  * Working directory: `$ProjectFileDir$`
* Launch from context menus, the main menu, or assign a keyboard shortcut (`Settings/Keymap`) to launch on the current file.

#### git pre-commit hook

```bash
cp bin/pre-commit.dist bin/pre-commit \
    && chmod a+x bin/pre-commit \
    && ln -sr -t .git/hooks/ bin/pre-commit
```

### Setting up rules

#### PHP Code Sniffer

The set of rules used is set by the file `ruleset.xml `, in which the Symfony standard is first imported in its entirety, and then rules that we don't need are excluded from it.

#### php-cs-fixer

The configuration is configured in the `.php_cs.dist` file. (updated configuration is in the bin/cs-fixer/.php_cs_new_files.dist file)

For easy viewing of the available configuration options, there is [php-cs-fixer configurator](https://mlocati.github.io/php-cs-fixer-configurator /).

### Deployment

#### Ansible

[Installation](http://docs.ansible.com/ansible/intro_installation.html )

#### Deploy (on dev)

```sh
$ make deploy host=dev7 branch=MST-XYZ skip_translations=true

```

## Running codeception tests

Tests are run inside a docker container.

### For the ru version

```sh
docker exec -it -u www-data -e SYMFONY_DEPRECATIONS_HELPER=weak php_ru bin/codecept -f run Functional tests/Functional/AppRuBundle
```

### For the com version

```sh
docker exec -it -u www-data -e SYMFONY_DEPRECATIONS_HELPER=weak php bin/codecept -f run Functional tests/Functional/AppBundle
docker exec -it -u www-data -e SYMFONY_DEPRECATIONS_HELPER=weak php bin/codecept -f run Functional tests/Functional/CasinoBundle
```

### For the pps version
```sh
docker exec -it -u www-data -e SYMFONY_DEPRECATIONS_HELPER=weak php_pps bin/codecept -f run Functional tests/Functional/AppPpsBundle
```

## Fixtures

```
docker-compose exec  php bin/console doctrine:fixtures:load --append --fixtures=src/TestingBundle/DataFixtures
```