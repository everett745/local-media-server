COMPOSE_FILE := docker-compose.yml
COMPOSE := docker compose -f $(COMPOSE_FILE)

.PHONY: help up down restart ps pull update logs logs-list logs-clean

help:
	@echo "Available targets:"
	@echo "  make up         - start stack in background"
	@echo "  make down       - stop and remove stack"
	@echo "  make restart    - restart stack"
	@echo "  make ps         - show service status"
	@echo "  make pull       - pull latest images"
	@echo "  make update     - pull + recreate containers"
	@echo "  make logs       - follow compose logs"
	@echo "  make logs-list  - list log files in data/"
	@echo "  make logs-clean - remove log files (keeps *.db, *.db-shm, *.db-wal)"

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart

ps:
	$(COMPOSE) ps

pull:
	$(COMPOSE) pull

update: pull up

logs:
	$(COMPOSE) logs -f --tail=100

logs-list:
	find data -type f \( -path '*/logs/*' -o -path '*/log/*' \) -print

logs-clean:
	find data -type f \( -path '*/logs/*' -o -path '*/log/*' \) ! -name '*.db' ! -name '*.db-shm' ! -name '*.db-wal' -delete
