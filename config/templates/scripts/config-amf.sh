#!/usr/bin/env bash
echo "[$(date --iso-8601=s)] Using environment variables for building $CONFIG_FILE from $TEMPLATE." > /dev/stderr
cp $TEMPLATE $CONFIG_FILE
sed -i "s/%AMF_NAME/${AMF_NAME:-AMF}/g" $CONFIG_FILE
sed -i "s/%NGAP_IP/$NGAP_IP/g" $CONFIG_FILE
sed -i "s/%SBI_REGISTER_IP/$SBI_REGISTER_IP/g" $CONFIG_FILE
sed -i "s/%SBI_BINDING_IP/$SBI_BINDING_IP/g" $CONFIG_FILE
sed -i "s/%SBI_BINDING_PORT/${SBI_BINDING_PORT:-8000}/g" $CONFIG_FILE
sed -i "s/%MCC/$MCC/g" $CONFIG_FILE
sed -i "s/%MNC/$MNC/g" $CONFIG_FILE
sed -i "s/%AMF_ID/$AMF_ID/g" $CONFIG_FILE
sed -i "s~%NRF_URI~$NRF_URI~g" $CONFIG_FILE
sed -i "s/%LOCALITY/${LOCALITY:-loc1}/g" $CONFIG_FILE
sed -i "s/%TAC/${TAC:-1}/g" $CONFIG_FILE

# DNN
DNN_SUB=""
for DNN in $DNN_LIST; do
	DNN_SUB="${DNN_SUB}\n    - $DNN"
done
sed -i "s/%DNN/$DNN_SUB/g" $CONFIG_FILE 

# S-NSSAI
read -ra SD_ARRAY <<< $SD_LIST
S_NSSAI_SUB=""
COUNT_SNSSAI=0
for SST in $SST_LIST; do
	S_NSSAI_SUB="${S_NSSAI_SUB}\n        - sst: $SST"
	S_NSSAI_SUB="${S_NSSAI_SUB}\n          sd: ${SD_ARRAY[$COUNT_SNSSAI]}"
	COUNT_SNSSAI=${COUNT_SNSSAI+1}
done
sed -i "s/%S_NSSAI/$S_NSSAI_SUB/g" $CONFIG_FILE
