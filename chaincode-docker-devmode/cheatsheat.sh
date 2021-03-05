#package the chaincode
peer lifecycle chaincode package medchaincode.tar.gz --lang node --path ./chaincode --label medchaincode_0

#
node chaincode/lib/assetTransfer.js --peer.address peer:7052

