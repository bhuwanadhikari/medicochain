'use strict';

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

        // buy commercial drug
        console.log('Submit commercial drug buy transaction.');

        const buyResponse = await contract.submitTransaction(
            'buy',
            'manufacturer', //manufacturer of the drug
            '00001',        //drugNumber
            'manufacturer', // current owner
            'distributor',       //newOwner
            '45',       //cost
            '2020-10-10',// purchase date time
            'birgunj',   //purchase place
        );

        // process response
        console.log('Process buy transaction response.');

        let drug = Drug.fromBuffer(buyResponse);

        console.log(`${drug.manufacturer} commercial drug : ${drug.drugNumber} successfully purchased by ${drug.owner}`);
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

    console.log('Buy program complete.');

}).catch((e) => {

    console.log('Buy program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);

});
