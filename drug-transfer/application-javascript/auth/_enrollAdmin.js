
'use strict';

const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');
const { buildCAClient, registerAndEnrollUser, enrollAdmin } = require('../../../test-application/javascript/CAUtil.js');
const { buildWallet, buildCCPManufacturer } = require('../../../test-application/javascript/AppUtil.js');

const channelName = 'medicochainchannel';
const chaincodeName = 'basic';
const mspOrg1 = 'ManufacturerMSP';
const org1UserId = 'appUser2';

async function main() {
    try {
        // load the network configuration
        // let connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection-org2.yaml', 'utf8'));
        // let connectionProfile = yaml.safeLoad(fs.readFileSync('../commercial-paper/organization/magnetocorp/gateway/connection-org2.yaml', 'utf8'));
        /////////////////////////////////////////////
        // build an in memory object with the network configuration (also known as a connection profile)

        const ccp = buildCCPManufacturer();
        // build an instance of the fabric ca services client based on
        // the information in the network configuration
        const caClient = buildCAClient(FabricCAServices, ccp, 'ca.manufacturer.medicochain.com');

        // setup the wallet to hold the credentials of the application user
        const walletPath = path.join(__dirname, 'wallet/bhuwan2');
        const wallet = await buildWallet(Wallets, walletPath);

        // in a real application this would be done on an administrative flow, and only once
        return await enrollAdmin(caClient, wallet, mspOrg1);

        // in a real application this would be done only when a new user was required to be added
        // and would be part of an administrative flow
        // await registerAndEnrollUser(caClient, wallet, mspOrg1, org1UserId, 'org1.department1');


        // /////////////////////////////////////////////
        // // Create a new CA client for interacting with the CA.
        // const caInfo = ccp.certificateAuthorities['ca.org2.example.com'];
        // const caTLSCACerts = caInfo.tlsCACerts.pem;
        // const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

        // // Create a new file system based wallet for managing identities.
        // const walletPath = path.join(process.cwd(), '../identity/user/bhuwan2/wallet');
        // const wallet = await Wallets.newFileSystemWallet(walletPath);
        // console.log(`Wallet path: ${walletPath}`);

        // // Check to see if we've already enrolled the admin user.
        // const userExists = await wallet.get('bhuwan2');
        // if (userExists) {
        //     console.log('An identity for the client user "user1" already exists in the wallet');
        //     return;
        // }

        // // Enroll the admin user, and import the new identity into the wallet.
        // const enrollment = await ca.enroll({ enrollmentID: 'user1', enrollmentSecret: 'user1pw' });
        // const x509Identity = {
        //     credentials: {
        //         certificate: enrollment.certificate,
        //         privateKey: enrollment.key.toBytes(),
        //     },
        //     mspId: 'Org2MSP',
        //     type: 'X.509',
        // };
        // await wallet.put('bhuwan2', x509Identity);

    } catch (error) {
        console.error(`Failed to enroll admin: ${error}`);
        throw error;
        process.exit(1);
    }
}

module.exports.execute = main;
