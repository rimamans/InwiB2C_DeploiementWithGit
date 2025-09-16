import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import template from "./inwiB2C_DisplayParentAttribute.html";

export default class InwiB2C_DisplayParentAttribute extends OmniscriptBaseMixin(LightningElement) {
       //ANO 9111 CHB 17/05/2023 Reservation Port DSLAM
    __DSLAM;
    providerIDValue;
    __accountid;
    __cin;
    __isfar;
    __iswakil;
    __isftthvula; 
    __username;
    __typepos = "";
    _attribute = {};
    __item = "";
    ODSLB2CTA;
    __index_IDPORTDSLAM;
    __selectedDSLAM="";
    showEngagement = false;
    ShowtypeLigneDisable=false;
    __showTypeDeLigne = true;
    __showStatutFar = false;
    __disabled = false;
    nra;
    __disableButton=false;
    __selectedFRAME="";
    __index_FRAME;
    __selectedSLOT="";
    __index_IDPORTSLOT;
    __selectedPORT="";
    __index_PORT;
    __selectedDSLAMNAME="";
    __index_DSLAMNAME;
    __selectedPROVIDERADSL="";
    __index_PROVIDERADSL;
    providerIDValue;
    __index_nra;
    __demenagement;
    frameValue;
    dslam_nameValue;
    portValue;
    slotValue;
    nraValue;
    __typeparcour="";
    //CHB ANO 11235 13/10/2023
    __selectedPOSITMDF="";
    __index_POSITMDF;
    positionregletteValue;
    //CHB ANO 11556 07/12/2023
    profile;
    __index_profile;
    __selectedRACK=""
    __index_RACK;
    rackValue;
   @api
  get typeparcour() {
    return this.__typeparcour;
  }
  set typeparcour(value) {
    this.__typeparcour = value;
  }
    @api
    get item() {
        return this._item
    }
    set item(value) {
        console.log(value)
        this.__item = { ...value };
    }

    @api
    get accountid() {
        return this.__accountid
    }
    set accountid(value) {
        this.__accountid = value;
    }
    isfar
    @api
    get isfar() {
        return this.__isfar
    }
    set isfar(value) {
        this.__isfar = value;
        console.log('setValuethis.isFar',this.__isfar);
    }
    @api
    get cin() {
        return this.__cin
    }
    set cin(value) {
        this.__cin = value;
    }
    @api
    get demenagement() {
        return this.__demenagement;
    }
    set demenagement(value) {
        this.__demenagement = value;
    }

    @api
    get username() {
        return this.__username;
    } set username(value) {
        this.__username = value;
    }
    @api
    get attribute() {
        return this._attribute
    }
    set attribute(value) {
        this._attribute = { ...value };
    }
  //CH-Y MigrationPrePostBackOffice Begin
  @api
  set iswakil(value) {
    this.__iswakil = value;
    console.log("is wakil aprés le setter", this.__iswakil)
  }
  get iswakil() {
      return this.__iswakil;

  }
//CH-Y MigrationPrePostBackOffice End

// CH_Y MC_MGEN3610-SFVLB2C_FTTH VULA TELEVENTE Begin
  __isftthvula ; 

  @api
  set  isftthvula(value) {

    this.__isftthvula = value;

  }
  get isftthvula () {
    return this.__isftthvula ;
  }  
// CH_Y MC_MGEN3610-SFVLB2C_FTTH VULA TELEVENTE end
    @api
    get typepos() {
        return this.__typepos;
    } set typepos(value) {
        this.__typepos = value;
        console.log("Valeur reçue dans le setter aprés typePos:", this.__typepos);
    }
    /*CHB 28/11/2023 DGSN DGPC begin */
    __permissiondgsndgpc=false;
    @api
    set permissiondgsndgpc(value) {
        this.__permissiondgsndgpc = value;
    }
    get permissiondgsndgpc() {
        return this.__permissiondgsndgpc;
    }
  /*CHB 28/11/2023 DGSN DGPC end */
    /* ILA 19/01/2024 PUPPILLES DGPC Start */
    __permissionpuppilesdgpc=false;
    @api
    set permissionpuppilesdgpc(value) {
        this.__permissionpuppilesdgpc = value;
    }
    get permissionpuppilesdgpc() {
        return this.__permissionpuppilesdgpc;
    }
     /* ILA 19/01/2024 PUPPILLES DGPC End */
   /* chb 29/04/2024 Campus postpayee begin*/
   @api
   set checkcampus(value){
   this.__checkcampus = value;
   }
   get checkcampus(){
   return this.__checkcampus;
   }
/* chb 29/04/2024 Campus postpayee end */
    __product;
    @api
    get product() {
        return this.__product;
    }
    set product(value) {
        this.__product = { ...value };
    }
    __modepaiment='';
    @api
    get modepaiment(){
        return this.__modepaiment;
      }
    set modepaiment(value){
      this.__modepaiment = value;
    }
    /* Collaborateur OCP ILA 13/11/24 Start */
    __isocpallowed
    @api
    set isocpallowed(value) {
        this.__isocpallowed = value;
    }
    get isocpallowed() {
        return this.__isocpallowed;
    }
    /* Collaborateur OCP ILA 13/11/24  End */
    __loading = false;
    __showinputs = false;
    __message = "";
    value = "";
    valueStatutFar="";
    orderid = "";
    options = [];
    optionsDureeEngagement = [];
    valueDureeEngagement = "";
    optionsTypeVente = [];
    valueTypeVente = "";
    StatutFar=[];
    get showEngagementCombobox() {
        return (this.__product && this.__product.InwiB2C_Type_offre__c === "Data") || this.__item.Product2.vlocity_cmt__Type__c === "idar duo" || this.__item.Product2.vlocity_cmt__Type__c === "FTTH" || this.__item.Product2.vlocity_cmt__Type__c === "ADSL";
    }

