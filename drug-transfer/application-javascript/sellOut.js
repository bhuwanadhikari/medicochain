/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

/*
 * This application has 6 basic steps:
 * 1. Select an identity from a wallet
 * 2. Connect to network gateway
 * 3. Access MedicochainNet network
 * 4. Construct request to issue commercial drug
 * 5. Submit transaction
 * 6. Process response
 */

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

    // redeem commercial drug
    console.log('Submit commercial drug redeem transaction.');

    const sellOutResponse = await contract.submitTransaction(
      'sellOut',
      'manufacturer', //manufacturer of the drug
      '00001',        //drugNumber
      'distributor', // current owner
      'bhuwan2 adhikari',       //newOwner
      '55',       //cost
      '2020-10-15',// purchase date time
      'dhading',   //purchase place
    );

    // process response
    console.log('Process redeem transaction response.');

    let drug = Drug.fromBuffer(sellOutResponse);

    console.log(`${drug.manufacturer}  drug : ${drug.drugNumber} successfully sold to ${drug.owner}`);
    console.log('Transaction complete.');

  } catch (error) {

    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);

  } finally {

    // Disconnect from the gateway
    console.log('Disconnect from Fabric gateway.')
    gateway.disconnect();

  }
}
main().then(() => {

  console.log('Sell program complete.');

}).catch((e) => {

  console.log('Sell program exception.');
  console.log(e);
  console.log(e.stack);
  process.exit(-1);

});
