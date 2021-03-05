'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Drug = require('../chaincode-javascript/lib/drug.js');


// Main program function
async function main(
    manufacturer,
    drugNumber,
    currentOwner,
    newOwner,
    boughtAt,
    purchaseDateTime,
    purchasePlace,
) {

    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet('../identity/user/bhuwan2/wallet');


    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {

        // Specify userName for network access
        const userName = 'bhuwan2';

        // Load connection profile; will be used to locate a gateway
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../commercial-paper/organization/magnetocorp/gateway/connection-org2.yaml', 'utf8'));

        // Set connection options; identity and wallet
        let connectionOptions = {
            identity: userName,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }

        };

        // Connect to gateway using application specified parameters
        console.log('Connect to Fabric gateway.');

        await gateway.connect(connectionProfile, connectionOptions);

        // Access MedicochainNet network
        console.log('Use network channel: medicochainchannel.');

        const network = await gateway.getNetwork('medicochainchannel');

        // Get addressability to commercial drug contract
        console.log('Use org.medicochainnet.drug smart contract.');

        const contract = await network.getContract('drugContract', 'org.medicochainnet.drug');

        // transfer drug
        console.log('Submit commercial drug transfer transaction.');

        const transferResponse = await contract.submitTransaction(
            // "transfer",
            "buy",
            manufacturer,
            drugNumber,
            currentOwner,
            newOwner,
            boughtAt,
            purchaseDateTime,
            purchasePlace,
        );

        // process response
        console.log('Process buy transaction response.');

        let drug = Drug.fromBuffer(transferResponse);

        console.log(`${drug.manufacturer} drug : ${drug.drugNumber} successfully purchased by ${drug.owner}`);
        console.log('Transaction complete.');
        return drug;

    } catch (error) {

        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);
        throw error;

    } finally {

        // Disconnect from the gateway
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();

    }
}
module.exports.execute = main;
