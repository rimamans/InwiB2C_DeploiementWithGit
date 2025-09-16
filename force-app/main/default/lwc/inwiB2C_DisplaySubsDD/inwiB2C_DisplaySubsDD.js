import { LightningElement, api, wire } from 'lwc';
import getSubscriptionDDs from "@salesforce/apex/InwiB2C_SubscriptionDDs.getSubscriptionDDs";
import getOrderDDs from "@salesforce/apex/InwiB2C_SubscriptionDDs.getOrderDDs";
import getAccountDDs from "@salesforce/apex/InwiB2C_SubscriptionDDs.getAccountDDs";

// variable pour definir les column a afficher sur la table des data
/* B-18616 M-Dj 01/11/24 affichage du champ InwiB2C_ORDER_DEGROUPAGE_NUM__c au lieu du orderNumber */ 
const columns = [
    { label: "Demande Degroupage Name", fieldName: "name", type: "url", typeAttributes: {
            label: {
                fieldName: "Name"
            },
            target: "_blank"
        } 
    },
    { label: "N Order", fieldName:  "InwiB2C_ORDER_DEGROUPAGE_NUM__c"},
    { label: "Numero", fieldName: "InwiB2C_SEQ_NUM__c" },
    { label: "Statut de la demande", fieldName: "Statutdegroupage" }
]
/* B-18616 M-Dj 01/11/24 affichage du champ InwiB2C_ORDER_DEGROUPAGE_NUM__c au lieu du orderNumber */
// variable pour mapper les value et les apiname pour la picklist de statusdegroupage
const statusValues = [
    { value: "Acceptée", apiName: "ACC" },
    { value: "Pré-Annulée", apiName: "ANN" },
    { value: "Rejet définitif", apiName: "DEF" },
    { value: "Nouvelle", apiName: "NOU" },
    { value: "Rejeté Guichet", apiName: "REG" },
    { value: "Rejetée", apiName: "REJ" },
    { value: "Résiliée", apiName: "RES" },
    { value: "Mise en service", apiName: "REU" },
    { value: "En cours", apiName: "SOU" },
    { value: "Suspendue", apiName: "SUS" },
    { value: "A pré-annuler", apiName: "TCA" },
    { value: "Statut Temporaire", apiName: "TEM" },
    { value: "Ligne connectée", apiName: "ACT" },
    { value: "Recyclage automatique", apiName: "RCA" },
    { value: "annulation définitive", apiName: "DAN" },
    { value: "En erreur", apiName: "InwiB2C_EnErreur" },
    { value: "Recyclée", apiName: "InwiB2C_Recyclee" },
    { value: "En cours de résiliation", apiName: "inwiB2C_en_cours_de_resiliation" },
    { value: "Recylée IN", apiName: "InwiB2C_Recyclee_IN" },
    { value: "Echec de mise en service", apiName: "InwiB2C_EchecMES" }
];

export default class InwiB2C_DisplaySubsDD extends LightningElement {

    @api recordId

    @api objectApiName;

    columns = columns
    data = [] 

    getRetreiveFunction() {
        if (this.objectApiName == "vlocity_cmt__Subscription__c") {
            return getSubscriptionDDs
        } else if (this.objectApiName == "Order") {
            return getOrderDDs
        } else if (this.objectApiName == "Account") {
            return getAccountDDs
        } else {
            return null
        }
    }

    retreiveFunct = this.getRetreiveFunction()
    
    /* 
    recuperer les DD de la souscription a partir de la class InwiB2C_SubscriptionDDs et affecter les 
    valeur et les url au column 
    */

    async connectedCallback() {
        try {
            const retreiveFunct = this.getRetreiveFunction()
            if (retreiveFunct) {
                const data  = await retreiveFunct({ Id: this.recordId })
                this.data = data.map(dd => ({
                    ...dd,
                    name: `/lightning/r/${dd.Id}/view`,
                    Statutdegroupage: this.getPickListValue(dd.InwiB2C_Statutdegroupage__c)
                }));
                console.log("Adjusted Data:", this.data);
                console.log("Object Name:", this.objectApiName);
            }
        } catch (error) {
            console.log(error)
        }
    }
   
    // @wire(retreiveFunct, { Id: '$recordId' })
    // wiredRecords({ data,error }) {
    //     if (data) {
    //         console.log('data', data)
    //         this.data = data.map(dd => ({
    //             ...dd,
    //             name: `/lightning/r/${dd.Id}/view`,
    //             Statutdegroupage: this.getPickListValue(dd.InwiB2C_Statutdegroupage__c)
    //         }))
    //         console.log("adjustedData ", data)
    //         console.log("object Name : " + this.objectApiName)
    //     } else {
    //         console.log(error)
    //     }
    // }
    /*
    fonction pour renvoie la value a partir de l'apiname de la picklist statusdegroupage
    */
    getPickListValue(apiName) {
        const status = statusValues.find(item => item.apiName === apiName);
        return status ? status.value : '';
    }
}