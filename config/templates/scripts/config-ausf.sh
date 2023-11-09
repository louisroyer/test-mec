#!/usr/bin/env bash
set -e
echo "[$(date --iso-8601=s)] Using environment variables for building ${CONFIG_FILE} from ${TEMPLATE}." > /dev/stderr

if [ -z "$BINDING_IP" ]; then
	echo "Missing mandatory environment variable (BINDING_IP)." > /dev/stderr
	exit 1
fi

if [ -z "$REGISTER_IP" ]; then
	echo "Missing mandatory environment variable (REGISTER_IP)." > /dev/stderr
	exit 1
fi

if [ -z "$NRF" ]; then
	echo "Missing mandatory environment variable (NRF)." > /dev/stderr
	exit 1
fi

cp "${TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%BINDING_IP/${BINDING_IP}/g" "${CONFIG_FILE}"
sed -i "s/%REGISTER_IP/${REGISTER_IP}/g" "${CONFIG_FILE}"
sed -i "s/%BINDING_PORT/${BINDING_PORT:8000}/g" "${CONFIG_FILE}"
sed -i "s/%NRF/${NRF}/g" "${CONFIG_FILE}"


