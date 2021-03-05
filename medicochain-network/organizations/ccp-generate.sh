#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=manufacturer
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/manufacturer.medicochain.com/tlsca/tlsca.manufacturer.medicochain.com-cert.pem
CAPEM=organizations/peerOrganizations/manufacturer.medicochain.com/ca/ca.manufacturer.medicochain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/manufacturer.medicochain.com/connection-manufacturer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/manufacturer.medicochain.com/connection-manufacturer.yaml

ORG=distributor
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/distributor.medicochain.com/tlsca/tlsca.distributor.medicochain.com-cert.pem
CAPEM=organizations/peerOrganizations/distributor.medicochain.com/ca/ca.distributor.medicochain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/distributor.medicochain.com/connection-distributor.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/distributor.medicochain.com/connection-distributor.yaml



ORG=wholesaler
P0PORT=5051
CAPORT=6054
PEERPEM=organizations/peerOrganizations/wholesaler.medicochain.com/tlsca/tlsca.wholesaler.medicochain.com-cert.pem
CAPEM=organizations/peerOrganizations/wholesaler.medicochain.com/ca/ca.wholesaler.medicochain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/wholesaler.medicochain.com/connection-wholesaler.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/wholesaler.medicochain.com/connection-wholesaler.yaml




ORG=retailer
P0PORT=3051
CAPORT=5054
PEERPEM=organizations/peerOrganizations/retailer.medicochain.com/tlsca/tlsca.retailer.medicochain.com-cert.pem
CAPEM=organizations/peerOrganizations/retailer.medicochain.com/ca/ca.retailer.medicochain.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/retailer.medicochain.com/connection-retailer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/retailer.medicochain.com/connection-retailer.yaml
