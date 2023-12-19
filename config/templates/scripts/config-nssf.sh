#!/usr/bin/env bash
set -e
echo "[$(date --iso-8601=s)] Using environment variables for building ${CONFIG_FILE} from ${TEMPLATE}." > /dev/stderr

if [ -z "$NRF" ]; then
	echo "Missing mandatory environment variable (NRF)." > /dev/stderr
	exit 1
fi
if [ -z "$BINDING_IP" ]; then
	echo "Missing mandatory environment variable (BINDING_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$REGISTER_IP" ]; then
	echo "Missing mandatory environment variable (REGISTER_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$SUPPORTED_NSSAIS" ]; then
	echo "Missing mandatory environment variable (SUPPORTED_NSSAIS)." > /dev/stderr
	exit 1
fi

IFS=$'\n'
# Supported NSSAI
SUPPORTED_NSSAIS_SUB_INDENT8=""
for NSSAI in ${SUPPORTED_NSSAIS}; do
	if [ -n "${NSSAI}" ]; then
		SUPPORTED_NSSAIS_SUB_INDENT8="${SUPPORTED_NSSAIS_SUB_INDENT8}\n        ${NSSAI}"
	fi
done
SUPPORTED_NSSAIS_SUB_INDENT12=""
for NSSAI in ${SUPPORTED_NSSAIS}; do
	if [ -n "${NSSAI}" ]; then
		SUPPORTED_NSSAIS_SUB_INDENT12="${SUPPORTED_NSSAIS_SUB_INDENT12}\n            ${NSSAI}"
	fi
done

# NSI List
NSI_LIST_SUB=""
for NSI in ${SUPPORTED_NSSAIS}; do
	if [ -n "${NSI}" ]; then
		case ${NSI} in
		-*)
			NSI_LIST_SUB="${NSI_LIST_SUB}\n      nsiInformationList:\n        - nrfId: http://${NRF}/nnrf-nfm/v1/nf-instances\n    ${NSI}" 
			;;
		*)
			NSI_LIST_SUB="${NSI_LIST_SUB}\n    ${NSI}" 
			;;
		esac
		NSI_LIST_SUB="${NSI_LIST_SUB}\n  ${NSI}"
	fi
done

awk \
	-v SUPPORTED_NSSAIS_SUB_INDENT8="${SUPPORTED_NSSAIS_SUB_INDENT8}" \
	-v SUPPORTED_NSSAIS_INDENT12="${SUPPORTED_NSSAIS_SUB_INDENT12}" \
	-v BINDING_IP="${BINDING_IP}" \
	-v REGISTER_IP="${REGISTER_IP}" \
	-v BINDING_PORT="${BINDING_PORT:-8000}" \
	-v NRF="${NRF}" \
	-v NSI_LIST="${NSI_LIST_SUB}" \
	'{
		sub(/%SUPPORTED_NSSAIS_INDENT8/, SUPPORTED_NSSAIS_SUB_INDENT8);
		sub(/%SUPPORTED_NSSAIS_INDENT12/, SUPPORTED_NSSAIS_SUB_INDENT12);
		sub(/%BINDING_IP/, BINDING_IP);
		sub(/%REGISTER_IP/, REGISTER_IP);
		sub(/%BINDING_PORT/, BINDING_PORT);
		sub(/%NRF/, NRF);
		sub(/%NSI_LIST/, NSI_LIST_SUB);
		print;
	}' \
	"${TEMPLATE}" > "${CONFIG_FILE}"
