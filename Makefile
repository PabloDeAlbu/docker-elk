include .env

.PHONY: up 

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose -f docker-compose.sedici.yml up -d

