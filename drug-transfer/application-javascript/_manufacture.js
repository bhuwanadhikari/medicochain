'use strict';

const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Drug = require('../chaincode-javascript/lib/drug.js');
const { buildCCPManufacturer } = require('../../test-application/javascript/AppUtil.js');

// Main program function
async function main(
    manufacturer,
    manufacturedIn,
    drugNumber,
    mfgDate,
    expDate,
    dose,
    composition,
    name,
    bn,
    isSoldOut,
    mrp
) {

    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet('./auth/wallet/bhuwan2');
    console.log(wallet);

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {

        // Specify userName for network access
        // const userName = 'isabella.issuer@magnetocorp.com';
        const userName = 'bhuwan2';

        // Load connection profile; will be used to locate a gateway

        // create new connection profile here okay and right
        const ccp = buildCCPManufacturer();

        // Set connection options; identity and wallet
        let connectionOptions = {
            identity: userName,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }
        };

        // Connect to gateway using application specified parameters
        console.log('Connect to Fabric gateway.');

        await gateway.connect(ccp, connectionOptions);

        // Access medicochain network
        console.log('Use network channel: medicochainchannel.');

        const network = await gateway.getNetwork('medicochainchannel');

        // Get addressability to drug contract
        console.log('Use org.medicochainnet.drug smart contract.');

        const contract = await network.getContract('drugContract');

        // manufacture drug
        console.log('Submit drug manufacture transaction.');

        const manufactureResponse = await contract.submitTransaction(
            'manufacture',

            manufacturer,
            manufacturedIn,
            drugNumber,
            mfgDate,
            expDate,
            dose,
            composition,
            name,
            bn,
            isSoldOut,
            mrp
        );

        // process response
        console.log('Process issue transaction response.' + manufactureResponse);

        let drug = Drug.fromBuffer(manufactureResponse);

        console.log(`${drug.issuer} commercial drug : ${drug.drugNumber} successfully issued for value ${drug.mrp}`);
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

module.exports.execute = main

