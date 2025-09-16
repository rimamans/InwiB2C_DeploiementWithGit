import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class InwiB2C_DisplayCart extends OmniscriptBaseMixin(LightningElement) {

    __vlccart;
    isModalOpen = false;
    __displayErrors = false;

    @api
    get vlccart (){
        return this.__vlccart;
    }
    set vlccart (value){
        this.__vlccart = {...value};

    }

    @api
    get displayErrors (){
        return this.__displayErrors;
    }
    set displayErrors (value){
        this.__displayErrors = value;
    }

    get updatedCart (){
        let cart = [];
        let oldCart = JSON.parse(JSON.stringify(this.vlccart));

        if (oldCart.records && oldCart.records.length > 0){

            cart =  oldCart.records.map(item => {
                if (item.messages && item.messages.length > 0) item.inwiB2C_Error = true;
                else item.inwiB2C_Error = false;

                return item;

            });
        }
        return cart;

    }

    selectItem (event){
        console.log('eeeee');
        console.log(JSON.stringify(event.target.name));
        let items = {}
        items.records =[];
        items.records.push(event.target.name);
        
        let reponse = {
            selectedItem : items
        }
        
        this.omniUpdateDataJson(reponse);
        this.omniSaveState(reponse,true);
        this.omniNextStep();
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
                total += item.vlocity_cmt__OneTimeTotal__c.value;
            });

        }

        

        return total;

    }


}