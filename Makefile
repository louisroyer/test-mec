DEBUG = --profile debug
DC = docker compose
EXEC = docker exec -it
.PHONY: default u d t
default: u
u:
	$(DC) $(DEBUG) up -d
d:
	$(DC) $(DEBUG) down

t/%:
	$(EXEC) $(@F)-debug bash
