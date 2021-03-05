#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This script extends the Hyperledger Fabric test network by adding
# adding a third organization to the network
#

# prepending $PWD/../bin to PATH to ensure we are picking up the correct binaries
# this may be commented out to resolve installed version of tools if desired
export PATH=${PWD}/../../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
export VERBOSE=false

# Print the usage message
function printHelp () {
  echo "Usage: "
  echo "  addWholesaler.sh up|down|generate [-c <channel name>] [-t <timeout>] [-d <delay>] [-f <docker-compose-file>] [-s <dbtype>]"
  echo "  addWholesaler.sh -h|--help (print this message)"
  echo "    <mode> - one of 'up', 'down', or 'generate'"
  echo "      - 'up' - add wholesaler to the sample network. You need to bring up the test network and create a channel first."
  echo "      - 'down' - bring down the test network and wholesaler nodes"
  echo "      - 'generate' - generate required certificates and org definition"
  echo "    -c <channel name> - test network channel name (defaults to \"medicochainchannel\")"
  echo "    -ca <use CA> -  Use a CA to generate the crypto material"
  echo "    -t <timeout> - CLI timeout duration in seconds (defaults to 10)"
  echo "    -d <delay> - delay duration in seconds (defaults to 3)"
  echo "    -s <dbtype> - the database backend to use: goleveldb (default) or couchdb"
  echo "    -i <imagetag> - the tag to be used to launch the network (defaults to \"latest\")"
  echo "    -cai <ca_imagetag> - the image tag to be used for CA (defaults to \"${CA_IMAGETAG}\")"
  echo "    -verbose - verbose mode"
  echo
  echo "Typically, one would first generate the required certificates and "
  echo "genesis block, then bring up the network. e.g.:"
  echo
  echo "	addWholesaler.sh generate"
  echo "	addWholesaler.sh up"
  echo "	addWholesaler.sh up -c medicochainchannel -s couchdb"
  echo "	addWholesaler.sh down"
  echo
  echo "Taking all defaults:"
  echo "	addWholesaler.sh up"
  echo "	addWholesaler.sh down"
}

# We use the cryptogen tool to generate the cryptographic material
# (x509 certs) for the new org.  After we run the tool, the certs will
# be put in the organizations folder with manufacturer and distributor

# Create Organziation crypto material using cryptogen or CAs
function generateWholesaler() {

  # Create crypto material using cryptogen
  if [ "$CRYPTO" == "cryptogen" ]; then
    which cryptogen
    if [ "$?" -ne 0 ]; then
      echo "cryptogen tool not found. exiting"
      exit 1
    fi
    echo
    echo "##########################################################"
    echo "##### Generate certificates using cryptogen tool #########"
    echo "##########################################################"
    echo

    echo "##########################################################"
    echo "############ Create Wholesaler Identities ######################"
    echo "##########################################################"

    set -x
    cryptogen generate --config=wholesaler-crypto.yaml --output="../organizations"
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      echo "Failed to generate certificates..."
      exit 1
    fi

  fi

  # Create crypto material using Fabric CAs
  if [ "$CRYPTO" == "Certificate Authorities" ]; then

    fabric-ca-client version > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "ERROR! fabric-ca-client binary not found.."
      echo
      echo "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
      echo "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
      exit 1
    fi

    echo
    echo "##########################################################"
    echo "##### Generate certificates using Fabric CA's ############"
    echo "##########################################################"

    IMAGE_TAG=${CA_IMAGETAG} docker-compose -f $COMPOSE_FILE_CA_DISTRIBUTOR up -d 2>&1

    . fabric-ca/registerEnroll.sh

    sleep 10

    echo "##########################################################"
    echo "############ Create Wholesaler Identities ######################"
    echo "##########################################################"

    createWholesaler

  fi

  echo
  echo "Generate CCP files for Wholesaler"
  ./ccp-generate.sh
}

# Generate channel configuration transaction
function generateWholesalerDefinition() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi
  echo "##########################################################"
  echo "#######  Generating Wholesaler organization definition #########"
  echo "##########################################################"
   export FABRIC_CFG_PATH=$PWD
   set -x
   configtxgen -printOrg WholesalerMSP > ../organizations/peerOrganizations/wholesaler.medicochain.com/wholesaler.json
   res=$?
   { set +x; } 2>/dev/null
   if [ $res -ne 0 ]; then
     echo "Failed to generate Wholesaler config material..."
     exit 1
   fi
  echo
}

