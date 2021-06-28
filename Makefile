include .env
.PHONY: up up-elk up-sources down stop stop-elk stop-sources prune force-recreate bash logstash

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f docker-compose-sources.yml up -d 

up-elk:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml up -d 

up-sources:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose-sources.yml up -d 

up-items:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/items/docker-compose.override.yml -f docker-compose-sources.yml up -d 

up-collections:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/collections/docker-compose.override.yml -f docker-compose-sources.yml up -d 

up-logs:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/logs/docker-compose.override.yml -f docker-compose-sources.yml up -d 

force-recreate:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose  -f docker-compose.yml -f docker-compose-sources.yml up -d --force-recreate 

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-sources.yml stop

stop-elk:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose  -f docker-compose.yml stop

stop-sources:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose-sources.yml stop

logs:
	@docker-compose -f docker-compose.yml -f docker-compose-sources.yml  logs -f --tail=10

build:
	@echo "Building servicies for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-sources.yml  build

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-sources.yml down -v

prune-elk:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml down -v

bash:
	docker exec -ti $(PROJECT_NAME)_$(filter-out $@,$(MAKECMDGOALS)) /bin/bash

logstash:
	docker exec -ti $(PROJECT_NAME)_logstash /bin/bash


