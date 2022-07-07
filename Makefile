DEBUG = --profile debug
DC = docker compose
EXEC = docker exec -it
LOG = docker logs
.PHONY: default u d t l lf
default: u
u:
	$(DC) $(DEBUG) up -d
d:
	$(DC) $(DEBUG) down

t/%:
	$(EXEC) $(@F)-debug bash
l/%:
	$(LOG) $(@F)
lf/%:
	$(LOG) $(@F) -f