function WholesalerUp () {
  # start wholesaler nodes
  if [ "${DATABASE}" == "couchdb" ]; then
    IMAGE_TAG=${IMAGETAG} docker-compose -f $COMPOSE_FILE_DISTRIBUTOR -f $COMPOSE_FILE_COUCH_DISTRIBUTOR up -d 2>&1
  else
    IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_DISTRIBUTOR up -d 2>&1
  fi
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start Wholesaler network"
    exit 1
  fi
}

# Generate the needed certificates, the genesis block and start the network.
function addWholesaler () {

  # If the test network is not up, abort
  if [ ! -d ../organizations/ordererOrganizations ]; then
    echo
    echo "ERROR: Please, run ./network.sh up createChannel first."
    echo
    exit 1
  fi

  # generate artifacts if they don't exist
  if [ ! -d "../organizations/peerOrganizations/wholesaler.medicochain.com" ]; then
    generateWholesaler
    generateWholesalerDefinition
  fi

  CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /fabric-tools/) {print $1}')
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "Bringing up network"
    WholesalerUp
  fi

  # Use the CLI container to create the configuration transaction needed to add
  # Wholesaler to the network
  echo
  echo "###############################################################"
  echo "####### Generate and submit config tx to add Wholesaler #############"
  echo "###############################################################"
  docker exec Wholesalercli ./scripts/wholesaler-scripts/step1wholesaler.sh $CHANNEL_NAME $CLI_DELAY $CLI_TIMEOUT $VERBOSE
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to create config tx"
    exit 1
  fi

  echo
  echo "###############################################################"
  echo "############### Have Wholesaler peers join network ##################"
  echo "###############################################################"
  docker exec Wholesalercli ./scripts/wholesaler-scripts/step2wholesaler.sh $CHANNEL_NAME $CLI_DELAY $CLI_TIMEOUT $VERBOSE
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to have Wholesaler peers join network"
    exit 1
  fi

}

# Tear down running network
function networkDown () {

    cd ..
    ./network.sh down
}


# Obtain the OS and Architecture string that will be used to select the correct
# native binaries for your platform
OS_ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up

# Using crpto vs CA. default is cryptogen
CRYPTO="cryptogen"

CLI_TIMEOUT=10
#default for delay
CLI_DELAY=3
# channel name defaults to "medicochainchannel"
CHANNEL_NAME="medicochainchannel"
# use this as the docker compose couch file
COMPOSE_FILE_COUCH_DISTRIBUTOR=docker/docker-compose-couch-wholesaler.yaml
# use this as the default docker-compose yaml definition
COMPOSE_FILE_DISTRIBUTOR=docker/docker-compose-wholesaler.yaml
# certificate authorities compose file
COMPOSE_FILE_CA_DISTRIBUTOR=docker/docker-compose-ca-wholesaler.yaml
# default image tag
IMAGETAG="latest"
# default ca image tag
CA_IMAGETAG="latest"
# database
DATABASE="leveldb"

# Parse commandline args

## Parse mode
if [[ $# -lt 1 ]] ; then
  printHelp
  exit 0
else
  MODE=$1
  shift
fi

# parse flags

while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  -h )
    printHelp
    exit 0
    ;;
  -c )
    CHANNEL_NAME="$2"
    shift
    ;;
  -ca )
    CRYPTO="Certificate Authorities"
    ;;
  -t )
    CLI_TIMEOUT="$2"
    shift
    ;;
  -d )
    CLI_DELAY="$2"
    shift
    ;;
  -s )
    DATABASE="$2"
    shift
    ;;
  -i )
    IMAGETAG=$(go env GOARCH)"-""$2"
    shift
    ;;
  -cai )
    CA_IMAGETAG="$2"
    shift
    ;;
  -verbose )
    VERBOSE=true
    shift
    ;;
  * )
    echo
    echo "Unknown flag: $key"
    echo
    printHelp
    exit 1
    ;;
  esac
  shift
done


# Determine whether starting, stopping, restarting or generating for announce
if [ "$MODE" == "up" ]; then
  echo "Add Wholesaler to channel '${CHANNEL_NAME}' with '${CLI_TIMEOUT}' seconds and CLI delay of '${CLI_DELAY}' seconds and using database '${DATABASE}'"
  echo
elif [ "$MODE" == "down" ]; then
  EXPMODE="Stopping network"
elif [ "$MODE" == "generate" ]; then
  EXPMODE="Generating certs and organization definition for Wholesaler"
else
  printHelp
  exit 1
fi

#Create the network using docker compose
if [ "${MODE}" == "up" ]; then
  addWholesaler
elif [ "${MODE}" == "down" ]; then ## Clear the network
  networkDown
elif [ "${MODE}" == "generate" ]; then ## Generate Artifacts
  generateWholesaler
  generateWholesalerDefinition
else
  printHelp
  exit 1
fi
