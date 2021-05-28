include .env
.PHONY: up down stop prune ps shell drush logs bash

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

force-recreate:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --force-recreate --remove-orphans

down: stop

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

logs:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose logs -f --tail=10

log:
	@docker logs -f --tail=10 $(PROJECT_NAME)_$(filter-out $@,$(MAKECMDGOALS))

build:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose build

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v

ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

bash:
	docker exec -ti $(PROJECT_NAME)_$(filter-out $@,$(MAKECMDGOALS)) /bin/bash

logstash:
	docker exec -ti $(PROJECT_NAME)_logstash /bin/bash


