 
./network.sh up createChannel -ca -c medicochainchannel -s couchdb 
./network.sh deployCC -ccn basic -ccl javascript
# ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic -ccv 1 -ccl javascript



#for path variables
export PATH=${PWD}/../bin:$PATH

#for the fabric config path
export FABRIC_CFG_PATH=$PWD/../config/


#use manufacturer as default for our orgs
export CORE_PEER_TLS_ENABLED=true export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/users/Admin@manufacturer.medicochain.com/msp
export CORE_PEER_ADDRESS=localhost:7051



#manufacture drug
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"manufacture","Args":["manufacturer3","Threeplace","00003","2020-10-30","2021-10-30","10mg", "glucose-60mgelse-98mg","cefixime","99/54","55"]}'


#drug state
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"getDrugState","Args":["manufacturer3","00003"]}'


#transfer drug
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"buy","Args":["manufacturer4","00004" ,"manufacturer4","distributor4" ,"444", "2010-10-44","Lucknow"]}'

#retail drug
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"sellOut","Args":["manufacturer4","00004" ,"distributor4","Bhuwan Adhikari" ,"460", "2010-10-88","Tallobesi"]}'

 







#initialize the things
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'










#for basic asset transfer
#get all assets
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"Args":["GetAllAssets"]}'




 
#transfer asset 6 
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'


#create new asset
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt -c '{"function":"CreateAsset","Args":["myasset","aqua", "33", "Christopher", "555"]}'


#asset exists?
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.medicochain.com --tls --cafile ${PWD}/organizations/ordererOrganizations/medicochain.com/orderers/orderer.medicochain.com/msp/tlscacerts/tlsca.medicochain.com-cert.pem -C medicochainchannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/manufacturer.medicochain.com/peers/peer0.manufacturer.medicochain.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/distributor.medicochain.com/peers/peer0.distributor.medicochain.com/tls/ca.crt --peerAddresses localhost:5051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/wholesaler.medicochain.com/peers/peer0.wholesaler.medicochain.com/tls/ca.crt --peerAddresses localhost:3051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/retailer.medicochain.com/peers/peer0.retailer.medicochain.com/tls/ca.crt  -c '{"function":"AssetExists","Args":["myasset"]}'




