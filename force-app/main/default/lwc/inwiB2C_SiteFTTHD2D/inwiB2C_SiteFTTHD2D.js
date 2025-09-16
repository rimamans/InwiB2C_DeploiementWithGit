import { LightningElement, api, track,wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_SiteFTTHD2D.html";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_SiteFTTHD2D   extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {    
    __data2 = [];
    newsite;
    @api nomsite;
    //@track nomsite; 
    regV;
    cityV;
    codePV;
    quartV;
    stepEligible=true;
    optionadresse = "old_address";
    showother = true;
    variant = 'error';
    showother=true;
    step12=false;
    step=false;
    stepAd=false;
    _ns = getNamespaceDotNotation();
    create=true;
    __showed=true;
    @api title;
    @api villename;
    @api message;
     eligible=false;
    @api p;
    @api r;
    @api q;
    @api pq;
    villeid;
    region;
    @api v;
    PaysValues = [];
    RegionValues = [];
    VilleValues = [];
    QuartierValues = [];
    __dataEligible=[];
    __dataplaque=[];
    dataPlaqueResult=[];//CHB B-10015 ano 21/06/2023 
    __dataSortName=[];
    isToSpecify=false;
    recordid;
    quartier;
    pquartier;
    codepostal;
    complementaddress;
   // list;
   __list;
    labelSelectedRegion;
    labelSelectedVille;
    labelSelectedQuartier;
    @api addressclient;
    checkrequiredfield=true;
    @api idserviceaccount;
    //@api list;

    // Added plaque attribute
    __plaque;
    @api
    get plaque() {
        return this.__plaque;
    }
    set plaque(value) {
        this.__plaque = value;
    }
    
    @api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }
    @api
    get list() {
        return this.__list;
    }
    set list(value) {
        this.__list = value;
       // this.setAttribute("nomsite",this.nomsite);
    }
    @api
    get showed() {
        return this.__showed;
    }
    set showed(value) {
      this.__showed = value;
     // this.setAttribute("nomsite",this.nomsite);
    }
    addressinstallation;
  @api
  get addressinstallation() {
    return this.__addressinstallation;
  }
  set addressinstallation(value) {
    this.__addressinstallation = value;
  }
  __canal;
  @api
  get canal() {
    return this.__canal;
  }
  set canal(value) {
    this.__canal = value;
  }

  get DisplayD2D() {
    return this.canal === "D2D"
  }

    get options() {
        return [
          {
            label: `Adresse Client (${this.addressclient})`,
            value: "old_address",
          },
          { label: "Nouvelle adresse", value: "new_address" },
        ];
      }
      optionadresseShow=null;
      search='';
    connectedCallback() {
      console.log('canal: ' + this.__canal);
      console.log('DisplayD2D: ' + this.DisplayD2D);
      console.log('addressinstallation: ' + this.addressinstallation);
        this.addressInstallation = this.addressinstallation;
        this.fieldVisible = true;
        this.step12=true;
        this.eligible=false;
        this.step=false;
        this.stepAd=false;
        this.create=true;
        this.newsite=true;
        this.checkrequiredfield=true;
        this.nomsite=this.list.nomsite;
        this.region=this.list.region;
        this.r=this.list.RegionName;
        this.villeid=this.list.ville;
        //this.Ville=this.list.ville;
        //this.v=this.list.ville;
        this.v=this.list.ville;
        this.cityV=this.list.VilleName;
        
        //this.setRegionInfo(this.v);
        this.labelSelectedVille=this.list.VilleName;
        this.labelSelectedRegion=this.list.RegionName;
        //this.ChangeVille(this.v);
        this.quartier=this.list.quartier;
        this.q=this.list.quartier;
        this.labelSelectedQuartier=this.list.QuartierName;
        if(this.v!='' && this.v!=null){
          let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +this.v+ '"}}';
          this.fetchPicklistValues('quartier', inp)
          //this.ChangeQuartier(this.q);
          }
        this.complementaddress=this.list.complement;
        this.codepostal=this.list.codepostale;
        this.pq=this.list.precisionquartier;
       console.log('adresse',this.optionadresseShow);
      //  this.optionadresseShow=this.addressclient;
        console.log('accountid'+this.accountid);
        console.log('list'+this.list);
        console.log('showed'+this.showed);
        
        
        if (this.PaysValues.length == 0) {

            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'

            this.fetchPicklistValues('pays', inp)
        }
        if (this.VilleValues.length == 0) {
            let inpputVille = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
            this.fetchPicklistValues('ville', inpputVille);
        }
        if (this.RegionValues.length == 0) {
            let inpputRegion = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
            this.fetchPicklistValues('region', inpputRegion);
        }
        if (this.v != null) {
           // this.omniUpdateDataJson({ "Quartier":this.q });
            
            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + this.v + '"}}';
            this.fetchPicklistValues('quartier', inp)
            

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
                   // this.omniUpdateDataJson({ "IdMaroc": this.PaysValues[indexMaroc].value });
                    if(!this.p) {
                      this.omniUpdateDataJson({ "Pays": this.PaysValues[indexMaroc].value });
                     
                   //     this.omniUpdateDataJson({ "PaysName":'Maroc' });
                    }

       
                    if (this.valuePays == null)
                        this.valuePays = this.PaysValues[indexMaroc].value;
                    this.IdMaroc = this.PaysValues[indexMaroc].value;

                    this.PaysValues.splice(0, 0, this.PaysValues.splice(indexMaroc, 1)[0]);


                }
                else if (picklist === 'region') this.RegionValues = rs;
                else if (picklist === 'ville') {

                    console.log('start picklist === ville  :')

                    this.VilleValues =rs;
                    let t =  rs.sort(function(a, b) {
                        var nameA = a.label.toUpperCase(); // ignore upper and lowercase
                        var nameB = b.label.toUpperCase(); // ignore upper and lowercase
                        if (nameA < nameB) {
                          return -1;
                        }
                        if (nameA > nameB) {
                          return 1;
                        }
                      
                        // names must be equal
                        return 0;
                      });

                      console.log('t :')
                      console.log(t)
                }
                else if (picklist === 'quartier') {
                    this.QuartierValues = rs;
                   // console.log('this.QuartierValues[0].value : '+ this.QuartierValues[0].value)
                    if(this.QuartierValues[0].value =='null'){
                        this.isToSpecify = true;
                      //  this.template.querySelector(`[data-theid="PrecisionQuartier"]`).value = this.pq;
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
                });}
                ChangePrecisionQuartier(event) {
                    this.omniUpdateDataJson({ "PrecisionQuartier": event.detail.value });
                    this.pquartier=event.detail.value;
                    this.eligible=false;
                    this.step=false;
                    this.stepAd=false;
                    this.create=true;
                    console.log('nomsite',this.nomsite);
                    if(this.nomsite!=''){
                        this.checkrequiredfield=false;}
                    
                    
                }      
    ChangePays(event) {
        //console.log('ChangePays')

       // this.omniUpdateDataJson({ "Pays": event.detail.value });
                 
        let labelSelected = this.PaysValues.find(opt => opt.value === event.detail.value).label;

       // this.omniUpdateDataJson({ "PaysName":labelSelected });



        if (labelSelected == 'Maroc') {
            this.template.querySelector(`[data-theid="Region"]`).style.display = "block"
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "block"
            if(this.template.querySelector(`[data-theid="Quartier"]`)!=null)
            this.template.querySelector(`[data-theid="Quartier"]`).style.display = "block"
        if(this.template.querySelector(`[data-theid="PrecisionQuartier"]`)!=null)
            this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "block"

           
        } else {
            this.QuartierValues = [];

            this.template.querySelector(`[data-theid="Region"]`).value = 'sélectionnez une ville';
            this.template.querySelector(`[data-theid="Ville"]`).value = '';

            //   this.template.querySelector(`[data-theid="Region"]`).placeholder = 'sélectionnez un pays';
            this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';         
            
            this.template.querySelector(`[data-theid="Region"]`).style.display = "none"
            this.template.querySelector(`[data-theid="Ville"]`).style.display = "none"
            

            if(this.template.querySelector(`[data-theid="Quartier"]`)==null){
                this.template.querySelector(`[data-theid="PrecisionQuartier"]`).style.display = "none"
                this.template.querySelector(`[data-theid="PrecisionQuartier"]`).value = null;

            }else{
                this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';
                this.template.querySelector(`[data-theid="Quartier"]`).style.display = "none"
                this.template.querySelector(`[data-theid="Quartier"]`).value = null;
            }


        }
    }


    ChangeRegion(event) {
        //console.log('ChangeRegion')

        this.omniUpdateDataJson({ "Region": event.detail.value });
      //  this.omniUpdateDataJson({ "Ville": "null" });
     // this.labelSelectedRegion = this.RegionValues.find(opt => opt.value === event.detail.value).label;
    //  this.VilleValues = [];
    //  this.QuartierValues = [];
      this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';
      this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';
      this.region= event.detail.value;
      //this.regionN= event.detail.value.name;
      console.log('this.region:',this.region);
      //console.log('this.regionN:',this.regionN);
      let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Villes","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Region Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"InwiB2C_Region__c","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Region Name":"' + event.detail.value + '"}}';

      this.fetchPicklistValues('ville', inp)

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
                    let CityInfo = response.result.IPResult.theCity;
                    console.log('CityInfo: ')
                    console.log(CityInfo)

                    // let regionId = response.result.IPResult.theCity.RegionName;
                    //console.log('regionId: ' + regionId)
                    //  console.log('response.result.IPResult.theCity: ')
                    console.log('data-theid:Region.value : '+this.template.querySelector(`[data-theid="Region"]`).value)
                    console.log('response.result.IPResult.theCity.RegionName : '+response.result.IPResult.theCity.RegionName)
                    this.regV=response.result.IPResult.theCity.RegionName;
                    this.cityV =response.result.IPResult.theCity.CityName;
                    this.r = response.result.IPResult.theCity.RegionName;
                    this.region = response.result.IPResult.theCity.RegionId;
                    this.labelSelectedRegion= response.result.IPResult.theCity.RegionName;
                    this.template.querySelector(`[data-theid="Region"]`).value = response.result.IPResult.theCity.RegionName;
                 //omniUpdateDataJson({ "Region": response.result.IPResult.theCity.RegionId });
               //Mod  this.region=response.result.IPResult.theCity.RegionId;
                 console.log('regionId: '+this.region);
                  // this.omniUpdateDataJson({ "PaysName": response.result.IPResult.theCity.PaysName });
                  // this.omniUpdateDataJson({ "RegionName": response.result.IPResult.theCity.RegionName });
                  // this.omniUpdateDataJson({ "CityName": response.result.IPResult.theCity.CityName });



                }

            })
            .catch(error => {
                console.log('error: ' + error);
            });
    }
   /* ChangeVille2(event) {
        let selectedvilleId = event.detail.value;
        this.villeid= selectedvilleId;
        this.labelSelectedVille =this.list.VilleName;
        this.setRegionInfo(selectedvilleId);
        let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + selectedvilleId + '"}}';

      this.fetchPicklistValues('quartier', inp);
    }*/
    ChangeVille(event) {
        //console.log('ChangeVille')
        //console.log('start changing Quartier values')
        this.eligible=false;
        this.step=false;
        this.stepAd=false;
        let selectedvilleId = event.detail.value;
        console.log('selectedvilleId: ' + selectedvilleId)
        this.villeid= selectedvilleId;
       // console.log('selectedvilleName: ' + labelSelectedVille);
        console.log('id ville: '+ this.villeid);
       // this.omniUpdateDataJson({ "Ville": selectedvilleId });
       // this.omniUpdateDataJson({ "RegionName": "null"  });
      //  this.omniUpdateDataJson({ "CityName": "null"  });
      //this.labelSelectedVille =this.list.VilleName;
      //CHB 12133 22/11/2023
      this.labelSelectedVille =this.VilleValues.find(opt => opt.value === event.detail.value).label;
      this.cityV =this.VilleValues.find(opt => opt.value === event.detail.value).label;
      this.QuartierValues = [];
      //this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';

      this.setRegionInfo(selectedvilleId);


      console.log('selectedvilleId: ' + selectedvilleId)
      let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + selectedvilleId + '"}}';

      this.fetchPicklistValues('quartier', inp);
     
    }
    ChangeQuartier(event) {
        this.create=true;
        //console.log('ChangeQuartier')
        this.step=false;
        this.stepAd=false;
        this.eligible=false;
        
        this.labelSelectedQuartier = this.QuartierValues.find(opt => opt.value === event.detail.value).label;
      //  console.log('labelSelectedQuartier: ' + this.labelSelectedQuartier)
        this.omniUpdateDataJson({ "Quartier": event.detail.value });
       
        this.quartier=event.detail.value;
        if(this.nomsite!=''){
        this.checkrequiredfield=false;}
         //console.log('changing region values')
    }
    handleChangeInput(event) {
       
        this[event.target.name] = event.target.value;
        //this.omniUpdateDataJson({ "CodePostale":this.codepostal });
        //this.omniUpdateDataJson({ "complementaddress":this.complementaddress });
        this.step=false;
        this.stepAd=false;
        this.eligible=false;
        if(this.q!='' || this.pq!=''){
            this.checkrequiredfield=false;}
        
       
        console.log('nomsite ',this.nomsite );
        }
     /* handleChange1(event) {
       // this.optionadresseShow=null;
        this.optionadresse = event.detail.value;
        if (this.optionadresse == "new_address") {
          this.fieldVisible = true;
          this.step12=true;
          this.eligible=false;
          this.step=false;
          this.stepAd=false;
          this.create=true;
          this.newsite=true;
          this.checkrequiredfield=true;
          this.nomsite=this.list.nomsite;
          this.region=this.list.region;
          this.r=this.list.RegionName;
          this.villeid=this.list.ville;
          //this.Ville=this.list.ville;
          //this.v=this.list.ville;
          this.v=this.list.ville;
          this.cityV=this.list.VilleName;
          
          //this.setRegionInfo(this.v);
          this.labelSelectedVille=this.list.VilleName;
          this.labelSelectedRegion=this.list.RegionName;
          //this.ChangeVille(this.v);
          this.quartier=this.list.quartier;
          this.q=this.list.quartier;
          this.labelSelectedQuartier=this.list.QuartierName;
          if(this.v!='' && this.v!=null){
            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +this.v+ '"}}';
            this.fetchPicklistValues('quartier', inp)
            //this.ChangeQuartier(this.q);
            }
          this.complementaddress=this.list.complement;
          this.codepostal=this.list.codepostale;
          this.pq=this.list.precisionquartier;
         console.log('adresse',this.optionadresseShow);
         } else {
          this.fieldVisible = false;
          this.step12=false;
          this.eligible=false;
          this.step=false;
          this.stepAd=false;
          this.create=true;
          this.optionadresseShow=this.addressclient;
          this.newsite=false;
          this.checkrequiredfield=true;
          this.nomsite=null;
          this.region=null;
          this.villeid=null;
          this.quartier=null;
          this.pquartier=null;
        }
      }*/
    //partie creation Account Service
    createAccount(){
        this.checkrequiredfield=true;
        console.log('input out of step12',this.list);
        this.hideModalBox();
        this._actionUtilClass = new OmniscriptActionCommonUtil();
       // let input;

           //if(this.step12==true){
            //let  input ='{"IdServiceAccount":"'+this.idserviceaccount+'","region": "'+this.region+'","ville": "'+this.villeid+'","parentId": "'+this.accountid+'","codepostale":"'+this.codepostal+'","complement":"'+this.complementaddress+'","quartier":"'+this.quartier+'","precisionquartier":"'+this.pquartier+'","nomsite":"'+this.nomsite+'"}';
            let  input ='{"accId":"'+this.idserviceaccount+'","region": "'+this.region+'","ville": "'+this.villeid+'","parentId": "'+this.accountid+'","codepostale":"'+this.codepostal+'","complement":"'+this.complementaddress+'","quartier":"'+this.quartier+'","precisionquartier":"'+this.pquartier+'","nomsite":"'+this.nomsite+'"}';
           
            console.log('input in step12',input);
           
          // }else{
         //console.log('listNew:'+this.list.push("nomsite",this.nomsite));
         //   input =this.list;
          // input= '{"nomsite":"'+this.nomsite+','+this.list+'"}';
       //   this.__list[0].nomsite=this.nomsite;
         // input= this.list;
          
          // console.log('this.list',this.list);
           console.log('input',input);
          // }
  //let input ='{"AccountId": "'+this.idrec+'"}';
  //let input ='{"region": "'+this.region+'","ville": "'+this.villeid+'","parentId": "'+this.accountid+'"}';
 
  const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwiB2C_CreateServiceAccount",
      options: "{}"
  };
  this._actionUtilClass
  .executeAction(params, null, this, null, null)
  .then(response => {
      console.log('responsecreateAccount',response.result.IPResult);
      
      if (!response.error) {
          if (response.result.IPResult.accountid !=null) {
             // this.__showAddAccount = false;
             this.recordid=response.result.IPResult.accountid;
             console.log('record: '+this.recordid);
          //   this.showMessage('Succès', 'le compte est cree.', 'succes');
             console.log('le compte est cree');
             //this.appelApi();
             //this.step12=false;
             this.eligible=true;
            // this.appelAPIPlaque();
            
          } else {
            
          //  this.showMessage('Erreur', 'Erreur lors de la creation', 'error');
            console.log('Erreur lors de la creation');
        
          }
      }
  })
  .catch(error => {
      window.console.log(error);
  });
    }
  /* 
      appelApi(){
        this._actionUtilClass = new OmniscriptActionCommonUtil();
           
  let input ='{"AccountId": "'+this.recordid+'"}';
  const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_Check_FO_Eligibilite",
      options: "{}"
  };
  this._actionUtilClass
  .executeAction(params, null, this, null, null)
  .then(response => {
      console.log('responseEligi',response.result.IPResult.CheckEligibilite);

      if (!response.error) {
          if (response.result.IPResult.CheckEligibilite=="Eligibile") {
             // this.__showAddAccount = false;
             this.eligible=true;
             console.log('eligible');
             this.create=false;
             this.appelAPIPlaque();
             this.showMessage('Succès', 'Eligible.', 'success');
             let dataResult = response.result.IPResult.serviceQualification;
             console.log('response service ',dataResult);
              let dataEligible = [];
              dataResult.map((itemE, index) => {
                  console.log(dataResult.length == 1);
                  itemE.index = index;
                  console.log('index ',index);
                  itemE.checked = dataResult.length == 1;
                  dataEligible.push(itemE);
              })
              this.__dataEligible = dataEligible;         
            
           
      }else {
        console.log('Non Eligible');
   
        this.showMessage('Erreur', 'Non Eligible', 'error');

      }}
  })
  .catch(error => {
      window.console.log(error);
    
  });
} ano 10952 CHADIA*/
handleChangeSearch(event){
    this.search=event.target.value;
    console.log("search",this.search);
    this.__dataplaque=this.dataPlaqueResult;
    if(this.search!='' || this.search!=null){
        this.__dataplaque=this.__dataplaque.filter(element => element.name.includes(event.target.value.toUpperCase()) );
    }
    
}

      handleSelectAdress(event){
  
        this.idadress = event.target.dataset.idline;
        console.log('adressId: ' + this.idadress);
        let selectedInfoAdressSite = { 
          "idAdress" :event.target.dataset.idline,
          "city" : event.target.dataset.city,
          "region" : event.target.dataset.region,
          "sroid" : event.target.dataset.sroid,
          "nroid" : event.target.dataset.nroid
      }
      
     // this.stepAd=true;
      this.omniUpdateDataJson(selectedInfoAdressSite);
      this.omniSaveState(selectedInfoAdressSite,true);
      
      
      }
      appelAPIPlaque(){
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('plaque:');
        console.log('Amine BRM'+this.optionadresse);
        console.log('Amine BRM2'+this.cityV);
        let input;
       // if (this.optionadresse == "new_address") {
        input = '{"city" :"' + this.cityV.replace(/ /g, '%20') +'" }';
            console.log('city True: '+input);
       // }else{
       //     input ='{"city" :"'+ this.villename+'" }';
       //     console.log('city False: '+input);
     //   }
      //  let input ='{"city :"'+this.city+'" }';
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            //sMethodName: "inwib2c_Get_Plaque_NRA",
            sMethodName: "inwib2c_Get_Plaque_NRAApigee",

            options: "{}"
        };
        this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log('responseplaque',response);
                  if (!response.error && response.result.IPResult) {
                      //if (response.result.IPResult ) {
                          //this.__showAddAccount = false;
                          let dataResult = response.result.IPResult.input;
                          console.log('dataResult',dataResult);
                          let dataplaque = [];
                          dataResult.map((item, index) => {
                              console.log(dataResult.length == 1);
                              item.index = index;
                            
                              this.create=false;
                              item.checked = dataResult.length == 1;
                              dataplaque.push(item);
                              this.__dataplaque = dataplaque;
                              this.__dataplaque = this.__dataSortName.sort();
                                                  this.__dataSortName = dataplaque;
                              this.dataPlaqueResult=   this.__dataplaque;                  
                              this.__dataSortName.sort(function (a, b) {
                                if (a.name < b.name) {
                                  return -1;
                                }
                                if (a.name > b.name) {
                                  return 1;
                                }
                                return 0;
                              });
                          })
                          this.createAccount();
                       //   this.__dataplaque = dataplaque;
                     // } 
                  }else {
                    this.__dataplaque = [];
                    this.showMessage('Erreur', 'Non Eligible', 'error');
                    //this.__showAddAccount = true;
                }
              })
        .catch(error => {
            window.console.log(error);
        });
      }
      handleSelectPlaque(event){
        this.idadress = event.target.dataset.idline;
        let selectedInfo = { 
          "city" : event.target.dataset.city,
          "referredtype" : event.target.dataset.referredtype,
          "name" : event.target.dataset.name,
         "vendor" : event.target.dataset.vendor,
         "statut": event.target.dataset.statut
      }
      this.stepAd=true;
      this.step=true;
      this.omniUpdateDataJson(selectedInfo);
      this.omniSaveState(selectedInfo,true);
      }
      showMessage(t, m, type) {
        const toastEvt = new ShowToastEvent({
            title: t,
            message: m,
            variant: type
        });
        this.dispatchEvent(toastEvt);
    };

    next(event) {
        //console.log('ChangeQuartier')
       
        this.updateEligible();
        
    
        }
        updateEligible(){
            this._actionUtilClass = new OmniscriptActionCommonUtil();
            this.omniUpdateDataJson({ "AccountIdService":  this.recordid });
             this.omniUpdateDataJson({"nomsite":this.nomsite});
            let input ='{"AccountId": "'+this.recordid+'"}';
            console.log('input',input);
            const params = {
                input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_UpdateAccountEligibleService",
                options: "{}"
            };
            this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
               console.log("response update account",response.result.IPResult);
                if (!response.error) {
                    if (response.result.IPResult !=null) {
                       // this.__showAddAccount = false;
                       console.log("response update account in response",response.result.IPResult);
                    //   this.showMessage('Succès', 'le compte est cree.', 'succes');
                       console.log('le champ eligible est bien modifié');
                       this.omniNextStep();
                       
                    } else {
                      
                    //  this.showMessage('Erreur', 'Erreur lors de la creation', 'error');
                      console.log('Erreur lors de lupdate');
                  
                    }
                }
            })
            .catch(error => {
                window.console.log(error);
            });
              } 
              @track isShowModal = false;

    showModalBox() {  
        this.isShowModal = true;
       //if (this.optionadresse == "new_address") {
         // this.optionadresseShow ='{"region": "'+this.regionN+'","ville": "'+this.villeid+'",+","codepostale":"'+this.codepostal+'","complement":"'+this.complementaddress+'","quartier":"'+this.quartier+'","precisionquartier":"'+this.pquartier+'"}';
       if (this.isToSpecify == false){
        this.optionadresseShow="Maroc ,"+this.labelSelectedRegion+","+this.labelSelectedVille+","+this.labelSelectedQuartier;  
    }else
    {
            this.optionadresseShow="Maroc ,"+this.labelSelectedRegion+","+this.labelSelectedVille+","+this.pquartier;
        }
    // }else{
    //    this.optionadresseShow=this.addressclient;
   //  }
        console.log('onclick',this.optionadresseShow);
       
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
              handleCancel(event){ 
               this.omniUpdateDataJson({ "annuler":true});
               this.omniNextStep();}
               //sort table
         //check required Field
   
    // H-M Rendre le champs  complement address facultatif le cas canal D2D
       checkField() {
            const isNomSiteValid = this.nomsite != null && this.nomsite !== '';
            const isRegionValid = this.region != null;
            const isVilleValid = this.villeid != null;
            const isQuartierValid = this.quartier != null || this.pquartier != null;
  
           
           const isComplementAddressValid = this.DisplayD2D || (this.complementaddress != null && this.complementaddress !== '');

           if (isNomSiteValid && isRegionValid && isVilleValid && isQuartierValid && isComplementAddressValid) {
            this.showModalBox();
            }else {
              console.log('in else');
              this.showMessage('Erreur', 'Champs Obligatoires Manquants', 'error');
            }
          } 

         gotonextStep() {
          this.omniNextStep();

        }
  /*05/08/2024 CHB  ANO B-18866 BEGIN */
  handleKeyDown(event) {
    // Regex pattern for allowed characters
    const regex = /^[A-Za-z0-9,–'’\-]$/;
    // Get the key pressed
    const key = event.key;

    // Check if the key pressed is valid
    if (!regex.test(key) && key !== 'Backspace' && key !== 'ArrowLeft' && key !== 'ArrowRight' && key !== 'Delete') {
        // Prevent the default action if the key is not allowed
        event.preventDefault();
    }
}/*05/08/2024 CHB  ANO B-18866 END */
      
}