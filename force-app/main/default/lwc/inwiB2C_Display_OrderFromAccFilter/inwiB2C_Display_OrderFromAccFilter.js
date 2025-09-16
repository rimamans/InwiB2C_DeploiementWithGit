import { LightningElement, wire, api } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';

import { refreshApex } from '@salesforce/apex';
import getOrderList from '@salesforce/apex/inwiB2C_OrderController.getOrderList';

export default class inwiB2C_Display_OrderFromAccFilter extends LightningElement {
    @api recordId;
    records;
    error;
    columns = [
        { label: 'Commande', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'InwiB2C_Num_ro_de_la_commande__c' }, target: '_self' }},
        { label: 'Statut', fieldName: 'InwiB2C_Statut_Order__c', type: 'text' },
        { label: 'Canal ', fieldName: 'InwiB2C_Canal_Order__c', type: 'text' },
        { label: 'Type de commande', fieldName: 'InwiB2C_Type_commande__c', type: 'text' },
        { label: 'Type d\'acte de gestion', fieldName: 'InwiB2C_Type_acte_de_gestion__c', type: 'text' },
        { label: 'Type de migration', fieldName: 'InwiB2C_Type_de_migration__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'TypeOffre', type: 'text' }
    ];

    sortedBy;
    sortedDirection;
    currentRecordId;

    connectedCallback() {
        this.currentRecordId = this.recordId;
        console.log('RecordId:', this.currentRecordId);
    }
    

    // Appel à la méthode Apex lors de l'initialisation du composant
    @wire(getOrderList, { accountId: '$currentRecordId'
 })
    
    wiredRecords(result) {
        console.log("value =", JSON.stringify(result));

        if (result.data) {
            this.records = result.data.map(order => ({
                ...order,
                OrderLink: '/' + order.inwiB2C_Order__c, 
                TypeOffre: order.inwiB2C_Order__r.InwiB2C_Type_Offer__c 
            }));
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            console.error('Erreur lors du chargement des données : ', result.error);
        }
    }

  
    refreshData() {
        return refreshApex(this.records);
    }


    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
       
    }
    handleRowAction(event) {
    }
}