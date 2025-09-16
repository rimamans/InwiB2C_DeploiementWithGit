import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayBalanceDealer.html';

export default class inwiB2C_DisplayBalanceDealer  extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    @track columns =[

        {fieldName: 'mdn', label: 'Numéro de la ligne', hideDefaultActions: true , initialWidth: 170,editable: false},
        {fieldName: 'name', label: 'Nom', hideDefaultActions: true , initialWidth: 170,editable: false},

        {fieldName: 'currentBalance', label: 'Solde actuel', hideDefaultActions: true , initialWidth: 200,editable: false},
       
        {fieldName: 'currency', label: 'Unité', hideDefaultActions: true,initialWidth: 80, editable: false},
        
        {fieldName: 'availableBalance', label: 'Solde disponible', hideDefaultActions: true , initialWidth: 170, editable: false}
         ];
    
  

    render() {

        //console.log(this.omniJsonData);
        return template;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        
        this.usageData = row.usages;

        this.openmodal();

        

        
    }

    @track openUsageDetail = false;
    openmodal() {
            this.openUsageDetail = true
        }
    closeModal() {
            this.openUsageDetail = false
        } 

    handleBlur(evt) {
        this.omniUpdateDataJson(evt.target.value);
    }

}