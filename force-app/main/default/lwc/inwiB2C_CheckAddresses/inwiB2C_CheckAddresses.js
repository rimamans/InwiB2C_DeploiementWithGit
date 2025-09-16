import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_CheckAddresses extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    _ns = getNamespaceDotNotation();

    @api p;
    @api r;
    @api v;
    @api q;
    @api pq;
    @api address2;
    @api cc;
    @api vv;  // Added @api property for Ville2

    isLoading = true;
    loadingMsg = 'picklists are loading...';

    PaysValues = [];
    RegionValues = [];
    VilleValues = [];
    QuartierValues = [];

    isToSpecify = false;

    connectedCallback() {
        console.log('this.p: ' + this.p);
        console.log('this.r: ' + this.r);
        console.log('this.v: ' + this.v);
        console.log('this.q: ' + this.q);
        console.log('this.pq: ' + this.pq);
        console.log('this.cc: ' + this.cc); // Log countryCode value
        console.log('this.vv: ' + this.vv); // Log Ville2 value

        if (this.PaysValues.length === 0) {
            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
            this.fetchPicklistValues('pays', inp);
        }
        if (this.VilleValues.length === 0) {
            let inpputVille = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}';
            this.fetchPicklistValues('ville', inpputVille);
        }
        if (this.v != null) {
            this.omniUpdateDataJson({ "Quartier": this.q });
            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + this.v + '"}}';
            this.fetchPicklistValues('quartier', inp);
        }
        if (this.p != null) {
            this.omniUpdateDataJson({ "Pays": this.valuePays });
        }
        if (this.v != null) {
            this.setRegionInfo(this.v);
            this.omniUpdateDataJson({ "Ville": this.v });
        }
        if (this.cc != null) {
            this.omniUpdateDataJson({ "countryCode": this.cc });
        }
        if (this.vv != null) {
            this.omniUpdateDataJson({ "Ville2": this.vv });
        }
    }

    IdMaroc;
    fetchPicklistValues(picklist, input) {
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        const params = {
            input: input,
            sClassName: 'vlocity_cmt.DefaultFetchPicklistOptionsImpl',
            sMethodName: 'fetchLookupOptions',
            options: '{}',
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                let rs = [];
                if (Object.keys(response.result.options).length === 0) {
                    let v = {
                        "label": 'Aucun élément',
                        "value": "null"
                    };
                    rs.push(v);
                } else {
                    rs = response.result.options.map((element) => {
                        let temp = {};
                        temp['label'] = element.value;
                        temp['value'] = element.name;
                        return temp;
                    });
                }
                if (picklist === 'pays') {
                    this.PaysValues = rs;
                    let indexMaroc = this.PaysValues.findIndex(x => x.label === "Maroc");
                    this.omniUpdateDataJson({ "IdMaroc": this.PaysValues[indexMaroc].value });
                    if (!this.p) {
                        this.omniUpdateDataJson({ "Pays": this.PaysValues[indexMaroc].value });
                        this.omniUpdateDataJson({ "PaysName": 'Maroc' });
                    }
                    if (this.valuePays == null)
                        this.valuePays = this.PaysValues[indexMaroc].value;
                    this.IdMaroc = this.PaysValues[indexMaroc].value;
                    this.PaysValues.splice(0, 0, this.PaysValues.splice(indexMaroc, 1)[0]);
                } else if (picklist === 'region') this.RegionValues = rs;
                else if (picklist === 'ville') {
                    this.VilleValues = rs;
                    let t = rs.sort(function (a, b) {
                        var nameA = a.label.toUpperCase();
                        var nameB = b.label.toUpperCase();
                        if (nameA < nameB) {
                            return -1;
                        }
                        if (nameA > nameB) {
                            return 1;
                        }
                        return 0;
                    });
                } else if (picklist === 'quartier') {
                    this.QuartierValues = rs;
                    if (this.QuartierValues[0].value == 'null') {
                        this.isToSpecify = true;
                        this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'Aucun élément à selectionner ';
                    }
                    if (this.QuartierValues.length != 1) {
                        this.isToSpecify = false;
                        this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez un quartier ';
                    }
                }
            })
            .catch(error => {
                console.log('error : ' + error);
            });
    }

    ChangePrecisionQuartier(event) {
        this.omniUpdateDataJson({ "PrecisionQuartier": event.detail.value });
    }

    ChangePays(event) {
        this.omniUpdateDataJson({ "Pays": event.detail.value });
        let labelSelected = this.PaysValues.find(opt => opt.value === event.detail.value).label;
        this.omniUpdateDataJson({ "PaysName": labelSelected });
        if (labelSelected === 'Maroc') {
            this.template.querySelector(`[data-theid="Region"]`).style.display = "block";
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "block";
            this.template.querySelector(`[data-theid="countryCode"]`).style.display = "block"; // Display countryCode field
            this.template.querySelector(`[data-theid="Address2"]`).style.display = "block"; // Display Address2 field
            if (this.template.querySelector(`[data-theid="Quartier"]`) != null)
                this.template.querySelector(`[data-theid="Quartier"]`).style.display = "block";
            if (this.template.querySelector(`[data-theid="PrecisionQuartier"]`) != null)
                this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "block";
        } else {
            this.omniUpdateDataJson({ "Region": "null" });
            this.omniUpdateDataJson({ "Ville": "null" });
            this.omniUpdateDataJson({ "Quartier": "null" });
            this.omniUpdateDataJson({ "PrecisionQuartier": "" });
            this.omniUpdateDataJson({ "RegionName": "null" });
            this.omniUpdateDataJson({ "CityName": "null" });
            this.omniUpdateDataJson({ "countryCode": "null" });
            this.omniUpdateDataJson({ "Ville2": "null" });
            this.QuartierValues = [];
            this.template.querySelector(`[data-theid="Region"]`).value = 'sélectionnez une ville';
            this.template.querySelector(`[data-theid="Ville"]`).value = '';
            this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';
            this.template.querySelector(`[data-theid="Region"]`).style.display = "none";
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "none";
            this.template.querySelector(`[data-theid="countryCode"]`).style.display = "none"; // Hide countryCode field
            this.template.querySelector(`[data-theid="Address2"]`).style.display = "none"; // Hide Address2 field
            if (this.template.querySelector(`[data-theid="Quartier"]`) != null)
                this.template.querySelector(`[data-theid="Quartier"]`).style.display = "none";
            if (this.template.querySelector(`[data-theid="PrecisionQuartier"]`) != null)
                this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "none";
        }
    }

    ChangeRegion(event) {
        this.omniUpdateDataJson({ "Region": event.detail.value });
        this.setRegionInfo(event.detail.value);
    }

    setRegionInfo(regionValue) {
        // Implementation for setting region info
    }

    ChangeVille(event) {
        this.omniUpdateDataJson({ "Ville": event.detail.value });
        let labelSelected = this.VilleValues.find(opt => opt.value === event.detail.value).label;
        this.omniUpdateDataJson({ "CityName": labelSelected });
    }

    ChangeQuartier(event) {
        this.omniUpdateDataJson({ "Quartier": event.detail.value });
        let labelSelected = this.QuartierValues.find(opt => opt.value === event.detail.value).label;
        this.omniUpdateDataJson({ "QuartierName": labelSelected });
    }
    
    handleAddress2Change(event) {
        this.omniUpdateDataJson({ "Address2": event.detail.value });
    }
}