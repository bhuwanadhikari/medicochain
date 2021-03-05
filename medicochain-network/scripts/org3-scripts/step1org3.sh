#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# This script is designed to be run in the wholesalercli container as the
# first step of the EYFN tutorial.  It creates and submits a
# configuration transaction to add wholesaler to the test network
#

CHANNEL_NAME="$1"
DELAY="$2"
TIMEOUT="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="medicochainchannel"}
: ${DELAY:="3"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
COUNTER=1
MAX_RETRY=5


# import environment variables
. scripts/wholesaler-scripts/envVarCLI.sh


# fetchChannelConfig <channel_id> <output_json>
# Writes the current channel config for a given channel to a JSON file
fetchChannelConfig() {
  ORG=$1
  CHANNEL=$2
  OUTPUT=$3

  setOrdererGlobals

  setGlobals $ORG

  echo "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config config_block.pb -o orderer.medicochain.com:7050 --ordererTLSHostnameOverride orderer.medicochain.com -c $CHANNEL --tls --cafile $ORDERER_CA
  { set +x; } 2>/dev/null

  echo "Decoding config block to JSON and isolating config to ${OUTPUT}"
  set -x
  configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config >"${OUTPUT}"
  { set +x; } 2>/dev/null
}

# createConfigUpdate <channel_id> <original_config.json> <modified_config.json> <output.pb>
# Takes an original and modified config, and produces the config update tx
# which transitions between the two
createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  set -x
  configtxlator proto_encode --input "${ORIGINAL}" --type common.Config >original_config.pb
  configtxlator proto_encode --input "${MODIFIED}" --type common.Config >modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb >config_update.pb
  configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate >config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
  configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope >"${OUTPUT}"
  { set +x; } 2>/dev/null
}

# signConfigtxAsPeerOrg <org> <configtx.pb>
# Set the peerOrg admin of an org and signing the config update
signConfigtxAsPeerOrg() {
  PEERORG=$1
  TX=$2
  setGlobals $PEERORG
  set -x
  peer channel signconfigtx -f "${TX}"
  { set +x; } 2>/dev/null
}

echo
echo "========= Creating config transaction to add wholesaler to network =========== "
echo

# Fetch the config for the channel, writing it to config.json
fetchChannelConfig 1 ${CHANNEL_NAME} config.json

# Modify the configuration to append the new org
set -x
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"WholesalerMSP":.[1]}}}}}' config.json ./organizations/peerOrganizations/wholesaler.medicochain.com/wholesaler.json > modified_config.json
{ set +x; } 2>/dev/null

# Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to wholesaler_update_in_envelope.pb
createConfigUpdate ${CHANNEL_NAME} config.json modified_config.json wholesaler_update_in_envelope.pb

echo
echo "========= Config transaction to add wholesaler to network created ===== "
echo

echo "Signing config transaction"
echo
signConfigtxAsPeerOrg 1 wholesaler_update_in_envelope.pb

echo
echo "========= Submitting transaction from a different peer (peer0.distributor) which also signs it ========= "
echo
setGlobals 2
set -x
peer channel update -f wholesaler_update_in_envelope.pb -c ${CHANNEL_NAME} -o orderer.medicochain.com:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${ORDERER_CA}
{ set +x; } 2>/dev/null

echo
echo "========= Config transaction to add wholesaler to network submitted! =========== "
echo

exit 0
