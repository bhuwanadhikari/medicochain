#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem
PEER0_manufacturer_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt
PEER0_distributor_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt
PEER0_wholesaler_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="OrdererMSP"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/medicochain.com/users/Admin@medicochain.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  ORG=$1
  if [ $ORG -eq 1 ]; then
    CORE_PEER_LOCALMSPID="ManufacturerMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANUFACTURER_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/manufacturer.medicochain.com/users/Admin@manufacturer.medicochain.com/msp
    CORE_PEER_ADDRESS=peer0.manufacturer.medicochain.com:7051
  elif [ $ORG -eq 2 ]; then
    CORE_PEER_LOCALMSPID="DistributorMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_TRANSPORTER_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/distributor.medicochain.com/users/Admin@distributor.medicochain.com/msp
    CORE_PEER_ADDRESS=peer0.distributor.medicochain.com:9051
  elif [ $ORG -eq 3 ]; then
    CORE_PEER_LOCALMSPID="WholesalerMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com/msp
    CORE_PEER_ADDRESS=peer0.wholesaler.medicochain.com:11051
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo $'\e[1;31m'!!!!!!!!!!!!!!! $2 !!!!!!!!!!!!!!!!$'\e[0m'
    echo
    exit 1
  fi
}