    get showTypeVente() {
        return (this.__item && this.__item.Product2.vlocity_cmt__Type__c === "idar duo") || (this.__item.Product2.vlocity_cmt__Type__c === "FTTH");
    }
    get optionsStatutFar() {
        return [
            { label: 'Actif', value: 'Actif' },
            { label: 'Non actif', value: 'Non actif' },
           
        ];
    }
    /*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 start*/
 __iswafacash;
      @api
     set iswafacash(value) {
    this.__iswafacash = value;
    console.log("wwafacash", this.__iswafacash)
  }
  get iswafacash() {
      return this.__iswafacash;

  }

    get filteredOptions() {
        if (this.iswafacash && (this.__item.Product2.vlocity_cmt__Type__c === "idar duo" ||  this.__item.Product2.vlocity_cmt__Type__c === "Postpaye")) {
            return this.options.filter(option => option.value === 'GP');
        }
        return this.options;
    }

/*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 end*/
    setOptions() {
        if ((this.__item.Product2.vlocity_cmt__Type__c === "FTTH") ||(this.__product && this.__product.Name && this.__product.Name==="Pack Internet Direct")) {
            this.showEngagement = true;
        }
        if ((this.__item.Product2.vlocity_cmt__Type__c === "ADSL") ||(this.__product && this.__product.Name && this.__product.Name==="Pack de dépannage")) {
            this.showEngagement = true;
        }
       
        // if (this.__product.Name==="Pack Internet Direct") {
        if (this.__product && this.__product.Name && this.__product.Name==="Pack Internet Direct") {

        this.ShowtypeLigneDisable = true;

        }
        if (this.__product && this.__product.Name && this.__product.Name==="Pack de dépannage") {

            this.ShowtypeLigneDisable = true;
    
            }
            if (this.__typeparcour==="eshop") {

                this.ShowtypeLigneDisable = true;
                if (this.__modepaiment!='inwiB2C_EnEspece'&& this.__item.Product2.vlocity_cmt__Type__c != "FTTH" && this.__item.Product2.vlocity_cmt__Type__c != "ADSL") {
                this.showEngagement=true;
                }
                
        }if(this.__typeparcour==="Televente" || this.__typeparcour === "RepriseD2D"){
          this.ShowtypeLigneDisable = true;
       } 
                
        let dataOptions = [];
        let value;
        let dataOptionsDureeEngagement = [];
        let valueDureeEngagement;
        let dataOptionsTypeVente = [];
        let valueTypeVente;
        const demenagement=this.__demenagement && this.__demenagement=="true"? true : false;
        const typeos = this.__typepos && this.__typepos == "inwib2c_OS" ? true : false;
         /*CHB 28/11/2023 DGSN DGPC begin */
        const permissionsetsnpc=this.__permissiondgsndgpc==true  ? true : false;
         /*CHB 28/11/2023 DGSN DGPC end */
        /* ILA 19/01/2024 PUPPILLES DGPC Start */
        const permissionsetpuppilespc=this.__permissionpuppilesdgpc==true  ? true : false;
        /* ILA 19/01/2024 PUPPILLES DGPC End */
        /* chb 29/04/2024 Campus postpayee begin*/
        const checkcampus=this.__checkcampus==true ? true : false;
        /* chb 29/04/2024 Campus postpayee end*/
         //chb 02/09/2024 ANO B-19703 begin/
         if (checkcampus ==false && this.__item.Product2.vlocity_cmt__Type__c === "Cameleon"  && this.__item.vlocity_cmt__RecurringPrice__c <99 ) { 
            this.__showTypeDeLigne = false;
        } //chb 02/09/2024 ANO B-19703 end/
        console.log("***************** parent********", this.__username, this.__cin, this.__accountid, this.__typepos, typeos, this.__typeparcour);
        console.log("***************** this.__product ********");
        //  console.log(JSON.stringify(this.__product).Name);
        console.log(JSON.stringify(this.__item));
        this.orderid = this.__item.OrderId.value;
        console.log(this.orderid);
        //chb 18/03/2024 SF24-022_Campus connecte postpayé begin */
        const showEtudiant= this.__item.vlocity_cmt__RecurringPrice__c >99 ?true:false;
        //chb 18/03/2024 SF24-022_Campus connecte postpayé END */
        //CHB 27/09/2023 ISIC BTS TTM
 //chb 18/03/2024 SF24-022_Campus connecte postpayé begin */
        /*if (this.__item.Product2.vlocity_cmt__Type__c === "Cameleon"  && this.__item.vlocity_cmt__RecurringPrice__c <99 ) { 
            //this.__showTypeDeLigne = false;
            showEtudiant=true;
            console.log('in cameleon diff de 20707 ');
         }*/

        //chb 18/03/2024 SF24-022_Campus connecte postpayé END */
        if (this.__item && this.__item.attributeCategories) {
            this.__item.attributeCategories.records[0] && this.__item.attributeCategories.records[0].productAttributes && this.__item.attributeCategories.records[0].productAttributes.records
                && this.__item.attributeCategories.records[0].productAttributes.records.map((item, index) => {

                    if (item.code == "INWIB2C_ATT_RT_ODSLB2CTA"){
                        this.ODSLB2CTA = item.userValues=='DP'? true:false;
                    }
                    //ano 11235 CHB 13/10/2023
                    if (item.code == "INWIB2C_ATT_RT_POSITMDF"){
                        this.__selectedPOSITMDF = item.userValues;
                        this.__index_POSITMDF = index;
                    }//ano 11556 CHB 07/12/2023
                    if (item.code == "INWIB2C_ATT_RT_RACK"){
                        this.__selectedRACK = item.userValues;
                        this.__index_RACK = index;
                    }
                   //ANO 9111 CHB 17/05/2023
                    if (item.code == "INWIB2C_ATT_RT_IDPORTDSLAM"){
                        this.__selectedDSLAM = item.userValues;
                        this.__index_IDPORTDSLAM = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_FRAME"){
                        this.__selectedFRAME = item.userValues;
                        this.__index_FRAME = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_SLOT"){
                        this.__selectedSLOT = item.userValues;
                        this.__index_IDPORTSLOT = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_PORT"){
                        this.__selectedPORT = item.userValues;
                        this.__index_PORT = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_DSLAMNAME"){
                        this.__selectedDSLAMNAME = item.userValues;
                        this.__index_DSLAMNAME = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_PROVIDERADSL"){
                        this.__selectedPROVIDERADSL = item.userValues;
                        this.__index_PROVIDERADSL = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_NRA"){
                        this.nra = item.userValues;
                        this.__index_nra = index;
                    }
                    if (item.code == "INWIB2C_ATT_RT_TYPE_LIGNE") {
                        /* Collaborateur OCP ILA 13/11/24 Start */
                        this.__index_type_ligne = index;
                        item.values.map(item3 => {
                            console.log('typecible', item3);
                            dataOptions.push(item3)
                          })
                          for (var i=dataOptions.length-1; i>=0; i--) {
                            if((dataOptions[i].value == "CO") || (!checkcampus && dataOptions[i].value == "CP") ||(!showEtudiant && dataOptions[i].value == "ED") || (dataOptions[i].value == "CI" && (!demenagement && !typeos)) || (!permissionsetsnpc && dataOptions[i].value == "PC") || (!permissionsetsnpc && dataOptions[i].value == "SN") || (!permissionsetpuppilespc && dataOptions[i].value == "PP") || (!this.__isocpallowed && dataOptions[i].value == "OCP")){
                                dataOptions.splice(i, 1);
                            }
                          }
                          value = item.userValues;
                          /**B-31452 07/07/25 ILA Start */
                          //if (this.__item.Product2.vlocity_cmt__Type__c === "idar duo" && value === "GP") {
                            if (this.__item.Product2.vlocity_cmt__Type__c === "idar duo" && value === "GP" && this.__typeparcour != 'Mig4G5G') {
                          /**B-31452 07/07/25 ILA End */
                            this.__disabled = true;
                            this.checkEligibilityGP();
                        }
                        
                        //CH-Y MigrationPrePostBackOffice Begin
                        const iswakil=this.__iswakil==true ? true : false;
                        console.log("isftthVula:", this.__isftthvula);
                        const isftthvula = this.__isftthvula==true ? true : false;
                        console.log("valeur de isftthVula:", isftthvula);
                        if(iswakil == true || isftthvula ==true){
                           console.log("dataOptions before filter",dataOptions);
                           dataOptions = dataOptions.filter((item)=>item.value=="GP");
                           console.log("dataOptions after filter",dataOptions);
                            
                        }
                        console.log("dataoptions length",dataOptions.length);
                        console.log("dataoptions", dataOptions);
                        //CH-Y MigrationPrePostBackOffice End
                    }

                    /*
                    if (item.code == "INWIB2C_ATT_RT_TYPE_LIGNE") 
                        {
                        this.__index_type_ligne = index;
                        //chb 18/03/2024 SF24-022_Campus connecte postpayé begin 
                        item.values.map(function (option) {
                            let newOption = [];
                            console.log("inside loop", option.value)
                            console.log("demenagement033"+demenagement);
       
                          if (option.value == "CI"){
                            if(demenagement ){
                                console.log("demenagementis", +demenagement);
                               newOption.label = option.label;
                               newOption.value = option.value;
                               dataOptions = [...dataOptions, newOption];
                           }
                            else
                             if(typeos && permissionsetsnpc && !permissionsetpuppilespc && option.value!="PP" && option.value !== "CP"   && !checkcampus && !showEtudiant && option.value !== "ED" ){
                                    newOption.label = option.label;
                                    newOption.value = option.value;
                                    dataOptions = [...dataOptions, newOption];
                                }else if(typeos &&  !permissionsetsnpc && permissionsetpuppilespc && option.value!="SN" && option.value!="PC" && option.value !== "CP"   && !checkcampus && option.value !== "ED" && !showEtudiant){
                                    newOption.label = option.label;
                                    newOption.value = option.value;
                                    dataOptions = [...dataOptions, newOption];
                                }else if(typeos &&  !permissionsetsnpc && !permissionsetpuppilespc && option.value!="SN" && option.value!="PC" && option.value!="PP" && option.value !== "CP" && !checkcampus && option.value !== "ED" && !showEtudiant){
                                    newOption.label = option.label;
                                    newOption.value = option.value;
                                    dataOptions = [...dataOptions, newOption];
                                }else if(typeos &&  permissionsetsnpc && permissionsetpuppilespc && option.value !== "CP" && !checkcampus &&  option.value !== "ED" && !showEtudiant){
                                    newOption.label = option.label;
                                    newOption.value = option.value;
                                    dataOptions = [...dataOptions, newOption];
                                }else if(typeos &&  option.value === "CP"  && checkcampus ){
                                    newOption.label = option.label;
                                    newOption.value = option.value;
                                    dataOptions = [...dataOptions, newOption];
                                }else if(typeos && showEtudiant && !checkcampus && option.value !== "CP"){
                                    newOption.label = option.label;
                                    newOption.value = option.value;
                                    dataOptions = [...dataOptions, newOption];
                                }
                            }
                            else if(permissionsetsnpc && !permissionsetpuppilespc && option.value!="PP" && option.value !== "CP" && !checkcampus && option.value !== "ED" &&  !showEtudiant ){
                                newOption.label = option.label;
                                newOption.value = option.value;
                                dataOptions = [...dataOptions, newOption];
                            }else if(!permissionsetsnpc && permissionsetpuppilespc && option.value!="SN" && option.value!="PC" && option.value !== "CP" && !checkcampus && option.value !== "ED" &&  !showEtudiant){
                                newOption.label = option.label;
                                newOption.value = option.value;
                                dataOptions = [...dataOptions, newOption];
                            }else if(!permissionsetsnpc && !permissionsetpuppilespc && option.value!="SN" && option.value!="PC" && option.value!="PP" && option.value !== "CP"  && !checkcampus && option.value !== "ED" &&  !showEtudiant){
                                newOption.label = option.label;
                                newOption.value = option.value;
                                dataOptions = [...dataOptions, newOption];
                            }else if(permissionsetsnpc && permissionsetpuppilespc  && option.value !== "CP" && !checkcampus && option.value !== "ED" &&  !showEtudiant ){
                                newOption.label = option.label;
                                newOption.value = option.value;
                                dataOptions = [...dataOptions, newOption];
                            }else if( option.value === "CP" && checkcampus  ){
                                newOption.label = option.label;
                                newOption.value = option.value;
                                dataOptions = [...dataOptions, newOption];
                            }else if(  showEtudiant && !checkcampus &&option.value !== "CP"){
                                newOption.label = option.label;
                                newOption.value = option.value;
                                dataOptions = [...dataOptions, newOption];
                            }
                            /* ILA 19/01/2024 PUPPILLES DGPC End 
                        });//chb 18/03/2024 SF24-022_Campus connecte postpayé end 
                        value = item.userValues;
                        if (this.__item.Product2.vlocity_cmt__Type__c === "idar duo" && value === "GP") {
                            this.__disabled = true;
                            this.checkEligibilityGP();
                        }
                    } 
                    */
                   /* Collaborateur OCP ILA 13/11/24 End */
                    else if (item.code == "INWIB2C_ATT_DC_NUMERO_ADHERANT") {
                        this.__index_numero_adherant = index;
                    } else if (item.code == "INWIB2C_ATT_DC_ElligibleAuTypeLigne") {
                        this.__index_eligible = index;
                    } else if (item.code == "INWIB2C_ATT_RT_ENGAGEMENT") {
                        if (this.__item.Product2.vlocity_cmt__Type__c === "ADSL" || this.showTypeVente || this.__product && this.__product.InwiB2C_Type_offre__c === "Data") {
                            this.__index_duree_engagement = index;
                            item.values.map(function (option) {
                                let newOptionDureeEngagement = [];
                                console.log("inside loop", option.value)
                                newOptionDureeEngagement.label = option.label;
                                newOptionDureeEngagement.value = option.value;
                                dataOptionsDureeEngagement = [...dataOptionsDureeEngagement, newOptionDureeEngagement];
                            });
                            valueDureeEngagement = item.userValues;
                        }

                    }
                    // else if (item.code == "INWIB2C_ATT_RT_VENTETYPE") {
                    //     this.__index_type_vente = index;
                    //     item.values.map(function (option) {
                    //         let newOptionTypeVente = [];
                    //         console.log("inside loop", option.value)
                    //         newOptionTypeVente.label = option.label;
                    //         newOptionTypeVente.value = option.value;
                    //         dataOptionsTypeVente = [...dataOptionsTypeVente, newOptionTypeVente];
                    //     });
                    //     valueTypeVente = item.userValues;

                    // }
                })
            //

        }

        this.options = dataOptions;
        this.value = this.value === "" ? value : this.value;
        //this.value = value;
        this.optionsDureeEngagement = dataOptionsDureeEngagement;
        this.valueDureeEngagement = valueDureeEngagement;

        this.optionsTypeVente = dataOptionsTypeVente;
        this.valueTypeVente = valueTypeVente;
    }







