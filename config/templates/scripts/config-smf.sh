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

if [ -z "$NRF_URI" ]; then
	echo "Missing mandatory environment variable (NRF_URI)." > /dev/stderr
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

awk \
	-v BINDING_IP="${BINDING_IP}" \
	-v REGISTER_IP="${REGISTER_IP}" \
	-v BINDING_PORT="${BINDING_PORT:-8000}" \
	-v NRF_URI="${NRF_URI}" \
	-v N4_IP="${N4_IP}" \
	-v UPF_N4_IP="${UPF_N4_IP}" \
	-v UPF_N3_IP="${UPF_N3_IP}" \
	-v DN_POOL="${DN_POOL}" \
	-v DNN="${DNN}" \
	-v SD="${SD}" \
	-v SST="${SST}" \
	'{
		sub(/%SUPPORTED_NSSAIS_INDENT8/, SUPPORTED_NSSAIS_SUB_INDENT8);
		sub(/%SUPPORTED_NSSAIS_INDENT12/, SUPPORTED_NSSAIS_SUB_INDENT12);
		sub(/%BINDING_IP/, BINDING_IP);
		sub(/%REGISTER_IP/, REGISTER_IP);
		sub(/%BINDING_PORT/, BINDING_PORT);
		sub(/%NRF_URI/, NRF_URI);
		sub(/%N4_IP/, N4_IP);
		sub(/%UPF_N4_IP/, UPF_N4_IP);
		sub(/%UPF_N3_IP/, UPF_N3_IP);
		sub(/%DN_POOL/, DN_POOL);
		sub(/%DNN/, DNN);
		sub(/%SD/, SD);
		sub(/%SST/, SST);
		print;
	}' \
	"${TEMPLATE}" > "${CONFIG_FILE}"

cat "${CONFIG_FILE}"
