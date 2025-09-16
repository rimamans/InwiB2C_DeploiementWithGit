import { LightningElement, api, track, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_DisplaySiteADSL.html";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

export default class inwiB2C_DisplaySiteADSL extends OmniscriptBaseMixin(NavigationMixin(LightningElement))
{
  @api accountid;
  numDes;
   //chb ano B-21095 08/10/2024
   expriationDate;
  @api message;
  // _records;
  _ns = getNamespaceDotNotation();
  __data = [];
  __dataNRA = [];
  _actionUtilClass;
  selectedIds;
  lstSelectedRecords;
  synchronisation = true;
  eligibleIAM = false;
  nra;
  nnra;
  statutdegroupage;
  showSearchIAM = true;
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
  Batimentvalues;
  batiment;

  porte;
  etage;
  escalier;

  nra = '';
  nnra = '';
  distance;
  sectionMinimal;
  //label
  labelProvince;
  labelCommune;
  labelQuartier;
  labelVoie;
  labelNumVoie; s
  //flag
  synEligible = false;
  displayMDNChoice = true;
  //PopUp
  @track isShowModal = false;
  //var mdn search 
  mdnFilter;
  selectedmdn;
  __selectedmdnListItem = '';
  records;
  numDes;
  flagStepMDN = false;
  mdn;
  //flag demande support IAM
  demandeIAM;
  synchronisation = true;
  fshowDemandeSupport = false;
  isLoadinginModal = false;
  //demande IAM
  Province;
  AdClient;
  FlagButtonSend = true;
  flagdisabletable = false;
  FlagFinalisation = false;
  //check elig interne
  access_technology;
  id_nra_iam = '';
  FlagSuivant = false;
  isLoading = false;
  ismigration = false;
  technoPorte;
  rli_vula;
  @api
  get rootitemid() {
    return this.__rootitemid;
  }
  set rootitemid(value) {
    this.__rootitemid = value;
  }
  @api
  get orderid() {
    return this.__orderid;
  }
  set orderid(value) {
    this.__orderid = value;
  }
  // ano 10033 13/06/2023 CHB
  @api
  get ismigration() {
    return this.__ismigration;
  }
  set ismigration(value) {
    this.__ismigration = value;
  }
  defaultSortDirection = 'asc';
  sortDirection = 'asc';
  sortedBy;
  title = '';
  region;
  ville;
  quartier;
  complementaddress;
  codepostal;
  datainfo = false;
  flagSearch = true;
  ShowButton = true;
  @track preSelectedRows = [];
  @api
  get profile() {
    return this.__profile;
  }
  set profile(value) {
    this.__profile = value;
  }
  @track columns = [
    { label: 'Adresse du site', fieldName: 'adresseIAM' },
    { label: 'Numéro de désignation', fieldName: 'ND', sortable: true },
    { label: 'Statut de dégroupage', fieldName: 'Statut', sortable: true },
    { label: 'Flag d’éligibilité', fieldName: 'eligibilite' }
  ];
  @api
  get list() {
    return this.__list;
  }
  set list(value) {
    this.__list = value;

  }
  sortBy(field, reverse, primer) {
    const key = primer
      ? function (x) {
        return primer(x[field]);
      }
      : function (x) {
        return x[field];
      };

    return function (a, b) {
      a = key(a);
      b = key(b);
      return reverse * ((a > b) - (b > a));
    };
  }

  onHandleSort(event) {
    const { fieldName: sortedBy, sortDirection } = event.detail;
    const cloneData = [...this.__data];

    cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
    this.__data = cloneData;
    this.sortDirection = sortDirection;
    this.sortedBy = sortedBy;
  }
  varExecute = true;
  connectedCallback() {
    //console.log('ismigration: '+this.ismigration);
    if (this.varExecute === true) {
      this.getRecords();
    }
  }
  getRecords() {
    this.varExecute = false;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input = '{"AccountId": "' + this.accountid + '","ismigration":' + this.ismigration + '}';
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_GetRecordADSL",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        // console.log('response1',response);
        if (!response.error) {
          //console.log("response.result.IPResult.listservice",response.result.IPResult.listservice);
          if (response.result.IPResult && response.result.IPResult.listservice) {
            this.datainfo = true;
            let dataResult = response.result.IPResult.listservice;
            let data = [];
            dataResult.map((item, index) => {
              // console.log(dataResult.length == 1);
              item.index = index;
              item.checked = dataResult.length == 1;
              data.push(item);
            })
            if (this.ismigration) {
              this.__data = data.filter(item => item.Statut == 'Inactive');
            }
            else {
              this.__data = data;
            }

            this.synchronisation = false;
            //   if(this.__data==null){
            //     console.log("vide pas de data");
            //   }
          }
          else {
            this.__data = [];
            this.datainfo = false;
          }
        }
      })
      .catch(error => {
        window.console.log(error);
      });
  }
  //getSelectedRec From Existing Sites
  getSelectedRec() {
    var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
    let ids = '';
    selectedRecords.forEach(currentItem => {
      ids = ids + ',' + currentItem.id;
      this.numDes = currentItem.ND;
      this.statutdegroupage = currentItem.Statut;
    });

    //selectedIds select id record site
    this.selectedIds = ids.replace(/^,/, '');
    // console.log('selectedIds are ', this.selectedIds);
    let my_ids = [];
    my_ids.push(this.selectedIds);
    this.preSelectedRows = my_ids;
    //console.log('this.numDes are ', this.numDes);
    // console.log(' this.statutdegroupage', this.statutdegroupage);
    this.synchronisation = false;
    if (this.statutdegroupage == 'Inactive') {
      this.showSearchIAM = false;
      this.synchronisation = true;
    } else {
      this.showSearchIAM = true;
      this.synchronisation = false;
    }
    this.FlagSuivant = false;
  }

  //begin check eligibilite interne
  checkEligibilityInterne() {
    this.isLoading = true;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    // this.synchronisation=false;
    //  this.numDes='0537326400';
    let input = '{"nd": "' + this.numDes + '"}';
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
        // console.log('response1',response);
        //this.isLoading = false;
        if (!response.error) {
          if (response.result.IPResult && response.result.IPResult.characteristic) {
               /*chb 07/05/2024 ANO B-15870 begin*/
            if(this.checkexistNDafterSynchroniseForCaseInactif==true){
              this.checkexistNDafterSynchroniseForCaseInactif=false;
              this.updateND();
            }else{/*chb 07/05/2024 ANO B-15870 end*/
            let dataResultE = response.result.IPResult.characteristic;
            let dataCh = [];
            dataResultE.map((item, index) => {
              //  console.log(dataResultE.length == 1);
              item.index = index;
              item.checked = dataResultE.length == 1;
              dataCh.push(item);
            })

            //this.__data = data;
            /*  this.eligibleIAM=true;
              this.flagPrecedent=false;
              this.flagSearch=true;
              this.Step1=false;*/
            this.synchronisation = true;



            this.showMessage('Succès', 'Le site est éligible.', 'success');

            dataCh.forEach(currentItem => {

              this.id_nra_iam = currentItem.id_nra_iam;
              this.access_technology = currentItem.access_technology;
              this.technoPorte = currentItem.technoPorte.replace('&', '');
              this.rli_vula = currentItem.rli_vula; // ano B-9848 CHB 21/06/2023
              //chb ano B-21095 08/10/2024
              this.expriationDate=currentItem.expirationDate;
            });
            // console.log('id_nra_iam: ',this.id_nra_iam);
            //  console.log('access_technology: ',this.access_technology);
            this.updateSF();

            /* if(this.synEligible==true){
               
               console.log('execute updateSF()');
               console.log('this.synEligible',this.synEligible);
              
             }*/
          }}
          else {
            /*chb 07/05/2024 ANO B-15870 begin*/
            if(this.checkexistNDafterSynchroniseForCaseInactif){
              this.createND();
            }else{/*chb 07/05/2024 ANO B-15870 end*/
            // this.isShowModal=true;
            //this.__data = [];
            this.synchronisation = true;
            this.isLoading = false;
            this.showMessage('Erreur', 'Le site est Non Eligible.', 'error');

          }}
        }
      })
      .catch(error => {
        window.console.log(error);
        //   alert(error);
        this.isLoading = false;
      });
  }
  //end check eligibilite interne
  /*chb 06/05/2024 ano B-14640 begin*/
  checkFieldsIAM(){
    if(this.ProvinceVille!=''&& this.ProvinceVille!=null && this.ProvinceVille!=undefined && this.ProvinceVille!='undefined'
    && this.CommuneV!=''&& this.CommuneV!=null && this.CommuneV!=undefined && this.CommuneV!='undefined'
    && this.QuartierIAM!=''&& this.QuartierIAM!=null && this.QuartierIAM!=undefined && this.QuartierIAM!='undefined'
    && this.Voie!=''&& this.Voie!=null && this.Voie!=undefined && this.Voie!='undefined'){
    this.checkEligibilite();
  }else{
    this.flagSearch = true;
    this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
  }
  }  /*chb 06/05/2024 ano B-14640 end*/
  checkEligibilite() {
    this.isLoadinginModal = true;

    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input;

    input = '{"check_by":"Address","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '","numway_code":"' + this.Numerovoie + '"}';
    //console.log('in searchvInactive : ',input);

    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CheckEligibiliteAdsl",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        // console.log('response1',response);
        this.isLoadinginModal = false;
        if (!response.error) {

          //  console.log("response.result.IPResultREc",response.result.IPResult.result.receivedMessage);
          //  console.log('receivedMessage',response.result.receivedMessage);
          //  console.log('receivedMessage IPResult :',response.result.IPResult.receivedMessage);
          if (response.result.IPResult && response.result.IPResult.characteristic) {
            let dataResult = response.result.IPResult.characteristic;
            // console.log( 'in charact',response.result.IPResult.characteristic);
            let data = [];
            dataResult.map((item, index) => {
              // console.log(dataResult.length == 1);
              item.index = index;
              item.checked = dataResult.length == 1;
              data.push(item);
            })
            this.__dataNRA = data;
            this.eligibleIAM = true;
            // if(this.__dataNRA==null){
            // console.log("vide pas de data");
            // }
            //this.omniUpdateDataJson({ "ListAdressIAM":  this.__dataNRA });
            this.__dataNRA.forEach(currentItem => {

              this.nra = currentItem.nra;
              this.nnra = currentItem.nnra;
              this.distance = currentItem.distance;
              this.sectionMinimal = currentItem.sectionMinimal;
            });
            //  console.log(' this.nra', this.nra);
            // console.log(' this.nnra', this.nnra);
            // console.log(' this.distance', this.distance);
            // console.log(' this.sectionMinimal', this.sectionMinimal);
            this.ShowButton = false;
            // this.lockMDN();
            //this.showMessage('Succès', 'Eligible.', 'success');
            // this.datainfo=false;
            this.hideModalBox();
            this.showSearchIAM = true;
            // this.updateSF();
            this.flagStepMDN = true;



          }

          else {
            //console.log('in non eligible');
            //this.eligibleIAM=false;
            this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');

            this.synchronisation = false;
            //this.__dataNRA = [];
            //this.eligibleIAM=false;

            // this.demandeIAM=true;
            // this.hideModalBox();
            // this.flagdisabletable=true;
            // this.flagStepMDN=true;
          }
        }  else {
          this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
          this.synchronisation = false;}
      })
      .catch(error => {
        window.console.log(error);
        this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
        //  alert(error);
        this.isLoading = false;
      });
  }
  @track columnsNRA = [
    { label: 'NRA de rattachement', fieldName: 'nra' },
    { label: 'NRA potentiel de raccordement', fieldName: 'nnra' },
    { label: 'Distance entre NRA et PC', fieldName: 'distance' },
    { label: 'Section câble', fieldName: 'sectionMinimal' }

  ];
  //begin search IAM
  fetchPicklistIAM(picklist) {
    let input;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    if (picklist == 'province') {
      input = '{"operation_name":"' + this.operationName + '"}';

    } else if (picklist == 'commune') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '"}';
      //console.log('input',input);
    } else if (picklist == 'getQuartiers') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '"}';
      //console.log('input',input);
    } else if (picklist == 'getVoies') {
      input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '"}';
      //console.log('input',input);
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

          // console.log('start picklist === province  :')

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

          // console.log('start picklist === commune  :')

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

          console.log('t :')
          console.log(t)
        } else if (picklist == 'getQuartiers') {

          //console.log('start picklist === getQuartiers  :')

          this.QuartierValuesIAM = rs;
            /*chb ano B-15501 15/04/2024 BEGIN */
          if (this.QuartierValuesIAM.length >= 1) {
            this.disableQuartierIAM = false;
          }
            /*chb ano B-15501 15/04/2024 ens */
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

          console.log('t :')
          console.log(t)
        } else if (picklist == 'getVoies') {

          // console.log('start picklist === getVoies  :')

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
          this.NumerovoieValues = rs;
            /*chb ano B-15501 15/04/2024 BEGIN */
          if (this.NumerovoieValues.length >= 1) {
            this.disableNumVoie = false;
          }
            /*chb ano B-15501 15/04/2024 end */
                        /*    
                        console.log('start picklist === Numerovoie  :')

                        
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
                            } );

                            console.log('t :')
                            console.log(t)
                        */}
      })
      .catch(error => {
        console.log('error : ' + error);
      });
  }
  InfoDegroupage() {
    if (this.ProvinceVille != null && this.Voie != null && this.Numerovoie != null && this.QuartierIAM != null && this.CommuneV != null) {
      this.flagSearch = false;

    }
    this.title = 'Recherche Adresse IAM';
    this.isShowModal = true;
    //console.log('this.valueStatus',this.valueStatus);
    // this.flagPrecedent=true;
    this.operationName = 'getProvinces';
    this.fetchPicklistIAM('province');
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
  showPicklistOptionsProvince() {
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
    /*chb ano B-14518 27/02/2024 begin */
    this.ProvinceVille='';
    this.labelProvince='';
    this.flagSearch = true;
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
    //console.log('this.ProvinceVilleLabel:',this.labelProvince);
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
     this.CommuneV ='';
     this.labelCommune ='';
     this.flagSearch = true;
     this.labelQuartier = '';
    this.QuartierIAM = '';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
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
    //console.log('this.CommuneV:',this.CommuneV);
    this.labelCommune = this.communeValues.find(opt => opt.value === selectedValueComm).label;
    // console.log('this.CommuneLabel:',this.labelCommune);
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
  selectSearchResultQuartierIAM(event)  {
    const selectedValueQuartierIAM = event.currentTarget.dataset.value;
    this.selectedSearchResultQuartierIAM = this.QuartierValuesIAM.find(
      (picklistOption) => picklistOption.value === selectedValueQuartierIAM
    );
    this.QuartierIAM = selectedValueQuartierIAM;
    //console.log('this.QuartierIAM:',this.QuartierIAM);
    this.labelQuartier = this.QuartierValuesIAM.find(opt => opt.value === selectedValueQuartierIAM).label;
    //console.log('this.labelQuartier:',this.labelQuartier);
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
    // this.Voie= event.detail.value;
    //this.labelVoie=this.VoieValues.find(opt => opt.value === event.detail.value).label;
    //this.operationName='getNumVoies';
    //this.fetchPicklistIAM('getNumVoies'); 
      /*chb ano B-14518 27/02/2024 begin */
      /*chb ano B-B-14640 24/04/2024  */
      this.flagSearch = true;
      this.Voie = '';
      this.labelVoie ='';
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
    //console.log('this.Voie:',this.Voie);
    this.labelVoie = this.VoieValues.find(opt => opt.value === selectedValueVoie).label;
    //console.log('this.labelQuartier:',this.labelVoie);
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
    //this.disableNumVoie = true;
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
      /*chb ano B-14518 27/02/2024 begin */
    const input = event.detail.value.toLowerCase();
    const result = this.NumerovoieValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsNumVoies = result;
  }
  selectSearchResultNumVoies(event) {
    const selectedValueNumVoies = event.currentTarget.dataset.value;
    this.selectedSearchResultNumVoies = this.NumerovoieValues.find(
      (picklistOption) => picklistOption.value === selectedValueNumVoies
    );
    this.Numerovoie = selectedValueNumVoies;
    this.labelNumVoie = this.NumerovoieValues.find(opt => opt.value === selectedValueNumVoies).label;
    //CHB 23/11/2023 ano 12324
    this.flagSearch = false;
    this.clearSearchResultsNumVoies();
  }
  handleinputIAM(event) {
    this[event.target.name] = event.target.value;
  }
  // CHB 05/02/24 ANO B-13991 END */
  //chb ano B-14518 27/02/2024 begin */
  handleCancel(){
    this.clearSearchResultsProvince();
    this.clearSearchResultsCommune();
    this.clearSearchResultsQuartierIAM();
    this.clearSearchResultsVoie();
    this.clearSearchResultsNumVoies();
    this.ProvinceVille = '';
    this.labelProvince='';  
    this.CommuneV ='';
    this.labelCommune ='';
    this.QuartierIAM = '';
    this.labelQuartier='';
    this.Voie = '';
    this.labelVoie ='';
    this.Numerovoie = '';
    this.labelNumVoie='';       
    this.batiment='';
    this.escalier='';
    this.etage='';
    this.porte='';
    this.disableCommune = true;
    this.disableQuartierIAM = true;
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.hideModalBox();
  } 
  //chb ano B-14518 27/02/2024 end */
  hideModalBox(){
    this.isShowModal = false;
    this.fshowDemandeSupport = false;
    this.demandeIAM = false;
  }
  //end search IAM
  //begin checkEligibilité

  //end checkEligibilité
  Suivant() {
    this.omniNextStep();
  }
  //show popup
  showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
      title: t,
      message: m,
      variant: type
    });
    this.dispatchEvent(toastEvt);
  }
  //begin search numero designation
  handleMdnFilterChange(event) {
    this.mdnFilter = event.target.value;
  }
  handleMdnSelection(event) {
    //console.log('selectedmdn:',this.selectedmdn);
    this.__selectedmdnListItem = event.detail.value;
    //console.log('__selectedmdnListItem:',this.__selectedmdnListItem);
  }
  getMdnList(event) {
    this.isLoading = true;
    // this.synchronisation=false;    
    this.orderId = '8010C0000016R9lQAE';
    let input = '{"mdnType":"IMS", "offerType":"Post", "category":"NORMAL", "mdn":"' + this.mdnFilter + '","lockToken":"' + this.orderId + '","nbrResult": 3, "rootItemId" : "' + this.rootitemid + '" }';

    console.log('getMdnList : ' + JSON.stringify(input));
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

    console.log('before call apex1' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        if (response.error == false) {
          console.log(response);

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
        console.log('error');
        window.console.log(error);
        this.isLoading = false;
      });


  }



  lockMDN() {
    this.isLoading = true;
    // this.synchronisation=false;
    this.convertNDto212(this.numDes);
    let mdn = this.mdn;
    //console.log('in getMdnlist');
    //this.convertND( this.__selectedmdnListItem);

    let input = '{"MDN": {"mdn": "' + mdn + '","lockToken": "' + this.orderid + '"}}';


    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'Inwi_InwiB2C_LockMdn',
      options: '{}'
    };

    //console.log('before call lockMDN' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        if (response.error == false) {
          //console.log(response);

          if (response.result) {
            //console.log(response);
            this.showmdn();
            //this.showmdn();  
            /* chb ANO 08/05/2024 begin */
            //this.createND();
            /* chb ANO 08/05/2024 end */
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
  getAdress() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input = '{"ServiceId": "' + this.selectedIds + '"}';
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_GetRecordADSL",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //console.log('response1',response);
        if (!response.error) {
          //console.log("response.result.IPResult.listAdressService",response.result.IPResult.listAdressService);
          if (response.result.IPResult && response.result.IPResult.listAdressService) {
            let dataResult = response.result.IPResult.listAdressService;
            let data = [];
            dataResult.map((item, index) => {
              //console.log(dataResult.length == 1);
              item.index = index;
              item.checked = dataResult.length == 1;
              data.push(item);
            })
            data.forEach(currentItem => {

              this.region = currentItem.regionName;
              this.ville = currentItem.villeName;
              this.quartier = currentItem.quartier;
              this.complementaddress = currentItem.complementAdress;
              this.codepostal = currentItem.codePostal;
            });
            if (this.__data == null) {
              console.log("vide pas de data");
            }
          }
          else {
            this.__data = [];
          }
        }
      })
      .catch(error => {
        window.console.log(error);
      });
  }