    //
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        console.log("demenagement2"+this.demenagement)
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.setOptions();
        console.log('this.__showTypeDeLigne'+this.__showTypeDeLigne);  
        console.log('__permissionpuppilesdgpc',this.__permissionpuppilesdgpc); 
        console.log('this.checkcampus',this.__checkcampus);
        console.log('connectedCallBackthis.isFar',this.__isfar);
        console.log('connectedCallBack',this.__iswakil);

    }

    render() {
        return template;
    }
    handleChangeDropDown(event) {
        this.value = event.detail.value;
        this.__message = "";
        console.log("this.value----->", this.value)
        console.log("this.cin----->", this.__cin)
        if (this.value == "CI") {

            this.__showinputs = false;
            this.__disabled = true;
            this.__showStatutFar = false;

            this.checkEligibilityCollaborator(this.value);

        } else if (this.value == "NAFIDA") {

            this.__disabled = true;
            this.__showinputs = true;
            this.__showStatutFar = false;

        }
        else if (this.__isfar && this.__isfar=="Eligible" && (this.value == "AF" || this.value == "PF") ) {

            this.__showStatutFar = true;
            this.__showinputs = false;
            this.__disabled = true;
            this.checkEligibilityFar(this.value);


        }
     
        /* ILA 19/01/2024 PUPPILLES DGPC Start */
        //ajouter PP a la condition
        /* Collaborateur OCP ILA 13/11/24 Start */
        //ajouter ocp a la condition
        else if ((this.value == "AF" || this.value == "PF" || this.value=="AX" || this.value=="PC" || this.value=="SN" || this.value=="PP" || this.value=="OCP") && this.__showStatutFar ==false) {
        /* ILA 19/01/2024 PUPPILLES DGPC End */

            this.__showinputs = false;
            this.__disabled = true;
            this.checkEligibilityFar(this.value,this.valueStatutFar);
            this.__showStatutFar = false;

        }
        else if (this.value == "GP" && this.__typeoffre != 'Postpaye') {

            this.__showinputs = false;
            this.__disabled = true;
            this.__showStatutFar = false;


        } else {
            this.__showinputs = false;
            this.__disabled = false;
            this.__showStatutFar=false;

            const selectedEvent = new CustomEvent("changelignetype", {
                detail: [],
            });
            this.dispatchEvent(selectedEvent);

        }




    }

    checkEligibilityGP() {
        console.log('in checkEligibilityGP');
        const selectedEvent = new CustomEvent("changelignetype", {
            detail: ["Checking Eligibility"],
        });
        this.dispatchEvent(selectedEvent);
        //
        this.__loading = true;
        this.__disabled = true;
        this.__message = "";
        const params = {

            input: '{"cin":"' + this.__cin + '","type":"Grand Public","typeoffer": "' + this.__item.Product2.vlocity_cmt__Type__c + '"}',
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_inwib2c_check_collaborateur",
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("call inwib2c_inwib2c_check_grand publique" + this.__item.Product2.vlocity_cmt__Type__c);
                console.log(response);
                let result = response.result.IPResult;
                console.log(result);
                console.log(this.value)
                this.__loading = false;
                if (result && result.count < result.max_gp) {
                    this.value = "GP";
                    this.__disabled = false;
                    console.log('check: this .value' + this.value)
                    const selectedEvent = new CustomEvent("changelignetype", {
                        detail: [],
                    });
                    this.dispatchEvent(selectedEvent);
                } else {
                    this.__message = "Le client a dépassé la limite autorisée";
                    const selectedEvent = new CustomEvent("changelignetype", {
                        detail: ["Le client a dépassé la limite autorisée"],
                    });
                    this.dispatchEvent(selectedEvent);
                }
            })
            .catch(error => {
                console.log("error");
                window.console.log(error);
            });

    }
    
    checkEligibilityFar(typeligne) {
        const selectedEvent = new CustomEvent("changelignetype", {
            detail: ["Checking Eligibility"],
        });
        this.dispatchEvent(selectedEvent);
        //
        this.__loading = true;
        this.__disabled = true;
        this.__message = "";

         /* Collaborateur OCP ILA 13/11/24 Start */
        //let type=typeligne=="PP"?"pupilles de la nation DGPC":typeligne=="SN"?"SN":typeligne=="PC"?"PC": typeligne=="AF"?"Adhérant FAR":typeligne=="PF"?"Pupilles de la nation FAR":"Forces auxiliaires";
        let type=typeligne=="PP"?"pupilles de la nation DGPC":typeligne=="SN"?"SN":typeligne=="PC"?"PC": typeligne=="AF"?"Adhérant FAR":typeligne=="PF"?"Pupilles de la nation FAR":typeligne=="OCP"?"Collaborateur OCP":"Forces auxiliaires";
        let methodName=typeligne=="OCP"?"inwib2c_check_OCP":"inwib2c_inwib2c_check_Far";
        /* Collaborateur OCP ILA 13/11/24 Start */
       
        const params = {
            input: '{"cin":"' + this.__cin + '","type":"' + type + '","typeoffer": "' + this.__item.Product2.vlocity_cmt__Type__c + '"}',
            sClassName: `${this._ns}IntegrationProcedureService`,
            /* Collaborateur OCP ILA 13/11/24 Start */
            //sMethodName: "inwib2c_inwib2c_check_Far",
            sMethodName: methodName,
            /* Collaborateur OCP ILA 13/11/24 End */
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("call inwib2c_inwib2c_check_collaborateur");
                console.log(response);
                let result = response.result.IPResult;
                console.log(result);
                console.log(this.value)
                this.__loading = false;
                if (result && result.count < result.max_far) {
                    this.value = typeligne;
                    this.__disabled = false;
                   // this.__showStatutFar=true;
                    console.log('check: this .value' + this.value)
                    const selectedEvent = new CustomEvent("changelignetype", {
                        detail: [],
                    });
                    this.dispatchEvent(selectedEvent);
                } else {
                    this.__message = "Le client a dépassé la limite autorisée";
                    const selectedEvent = new CustomEvent("changelignetype", {
                        detail: ["Le client a dépassé la limite autorisée"],
                    });
                    this.dispatchEvent(selectedEvent);
                }
            })
            .catch(error => {
                console.log("error");
                window.console.log(error);
            });

    }


    checkEligibilityCollaborator(typeligne) {
        const selectedEvent = new CustomEvent("changelignetype", {
            detail: ["Checking Eligibility"],
        });
        this.dispatchEvent(selectedEvent);
        //
        this.__loading = true;
        this.__disabled = true;
        this.__message = "";
        const params = {
            input: '{"cin":"' + this.__cin + '","orderid":"'+this.orderid+'","type": "Collaborateur inwi" ,"typeoffer": "' + this.__item.Product2.vlocity_cmt__Type__c + '"}',
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_inwib2c_check_collaborateur",
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("call inwib2c_inwib2c_check_collaborateur");
                console.log(response);
                let result = response.result.IPResult;
                console.log(result);
                console.log(this.value)
                this.__loading = false;
                if (result && result.count < result.max_collaborateur) {
                    this.value == "CI";
                    this.__disabled = false;
                    const selectedEvent = new CustomEvent("changelignetype", {
                        detail: [],
                    });
                    this.dispatchEvent(selectedEvent);
                } else {
                    this.__message = "Le client a dépassé la limite autorisée";
                    const selectedEvent = new CustomEvent("changelignetype", {
                        detail: ["Le client a dépassé la limite autorisée"],
                    });
                    this.dispatchEvent(selectedEvent);
                }
            })
            .catch(error => {
                console.log("error");
                window.console.log(error);
            });

    }

    checkEligibilityNafida() {
        const selectedEvent = new CustomEvent("changelignetype", {
            detail: ["Checking Eligibility"],
        });
        this.dispatchEvent(selectedEvent);
        this.__disabled = true;
        this.__message = "";
        let value =
            this.template.querySelector(`[data-theid="numadherant"]`).value;
        if (!value || value == "") {
            this.__message = "Veuillez saisir le numéro de l'adhérant";
        } else {
            this.__loading = true;
            const input = `{
                "foudationName": "FM6",
                "adherentNationalId": "`+ this.__cin + `",
                "adherentNumber": "`+ value + `",
                "accountid": "`+ this.__accountid + `",
                "typeoffer": "`+ this.__item.Product2.vlocity_cmt__Type__c + `"
            }`;

            const params = {
                input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_inwib2c_check_nafida_member",
                options: "{}",
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log("call inwib2c_inwib2c_check_nafida_member");
                    let result = response.result.IPResult;
                    console.log(result);
                    this.__loading = false;
                    if (result) {
                        console.log('num ligne nafida  : ' + result.count.count)
                        if (result.status == "1") {
                            if (result.identificationStatus && result.identificationStatus == "0") {
                                this.__message = "Le client n'est pas adhérant dans la fondation";
                                const selectedEvent = new CustomEvent("changelignetype", {
                                    detail: ["Le client n'est pas adhérant dans la fondation"],
                                });
                                this.dispatchEvent(selectedEvent);
                            } else if (result.identificationStatus && result.identificationStatus == "1" && result.count.count >= result.count.max_nafida) {
                                this.__message = "Le client a dépassé la limite autorisée";
                                const selectedEvent = new CustomEvent("changelignetype", {
                                    detail: ["Le client a dépassé la limite autorisée"],
                                });
                                this.dispatchEvent(selectedEvent);
                            } else {
                                this.value == "NAFIDA";
                                this.__disabled = false;
                                const selectedEvent = new CustomEvent("changelignetype", {
                                    detail: [],
                                });
                                this.dispatchEvent(selectedEvent);
                            }
                        } else if (!result.success) {
                            this.__message = result.error;
                        }
                    }
                })
                .catch(error => {
                    console.log("error");
                    window.console.log(error);
                });
        }
    }

    // Durée d'engagement
    handleChangeDropDownDureeEngagement(event) {
        this.valueDureeEngagement = event.detail.value;
    }

    handleClick() {
        console.log("this.showTypeVente");
        console.log(this.showTypeVente, this.valueTypeVente);
        console.log(this.showTypeVente && (!this.valueTypeVente || !this.valueTypeVente == ""));

        console.log("this.showTypeVente else");
        console.log("this.showTypeVente else: ",this.showTypeVente );
        this.__message = "";
        let localItem = JSON.parse(JSON.stringify(this.__item));
        console.log(this.value)
        localItem.attributeCategories.records[0].productAttributes.records[this.__index_type_ligne].userValues = this.value;
        localItem.attributeCategories.records[0].productAttributes.records[this.__index_eligible].userValues = true;
        
        if (this.value == "NAFIDA") {
            localItem.attributeCategories.records[0].productAttributes.records[this.__index_numero_adherant].userValues = this.template.querySelector(`[data-theid="numadherant"]`).value;
        }

        if ((this.__product && this.__product.InwiB2C_Type_offre__c === "Data") || this.showTypeVente) {
            localItem.attributeCategories.records[0].productAttributes.records[this.__index_duree_engagement].userValues = this.valueDureeEngagement;
        }
       
        // if (this.showTypeVente) {
        //     localItem.attributeCategories.records[0].productAttributes.records[this.__index_type_vente].userValues = this.valueTypeVente;
        // }


        //
        this.__item = JSON.parse(JSON.stringify(localItem));
        const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item,
        });

        /* Collaborateur OCP ILA 13/11/24 add OCP to approbation */
        if (this.value == "CI" || this.value == "NAFIDA" || this.value == "OCP") {
            const params = {
                input: '{"value": ' + true + ', "orderid":"' + this.orderid + '" }',
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_set_order_approbation",
                options: '{}',
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log("saveAppliedPromotions");
                    this.dispatchEvent(selectedEvent);

                })
                .catch(error => {
                    this.saving = false;
                    window.console.log(error);
                });

        }
        
        
        if ((this.value == "AF" || this.value == "PF"  ) &&  this.valueStatutFar) {
            const params = {
                input: '{"value": "' + this.valueStatutFar + '", "orderid":"' + this.orderid + '" }',
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_updateOrderFar",
                options: '{}',
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log("saveAppliedPromotions");
                    this.dispatchEvent(selectedEvent);

                })
                .catch(error => {
                    this.saving = false;
                    window.console.log(error);
                });

        }
        
        else {
            console.log("call dispatch")
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
        }



    }

    // Type Vente
    handleChangeDropDownTypeVente(event) {
        this.valueTypeVente = event.detail.value;
    }
    
    handleChangeStatFar(event) {
        this.valueStatutFar = event.detail.value;

    }
