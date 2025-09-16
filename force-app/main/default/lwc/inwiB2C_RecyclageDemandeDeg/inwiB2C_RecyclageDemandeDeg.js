import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_RecyclageDemandeDeg.html';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_RecyclageDemandeDeg extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
   // infoAdresse = [{0:"codePORTE|valPORTE"},{1:"codeETAGE|valETAGE"},{2:"codeESC|valESC"}];

    infoAdresse ={
        0: 'codePORTE|valPORTE',
        1: 'codeETAGE|valETAGE',
        2:'codeESC|valESC',
        3:'codeBAT|valBAT',
        4:'codeNVOIE|valNVOIE',
        5:'codeVOIE|valVOIE',
        6:'codeQUARTIER|valQUARTIER',
        7:'codeCCOM|valCCOM',
        8:'codeABVR_PERS|valABVR_PERS'
    };
    flagValider=false;
    flagSynchro=true;
    flagSearch=false;
    isLoadinginModal=false;
    showAddPropose=false;
    showAddIAM = false;
    showButtons=false;
    addIAMEmpty = false;
    nra;
    nnra;
    distance;
    sectionMinimal;
    @track codeRoutageList;
    codeRoutage;


    provinceValues = [];
    ProvinceVille;
    operationName;
    communeValues = [];
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
    //label
    labelProvince;
    labelCommune;
    labelQuartier;
    labelVoie;
    labelNumVoie;
    //final values
    provinceCodeFinal;
    provinceLabelFinal;
    communeCodeFinal;
    communeLabelFinal;
    quartierCodeFinal;
    quartierLabelFinal;
    voieCodeFinal;
    voieLabelFinal;
    nvoieCodeFinal;
    nvoieLabelFinal;
    adresseSiteFinal;
    batimentFinal;
    etageFinal;
    escalierFinal;
    
  
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
    /**MGEN3568 07/08/24 ILA Start*/
    @track mindate;
    @track maxdate;
    @track selector;
    @track disabled;
    dispSelectedDate;
    __showrendezvous;
    __minDateRecyclage
    @api
    get mindaterecyclage(){
      this.__minDateRecyclage
    }
    set mindaterecyclage(value){
      this.__minDateRecyclage=value;
    }
    __maxDateRecyclage
    @api
    get maxdaterecyclage(){
      this.__maxDateRecyclage
    }
    set maxdaterecyclage(value){
      this.__maxDateRecyclage=value;
    }
    @api
    get showrendezvous(){
      this.__showrendezvous;
  }
  set showrendezvous(value){
      this.__showrendezvous= value;
  }
  __holidays = []
  @api
  get holidays(){
    this.__holidays
  }
  set holidays(value){
    this.__holidays=value;
  }
    /**MGEN3568 07/08/24 ILA end*/
    __demande;
    @api
    get demande(){
        this.__demande;
    }
    set demande(value){
        this.__demande = value;
    }
    __degnum;
    @api
    get degnum(){
        this.__degnum;
    }
    set degnum(value){
        this.__degnum = value;
    }
    __recycleerreur;
    @api
    get recycleerreur(){
        this.__recycleerreur;
    }
    set recycleerreur(value){
        this.__recycleerreur = value;
    }
    adresseSplitee = {};
    //adresseSplitee = new Map();
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    setcodeRoutage(){
        let codes= [
            { label: 'E2101', value: 'E2101' },
            { label: 'E3101', value: 'E3101' },
        ];
        this.codeRoutageList = codes;
        this.codeRoutage = this.__demande.InwiB2C_codeRoutage__c;
     }

     handleSelection(event){
        this.codeRoutage= event.detail.value;}



    get isCT(){
      if(this.__demande.InwiB2C_typeCommande__c	== 'CT')
        return true
      else
        return false
    }
    splitAdresse(){
        if(this.__demande.InwiB2C_AdresseIAMProposee__c){
        let adresse = this.__demande.InwiB2C_AdresseIAMProposee__c.split('|');
        let tmp1;
        let tmp2;
        //console.log(adresse[0].substring(0,adresse[0].indexOf(';')));
       // console.log(adresse[0].substring(adresse[0].indexOf(';')+1,adresse[0].length));
       for (let [key, value] of Object.entries(this.infoAdresse)){
        //console.log('test',adresse[key]);
        tmp1=value.split('|');
        if(adresse[key]==undefined){
            for(let i = 0; i < 2; i++){
                this.adresseSplitee[tmp1[i]]="";
            }
        }
        else if(adresse[key].indexOf(';')==-1){
            this.adresseSplitee[tmp1[0]]="";
            this.adresseSplitee[tmp1[1]]=adresse[key];
        }
        else{
            tmp2=adresse[key].split(';');
            for(let i = 0; i < 2; i++){
                this.adresseSplitee[tmp1[i]]=tmp2[i];
            }
        }

            
       }
       //this.omniUpdateDataJson({ 'adresseSplitee':JSON.stringify(this.adresseSplitee)});
       //console.log('test',this.adresseSplitee);
    }
    }

    connectedCallback(){
        this.addIAMEmpty = this.__demande.InwiB2C_AdresseIAMProposee__c === undefined ? false : true;
        this.operationName = 'getProvinces';
        this.setcodeRoutage();
    }
    showMessage(t, m, type) {
        const toastEvt = new ShowToastEvent({
            title: t,
            message: m,
            variant: type
        });
        this.dispatchEvent(toastEvt);
      }
    handleinputIAM(event){
        this[event.target.name] = event.target.value;
      }
    Search(){
        if(this.showAddIAM== true &&(this.ProvinceVille==null || this.Voie==null || this.Numerovoie==null || this.QuartierIAM==null || this.CommuneV==null)){
            this.showMessage('Erreur','Champs Obligatoires Manquants','error');
            //alert('Champs Obligatoires Manquants');
        }
        else{
            //set final values
            this.provinceCodeFinal = this.showAddPropose == true ? this.adresseSplitee.codeABVR_PERS : this.ProvinceVille;
            this.communeCodeFinal = this.showAddPropose == true ? this.adresseSplitee.codeCCOM : this.CommuneV;
            this.quartierCodeFinal = this.showAddPropose == true ? this.adresseSplitee.codeQUARTIER : this.QuartierIAM;
            this.voieCodeFinal = this.showAddPropose == true ? this.adresseSplitee.codeVOIE : this.Voie;
            this.nvoieCodeFinal = this.showAddPropose == true ? this.adresseSplitee.codeNVOIE : this.Numerovoie;
            this.provinceLabelFinal = this.showAddPropose == true ? this.adresseSplitee.valABVR_PERS : this.labelProvince;
            this.quartierLabelFinal = this.showAddPropose == true ? this.adresseSplitee.valQUARTIER : this.labelQuartier;
            this.communeLabelFinal = this.showAddPropose == true ? this.adresseSplitee.valCCOM : this.labelCommune;
            this.nvoieLabelFinal = this.showAddPropose == true ? this.adresseSplitee.valNVOIE : this.labelNumVoie;
            this.voieLabelFinal = this.showAddPropose == true ? this.adresseSplitee.valVOIE : this.labelVoie;
            let adresseTMP = '';
           if(this.showAddIAM == true){
                if(typeof this.porte === 'undefined'){
                    this.porte=''
                  }
                  if(typeof this.etage==='undefined'){
                    this.etage=''
                  } if(typeof this.batiment==='undefined'){
                    this.batiment=''
                  } if(typeof this.escalier==='undefined'){
                    this.escalier=''
                  }
                adresseTMP=this.porte+'|'+this.etage+'|'+this.escalier+'|'+this.batiment+'|'+this.Numerovoie+';'+this.labelNumVoie+'|'+this.Voie+';'+this.labelVoie+'|'+this.QuartierIAM+';'+this.labelQuartier+'|'+this.CommuneV+';'+this.labelCommune+'|'+this.ProvinceVille+';'+this.labelProvince;
            }
            this.adresseSiteFinal = this.showAddPropose == true ? this.__demande.InwiB2C_AdresseIAMProposee__c : adresseTMP;
            this.batimentFinal = this.showAddPropose == true ? this.adresseSplitee.valBAT : this.batiment;
            this.etageFinal = this.showAddPropose == true ? this.adresseSplitee.valETAGE : this.etage;
            this.escalierFinal = this.showAddPropose == true ? this.adresseSplitee.valESC : this.escalier;
            

            //call VIP
            this.isLoadinginModal=true;
            this._actionUtilClass = new OmniscriptActionCommonUtil();
            let vipInput;
            if( this.__demande.InwiB2C_StatutLigneIam__c=='Ligne active'){
                vipInput ='{"check_by":"Address","nd": "'+this.__demande.InwiB2C_NumeroDesignation__c+'","city_code":"'+this.provinceCodeFinal+'","municipality_code":"'+this.communeCodeFinal+'","district_code":"'+this.quartierCodeFinal+'","way_code":"'+this.voieCodeFinal +'","numway_code":"'+this.nvoieCodeFinal+'"}';
            console.log('input Active: ',vipInput);}
            else{
                vipInput ='{"check_by":"Address","city_code":"'+this.provinceCodeFinal+'","municipality_code":"'+this.communeCodeFinal+'","district_code":"'+this.quartierCodeFinal+'","way_code":"'+this.voieCodeFinal +'","numway_code":"'+this.nvoieCodeFinal+'"}';
                console.log('input Inactive : ',vipInput);
            }
            const params = {
                input: vipInput,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_CheckEligibiliteAdsl",
                options: "{}"
            };
            this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('response',JSON.stringify(response));
            this.isLoadinginModal=false;
            if (response.result.IPResult.result && response.result.IPResult.result.status==0) {
                this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
                 //alert('Cette adresse est introuvable');
            }
            else{
                if(response.result.IPResult.characteristic){
                    let dataResult = response.result.IPResult.characteristic;
                    let data = [];
                    dataResult.map((item, index) => {
                        item.index = index;
                        item.checked = dataResult.length == 1;
                        data.push(item);
                    })
                    data.forEach(currentItem => {
                                
                        this.nra=currentItem.nra;
                        this.nnra=currentItem.nnra;
                        this.distance=currentItem.distance;
                        this.sectionMinimal=currentItem.sectionMinimal;
                    });
                    this.updateSF();
                    this.showMessage('Succès', 'Adresse OK', 'success');
                    //alert('Adresse ok');
                    this.flagSynchro=false;
                    this.flagSearch=true;
                }
                
          }
        
        }

          ).catch(error => {
            this.showMessage('Erreur', 'Cette adresse est introuvable', 'error');
            //alert('Cette adresse est introuvable');
              console.log('error search ',error);
              this.isLoadinginModal=false;
          }); 
        }
            

    }
    updateSF(){
        //mettre a jour l'adresse du site
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        let vipInput='{"site":"'+this.__demande.InwiB2C_Site__c+'","adresse":"'+ this.adresseSiteFinal+'"}';
        console.log('updateSF: ',vipInput);
        const params = {
            input: vipInput,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_UpdateAddressIAMRecyclage',
            options: '{}'
        };
        this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
        this.isLoading=false; 
          if (response.error == false) {
              console.log('updateSFNOK: ',response);
          }
          else
          console.log('updateSFOK: ',response);
      })
      .catch(error => {
          console.log('error');
          window.console.log('updateSFNOK1: ',error);
          this.isLoading=false;
      });
    }

    Synchronise(){
        this.isLoadinginModal=true;
        let vipInput;
        if(this.nnra=='undefined' || this.nnra==undefined){
            this.nnra=''
        }
        if(this.__demande.InwiB2C_StatutLigneIam__c=='Ligne active'){
            //VIPinput=  '{"addresseCompl1":"'+this.__adresseIam+'","addresseCompl2":"","buildingName":"SAPINO","buildingNum":"12","cableLength":"'+this.distance+'","cableSection":"'+this.sectionMinimal+'","cityName":"'+this.labelProvince+'","countryName":"Maroc","creationDate":"2022-08-25T23:10:51.51Z[UTC]","creationLogin":"abdo","degroupage":true,"districtName":"'+this.labelQuartier+'","expireDate":"2022-08-25T23:10:51.51Z[UTC]","flatNum":"8","floorNum":"'+this.Etage+'","freePortState":false,"lastUpdateDate":"2022-08-25T23:10:51.51Z[UTC]","nameLabel":"NameLabel","nd":"'+this.numND+'","neighborhood":"'+this.labelQuartier+'","nnraiam":"","nraiam":"'+this.nra+'","panierId":"'+this.orderid+'","postalCode":"'+this.codepostal+'","regionName":"'+this.labelCommune+'","statusLine":"RESIL","streetNum": "'+this.labelNumVoie+'","typeClient":"B2C","unreliable":false,"updateLogin":"SYNC_ND_Login"}';
            vipInput= '{"addresseCompl1":"'+this.adresseSiteFinal+'","addresseCompl2":"","buildingName":"'+this.batimentFinal+'","buildingNum":"","cableLength":"'+this.distance+'","cableSection":"'+this.sectionMinimal+'","cityName":"'+this.provinceLabelFinal+'","countryName":"Maroc","degroupage":true,"districtName":"'+this.quartierLabelFinal+'","flatNum":"","floorNum":"'+this.etageFinal+'","freePortState":false,"nameLabel":"'+this.__demande.InwiB2C_LastName__c+'","nd":"'+this.__demande.InwiB2C_NumeroDesignation__c+'","neighborhood":"'+this.quartierLabelFinal+'","nnraiam":"'+this.nnra+'","nraiam":"'+this.nra+'","panierId":"'+this.__demande.InwiB2C_Order__c+'","regionName":"'+this.communeLabelFinal+'","statusLine":"RESIL","streetNum": "'+this.nvoieLabelFinal+'","typeClient":"B2C","unreliable":false,"creationDate": "2022-08-25T23:10:51.51Z[UTC]","expireDate": "2022-08-25T23:10:51.51Z[UTC]","lastUpdateDate": "2022-08-25T23:10:51.51Z[UTC]","updateLogin": "SYNC_ND_Login"}';
        }
        else{
            //vipInput='{';
            vipInput='{"addresseCompl1":"'+this.adresseSiteFinal+'","addresseCompl2":"","buildingName":"'+this.batimentFinal+'","buildingNum":"","cableLength":"'+this.distance+'","cableSection":"'+this.sectionMinimal+'","cityName":"'+this.provinceLabelFinal+'","countryName":"Maroc","degroupage":false,"districtName":"'+this.quartierLabelFinal+'","flatNum":"","floorNum":"'+this.etageFinal+'","freePortState":false,"nameLabel":"'+this.__demande.InwiB2C_LastName__c+'","nd":"'+this.__demande.InwiB2C_ndOperateur__c+'","neighborhood":"'+this.quartierLabelFinal+'","nnraiam":"'+this.nnra+'","nraiam":"'+this.nra+'","panierId":"'+this.__demande.InwiB2C_Order__c+'","regionName":"'+this.communeLabelFinal+'","statusLine":"RESIL","streetNum": "'+this.nvoieLabelFinal+'","typeClient":"B2C","unreliable":false,"creationDate": "2022-08-25T23:10:51.51Z[UTC]","expireDate":"2022-08-25T23:10:51.51Z[UTC]","lastUpdateDate": "2022-08-25T23:10:51.51Z[UTC]","updateLogin": "SYNC_ND_Login"}';
        }
        console.log('synchronise',vipInput);
        const params = {
            input: vipInput,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_SynchroniserRefAddress',
            options: '{}'
        };
        this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => { 
          this.isLoadinginModal=false; 
            if (response.error == false) {
                console.log(response);
                if (response.result) {
                    console.log('inwib2c_SynchroniserRefAddressResponse',JSON.stringify(response));
                    if(response.result.IPResult.result && response.result.IPResult.result.status=='0'){
                       // alert('Probleme de synchronisation');
                        this.showMessage('Message', 'Probleme de synchronisation', 'error');
                    } 
                   else{
                    //alert('adresse IAM est bien mis a jour ');
                    this.showMessage('Message', 'adresse IAM est bien mis a jour ', 'success');
                    this.flagValider=false;
                    this.flagSynchro = true;
                   }
                }
            }
        })
        .catch(error => {
            console.log('error');
            window.console.log(error);
        });    
    }
    /**MGEN3568 ILA 20/02/2024 Start*/
    handleRendezVous(event){
      const date = new Date(event.target.value);
      const dayOfWeek = date.getDay();
      let rendezVous=this.template.querySelector('[data-id="rendezVous"]').value;
      const formattedDate = date.toLocaleDateString('GMT', {year: 'numeric', month: 'numeric', day: 'numeric'}).replace(/ /g, '-');
      let holidayTMP = [];
      for (let i = 0; i < this.__holidays.length; i++) {
        const dateTMP=new Date(this.__holidays[i]);
        holidayTMP.push(dateTMP.toLocaleDateString('GMT', {
          year: 'numeric', month: 'numeric', day: 'numeric'
        }).replace(/ /g, '-'));
      }
      if(date <= new Date(this.__minDateRecyclage) || Date.parse(rendezVous) > new Date(this.__maxDateRecyclage) || dayOfWeek === 6 || dayOfWeek === 0 || holidayTMP.includes(formattedDate) ){
          this.flagValider = true;
          this.showMessage('Erreur', 'Merci de choisir un jour ouvré', 'error');
        }
      else
        this.flagValider = false;
    }
    /**MGEN3568 ILA 20/02/2024 End*/
    valider(){
        //creer une nouvelle demande et l'envoyer a IAM
        /**B-14273 ILA 20/02/2024 Start*/
        //let newDemande = [];
        /**MGEN3568 07/08/24 ILA Start*/
        this.omniUpdateDataJson({ 'rendezVous':this.template.querySelector('[data-id="rendezVous"]').value});
        /**MGEN3568 07/08/24 ILA End*/
        let nom = this.template.querySelector('[data-id="nom"]').value;
        let prenom = this.template.querySelector('[data-id="prenom"]').value;
        let cin = this.template.querySelector('[data-id="cin"]').value;
        let comment = this.template.querySelector('[data-id="comment"]').value;
        let contact = this.template.querySelector('[data-id="contact"]').value;
        let adresse = this.showButtons == true ? this.adresseSiteFinal : this.__demande.InwiB2C_ADRESSE__c;
        let adresseIAM =this.__demande.InwiB2C_AdresseIAMProposee__c;
        let bat=this.showButtons == true ? this.batimentFinal : this.__demande.InwiB2C_BAT__c;
        let ccom=this.showButtons == true ? this.communeCodeFinal : this.__demande.InwiB2C_CCOM__c;
        let cquartier=this.showButtons == true ? this.quartierCodeFinal : this.__demande.InwiB2C_CQUARTIER__c;
        let cvoie=this.showButtons == true ? this.voieCodeFinal: this.__demande.InwiB2C_CVOIE__c;
        let esc=this.showButtons == true ? this.escalierFinal : this.__demande.InwiB2C_ESC__c;
        let etage=this.showButtons == true ? this.etageFinal : this.__demande.InwiB2C_ETAGE__c;
        let nvoie=this.showButtons == true ? this.nvoieCodeFinal: this.__demande.InwiB2C_NVOIE__c;
        let porte=this.showButtons == true ? this.porte : this.__demande.InwiB2C_PORTE__c;

        this.omniUpdateDataJson({ 'finalNom':nom});
        this.omniUpdateDataJson({ 'finalPrenom':prenom});
        this.omniUpdateDataJson({ 'finalCin':cin});
        this.omniUpdateDataJson({ 'finalComment':comment});
        this.omniUpdateDataJson({ 'finalContact':contact});
        this.omniUpdateDataJson({ 'finalCodeRoutage':this.codeRoutage});
        this.omniUpdateDataJson({ 'finalAdresse':adresse});
        this.omniUpdateDataJson({ 'finalAdresseIAM':adresseIAM});
        this.omniUpdateDataJson({ 'finalBat':bat});
        this.omniUpdateDataJson({ 'finalCcom':ccom});
        this.omniUpdateDataJson({ 'finalCquartier':cquartier});
        this.omniUpdateDataJson({ 'finalCvoie':cvoie});
        this.omniUpdateDataJson({ 'finalEsc':esc});
        this.omniUpdateDataJson({ 'finalEtage':etage});
        this.omniUpdateDataJson({ 'finalNvoie':nvoie});
        this.omniUpdateDataJson({ 'finalPorte':porte});
        /**B-14273 ILA 20/02/2024 End*/
        
        this.omniUpdateDataJson({ 'createNewDemande':true});
        this.omniNextStep();
    
    }
    annuler(){
        this.omniUpdateDataJson({'exit':true});
        this.omniNextStep();
    }
    showaddsite(){
        this.showAddPropose = false;
        this.showAddIAM = true;
        /**B-14845 ILA  25/03/2024 start*/
        //if(this.__recycleerreur == false ){
          /**B-14845 ILA  25/03/2024 End*/
        this.fetchPicklistIAM('province');
        console.log('fetch=>' )
        this.showButtons = true;
        this.flagValider = true;
      //}
    }
    showaddIAM(){
        this.showAddIAM = false;
        this.showAddPropose = true;
        /**B-14845 ILA  25/03/2024 start*/
        //if(this.__recycleerreur == false){
           /**B-14845 ILA  25/03/2024 End*/
        this.splitAdresse();
        this.showButtons = true;
        this.flagValider = true;
      //}
    }
    ////////////////////////////////////////////////////////////
    fetchPicklistIAM(picklist) {
        let input;
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        if (picklist == 'province') {
          input = '{"operation_name":"' + this.operationName + '"}';
    
        } else if (picklist == 'commune') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '"}';
          //   console.log('input',input);
        } else if (picklist == 'getQuartiers') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '"}';
          //  console.log('input',input);
        } else if (picklist == 'getVoies') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '"}';
          // console.log('input',input);
        } else if (picklist == 'getNumVoies') {
          input = '{"operation_name":"' + this.operationName + '","city_code":"' + this.ProvinceVille + '","municipality_code":"' + this.CommuneV + '","district_code":"' + this.QuartierIAM + '","way_code":"' + this.Voie + '"}';
          // console.log('input',input);
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
                "label": 'Aucun élément',
                "value": "null"
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
    
              //   console.log('t :')
              //  console.log(t)
            } else if (picklist == 'commune') {
    
              //console.log('start picklist === commune  :')
    
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
    
              //  console.log('t :')
              //  console.log(t)
            } else if (picklist == 'getQuartiers') {
    
              // console.log('start picklist === getQuartiers  :')
    
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
    
              //  console.log('t :')
              //  console.log(t)
            } else if (picklist == 'getVoies') {
    
              // console.log('start picklist === getVoies  :')
    
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
    
              //  console.log('t :')
              //   console.log(t)
            } else if (picklist == 'getNumVoies') {
    
              //console.log('start picklist === Numerovoie  :')
    
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
    
              //  console.log('t :')
              //  console.log(t)
            }
          })
          .catch(error => {
            console.log('error : ' + error);
          });
      }
    

    //positionClick;
  showPicklistOptionsProvince() {
    //this.positionClick = 'ProvinceInput';
    if (!this.searchResultsProvince) {
      this.searchResultsProvince = this.provinceValues;
    }
    this.searchResultsCommune = null;
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
      //chb ano B-14518 27/02/2024
    this.ProvinceVille = null;
    this.labelProvince=null;
  }
  showPicklistOptionsCommune() {
    if (!this.searchResultsCommune) {
      this.searchResultsCommune = this.communeValues;
    }
    this.searchResultsQuartierIAM = null;
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
     //chb ano B-14518 27/02/2024
    this.CommuneV =null;
    this.labelCommune =null;
  }
  showPicklistOptionsQuartierIAM() {
    if (!this.searchResultsQuartierIAM) {
      this.searchResultsQuartierIAM = this.QuartierValuesIAM;
    }
    this.searchResultsVoie = null;
    this.searchResultsNumVoies = null;
      //chb ano B-14518 27/02/2024
    this.QuartierIAM = null;
    this.labelQuartier=null;
  }
  showPicklistOptionsVoie() {
    if (!this.searchResultsVoie) {
      this.searchResultsVoie = this.VoieValues;
    }
    this.searchResultsNumVoies = null;
       //chb ano B-14518 27/02/2024
     this.Voie = null;
     this.labelVoie =null;
  }
  showPicklistOptionsNumVoies() {
    if (!this.searchResultsNumVoies && this.NumerovoieValues.length > 1) {
      this.searchResultsNumVoies = this.NumerovoieValues;
    }
     //chb ano B-14518 27/02/2024
    this.Numerovoie = null;
    this.labelNumVoie=null;
  }
  handleKeyPress(event) {
    if (event.key === 'Enter' || event.key === 'Return') {
      // Clear your list here
      this.searchResultsNumVoies = null;
    }
  }

  GetProvince(event){
    /* this.ProvinceVille= event.detail.value;
     this.labelProvince=this.provinceValues.find(opt => opt.value === event.detail.value).label;
     this.operationName='getCommunes';
     this.fetchPicklistIAM('commune');*/
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
        this.ProvinceVille=null;
        this.labelProvince=null;
        const selectedValueProv = event.currentTarget.dataset.value;
        this.selectedSearchResultProvince = this.provinceValues.find(
            (picklistOption) => picklistOption.value === selectedValueProv
        );
        this.ProvinceVille = selectedValueProv;
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

    
    GetCommune(event){
        /*this.CommuneV= event.detail.value;
        this.labelCommune=this.communeValues.find(opt => opt.value === event.detail.value).label;
        this.operationName='getQuartiers';
        this.fetchPicklistIAM('getQuartiers');*/
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
      this.CommuneV =null;
      this.labelCommune =null;
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
  
    GetQuartier(event){
        /*this.QuartierIAM= event.detail.value;
        this.labelQuartier=this.QuartierValuesIAM.find(opt => opt.value === event.detail.value).label;
        this.operationName='getVoies';
        this.fetchPicklistIAM('getVoies'); */
        const input = event.detail.value.toLowerCase();
        const result = this.QuartierValuesIAM.filter((picklistOption) =>
        picklistOption.label.toLowerCase().includes(input)
        );
        this.searchResultsQuartierIAM = result;
    }
    selectSearchResultQuartierIAM(event) {
      this.QuartierIAM = null;
      this.labelQuartier=null;
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
    getVoies(event){
        /*this.Voie= event.detail.value;
        this.labelVoie=this.VoieValues.find(opt => opt.value === event.detail.value).label;
        this.operationName='getNumVoies';
        this.fetchPicklistIAM('getNumVoies'); */
        const input = event.detail.value.toLowerCase();
        const result = this.VoieValues.filter((picklistOption) =>
        picklistOption.label.toLowerCase().includes(input)
        );
        this.searchResultsVoie = result;
      }
      selectSearchResultVoie(event) {
      this.Voie = null;
      this.labelVoie =null;
      const selectedValueVoie = event.currentTarget.dataset.value;
      this.selectedSearchResultVoie = this.VoieValues.find(
        (picklistOption) => picklistOption.value === selectedValueVoie
      );
      this.Voie = selectedValueVoie;
      this.labelVoie = this.VoieValues.find(opt => opt.value === selectedValueVoie).label;
      this.disableNumVoie = true;
      this.operationName = 'getNumVoies';
      this.fetchPicklistIAM('getNumVoies');
      this.flagSearch = false;
      this.Numerovoie = '';
      this.labelNumVoie = '';
      this.clearSearchResultsVoie();
    }
      getNumVoies(event){
        /*this.Numerovoie= event.detail.value;
        this.labelNumVoie=this.NumerovoieValues.find(opt => opt.value === event.detail.value).label;*/
        const input = event.detail.value.toLowerCase();
        const result = this.NumerovoieValues.filter((picklistOption) =>
        picklistOption.label.toLowerCase().includes(input)
        );
        this.searchResultsNumVoies = result;
        this.flagSearch = false;
      }
      selectSearchResultNumVoies(event) {
        this.Numerovoie = null;
        this.labelNumVoie=null;
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
      /*chb 25/09/2024 B-20681 begin */
      handleKeyDown(event) {
        // Récupérer le code de la touche pressée
        const key = event.key;

        // Bloquer tout caractère non numérique
        if (!/^[0-9]$/.test(key) && key !== 'Backspace' && key !== 'ArrowLeft' && key !== 'ArrowRight') {
            event.preventDefault(); // Bloque la saisie de caractères non numériques
        }
    }
 /*chb 25/09/2024 B-20681 end */
    render(){
        return template;
    }
}