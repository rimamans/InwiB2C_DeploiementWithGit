import { LightningElement, wire, track, api } from 'lwc';
import getOrdersForUserQueue from '@salesforce/apex/InwiB2C_ListViewWakil.getOrdersForUserQueue';

export default class InwiB2C_ListViewWakil extends LightningElement {
    @track orders = [];
    @track filteredOrders = [];
    @track error;
    @track selectedStatus = 'All';
    @track partnerCode = '';
    @api recordId; // Ajout de recordId

    // Options pour le filtre de statut
    statusOptions = [
        { label: 'Tous les statuts', value: 'All' },
        { label: 'En cours', value: 'EnCours' },
        { label: 'Paiement', value: 'Paiement' },
        { label: 'Activation', value: 'Activation' },
        { label: 'Active', value: 'Activee' }
    ];

    // Colonnes pour le tableau
    columns = [
        { label: 'Commande', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'OrderNumber' }, target: '_blank' }},
        { label: 'Statut', fieldName: 'inwiB2C_Statut__c', type: 'text' },
        { label: 'Client', fieldName: 'AccountLink', type: 'url', typeAttributes: { label: { fieldName: 'AccountName' }, target: '_blank' }},
        { label: 'Type de commande', fieldName: 'inwib2c_TypeDeLaCommande__c', type: 'text' },
        { label: 'Date de création', fieldName: 'CreatedDate', type: 'date', sortable: true },
        { label: 'Offre', fieldName: 'InwiB2C_Offre__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'InwiB2C_Type_Offer__c', type: 'text' },
        { label: 'Code partenaire', fieldName: 'PartnerCode', type: 'text' },
       // { label: 'POS Code', fieldName: 'POSCODE', type: 'text' },
        //{ label: 'Animateur D2D', fieldName: 'Animateur', type: 'text' }
    ];

    
    

    // Charger les commandes depuis Apex
    @wire(getOrdersForUserQueue)
    wiredOrders({ error, data }) {
        if (data) {
            this.orders = data.map(order => ({
                ...order,
                OrderLink: `/Wakil/s/order/${order.Id}/view`,
                AccountLink: `/Wakil/s/account/${order.AccountId}/view`,
                inwiB2C_Statut__c: order.inwiB2C_Statut__c ?.replace('inwiB2C_', '') || '',
                inwib2c_TypeDeLaCommande__c: order.inwib2c_TypeDeLaCommande__c?.replace('inwiB2C_', '') || '',
                AccountName: order.Account?.Name || '',
                PartnerCode: order.inwib2c_Partenaire__r?.inwib2c_CodePartenaire__c || '',
                Animateur: order.inwiB2C_Animateur_D2D__r?.Name || ''

            }));
            this.filteredOrders = [...this.orders];
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.orders = [];
            this.filteredOrders = [];
        }
    }

    // Appliquer les filtres
    applyFilters() {
        let filtered = [...this.orders];

        if (this.selectedStatus !== 'All') {
            filtered = filtered.filter(order => order.inwiB2C_Statut__c === this.selectedStatus);
        }

        if (this.partnerCode) {
            filtered = filtered.filter(order => order.PartnerCode.includes(this.partnerCode));
        }

        this.filteredOrders = filtered;
    }

    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
        this.applyFilters();
    }

    handlePartnerCodeChange(event) {
        this.partnerCode = event.target.value;
        this.applyFilters();
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
    
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
    
        const sortedData = [...this.filteredOrders];
        sortedData.sort((a, b) => {
            let valueA = a[fieldName] || '';
            let valueB = b[fieldName] || '';
    
            if (fieldName === 'CreatedDate') {
                valueA = new Date(valueA);
                valueB = new Date(valueB);
            }
    
            return sortDirection === 'asc'
                ? valueA > valueB ? 1 : -1
                : valueA < valueB ? 1 : -1;
        });
    
        this.filteredOrders = sortedData;
    }
    
    
    
}