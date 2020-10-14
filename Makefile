UNAME := $(shell uname)
comma := ,
datetime := $(shell date +"%Y%m%d%H%M%S")

AUTOLOAD = vendor/autoload.php
THEME_NAME = 
PLUGIN_NAME = player-for-web-pure-data-patches
THEME_FOLDER = public/wp-content/themes/$(THEME_NAME)
PLUGIN_FOLDER = public/wp-content/plugins/$(PLUGIN_NAME)
CERTS_DIR = .certs
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_FLAGS = -f docker/docker-compose.yaml -f docker/docker-compose-dev.yaml --env-file docker/.env
MKCERT = mkcert

docker-compose = $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_FLAGS) $1
docker-exec =  $(call docker-compose,exec -T app /bin/bash -c "$1")

ifeq ($(shell docker ps | grep "app" -c),1)
    wp-core-version = $(shell $(call docker-exec,wp core version  --allow-root --path=/srv/app/public/wp))
endif

.PHONY: up composer build halt destroy ssh certs provision composer-install \
		composer-normalize phpstan php-cs-fixer php-cs phpunit phpunit-coverage lint-twig database

# Docker
up: compose $(AUTOLOAD)

compose: $(CERTS_DIR)
ifeq ($(UNAME), Darwin)
	SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock $(call docker-compose,up -d)
else
	$(call docker-compose,up -d)
endif

build: halt
	$(call docker-compose,build)

halt:
	$(call docker-compose,stop)

destroy:
	$(call docker-compose,down --remove-orphans)

ssh:
	$(call docker-compose,exec app /bin/bash)

$(CERTS_DIR):
	$(MAKE) certs

certs:
	mkdir -p $(CERTS_DIR)
	$(MKCERT) -install
	$(MKCERT) -cert-file $(CERTS_DIR)/certificate.pem -key-file $(CERTS_DIR)/certificate-key.pem localhost

# App
$(AUTOLOAD):
	$(MAKE) provision

provision: composer-install public/wp/installed $(PLUGIN_FOLDER)/tests/bootstrap.php database

composer-init-plugin-$(PLUGIN_NAME):
	$(call docker-exec,composer init -d $(PLUGIN_FOLDER))

composer-install-plugin-$(PLUGIN_NAME):
	$(call docker-exec,composer install -d $(PLUGIN_FOLDER) --optimize-autoloader)

composer-install-plugin-$(PLUGIN_NAME)-for-deploy:
	$(call docker-exec,composer install -d $(PLUGIN_FOLDER) --prefer-dist --classmap-authoritative --no-progress --no-interaction --no-dev)

composer-outdated-plugin-$(PLUGIN_NAME):
	$(call docker-exec,composer outdated -d $(PLUGIN_FOLDER) --direct)

composer-update-plugin-$(PLUGIN_NAME):
	$(call docker-exec,composer update -d $(PLUGIN_FOLDER) --optimize-autoloader --prefer-source)

composer-dump-autoload-plugin-$(PLUGIN_NAME):
	$(call docker-exec,composer dump-autoload -d $(PLUGIN_FOLDER))

composer-normalize-plugin-$(PLUGIN_NAME):
	$(call docker-exec,composer normalize -d $(PLUGIN_FOLDER))

composer-install:
	$(call docker-exec,composer install --optimize-autoloader)

composer-install-for-deploy:
	$(call docker-exec,composer install --prefer-dist --classmap-authoritative --no-progress --no-interaction --no-dev)

composer-outdated:
	$(call docker-exec,composer outdated --direct)

composer-update:
	$(call docker-exec,composer update --optimize-autoloader --prefer-source)

composer-normalize:
	$(call docker-exec,composer normalize)

phpstan:
	$(call docker-exec,composer phpstan)

psalm:
	$(call docker-exec,composer psalm)

php-cs-fixer:
	$(call docker-exec,composer phpcbf)

php-cs:
	$(call docker-exec,composer phpcs)

$(THEME_FOLDER)/tests/bootstrap.php:
	$(call docker-exec,wp scaffold theme-tests $(THEME_NAME) --allow-root --path=public/wp)

$(PLUGIN_FOLDER)/tests/bootstrap.php:
	$(call docker-exec,wp scaffold plugin-tests $(PLUGIN_NAME) --allow-root --path=public/wp)

$(PLUGIN_FOLDER)/tests_installed_$(wp-core-version):
	$(call docker-exec,cd $(PLUGIN_FOLDER) && bash bin/install-wp-tests.sh wordpress_test_$(wp-core-version)_plugin_$(PLUGIN_NAME) root root mysql $(wp-core-version) && touch tests_installed_$(wp-core-version))

phpunit-plugin-$(PLUGIN_NAME): $(PLUGIN_FOLDER)/tests_installed_$(wp-core-version)
	$(call docker-exec,cd $(PLUGIN_FOLDER) && bash bin/install-wp-tests.sh wordpress_test_$(wp-core-version)_plugin_$(PLUGIN_NAME) root root mysql $(wp-core-version) true)
	$(call docker-exec,cd $(PLUGIN_FOLDER) && phpunit)

$(THEME_FOLDER)/tests_installed_$(wp-core-version):
	$(call docker-exec,cd $(THEME_FOLDER) && bash bin/install-wp-tests.sh wordpress_test_$(wp-core-version)_theme_$(THEME_NAME) root root mysql $(wp-core-version) && touch tests_installed_$(wp-core-version))

phpunit-theme-$(THEME_NAME): $(THEME_FOLDER)/tests_installed_$(wp-core-version)
	$(call docker-exec,cd $(THEME_FOLDER) && bash bin/install-wp-tests.sh wordpress_test_$(wp-core-version)_theme_$(THEME_NAME) root root mysql $(wp-core-version) true)
	$(call docker-exec,cd $(THEME_FOLDER) && phpunit)

phpunit: phpunit-plugin-$(PLUGIN_NAME)

lint-twig:
	$(call docker-exec,composer lint-twig)

database:
	#$(call docker-exec,wp search-replace 'http://localhost' 'https://localhost:8443' --allow-root --path=/srv/app/public/wp)

public/wp/installed:
	$(call docker-exec,wp core install --url=localhost:8443 --title='Wordpress Archetype' --admin_user=wordpress --admin_password=wordpress --admin_email=marcmaurialloza@gmail.com --allow-root --path=public/wp)
	$(call docker-exec,touch public/wp/installed)
