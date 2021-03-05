'use strict';

// Utility class for ledger state
const State = require('./../ledger-api/state.js');

// Enumerate drug state values
const cpState = {
    MANUFACTURED: 1,
    ACTIVE: 2,
    SOLD_OUT: 3
};

class Drug extends State {

    constructor(obj) {
        super(Drug.getClass(), [obj.manufacturer, obj.drugNumber]);
        Object.assign(this, obj);
    }

    getManufacturer() {
        return this.manufacturer;
    }

    setManufacturer(newManufacturer) {
        this.manufacturer = newManufacturer;
    }

    getOwner() {
        return this.owner;
    }

    setOwner(newOwner) {
        this.owner = newOwner;
    }

    getBoughtAt() {
        return this.boughtAt;
    }

    setBoughtAt(boughtAt) {
        this.boughtAt = boughtAt;
    }

    getPurchaseDateTime() {
        return this.purchaseDateTime;
    }

    setPurchaseDateTime(purchaseDateTime) {
        this.purchaseDateTime = purchaseDateTime;
    }

    getPurchasePlace() {
        return this.purchasePlace;
    }


    getCurrentState() {
        return this.currentState;
    }


    setPurchasePlace(purchasePlace) {
        this.purchasePlace = purchasePlace;
    }

    setManufactured() {
        this.currentState = cpState.MANUFACTURED;
    }

    isManufactured() {
        return this.currentState === cpState.MANUFACTURED;
    }

    setActive() {
        this.currentState = cpState.ACTIVE;
    }

    isActive() {
        console.log("State of drug is here, ", this.currentState)
        return this.currentState === cpState.ACTIVE;
    }

    setSoldOut() {
        this.currentState = cpState.SOLD_OUT;
    }

    isSoldOut() {
        return this.currentState === cpState.SOLD_OUT;
    }

    static fromBuffer(buffer) {
        return Drug.deserialize(buffer);
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to drug
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, Drug);
    }

    /**
     * Factory method to create a drug object
     */
    static createInstance(
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
        return new Drug({
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

        });
    }

    static getClass() {
        return 'org.medicochainnet.drug';
    }
}

module.exports = Drug;
