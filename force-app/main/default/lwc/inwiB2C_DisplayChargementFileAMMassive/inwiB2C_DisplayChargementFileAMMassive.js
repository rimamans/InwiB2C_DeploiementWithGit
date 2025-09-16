import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_DisplayChargementFileAMMassive extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    __records = [];
    @api
    get records() {
        return this.__records;
    }
    set records(value) {
        this.__records = value;
    }

    lignes = [];
    @track columns = [
        { label: 'Segment Dealer', fieldName: 'Inwib2c_Segment_Dealer_c__c', hideDefaultActions: 'true' },
        { label: 'Distributeur ratttaché au détaillant', fieldName: 'ParentId__c', hideDefaultActions: 'true' },
        { label: 'Type Handler', fieldName: 'inwiB2C_Typehandler__c', hideDefaultActions: 'true' },
        { label: 'Last Name', fieldName: 'LastName__c', hideDefaultActions: 'true' },
        { label: 'First Name', fieldName: 'FirstName__c', hideDefaultActions: 'true' },
        { label: 'CIN', fieldName: 'InwiB2C_CIN__c', hideDefaultActions: 'true' },
        { label: 'Type CIN', fieldName: 'InwiB2C_Type_CIN_c__c', hideDefaultActions: 'true' },
        { label: 'Code Dealer', fieldName: 'InwiB2C_Code_Dealer__c', hideDefaultActions: 'true' },
        { label: 'Partenaire Num Contact 1', fieldName: 'PartenaireNumContact1__c', hideDefaultActions: 'true' },
        { label: 'Partenaire Num Contact 2', fieldName: 'Partenaire_Num_Contact2__c', hideDefaultActions: 'true' },
        { label: 'Adresse Mail', fieldName: 'inwib2c_AdresseMail__c', hideDefaultActions: 'true' },
        { label: 'Region', fieldName: 'InwiB2C_Region__c', hideDefaultActions: 'true' },
        { label: 'Adresse', fieldName: 'InwiB2C_Address__c', hideDefaultActions: 'true' },
        { label: 'Quartier', fieldName: 'InwiB2C_Quartier__c', hideDefaultActions: 'true' },
        { label: 'Ville', fieldName: 'inwiB2C_Ville__c', hideDefaultActions: 'true' },
        { label: 'Flag Rural ou Urbain', fieldName: 'InwiB2C_Flag_Rural_Urbain__c', hideDefaultActions: 'true' },
        { label: 'Canal', fieldName: 'InwiB2C_Canal__c', hideDefaultActions: 'true' },
        { label: 'Longitude', fieldName: 'inwib2c_Geolocalisation_Longitude__c', hideDefaultActions: 'true' },
        { label: 'Latitude', fieldName: 'inwib2c_Geolocalisation_Latitude__c', hideDefaultActions: 'true' },
        { label: 'Vendeur', fieldName: 'InwiB2C_Vendeur__c', hideDefaultActions: 'true' },
        { label: 'Sous-Region(RVR)', fieldName: 'InwiB2C_SousRegion__c', hideDefaultActions: 'true' },
        { label: 'UIID', fieldName: 'InwiB2C_UIID__c', hideDefaultActions: 'true' },
        { label: 'Erreur', fieldName: 'InwiB2C_Erreur__c', hideDefaultActions: 'true', cellAttributes: { class: { fieldName: 'ErrorColor' } } },
        { label: 'Statut', fieldName: 'InwiB2C_Statut__c', hideDefaultActions: 'true', cellAttributes: { class: { fieldName: 'statutColor' } } }
    ];

    @track data; // data displayed on table
    @track startingRecord = 1;
    @track page = 1;
    @track endingRecord = 0;
    @track totalRecordCount = 0;
    @track totalPage = 0;
    @track pageSize = 50;
    @track initialRecords;

    setInfo() {
        this.lignes = this.__records.map(item => {
            // Attribuer des couleurs dynamiques en fonction de l'état
            let statutColor = item.InwiB2C_Statut__c === 'Error' ? 'slds-text-color_error' : 'slds-text-color_success';
            let errorColor = item.InwiB2C_Erreur__c ? 'slds-text-color_error' : 'slds-text-color_default';
            return { 
                ...item,
                statutColor,   // Classe pour le statut
                ErrorColor: errorColor // Classe pour l'erreur
            };
        });

        this.totalRecordCount = this.lignes.length;
        this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
        this.data = this.lignes.slice(0, this.pageSize);
        this.initialRecords = this.data;
        this.endingRecord = this.pageSize;
    }

    connectedCallback() {
        this.setInfo();
    }

    prevHandler(event) {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandler(event) {
        if (this.page < this.totalPage && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }

    displayRecordPerPage(page) {
        this.startingRecord = (page - 1) * this.pageSize;
        this.endingRecord = page * this.pageSize;
        this.endingRecord = (this.endingRecord > this.totalRecordCount) ? this.totalRecordCount : this.endingRecord;
        this.data = this.lignes.slice(this.startingRecord, this.endingRecord);
        this.initialRecords = this.data;
        this.startingRecord = this.startingRecord + 1;
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        if (searchKey) {
            this.data = this.initialRecords;
            if (this.lignes) {
                let searchRecords = [];
                for (let record of this.lignes) {
                    let valuesArray = Object.values(record);
                    for (let val of valuesArray) {
                        let strVal = String(val); 
                        if (strVal && strVal.toLowerCase().includes(searchKey)) {
                            searchRecords.push(record);
                            break;
                        }
                    }
                }
                this.data = searchRecords;
            }
        } else {
            this.data = this.initialRecords;
        }
    }

    render() {
        return template;
    }
}