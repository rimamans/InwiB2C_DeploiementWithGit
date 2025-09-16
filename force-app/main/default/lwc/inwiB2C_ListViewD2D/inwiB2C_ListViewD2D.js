import { LightningElement, wire, api, track } from 'lwc';
import getOrderList from '@salesforce/apex/InwiB2C_ListViewsD2D.getOrdersForUserQueue';
import getAllOrders from '@salesforce/apex/InwiB2C_ListViewsD2D.getAllOrders';

import { refreshApex } from '@salesforce/apex';

export default class InwiB2C_ListViewD2D extends LightningElement {
    @api recordId;
    @track records = [];
    @track filteredRecords = [];
    @track error;
    @track selectedStatus = 'All';
    @track partnerCode = '';  // Nouvelle variable pour stocker le code partenaire
    @track isChecked=true;// variable pour stocker l'etat du checkbox
    wiredOrdersResult; 
    isLoading=false;
    // Options de la liste déroulante pour les statuts
    statusOptions = [
        { label: 'Tous les statuts', value: 'All' },
        { label: 'En cours', value: 'En cours' },
        { label: 'Paiement', value: 'Paiement' },
        { label: 'Activation', value: 'Activation' },
        { label: 'Active', value: 'Active' },
        { label: 'En attente d\'approbation', value: 'En attente d\'approbation'},	
        { label: 'Recyclée', value: 'Recyclée'}
    
    ];


    // Colonnes du tableau
    columns = [
        { label: 'Commandes', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'OrderNumber' }, target: '_blank' }},
        { label: 'Statut', fieldName: 'inwiB2C_Statut__c', type: 'text' },
        { label: 'Statut de livraison D2D', fieldName: 'InwB2C_Statut_livraison_D2D__c', type: 'text' },
        { label: 'Client', fieldName: 'AccLink', type: 'url', typeAttributes: { label: { fieldName: 'ACC' }, target: '_blank' }},
        { label: 'Type de commande', fieldName: 'Type_commande__c', type: 'text' },
        { label: 'Date de création', fieldName: 'CreatedDate', type: 'date', sortable: true },
        { label: 'Offre', fieldName: 'InwiB2C_Offre__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'InwiB2C_Type_Offer__c', type: 'text' },
        { label: 'POS Code', fieldName: 'POSCODE', type: 'text' },
        { label: 'Animateur D2D', fieldName: 'Animateur', type: 'text' }
    ];

    // Appel à Apex pour obtenir les données
    @wire(getOrderList, { accountId: '$recordId' })
    wiredOrders(result) {
        this.isLoading=true;
        this.wiredOrdersResult = result; // Stocker le résultat du wire pour refreshApex
        const { data, error } = result;

        if (data) {
            this.records = data.map(order => ({
                ...order,
                OrderLink: `/BackOfficeDistributeurD2D/s/order/${order.Id}/view`,
                AccLink: `/BackOfficeDistributeurD2D/s/account/${order.AccountId}/view`,
                ACC: order.Account?.Name || '',
                inwiB2C_Statut__c: order.inwiB2C_Statut__c || 'Unknown',
                Type_commande__c: order.inwib2c_TypeDeLaCommande__c?.replace('inwiB2C_', '') || '',
                Animateur: order.inwiB2C_Animateur_D2D__r?.Name || '',
                POSCODE: order.inwib2c_Partenaire__r?.inwib2c_CodePartenaire__c || ''
            }));
            //this.filteredRecords = this.isChecked ? [...this.records] : [];
            this.updateFilteredRecords(); // Met à jour filteredRecords
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = [];
            this.filteredRecords = [];
            this.isLoading=false;
        }
    }
// methode de checkbox

handleCheckboxChange(event) {
    this.isChecked = event.target.checked;
    this.filteredRecords = [];
    this.records= [];
    this.isLoading=true
    if (this.isChecked) {
        refreshApex(this.wiredOrdersResult).then(() => {
            this.updateFilteredRecords(); // Met à jour les records après le rafraîchissement
        });
    } else {
        this.filteredRecords = [];
        this.records= [];
        getAllOrders({ accountId: this.recordId })
        .then(result => {
            this.records = result.map(order => ({
                ...order,
                OrderLink: `/BackOfficeDistributeurD2D/s/order/${order.Id}/view`,
                AccLink: `/BackOfficeDistributeurD2D/s/account/${order.AccountId}/view`,
                ACC: order.Account?.Name || '',
                inwiB2C_Statut__c: order.inwiB2C_Statut__c || 'Unknown',
                Type_commande__c: order.inwib2c_TypeDeLaCommande__c?.replace('inwiB2C_', '') || '',
                Animateur: order.inwiB2C_Animateur_D2D__r?.Name || '',
                POSCODE: order.inwib2c_Partenaire__r?.inwib2c_CodePartenaire__c || ''
            }));
            this.updateFilteredRecords(); // Met à jour filteredRecords
            //this.isLoading=false;
        })
        .catch(error => {
            this.error = error;
            this.records = [];
            this.filteredRecords = [];
            this.isLoading=false;
        });
    }
}

updateFilteredRecords() {
    // Si la case est cochée, on charge les données dans filteredRecords
    this.filteredRecords =  [...this.records] ;
    this.isLoading=false;
}
    // Méthode pour appliquer les filtres
    applyFilter() {
       
        let filtered = [...this.records];

        // Filtre par statut
        if (this.selectedStatus !== 'All') {
            filtered = filtered.filter(record => record.inwiB2C_Statut__c === this.selectedStatus);
        }

        // Filtre par code partenaire (si un code partenaire est saisi)
        if (this.partnerCode) {
            filtered = filtered.filter(record => record.POSCODE && record.POSCODE.includes(this.partnerCode));
        }

        this.filteredRecords = filtered;
        
    }

    // Méthode pour gérer le changement du filtre de statut
    handleFilterChange(event) {
        this.selectedStatus = event.detail.value;
        this.applyFilter();
    }

    // Méthode pour gérer le changement du filtre de code partenaire
    handlePartnerCodeChange(event) {
        this.partnerCode = event.detail.value;
        this.applyFilter();
    }

    // Méthode pour gérer le tri des colonnes
    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        const cloneData = [...this.filteredRecords];
        cloneData.sort((a, b) => {
            let aValue = a[fieldName] || '';
            let bValue = b[fieldName] || '';

            if (fieldName === 'CreatedDate') {
                aValue = new Date(aValue);
                bValue = new Date(bValue);
            }

            return sortDirection === 'asc'
                ? (aValue > bValue ? 1 : -1)
                : (aValue < bValue ? 1 : -1);
        });

        this.filteredRecords = cloneData;
    }
}