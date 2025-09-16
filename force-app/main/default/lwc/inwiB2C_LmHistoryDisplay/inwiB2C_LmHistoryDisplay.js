import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_LmHistoryDisplay.html';

export default class InwiB2C_LmHistoryDisplay extends OmniscriptBaseMixin(LightningElement) {
    @api recordsString ;
    @track columns =[

        {fieldName: 'M_LINE_ID', label: 'Telephone', hideDefaultActions: true,initialWidth: 120},
        {fieldName: 'M_AMOUNT_CON', label: 'Montant', hideDefaultActions: true, initialWidth: 85,type: 'currency', typeAttributes: { currencyCode: 'MAD' }},
        {fieldName: 'DURATION', label: 'Duree', hideDefaultActions: true,initialWidth: 65},
        {fieldName: 'M_CALL_TYPE', label: 'Type', hideDefaultActions: true,initialWidth: 60},
        {fieldName: 'M_SERVICE_NAME', label: 'Service', hideDefaultActions: true},
        {fieldName: 'M_TYPE_CONSO', label: 'Type Conso', hideDefaultActions: true},
        {fieldName: 'GPRS_VOLUME', label: 'Volume', hideDefaultActions: true,initialWidth: 70},
        {label: 'Balances', type: "button", initialWidth: 120, typeAttributes: { label: "Balances", name: "balanceDetails", title: 'Cliquer ici pour le détail des balances'}}
             
            ];


   
    @track targetObject;
    @track draftValues = [];

    handleBlur(evt) {
        this.omniUpdateDataJson(evt.target.value);
    }

    render() {

        //console.log(this.omniJsonData);
        return template;
    }

    get records2 (){

        //let saveState = this.omniGetSaveState();

        //console.log(this.recordsString);

        let records = JSON.parse(this.recordsString);


        //console.log('in records2');
        
       if (records){
            //console.log(records);
            if (Array.isArray(records)){
                records.forEach((r,i) =>{
                    r.Id = i;
                })
                //console.log(records);
                return records;
            }else {
                let A = [];
                records.Id = 0;
                A.push(records);
                return A;
            }
        }

    }

}