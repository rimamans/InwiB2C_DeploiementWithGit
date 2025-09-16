import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import template from './inwib2cAddressManagement.html';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';



export default class Inwib2cAddressManagement extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    _ns = getNamespaceDotNotation();

    @api p;
    @api r;

    @api v;
    @api q;


    isLoading = true;
    loadingMsg = 'picklists are loading...';

    PaysValues = [];
    RegionValues = [];
    VilleValues = [];
    QuartierValues = [];

    isToSpecify=false;
    connectedCallback() {


        
        console.log('this.p: '+ this.p)
        console.log('this.r: '+ this.r)
        console.log('this.v: '+ this.v)
        console.log('this.q: '+ this.q)
        /*
                if (this.r != null) {
                    console.log('re call r')
                    let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Regions","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Country Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"Pays__c","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Country Name":"' + this.p + '"}}';
                    this.fetchPicklistValues('region', inp)
                }
        */


        if (this.PaysValues.length == 0) {

            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'

            this.fetchPicklistValues('pays', inp)
        }
        if (this.VilleValues.length == 0) {
            let inpputVille = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
            this.fetchPicklistValues('ville', inpputVille);
        }


        if (this.v != null) {
                    let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + this.v + '"}}';
            this.omniUpdateDataJson({ "Quartier":this.q });

                    this.fetchPicklistValues('quartier', inp)
         }


         if (this.p != null) this.omniUpdateDataJson({ "Pays": this.valuePays });
         if (this.v != null) {
             
             this.setRegionInfo(this.v)
             this.omniUpdateDataJson({ "Ville": this.v });
             
        
        }
         





    }

    IdMaroc;
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
                // //console.log('response.result.options')
                // //console.log(response.result.options)
                let rs = [];
                //  //console.log('Object.keys(empty).length : '+Object.keys(response.result.options).length )

                //  //console.log('response.result.options')
                // //console.log(response.result.options)

                if (Object.keys(response.result.options).length == 0) {
                    //console.log('start the empty case')
                    let v = {
                        "label": 'Aucun élément',
                        "value": "null"
                    };
                    //console.log('v : ')
                    //console.log(v)

                    rs.push(v);
                    //console.log('end the empty case')

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

                if (picklist === 'pays') {
                    this.PaysValues = rs;
                    let indexMaroc = this.PaysValues.findIndex(x => x.label === "Maroc");

                    //console.log('indexMaroc: ' + indexMaroc)
                    //console.log('this.PaysValues[indexMaroc]: ' + this.PaysValues[indexMaroc].value)
                    this.omniUpdateDataJson({ "IdMaroc": this.PaysValues[indexMaroc].value });
                    if(!this.p) this.omniUpdateDataJson({ "Pays": this.PaysValues[indexMaroc].value });
                    if (this.valuePays == null)
                        this.valuePays = this.PaysValues[indexMaroc].value;
                    this.IdMaroc = this.PaysValues[indexMaroc].value;

                    this.PaysValues.splice(0, 0, this.PaysValues.splice(indexMaroc, 1)[0]);


                }
                else if (picklist === 'region') this.RegionValues = rs;
                else if (picklist === 'ville') this.VilleValues = rs;
                else if (picklist === 'quartier') {
                    this.QuartierValues = rs;
                    console.log('this.QuartierValues[0].value : '+ this.QuartierValues[0].value)
                    if(this.QuartierValues[0].value =='null'){
                        this.isToSpecify = true;
                        this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'Aucun élément à selectionner ';
                    }
                    if(this.QuartierValues.length !=1 ){
                        this.isToSpecify = false;
                        this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez un quartier ';
                    }

                }

            })
            .catch(error => {
                console.log('error : ' + error);
            });

        //console.log('end fetchPicklistValues')

    }

    ChangePrecisionQuartier(event) {
        this.omniUpdateDataJson({ "PrecisionQuartier": event.detail.value });
    }

    ChangePays(event) {
        //console.log('ChangePays')

        this.omniUpdateDataJson({ "Pays": event.detail.value });

        let labelSelected = this.PaysValues.find(opt => opt.value === event.detail.value).label;



        console.log('labelSelected: ' + labelSelected)

        if (labelSelected == 'Maroc') {
            this.template.querySelector(`[data-theid="Region"]`).style.display = "block"
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "block"
            this.template.querySelector(`[data-theid="Quartier"]`).style.display = "block"

        } else {
            this.omniUpdateDataJson({ "Region": "null" });
            this.omniUpdateDataJson({ "Ville": "null" });
            this.omniUpdateDataJson({ "Quartier": "null" });
            this.omniUpdateDataJson({ "PrecisionQuartier": "null" });

            // this.RegionValues = [];
            //  this.VilleValues = [];
            this.QuartierValues = [];

            this.template.querySelector(`[data-theid="Region"]`).value = 'sélectionnez une ville';
            this.template.querySelector(`[data-theid="Ville"]`).value = '';
            this.template.querySelector(`[data-theid="Quartier"]`).value = null;

            //   this.template.querySelector(`[data-theid="Region"]`).placeholder = 'sélectionnez un pays';
            this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';
            this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';



            this.template.querySelector(`[data-theid="Region"]`).style.display = "none"
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "none"
            this.template.querySelector(`[data-theid="Quartier"]`).style.display = "none"


        }

        //console.log('start changing region values')
        /*
                let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Regions","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Country Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"Pays__c","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Regions:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Country Name":"' + event.detail.value + '"}}';
        
                this.fetchPicklistValues('region', inp)
        */
        //console.log('end changing region values')

    }


    ChangeRegion(event) {
        //console.log('ChangeRegion')

        this.omniUpdateDataJson({ "Region": event.detail.value });
        this.omniUpdateDataJson({ "Ville": "null" });
        this.omniUpdateDataJson({ "Quartier": "null" });

        this.VilleValues = [];
        this.QuartierValues = [];
        this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';
        this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';

        //console.log('start changing Villes values')

        let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Villes","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Region Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"InwiB2C_Region__c","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Region Name":"' + event.detail.value + '"}}';

        this.fetchPicklistValues('ville', inp)

        //console.log('end changing Villes values')

    }




    setRegionInfo(idVille){
        let input = '{"theId": "' + idVille + '"}';
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_getInfoCity',
            options: input
        };
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                // console.log('in response :')
                //   console.log(response)

                //  //console.log(response.result.IPResult)
                if (response.error == false) {
                    //   let CityInfo = response.result.IPResult.theCity;
                    // let regionId = response.result.IPResult.theCity.RegionName;
                    //console.log('regionId: ' + regionId)
                    //  console.log('response.result.IPResult.theCity: ')
                    //  console.log(response.result.IPResult.theCity)

                this.template.querySelector(`[data-theid="Region"]`).value = response.result.IPResult.theCity.RegionName;
                   this.omniUpdateDataJson({ "Region": response.result.IPResult.theCity.RegionId });
                }

            })
            .catch(error => {
                console.log('error: ' + error);
            });
    }

    ChangeVille(event) {
        //console.log('ChangeVille')
        //console.log('start changing Quartier values')

        let selectedvilleId = event.detail.value;
        console.log('selectedvilleId: ' + selectedvilleId)


        this.omniUpdateDataJson({ "Ville": selectedvilleId });
        this.omniUpdateDataJson({ "Quartier": "null" });
        this.omniUpdateDataJson({ "PrecisionQuartier": "null" });

        this.QuartierValues = [];
        //this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';

        this.setRegionInfo(selectedvilleId)


        console.log('selectedvilleId: ' + selectedvilleId)
        let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + selectedvilleId + '"}}';

        this.fetchPicklistValues('quartier', inp)

        //console.log('end changing Quartier values')
    }



    ChangeQuartier(event) {
        //console.log('ChangeQuartier')
        this.omniUpdateDataJson({ "Quartier": event.detail.value });

        //  //console.log('changing region values')
    }

    render() {
        console.log('this.p : ' + this.p)
        return template;
    }
}