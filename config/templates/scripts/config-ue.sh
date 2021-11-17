#!/usr/bin/env bash
echo "[$(date --iso-8601=s)] Using environment variables for building $config_file from $template." > /dev/stderr
cp $template $config_file
sed -i "s/%MCC/$MCC/g" $config_file
sed -i "s/%MNC/$MNC/g" $config_file
sed -i "s/%MSISDN/$MSISDN/g" $config_file 
sed -i "s/%GNB/$GNB/g" $config_file

# S-NSSAI
read -ra SD_ARRAY <<< $SD_LIST
read -ra APN_ARRAY <<< $APN_LIST
S_NSSAI_SUB=""
SESSIONS_SUB=""
COUNT_SNSSAI=0
for SST in $SST_LIST; do
	S_NSSAI_SUB="${S_NSSAI_SUB}\n  - sst: $SST"
	S_NSSAI_SUB="${S_NSSAI_SUB}\n    sd: ${SD_ARRAY[$COUNT_SNSSAI]}"
	SESSIONS_SUB="${SESSIONS_SUB}\n  - type: 'IPv4'\n    apn: '${APN_ARRAY[$COUNT_SNSSAI]}'\n    slice:"
	SESSIONS_SUB="${SESSIONS_SUB}\n      sst: $SST"
	SESSIONS_SUB="${SESSIONS_SUB}\n      sd: ${SD_ARRAY[$COUNT_SNSSAI]}"
	COUNT_SNSSAI=${COUNT_SNSSAI+1}
done
sed -i "s/%S_NSSAI/$S_NSSAI_SUB/g" $config_file
sed -i "s/%SESSIONS/$SESSIONS_SUB/g" $config_file
