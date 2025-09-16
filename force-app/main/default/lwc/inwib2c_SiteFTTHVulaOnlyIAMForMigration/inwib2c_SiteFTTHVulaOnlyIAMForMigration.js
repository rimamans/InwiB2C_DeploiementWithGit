import { LightningElement, api, track,wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class Inwib2c_SiteFTTHVulaOnlyIAMForMigration  extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) 
{    
    __data2 = [];
    newsite;
    @track nomsite; 
    regV;
    cityV;
    codePV;
    quartV;
    stepEligible=true;
    optionadresse = "old_address";
    showother = true;
    variant = 'error';
    showother=true;
    step12=true;
    step=false;
    stepAd=false;
    _ns = getNamespaceDotNotation();
    create=true;
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
    valuePays = [];
    PaysValues = [];
    RegionValues = [];
    VilleValues = [];
    QuartierValues = [];
    __dataEligible=[];
    __dataplaque=[];
    dataPlaqueResult=[];
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
    @track labelSelected ;
    @api addressclient;
    checkrequiredfield=true;
    displayMDNChoice = true;
    displayNDIAMchoice = true ; 
    
    //var mdn search 
  mdnFilter = '';
  selectedmdn;
  __selectedmdnListItem = '';
  records;
  //numDes;
  mdn;
  @track numND;
// adressiam
batiment;
  porte;
  etage;
  escalier;
  Quartier ;
  //Commune ;
  Province ;
  Voie ;
  NumVoie ; 
  ProvinceCode ;
  CommuneCode ;
  QuartierCode ;
  VoieCode ;
  statutLigne ;
  @track portabilite ;
  @track typeIdentifiant ;
  @track typeAccesInternet = 'Aucun accès' ;
  showNDInput = false;
  showBoxNum = false ;
  showInputLogin = false ;
  showBlocEligibilite = false ; 
  disabledFieldsOnUpdate = false ; 
  updateLogin = true ; 
  @track ndIAM ;
 // MGEN3729 FTTH_VULA éligibilité exigences ANR begin
 disablelogin = false ; 
 @api
    get nd () {
        return this.__nd;
    }
    set nd (value) {
        this.__nd = value;
    }

    @api
    get statutligne() {
        return this.__statutligne;
    }
    set statutligne(value) {
        this.__statutligne = value;
    }

    @api
    get login() {
        return this.__login;
    }
    set login(value) {
        this.__login = value;
    }
 // MGEN3729 FTTH_VULA éligibilité exigences ANR end

  @track Login ;
  @track ndIAM212 ;
  // Operateur MSISDN
  OIMSISDN = '' ;
  ShowTypeIdentifiant = false ; // Y-MH  B-26441 

  IsNDChcked = false ; // MGEN3729 FTTH_VULA éligibilité exigences ANR


  typeAccesOptions = [
    { label: 'Fibre IAM', value: 'Fibre IAM' },
    { label: 'Fibre Orange', value: 'Fibre Orange' },
    { label: 'ADSL IAM', value: 'ADSL IAM' },
    { label: 'ADSL Orange', value: 'ADSL Orange' },
    { label: 'Aucun accès', value: 'Aucun accès' }
];

portabiliteOptions = [
    { label: 'Oui', value: 'Oui' },
    { label: 'Non', value: 'Non' }
];

@track identifiantLigneOptions = [
    { label: 'Numéro de désignation (ND)', value: 'ND' },
];

 //@api list
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
    // ORDERID
    @api
  get orderid() {
    return this.__orderid;
  }
  set orderid(value) {
    this.__orderid = value;
  }
  @api
  get rootitemid() {
    return this.__rootitemid;
  }
  set rootitemid(value) {
    this.__rootitemid = value;
  }

  // typeInfrastructure
  @api
  get infrastructure() {
    return this.__infrastructure;
  }
  set infrastructure(value) {
    this.__infrastructure = value;
  }
  @api
  get plaque() {
    return this.__plaque;
  }
  set plaque(value) {
    this.__plaque = value;
  }
  @api
  get nro() {
    return this.__nro;
  }
  set nro (value) {
    this.__nro = value;
  }
  @api
  get fournisseur() {
    return this.__fournisseur;
  }
  set fournisseur(value) {
    this.__fournisseur = value;
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

    // Y_MH B-2780 09/04/2025  begin
      get ndLabel() {
        return this.portabilite === 'Oui' ? 'Numéro à porter' : "ND de la ligne existante (MDN du client chez l'autre opérateur)" ;//B-28634 YMH  15_05_2025
    }
    // Y_MH B-2780 09/04/2025  end


    // Y_MH B-27806 09/04/2025  begin
      get mdnLabel() {
        if (this.statutLigne == 'inactive' && this.portabilite == 'Non') {
            return 'MDN';
        } 
        // Autres cas
        return 'MDN'; // //B-28634 YMH 15_05_2025
    }
     // Y_MH B-B-27806 09/04/2025  end
  

      optionadresseShow=null;
      search='';
    connectedCallback() {
      console.log("this.portabilite", this.portabilite);
      console.log("this.isInfrastructureIAM", this.isInfrastructureIAM);
      console.log("this.statutLigne", this.statutLigne);
     // console.log("liste connectedcallback", this.list ) ;
        this.region=this.list.region;
        this.r=this.list.RegionName;
        this.villeid=this.list.ville;
        this.v=this.list.ville;
        this.cityV=this.villename;
        this.Quartier = this.list.Quartier;
        this.QuartierCode = this.list.QuartierCode ; 
        this.VoieCode = this.list.VoieCode ; 
        this.CommuneCode = this.list.CommuneCode ;
        this.ProvinceCode = this.list.ProvinceCode ; 
        this.Voie = this.list.Voie;
        this.Province = this.list.Province;
        //this.Commune = this.list.Commune;
        this.NumVoie = this.list.NumVoie;
        this.labelSelectedVille=this.villename;
        this.labelSelectedRegion=this.list.RegionName;
        this.quartier=this.list.quartier;
        this.q=this.list.quartier;
        this.labelSelectedQuartier=this.list.QuartierName;
        this.pquartier=this.list.precisionquartier;
        this.valuePays = this.list.paysId ;
        if(this.list.precisionquartier!='undefined' && this.list.precisionquartier!='' && this.list.precisionquartier!=null){
            this.isToSpecify=true;
        }
        if(this.v!='' && this.v!=null){
          let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' +this.v+ '"}}';
          this.fetchPicklistValues('quartier', inp)
          }
        this.complementaddress=this.list.complement;
        this.codepostal=this.list.codepostale;
        this.nomsite = this.list.nomsite + " site" ; 
       // console.log("nomsite", this.nomsite ) ;
        this.pq=this.list.precisionquartier;
       // console.log('list'+this.list);

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
            this.omniUpdateDataJson({ "Quartier":this.q });
            
            let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + this.v + '"}}';
            this.fetchPicklistValues('quartier', inp)
            

         }
//MGEN3729 FTTH_VULA éligibilité exigences ANR
        if (this.infrastructure == 'IAM') {
            if(this.statutligne == 'active') {
                this.typeAccesOptions = [
                { label: 'Fibre IAM', value: 'Fibre IAM' },
                
                ];
                if (this.nd !== '' && this.nd != null && this.nd != undefined ) {
                    this.displayNDIAMchoice = false ; 
                    this.ndIAM = this.nd ; 
                    this.statutLigne = this.statutligne ;
                    this.typeAccesInternet = 'Fibre IAM' ; 
                    this.portabilite = '' ;  // porta par defaut vide
                    this.ShowTypeIdentifiant = true ;
                    this.typeIdentifiant = 'ND' ; 
                    this.showNDInput = false ;

                }else if (this.login !== '' && this.login != null && this.login != undefined) {
                      this.typeAccesInternet = 'Fibre IAM' ;
                      this.portabilite = 'Non' ;  // porta par defaut vide
                      this.Login = this.login ; 
                      this.statutLigne = this.statutligne ;
                      this.disablelogin = true ; 
                      this.ShowTypeIdentifiant = true ;
                        this.identifiantLigneOptions = [
                          { label: 'Login', value: 'Login' },
                       ];
                      this.portabiliteOptions = [
    
                      { label: 'Non', value: 'Non' }
                      ];
                      this.typeIdentifiant = 'Login' ; 
                      this.showBoxNum = true ;
                      this.updateLogin = false ; 
                      console.log("typeidentifian" ,this.typeIdentifiant) ;
                }
               
                console.log("numéro de designation connectedcallback", this.nd) ; 
                console.log("statut de la ligne connectedcallback", this.statutligne) ;
                console.log("operateur connectedcallback", this.infrastructure) ;
                console.log("operateur connectedcallback", this.login) ;


            }else {
              this.typeAccesOptions = [
              { label: 'Aucun accès', value: 'Aucun accès' }
              ];
              this.handleTypeAccesChange() ; 
            }
                 console.log("numéro de designation connectedcallback OUT IF ", this.nd) ; 
                console.log("statut de la ligne connectedcallback OUT IF", this.statutligne) ;
                console.log("operateur connectedcallback OUT IF ", this.infrastructure) ;
                console.log("operateur connectedcallback OUT IF ", this.login) ;


        }else if (this.infrastructure == 'ORANGE') {
           if(this.statutligne == 'active') {
                this.typeAccesOptions = [
                { label: 'Fibre Orange', value: 'Fibre Orange' },
                
                ];
                this.displayNDIAMchoice = false ; 
                this.ndIAM = this.nd ; 
                this.statutLigne = this.statutligne ;
                this.typeAccesInternet = 'Fibre Orange' ; 
                this.portabilite = 'Oui' ; 
                this.ShowTypeIdentifiant = true ;
                this.typeIdentifiant = 'ND' ; 
                this.showNDInput = false ;


              }else {
              this.typeAccesOptions = [
              { label: 'Aucun accès', value: 'Aucun accès' }
              ];
              this.handleTypeAccesChange() ; 
            }          
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

                     // console.log('t :')
                     // console.log(t)
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
                    this.q=null;
                    this.quartier=null;
                    if(this.nomsite!='' && this.nomsite!=null){
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
      this.VilleValues = [];
      this.QuartierValues = [];
      this.template.querySelector(`[data-theid="Ville"]`).placeholder = 'sélectionnez une ville';
      this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';
      this.region= event.detail.value;
      //this.regionN= event.detail.value.name;
      //console.log('this.region:',this.region);
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
                   // console.log('CityInfo: ')
                   // console.log(CityInfo)

                    // let regionId = response.result.IPResult.theCity.RegionName;
                    //console.log('regionId: ' + regionId)
                    //  console.log('response.result.IPResult.theCity: ')
                   // console.log('data-theid:Region.value : '+this.template.querySelector(`[data-theid="Region"]`).value)
                   // console.log('response.result.IPResult.theCity.RegionName : '+response.result.IPResult.theCity.RegionName)
                    this.regV=response.result.IPResult.theCity.RegionName;
                    this.cityV =response.result.IPResult.theCity.CityName;
                    this.r = response.result.IPResult.theCity.RegionName;
                    this.region = response.result.IPResult.theCity.RegionId;
                    this.labelSelectedRegion= response.result.IPResult.theCity.RegionName;
                    this.template.querySelector(`[data-theid="Region"]`).value = response.result.IPResult.theCity.RegionName;
                 //omniUpdateDataJson({ "Region": response.result.IPResult.theCity.RegionId });
               //Mod  this.region=response.result.IPResult.theCity.RegionId;
                // console.log('regionId: '+this.region);
                  // this.omniUpdateDataJson({ "PaysName": response.result.IPResult.theCity.PaysName });
                  // this.omniUpdateDataJson({ "RegionName": response.result.IPResult.theCity.RegionName });
                  // this.omniUpdateDataJson({ "CityName": response.result.IPResult.theCity.CityName });



                }

            })
            .catch(error => {
               // console.log('error: ' + error);
            });
    }

    ChangeVille(event) {
        //console.log('ChangeVille')
        //console.log('start changing Quartier values')
        this.eligible=false;
        this.step=false;
        this.stepAd=false;
        let selectedvilleId = event.detail.value;
       // console.log('selectedvilleId: ' + selectedvilleId)
        this.villeid= selectedvilleId;
       // console.log('selectedvilleName: ' + labelSelectedVille);
       // console.log('id ville: '+ this.villeid);
       // this.omniUpdateDataJson({ "Ville": selectedvilleId });
       // this.omniUpdateDataJson({ "RegionName": "null"  });
      //  this.omniUpdateDataJson({ "CityName": "null"  });
      this.labelSelectedVille = this.VilleValues.find(opt => opt.value === event.detail.value).label;
      
      
      this.QuartierValues = [];
      //this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';

      this.setRegionInfo(selectedvilleId)
      this.pquartier=null;

      console.log('selectedvilleId: ' + selectedvilleId)
      let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + selectedvilleId + '"}}';

      this.fetchPicklistValues('quartier', inp)
     
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
}

