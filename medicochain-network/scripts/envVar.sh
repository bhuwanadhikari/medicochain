source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem
export PEER0_manufacturer_CA=${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt
export PEER0_distributor_CA=${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt
export PEER0_wholesaler_CA=${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt
export PEER0_retailer_CA=${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/medicochain.com/users/Admin@medicochain.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG = "manufacturer" ]; then
    export CORE_PEER_LOCALMSPID="ManufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_manufacturer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/users/Admin@manufacturer.medicochain.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG = "distributor" ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_distributor_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.medicochain.com/users/Admin@distributor.medicochain.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG = "wholesaler" ]; then
    export CORE_PEER_LOCALMSPID="WholesalerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_wholesaler_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com/msp
    export CORE_PEER_ADDRESS=localhost:5051

elif [ $USING_ORG = "retailer" ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_retailer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.medicochain.com/users/Admin@retailer.medicochain.com/msp
    export CORE_PEER_ADDRESS=localhost:3051


  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization{
    infoln "Done for the org: $1"
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
