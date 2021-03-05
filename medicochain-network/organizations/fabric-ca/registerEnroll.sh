
source scriptUtils.sh











function createManufacturer() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/manufacturer.medicochain.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-manufacturer --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name manufactureradmin --id.secret manufactureradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/manufacturer.medicochain.com/peers
  mkdir -p organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/msp --csr.hosts peer0.manufacturer.medicochain.com --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls --enrollment.profile tls --csr.hosts peer0.manufacturer.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/tlsca/tlsca.manufacturer.medicochain.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/ca
  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/ca/ca.manufacturer.medicochain.com-cert.pem

  mkdir -p organizations/peerOrganizations/manufacturer.medicochain.com/users
  mkdir -p organizations/peerOrganizations/manufacturer.medicochain.com/users/User1@manufacturer.medicochain.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/users/User1@manufacturer.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/users/User1@manufacturer.medicochain.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/manufacturer.medicochain.com/users/Admin@manufacturer.medicochain.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://manufactureradmin:manufactureradminpw@localhost:7054 --caname ca-manufacturer -M ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/users/Admin@manufacturer.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/manufacturer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/users/Admin@manufacturer.medicochain.com/msp/config.yaml

}








function createDistributor() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/distributor.medicochain.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/distributor.medicochain.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-distributor --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/distributor.medicochain.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-distributor --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-distributor --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-distributor --id.name distributoradmin --id.secret distributoradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/distributor.medicochain.com/peers
  mkdir -p organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/msp --csr.hosts peer0.distributor.medicochain.com --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls --enrollment.profile tls --csr.hosts peer0.distributor.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/tlsca/tlsca.distributor.medicochain.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/ca
  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/ca/ca.distributor.medicochain.com-cert.pem

  mkdir -p organizations/peerOrganizations/distributor.medicochain.com/users
  mkdir -p organizations/peerOrganizations/distributor.medicochain.com/users/User1@distributor.medicochain.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/users/User1@distributor.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/users/User1@distributor.medicochain.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/distributor.medicochain.com/users/Admin@distributor.medicochain.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://distributoradmin:distributoradminpw@localhost:8054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/users/Admin@distributor.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/users/Admin@distributor.medicochain.com/msp/config.yaml

}
















function createWholesaler() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/wholesaler.medicochain.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca-wholesaler --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null
e
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name wholesaleradmin --id.secret wholesaleradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/wholesaler.medicochain.com/peers
  mkdir -p organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-wholesaler -M ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/msp --csr.hosts peer0.wholesaler.medicochain.com --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-wholesaler -M ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls --enrollment.profile tls --csr.hosts peer0.wholesaler.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/tlsca/tlsca.wholesaler.medicochain.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/ca
  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/ca/ca.wholesaler.medicochain.com-cert.pem

  mkdir -p organizations/peerOrganizations/wholesaler.medicochain.com/users
  mkdir -p organizations/peerOrganizations/wholesaler.medicochain.com/users/User1@wholesaler.medicochain.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-wholesaler -M ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/users/User1@wholesaler.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/users/User1@wholesaler.medicochain.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://wholesaleradmin:wholesaleradminpw@localhost:6054 --caname ca-wholesaler -M ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com/msp/config.yaml

}













function createRetailer() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/retailer.medicochain.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/retailer.medicochain.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:5054 --caname ca-retailer --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-retailer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-retailer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-retailer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-5054-ca-retailer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/retailer.medicochain.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-retailer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-retailer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-retailer --id.name retaileradmin --id.secret retaileradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/retailer.medicochain.com/peers
  mkdir -p organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/msp --csr.hosts peer0.retailer.medicochain.com --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:5054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls --enrollment.profile tls --csr.hosts peer0.retailer.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/tlsca/tlsca.retailer.medicochain.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/ca
  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/ca/ca.retailer.medicochain.com-cert.pem

  mkdir -p organizations/peerOrganizations/retailer.medicochain.com/users
  mkdir -p organizations/peerOrganizations/retailer.medicochain.com/users/User1@retailer.medicochain.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:5054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/users/User1@retailer.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/users/User1@retailer.medicochain.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/retailer.medicochain.com/users/Admin@retailer.medicochain.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://retaileradmin:retaileradminpw@localhost:5054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/users/Admin@retailer.medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/users/Admin@retailer.medicochain.com/msp/config.yaml

}















function createOrderer() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/ordererOrganizations/medicochain.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/medicochain.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/medicochain.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/medicochain.com/orderers
  mkdir -p organizations/ordererOrganizations/medicochain.com/orderers/medicochain.com

  mkdir -p organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp --csr.hosts orderer.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls --enrollment.profile tls --csr.hosts orderer.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/medicochain.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem

  mkdir -p organizations/ordererOrganizations/medicochain.com/users
  mkdir -p organizations/ordererOrganizations/medicochain.com/users/Admin@medicochain.com

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/medicochain.com/users/Admin@medicochain.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/medicochain.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/medicochain.com/users/Admin@medicochain.com/msp/config.yaml

}
