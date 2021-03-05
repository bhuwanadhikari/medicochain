'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Drug = require('../contract/lib/drug.js');

// Main program function
async function main() {

    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet('../identity/user/bhuwan2/wallet');

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {

        // Specify userName for network access
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

        // Connect to gateway using application specified parameters
        console.log('Connect to Fabric gateway.');

        await gateway.connect(connectionProfile, connectionOptions);

        // Access PaperNet network
        console.log('Use network channel: medicochainchannel.');

        const network = await gateway.getNetwork('medicochainchannel');

        // Get addressability to commercial drug contract
        console.log('Use org.medicochainnet.drug smart contract.');

        const contract = await network.getContract('drugContract');

        // issue commercial drug
        console.log('Submit commercial drug issue transaction.');

        const getDrugHistoryResponse = await contract.submitTransaction(
            'getDrugHistory',
            'manufacturer',
            '00001'
        );

        // process response
        try {
            console.log('Process issue transaction response.' + getDrugHistoryResponse);
        } catch (e) { console.log(e) }
        try {
            let drugHistory = Drug.fromBuffer(getDrugHistoryResponse);
            console.log("Received clean drug history is: ", drugHistory)
        } catch (e) { console.log(e) }

        console.log('Transaction complete.');

    } catch (error) {

        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);

    } finally {

        // Disconnect from the gateway
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();

    }
}
main().then(() => {

    console.log('Issue program complete.');

}).catch((e) => {

    console.log('Issue program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);

});
