/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, Wallets } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const { buildCAClient, registerAndEnrollUser, enrollAdmin } = require('../../utils/CAUtil.js');
const { buildCCPManufacturer, buildWallet } = require('../../utils/AppUtil.js');
const Drug = require('../chaincode-javascript/lib/drug')


const channelName = 'medicochainchannel';
const chaincodeName = 'basic';
const mspOrg1 = 'ManufacturerMSP';
const walletPath = path.join(__dirname, 'wallet');
const org1UserId = 'appUser44';

function prettyJSONString(inputString) {
	return JSON.stringify(JSON.parse(inputString), null, 2);
}


async function main() {
	try {
		// build an in memory object with the network configuration (also known as a connection profile)
		const ccp = buildCCPManufacturer();

		// // build an instance of the fabric ca services client based on
		// // the information in the network configuration
		const caClient = buildCAClient(FabricCAServices, ccp, 'ca.manufacturer.medicochain.com');

		// // setup the wallet to hold the credentials of the application user
		const wallet = await buildWallet(Wallets, walletPath);

		// // in a real application this would be done on an administrative flow, and only once
		await enrollAdmin(caClient, wallet, mspOrg1);

		// // in a real application this would be done only when a new user was required to be added
		// // and would be part of an administrative flow
		await registerAndEnrollUser(caClient, wallet, mspOrg1, org1UserId, 'org1.department1');

		console.log(`******** API finished executing ${error}`);

	} catch (error) {
		console.error(`******** FAILED to run the application: ${error}`);
	}
}

module.exports.execute = main;
