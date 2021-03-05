'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Drug = require('../chaincode-javascript/lib/drug.js');

// Main program function
async function main(
    manufacturer,
    drugNumber
) {

    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet('../identity/user/bhuwan2/wallet');

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {

        // const userName = 'bhuwan2.issuer@magnetocorp.com';
        const userName = 'bhuwan2';

        // Load connection profile; will be used to locate a gateway
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../commercial-paper/organization/magnetocorp/gateway/connection-org2.yaml', 'utf8'));

        // Set connection options; identity and wallet
        let connectionOptions = {
            identity: userName,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }
        };

        console.log('Connect to Fabric gateway.');

        await gateway.connect(connectionProfile, connectionOptions);

        // Access medicochain network
        console.log('Use network channel: medicochainchannel.');

        const network = await gateway.getNetwork('medicochainchannel');

        // Get addressability to drug contract
        console.log('Use org.medicochainnet.drug smart contract.');

        const contract = await network.getContract('drugContract');

        // manufacture drug
        console.log('Submit drug manufacture transaction.');

        const getDrugHistoryResponse = await contract.submitTransaction(
            'getDrugHistory',
            manufacturer,
            drugNumber
        );
        let drugHistory = Drug.fromBuffer(getDrugHistoryResponse);
        console.log('Transaction complete.');
        return drugHistory;
    } catch (error) {
        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);
        throw error
    } finally {
        // Disconnect from the gateway
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();

    }
}
module.exports.execute = main; 
