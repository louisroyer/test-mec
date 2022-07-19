DEBUG = --profile debug
DC = docker compose
EXEC = docker exec -it
LOG = docker logs
PING = ping -c 10 -i 0.2
DIGSHORT = dig +short A
CURL = curl -L

TESTCASES := ue2ue explicitaccess dnsredirect trafficsteering

.PHONY: default u d t l lf e ping uping ip dig test $(addprefix test/, $(TESTCASES)) $(addprefix test-label/, $(TESTCASES)) 

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
	@echo "======  PING $(*D) -> $(@F) ======"
	@TARGET=$(shell $(EXEC) $(@F)-debug bash -c "ip --brief address show uesimtun0|awk '{print \$$3; exit}'|cut -d"/" -f 1");\
	echo $(EXEC) $(*D)-debug bash -c \"$(PING) $$TARGET\";\
	$(EXEC) $(*D)-debug bash -c "$(PING) $$TARGET"
ping/%:
	$(EXEC) $(*D)-debug bash -c "$(PING) $(@F)"

dig/%:
	@echo "====== DIG $(*D) ->  $(@F) ======"
	$(EXEC) $(*D)-debug bash -c "$(DIGSHORT) $(@F)"

curl/%:
	@echo "====== CURL $(*D) ->  $(@F) ======"
	$(EXEC) $(*D)-debug bash -c "$(CURL) http://$(@F)"

waitkey:
	@echo ""
	@echo "#=========================#"
	@echo "# Press enter to continue #"
	@echo "#=========================#"
	@read line

test: $(addprefix test/, $(TESTCASES))

test-label/ue2ue:
	@echo "#===============================================================#"
	@echo "# Comparison of UE to UE latency between MEC and non-MEC slices #"
	@echo "#                  (press enter to continue)                    #"
	@echo "#===============================================================#"
	@echo ""
	@read line
test/ue2ue: test-label/ue2ue uping/ue3/ue4 waitkey uping/ue1/ue2


test-label/explicitaccess:
	@echo "#====================================#"
	@echo "# Explicit Access to MEC application #"
	@echo "#     (press enter to continue)      #"
	@echo "#====================================#"
	@echo ""
	@read line
test/explicitaccess: test-label/explicitaccess dig/ue1/site1.mec.test curl/ue1/site1.mec.test

test-label/dnsredirect:
	@echo "#================================#"
	@echo "# MEC Access via DNS Redirection #"
	@echo "#    (press enter to continue)   #"
	@echo "#================================#"
	@echo ""
	@read line
test/dnsredirect: test-label/dnsredirect dig/ue3/site1.test curl/ue3/site1.test waitkey dig/ue1/site1.test curl/ue1/site1.test

test-label/trafficsteering:
	@echo "#=================================#"
	@echo "# MEC Access via Traffic Steering #"
	@echo "#    (press enter to continue)    #"
	@echo "#=================================#"
	@echo ""
	@read line
test/trafficsteering: test-label/trafficsteering dig/ue3/site2.test curl/ue3/site2.test waitkey dig/ue1/site2.test curl/ue1/site2.test
