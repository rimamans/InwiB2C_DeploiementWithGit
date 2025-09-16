import { LightningElement, wire, track } from 'lwc';
import getRetailStores from '@salesforce/apex/InwiCGC_AMStatsController.getRetailStores';

export default class InwiCGC_AMStats extends LightningElement {
    columns1 = [        
        { label: 'Nom', fieldName: 'Name', type: 'text' },
        { label: 'Date Creation', fieldName: 'CreatedDate', type: 'date' },
        { label: 'Created By', fieldName: 'CreatedBy', type: 'text' },
        { label: 'Region', fieldName: 'inwiCGC_Region_AC__c', type: 'text' },
        { label: 'Localisation', fieldName: 'inwiCGC_Flag__c', type: 'text' },
        { label: 'Circuit', fieldName: 'inwiCGC_VilleAM__c', type: 'text' }
    ];

    columns2 = [
        { label: 'Nom AM', fieldName: 'Name', type: 'text' },
        { label: 'Dealer Identifier', fieldName: 'inwiCGC_Dealer_Identifier__c', type: 'boolean' },
        { label: 'MDN Dealer', fieldName: 'inwiB2C_MDN__c', type: 'text' }
    ];

    columns3 = [
        { label: 'Nom AM', fieldName: 'Name', type: 'text' },
        { label: 'Distributeur App Mobile', fieldName: 'inwiCGC_Distributeur_App__c', type: 'boolean' },
        { label: 'MDN Dealer', fieldName: 'inwiB2C_MDN__c', type: 'text' }
    ];

    @track data1 = [];
    @track data2 = [];
    @track data3 = [];

    @wire(getRetailStores)
    wiredRetailStores({ error, data }) {
        if (data) {
            this.data1 = data.map(store => ({
                Id: store.Id,
                CreatedDate: store.CreatedDate,
                Name: store.Name,
                CreatedBy: store.CreatedBy?.Name,
                inwiCGC_Region_AC__c: store.inwiCGC_Region_AC__c,
                inwiCGC_Flag__c: store.inwiCGC_Flag__c,
                inwiCGC_VilleAM__c: store.inwiCGC_VilleAM__c
            }));

            this.data2 = data.map(store => ({
                Id: store.Id,
                Name: store.Name,
                inwiCGC_Dealer_Identifier__c: store.inwiCGC_Dealer_Identifier__c,
                inwiB2C_MDN__c: store.inwiB2C_MDN__c
            }));

            this.data3 = data.map(store => ({
                Id: store.Id,
                Name: store.Name,
                inwiCGC_Distributeur_App__c: store.inwiCGC_Distributeur_App__c,
                inwiB2C_MDN__c: store.inwiB2C_MDN__c
            }));
        } else if (error) {
            console.error(error);
        }
    }
}