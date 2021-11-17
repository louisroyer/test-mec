#!/usr/bin/env bash
set -e

#### CONFIGURATION ####
GNBS_INTERNAL="10.0.201.0/24"
GNBS_EXTERNAL="10.0.240.2 10.0.3.141"

AMF="10.0.214.0/24"
AMF_GW="10.0.214.2"

UPFS="10.0.203.0/24 10.0.205.0/24"
UPFS_GW="10.0.203.2 10.0.205.2"

DNNTEST="10.0.220.0/24"

STR_GNB_INTERNAL="10.0.201.3"
STR_TRUNKS="10.0.202.3 10.0.204.3"

STR_ROUTE_EXTERNAL="10.0.201.1"

GWR_TRUNKS="10.0.206.2 10.0.207.2"

TRUNKS_ST="10.0.202.2 10.0.204.2"
TRUNKS_GW="10.0.206.3 10.0.207.3"
#### END CONFIGURATION ####

### START SCRIPT ###
case "$1" in
	gnbs|gnb)
		echo "$GNBS_INTERNAL $GNBS_EXTERNAL"
		;;
	gnbs-ext|gnb-ext)
		echo "$GNBS_EXTERNAL"
		;;
	amf)
		echo "$AMF"
		;;
	upfs)
		echo "$UPFS"
		;;
	upf)
		read -ra upf <<< $UPFS
		echo  ${upf[-1+$2]}
		;;
	gw-router-trunk)
		read -ra st <<< $GWR_TRUNKS
		echo ${st[-1+$2]}
		;;
	gw-router-amf)
		echo "$AMF_GW"
		;;
	gw-router-upf)
		read -ra gw <<< $UPFS_GW
		echo ${gw[-1+$2]}
		;;
	trunk-st)
		read -ra st <<< $TRUNKS_ST
		echo ${st[-1+$2]}
		;;
	trunk-gw)
		read -ra st <<< $TRUNKS_GW
		echo ${st[-1+$2]}
		;;
	dnn-test)
		echo "$DNNTEST"
		;;
	st-router-trunk)
		read -ra st <<< $STR_TRUNKS
		echo ${st[-1+$2]}
		;;
	str-gnb-internal)
		echo "$STR_GNB_INTERNAL"
		;;
	str-route-external)
		echo "$STR_ROUTE_EXTERNAL"
		;;
esac
### END SCRIPT ###
