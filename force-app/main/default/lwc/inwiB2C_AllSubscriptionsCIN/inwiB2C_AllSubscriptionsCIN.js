import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_AllSubscriptionsCIN.html';


export default class InwiB2C_AllSubscriptionsCIN extends OmniscriptBaseMixin(LightningElement)  {
    areDetailsVisible = false;
    @api list;
    columns = [

        { label: 'Numero MDN', fieldName: 'mdn',initialWidth: 160},
        { label: 'Offre', fieldName: 'Offre',initialWidth: 180 },
        { label: 'Canal de souscription', fieldName: 'Canal',initialWidth: 150 },
        { label: 'Numéro de la pièce d’identité', fieldName: 'CIN',initialWidth: 200},
        { label: 'Statut', fieldName: 'StatusSubscription',initialWidth: 180 },
            ];
            
    renderedCallback() {

        if (this.list && this.list != null)
        this.areDetailsVisible = true;

    }
  
    handleSelectedSubscription(event) {
       
        const selectedRows = event.detail.selectedRows;
    
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++){
            let selectedSubscription = { 
                "selectedSubscriptionId" :event.detail.selectedRows,
                
            }
            this.omniUpdateDataJson(selectedSubscription);
            this.omniSaveState(selectedSubscription,true);
        }
 
    }
    SaveAndNext(event){

        this.omniNextStep();

    }
    render() {
        return template;
    }
}