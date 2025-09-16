/**
 * @description       : Lwc pour affichage des demandes de  recyclage des commandes ftth ainsi deux boutons  recycler et annuler 
 * @author            : Rosa slimani
 * @last modified on  : 07/02/2025
 * @last modified by  : rosa slimani
**/

import { LightningElement,api,track  } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';



export default class InwiB2C_DemandeRecyclageFTTHList extends OmniscriptBaseMixin(NavigationMixin(LightningElement)){
    @track sortBy;
    @track sortedDirection;
    _records = [];
    @api
    get records() {
        return this._records;
    }
    set records(value) {
        this._records = value;
        }

    //vérifier si la liste est vide
    get islistEmpty() {
        return this._records.length == 0 ? true : false;
    }   
      //construction du tableau contenant la liste des demandes
        columns = [
            { label: 'Numéro de commande', fieldName: 'OrderNumber',hideDefaultActions: 'true',initialWidth: 80 },
            { label: "Motif d'échec de raccordement", fieldName: 'InwiB2C_Motif_d_chec_de_raccordement__c',hideDefaultActions: 'true',initialWidth: 110 },
            { label: "Client", fieldName: 'Name',hideDefaultActions: 'true',initialWidth: 100 },
            { label: "Numéro de contact", fieldName: 'NumContact',hideDefaultActions: 'true',initialWidth: 130 },
            { label: "CIN", fieldName: 'CIN',hideDefaultActions: 'true',initialWidth: 110 },
            { label: "Statut de la demande", fieldName: 'InwiB2C_Statut__c',hideDefaultActions: 'true',initialWidth: 80 },
            { label: "Compteur de repéchage", fieldName: 'InwiB2C_Compteur_de_rep_chage__c',hideDefaultActions: 'true',initialWidth: 80 },
            {type: "button",typeAttributes: {   label: "Détails",  name: 'Details', variant: 'brand', value: 'view',disabled: { fieldName: 'DetailsDisabled' },iconPosition: 'left', },initialWidth: 100},
            {type: "button",typeAttributes: {   label: "Recycler",  name: 'Recycle', variant: 'brand', value: 'view',disabled: { fieldName: 'ReycleDisabled' },iconPosition: 'left', },initialWidth: 100},
            {type: "button", typeAttributes: {   label: "Annuler",  name: 'Cancel', variant: 'brand', value: 'view',disabled: { fieldName: 'CancelDisabled' }, iconPosition: 'left', },initialWidth: 100}
           
        
        ] ;
       
   
     //retourner au lwc l'action a faire et le numero de la commande
     handleClick(event){
        const row = event.detail.row;
        let action = '';
        if(event.detail.action.name == 'Cancel')
            action='cancel';
        else if (event.detail.action.name == 'Recycle'){
            action='recycle';
            }else if (event.detail.action.name == 'Details'){
                action='Details';
            }    
        this.omniUpdateDataJson({ 'orderNumber': row.OrderNumber }); //recuperer le numero de commande
        this.omniUpdateDataJson({ 'action':action});
        this.omniUpdateDataJson({ 'selectedRequest':row.Id});
        console.log(`Action: ${action}, Numéro de commande: ${row.OrderNumber}`);
        this.omniNextStep();
}
       //trier la tableau
       handleSort(event) {
    // recuperer le nom et trier la liste
          this.sortBy = event.detail.fieldName;
          this.sortedList = event.detail.sortedList;

  }



}