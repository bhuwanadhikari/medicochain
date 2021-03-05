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
        const userName = 'appUser44';

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

        const issueResponse = await contract.submitTransaction(
            

            'manufacture',
            'manufacturer',
            'Delhi Metropolitans',
            '00001',
            '2020-10-30',
            '2021-10-30',
            '10mg',
            'glucose-60mg,else-98mg',
            'cefixime',
            '99/54',
            'false',
            '55'
        );

        // process response
        console.log('Process issue transaction response.' + issueResponse);

        let drug = Drug.fromBuffer(issueResponse);

        console.log(`${drug.issuer} commercial drug : ${drug.drugNumber} successfully issued for value ${drug.mrp}`);
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
