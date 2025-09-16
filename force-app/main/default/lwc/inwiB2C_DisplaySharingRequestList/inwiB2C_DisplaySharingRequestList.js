/**
 * @description       : Lwc pour affichage des demandes de partage avec les boutons
 * @author            : Imane Lakrari
 * @last modified on  : 25-12-2024
 * @last modified by  : Imane Lakrari
**/

import { LightningElement,api,track  } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_DisplaySharingRequestList extends OmniscriptBaseMixin(NavigationMixin(LightningElement)){

    @track sortBy;
    @track sortedDirection;
    __records = [];
    @api
    get records() {
        return this.__records;
    }
    set records(value) {
        this.__records = value;
        }

    columns = [
        { label: 'N° Partage', fieldName: 'InwiB2C_Numero_Partage__c',hideDefaultActions: 'true',initialWidth: 80 },
        { label: 'Numéro', fieldName: 'InwiB2C_Sequence__c',hideDefaultActions: 'true' ,initialWidth: 50 },
        { label: 'Nom', fieldName: 'InwiB2C_LastName__c',hideDefaultActions: 'true',initialWidth: 80 },
        { label: 'Prénom', fieldName: 'InwiB2C_FirstName__c',hideDefaultActions: 'true',initialWidth: 80 },
        { label: 'N° Identification', fieldName: 'InwiB2C_Nationalid__c' ,hideDefaultActions: 'true',initialWidth: 80},
        { label: 'Numéro de contact', fieldName: 'InwiB2C_numeroContact__c' ,hideDefaultActions: 'true',initialWidth: 80},
        { label: 'ND', fieldName: 'InwiB2C_nd_Attribut__c' ,hideDefaultActions: 'true',initialWidth: 90 },
        { label: 'ND OI', fieldName: 'InwiB2C_NumeroDesignation__c' ,hideDefaultActions: 'true',initialWidth: 90 },
        { label: 'Opérateur Infrastructure', fieldName: 'InwiB2C_Operateur_Infrastructure__c' ,hideDefaultActions: 'true',initialWidth: 80 },
        { label: 'Date de création', fieldName: 'CreatedDate', type: 'date' ,hideDefaultActions: 'true',initialWidth: 90},
        { label: 'Statut de la demande', fieldName: 'InwiB2C_Statut_demande__c' ,hideDefaultActions: 'true',initialWidth: 90},
        //K-KA 30-05-2025 B-29274 start
        { label: 'Type d\'Opération', fieldName: 'InwiB2C_Type_d_operation__c' ,hideDefaultActions: 'true',initialWidth: 90},
        //K-KA 30-05-2025 B-29274 end
        { label: 'Motif de rejet', fieldName: 'InwiB2C_Motif__c' ,hideDefaultActions: 'true',initialWidth: 110},
        {type: "button", typeAttributes: {   label: "Voir",  name: 'View', variant: 'brand',disabled: false, value: 'view', iconPosition: 'left', },initialWidth: 80},
        {type: "button", typeAttributes: {   label: "Annuler",  name: 'Cancel', variant: 'brand', value: 'view',disabled: { fieldName: 'CancelDisabled' }, iconPosition: 'left', },initialWidth: 95},
        {type: "button",typeAttributes: {   label: "Recycler",  name: 'Recycle', variant: 'brand', value: 'view',disabled: { fieldName: 'ReycleDisabled' },iconPosition: 'left', },initialWidth: 100}
        ]; 

    //vérifier si la liste est vide
    get islistEmpty() {
           return this.__records.length == 0 ? true : false;

        }

    //retourner au lwc l'action a faire et l'id de la demande selectionée
    handlesClick(event){
            const row = event.detail.row;
            let action = 'view';
            if(event.detail.action.name == 'Cancel')
                action='cancel';
            else if (event.detail.action.name == 'Recycle')
                action='recycle';
            this.omniUpdateDataJson({ 'selectedRequest':row.Id});
            this.omniUpdateDataJson({ 'action':action});
            this.omniNextStep();
    }

    //trier la tableau
    handleSort(event) {
        // Get the field name and sort direction
        this.sortBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;

      }
}