//begin search MDN(Numero de designation)
handleMdnFilterChange(event) {
    this.mdnFilter = event.target.value;
  }
  handleMdnSelection(event) {
    //console.log('selectedmdn:',this.selectedmdn);
    this.__selectedmdnListItem = event.detail.value;
  }
// GET INFRAS
get isInfrastructureInwi() {
    return this.__infrastructure === 'INWI';
}
get isInfrastructureOrange() {
  return this.__infrastructure === 'ORANGE';
}
get isInfrastructureIAM() {
  return this.__infrastructure === 'IAM';
}
// recherche Mdn
getMdnList(event) {
    let input = '{"serviceAccount":"' + this.accountid + '","mdnType":"IMS", "offerType":"' + this.region + '", "category":"NORMAL", "mdn":"' + this.mdnFilter + '","lockToken":"' + this.orderid + '","nbrResult": 3, "rootItemId" : "' + this.rootitemid + '" }';

    //console.log('getMdnList : ' + JSON.stringify(input));
    let structure = {
      "action": "ON_BILL",
      "opid": "8787747467457674567",
      "type": "OCS",
      "mdn": "212648040012",
      "productOrderItem": [{
        "orderItemAction": "ADD",
        "orderItemId": "1008"
      }
      ]
    };
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'Inwi_InwiB2C_MdnSearch',
      options: structure
    };

   // console.log('before call mdnsearch' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        
           console.log(response);
           
          if (response.result) {
            //   console.log(response);
            var returnOptions = [];
            this.isLoading = false;
            response.result.IPResult.forEach(ele => {
              returnOptions.push({ label: ele.mdn, value: ele.mdn });
            });
            this.records = returnOptions;


          }
        
      })
      .catch(error => {
        console.log('error');
        window.console.log(error);
        this.isLoading = false;
      });
  }

  //function convert ND
  convertND(nd) {
    this.numND = "0";
    this.numND += nd.substring(3, 14);
    console.log("myND: ",this.numND);
  }
  convertNDTo212(nd) {
    // Vérifiez si le numéro commence par '0'
    
    return '212' + nd.substring(1);
}

