import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getOrderList from '@salesforce/apex/inwiB2C_Wakil_OrderController.getOrderList';

export default class inwiB2C_Wakil_Display_OrderFromAccFilter extends LightningElement {
    @api recordId; // ID du compte en cours
    // Propriétés internes
    orders = [];
    error;
    wiredResult;
    sortedBy;
    sortedDirection;
    // Colonnes du tableau
    columns = [
        { label: 'Numéro de commande', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'OrderNumber' }, target: '_blank' } },
        { label: 'Statut', fieldName: 'Status', type: 'text' },
        { label: 'Offre', fieldName: 'InwiB2C_Offre__c', type: 'text' },
        { label: 'Type d\'offre', fieldName: 'InwiB2C_Type_Offer__c', type: 'text' },
        { label: 'Type de commande', fieldName: 'typeDeCommande', type: 'text' }, // Changement ici
        { label: 'Type de migration', fieldName: 'typeDeMigration', type: 'text' }, // Changement ici
        { label: 'Créé par', fieldName: 'CreatedByName', type: 'text' },
        { label: 'Date d\'effet', fieldName: 'EffectiveDate', type: 'date' }
    ];
    
    // Appel Apex pour récupérer les ordres
    @wire(getOrderList, { accountId: '$recordId' })
    wiredOrders(result) {
        this.wiredResult = result;
        if (result.data) {
            this.orders = result.data.map(order => ({
                ...order,
                OrderLink: `/BackOfficeDistributeurD2D/s/order/${order.Id}/view`, // Lien URL vers l'ordre
                CreatedByName: order.CreatedBy?.Name, // Champ relationnel
                typeDeCommande: order.inwib2c_TypeDeLaCommande__c === 'inwiB2C_Migration' ? 'Migration' : order.inwib2c_TypeDeLaCommande__c, // Logique pour le type de commande
                typeDeMigration: order.inwiB2C_TypeDeMigration__c === 'InwiB2C_MigrationPrePostpayé' ? 'Migration Prépayé Postpayé' : order.inwiB2C_TypeDeMigration__c // Logique pour le type de migration
            }));
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.orders = [];
        }
    }
    
    // Méthode pour rafraîchir les données
    refreshData() {
        refreshApex(this.wiredResult);
    }
    
    // Méthode pour trier les colonnes
    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        this.sortData(fieldName, sortDirection);
    }
    
    // Fonction pour trier les données localement
    sortData(fieldName, sortDirection) {
        const isReverse = sortDirection === 'desc' ? -1 : 1;
        this.orders = [...this.orders].sort((a, b) => {
            const aValue = a[fieldName] || '';
            const bValue = b[fieldName] || '';
            return isReverse * ((aValue > bValue) - (bValue > aValue));
        });
    }
}