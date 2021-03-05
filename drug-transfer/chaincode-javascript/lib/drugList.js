'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('./../ledger-api/statelist.js');

const Drug = require('./drug.js');

class DrugList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.medicochainnet.druglist');
        this.use(Drug);
    }

    async addDrug(drug) {
        return this.addState(drug);
    }

    async getDrug(drugKey) {
        return this.getState(drugKey);
    }

    async updateDrug(drug) {
        return this.updateState(drug);
    }

    async getDrugHistory(drugKey) {
        return this.getHistory(drugKey);
    }
}


module.exports = DrugList;
