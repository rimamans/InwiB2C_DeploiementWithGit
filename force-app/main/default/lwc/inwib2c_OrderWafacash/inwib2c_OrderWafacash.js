import { LightningElement, api, track } from 'lwc';

import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class Inwib2c_OrderWafacash extends LightningElement {
    @api recordId;
    @track orders = [];
    @track error;

   // _ns = getNamespaceDotNotation();
  _actionUtilClass;

    // Définition colonnes du tableau
    columns = [
        { label: 'N° Commande', fieldName: 'OrderLink', type: 'url', typeAttributes: { label: { fieldName: 'OrderNumber' }, target: '_blank' } },
        { label: 'Statut', fieldName: 'Statut', type: 'text' },
        { label: 'Offre', fieldName: 'offre', type: 'text' },
        { label: 'Type Commande', fieldName: 'TypeCommande', type: 'text' },
        { label: 'Type Migration', fieldName: 'TypeMigration', type: 'text' },
        { label: 'Type Acte de gestion', fieldName: 'TypeActeDeGestion', type: 'text' },
        { label: 'Date de création', fieldName: 'StartDate', type: 'date' }
       
    ];

    connectedCallback() {
         this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.loadOrders();
    }

        cleanTypeField(value) {
        if (!value) return value;
        
        // Supprimer les différents préfixes possibles
        const prefixes = ['INWIB2C_', 'inwiB2C_', 'inwiB2c_', 'InwiB2C_'];
        
        for (let prefix of prefixes) {
            if (value.startsWith(prefix)) {
                return value.substring(prefix.length);
            }
        }
        
        return value;
    }

    async loadOrders() {
        let inputParams = { accountid: this.recordId };

        const params = {
            input: JSON.stringify(inputParams),
            sClassName: `IntegrationProcedureService`,
            sMethodName: 'inwib2c_getorderWafacash',
            options: '{}'
        };

        console.log('Appel IP avec params ===>', JSON.stringify(params));

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('Réponse IP ===>', JSON.stringify(response, null, 2));

               
        
            //this.orders = response.result.IPResult.list;
            //console.log("result order", this.orders)

            console.log("response", response.result.IPResult.list)

            if (response.result.IPResult.list) {
            this.orders = response.result.IPResult.list.map(order => ({
                ...order,
                OrderLink: `/Wafacash/s/order/${order.id}/view`, 
                CreatedByName: order.createdBy, 
                TypeCommande: this.cleanTypeField(order.TypeComm),
                TypeMigration: this.cleanTypeField(order.TypeMig),
                TypeActeDeGestion : this.cleanTypeField(order.TypeActe),
                Statut : this.cleanTypeField(order.Statut)
            }));
            this.error = undefined;
        } else {
            this.error = response.error;
            this.orders = [];
        }
        
    })
    .catch(error => {
        console.error('Erreur appel IP ===>', error);
                this.error = error;
                this.orders = [];
    });
            
    }
}