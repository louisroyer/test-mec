DEBUG = --profile debug
DC = docker compose
EXEC = docker exec -it
LOG = docker logs
PING = ping -c 10 -i 0.2
DIGSHORT = dig +short A
CURL = curl -L 

COLOR_RED = \033[0;31m
COLOR_GREEN = \033[0;32m
COLOR_YELLOW = \033[0;33m
COLOR_BLUE = \033[0;34m
COLOR_END = \033[0m
TESTCASES := ue2ue explicitaccess dnsredirect trafficsteering

.PHONY: default u d t l lf e ping uping ip dig waitkey test $(addprefix test/, $(TESTCASES)) $(addprefix test-label/, $(TESTCASES)) 

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
	@echo "$(COLOR_BLUE)======  PING $(*D) -> $(@F) ======$(COLOR_END)"
	@TARGET=$(shell $(EXEC) $(@F)-debug bash -c "ip --brief address show uesimtun0|awk '{print \$$3; exit}'|cut -d"/" -f 1");\
	echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(PING) $$TARGET\" $(COLOR_END)";\
	$(EXEC) $(*D)-debug bash -c "$(PING) $$TARGET"
ping/%:
	$(EXEC) $(*D)-debug bash -c "$(PING) $(@F)"

dig/%:
	@echo "$(COLOR_BLUE)====== DIG $(*D) ->  $(@F) ======$(COLOR_END)"
	@echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(DIGSHORT) $(@F)\"$(COLOR_END)"
	@$(EXEC) $(*D)-debug bash -c "$(DIGSHORT) $(@F)"

curl/%:
	@echo "$(COLOR_BLUE)====== CURL $(*D) ->  $(@F) ======$(COLOR_END)"
	@echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(CURL) $(@F)\"$(COLOR_END)"
	@$(EXEC) $(*D)-debug bash -c "$(CURL) $(@F)"

waitkey/%:
	@echo "$(COLOR_YELLOW)"
	@echo "#=========================#"
	@echo "# Press enter to continue #"
	@echo "#=========================#$(COLOR_END)"
	@read line

test: $(addprefix test/, $(TESTCASES))

test-label/ue2ue:
	@echo "$(COLOR_GREEN)#===============================================================#"
	@echo "# Comparison of UE to UE latency between MEC and non-MEC slices #"
	@echo "#                  (press enter to continue)                    #"
	@echo "#===============================================================#"
	@echo "$(COLOR_END)"
	@read line
test/ue2ue: test-label/ue2ue uping/ue3/ue4 waitkey/ue2ue/3 uping/ue1/ue2 waitkey/ue2ue/2


test-label/explicitaccess:
	@echo "$(COLOR_GREEN)#====================================#"
	@echo "# Explicit Access to MEC application #"
	@echo "#     (press enter to continue)      #"
	@echo "#====================================#"
	@echo "$(COLOR_END)"
	@read line
test/explicitaccess: test-label/explicitaccess dig/ue1/site1.mec.test curl/ue1/site1.mec.test waitkey/explicitaccess/1

test-label/dnsredirect:
	@echo "$(COLOR_GREEN)#================================#"
	@echo "# MEC Access via DNS Redirection #"
	@echo "#    (press enter to continue)   #"
	@echo "#================================#"
	@echo "$(COLOR_END)"
	@read line
test/dnsredirect: test-label/dnsredirect dig/ue3/site1.test curl/ue3/site1.test waitkey/dnsredirect/1 dig/ue1/site1.test curl/ue1/site1.test waitkey/dnsredirect/2

test-label/trafficsteering:
	@echo "$(COLOR_GREEN)#=================================#"
	@echo "# MEC Access via Traffic Steering #"
	@echo "#    (press enter to continue)    #"
	@echo "#=================================#"
	@echo "$(COLOR_END)"
	@read line
test/trafficsteering: test-label/trafficsteering dig/ue3/site2.test curl/ue3/site2.test waitkey/trafficsteering/1 dig/ue1/site2.test curl/ue1/site2.test waitkey/trafficsteering/1
