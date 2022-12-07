DEBUG = --profile debug
SOCKS= --profile socks
DC = docker compose
EXEC = docker exec -it
LOG = docker logs
PING = ping -c 10 -i 0.2
DIGSHORT = dig +short A
CURL = curl -L 
CURL_I = curl -IL
#CURL = time curl -L 

COLOR_RED = \033[0;31m
COLOR_GREEN = \033[0;32m
COLOR_YELLOW = \033[0;33m
COLOR_BLUE = \033[0;34m
COLOR_END = \033[0m
#TESTCASES := ue2ue explicitaccess appredirect dnsredirect trafficsteering
TESTCASES := explicitaccess dnsredirect appredirect trafficsteering

.PHONY: default u d t l lf e ping uping ip dig waitkey firefox test $(addprefix test/, $(TESTCASES)) $(addprefix test-label/, $(TESTCASES)) 

default: u
# Start containers
u:
	$(DC) $(DEBUG) up -d
	$(DC) $(SOCKS) up -d
# Shutdown containers
d:
	$(DC) $(DEBUG) down
	$(DC) $(SOCKS) down 

# Restart containers
r: d u

# Enter container
e/%:
	$(EXEC) $(@F) bash

# Enter debug-container
t/%:
	$(EXEC) $(@F)-debug bash
# Get container's logs
l/%:
	$(LOG) $(@F)
# Get container's logs (continuous)
lf/%:
	$(LOG) $(@F) -f

# Get IP Address of an ue
ip/%:
	@$(EXEC) $(@F)-debug bash -c "ip --brief address show uesimtun0|awk '{print \"$(@F):\", \$$3; exit}'"

# Ping an ue from another ue
# Example uping/ue1/ue2 -> Ping from ue1 to ue2
uping/%:
	@echo "$(COLOR_BLUE)======  PING $(*D) -> $(@F) ======$(COLOR_END)"
	@TARGET=$(shell $(EXEC) $(@F)-debug bash -c "ip --brief address show uesimtun0|awk '{print \$$3; exit}'|cut -d"/" -f 1");\
	echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(PING) $$TARGET\" $(COLOR_END)";\
	$(EXEC) $(*D)-debug bash -c "$(PING) $$TARGET"

# Ping from a container
ping/%:
	$(EXEC) $(*D)-debug bash -c "$(PING) $(@F)"

# Dig from a container
dig/%:
	@echo "$(COLOR_BLUE)====== DIG $(*D) ->  $(@F) ======$(COLOR_END)"
	@echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(DIGSHORT) $(@F)\"$(COLOR_END)"
	@$(EXEC) $(*D)-debug bash -c "$(DIGSHORT) $(@F)"

# Curl from a container
curl/%:
	@echo "$(COLOR_BLUE)====== CURL $(*D) ->  $(@F) ======$(COLOR_END)"
	@echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(CURL) $(@F)\"$(COLOR_END)"
	@$(EXEC) $(*D)-debug bash -c "$(CURL) $(@F)"

# Curl from a container and print headers
curl_i/%:
	@echo "$(COLOR_BLUE)====== CURL $(*D) ->  $(@F) ======$(COLOR_END)"
	@echo "$(COLOR_RED)$(EXEC) $(*D)-debug bash -c \"$(CURL) $(@F)\"$(COLOR_END)"
	@$(EXEC) $(*D)-debug bash -c "$(CURL_I) $(@F)"

# Wait for a key press
waitkey/%:
#	@echo "$(COLOR_YELLOW)"
#	@echo "#=========================#"
#	@echo "# Press enter to continue #"
#	@echo "#=========================#$(COLOR_END)"
	@read line

# enable socks connection (firefox cannot send user/password), and open firefox profile
firefox/%:
	@TARGET=$(shell $(EXEC) $(@F)-debug bash -c "ip --brief address show ran-0|awk '{print \$$3; exit}'|cut -d"/" -f 1");\
	curl --connect-timeout 1 --socks5 user:password@$$TARGET:1080 test 2>/dev/null ; true; \
	echo "Starting firefox with profile $$TARGET, please create and configure it if it doesn't exist yet." ; \
	firefox -P $$TARGET 2>/dev/null &

# Run tests
test: $(addprefix test/, $(TESTCASES))

test-label/ue2ue:
	clear
	@echo "$(COLOR_GREEN)#===============================================================#"
	@echo "# Comparison of UE to UE latency between MEC and non-MEC slices #"
	@echo "#                  (press enter to continue)                    #"
	@echo "#===============================================================#$(COLOR_END)"
	@read line
test/ue2ue: test-label/ue2ue uping/ue3/ue4 waitkey/ue2ue/3 uping/ue1/ue2 waitkey/ue2ue/2


test-label/explicitaccess:
	clear
	@echo "$(COLOR_GREEN)#====================================#"
	@echo "#     Known instance identifier      #"
	@echo "#====================================#$(COLOR_END)"
test/explicitaccess: test-label/explicitaccess dig/ue1/site1.mec.test curl/ue1/site1.mec.test waitkey/explicitaccess/1

test-label/appredirect:
	clear
	@echo "$(COLOR_GREEN)#====================================#"
	@echo "#      Application Redirection       #"
	@echo "#====================================#$(COLOR_END)"
#test/appredirect: test-label/appredirect dig/ue3/site3.test curl/ue3/site3.test waitkey/appredirect/1 dig/ue1/site3.test curl/ue1/site3.test waitkey/appredirect/2
test/appredirect: test-label/appredirect  dig/ue1/site3.test curl_i/ue1/site3.test curl/ue1/site3.test waitkey/appredirect/2

test-label/dnsredirect:
	clear
	@echo "$(COLOR_GREEN)#================================#"
	@echo "#    More-informed DNS Resolver  #"
	@echo "#================================#$(COLOR_END)"
#test/dnsredirect: test-label/dnsredirect dig/ue3/site1.test curl/ue3/site1.test waitkey/dnsredirect/1 dig/ue1/site1.test curl/ue1/site1.test waitkey/dnsredirect/2
test/dnsredirect: test-label/dnsredirect dig/ue1/site1.test curl/ue1/site1.test waitkey/dnsredirect/2

test-label/trafficsteering:
	clear
	@echo "$(COLOR_GREEN)#=================================#"
	@echo "#         Uplink classifier       #"
	@echo "#=================================#$(COLOR_END)"
#test/trafficsteering: test-label/trafficsteering dig/ue3/site2.test curl/ue3/site2.test waitkey/trafficsteering/1 dig/ue1/site2.test curl/ue1/site2.test waitkey/trafficsteering/1
test/trafficsteering: test-label/trafficsteering dig/ue1/site2.test curl/ue1/site2.test waitkey/trafficsteering/1
