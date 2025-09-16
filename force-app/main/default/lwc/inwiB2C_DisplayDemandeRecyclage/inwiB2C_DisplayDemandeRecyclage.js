import { LightningElement, api } from "lwc";
import getOrderDRs from "@salesforce/apex/InwiB2C_DisplayDemandeRecyclage.getOrderDRs";
/*K-KA 14-02-2025 début*/
// Définition des colonnes du tableau Lightning 
const columns = [
    {
        label: "Name Demande Recyclage",
        fieldName: "nameLink",
        type: "url",
        typeAttributes: {
            label: {
                fieldName: "Name"
            },
            target: "_self"
        }
    },
    { label: "Work order", fieldName: "InwiB2C_work_order_Id__c" },
    { label: "Work order task", fieldName: "InwiB2C_Workordertask_Id__c" },
    {
        label: "Client",
        fieldName: "clientLink",
        type: "url",
        typeAttributes: {
            label: {
                fieldName: "clientName"
            },
            target: "_self"
        }
    },
    {
        label: "Rendez-vous",
        fieldName: "rendezvousLink",
        type: "url",
        typeAttributes: {
            label: {
                fieldName: "InwiB2C_Id_Rendez_vous__c"
            },
            target: "_self"
        }
    },
    { label: "Statut de la demande", fieldName: "InwiB2C_Statut__c" },
    { label: "Statut d'échec'", fieldName: "InwiB2C_Motif_d_chec_de_raccordement__c" },
    { label: "Compteur de repéchage", fieldName: "InwiB2C_Compteur_de_rep_chage__c" },
    { label: "Numéro de la ligne", fieldName: "InwiB2C_ND__c" },
    { label: "Date début planifiée", fieldName: "InwiB2C_Date_debut_planifiee__c" }
];
// Liste des valeurs possibles pour les statuts des demandes de recyclage

const statusValues = [
    { value: "A recycler", apiName: "A recycler" },
    { value: "recyclée", apiName: "recyclée" },
    { value: "annulée", apiName: "annulée" }
];

export default class InwiB2C_DisplayDemandeRecyclage extends LightningElement {
    @api recordId;
    @api objectApiName;

    columns = columns;
    data = [];
   // Cette méthode retourne la fonction Apex appropriée pour récupérer les données
    getRetreiveFunction() {
       if (this.objectApiName == "Order") {
            return getOrderDRs;
        } else {
            return null;
        }
    }

    async connectedCallback() {
        try {
            const retreiveFunct = this.getRetreiveFunction();
            if (retreiveFunct) {
                // Appel de la fonction Apex pour récupérer les données de demande de recyclage
                const data = await retreiveFunct({ Id: this.recordId });
                this.data = data.map((dr) => ({
                    ...dr,
                    name: `/lightning/r/${dr.Id}/view`,
                    clientLink: dr.InwiB2C_client__c
                        ? `/lightning/r/Account/${dr.InwiB2C_client__c}/view`
                        : "",
                    clientName: dr.InwiB2C_client__r
                        ? dr.InwiB2C_client__r.Name
                        : "No Client",
                    rendezvousLink: dr.InwiB2C_Id_Rendez_vous__c
                        ? `/lightning/r/Event/${dr.InwiB2C_Id_Rendez_vous__c}/view`
                        : "",
                    nameLink: dr.Id
                        ? `/lightning/r/Event/${dr.Id}/view`
                        : "",
                    StatutRecyclage: this.getPickListValue(dr.InwiB2C_Statut__c)
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
/*K-KA 14-02-2025 End*/