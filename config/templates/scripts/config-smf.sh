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

if [ -z "$N4_IP" ]; then
	echo "Missing mandatory environment variable (N4_IP)." > /dev/stderr
	exit 1
fi


# TODO: $USER_PLANE_INFORMATION instead of this
if [ -z "$UPF_N4_IP" ]; then
	echo "Missing mandatory environment variable (UPF_N4_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$UPF_N3_IP" ]; then
	echo "Missing mandatory environment variable (UPF_N3_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$DN_POOL" ]; then
	echo "Missing mandatory environment variable (DN_POOL)." > /dev/stderr
	exit 1
fi
if [ -z "$DNN" ]; then
	echo "Missing mandatory environment variable (DNN)." > /dev/stderr
	exit 1
fi
if [ -z "$SD" ]; then
	echo "Missing mandatory environment variable (SD)." > /dev/stderr
	exit 1
fi
if [ -z "$SST" ]; then
	echo "Missing mandatory environment variable (SST)." > /dev/stderr
	exit 1
fi

cp "${TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%BINDING_IP/${BINDING_IP}/g" "${CONFIG_FILE}"
sed -i "s/%REGISTER_IP/${REGISTER_IP}/g" "${CONFIG_FILE}"
sed -i "s/%BINDING_PORT/${BINDING_PORT:8000}/g" "${CONFIG_FILE}"
sed -i "s/%NRF/${NRF}/g" "${CONFIG_FILE}"
sed -i "s/%N4_IP/${N4_IP}/g" "${CONFIG_FILE}"

# TODO: Replace this
sed -i "s/%UPF_N4_IP/${UPF_N4_IP}/g" "${CONFIG_FILE}"
sed -i "s/%UPF_N3_IP/${UPF_N3_IP}/g" "${CONFIG_FILE}"
sed -i "s/%DN_POOL/${DN_POOL}/g" "${CONFIG_FILE}"
sed -i "s/%DNN/${DNN}/g" "${CONFIG_FILE}"
sed -i "s/%SD/${DNN}/g" "${CONFIG_FILE}"
sed -i "s/%SST/${SST}/g" "${CONFIG_FILE}"