//Lock Ressource DSLAM------------------
//insert DSLAM
set DSLAM (value){
    this.__selectedDSLAM=value;
    let localItem = JSON.parse(JSON.stringify(this.__item));
    console.log(this.value)

    localItem.attributeCategories.records[0].productAttributes.records[this.__index_IDPORTDSLAM].userValues = value;
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_PROVIDERADSL].userValues = this.providerIDValue;
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_FRAME].userValues = this.frameValue;
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_DSLAMNAME].userValues = this.dslam_nameValue;
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_PORT].userValues = this.portValue;
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_IDPORTSLOT].userValues = this.slotValue;
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_nra].userValues = this.nraValue;  
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_POSITMDF].userValues = this.positionregletteValue; 
    //ANO 11556 CHB 07/12/2023
    localItem.attributeCategories.records[0].productAttributes.records[this.__index_RACK].userValues = this.rackValue; 
    this.__item = JSON.parse(JSON.stringify(localItem));
    const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
    detail: this.__item
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
    this.__disableButton=true;
}
get DSLAM() {

    return this.__selectedDSLAM;
}

PORTDSLAM(){
   

    this._actionUtilClass = new OmniscriptActionCommonUtil();
    //this.nra='NRA1001';
    let input ='{"Action": "LOCK","POOLID": "SYS","TypeRessource": "DSLAM_PORT","quantity": "1","resourceCharacteristic": [{"name": "NRA","value":"'+this.nra+'"}]}';
    
     console.log('LockOrUnlockRessource1: ',input);
    const params = {
        input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "Inwi_InwiB2C_LockOrUnlockRessource",
        options: "{}"
    };
    this._actionUtilClass
    .executeAction(params, null, this, null, null)
    .then(response => {
        console.log('response1',response);
        //this.isLoading=false;
        if (!response.error) {
            if (response.result.IPResult && response.result.IPResult.resourceCharacteristicList) {
                let dataResult = response.result.IPResult.resourceCharacteristicList;
                let data = [];
                dataResult.map((item, index) => {
                console.log(dataResult.length == 1);
                item.index = index;
                item.checked = dataResult.length == 1;
                data.push(item);
          })
                 this.__disableButton=true;
                //let DSLAM;  
                     var properties = dataResult[0].properties;
                    for (var i = 0; i < properties.length; i++) {
                    var property = properties[i];
                    if (property.code === "PROVIDER_ID") {
                        this.providerIDValue = property.value;
                    }
                    else if (property.code === "FRAME") {
                        this.frameValue = property.value;
                    } 
                    else if (property.code === "SLOT") {
                        this.slotValue = property.value;
                    } 
                    else if (property.code === "PORT") {
                        this.portValue = property.value;
                    } 
                    else if (property.code === "DSLAM_NAME") {
                        this.dslam_nameValue = property.value;
                    } 
                    else if (property.code === "NRA") {
                        this.nraValue = property.value;
                    } 
                    //CHB ANO 11235 13/10/2023
                    else if (property.code === "REGLETTE_POSITION") {
                        this.positionregletteValue = property.value.padStart(6, '0');
                    } //ANO 11556 CHB 07/12/2023 
                    else if (property.code === "RACK") {
                        this.rackValue = property.value;
                    } 
                    }
                  /*
                     console.log('V DSLAM',this.DSLAM);
                     console.log('V frameValue',this.frameValue);
                     console.log('V slotValue',this.slotValue);
                     console.log('V portValue',this.portValue);
                     console.log('V dslam_nameValue',this.dslam_nameValue);
                     console.log('V providerIDValue',this.providerIDValue);
                     console.log('V nraValue',this.nraValue);
                     console.log('V positionregletteValue',this.positionregletteValue);*/
                     data.forEach(currentItem => {       
                        this.DSLAM=currentItem.value;
                         });
                             } 
            else {  
                this.__message = response.result.IPResult.result.message;
                const selectedEvent = new CustomEvent("reservationPortDSLAM", {
                    detail: [response.result.IPResult.result.message],
                });
                this.dispatchEvent(selectedEvent);   
            }
        }
    })
    .catch(error => {
        window.console.log(error);
      
    });  
 
    }
   
   
}