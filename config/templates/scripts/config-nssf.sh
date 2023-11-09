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
			NSI_LIST_SUB="${NSI_LIST_SUB}\n      nsiInformationList:\n        - nrfId: http://%NRF/nnrf-nfm/v1/nf-instances\n    ${NSI}" 
			;;
		*)
			NSI_LIST_SUB="${NSI_LIST_SUB}\n    ${NSI}" 
			;;
		esac
		NSI_LIST_SUB="${NSI_LIST_SUB}\n  ${NSI}"
	fi
done

cp "${TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%BINDING_IP/${BINDING_IP}/g" "${CONFIG_FILE}"
sed -i "s/%REGISTER_IP/${REGISTER_IP}/g" "${CONFIG_FILE}"
sed -i "s/%BINDING_PORT/${BINDING_PORT:8000}/g" "${CONFIG_FILE}"
sed -i "s/%NRF/${NRF}/g" "${CONFIG_FILE}"
sed -i "s/%SUPPORTED_NSSAIS_INDENT8/${SUPPORTED_NSSAIS_SUB_INDENT8}/g" "${CONFIG_FILE}"
sed -i "s/%SUPPORTED_NSSAIS_INDENT12/${SUPPORTED_NSSAIS_SUB_INDENT12}/g" "${CONFIG_FILE}"
sed -i "s/%NSI_LIST/${NSI_LIST_SUB}/g" "${CONFIG_FILE}"

