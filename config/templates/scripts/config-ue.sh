#!/usr/bin/env bash
echo "[$(date --iso-8601=s)] Using environment variables for building ${CONFIG_FILE} from ${TEMPLATE}." > /dev/stderr
cp "${TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%MCC/$MCC/g" "${CONFIG_FILE}"
sed -i "s/%MNC/$MNC/g" "${CONFIG_FILE}"
sed -i "s/%MSISDN/$MSISDN/g" "${CONFIG_FILE}" 
sed -i "s/%GNB/$GNB/g" "${CONFIG_FILE}"

# S-NSSAI
read -ra SD_ARRAY <<< "${SD_LIST}"
read -ra APN_ARRAY <<< "${APN_LIST}"
S_NSSAI_SUB=""
SESSIONS_SUB=""
COUNT_SNSSAI=0
for SST in $SST_LIST; do
	S_NSSAI_SUB="${S_NSSAI_SUB}\n  - sst: ${SST}"
	S_NSSAI_SUB="${S_NSSAI_SUB}\n    sd: ${SD_ARRAY[$COUNT_SNSSAI]}"
	SESSIONS_SUB="${SESSIONS_SUB}\n  - type: 'IPv4'\n    apn: '${APN_ARRAY[$COUNT_SNSSAI]}'\n    slice:"
	SESSIONS_SUB="${SESSIONS_SUB}\n      sst: ${SST}"
	SESSIONS_SUB="${SESSIONS_SUB}\n      sd: ${SD_ARRAY[$COUNT_SNSSAI]}"
	COUNT_SNSSAI=${COUNT_SNSSAI+1}
done
sed -i "s/%S_NSSAI/${S_NSSAI_SUB}/g" "${CONFIG_FILE}"
sed -i "s/%SESSIONS/${SESSIONS_SUB}/g" "${CONFIG_FILE}"
