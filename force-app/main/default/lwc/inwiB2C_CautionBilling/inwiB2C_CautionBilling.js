import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_CautionBilling.html';

export default class inwiB2C_CautionBilling extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    @track columns =[

       
        
        {fieldName: 'NEWPROFIL', label: 'Libellé produit', hideDefaultActions: true , editable: false},
        {fieldName: 'Date', label: 'Date de dépôt', hideDefaultActions: true, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},
        
        {fieldName: 'RefCaution', label: 'Réf caution', hideDefaultActions: true , editable: false},
        {fieldName: 'numLigne', label: 'Numéro de la ligne', hideDefaultActions: true , editable: false},
        {fieldName: 'amount', label: 'Montant de la caution', hideDefaultActions: true , editable: false}

         ];

  

get list () {
console.log('propreties')
console.log('this.records'+this.records)
       
  return this.records;
  
    }



    render() {
        //console.log(this.omniJsonData);
        return template;
    }


}