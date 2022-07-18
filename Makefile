DEBUG = --profile debug
DC = docker compose
EXEC = docker exec -it
LOG = docker logs
.PHONY: default u d t l lf e ping uping ip dig
default: u
u:
	$(DC) $(DEBUG) up -d
d:
	$(DC) $(DEBUG) down
r: d u

e/%:
	$(EXEC) $(@F) bash

t/%:
	$(EXEC) $(@F)-debug bash
l/%:
	$(LOG) $(@F)
lf/%:
	$(LOG) $(@F) -f
ip/%:
	@$(EXEC) $(@F)-debug bash -c "ip --brief address show uesimtun0|awk '{print \"$(@F):\", \$$3; exit}'"

uping/%:
	@TARGET=$(shell $(EXEC) $(@F)-debug bash -c "ip --brief address show uesimtun0|awk '{print \$$3; exit}'|cut -d"/" -f 1");\
	echo docker exec -it $(*D)-debug bash -c "ping -c 10 $$TARGET";\
	$(EXEC) $(*D)-debug bash -c "ping -c 10 $$TARGET"
ping/%:
	$(EXEC) $(*D)-debug bash -c "ping -c 10 $(@F)"

dig/%:
	$(EXEC) $(*D)-debug bash -c "dig +short A $(@F)"
