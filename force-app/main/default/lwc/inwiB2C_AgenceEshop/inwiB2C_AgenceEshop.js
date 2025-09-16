import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import template from './inwiB2C_AgenceEshop.html';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';



export default class inwiB2C_AgenceEshop extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    _ns = getNamespaceDotNotation();


    VilleValeur = [];
    AgenceValues = [];

    connectedCallback() {
            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
            this.fetchPicklistValues('villes', inp)

    }




    fetchPicklistValues(picklist, input) {

        //console.log('start fetchPicklistValues')
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

                if (Object.keys(response.result.options).length == 0) {
                    //console.log('start the empty case')
                    let v = {
                        "label": 'Aucun élément',
                        "value": "null"
                    };
                    rs.push(v);
                }
				else if(Object.keys(response.result.options).length == 1){
						let temp = {}
                        temp['label'] = response.result.options[0];
                        temp['value'] = response.result.options[0];
                        return temp;
				}
                else {
                    rs = response.result.options.map((element) => {
                        let temp = {}
                        //   if (element.value == 'Maroc')
                        temp['label'] = element.value;
                        temp['value'] = element.name;
                        return temp;
                    });
                }
                if (picklist === 'villes') {
                    this.VilleValeur = rs;
                    rs.sort((a, b)=> {
                        var nameA = a.label.toUpperCase(); // ignore upper and lowercase
                        var nameB = b.label.toUpperCase(); // ignore upper and lowercase
                        if (nameA < nameB) return -1;
                        if (nameA > nameB) return 1;
                        return 0;
                    });


                }
                else if (picklist === 'agence') {
                    this.AgenceValues = rs;
                    rs.sort((a, b)=> {
                        var nameA = a.label.toUpperCase(); // ignore upper and lowercase
                        var nameB = b.label.toUpperCase(); // ignore upper and lowercase
                        if (nameA < nameB) return -1;
                        if (nameA > nameB) return 1;
                        return 0;
                    });

                  
                }


            })
            .catch(error => {
                console.log('error : ' + error);
            });

        //console.log('end fetchPicklistValues')

    }

    ChangeVilles(event) {
        //console.log('ChangePays')

        let idSelectedVille = event.detail.value;
        this.omniUpdateDataJson({ "villes": idSelectedVille });

        let labelSelected = this.VilleValeur.find(opt => opt.value === event.detail.value).label;

        let input = '{"MapItems":[{  "FilterOperator__c": "=","InterfaceFieldAPIName__c": "InwiB2C_Address__r.inwiB2C_Ville__c",  "FilterValue__c": "Ville Name","DomainObjectFieldAPIName__c": "Agence", "InterfaceObjectName__c": "Account", "InterfaceObjectLookupOrder__c": 1},{"FilterOperator__c": "=","InterfaceFieldAPIName__c": "inwib2c_Type__c","FilterValue__c": "\'inwib2c_Propre\'","DomainObjectFieldAPIName__c": "Agence","InterfaceObjectName__c": "Account","InterfaceObjectLookupOrder__c": 1},{"DomainObjectCreationOrder__c": 1,"DomainObjectAPIName__c": "JSON","InterfaceFieldAPIName__c": "Agence:Id","DomainObjectFieldAPIName__c": "name"},{"DomainObjectCreationOrder__c": 1,"DomainObjectAPIName__c": "JSON","InterfaceFieldAPIName__c": "Agence:Name","DomainObjectFieldAPIName__c": "value"}],"DRParams": {"Ville Name": "'+idSelectedVille+'"}}'
console.log('input' +input);

        
        this.fetchPicklistValues('agence', input);


    }

    ChangeAgence(event) {

        this.omniUpdateDataJson({ "agence": event.detail.value });

        let labelagence = this.AgenceValues.find(opt => opt.value === event.detail.value).label;
    }






    render() {
        return template;
    }
}