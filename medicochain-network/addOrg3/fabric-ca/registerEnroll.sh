

function createWholesaler {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/wholesaler.medicochain.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-wholesaler --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-wholesaler --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name wholesaleradmin --id.secret wholesaleradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

	mkdir -p ../organizations/peerOrganizations/wholesaler.medicochain.com/peers
  mkdir -p ../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-wholesaler -M ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/msp --csr.hosts peer0.wholesaler.medicochain.com --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-wholesaler -M ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls --enrollment.profile tls --csr.hosts peer0.wholesaler.medicochain.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/tlsca/tlsca.wholesaler.medicochain.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/ca
  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/ca/ca.wholesaler.medicochain.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/wholesaler.medicochain.com/users
  mkdir -p ../organizations/peerOrganizations/wholesaler.medicochain.com/users/User1@wholesaler.medicochain.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-wholesaler -M ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/users/User1@wholesaler.medicochain.com/msp --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/users/User1@wholesaler.medicochain.com/msp/config.yaml

  mkdir -p ../organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://wholesaleradmin:wholesaleradminpw@localhost:11054 --caname ca-wholesaler -M ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com/msp --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/wholesaler.medicochain.com/users/Admin@wholesaler.medicochain.com/msp/config.yaml

}
