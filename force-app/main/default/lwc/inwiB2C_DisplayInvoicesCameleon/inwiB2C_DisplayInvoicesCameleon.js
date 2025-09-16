import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import template from './inwiB2C_DisplayInvoicesCameleon.html';

export default class inwiB2C_DisplayInvoicesCameleon extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {



    __records = [];
    __allpayedinvoices;
   
    @track
    list = [];
    index;


    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
        console.log("__records1" + JSON.stringify(this.__records));
    }

    get allpayedinvoices() {

        var results1 = [];
        if(this.records.length == undefined){
            
            if (this.records.status == "Payée")
             {
                 results1.push(this.records);
             }
         }else{
        for (let i = 0; i < this.records.length; i++) {
            if (this.records && this.records[i].status == "Payée") {
                results1.push(this.records[i]);
            }
        }
    }
       // this.list = results1;
        console.log("results1" + results1);
        console.log("geeeet");
        return results1;


    }

    set allpayedinvoices(value) {

        this.__allpayedinvoices = value;
  
        console.log("seeeet");
    }
    get allunpayedinvoices() {

        var results2 = [];
        var totalAmmount = 0;
        console.log("undefined"+this.records.length);
        if(this.records.length == undefined){
            
           if (this.records.status == "Partiellement payée" || this.records.status == "Impayée")
            {
                results2.push(this.records);
                 console.log("allunpayedinvoices"+this.records.status);
            }
        }else{
       
        for (let i = 0; i < this.records.length; i++) {
            console.log("FOR "+ this.records[i].status);
            if (this.records && (this.records[i].status == "Partiellement payée" || this.records[i].status == "Impayée")) {
                console.log("IN IF "+ this.records[i].status);
                results2.push(this.records[i]);
                totalAmmount += this.records[i].invoiceAmount;
            }
        }
    }
        /* this.list = results2;
       let totatamountinvoices = {
            "totatamount": totalAmmount
        }

        this.omniUpdateDataJson(totatamountinvoices);
        this.omniSaveState(totatamountinvoices, true);*/
        console.log("results2" + results2);
        console.log("totalAmmount" + totalAmmount);


        return results2;


    }

    readOnlyCheckBox() {
        return false;
    }
    renderedCallback() {
    }
    handleNext() {

            this.omniNextStep();
        
    }

    handlePrevious(){
        this.omniPrevStep();
    }

    render(event) {

        return template;
    }


}