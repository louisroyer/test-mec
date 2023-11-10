#!/usr/bin/env bash
set -e
echo "[$(date --iso-8601=s)] Using environment variables for building ${CONFIG_FILE} from ${TEMPLATE}." > /dev/stderr

if [ -z "$N4_IP" ]; then
	echo "Missing mandatory environment variable (N4_IP)." > /dev/stderr
	exit 1
fi


cp "${TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%N4_IP/${N4_IP}/g" "${CONFIG_FILE}"

