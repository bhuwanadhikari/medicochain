'use strict';

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');

// medicochain specifc classes
const Drug = require('./drug.js');
const DrugList = require('./drugList.js');

class DrugContext extends Context {

    constructor() {
        super();
        // All drugs are held in a list of drugs
        this.drugList = new DrugList(this);
    }

}

/**
 * Define drug smart contract by extending Fabric Contract class
 */
class DrugContract extends Contract {

    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('org.medicochainnet.drug');
    }

    /**
     * Define a custom context for drug
    */
    createContext() {
        return new DrugContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // No implementation required with this example
        // It could be where data migration is performed, if necessary
        console.log('Instantiate the contract');
    }


    async manufacture(
        ctx,
        manufacturer,
        manufacturedIn,
        drugNumber,
        mfgDate,
        expDate,
        dose,
        composition,
        name,
        bn,
        mrp
    ) {

        // create an instance of the drug
        let drug = Drug.createInstance(
            manufacturer,
            manufacturedIn,
            drugNumber,
            mfgDate,
            expDate,
            dose,
            composition,
            name,
            bn,
            mrp
        );

        // Smart contract, rather than drug, moves drug into MANUFACTURED state
        drug.setManufactured();

        // Newly issued drug is owned by the manufacturer
        drug.setOwner(manufacturer);

        // Add the drug to the list of all similar drugs in the ledger world state
        await ctx.drugList.addDrug(drug);

        // Must return a serialized drug to caller of smart contract
        return drug;
    }

    async buy(
        ctx,
        manufacturer,
        drugNumber,
        currentOwner,
        newOwner,
        boughtAt,
        purchaseDateTime,
        purchasePlace,
    ) {

        // Retrieve the current drug using key fields provided
        let drugKey = Drug.makeKey([manufacturer, drugNumber]);
        let drug = await ctx.drugList.getDrug(drugKey);

        // Validate current owner
        // if (drug.getOwner() !== currentOwner) {
        //     throw new Error('Drug ' + manufacturer + drugNumber + ' is not owned by ' + currentOwner + 'and compare ' + currentOwner + ',' + drug.getOwner());
        // }


        // if (!drug.isSoldOut() && drug.isManufactured()) {
        drug.setBoughtAt(boughtAt)
        // }


        // if (!drug.isSoldOut() && drug.isManufactured()) {
        drug.setPurchaseDateTime(purchaseDateTime)
        // }


        // if (!drug.isSoldOut() && drug.isManufactured()) {
        drug.setPurchasePlace(purchasePlace)
        // }

        // First buy moves state from MANUFACTURED to ACTIVE
        // if (drug.isManufactured()) {
        drug.setActive();
        // }

        // Check drug is not already SOLD_OUT
        // if (drug.isActive()) {
        drug.setOwner(newOwner);
        // } else {
        //     throw new Error('Drug ' + manufacturer + drugNumber + ' is not ACTIVE. Current state = ' + drug.getCurrentState());
        // }

        // Update the drug
        await ctx.drugList.updateDrug(drug);
        return drug;
    }


    async sellOut(
        ctx,
        manufacturer, //manufacturer of the drug
        drugNumber,        //drugNumber
        currentOwner, // current owner
        newOwner,       //newOwner
        boughtAt,       //cost
        purchaseDateTime,// purchase date time
        purchasePlace,
    ) {

        // Retrieve the current drug using key fields provided
        let drugKey = Drug.makeKey([manufacturer, drugNumber]);
        let drug = await ctx.drugList.getDrug(drugKey);

        // Validate current owner
        // if (drug.getOwner() !== currentOwner) {
        //     throw new Error('Drug ' + manufacturer + drugNumber + ' is not owned by ' + currentOwner + 'and compare ' + currentOwner + ',' + drug.getOwner());
        // }


        // if (!drug.isSoldOut() && drug.isManufactured()) {
        drug.setBoughtAt(boughtAt)
        // }


        // if (!drug.isSoldOut() && drug.isManufactured()) {
        drug.setPurchaseDateTime(purchaseDateTime)
        // }


        // if (!drug.isSoldOut() && drug.isManufactured()) {
        drug.setPurchasePlace(purchasePlace)
        // }

        // First buy moves state from MANUFACTURED to ACTIVE
        // if (drug.isManufactured()) {
        drug.setActive();
        // }

        drug.setSoldOut();

        // Check drug is not already SOLD_OUT
        // if (drug.isActive()) {
        drug.setOwner(newOwner);
        // } else {
        //     throw new Error('Drug ' + manufacturer + drugNumber + ' is not ACTIVE. Current state = ' + drug.getCurrentState());
        // }


        // Update the drug
        await ctx.drugList.updateDrug(drug);
        return drug;
    }
















    // async sellOut(
    //     ctx,
    //     manufacturer,
    //     drugNumber,
    //     currentOwner,
    //     newOwner,
    //     soldAt,
    //     purchaseDateTime,
    //     purchasePlace,
    // ) {

    //     // Retrieve the current drug using key fields provided
    //     let drugKey = Drug.makeKey([manufacturer, drugNumber]);
    //     let drug = await ctx.drugList.getDrug(drugKey);

    //     // Validate current owner
    //     // if (drug.getOwner() !== currentOwner) {
    //     // console.log('here is owner comparison', drug.getOwner, currentOwner)
    //     // throw new Error('Drug ' + manufacturer + drugNumber + ' is not owned by ' + currentOwner);
    //     // }


    //     // if (!drug.isSoldOut() && drug.isManufactured()) {
    //     drug.setSoldAt(soldAt)
    //     // }


    //     // if (!drug.isSoldOut() && drug.isManufactured()) {
    //     drug.getPurchaseDateTime(purchaseDateTime)
    //     // }


    //     // if (!drug.isSoldOut() && drug.isManufactured()) {
    //     drug.setPurchasePlace(purchasePlace)
    //     // }



    //     // Check drug is not already active to be sold
    //     // if (drug.isActive()) {
    //     drug.setOwner(newOwner);
    //     // } else {
    //     //     throw new Error('Drug ' + manufacturer + drugNumber + ' is not ACTIVE. Current state = ' + drug.getCurrentState());
    //     // }

    //     //selling drug to customer
    //     // if (drug.isActive()) {
    //     drug.setSoldOut();
    //     // }

    //     // Update the drug
    //     await ctx.drugList.updateDrug(drug);
    //     return drug;
    // }

    //get drug state
    async getDrugState(ctx, manufacturer, drugNumber) {
        // Retrieve the current drug using key fields provided

        let drugKey = Drug.makeKey([manufacturer, drugNumber]);
        let state = await ctx.drugList.getDrug(drugKey);

        logg('history from contract', state);

        return state || JSON.stringify({});
    }


    //get drug History
    async getDrugHistory(ctx, manufacturer, drugNumber) {
        // Retrieve the current drug using key fields provided

        let drugKey = Drug.makeKey([manufacturer, drugNumber]);
        let history = await ctx.drugList.getDrugHistory(drugKey);

        logg('history from contract', history)

        return history
    }


    //simple log for the test
    async getChaincodeStatus(ctx) {
        // Retrieve the current drug using key fields provided
        logg('printing the drug contract status');
        return JSON.stringify({
            "message": "chaincode is deployed"
        });
    }
}

const logg = (message, data) => {
    console.log('==============================================================================================================================================');
    console.log(message, ':::::', data);
    console.log('====================================================================================================================================================')
}

module.exports = DrugContract;
