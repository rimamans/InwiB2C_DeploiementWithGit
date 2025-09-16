import { LightningElement, api, track, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_SiteADSLD2D.html";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { ingestDataConnector } from "lightning/analyticsWaveApi";

export default class inwiB2C_SiteADSLD2D extends OmniscriptBaseMixin(NavigationMixin(LightningElement))
{
  @api message;
  //chb ano B-21095 08/10/2024
  expriationDate;
  varclass = "slds-col slds-size_1-of-2 elementMargin2";
  numberrows = "1"
  valueStatus;
  numND;
  nomIAM;
  prenomIAM;
  nomSite;
  addIAM;
  addInwi;
  addressInstallation;
  //Flag
  Step1 = true;
  StatusDeg = false;
  StepDeg = false;
  flagSearch = true;
  flagPrecedent = false;
  FrequiredField = false;
  isLoading = false;
  isLoadinginModal = false;
  displayMDNChoice = true;
  demandeIAM = false;
  fshowDemandeSupport = false;
  FlagFinalisation = false;
  // FlagSuivant=false;
  fshowDemandeSupport = false;
  requalification = false;
  //declar Adresse
  valuePays = [];
  PaysValues = [];
  RegionValues = [];
  VilleValues = [];
  QuartierValues = [];
  labelSelectedQuartier;
  labelSelectedVille;
  isToSpecify = false;
  quartier;
  pquartier;
  @api codepostal;
  @api complementaddress;
  region;
  @api p;
  @api r;
  @track q;
  @api pq;
  @track v;
  villeid;
  __ismigration = false;
  _actionUtilClass;
  technoPorte;
  rli_vula;
  _ns = getNamespaceDotNotation();
  //var Account ,order,pos,distrib
  accountidSite;

  @api
  get serviceaccountid() {
    return this.__serviceaccountid;
  }
  set serviceaccountid(value) {
    this.__serviceaccountid = value;
  }

  @api
  get orderid() {
    return this.__orderid;
  }
  set orderid(value) {
    this.__orderid = value;
  }
  @api
  get pos() {
    return this.__pos;
  }
  set pos(value) {
    this.__pos = value;
  }
  @api
  get distrib() {
    return this.__distrib;
  }
  set distrib(value) {
    this.__distrib = value;
  }
  @api
  get username() {
    return this.__username;
  }
  set username(value) {
    this.__username = value;
  }
  @api
  get rootitemid() {
    return this.__rootitemid;
  }
  set rootitemid(value) {
    this.__rootitemid = value;
  }

  @api
  get profile() {
    return this.__profile;
  }
  set profile(value) {
    this.__profile = value;
  }
  __ville;
  @api
  get ville() {
    return this.__ville;
  }
  set ville(value) {
    this.__ville = value;
  }
  __quartier;
  @api
  get quartier() {
    return this.__quartier;
  }
  set quartier(value) {
    this.__quartier = value;
  }
  @api
  get villeid() {
    return this.__villeid;
  }
  set villeid(value) {
    this.__villeid = value;
  }
  // ano 10033 13/06/2023 CHB
  @api
  get ismigration() {
    return this.__ismigration;
  }
  set ismigration(value) {
    this.__ismigration = value;
  }
  //VAR ad IAM
  provinceValues;
  ProvinceVille;

  operationName;
  communeValues;
  CommuneV;

  QuartierIAM;
  QuartierValuesIAM;
  VoieValues;
  Voie;
  Numerovoie;
  NumerovoieValues;

  batiment;
  porte;
  etage;
  escalier;

  nra;
  nnra;
  distance;
  sectionMinimal;
  //label
  labelProvince;
  labelCommune;
  labelQuartier;
  labelVoie;
  labelNumVoie;
  //var search IAM
  __data = [];
  eligibleIAM = false;
  //var mdn search 
  mdnFilter = '';
  selectedmdn;
  __selectedmdnListItem = '';
  records;
  //numDes;
  mdn;
  //var de synchronisation
  synchronisation = true;
  //demande IAM
  Province;
  AdClient;
  FlagButtonSend = true;

  //PopUp
  @track isShowModal = false;
  //Eligibilty
  access_technology;
  id_nra_iam;
  __dataEliInterne = [];
  title;
  previous = false; // flag pour le cas bouton precedent 
  disablePrecedent = false; // pour cacher le bouton precedent dans le cas requalification d'adresse
  numerodesignation;
  statutdegroupage;
  nomsite;
  nomiam;
  prenomiam;
  @api
  get numerodesignation() {
    return this.__numerodesignation;
  }
  set numerodesignation(value) {
    this.__numerodesignation = value;
  }
  @api
  get statutdegroupage() {
    return this.__statutdegroupage;
  }
  set statutdegroupage(value) {
    this.__statutdegroupage = value;
  }
  @api
  get nomsite() {
    return this.__nomsite;
  }
  set nomsite(value) {
    this.__nomsite = value;
  }
  @api
  get nomiam() {
    return this.__nomiam;
  }
  set nomiam(value) {
    this.__nomiam = value;
  }
  @api
  get prenomiam() {
    return this.__prenomiam;
  }
  set prenomiam(value) {
    this.__prenomiam = value;
  }
  __adressename;
  @api
  get adressename() {
    return this.__adressename;
  }
  set adressename(value) {
    this.__adressename = value;
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

  get DisplayAdress() {
    return this.canal === "D2D"
  }

  //   get disablestatutdegroupage() {
  //     return !(this.canal === "eshop" || this.canal === "Televente");
  // }
  checkadslsitesynced
  @api
  get checkadslsitesynced() {
    return this.__checkadslsitesynced;
  }
  set checkadslsitesynced(value) {
    this.__checkadslsitesynced = value;
  }
  adressefactureiam
  @api
  get adressefactureiam() {
    return this.__adressefactureiam;
  }
  set adressefactureiam(value) {
    this.__adressefactureiam = value;
  }

  notdisplayiconloopadresse
  @api
  get notdisplayiconloopadresse() {
    return this.__notdisplayiconloopadresse
  }
  set notdisplayiconloopadresse(value) {
    this.__notdisplayiconloopadresse = value;
  }


  connectedCallback() {
    console.log('serviceAccount: ' + this.serviceaccountid);
    console.log('disablestatutdegroupage: ' + this.disablestatutdegroupage);
    console.log('checkadslsitesynced: ' + this.checkadslsitesynced);
    //chb 25/11/2024 ano B-21711 begin*/
    this.accountidSite = this.serviceaccountid;
   //chb 25/11/2024 ano B-21711 end*/
    this.v = this.ville;
    this.q = this.quartier;
    this.pquartier = this.pq;
    this.labelSelectedQuartier = this.quartier;
    this.labelSelectedVille = this.ville;
    this.numND = this.numerodesignation;
     this.valueStatus = this.statutdegroupage;
    this.nomIAM = this.nomiam;
    this.prenomIAM = this.prenomiam;
    this.nomSite = this.nomsite;
    this.addInwi = this.adressename;
    this.addressInstallation = this.addressinstallation;
    this.FlagSuivant = this.checkadslsitesynced;
    this.addIAM = this.adressefactureiam,
    this.FrequiredField = this.notdisplayiconloopadresse,
    this.requalification = this.checkadslsitesynced,
    this.StatusDeg = true;
    if( this.valueStatus=='Active'){
        this.StepDeg=true;
    }else{
        this.StepDeg=false;
        }  
    if (this.PaysValues.length == 0) {

      let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Pays__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'

      this.fetchPicklistValues('pays', inp)
    }
    this.valuePays = this.PaysValues.find(x => x.label === this.pays);
    if (this.RegionValues.length == 0) {
      let inpputRegion = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"InwiB2C_Region__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
      this.fetchPicklistValues('region', inpputRegion);
    }
    if (this.VilleValues.length == 0) {
      let inpputVille = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Country","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"\'\'","FilterOperator__c":"LIKE","InterfaceFieldAPIName__c":"Name","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Country:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{}}'
      this.fetchPicklistValues('ville', inpputVille);
    }
    // console.log('v',this.v);
    if (this.v != null) {
      // console.log('in this.v diff null');
      let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + this.villeid + '"}}';
      this.fetchPicklistValues('quartier', inp)
      this.isToSpecify = false;
    }
    // console.log('this.q',this.q);               
  }
  IdMaroc;
  fetchPicklistValues(picklist, input) {

    // console.log('start fetchPicklistValues')
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
          let value = {
            "label": 'Aucun élément',
            "value": "null"
          };
          rs.push(value);

        }
        else {
          rs = response.result.options.map((element) => {

            let temp = {}
            temp['label'] = element.value;
            temp['value'] = element.name;
            return temp;
          });
        }

        if (picklist === 'pays') {
          this.PaysValues = rs;
          let indexMaroc = this.PaysValues.findIndex(x => x.label === "Maroc");
          if (!this.p) {
          }


          if (this.valuePays == null)
            this.valuePays = this.PaysValues[indexMaroc].value;
          this.IdMaroc = this.PaysValues[indexMaroc].value;

          this.PaysValues.splice(0, 0, this.PaysValues.splice(indexMaroc, 1)[0]);


        }
        else if (picklist === 'region') {
          this.RegionValues = rs;
          let indexRegion = this.RegionValues.findIndex(x => x.label === this.r);
          this.region = this.RegionValues[indexRegion].value;
          // console.log('regionId',this.region);
        }
        else if (picklist === 'ville') {
          this.VilleValues = rs;
          // console.log('start picklist === ville  :')


          let t = rs.sort(function (a, b) {
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
          this.v = this.VilleValues.find(x => x.label === this.ville).value;
          let indexVille = this.VilleValues.findIndex(x => x.label === this.ville);
          this.villeid = this.VilleValues[indexVille].value;
          // console.log('this.villeid: ',this.villeid);
        }
        else if (picklist === 'quartier') {
          // console.log('in quartier pick');
          this.QuartierValues = rs;
          // console.log('in quartier pick',this.QuartierValues);
          if (this.QuartierValues[0].value == 'null') {
            // console.log('in quegalenull'); 
            this.isToSpecify = true;
            this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'Aucun élément à selectionner ';

          }
          else if (this.QuartierValues.length != 1) {

            // console.log('in quartierva <> null');
            this.isToSpecify = false;

            this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez un quartier ';
            let indexQuartier = this.QuartierValues.findIndex(x => x.label === this.quartier);
            this.quartier = this.QuartierValues[indexQuartier].value;
            this.q = this.QuartierValues[indexQuartier].value;
            //console.log('quartierid: ',this.quartier);
          }

        }
      })
      .catch(error => {
        //console.log('error : ' + error);
      });
  }

  ChangeRegion(event) {
    this.template.querySelector(`[data-theid="Quartier"]`).placeholder = 'sélectionnez une ville';
    this.region = event.detail.value;
    //console.log('this.region:',this.region);
    let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Villes","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Region Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"InwiB2C_Region__c","InterfaceObjectName__c":"inwiB2C_Ville__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Villes:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Region Name":"' + event.detail.value + '"}}';
    this.fetchPicklistValues('ville', inp)
  }
  setRegionInfo(idVille) {
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
        if (response.error == false) {
          let CityInfo = response.result.IPResult.theCity;
          // console.log('CityInfo: ')
          // console.log(CityInfo)
          // console.log('data-theid:Region.value : '+this.template.querySelector(`[data-theid="Region"]`).value)
          //console.log('response.result.IPResult.theCity.RegionName : '+response.result.IPResult.theCity.RegionName)
          this.regV = response.result.IPResult.theCity.RegionName;
          this.cityV = response.result.IPResult.theCity.CityName;
          this.r = response.result.IPResult.theCity.RegionName;
          this.region = response.result.IPResult.theCity.RegionId;
          this.labelSelectedRegion = response.result.IPResult.theCity.RegionName;
          this.template.querySelector(`[data-theid="Region"]`).value = response.result.IPResult.theCity.RegionName;
          // console.log('regionId: '+this.region);
        }

      })
      .catch(error => {
        console.log('error: ' + error);
      });
  }
  ChangeQuartier(event) {


    this.labelSelectedQuartier = this.QuartierValues.find(opt => opt.value === event.detail.value).label;
    this.quartier = event.detail.value;
    this.q = event.detail.value;
  }
  ChangePrecisionQuartier(event) {
    this.pquartier = event.detail.value;
  }
  ChangeVille(event) {
    let selectedvilleId = event.detail.value;
    this.v = event.detail.value;
    // console.log('selectedvilleId: ' + selectedvilleId);
    this.villeid = selectedvilleId;
    //console.log('id ville: '+ this.villeid);
    this.labelSelectedVille = this.VilleValues.find(opt => opt.value === event.detail.value).label;
    this.setRegionInfo(selectedvilleId)
    // console.log('selectedvilleId: ' + selectedvilleId)
    let inp = '{"MapItems":[{"DomainObjectFieldAPIName__c":"Quarties","InterfaceObjectLookupOrder__c":1,"FilterValue__c":"Ville Name","FilterOperator__c":"=","InterfaceFieldAPIName__c":"inwiB2C_Ville__c","InterfaceObjectName__c":"inwiB2C_Quartier__c"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Id","DomainObjectFieldAPIName__c":"name"},{"DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON","InterfaceFieldAPIName__c":"Quarties:Name","DomainObjectFieldAPIName__c":"value"}],"DRParams":{"Ville Name":"' + selectedvilleId + '"}}';
    this.fetchPicklistValues('quartier', inp)

  }
  handleChangeInputAdInwi(event) {

    this[event.target.name] = event.target.value;
    //console.log('nomsite ',this.nomsite );
  }
  //end Adress   
  //begin update Site ADSL SF
  updateAccount() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input;
    this.accountidSite = this.serviceaccountid;

    input = '{"idAccountsite":"' + this.accountidSite + '","regionId": "' + this.region + '","IdVille": "' + this.villeid + '","codepostale":"' + this.codepostal + '","complementadresse":"' + this.complementaddress + '","IdQuartier":"' + this.quartier + '","precisionquartier":"' + this.pquartier + '","nomsite":"' + this.nomSite + '","nomIAM":"' + this.nomIAM + '","prenomIAM":"' + this.prenomIAM + '","statutDegroupage":"' + this.valueStatus + '"}';//,"numND":"'+this.numND+'"
    //console.log('input update Account Site',input);
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_UpdateAdressSite",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        // console.log('responseupdateServiceAccount',response.result.IPResult);

        if (!response.error) {

          console.log('le compte est bien modifier');

        }

      })
      .catch(error => {
        window.console.log(error);
      });

  }
  //end update Site ADSL SF

  //end Create Site ADSL SF
  get options() {
    // ano 10033 13/06/2023 CHB
    if (this.ismigration) {
      //  console.log('in true');
      return [
        { label: "Inactive", value: "Inactive" }
      ];
    }
    else {
      // console.log('in else');
      return [
        { label: `Active`, value: "Active" },
        { label: "Inactive", value: "Inactive" },
      ];
    }
  }
  ChangeStatus(event) {
    this.numND = "";
    this.valueStatus = event.detail.value;
    // console.log('valueStatus',this.valueStatus);
    this.StatusDeg = true;
    if (this.valueStatus == 'Active') {
      this.StepDeg = true;
    } else {
      this.StepDeg = false;


    }

  }

  handleChangeInput(event) {
    this[event.target.name] = event.target.value;

  }

  //Begin Address IAM
  //GetAdressIAM

  fetchPicklistIAM(picklist) {
    let input;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    if (picklist == 'province') {
      input = '{"operation_name":"' + this.operationName + '"}';

    } else if (picklist == 'commune') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '"}';
      //  console.log('input',input);
    } else if (picklist == 'getQuartiers') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '"}';
      // console.log('input',input);
    } else if (picklist == 'getVoies') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '"}';
      //  console.log('input',input);
    } else if (picklist == 'getNumVoies') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '"}';
      //console.log('input',input);
    }
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_GetGeographiqueAddressAdsl",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        let rs = [];
        if (Object.keys(response.result.IPResult).length == 0) {
          let v = {
            "label": '',
            "value": ""
          };
          rs.push(v);

        }
        else {
          rs = response.result.IPResult.map((element) => {

            let temp = {}
            //   if (element.value == 'Maroc')
            temp['label'] = element.label;
            temp['value'] = element.code;
            return temp;
          });
        }

        if (picklist == 'province') {

          //  console.log('start picklist === province  :')

          this.provinceValues = rs;
          let t = rs.sort(function (a, b) {
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
        } else if (picklist == 'commune') {

          //   console.log('start picklist === commune  :')

          this.communeValues = rs;
            /*chb ano B-15501 15/04/2024 BEGIN */
          if (this.communeValues.length >= 1) {
            this.disableCommune = false;
          }
            /*chb ano B-15501 15/04/2024 end */
          let t = rs.sort(function (a, b) {
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

          //console.log('t :')
          //console.log(t)
        } else if (picklist == 'getQuartiers') {

          // console.log('start picklist === getQuartiers  :')

          this.QuartierValuesIAM = rs;
            /*chb ano B-15501 15/04/2024 BEGIN */
          if (this.QuartierValuesIAM.length >= 1) {
            this.disableQuartierIAM = false;
          }
            /*chb ano B-15501 15/04/2024 end */
          let t = rs.sort(function (a, b) {
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
          //console.log(t)
        } else if (picklist == 'getVoies') {

          //console.log('start picklist === getVoies  :')

          this.VoieValues = rs;
            /*chb ano B-15501 15/04/2024 BEGIN */
          if (this.VoieValues.length >= 1) {
            this.disableVoie = false;
          }
            /*chb ano B-15501 15/04/2024 end */
          let t = rs.sort(function (a, b) {
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

          //console.log('t :')
          //console.log(t)
        } else if (picklist == 'getNumVoies') {

          //console.log('start picklist === Numerovoie  :')

          this.NumerovoieValues = rs;
            /*chb ano B-15501 15/04/2024 BEGIN */
          if (this.NumerovoieValues.length >= 1) {
            this.disableNumVoie = false;
          }
            /*chb ano B-15501 15/04/2024 end */
          let t = rs.sort(function (a, b) {
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

          //console.log('t :')
          //console.log(t)
        }
      })
      .catch(error => {
        console.log('error : ' + error);
      });
  }
  InfoDegroupage() {

    //ANO 12324 CHB 24/11/2023 
    if (this.previous == false && this.ProvinceVille != null && this.Voie != null && this.Numerovoie != null && this.QuartierIAM != null && this.CommuneV != null) {
      // if (this.previous == false && this.ProvinceVille != null && this.Voie != null && this.QuartierIAM != null && this.CommuneV != null &&  this.ProvinceVille != '' && this.Voie !='' && this.QuartierIAM != '' && this.CommuneV != '') {
      this.flagSearch = true;
      this.disablePrecedent = true;
      this.requalification = true;
      //this.synchronisation=true;
    }
    //console.log('this.q',this.q);
    //console.log(this.v);
    //console.log(this.pq);
    //console.log(this.pquartier);
    // && this.q !=null && this.v!=null
    //console.log('this.valueStatus: ' + this.valueStatus + ' this.nomSite: ' + this.nomSite + ' this.q: '+  this.q+  ' this.pquartier: ' + this.pquartier);
    // if (this.valueStatus != null && this.nomSite != null && this.nomSite != '' && ((this.q != null && this.q != '') || (this.pquartier != '' && this.pquartier != null)) && this.v != null && this.v != '') {
    if (this.valueStatus == 'Inactive') {
      //console.log('in if');
      this.isShowModal = true;
      this.title = 'Recherche Adresse IAM';

      this.demandeIAM = false;
      this.eligibleIAM = false;

      this.FlagFinalisation = false;
      //console.log('this.valueStatus',this.valueStatus);
      this.flagPrecedent = true;
      this.operationName = 'getProvinces';
      this.fetchPicklistIAM('province');


    }
    else if (this.valueStatus == 'Active' && this.nomIAM != null && this.prenomIAM != null && this.nomIAM != '' && this.prenomIAM != '' && this.numND != null && this.numND != '') {


      function checkNumND(numND) {
        return /^05\d{8}$/.test(numND);
      }
      if (checkNumND(this.numND)) {
        //console.log('Le numéro de designation est au format valide.');
        this.demandeIAM = false;
        this.eligibleIAM = false;
        this.FlagFinalisation = false;
        // console.log('in elseif');
        this.checkND();
      }
      else {
        this.showMessage('Error', 'Numero de designation doit être au format 05XXXXXXXXX', 'error');
      }


    } else {
      //console.log('in else');
      this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
    }



  }
  Precedent() {
    this.Step1 = true;
    this.StatusDeg = false;
    this.valueStatus = '';
  }
  // CHB 05/02/24 ANO B-13991 BEGIN */
  searchResultsProvince;
  searchResultsCommune;
  searchResultsQuartierIAM;
  searchResultsVoie;
  searchResultsNumVoies;
  @track selectedSearchResultProvince;
  @track selectedSearchResultCommune;
  @track selectedSearchResultQuartierIAM;
  @track selectedSearchResultVoie;
  @track selectedSearchResultNumVoies;
  disableCommune = true;
  disableQuartierIAM = true;
  disableVoie = true;
  disableNumVoie = true;
  get selectedValueProv() {
    return this.selectedSearchResultProvince ? this.selectedSearchResultProvince.label : null;
  }
  get selectedValueComm() {
    return this.selectedSearchResultCommune ? this.selectedSearchResultCommune.label : null;
  }
  get selectedValueQuartierIAM() {
    return this.selectedSearchResultQuartierIAM ? this.selectedSearchResultQuartierIAM.label : null;
  }
  get selectedValueVoie() {
    return this.selectedSearchResultVoie ? this.selectedSearchResultVoie.label : null;
  }
  get selectedValueNumVoies() {
    return this.selectedSearchResultNumVoies ? this.selectedSearchResultNumVoies.label : null;
  }
  clearSearchResultsProvince() {
    this.searchResultsProvince = null;
  }
  clearSearchResultsCommune() {
    this.searchResultsCommune = null;
  }
  clearSearchResultsQuartierIAM() {
    this.searchResultsQuartierIAM = null;
  }
  clearSearchResultsVoie() {
    this.searchResultsVoie = null;
  }
  clearSearchResultsNumVoies() {
    this.searchResultsNumVoies = null;
  }
  positionClick;
  showPicklistOptionsProvince() {
    this.positionClick = 'ProvinceInput';
    if (!this.searchResultsProvince) {
      this.searchResultsProvince = this.provinceValues;
    }
    this.searchResultsCommune = null;
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.ProvinceVille = '';
    this.labelProvince = '';
  }
  showPicklistOptionsCommune() {
    if (!this.searchResultsCommune) {
      this.searchResultsCommune = this.communeValues;
    }
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.CommuneV = '';
    this.labelCommune = '';
  }
  showPicklistOptionsQuartierIAM() {
    if (!this.searchResultsQuartierIAM) {
      this.searchResultsQuartierIAM = this.QuartierValuesIAM;
    }
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.QuartierIAM = '';
    this.labelQuartier = '';
  }
  showPicklistOptionsVoie() {
    if (!this.searchResultsVoie) {
      this.searchResultsVoie = this.VoieValues;
    }
    this.searchResultsNumVoies = null;
    //chb ano B-14518 27/02/2024
    this.Voie = '';
    this.labelVoie = '';
  }
  showPicklistOptionsNumVoies() {
    if (!this.searchResultsNumVoies && this.NumerovoieValues.length >= 1) {
      this.searchResultsNumVoies = this.NumerovoieValues;
    }
    //chb ano B-14518 27/02/2024
    this.Numerovoie = '';
    this.labelNumVoie = '';
  }
  handleKeyPress(event) {
    if (event.key === 'Enter' || event.key === 'Return') {
      // Clear your list here
      this.searchResultsNumVoies = null;
    }
  }
  GetProvince(event) {
    //this.ProvinceVille= event.detail.value;
    // this.labelProvince=this.provinceValues.find(opt => opt.value === event.detail.value).label;
    //console.log('value: ',event.detail.value);
    // console.log('this.ProvinceVille: ' + this.ProvinceVille);
    //console.log('in getProvince');
/*chb ano B-14518 27/02/2024 begin */
this.ProvinceVille = '';
this.labelProvince = '';
this.CommuneV = '';
this.labelCommune = '';
this.labelQuartier = '';
this.QuartierIAM = '';
this.Voie = '';
this.labelVoie = '';
this.Numerovoie = '';
this.labelNumVoie = '';
this.disableCommune = true;
this.disableQuartierIAM = true;
this.disableVoie = true;
this.disableNumVoie = true;
this.communeValues = [];
this.QuartierValuesIAM = [];
this.flagSearch = true;
/*chb ano B-14518 27/02/2024 end */
    const input = event.detail.value.toLowerCase();
    const result = this.provinceValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsProvince = result;
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
  }
  selectSearchResultProv(event) {
    const selectedValueProv = event.currentTarget.dataset.value;
    this.selectedSearchResultProvince = this.provinceValues.find(
      (picklistOption) => picklistOption.value === selectedValueProv
    );
    this.ProvinceVille = selectedValueProv;
    // SOB 03/10/2025 Added control on Province input B-23528
    this.FlagButtonSend = !(this.ProvinceVille || this.AdClient);
    //console.log('this.ProvinceVille:',this.ProvinceVille);
    this.labelProvince = this.provinceValues.find(opt => opt.value === selectedValueProv).label;
    // console.log('this.ProvinceVilleLabel:',this.labelProvince);
    this.CommuneV = '';
    this.labelCommune = '';
    this.labelQuartier = '';
    this.QuartierIAM = '';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableCommune = true;
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.communeValues = [];
    this.QuartierValuesIAM = [];
    this.flagSearch = true;
    this.operationName = 'getCommunes';
    this.fetchPicklistIAM('commune');
    this.clearSearchResultsProvince();
  }
  GetCommune(event) {
    /*this.CommuneV= event.detail.value;
  
    this.labelCommune=this.communeValues.find(opt => opt.value === event.detail.value).label;
 
    console.log('this.CommuneV: ' + this.CommuneV);
    this.operationName='getQuartiers';
    this.fetchPicklistIAM('getQuartiers');*/
     /*chb ano B-14518 27/02/2024 begin */
     this.CommuneV = '';
     this.labelCommune = '';
     this.labelQuartier = '';
    this.QuartierIAM = '';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
    /*chb ano B-14518 27/02/2024 end */
    const input = event.detail.value.toLowerCase();
    const result = this.communeValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsCommune = result;

    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
    this.handleDocumentClick;
  }
  selectSearchResultCommune(event) {
    const selectedValueComm = event.currentTarget.dataset.value;
    this.selectedSearchResultCommune = this.communeValues.find(
      (picklistOption) => picklistOption.value === selectedValueComm
    );
    this.CommuneV = selectedValueComm;
    // console.log('this.CommuneV:',this.CommuneV);
    this.labelCommune = this.communeValues.find(opt => opt.value === selectedValueComm).label;
    //  console.log('this.CommuneLabel:',this.labelCommune);
    this.labelQuartier = '';
    this.QuartierIAM = '';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
    this.operationName = 'getQuartiers';
    this.fetchPicklistIAM('getQuartiers');
    this.clearSearchResultsCommune();
  }
  GetQuartier(event) {
    /* this.QuartierIAM= event.detail.value;
     this.labelQuartier=this.QuartierValuesIAM.find(opt => opt.value === event.detail.value).label;
 
     this.operationName='getVoies';
     this.fetchPicklistIAM('getVoies'); */
     /*chb ano B-14518 27/02/2024 begin */
    this.QuartierIAM = '';
    this.labelQuartier = '';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
     /*chb ano B-14518 27/02/2024 end */
    const input = event.detail.value.toLowerCase();
    const result = this.QuartierValuesIAM.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsQuartierIAM = result;
  }
  selectSearchResultQuartierIAM(event) {
    const selectedValueQuartierIAM = event.currentTarget.dataset.value;
    this.selectedSearchResultQuartierIAM = this.QuartierValuesIAM.find(
      (picklistOption) => picklistOption.value === selectedValueQuartierIAM
    );
    this.QuartierIAM = selectedValueQuartierIAM;
    //   console.log('this.QuartierIAM:',this.QuartierIAM);
    this.labelQuartier = this.QuartierValuesIAM.find(opt => opt.value === selectedValueQuartierIAM).label;
    //   console.log('this.labelQuartier:',this.labelQuartier);
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
    this.operationName = 'getVoies';
    this.fetchPicklistIAM('getVoies');
    this.clearSearchResultsQuartierIAM();
  }

  getVoies(event) {
    /*this.Voie= event.detail.value;
    this.labelVoie=this.VoieValues.find(opt => opt.value === event.detail.value).label;
 
    this.operationName='getNumVoies';
    this.fetchPicklistIAM('getNumVoies'); 
    this.flagSearch=false;
    this.labelNumVoie=null;
    this.Numerovoie=null;*/
    /*chb ano B-14518 27/02/2024 begin */
    /*chb ano B-B-14640 24/04/2024  */
    this.flagSearch = true;
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
 /*chb ano B-14518 27/02/2024 end */
    const input = event.detail.value.toLowerCase();
    const result = this.VoieValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsVoie = result;

  }
  selectSearchResultVoie(event) {
    const selectedValueVoie = event.currentTarget.dataset.value;
    this.selectedSearchResultVoie = this.VoieValues.find(
      (picklistOption) => picklistOption.value === selectedValueVoie
    );
    this.Voie = selectedValueVoie;
    //  console.log('this.Voie:',this.Voie);
    this.labelVoie = this.VoieValues.find(opt => opt.value === selectedValueVoie).label;
    //  console.log('this.labelQuartier:',this.labelVoie);
    this.disableNumVoie = true;
    this.operationName = 'getNumVoies';
    this.fetchPicklistIAM('getNumVoies');
    if(this.ProvinceVille!=''&& this.ProvinceVille!=null && this.ProvinceVille!=undefined && this.ProvinceVille!='undefined'
    && this.CommuneV!=''&& this.CommuneV!=null && this.CommuneV!=undefined && this.CommuneV!='undefined'
    && this.QuartierIAM!=''&& this.QuartierIAM!=null && this.QuartierIAM!=undefined && this.QuartierIAM!='undefined'
    && this.Voie!=''&& this.Voie!=null && this.Voie!=undefined && this.Voie!='undefined'){
    this.flagSearch = false;
  }else{
    this.flagSearch = true;
    this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
  }
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.clearSearchResultsVoie();
  }

  getNumVoies(event) {
    /* this.Numerovoie= event.detail.value;
     this.labelNumVoie=this.NumerovoieValues.find(opt => opt.value === event.detail.value).label;
     //CHB 23/11/2023 ano 12324
     this.flagSearch=false;
*/
  /*chb ano B-14518 27/02/2024 begin */
    this.Numerovoie = '';
    this.labelNumVoie = '';
  /*chb ano B-14518 27/02/2024 end */
    const input = event.detail.value.toLowerCase();
    const result = this.NumerovoieValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsNumVoies = result;
    this.flagSearch = false;

  }
  selectSearchResultNumVoies(event) {
    const selectedValueNumVoies = event.currentTarget.dataset.value;
    this.selectedSearchResultNumVoies = this.NumerovoieValues.find(
      (picklistOption) => picklistOption.value === selectedValueNumVoies
    );

    this.Numerovoie = selectedValueNumVoies;
    this.labelNumVoie = this.NumerovoieValues.find(opt => opt.value === selectedValueNumVoies).label;
    //  console.log('searchResultsNumVoies',this.NumerovoieValues.length);
    //  console.log('this.Numerovoie:',this.Numerovoie);
    //   console.log('this.labelNumVoie:',this.labelNumVoie);
    //CHB 23/11/2023 ano 12324
    this.flagSearch = false;
    //console.log('labelNumVoie',this.labelNumVoie);

    this.clearSearchResultsNumVoies();
  }
  // CHB 05/02/24 ANO B-13991 BEGIN */

  handleinputIAM(event) {
    this[event.target.name] = event.target.value;
  }

  //end address IAM
  //BEgin search address IAM
  @track columns = [
    { label: 'NRA de rattachement', fieldName: 'nra' },
    { label: 'NRA potentiel de raccordement', fieldName: 'nnra' },
    { label: 'Distance entre NRA et PC', fieldName: 'distance' },
    { label: 'Section câble', fieldName: 'sectionMinimal' }

  ];
  /*chb 06/05/2024 ano B-14640 begin*/
  checkFieldsIAM(){
    if(this.ProvinceVille!=''&& this.ProvinceVille!=null && this.ProvinceVille!=undefined && this.ProvinceVille!='undefined'
    && this.CommuneV!=''&& this.CommuneV!=null && this.CommuneV!=undefined && this.CommuneV!='undefined'
    && this.QuartierIAM!=''&& this.QuartierIAM!=null && this.QuartierIAM!=undefined && this.QuartierIAM!='undefined'
    && this.Voie!=''&& this.Voie!=null && this.Voie!=undefined && this.Voie!='undefined'){
    this.Search();
  }else{
    this.flagSearch = true;
    this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
  }
  }  /*chb 06/05/2024 ano B-14640 end*/
  Search() {
    this.FlagSuivant = false;
    this.isLoadinginModal = true;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input;
    if (this.valueStatus == 'Active') {
      input = '{"check_by":"Address","nd": "' + this.numND + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '","numway_code":"' + this.Numerovoie + '"}';
      //console.log('in search Active: ',input);
    }
    else {
      input = '{"check_by":"Address","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '","numway_code":"' + this.Numerovoie + '"}';
      //console.log('in searchvInactive : ',input);
    }
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CheckEligibiliteAdsl",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //console.log('response1',response);
        this.isLoadinginModal = false;
        if (!response.error) {
          if (response.result.IPResult && response.result.IPResult.characteristic) {
            let dataResult = response.result.IPResult.characteristic;
            let data = [];
            dataResult.map((item, index) => {
              // console.log(dataResult.length == 1);
              item.index = index;
              item.checked = dataResult.length == 1;
              data.push(item);
            })
            this.__data = data;
            this.eligibleIAM = true;
            this.flagPrecedent = false;
            this.Step1 = false;
            if (this.valueStatus == 'Active') {
              this.synchronisation = false;
              /*CHB ANo B-15870 07/05/2024 begin*/
              this.displayMDNChoice=false;
              /*CHB ANo B-15870 07/05/2024 end*/
            }
            this.hideModalBox();

            //console.log('in eligible');
            if (this.__data == null) {
              // console.log("vide pas de data");
            }

            this.updateAccount();



            this.showMessage('Succès', 'Le site est Eligible.', 'success');

            this.__data.forEach(currentItem => {

              this.nra = currentItem.nra;
              this.nnra = currentItem.nnra;
              this.distance = currentItem.distance;
              this.sectionMinimal = currentItem.sectionMinimal;
            });


          }//B-14614 chb 06/03/2024 BEGIN */
          else {
            this.isShowModal = true;
            this.__data = [];
            this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
            this.synchronisation = false;
          }//B-14614 chb 06/03/2024 end */
        } else {
          this.isShowModal = true;
          this.__data = [];
          this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
          this.synchronisation = false;
        }
      })
      .catch(error => {
        this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
        window.console.log(error);
        //  alert(error);
        this.isLoadinginModal = false;
      });
  }



  //end search address IAM

  //begin search MDN(Numero de designation)
  handleMdnFilterChange(event) {
    this.mdnFilter = event.target.value;
  }
  handleMdnSelection(event) {
    // console.log('selectedmdn:',this.selectedmdn);
    this.__selectedmdnListItem = event.detail.value;
  }
  getMdnList(event) {
    let input = '{"serviceAccount":"' + this.accountidSite + '","mdnType":"IMS", "offerType":"' + this.region + '", "category":"NORMAL", "mdn":"' + this.mdnFilter + '","lockToken":"' + this.orderid + '","nbrResult": 3, "rootItemId" : "' + this.rootitemid + '" }';

    // console.log('getMdnList : ' + JSON.stringify(input));
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

    //console.log('before call apex1' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        if (response.error == false) {
          ///console.log(response);

          if (response.result) {
            console.log(response);
            var returnOptions = [];
            this.isLoading = false;
            response.result.IPResult.forEach(ele => {
              returnOptions.push({ label: ele.mdn, value: ele.mdn });
            });
            this.records = returnOptions;


          }
        }
      })
      .catch(error => {
        //c//onsole.log('error');
        window.console.log(error);
        this.isLoading = false;
      });


  }



  lockMDN() {
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
    //console.log('before call lockMDN' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        if (response.error == false) {
          // console.log(response);

          if (response.result) {
            //console.log(response);
          }
        }
      })
      .catch(error => {
        // console.log('error');
        window.console.log(error);

      });
  }
  showmdn() {
    this.displayMDNChoice = false;
  }
  //select ND
  selectND() {
     /*chb ano B-15870 07/05/2024 begin */
     this.checkND();
     //this.convertND(this.__selectedmdnListItem);
     //this.showmdn();
     //this.synchronisation = false;
     /*chb ano B-15870 07/05/2024 end */
  }
  createND() {
    this.isLoading = true;

    // this.requalification=true;
    let mdn = this.__selectedmdnListItem;

    let input = '{ "addresseCompl1": "' + this.complementaddress + '", "addresseCompl2": "", "cityName": "' + this.labelSelectedVille + '", "countryName": "MAR", "creationDate": "2023-03-09T17:20:51.51Z[UTC]", "creationLogin": "hila.touiri", "districtName": "' + this.labelSelectedQuartier + '", "nameLabel": "MOHAMMED OMMOUR", "nd": "' + this.numND + '", "postalCode": "' + this.codepostal + '", "regionName": "' + this.r + '", "typeClient": "B2C" }';


    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_CreateND',
      options: '{}'
    };
    // console.log('before call createND' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //this.isLoading=false;
        //console.log(response);
        if (!response.error) {
          // console.log(response);

          if (response.result.IPResult.status == '1') {
            //console.log(response);
            this.synchronisation = false;
            this.updateND();


          } else {
            this.isLoading = false;
            this.showMessage('Message', response.result.IPResult.result.message, 'error');
            //console.log('result.IPResult.status',response.result.IPResult.result.message);
          }
        }
      })
      .catch(error => {
        //console.log('error');
        window.console.log(error);

      });
  }
  //end search mdn
  //begin synchronisation
   /* chb ano B-15870 07/05/2024 begin*/
  checkexistNDafterSynchroniseForCaseInactif=false;
   /* chb ano B-15870 07/05/2024 END*/
  Synchronise() {
    //this.synchronisation=true;
    //enable button synchronise after requalification adress 
    if (this.requalification == true) {
      this.synchronisation = false;
    }
    if (this.requalification == true || this.valueStatus == 'Active') {//update (status deg active ou dans le cas de qualification de l'adresse)
      this.updateND();
    } else {
      /* chb ano B-15870 07/05/2024 begin*/
      //this.createND();
      //this.previous = false;
     // console.log('in if requalification egale false');
     this.checkexistNDafterSynchroniseForCaseInactif=true;
     this.checkEligibilityInterne();
      /* chb ano B-15870 07/05/2024 end*/
    }


  }
  updateSF() {
      /* chb ano B-19085 24/09/2024 begin */
      let traceServiceInfoAPI = { 
        "accountidSite":this.accountidSite,
        "Service_Distance" :this.distance,
        "Service_id_nra_iam" : this.id_nra_iam,
        "Service_nnra" : this.nnra,
        "Service_nra" :this.nra ,
        "Service_Rli_VULA" :this.rli_vula ,
        "Service_SectionMinimal" :this.sectionMinimal,
        "Service_Technologie" : this.access_technology,
        "Service_TechnoPorte" : this.technoPorte
    }
    this.omniUpdateDataJson(traceServiceInfoAPI);
    this.omniSaveState(traceServiceInfoAPI,true);
     /* chb ano B-19085 24/09/2024 end */
    if (this.isToSpecify == false) {
      //console.log('in pq==vide');
      this.addInwi = "Maroc" + " " + this.r + " " + this.labelSelectedVille + " , " + this.labelSelectedQuartier;
    } else {
      //console.log('in pq!=vide');
      this.addInwi = "Maroc" + " " + this.r + " " + this.labelSelectedVille + " , " + this.pquartier;
    }
    this.isLoading = true;
    if (this.valueStatus == 'Active') {

      this.__selectedmdnListItem = this.numND;
    }

    //

    //let adress='|'+this.Numerovoie+'|;|'+this.Voie+';'+this.labelVoie+'|;|'+this.QuartierIAM+';'+this.labelQuartier+'|;|'+this.CommuneV+';'+this.labelCommune+'|;|'+this.ProvinceVille+';'+this.labelProvince+'|';
   
    this.porte=this.porte==null?'':this.porte=='undefined'?'':this.porte==undefined?'':this.porte;
    this.etage=this.etage==null?'':this.etage=='undefined'?'':this.etage==undefined?'':this.etage;
    this.batiment=this.batiment==null?'':this.batiment=='undefined'?'':this.batiment==undefined?'':this.batiment;
    this.escalier=this.escalier==null?'':this.escalier=='undefined'?'':this.escalier==undefined?'':this.escalier;
    this.prenomIAM=this.prenomIAM==null?'':this.prenomIAM=='undefined'?'':this.prenomIAM==undefined?'':this.prenomIAM;
    this.nomIAM=this.nomIAM==null?'':this.nomIAM=='undefined'?'':this.nomIAM==undefined?'':this.nomIAM;

    let adress = this.porte + '|' + this.etage + '|' + this.escalier + '|' + this.batiment + '|' + this.Numerovoie + ';' + this.labelNumVoie + '|' + this.Voie + ';' + this.labelVoie + '|' + this.QuartierIAM + ';' + this.labelQuartier + '|' + this.CommuneV + ';' + this.labelCommune + '|' + this.ProvinceVille + ';' + this.labelProvince;
    this.addIAM = adress;
    let input;
    if (this.valueStatus == 'Inactive') {
      this.convertND(this.__selectedmdnListItem);
      input = '{"ChoixNumero":"personnaliser le numéro","adresseIAM": "' + adress + '","idService": "' + this.accountidSite + '","ND":"' + this.numND + '","MSISDN_PORTED":"null","MSISDN":"' + this.__selectedmdnListItem + '","orderId":"' + this.orderid + '","flagEligible":true,"nra":"' + this.id_nra_iam + '","distance":"' + this.distance + '","sectionMinimal":"' + this.sectionMinimal + '","accesTechnology":"' + this.access_technology + '","statutDegroupage":"' + this.valueStatus + '","nomsite":"' + this.nomSite + '","technoPorte":"' + this.technoPorte + '","rli_vula":"' + this.rli_vula + '"}';
      //console.log("input: ",input);
    }
    else {
      this.convertNDto212(this.numND);
      input = '{"portaIn":true,"operator":"Maroc Telecom","ChoixNumero":"porter un numéro","adresseIAM": "' + adress + '","idService": "' + this.accountidSite + '","ND":"' + this.numND + '","MSISDN_PORTED":"' + this.mdn + '","MSISDN":"' + this.mdn + '","orderId":"' + this.orderid + '","flagEligible":true,"nra":"' + this.nnra + '","distance":"' + this.distance + '","sectionMinimal":"' + this.sectionMinimal + '","accesTechnology":"' + this.access_technology + '","statutDegroupage":"' + this.valueStatus + '","nomsite":"' + this.nomSite + '","technoPorte":"' + this.technoPorte + '","rli_vula":"' + this.rli_vula + '","nomIAM":"' + this.nomIAM + '","prenomIAM":"' + this.prenomIAM +'"}';
      // console.log("input: ",input);
    }


    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_UpdateAddressIAM',
      options: '{}'
    };



    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        if (response.error == false) {
          // console.log(response);

          if (response.result){
              // console.log(response);
              this.FlagSuivant = true;
              this.Step1 = true;
              if (this.valueStatus == 'Inactive' && this.requalification == false) {
                this.lockMDN();
              }else if(this.valueStatus == 'Active'){
                /*chb ano B-15870 07/05/2024*/
                this.displayMDNChoice=true;
              //chb 19/02/2024
              }
              this.requalification = true;
              this.disablePrecedent = true;
              this.varclass = "slds-col slds-size_1-of-1 elementMargin2";
              this.numberrows = "2";
            } 
        }
      })
      .catch(error => {
        //console.log('error');
        window.console.log(error);
        this.isLoading = false;
      });
  }
  updateND() {
    let input;

    /*chb 06/05/2024 ano B-15874 begin */
    this.nra=this.nra==null?'':this.nra=='undefined'?'':this.nra==undefined?'':this.nra;
    this.nnra=this.nnra==null?'':this.nnra=='undefined'?'':this.nnra==undefined?'':this.nnra;
    this.labelNumVoie=this.labelNumVoie==null ? '':this.labelNumVoie=='undefined'?'':this.labelNumVoie;
    this.codepostal=this.codepostal ==null?'':this.codepostal =='undefined'?'':this.codepostal;
    this.Etage=this.Etage==null?'':this.Etage=='undefined'?'':this.Etage;
    /*chb 06/05/2024 ano B-15874 end */
    //chb ano B-21095 08/10/2024 BEGIN */
    const currentDate = new Date().toISOString(); // Format: YYYY-MM-DDTHH:MM:SS.sssZ
    // ajouter un suffixe UTC comme "2025-03-23T16:18:30Z[UTC]"
    const currentDateUTC = currentDate.replace('Z', 'Z[UTC]');
    const expirationDateF = (this.expirationDate == null || this.expirationDate === '')?currentDateUTC: this.expirationDate; 
     //chb ano B-21095 08/10/2024 end */
    if (this.valueStatus == 'Active') {
      //input = '{"addresseCompl1":"' + this.complementaddress + '","addresseCompl2":"","buildingName":"SAPINO","buildingNum":"12","cableLength":"' + this.distance + '","cableSection":"' + this.sectionMinimal + '","cityName":"' + this.labelProvince + '","countryName":"Maroc","creationDate":"2022-08-25T23:10:51.51Z[UTC]","creationLogin":"abdo","degroupage":true,"districtName":"' + this.labelQuartier + '","expireDate":"2022-08-25T23:10:51.51Z[UTC]","flatNum":"8","floorNum":"' + this.Etage + '","freePortState":false,"lastUpdateDate":"2022-08-25T23:10:51.51Z[UTC]","nameLabel":"NameLabel","nd":"' + this.numND + '","neighborhood":"' + this.labelQuartier + '","nnraiam":"'+this.nnra+'","nraiam":"' + this.nra + '","panierId":"' + this.orderid + '","postalCode":"' + this.codepostal + '","regionName":"' + this.labelCommune + '","statusLine":"RESIL","streetNum": "' + this.labelNumVoie + '","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
      input = '{"addresseCompl1":"' + this.complementaddress + '","addresseCompl2":"","buildingName":"","buildingNum":"'+this.batiment+'","cableLength":"' + this.distance + '","cableSection":"' + this.sectionMinimal + '","cityName":"' + this.labelProvince + '","countryName":"Maroc","creationDate":"'+currentDateUTC+'","creationLogin":"abdo","degroupage":true,"districtName":"' + this.labelQuartier + '","expireDate":"'+expirationDateF+'","flatNum":"'+this.porte+'","floorNum":"' + this.Etage + '","freePortState":false,"lastUpdateDate":"'+currentDateUTC+'","nameLabel":"","nd":"' + this.numND + '","neighborhood":"' + this.labelQuartier + '","nnraiam":"'+this.nnra+'","nraiam":"' + this.nra + '","panierId":"' + this.orderid + '","postalCode":"' + this.codepostal + '","regionName":"' + this.labelCommune + '","statusLine":"RESIL","streetNum": "' + this.labelNumVoie + '","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
    } else {
      this.convertND(this.__selectedmdnListItem);
      //input = '{"addresseCompl1":"' + this.complementaddress + '","addresseCompl2":"","buildingName":"SAPINO","buildingNum":"12","cableLength":"' + this.distance + '","cableSection":"' + this.sectionMinimal + '","cityName":"' + this.labelProvince + '","countryName":"Maroc","creationDate":"2022-08-25T23:10:51.51Z[UTC]","creationLogin":"abdo","degroupage":false,"districtName":"' + this.labelQuartier + '","expireDate":"2022-08-25T23:10:51.51Z[UTC]","flatNum":"8","floorNum":"' + this.Etage + '","freePortState":false,"lastUpdateDate":"2022-08-25T23:10:51.51Z[UTC]","nameLabel":"NameLabel","nd":"' + this.numND + '","neighborhood":"' + this.labelQuartier + '","nnraiam":"'+this.nnra+'","nraiam":"' + this.nra + '","panierId":"' + this.orderid + '","postalCode":"' + this.codepostal + '","regionName":"' + this.labelCommune + '","statusLine":"RESIL","streetNum": "' + this.labelNumVoie + '","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
      input = '{"addresseCompl1":"' + this.complementaddress + '","addresseCompl2":"","buildingName":"","buildingNum":"'+this.batiment+'","cableLength":"' + this.distance + '","cableSection":"' + this.sectionMinimal + '","cityName":"' + this.labelProvince + '","countryName":"Maroc","creationDate":"'+currentDateUTC+'","creationLogin":"abdo","degroupage":false,"districtName":"' + this.labelQuartier + '","expireDate":"'+expirationDateF+'","flatNum":"'+this.porte+'","floorNum":"' + this.Etage + '","freePortState":false,"lastUpdateDate":"'+currentDateUTC+'","nameLabel":"","nd":"' + this.numND + '","neighborhood":"' + this.labelQuartier + '","nnraiam":"'+this.nnra+'","nraiam":"' + this.nra + '","panierId":"' + this.orderid + '","postalCode":"' + this.codepostal + '","regionName":"' + this.labelCommune + '","statusLine":"RESIL","streetNum": "' + this.labelNumVoie + '","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
    } //chb ano B-21095 08/10/2024 end */
    

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_SynchroniserRefAddress',
      options: '{}'
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        if (response.error == false) {
          //console.log(response);

          if (response.result) {
            //console.log(response);

            if (response.result.IPResult.status == '1') {
              this.checkexistNDafterSynchroniseForCaseInactif=false;
              this.checkEligibilityInterne();
              this.FrequiredField = true;

            }
            else {
              this.showMessage('Message', response.result.IPResult.result.message, 'error');
              //console.log('result.IPResult.status',response.result.IPResult.result.message);
            }

          }
        }
      })
      .catch(error => {

        //console.log('error');
        window.console.log(error);
      });
  }
  //end synchronisation

  //begin demande support IAM
  //SOB 07/03/2025 start B-23528
  handleInputDemande(event) {
    this.AdClient = event.target.value;

    this.FlagButtonSend = !(this.Province || this.AdClient);

    if (this.AdClient.includes("'") || this.AdClient.includes('"')) {
        this.showToast('Erreur', "L'adresse client ne doit pas contenir de guillemets (' ou \").", 'error');
        this.FlagButtonSend = true;
    }
  }
  handleProvince(event) {
    this.Province = event.target.value;
    this.FlagButtonSend = !(this.ProvinceVille || this.AdClient);
  }
  //chb B-23528 07/01/2025 begin*/
  handleKeyDownVilleSupport(event) {
    // Regex pattern for allowed characters
    const regex = /^['"]$/;

      const key = event.key;

      // Check if the key is a quote and prevent input unless it's a navigation key
      if (regex.test(key) && key !== 'Backspace' && key !== 'ArrowLeft' && key !== 'ArrowRight' && key !== 'Delete') {
          event.preventDefault();
      }
} //chb B-23528 07/01/2025 end*/
  demandeSuPIAM() {
    this.title = 'Demande Support IAM';
    this.fshowDemandeSupport = true;
    this.synchronisation = true;
    this.demandeIAM = true;

  }
  showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    this.dispatchEvent(event);
  }
  callAPIdemandeIAM() {

    if (!this.AdClient && !this.Province) {
      this.showToast('Erreur', 'Champ(s) manquant(s) : Adresse client et Province sont obligatoires.', 'error');
      return;
  }
  if (this.AdClient.includes("'") || this.AdClient.includes('"')) {
      this.showToast('Erreur', "L'adresse client ne doit pas contenir de guillemets (' ou \").", 'error');
      this.FlagButtonSend = true;
      return;
  }

    this.isLoadinginModal = true;
    
    let input = '{ "name": "' + this.AdClient + '","stateOrProvince": "' + this.ProvinceVille + '", "businessUnit": "' + this.distrib + '", "pos": "' + this.pos + '", "orderId": "' + this.orderid + '"}'
    //console.log("input: ",input);
    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_DemandeSupportAddressIAM',
      options: '{}'
    };



    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log('reponse.error',response.error);
        if (response.error == false) {
          console.log(response);
          console.log('in reponse.error');
          if (response.result.IPResult.status == "1") {
            //   console.log(response);
            
            this.FlagFinalisation = true;
            this.isLoadinginModal = false;
            this.demandeIAM = true;
          } 
          } else {
            this.showToast('Erreur API', response.result.IPResult.result.message || 'Une erreur est survenue lors de l’appel API.', 'error');
            this.isLoadinginModal = false;
          }
      })
      .catch(error => {
        // console.log('error');
        window.console.log(error);
        this.showToast('Erreur API', 'Échec de l’appel API. Vérifiez votre connexion.', 'error');           
        this.isLoadinginModal = false;
      });

  }
  Terminer() {

    if (this.profile != "Inwi POS") {
      this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
          "recordId": this.orderid,
          "objectApiName": "Order",
          "actionName": "view"
        },
      }, true);

    } //generate Link Community
    else {

      let url = "/PortailPDVPhase2/s/order/" + this.orderid;
      this[NavigationMixin.GenerateUrl]({
        type: "standard__webPage",
        attributes: {
          url: url,
        },
      }, true)
    }//then(generatedUrl => {
    //window.open(generatedUrl);
    // });


  }
  //end demande support IAM
  //show popup
  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
      title: t,
      message: m,
      variant: type
    });
    this.dispatchEvent(toastEvt);
  }
  //function convert ND
  convertND(nd) {
    this.numND = "0";
    this.numND += nd.substring(3, 14);
    console.log("myND: ", this.numND);
  }
  convertNDto212(nd) {
    this.mdn = "212";
    this.mdn += nd.substring(1, 14);
    console.log("myND: ", this.mdn);
  }
  next() {
   this.omniNextStep();
 } 
  handleCancel() {
    //chb ano B-14518 27/02/2024
    this.clearSearchResultsProvince();
    this.clearSearchResultsCommune();
    this.clearSearchResultsQuartierIAM();
    this.clearSearchResultsVoie();
    this.clearSearchResultsNumVoies();
    this.ProvinceVille = '';
    this.labelProvince = '';
    this.CommuneV = '';
    this.labelCommune = '';
    this.QuartierIAM = '';
    this.labelQuartier = '';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.batiment = '';
    this.escalier = '';
    this.etage = '';
    this.porte = '';
    this.disableCommune = true;
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.hideModalBox();
  }
  //chb ano B-14518 27/02/2024 end */
  hideModalBox() {
    this.isShowModal = false;
    this.fshowDemandeSupport = false;
    this.demandeIAM = false;
  }
  //begin check eligibility interne
  checkEligibilityInterne() {

    this.isLoading = true;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input;
    if (this.valueStatus == 'Active') {
      input = '{"nd": "' + this.numND + '"}';
    } else {

      input = '{"nd": "' + this.numND + '"}';

    }
    //console.log('check eligibilité interne: ',input);
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_eligibilityInterne",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //console.log('response1',response);
        this.isLoading = false;
        if (!response.error) {
          if (response.result.IPResult && response.result.IPResult.characteristic) {
            /*chb 07/05/2024 ANO B-15870 begin*/
            if(this.checkexistNDafterSynchroniseForCaseInactif==true){
              this.checkexistNDafterSynchroniseForCaseInactif=false;
              this.updateND();
            } /*chb 07/05/2024 ANO B-15870 end*/
            else{
            let dataResult = response.result.IPResult.characteristic;
            let data = [];
            dataResult.map((item, index) => {
              //console.log(dataResult.length == 1);
              item.index = index;
              item.checked = dataResult.length == 1;
              data.push(item);
            })
            this.eligibleIAM = true;
            this.flagPrecedent = false;
            this.flagSearch = true;
            this.Step1 = false;



            this.showMessage('Succès', 'Le site est éligible.', 'success');
            this.__dataEliInterne = data;
            this.__dataEliInterne.forEach(currentItem => {

              this.id_nra_iam = currentItem.id_nra_iam;
              this.access_technology = currentItem.access_technology;
              this.technoPorte = currentItem.technoPorte.replace('&', '');
              this.rli_vula = currentItem.rli_vula;
              //chb ano B-21095 08/10/2024
              this.expriationDate=currentItem.expirationDate;
            });
            // console.log('id_nra_iam: ',this.id_nra_iam);
            // console.log('access_technology: ',this.access_technology);


            this.updateSF();
          }}
          else {
              /*chb 07/05/2024 ANO B-15870 begin*/
            if(this.checkexistNDafterSynchroniseForCaseInactif){
              this.createND();
            }else{  /*chb 07/05/2024 ANO B-15870 end*/
            this.showMessage('Erreur', 'Le site non  éligible.', 'error');
            //console.log('result.IPResult.status',response.result.IPResult.result.message);
          }
        }
        }
      })
      .catch(error => {
        window.console.log(error);

        this.isLoading = false;
      });
  }

  //end check eligibility interne
  //begin Controle ND 
  checkND() {
    //console.log('in checkND');

    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input;
 /* chb ano B-15870 07/05/2024 begin */
 if(this.valueStatus=='Inactive'){
  input = '{"NumeroDeLaLigne": "' + this.__selectedmdnListItem + '"}';
}else{
    this.convertNDto212(this.numND);
    input = '{"NumeroDeLaLigne": "' + this.mdn + '"}';
  }
/* chb ano B-15870 07/05/2024 end */
   
    //console.log('checkCheckND: ',input);
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CheckND",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //console.log('response1',response);

        if (!response.error) {
          if (response.result.IPResult) {
            let countSub = response.result.IPResult.CountSub;
            if (countSub == '0') {
              /* chb ANO B-15870 07/05/2024 BEGIN */
              if(this.valueStatus=='Inactive'){
                this.convertND(this.__selectedmdnListItem);
                this.showmdn();
                this.synchronisation = false;
            }else{/* chb ANO B-15870 07/05/2024 end */
              this.title = 'Recherche Adresse IAM';
              this.isShowModal = true;

              //c//onsole.log('this.valueStatus',this.valueStatus);
              this.flagPrecedent = true;
              this.operationName = 'getProvinces';
              this.fetchPicklistIAM('province');

            }} else {
              this.showMessage('Error', 'Numero de designation Existant', 'error');
            }
          }
          else {
            //console.log('error');     
          }
        }
      })
      .catch(error => {
        window.console.log(error);

        this.isLoading = false;
      });
  }
  //end controle ND
  Previous() {

    if (this.requalification == true) {
      //console.log('in if req');
      this.FlagSuivant = false;
    } else {
      //console.log('in else');
      this.displayMDNChoice = true;
      this.mdnFilter = null;
      this.records = false;
      this.synchronisation = true;
    }
    this.previous = true;

    this.Step1 = true;
    this.eligibleIAM = false;

  }
  gotonextStep() {
    this.omniNextStep();
  }
  // chb 15/02/2024 Begin*/

  fshowPopupModif = false;
  handleOnClickModifier() {
    //console.log('handleOnClickModifier');
    this.fshowPopupModif = true;
    //console.log('FlagSuivant', this.FlagSuivant);
    //console.log('requalification', this.requalification);
  }
  hideModalBoxModif() {
    this.fshowPopupModif = false;
  }
  checkTraitementRollback(){
    if (this.valueStatus == 'Active') {
      this.rollbackSF();
    }else{
    this.handleDelete();
    }
  }
  handleDelete() {
    this.isLoading = true;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input = '{"nds":[ "' + this.numND + '" ]}';

    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_DeleteND",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //  console.log('response1',response);

        if (!response.error && response.result.IPResult) {
          this.liberationMDN();
          //console.log('in deleteND');
          // console.log('in deleteND response.result.IPResult', response.result.IPResult);
        } else {
          this.isLoading = false;
          this.showMessage('Error', 'Erreur lors de delete', 'error');
        }



      })
      .catch(error => {
        window.console.log(error);

        //  this.isLoading = false;
      });
  }
  liberationMDN() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.isLoading = true;
    let input = '{"lockToken":"' + this.orderid + '","mdn":"' + this.__selectedmdnListItem + '"}';
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwi_InwiB2_UnlockMdn",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //  console.log('response1',response);

        if (!response.error && response.result.IPResult) {

          //console.log('in liberationMDN');
          //console.log('in liberationMDN response.result.IPResult', response.result.IPResult);
          this.rollbackSF();
        } else {
          this.isLoading = false;
          this.showMessage('Error', response.result.IPResult.message, 'error');
        }



      })
      .catch(error => {
        window.console.log(error);

      });
  }

  rollbackSF() {
    this.isLoading = true;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input = '{"orderId":"' + this.orderid + '","OrderItem":"' + this.rootitemid + '","AccountId":"' + this.accountidSite + '"}';
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_RollbackInfoADSL_Site",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        if (!response.error && response.result.IPResult) {
          //console.log('in RollbackSF');
          this.rollbackVariables();
        } else {
          this.isLoading = false;
          this.showMessage('Error', response.result.IPResult.message, 'error');
        }
      })
      .catch(error => {
        window.console.log(error);

      });
  }
  rollbackVariables() {
    //console.log('in rollbackSF');
    this.Step1 = true;
    this.FlagSuivant = false;
    this.FrequiredField = false;
    this.fshowPopupModif = false;
    this.requalification = false;//Pour faire la creation au lieu de updateND
    this.valueStatus = '';
    this.StepDeg = '';
    this.numND = '';
    this.nomIAM = '';
    this.prenomIAM = '';
    this.nomSite = '';
    this.addIAM = '';
    this.addIAM = '';
    this.labelProvince = '';
    this.labelCommune = '';
    this.labelQuartier = '';
    this.labelVoie = '';
    this.labelNumVoie = '';
    this.batiment = '';
    this.escalier = '';
    this.etage = '';
    this.porte = '';
    //partie Recherche Adresse IAM
    this.disableCommune = true;
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    //partie search mdn 
    this.displayMDNChoice = true;
    this.mdnFilter = '';
    this.selectedmdn = '';
    this.__selectedmdnListItem = '';
    this.records = '';
    this.disablePrecedent = false;
    this.synchronisation = true;
    this.isLoading = false;

  }

}