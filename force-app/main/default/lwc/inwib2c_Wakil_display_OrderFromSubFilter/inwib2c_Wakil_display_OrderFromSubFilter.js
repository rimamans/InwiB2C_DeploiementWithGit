import { LightningElement, wire, api } from 'lwc';
import { refreshApex } from '@salesforce/apex'; import getAllOrders from '@salesforce/apex/inwib2c_Wakil_OrderSubController.getAllOrders';
export default class inwib2c_Wakil_display_OrderFromSubFilter extends LightningElement {
    // Public property
    @api recordId;
    // Private properties
    orders = [];
    error;
    wiredResult;
    columns = [
        { label: 'Numéro de commande', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'InwiB2C_Num_ro_de_la_commande__c' }, target: '_blank' }},
        { label: 'Statut', fieldName: 'InwiB2C_Statut_Order__c', type: 'text' },
        { label: 'Canal de commande', fieldName: 'InwiB2C_Canal_Order__c', type: 'text' },
        { label: 'Type de commande', fieldName: 'InwiB2C_Type_commande__c', type: 'text' },
       // { label: 'Type d\'acte de gestion', fieldName: 'InwiB2C_Type_acte_de_gestion__c', type: 'text' },
        { label: 'Type de migration', fieldName: 'InwiB2C_Type_de_migration__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'Type_Offer', type: 'text' }
    ];
    // Wire service to get data from Apex class
    @wire(getAllOrders, { subscriptionId: '$recordId' })
    wiredOrders(result) {
        this.wiredResult = result;
        if (result.data) {
            this.orders = result.data.map(order => ({
                ...order,
                OrderLink: `/BackOfficeDistributeurD2D/s/order/${order.InwiB2C_Order__c}/view`, // Construct URL for Order
                Type_Offer: order.inwiB2C_Order__r?.InwiB2C_Type_Offer__c // Nested field mapping
            }));
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.orders = [];
        }
    }
    // Refresh data method
    refreshData() {
        refreshApex(this.wiredResult);
    }
    // Handle sorting if needed
    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortData(fieldName, sortDirection);
    }
    sortData(fieldName, sortDirection) {
        const parsedData = [...this.orders];
        const isReverse = sortDirection === 'desc' ? -1 : 1;
        parsedData.sort((a, b) => {
            const aValue = a[fieldName] ? a[fieldName] : '';
            const bValue = b[fieldName] ? b[fieldName] : '';
            return isReverse * ((aValue > bValue) - (bValue > aValue));
        });
        this.orders = parsedData;
    }
}