include .env
.PHONY: up up-elk up-sources down stop stop-elk stop-sources prune force-recreate bash logstash

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose -f docker-compose.yml up -d 

up-postgres:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose -f docker-compose-sources.yml up -d 

up-items:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/items/docker-compose.override.yml up -d 
	docker-compose -f docker-compose-sources.yml up -d 

up-collections:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/collections/docker-compose.override.yml -f docker-compose-sources.yml up -d 

up-logs:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/logs/docker-compose.override.yml up -d 

up-apache2:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/apache2/docker-compose.apache2.yml up -d 

up-apache2-test:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/apache2/docker-compose.apache2.yml  -f logstash/indexes/apache2/docker-compose.apache2.test.yml up -d 

up-dspace:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/dspace/docker-compose.dspace.yml up -d 

up-dspace-test:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/dspace/docker-compose.dspace.yml  -f logstash/indexes/dspace/docker-compose.dspace.test.yml up -d 

up-accessed_items:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml -f logstash/indexes/accessed_items/docker-compose.override.yml up -d 


rm-filebeat-data:
	@echo "remove /usr/share/filebeat from elk_filebeat_logs"
	docker exec elk_filebeat_logs sh -c 'rm -rf /usr/share/filebeat/data'

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


