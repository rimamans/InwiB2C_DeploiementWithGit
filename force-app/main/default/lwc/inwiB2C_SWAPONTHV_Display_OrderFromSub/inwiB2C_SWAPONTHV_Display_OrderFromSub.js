import { LightningElement, wire, api } from 'lwc'; 
import { refreshApex } from '@salesforce/apex'; 
import getAllOrders from '@salesforce/apex/inwiB2C_SWAPONTHV_OrderSubController.getAllOrders';

export default class InwiB2C_SWAPONTHV_Display_OrderFromSub extends LightningElement {
        @api recordId; // Record ID passed to the component

    orders = [];
    error;
    wiredResult;

    columns = [
        { label: 'Numéro de commande', fieldName: 'OrderLink', type: 'url', 
          typeAttributes: { label: { fieldName: 'InwiB2C_Num_ro_de_la_commande__c' }, target: '_blank' }},
        { label: 'Statut', fieldName: 'InwiB2C_Statut_Order__c', type: 'text' },
        { label: 'Canal de commande', fieldName: 'InwiB2C_Canal_Order__c', type: 'text' },
        { label: 'Type de commande', fieldName: 'InwiB2C_Type_commande__c', type: 'text' },
        { label: 'Type de migration', fieldName: 'InwiB2C_Type_de_migration__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'Type_Offer', type: 'text' }
    ];

    @wire(getAllOrders, { subscriptionId: '$recordId' })
    wiredOrders(result) {
        this.wiredResult = result;
        if (result.data) {
            this.orders = result.data.map(order => ({
                ...order,
                OrderLink: `/BackOfficeDistributeurD2D/s/order/${order.Id}/view`,
                Type_Offer: order.InwiB2C_Order__r?.InwiB2C_Type_Offer__c || 'N/A'
            }));
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.orders = [];
        }
    }

    refreshData() {
        refreshApex(this.wiredResult);
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortData(fieldName, sortDirection);
    }

    sortData(fieldName, sortDirection) {
        const parsedData = [...this.orders];
        const isReverse = sortDirection === 'desc' ? -1 : 1;
        parsedData.sort((a, b) => {
            const aValue = a[fieldName] || '';
            const bValue = b[fieldName] || '';
            return isReverse * ((aValue > bValue) - (bValue > aValue));
        });
        this.orders = parsedData;
    }
}