get fullAddress() {
  const porte = this.porte || '';
  const etage = this.etage || '';
  const escalier = this.escalier || '';
  const batiment = this.batiment || '';
  const numDansLaVoie = this.NumVoie || '';
  
  const codeVoie = this.VoieCode || '';
  const valeurVoie = this.Voie || '';
  const codeQuartier = this.QuartierCode || '';
  const valeurQuartier = this.Quartier || '';
  const codeCommune = this.CommuneCode || '';
  //const valeurCommune = this.Commune || '';
  const codeProvince = this.ProvinceCode || '';
  const valeurProvince = this.Province || '';

  // Concaténation 
  return (
      `${porte}|${etage}|${escalier}|${batiment}|${numDansLaVoie}|` +
      `${codeVoie};${valeurVoie}|${codeQuartier};${valeurQuartier}|` +
      `${codeCommune}|${codeProvince};${valeurProvince}|`
  );
}
// Y_MH Begin

  updateSF() {
    console.log('updateSF called');
   // console.log('ADRESSEIAM', this.fullAddress) ;
   console.log('fournisseur updatesf', this.fournisseur);

    this.isLoading = true;
    let input; 
    // cas Inwi
    if (this.isInfrastructureInwi === true) {
     input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '" , "nomsite":"' + this.nomsite + '", "fournisseur":"' + this.__fournisseur + '" , "OperateurInfra":"' + this.__infrastructure + '" ,"plaque":"' + this.__plaque + '" , "Operateur":"INWI" ,"nro":"' + this.__nro + '" }';

     // Cas Orange
    } else if (this.isInfrastructureOrange) {
      if (this.statutLigne === 'active') {
        if (this.portabilite === 'Oui') {
          this.ndIAM212 = this.convertNDTo212(this.ndIAM) ;
           input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '", "NDOI":"' + this.ndIAM +'" , "numND":"' + this.ndIAM + '","nomsite":"' + this.nomsite + '","NumTel":"' + this.ndIAM212 + '","fournisseur":"' + this.__fournisseur + '","plaque":"' + this.__plaque + '","ChoixNum":"porter un numéro","PortedNd":"' + this.ndIAM212 + '", "OperateurInfra":"' + this.__infrastructure + '" ,"DatePortabilité":"' + new Date().toISOString().split("T")[0] + '","EligiblePortaIn":"true" , "StatutPartage":"Ligne Active" , "Operateur":"ORANGE", "AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '" ,"nro":"' + this.__nro + '" }';
        }else {
           input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '","numND":"' + this.ndIAM + '"  , "NDOI":"' + this.numND +'" ,"nomsite":"' + this.nomsite + '","NumTel":"' + this.__selectedmdnListItem + '" ,"fournisseur":"' + this.__fournisseur + '" ,"plaque":"' + this.__plaque + '", "ChoixNum":"personnaliser le numéro",  "OperateurInfra":"' + this.__infrastructure + '" ,"EligiblePortaIn":false , "StatutPartage":"Ligne Active" , "Operateur":"ORANGE", "AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '"  ,"nro":"' + this.__nro + '" }';
        }
      } else if (this.statutLigne === 'inactive') {
          if (this.portabilite === 'Oui') {
            this.ndIAM212 = this.convertNDTo212(this.ndIAM) ;
           input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '","numND":"' + this.ndIAM + '"   , "NDOI":"' + this.numND +'" ,"nomsite":"' + this.nomsite + '", "fournisseur":"' + this.__fournisseur + '" ,"plaque":"' + this.__plaque + '" , "PortedNd":"' + this.ndIAM212 + '", "NumTel":"' + this.__selectedmdnListItem + '" ,  "ChoixNum":"porter un numéro",  "OperateurInfra":"' + this.__infrastructure + '" ,"DatePortabilité":"' + new Date().toISOString().split("T")[0] + '","EligiblePortaIn":true , "StatutPartage":"Ligne Inactive" , "Operateur":"ORANGE" , "AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '"  ,"nro":"' + this.__nro + '"}';
          }else {
             input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '","NDOI":"' + this.numND + '","nomsite":"' + this.nomsite + '","NumTel":"' + this.__selectedmdnListItem + '" ,"fournisseur":"' + this.__fournisseur + '" ,"plaque":"' + this.__plaque + '" ,  "ChoixNum":"personnaliser le numéro",  "OperateurInfra":"' + this.__infrastructure + '" ,"EligiblePortaIn":false , "StatutPartage":"Ligne Inactive" , "Operateur":"ORANGE" , "AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '"  , "OperatorMsiSDN":"' + this.OIMSISDN + '" ,"nro":"' + this.__nro + '"}';
          }
      }
    } 
    // CAs IAM
    
    else if (this.isInfrastructureIAM) {
      if (this.statutLigne === 'active') {
        if (this.portabilite === 'Oui') {
          this.ndIAM212 = this.convertNDTo212(this.ndIAM) ;
           input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '" ,"AdresseIAM":"' + this.fullAddress + '" , "NDOI":"' + this.ndIAM +'" , "numND":"' + this.ndIAM + '","nomsite":"' + this.nomsite + '","NumTel":"' + this.ndIAM212 + '","fournisseur":"' + this.__fournisseur + '","plaque":"' + this.__plaque + '","ChoixNum":"porter un numéro","PortedNd":"' + this.ndIAM212 + '", "OperateurInfra":"' + this.__infrastructure + '" ,"DatePortabilité":"' + new Date().toISOString().split("T")[0] + '","EligiblePortaIn":true, "StatutPartage":"Ligne Active" , "Operateur":"IAM" , "AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '" ,"nro":"' + this.__nro + '" }';
        }else {
           input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '", "Login":"' + this.Login + '" , "AdresseIAM":"' + this.fullAddress + '" ,"numND":"' + this.ndIAM + '"  , "NDOI":"' + this.numND +'" , "nomsite":"' + this.nomsite + '","NumTel":"' + this.__selectedmdnListItem + '" ,"fournisseur":"' + this.__fournisseur + '" ,"plaque":"' + this.__plaque + '", "ChoixNum":"personnaliser le numéro",  "OperateurInfra":"' + this.__infrastructure + '" ,"EligiblePortaIn":false  ,"Identifiantigne":"' + this.updateLogin + '" , "StatutPartage": "Ligne Active" , "Operateur":"IAM" ,"AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '" ,"nro":"' + this.__nro + '" } ';
        }
      } else if (this.statutLigne === 'inactive') {
          if (this.portabilite === 'Oui') {
            this.ndIAM212 = this.convertNDTo212(this.ndIAM) ;
           input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '", "AdresseIAM":"' + this.fullAddress + '" , "numND":"' + this.ndIAM + '"   , "NDOI":"' + this.numND +'" ,"nomsite":"' + this.nomsite + '" ,"NumTel":"' + this.__selectedmdnListItem + '" , "fournisseur":"' + this.__fournisseur + '" ,"plaque":"' + this.__plaque + '" , "PortedNd":"' + this.ndIAM212 + '",  "ChoixNum":"porter un numéro",  "OperateurInfra":"' + this.__infrastructure + '" ,"DatePortabilité":"' + new Date().toISOString().split("T")[0] + '","EligiblePortaIn":true , "StatutPartage": "Ligne Inactive" , "Operateur":"IAM" ,"AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '" ,"nro":"' + this.__nro + '" }';
          }else {
             input = '{"OrderId":"' + this.orderid + '","IdSite":"' + this.accountid + '", "AdresseIAM":"' + this.fullAddress + '" , "NDOI":"' + this.numND + '","nomsite":"' + this.nomsite + '","NumTel":"' + this.__selectedmdnListItem + '" ,"fournisseur":"' + this.__fournisseur + '" ,"plaque":"' + this.__plaque + '" ,  "ChoixNum":"personnaliser le numéro",  "OperateurInfra":"' + this.__infrastructure + '" ,"EligiblePortaIn":false , "StatutPartage": "Ligne Inactive" , "Operateur":"IAM" , "AccesType": "' + this.typeAccesInternet + '", "IdetifiantDeLigne": "' + this.typeIdentifiant + '", "Portabilite": "' + this.portabilite + '", "StatutLigne": "' + this.statutLigne + '" , "OperatorMsiSDN":"' + this.OIMSISDN + '" ,"nro":"' + this.__nro + '" }';
          }
      }
    } 
    const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`, 
        sMethodName: 'inwib2c_inwib2c_UpdateAttributsSiteVula', 
        options: '{}'
    };

   console.log('before call updateSF', JSON.stringify(params));

   
    this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            this.isLoading = false;

           
              //  console.log('response API', response);

                if (response.result) {
                  //  console.log('Attributs du site mis à jour avec succès.', response);
                    this.next() ;
                                  
                   }
            
        })
        .catch(error => {
          console.log('error');
          window.console.log(error);
        });
    }
// Y_MH End

    // update adresse inwi 
    updateAccount() {
      this._actionUtilClass = new OmniscriptActionCommonUtil();
      let input;
  
      console.log('Update adress called');
      // Vérification des champs nécessaires
      if (
        this.nomsite!=null
        && this.nomsite!='' 
        && this.region !=null 
        && this.villeid!=null 
        && (this.quartier !=null || this.pquartier!=null) 
        && this.complementaddress !=null 
        && this.complementaddress !=''
      ) {
          console.log('Tous les champs requis sont remplis. Lancement de la mise à jour.');
  
          input = '{"idAccountsite":"' + this.accountid + '","regionId": "' + this.region + '", "IdPays": "' + this.valuePays + '","IdVille": "' + this.villeid + '","codepostale":"' + this.codepostal + '","complementadresse":"' + this.complementaddress + '","IdQuartier":"' + this.quartier + '","precisionquartier":"' + this.pquartier + '"}';

          const params = {
              input,
              sClassName: `${this._ns}IntegrationProcedureService`,
              sMethodName: 'inwib2c_InwiB2C_UpdateAdressSiteVula',
              options: '{}',
          };
  
          this._actionUtilClass
              .executeAction(params, null, this, null, null)
              .then(response => {
                  if (!response.error) {
                    //  console.log('Adresse mise à jour avec succès');
                      this.showBlocEligibilite = true ; 
                      this.disabledFieldsOnUpdate = true;
         
                  } 
              })
              .catch(error => {
                //  console.log('Erreur critique :', error);
                  this.showMessage('Erreur', 'Erreur critique lors de la mise à jour', 'error');
              });
      } else {
         // console.log('Champs obligatoires manquants');
          this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
      }
  }
  
// ticket B-27481 Y_MH Begin
    checkND() {
      console.log('in checkND');
      //console.log('this.portabilite' , this.portabilite);
      this._actionUtilClass = new OmniscriptActionCommonUtil();
      let input;
      
      //if(this.portabilite=='Non'){
        input = '{"NumeroDeLaLigne": "' + this.__selectedmdnListItem + '"}';
      //}else{
        //this.ndIAM212 = this.convertNDTo212(this.ndIAM);
        //  input = '{"NumeroDeLaLigne": "' + this.ndIAM212 + '"}';
        //}
      // console.log('checkCheckND: ',input);
      const params = {
        input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_CheckNDFTTHVula",
        options: "{}"
      };
      console.log('before call checkND', JSON.stringify(params));
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          //  console.log('response1',response);
  
          if (!response.error) {
            if (response.result.IPResult) {
              let countSub = response.result.IPResult.CountSub;
              if (countSub == '0') {
               // if (this.portabilite == 'Non' && this.__selectedmdnListItem != '' && this.__selectedmdnListItem != null) {
                if ( this.__selectedmdnListItem != '' && this.__selectedmdnListItem != null) {
                 // console.log ('le numero peut etre utilisé')
                  this.lockMDN () ; 
               // }else  if (this.portabilite == 'Oui' && this.ndIAM != '' && this.ndIAM != null){
                 // console.log ('le numero NDIAM peut etre utilisé')
                 // this.displayNDIAMchoice = false ; 
                 // this.showNDInput = false ; 
                }else {
                  this.showMessage('Error', 'Numero de designation invalide ', 'error');
                }
              }
               else {
                this.showMessage('Error', 'Numero de designation existant', 'error');
              }
            }
            else {
              //  console.log('error');     
            }
          }
        })
        .catch(error => {
          window.console.log(error);
  
          this.isLoading = false;
        });
    }

    checkNDIAM() {
      console.log('in checkND');
      //console.log('this.portabilite' , this.portabilite);
      this._actionUtilClass = new OmniscriptActionCommonUtil();
      let input;
  
        this.ndIAM212 = this.convertNDTo212(this.ndIAM);
          input = '{"NumeroDeLaLigne": "' + this.ndIAM212 + '"}';
      
      const params = {
        input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_CheckNDFTTHVula",
        options: "{}"
      };
      console.log('before call checkND', JSON.stringify(params));
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          //  console.log('response1',response);
  
          if (!response.error) {
            if (response.result.IPResult) {
              let countSub = response.result.IPResult.CountSub;
              if (countSub == '0') {

                if ( this.ndIAM != '' && this.ndIAM != null){ 
                  const regex = /^(05|08)[0-9]{8}$/; // Y_MH begin B-28639 B-27481

                  if (regex.test(this.ndIAM)) {
                  console.log ('le numero NDIAM peut etre utilisé')
                  this.displayNDIAMchoice = false ; 
                  this.showNDInput = false ; 
                }else {
                  this.showMessage('Error', 'Le numéro doit commencer par 05 ou 08 et contenir exactement 10 chiffres', 'error');
              }}// Y_MH begin B-28639 end 
                else {
                  this.showMessage('Error', 'Numero de designation invalide ', 'error');
                }
              }
              else {
                this.showMessage('Error', 'Numero de designation existant', 'error');
              }
            }
            else {
              //  console.log('error');     
            }
          }
        })
        .catch(error => {
          window.console.log(error);
  
          this.isLoading = false;
        });
    }
    // ticket B-27481 Y_MH End

  lockMDN() {
    console.log('lockMDN called');
    this.isLoading = true;
    let mdn = this.__selectedmdnListItem;
    let input = '{"MDN": {"mdn": "' + mdn + '","lockToken": "' + this.orderid + '"}}';
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'Inwi_InwiB2C_LockMdn',
      options: '{}'
    };
    this.convertND(this.__selectedmdnListItem);
    // console.log('before call lockMDN' + JSON.stringify(params));


    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        if (response.error == false) {
          // console.log("response API" ,response);
          if (response.result) {
          //  console.log("response API" , response);
            this.displayMDNChoice = false;
          //  console.log("this.displayMDNChoice", this.displayMDNChoice);
          }
        }
      })
      .catch(error => {
        console.log('error');
        window.console.log(error);
      });

  }

OptionsChange() {
  if (this.isInfrastructureIAM === true) {
    if (this.typeAccesInternet === 'Fibre IAM') {
        this.statutLigne = 'active';
        // this.typeIdentifiant = '';
        this.displayMDNChoice = true ; 
        // this.displayNDIAMchoice = true ; 
        this.records = false ;
        this.showBoxNum = false ;
        this.ShowTypeIdentifiant = true ; // Y-MH  B-26441 
    } else {
        this.statutLigne = 'inactive';
        // this.typeIdentifiant = '';
        this.displayMDNChoice = true ; 
        // this.displayNDIAMchoice = true ; 
        this.records = false ;
        this.showBoxNum = false ;
        this.ShowTypeIdentifiant = false ;// Y-MH  B-26441 
        
    }
  }else if (this.isInfrastructureOrange === true) {

    if (this.typeAccesInternet === 'Fibre Orange') {
      this.statutLigne = 'active';
      // this.typeIdentifiant = '';
      this.displayMDNChoice = true ; 
      // this.displayNDIAMchoice = true ; 
      this.showBoxNum = false ;
      this.ShowTypeIdentifiant = true ; // Y-MH  B-26441 
  } else {
      this.statutLigne = 'inactive';
      // this.portabilite = '';
      // this.typeIdentifiant = '';
      this.displayMDNChoice = true ; 
      // this.displayNDIAMchoice = true ; 
      this.records = false ;
      this.showBoxNum = false ;
      this.ShowTypeIdentifiant = false ;// Y-MH  B-26441 
  }
}
    
    this.showNDInput = false;
    this.showInputLogin = false ; 
}

  // Partie IAM
  handleTypeAccesChange() {
    //this.typeAccesInternet = event.detail.value;
   // this.showBoxNum = false 
   this.typeIdentifiant = '';
   this.portabilite = '';
    this.displayNDIAMchoice = true ;
 this.OptionsChange() ; 
  if (this.typeAccesInternet === 'Aucun accès') {
  this.statutLigne = 'inactive';
  this.displayMDNChoice = true ; 
  // this.displayNDIAMchoice = true ; 
  this.records = false ;
  this.portabiliteOptions = [
    { label: 'Non', value: 'Non' }
];
  this.portabilite = 'Non'
  this.typeIdentifiant = 'ND'
  this.showBoxNum = true ;
  this.ShowTypeIdentifiant = false ;// Y-MH  B-26441 

} else {
  this.portabiliteOptions = [
    { label: 'Oui', value: 'Oui' },
    { label: 'Non', value: 'Non' }
  ];
}
  

   }

 ShowInputsNd() {
  this.updateLogin = true ; 
  if (this.portabilite === 'Oui'  && this.typeIdentifiant === 'ND') {
    // Y-MH porta oui , ligne incative il faut saisir un num et choisir un num 
    if (this.statutLigne === 'active' ) {
      if (this.nd !== '' && this.nd != null && this.nd != undefined ) {
         this.showNDInput = false; // ne pas afficher linput du nd quand cest une ligne active
      }else {
         this.showNDInput = true;
         this.displayMDNChoice = true ; 
      }
      // this.showNDInput = true; // ne pas afficher linput du nd quand cest une ligne active
      console.log("this.showBoxNumportaouiACTIVE", this.showBoxNum)
    }else if (this.statutLigne === 'inactive') {
      this.showNDInput = true;
      this.showBoxNum = true ;
      console.log("this.showBoxNumportaouiINACTIVE", this.showBoxNum)

    }
   

} else if (this.portabilite === 'Non' ) {
// ticket B-24470 Y_MH begin
  if (this.statutLigne === 'active') {
    if (this.typeIdentifiant === 'ND') {
      this.showBoxNum = true ;
        // this.showNDInput = true;
    }else if (this.typeIdentifiant === 'Login') {
      // this.showInputLogin = true ; 
      this.showBoxNum = true ;
      this.updateLogin = false ; 
    }
  } else if (this.statutLigne === 'inactive') {

    if (this.typeIdentifiant === 'ND') {
      this.showBoxNum = true ; 
      //console.log("this.showBoxNum", this.showBoxNum) ;
      //console.log("this.displayMDNChoice",  this.displayMDNChoice) ;
      //console.log("this.showNDInput",  this.showNDInput) ; 
    }
  }
  
  // ticket B-24470 Y_MH end

}else {
  this.showNDInput = false;
    this.showBoxNum = false;
    this.showInputLogin = false ;      
    console.log("this.showBoxNum", this.showBoxNum) ;
}
}

// Y-MH Operateur MSISDN doit etre en fonction de statut de la ligne et type d'acces a intenet 
SelectOIMSISDN () {
  this.OIMSISDN = '' ;
if (this.statutLigne === 'inactive') {
if (this.portabilite === 'Oui') {  // Porta oui on met a jour l'operateur sur MSISDN
  if (this.typeAccesInternet==='Fibre IAM' || this.typeAccesInternet==='ADSL IAM') {
    this.OIMSISDN = 'Maroc Telecom' ;
    console.log("this. OIMSISDN IAM IN", this.OIMSISDN)
  
  }else if (this.typeAccesInternet==='Fibre Orange' || this.typeAccesInternet==='ADSL Orange') {
    this.OIMSISDN = 'Orange' ;
    console.log("this. OIMSISDN Orange IN", this.OIMSISDN)
  
  }else if (this.typeAccesInternet==='Aucun accès') {
    this.OIMSISDN = '' ;
    console.log("this. OIMSISDN IN", this.OIMSISDN)
  }

}else if (this.portabilite === 'Non') { // Porta NON on insére vide  l'operateur sur MSISDN
  this. OIMSISDN = '' ;
  console.log("this. OIMSISDN IN POTANon", this. OIMSISDN) 
}

} else if (this.statutLigne === 'active') {
  if (this.typeAccesInternet==='Fibre IAM' ) {
  this.OIMSISDN = 'Maroc Telecom' ;
  console.log("this. OIMSISDN IAM AC", this.OIMSISDN)

}else if ( this.typeAccesInternet==='Fibre Orange') {
  this.OIMSISDN = 'Orange' ;
  console.log("this. OIMSISDN ORANGE AC", this.OIMSISDN)
}
} 
}
// Y-MH end
 
handlePortabiliteChange(event) {
  this.portabilite = event.detail.value;
  console.log("portabilité dans handlePortabiliteChange ", this.portabilite) ; 
   console.log("Statut de la ligne dans handlePortabiliteChange ", this.statutLigne) ; 
  
  this.showNDInput = false;
  this.showBoxNum = false ;
  this.showInputLogin = false ; 
 
 
  if (this.statutLigne !== 'active' ) {
    this.ndIAM = '' ; // ne pas reinisialiser quand c actif
     this.typeIdentifiant = ''; // ne pas reinisialiser c actif
     this.Login = '' ; // ne pas reinisialiser quand c actif
     this.disablelogin = false ; // ne pas reinisialiser quand c actif
     this.displayNDIAMchoice = true ;  // ne pas reinisialiser quand c actif
  }
 
  this.numND = '' ; 
  this.records = false ;
  this.__selectedmdnListItem = '' ;  // Y-MH
       
             
  this.OptionsChange() ;       

  if (this.isInfrastructureIAM === true && this.typeAccesInternet === 'Fibre IAM' && this.portabilite === 'Non' ) {

    //this.typeIdentifiant = '';
      // Afficher uniquement ND si portabilité = Oui
      
    //   this.identifiantLigneOptions = [
    //     { label: 'Numéro de désignation (ND)', value: 'ND' },
    //     { label: 'Login', value: 'Login' }
    // ];
      console.log("identifiantLigneOptions",this.identifiantLigneOptions) ;
      console.log("ShowTypeIdentifiant dans handlePortabiliteChange 1 ", this.ShowTypeIdentifiant) ;

  } else  {
     this.typeIdentifiant = 'ND'
    this.identifiantLigneOptions = [
      { label: 'Numéro de désignation (ND)', value: 'ND' },
  ];
   console.log("ShowTypeIdentifiant dans handlePortabiliteChange 1 ", this.ShowTypeIdentifiant) ;
  
  }
  this.ShowInputsNd();
  this.SelectOIMSISDN() ;
 
}

handleTypeIdentifiantChange(event) {
this.typeIdentifiant = event.detail.value;
this.showBoxNum = false ;
this.showInputLogin = false ; 
this.showNDInput = false;
this.displayMDNChoice = true ; 
this.displayNDIAMchoice = true ; 
this.records = false ;
this.ShowInputsNd();
}

  handleinputIAM(event) {
    this[event.target.name] = event.target.value;
  }

  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
        title: t,
        message: m,
        variant: type
    });
    this.dispatchEvent(toastEvt);
}
  next() {
    console.log('this.displayNDIAMchoice' , this.displayNDIAMchoice) ;
    console.log('this.ndIAM' ,this.ndIAM) ;
    // Vérification des champs pour Infrastructure Inwi
    if (this.isInfrastructureInwi === true) {
        if (
          this.nomsite!=null
          && this.nomsite!='' 
          && this.region !=null 
          && this.villeid!=null 
          && (this.quartier !=null || this.pquartier!=null) 
          && this.complementaddress !=null 
          && this.complementaddress !=''
           
         
        ) {
          //console.log('Tous les champs requis sont remplis');
          
          this.omniNextStep();
          
        }else {
         // console.log('Tous les champs requis sont pas remplis');
          this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
    
        }
    } 
    // Vérification des champs pour Infrastructure Orange ou IAM
     if (this.isInfrastructureOrange === true || this.isInfrastructureIAM === true) {
      
        if (
           this.nomsite!=null
           && this.nomsite!='' 
           && this.region !=null 
           && this.villeid!=null 
           && (this.quartier !=null || this.pquartier!=null) 
           && this.complementaddress !=null 
           && this.complementaddress !=''
           && (( this.displayNDIAMchoice == false &&  this.ndIAM !=null && this.ndIAM !='' )
           || ( this.numND != null && this.numND != ''  ) )
           && this.typeAccesInternet !=null 
           && this.typeAccesInternet !='' 
           && this.portabilite !=null 
           && this.portabilite !='' 
           && this.typeIdentifiant !=null 
           && this.typeIdentifiant !='' 
           &&  (this.typeIdentifiant !== 'Login' || (this.Login != null && this.Login != '')) 
           &&  (
            this.statutLigne !== 'active' || 
            this.portabilite !== 'Non' || 
            this.typeIdentifiant !== 'ND' || 
            (this.ndIAM != null && this.ndIAM != '' && this.numND != null && this.numND != '' && this.displayNDIAMchoice == false)) // Y_MH 26_05_2025 B-27481

            &&  (
              this.statutLigne !== 'inactive' || 
              this.portabilite !== 'Oui' || 
              this.typeIdentifiant !== 'ND' || 
              (this.ndIAM != null && this.ndIAM != '' && this.numND != null && this.numND != '' && this.displayNDIAMchoice == false )) // Y_MH 26_05_2025 B-27481

            &&  (
            this.statutLigne !== 'active' || 
            this.portabilite !== 'Oui' || 
            this.typeIdentifiant !== 'ND' || 
            (this.ndIAM != null && this.ndIAM != '' && this.displayNDIAMchoice == false)) // Y_MH 26_05_2025 B-27481

           
        ) {
         // console.log('Tous les champs requis sont remplis');
          this.omniNextStep();
             
        }else {
        //  console.log('Tous les champs requis sont pas remplis');
          this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
        }
    }
}

}