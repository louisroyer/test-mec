#!/usr/bin/env bash
echo "[$(date --iso-8601=s)] Using environment variables for building ${CONFIG_FILE} from ${TEMPLATE}." > /dev/stderr
cp "${TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%MCC/$MCC/g" "${CONFIG_FILE}"
sed -i "s/%MNC/$MNC/g" "${CONFIG_FILE}"
sed -i "s/%NCI/$NCI/g" "${CONFIG_FILE}" 
sed -i "s/%LINK_IP/$LINK_IP/g" "${CONFIG_FILE}"
sed -i "s/%NGAP_IP/$NGAP_IP/g" "${CONFIG_FILE}"
sed -i "s/%GTP_IP/$GTP_IP/g" "${CONFIG_FILE}"
sed -i "s/%AMF_IP/$AMF_IP/g" "${CONFIG_FILE}"
sed -i "s/%AMF_PORT/${AMF_PORT:-38412}/g" "${CONFIG_FILE}"
sed -i "s/%TAC/${TAC:-1}/g" "${CONFIG_FILE}"

# S-NSSAI
read -ra SD_ARRAY <<< "${SD_LIST}"
S_NSSAI_SUB=""
COUNT_SNSSAI=0
for SST in $SST_LIST; do
	S_NSSAI_SUB="${S_NSSAI_SUB}\n  - sst: ${SST}"
	S_NSSAI_SUB="${S_NSSAI_SUB}\n    sd: ${SD_ARRAY[$COUNT_SNSSAI]}"
	COUNT_SNSSAI=${COUNT_SNSSAI+1}
done
sed -i "s/%S_NSSAI/${S_NSSAI_SUB}/g" "${CONFIG_FILE}"
