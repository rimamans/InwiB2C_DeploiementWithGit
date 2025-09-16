import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class InwiB2C_CartButton extends OmniscriptBaseMixin(LightningElement) {

    __vlccart;
    isModalOpen = false;

    @api
    get vlccart (){
        return this.__vlccart;
    }
    set vlccart (value){
        this.__vlccart = {...value};

    }

    
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    get cartTotalAmount(){

        let total = 0;

        if (this.vlccart.records) {
            this.vlccart.records.forEach(item => {
                total += item.vlocity_cmt__EffectiveOneTimeTotal__c.value;
            });

        }

        

        return total;

    }
}