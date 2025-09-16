import { LightningElement, api, track, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class InwiB2C_EligibiliteADSL extends OmniscriptBaseMixin(NavigationMixin(LightningElement))
{
    @api message;
    //FLAG
    flagSearch = true;
    isLoadinginModal = false;
 //VAR ad IAM
 _ns = getNamespaceDotNotation();
 _actionUtilClass;
 provinceValues;
 ProvinceVille;
 __data = [];
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
requeteTrace;
responseTrace='';
statutEligibilite;
    connectedCallback() {
    this.operationName = 'getProvinces';
    this.fetchPicklistIAM('province');
    }
    fetchPicklistIAM(picklist) {
        let input;
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        if (picklist == 'province') {
          input = '{"operation_name":"' + this.operationName + '"}';
    
        } else if (picklist == 'commune') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '"}';
        } else if (picklist == 'getQuartiers') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '"}';
        } else if (picklist == 'getVoies') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '"}';
        } else if (picklist == 'getNumVoies') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '"}';
        
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
                
                temp['label'] = element.label;
                temp['value'] = element.code;
                return temp;
              });
            }
    
            if (picklist == 'province') {
    
       
    
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
    
             
            } else if (picklist == 'commune') {
    
              
    
              this.communeValues = rs;
              
              if (this.communeValues.length >= 1) {
                this.disableCommune = false;
              }
              
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
    
        
            } else if (picklist == 'getQuartiers') {
    
           
    
              this.QuartierValuesIAM = rs;
              
              if (this.QuartierValuesIAM.length >= 1) {
                this.disableQuartierIAM = false;
              }
             
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
    
              
            } else if (picklist == 'getVoies') {
    
            
    
              this.VoieValues = rs;
           
              if (this.VoieValues.length >= 1) {
                this.disableVoie = false;
              }
              
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
    
             
            } else if (picklist == 'getNumVoies') {
    
              
    
              this.NumerovoieValues = rs;
              
              if (this.NumerovoieValues.length >= 1) {
                this.disableNumVoie = false;
              }
               
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
    
       
            }
          })
          .catch(error => {
            console.log('error : ' + error);
          });
      }
      
  
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
  //positionClick;
  showPicklistOptionsProvince() {
    
    if (!this.searchResultsProvince) {
      this.searchResultsProvince = this.provinceValues;
    }
    this.searchResultsCommune = null;
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
  
    this.ProvinceVille = '';
    this.labelProvince='';
  }
  showPicklistOptionsCommune() {
    if (!this.searchResultsCommune) {
      this.searchResultsCommune = this.communeValues;
    }
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
   
    this.CommuneV ='';
    this.labelCommune ='';
  }
  
  showPicklistOptionsQuartierIAM() {
    if (!this.searchResultsQuartierIAM) {
      this.searchResultsQuartierIAM = this.QuartierValuesIAM;
    }
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
   
    this.QuartierIAM = '';
    this.labelQuartier='';
  }
  showPicklistOptionsVoie() {
    if (!this.searchResultsVoie) {
      this.searchResultsVoie = this.VoieValues;
    }
    this.searchResultsNumVoies = null;

     this.Voie = '';
     this.labelVoie ='';
  }
  showPicklistOptionsNumVoies() {
    if (!this.searchResultsNumVoies && this.NumerovoieValues.length >= 1) {
      this.searchResultsNumVoies = this.NumerovoieValues;
    }

    this.Numerovoie = '';
    this.labelNumVoie='';
  }
  handleKeyPress(event) {
    if (event.key === 'Enter' || event.key === 'Return') {
      // Clear your list here
      this.searchResultsNumVoies = null;
    }
  }
 
  GetProvince(event) {
 
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
    
    this.searchResultsProvince= this.provinceValues;
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
    this.labelProvince = this.provinceValues.find(opt => opt.value === event.currentTarget.dataset.value).label;
    const selectedValueProv = event.currentTarget.dataset.value;
    this.selectedSearchResultProvince = this.provinceValues.find(
      (picklistOption) => picklistOption.value === selectedValueProv
    );
    this.ProvinceVille = selectedValueProv;
    
    this.labelProvince = this.provinceValues.find(opt => opt.value === selectedValueProv).label;
    
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
    
    this.labelCommune = this.communeValues.find(opt => opt.value === selectedValueComm).label;
   
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
 
       this.QuartierIAM='';
       this.labelQuartier='';
    this.Voie = '';
    this.labelVoie = '';
    this.Numerovoie = '';
    this.labelNumVoie = '';
    this.disableVoie = true;
    this.disableNumVoie = true;
    this.flagSearch = true;
   
  
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
    
    this.labelQuartier = this.QuartierValuesIAM.find(opt => opt.value === selectedValueQuartierIAM).label;
  
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
   
     this.flagSearch = true;
     this.Voie = '';
     this.labelVoie ='';
     this.Numerovoie = '';
     this.labelNumVoie = '';

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
  
    this.labelVoie = this.VoieValues.find(opt => opt.value === selectedValueVoie).label;
    
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
  

    const input = event.detail.value.toLowerCase();
    const result = this.NumerovoieValues.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResultsNumVoies = result;
    this.flagSearch = false;

  }
  selectSearchResultNumVoies(event) {
 
    this.Numerovoie = '';
    this.labelNumVoie='';
    const selectedValueNumVoies = event.currentTarget.dataset.value;
    this.selectedSearchResultNumVoies = this.NumerovoieValues.find(
      (picklistOption) => picklistOption.value === selectedValueNumVoies
    );

    this.Numerovoie = selectedValueNumVoies;
    this.labelNumVoie = this.NumerovoieValues.find(opt => opt.value === selectedValueNumVoies).label;
  
    this.flagSearch = false;
    console.log('labelNumVoie', this.labelNumVoie);

    this.clearSearchResultsNumVoies();
  }
 
  handleinputIAM(event) {
    this[event.target.name] = event.target.value;
  }
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
  } 
  Search() {
   
    this.isLoadinginModal = true;
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input= '{"check_by":"Address","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '","numway_code":"' + this.Numerovoie + '"}';
    this.requeteTrace=input;
   
    
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CheckEligibiliteAdsl",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        this.responseTrace=response.result.IPResult;
        this.isLoadinginModal = false;
        if (!response.error) {
          if (response.result.IPResult && response.result.IPResult.characteristic) {
            let dataResult = response.result.IPResult.characteristic;
            let data = [];
            dataResult.map((item, index) => {
              
              item.index = index;
              item.checked = dataResult.length == 1;
              data.push(item);
            })
            this.__data = data;
            
            
            //this.responseTrace=this.__data;
           
            this.statutEligibilite='OK';
            this.createTrace();
            


            this.showMessage('Succès', 'Le site est Eligible.', 'success');

          


          }
          //CHB ANO B-14614 06/03/2024
          else{
           // this.isShowModal = true;
            this.statutEligibilite="ko";
            this.__data = [];
            this.createTrace();
            this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
            //this.synchronisation = false;
          }

        } else {
           this.statutEligibilite="KO";
          //this.isShowModal = true;
          this.__data = [];
          //console.log('in non eligible');
          this.createTrace();
          this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
          //this.synchronisation = false;
        }
      })
      .catch(error => {
        this.createTrace();
        this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
        window.console.log(error);
        //  alert(error);
        this.isLoadinginModal = false;
      });
  }
  createTrace(){
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    let input= '{"apiName":"TraceEligibiliteADSL","requestBody":' + this.requeteTrace + ',"responseAPI":' + JSON.stringify(this.responseTrace) + ',"statutAPI":"'+this.statutEligibilite+'"}';
     
    
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CreateTraceForEligibiliteADSL",
      options: "{}"
    };
    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
       
        this.isLoadinginModal = false;
        if (!response.error) {}
      })
      .catch(error => {
        this.isLoadinginModal = false;
        window.console.log(error);
      });
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

  next() {
    this.omniNextStep();
  }
}