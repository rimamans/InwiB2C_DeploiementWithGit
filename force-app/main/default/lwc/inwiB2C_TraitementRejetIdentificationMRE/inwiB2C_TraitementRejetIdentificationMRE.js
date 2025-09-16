import { LightningElement,api } from 'lwc';
import getMdnKoHandler from "@salesforce/apex/InwiB2C_TraitementRejetIdentificationMRE.getMdnKoHandler";



// Définition des colonnes du tableau Lightning 
const columns = [
    {
        label: "Business Reference",
        fieldName: "nameLink",
        type: "url",
        typeAttributes: {
            label: {
                fieldName: "InwiB2C_BusinessReference__c"
            },
            target: "_self"
        }
    },
    {label: "Date de Création", fieldName: "CreatedDate"},
    { label: "MDN", fieldName: "InwiB2C_Mdn__c" },
    { label: "Statut de traitement", fieldName: "InwiB2C_Statut__c" }
];
const statusValues = [
    { value: "Nouvelle", apiName: "Nouvelle" }
]

export default class InwiB2C_TraitementRejetIdentificationMRE extends LightningElement {
        @api recordId;
        @api objectApiName;
    
        columns = columns;
        data = [];
       // Cette méthode retourne la fonction Apex appropriée pour récupérer les données
        getRetreiveFunction() {
           if (this.objectApiName == "InwiB2C_MDN_KOHandler__c") {
                return getMdnKoHandler;
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
                this.data = data.map((mdn) => ({
                    ...mdn,
                    nameLink: mdn.Id
                        ? `/lightning/r/Event/${mdn.Id}/view`
                        : "",
                    StatutTraitement: this.getPickListValue(mdn.InwiB2C_Statut__c)
                }));
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