/* chb ANO B-15870 07/05/2024 BEGIN */
   //select ND
   selectND() {
    this.checkND();
  }
  
  //begin Controle ND 
  checkND(){
    //console.log('in checkND');

    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input = '{"NumeroDeLaLigne": "' + this.__selectedmdnListItem + '"}';
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CheckND",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        if (!response.error) {
          if (response.result.IPResult) {
            let countSub = response.result.IPResult.CountSub;
            if (countSub == '0') {
                this.convertND(this.__selectedmdnListItem);
                this.showmdn();
            } else {
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
  //end controle ND
   /* chb ano B-15870 07/05/2024 end */
  createND() {
    this.isLoading = true;
    // this.synchronisation=false;
    this.showmdn();
    let mdn = this.__selectedmdnListItem;
    //console.log('in getMdnlist');

    let input = '{ "addresseCompl1": "' + this.complementaddress + '", "addresseCompl2": "", "cityName": "' + this.ville + '", "countryName": "MAR", "creationDate": "2023-03-09T17:20:51.51Z[UTC]", "creationLogin": "hila.touiri", "districtName": "' + this.quartier + '", "nameLabel": "MOHAMMED OMMOUR", "nd": "' + this.numDes + '", "postalCode": "' + this.codepostal + '", "regionName": "' + this.region + '", "typeClient": "B2C" }';


    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_CreateND',
      options: '{}'
    };
    // this.convertND(this.__selectedmdnListItem);
    //console.log('before call createND' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.isLoading = false;
        console.log(response);
        if (response.error == false) {
          console.log(response);
          /*chb ano 07/05/2024 begin */
          if (response.result.IPResult.status == '1') {
            //    console.log(response);
            this.updateND();
          } else {
            this.isLoading = false;
            this.showMessage('Message', response.result.IPResult.result.message, 'error');
            //   console.log('result.IPResult.status',response.result.IPResult.result.message);
          }
        
        }/*chb ano 07/05/2024 end */
      })
      .catch(error => {
        //console.log('error');
        window.console.log(error);

      });
  }
  //end search numero designation

  //begin synchronise
  convertND(nd) {
    this.numDes = "0";
    this.numDes += nd.substring(3, 14);
    //console.log("myND: ",this.numDes);
  }
  convertNDto212(nd) {
    this.mdn = "212";
    this.mdn += nd.substring(1, 14);
    //console.log("myND: ",this.mdn);
  }
  checkexistNDafterSynchroniseForCaseInactif=false;
  Synchronise() {
    if (this.statutdegroupage == 'Inactive') {
      this.checkexistNDafterSynchroniseForCaseInactif=true;
      this.checkEligibilityInterne();
    }else{
    this.updateND();
    this.synEligible = true; // flag apres la synchronisation pr faire l'update en sf si eligible
    }
  }
  updateND() {
    let input;
    //this.username='chBANI'

    /*chb 06/05/2024 ano B-15874 begin */
    this.nra=this.nra==null?'':this.nra=='undefined'?'':this.nra==undefined?'':this.nra;
    this.nnra=this.nnra==null?'':this.nnra=='undefined'?'':this.nnra==undefined?'':this.nnra;
    this.labelNumVoie=this.labelNumVoie==null ? '':this.labelNumVoie=='undefined'?'':this.labelNumVoie;
    this.codepostal=this.codepostal ==null?'':this.codepostal =='undefined'?'':this.codepostal;
    this.Etage=this.Etage==null?'':this.Etage=='undefined'?'':this.Etage;
    /*chb 06/05/2024 ano B-15874 end */
      /*chb 06/05/2024 ano B-15874 end */
     //chb ano B-21095 08/10/2024 BEGIN */
     const currentDate = new Date().toISOString(); // Format: YYYY-MM-DDTHH:MM:SS.sssZ
     // ajouter un suffixe UTC comme "2025-03-23T16:18:30Z[UTC]"
     const currentDateUTC = currentDate.replace('Z', 'Z[UTC]');
     const expirationDateF = (this.expirationDate == null || this.expirationDate === '')?currentDateUTC: this.expirationDate; 
      //chb ano B-21095 08/10/2024 end */
    this.nnra = '';
       //chb ano B-21095 08/10/2024 BEGIN */
   // input = '{"addresseCompl1":"' + this.complementaddress + '","addresseCompl2":"Appart 34","buildingName":"SAPINO","buildingNum":"12","cableLength":"' + this.distance + '","cableSection":"' + this.sectionMinimal + '","cityName":"' + this.labelProvince + '","countryName":"Maroc","creationDate":"2022-08-25T23:10:51.51Z[UTC]","creationLogin":"abdo","degroupage":false,"districtName":"' + this.labelQuartier + '","expireDate":"2022-08-25T23:10:51.51Z[UTC]","flatNum":"8","floorNum":"' + this.Etage + '","freePortState":false,"lastUpdateDate":"2022-08-25T23:10:51.51Z[UTC]","nameLabel":"NameLabel","nd":"' + this.numDes + '","neighborhood":"' + this.labelQuartier + '","nnraiam":"' + this.nnra + '","nraiam":"' + this.nra + '","panierId":"' + this.orderid + '","postalCode":"' + this.codepostal + '","regionName":"' + this.labelCommune + '","statusLine":"RESIL","streetNum": "' + this.labelNumVoie + '","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
    input = '{"addresseCompl1":"' + this.complementaddress + '","addresseCompl2":"","buildingName":"","buildingNum":"'+this.batiment+'","cableLength":"' + this.distance + '","cableSection":"' + this.sectionMinimal + '","cityName":"' + this.labelProvince + '","countryName":"Maroc","creationDate":"'+currentDateUTC+'","creationLogin":"abdo","degroupage":false,"districtName":"' + this.labelQuartier + '","expireDate":"'+expirationDateF+'","flatNum":"'+this.porte+'","floorNum":"' + this.Etage + '","freePortState":false,"lastUpdateDate":"'+currentDateUTC+'","nameLabel":"","nd":"' + this.numDes + '","neighborhood":"' + this.labelQuartier + '","nnraiam":"'+this.nnra+'","nraiam":"' + this.nra + '","panierId":"' + this.orderid + '","postalCode":"' + this.codepostal + '","regionName":"' + this.labelCommune + '","statusLine":"RESIL","streetNum": "' + this.labelNumVoie + '","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
    //chb ano B-21095 08/10/2024 END */
   
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
            console.log(response);
            //this.synchronisation=true;
            if (response.result.IPResult.status == '1') {

              //alert('adresse IAM est bien mis a jour ');
              //this.showMessage('Message', 'Adresse IAM est bien mis a jour ', 'success');
              //this.Search();
              this.checkexistNDafterSynchroniseForCaseInactif=false;
              this.checkEligibilityInterne();

            }
            else {

              this.showMessage('Message', 'Probleme de synchronisation', 'error');
            }
            //console.log('result.IPResult.status',response.result.IPResult.status);

            //alert(response.result.IPResult.info.statusCode);  
            // Aucun ND n'est trouvé dans le référentiel avec la référence 0528209256
          }
        }
      })
      .catch(error => {
        //console.log('error');
        window.console.log(error);
        //alert('Adresse IAM est non synchronisé.'); 
      });
  }
  updateSF() {
     /* chb ano B-19085 24/09/2024 begin */
     let traceServiceInfoAPI = { 
      "accountidSite":this.selectedIds,
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
    if (typeof this.porte === 'undefined') {
      this.porte = ''
    } if (typeof this.etage === 'undefined') {
      this.etage = ''
    } if (typeof this.batiment === 'undefined') {
      this.batiment = ''
    } if (typeof this.escalier === 'undefined') {
      this.escalier = ''
    }
    let adress = this.porte + '|' + this.etage + '|' + this.escalier + '|' + this.batiment + '|' + this.Numerovoie + ';' + this.labelNumVoie + '|' + this.Voie + ';' + this.labelVoie + '|' + this.QuartierIAM + ';' + this.labelQuartier + '|' + this.CommuneV + ';' + this.labelCommune + '|' + this.ProvinceVille + ';' + this.labelProvince;

    //let adress='|'+this.Numerovoie+'|;|'+this.Voie+';'+this.labelVoie+'|;|'+this.QuartierIAM+';'+this.labelQuartier+'|;|'+this.CommuneV+';'+this.labelCommune+'|;|'+this.ProvinceVille+';'+this.labelProvince+'|';

    this.addIAM = adress;
    let input;
    this.convertNDto212(this.numDes);
    if (this.statutdegroupage == 'Inactive') {
      // ano B-9848 CHB 21/06/2023
      input = '{"ChoixNumero":"personnaliser le numéro","adresseIAM": "' + adress + '","idService": "' + this.selectedIds + '","ND":"' + this.numDes + '","MSISDN_PORTED":"null","MSISDN":"' + this.mdn + '","orderId":"' + this.orderid + '","flagEligible":true,"nra":"' + this.id_nra_iam + '","distance":"' + this.distance + '","sectionMinimal":"' + this.sectionMinimal + '","accesTechnology":"' + this.access_technology + '","statutDegroupage":"' + this.statutdegroupage + '","technoPorte":"' + this.technoPorte + '","rli_vula":"' + this.rli_vula + '"}';
    }

    else {

      input = '{"portaIn":true,"operator":"Maroc Telecom","ChoixNumero":"porter un numéro","idService": "' + this.selectedIds + '","ND":"' + this.numDes + '","MSISDN_PORTED":"' + this.mdn + '","MSISDN":"' + this.mdn + '","orderId":"' + this.orderid + '","flagEligible":true,"nra":"' + this.id_nra_iam + '","distance":"' + this.distance + '","sectionMinimal":"' + this.sectionMinimal + '","accesTechnology":"' + this.access_technology + '","statutDegroupage":"' + this.statutdegroupage + '","technoPorte":"' + this.technoPorte + '","rli_vula":"' + this.rli_vula + '"}';

    }
    //console.log('input:',input);

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_UpdateAddressIAM',
      options: '{}'
    };



    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        //this.isLoading = false;
        if (response.error == false) {
          //console.log(response);

          if (response.result) {
            // console.log(response);
            //this.synchronisation=true;  
            // this.showMessage('Succès', 'Adresse IAM est bien synchronisé.', 'success');
            // alert('Adresse IAM est bien synchronisé.');  
            if (this.statutdegroupage == 'Inactive') {
              this.lockMDN();
            }
             
            //this.updateND();
            this.FlagSuivant = true;
            this.isLoading=false;
            //this.Step1=true;
          }
        }
      })
      .catch(error => {
        //console.log('error');
        window.console.log(error);
        this.isLoading = false;
      });
  }
  //end synchronise
  //begin demande Support IAM
  //SOB 07/03/2025 start B-23528
  handleInputDemande(event) {
    
    this.AdClient = event.target.value;

    this.FlagButtonSend = !(this.Province || this.AdClient);

    if (this.AdClient.includes("'") || this.AdClient.includes('"')) {
        this.showToast('Erreur', "L'adresse client ne doit pas contenir de guillemets (' ou \").", 'error');
        this.FlagButtonSend = true;
    }
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
   
    // var adressIAM = this.labelProvince+" "+this.labelCommune+" "+this.labelQuartier+" "+this.labelVoie+" "+ this.labelNumVoie+" "+this.Porte+" "+this.Etage+" "+this.Escalier+" "+this.Batiment;
    //console.log("adressIAM: ",adressIAM);
    let input = '{ "name": "' + this.AdClient + '","stateOrProvince": "' + this.ProvinceVille + '", "businessUnit": "' + this.distrib + '", "pos": "' + this.pos + '", "orderId": "' + this.orderid + '"}'
    //console.log("input: ",input);
    //'{ "addresseCompl1": "'+this.complementaddress+'","buildingName": "SAPINO", "buildingNum": "12", "cityName": "'+this.cityV+'", "countryName": "Maroc", "degroupage": true, "districtName": "Sidi maaarouf", "expireDate": "2022-08-25T23:10:51.51Z[UTC]", "flatNum": "8", "floorNum": "3", "freePortState": false, "lastUpdateDate": "2022-08-25T23:10:51.51Z[UTC]", "nameLabel": "NameLabel", "nd": "0528209256", "neighborhood": "tacharouk", "nnraiam": "NNR-001", "nraiam": "NRA-02", "panierId": "PAN0436", "postalCode": "87252", "regionName": "Souss massa draa", "statusLine": "RESIL", "streetNum": "87", "typeClient": "B2C", "unreliable": false, "updateLogin": "abdessamad" }' 


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
        window.console.log(error);
        this.showToast('Erreur API', 'Échec de l’appel API. Vérifiez votre connexion.', 'error');           
        this.isLoadinginModal = false;
      });

  }//SOB 07/03/2025 end B-23528
  //end demande Support IAM
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
  Previous() {
    //ano 10034 13/06/2023 CHB
    this.numDes = null;
    this.displayMDNChoice = true;
    this.records = false;
    this.mdnFilter = null;
    this.flagdisabletable = false;
    this.eligibleIAM = false;
    this.datainfo = true;
    this.ShowButton = true;
    this.preSelectedRows = [];
    this.handleCancel();
  }
}