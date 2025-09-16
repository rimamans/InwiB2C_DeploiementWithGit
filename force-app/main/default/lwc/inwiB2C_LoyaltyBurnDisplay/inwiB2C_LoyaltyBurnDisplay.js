import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_LoyaltyBurnDisplay.html';

export default class InwiB2C_LoyaltyBurnDisplay extends OmniscriptBaseMixin(LightningElement) {

    //@api records;

   _records;

    @api
    get records() {
        return this._records;
    }
    set records(value) {
        if (value) {
            this._records = value;
            //console.log(this.records);
        }
    }



    @track columns =[

        {fieldName: 'id', label: 'Id Transaction', hideDefaultActions: true ,initialWidth: 200, editable: false},
        {fieldName: 'offre', label: 'Offre', hideDefaultActions: true , editable: false},
        {fieldName: 'quantity', label: 'Nombre de Points', hideDefaultActions: true,initialWidth: 200, type :"number" , editable: false, typeAttributes: {
            minimumFractionDigits: "2"
        }},
        {fieldName: 'date', label: 'Date effective', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false}
         ];


    get loyaltyTransaction () {

        console.log(JSON.stringify(this.records));

       
        //if (this.records && this.records.loyaltyTransaction) return this.records.loyaltyTransaction;

        if (this.omniJsonData && this.omniJsonData.result && this.omniJsonData.result.loyaltyTransaction){
            return this.omniJsonData.result.loyaltyTransaction;
        }
        else return [];
    }



    render() {

        //console.log(this.omniJsonData);
        return template;
    }

    handleBlur(evt) {
        this.omniUpdateDataJson(evt.target.value);
    }


}