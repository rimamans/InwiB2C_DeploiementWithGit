/** 
 * Sujet: MGEN3727B Besoin Identification MDM_TRE_Data_Reporting_V1.0
 * author : khaoula kanboua
 * last modify by : Khaoula kanboua  17/06/2025
 
*/
import { LightningElement, track } from 'lwc';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_TraitementRejetIdentificationMRE extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    //Les coulums de la table
    @track columns = [
    {
        label: 'Référence Business',
        type: 'button',
        typeAttributes: {
            label: { fieldName: 'InwiB2C_BusinessReference__c' },
            name: 'businessReferenceClick',
            variant: 'base'
        }
    },
    { label: 'Date de création', fieldName: 'CreatedDate', type: 'date' },
    { label: 'MDN', fieldName: 'InwiB2C_Mdn__c'},
    { label: 'Statut', fieldName: 'InwiB2C_Statut__c'}
];


    @track data = [];
    @track displayData = [];
    @track page = 1;
    @track pageSize = 5;
    @track totalRecordCount = 0;
    @track totalPage = 0;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track error;
    connectedCallback() {
        this.loadMdnKoHandlerData();
    }
    // Fait appel à la calsse apex pour récupérer la liste des enregistrements et initialise la pagination
    loadMdnKoHandlerData() {
        this._actionUtil = new OmniscriptActionCommonUtil();
        const params = {
            input: '{}',
            sClassName: 'InwiB2C_TraitementRejetIdentificationMRE',
            sMethodName: 'getMdnKoHandler',
            options: '{}'
        };

        this._actionUtil
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response?.result?.result && Array.isArray(response.result.result)) {
                    this.data = response.result.result.map(row => ({
                        ...row,
                    }));
                    this.totalRecordCount = this.data.length;
                    this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
                    this.displayRecordPerPage(this.page);
                } else {
                    this.error = 'Aucune donnée reçue.';
                }
            })
            .catch(error => {
                this.error = 'Erreur lors de la récupération : ' + JSON.stringify(error);
                console.error(error);
            });
    }
    // Affiche les enregistrements de la page courante en fonction du numéro de page
    displayRecordPerPage(page) {
        this.startingRecord = (page - 1) * this.pageSize;
        this.endingRecord = Math.min(page * this.pageSize, this.totalRecordCount);
        this.displayData = this.data.slice(this.startingRecord, this.endingRecord);
        this.startingRecord += 1;
    }

    nextHandler() {
        if (this.page < this.totalPage) {
            this.page += 1;
            this.displayRecordPerPage(this.page);
        }
    }

    prevHandler() {
        if (this.page > 1) {
            this.page -= 1;
            this.displayRecordPerPage(this.page);
        }
    }

    // Gère le clic sur l'url de bussinece reference sélectionner
    handleClick(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;

    let action = '';

     if (actionName === 'businessReferenceClick') {
        action = 'businessReference';
    }

    console.log("action: " + action);

    this.omniUpdateDataJson({
        action: action,
        selectedRow: row 
    });
    this.omniUpdateDataJson({ 'selectedRequest':row.InwiB2C_BusinessReference__c });
    this.omniNextStep();

}
 
}