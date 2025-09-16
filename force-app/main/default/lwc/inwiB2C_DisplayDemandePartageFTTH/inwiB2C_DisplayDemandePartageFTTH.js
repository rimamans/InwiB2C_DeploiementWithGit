import { LightningElement, api } from "lwc";
import getOrderDPs from "@salesforce/apex/inwiB2C_DisplayDemandePartageFTTH.getOrderDPs";
/*K-KA 14-05-2025 B-28661 début*/
// Définition des colonnes du tableau Lightning 
const columns = [
    {
        label: "Demande Partage Name",
        fieldName: "nameLink",
        type: "url",
        typeAttributes: {
            label: {
                fieldName: "Name"
            },
            target: "_self"
        }
    },
    {label: "Order Number", fieldName: "orderName"},
    { label: "Numero Partage", fieldName: "InwiB2C_Numero_Partage__c" },
    { label: "Statut de la demande", fieldName: "InwiB2C_Statut_demande__c" }
];
// Liste des valeurs possibles pour les statuts des demandes de partage

const statusValues = [
    { value: "Acceptée", apiName: "ACC" },
    { value: "Pré-Annulée", apiName: "ANN" },
    { value: "Rejet définitif", apiName: "DEF" },
    { value: "Nouvelle", apiName: "NOU" },
    { value: "Rejeté Guichet", apiName: "REG" },
    { value: "Rejetée", apiName: "REJ" },
    { value: "Résiliée", apiName: "RES" },
    { value: "Mise en service", apiName: "MES" },
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

export default class InwiB2C_DisplayDemandeRecyclage extends LightningElement {
    @api recordId;
    @api objectApiName;

    columns = columns;
    data = [];
   // Cette méthode retourne la fonction Apex appropriée pour récupérer les données
    getRetreiveFunction() {
       if (this.objectApiName == "Order") {
            return getOrderDPs;
        } else {
            return null;
        }
    }

    async connectedCallback() {
        try {
            const retreiveFunct = this.getRetreiveFunction();
            if (retreiveFunct) {
                // Appel de la fonction Apex pour récupérer les données de demande de partage
                const data = await retreiveFunct({ Id: this.recordId });
                this.data = data.map((dp) => ({
                    ...dp,
                    name: `/lightning/r/${dp.Id}/view`,
                    orderName: dp.InwiB2C_Order__r
                        ? dp.InwiB2C_Order__r.OrderNumber
                        : "No Client",
                    nameLink: dp.Id
                        ? `/lightning/r/Event/${dp.Id}/view`
                        : "",
                    OrderNumber: dp.InwiB2C_Order__r?.OrderNumber || '',
                    StatutRecyclage: this.getPickListValue(dp.InwiB2C_Statut_demande__c)
                }));
                console.log("Adjusted Data:", this.data);
                console.log("Object Name:", this.objectApiName);
            }
        } catch (error) {
            console.log(error);
        }
    }
//Méthode pour récupérer la valeur d'affichage associée à un statut
    getPickListValue(apiName) {
        const status = statusValues.find((item) => item.apiName === apiName);
        return status ? status.value : "";
    }
}
/*K-KA 14-05-2025 End*/