import { LightningElement, api, track } from 'lwc';

import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class InwiB2C_TerminalSelectionV3 extends OmniscriptBaseMixin(LightningElement) {
		isftth = false;
        __isaccessoire;
        updateOngoing=false;
        previousSelectedRowId = null; 
        @track modifiedNameAgenceLivraison = '';
       // validateEshopImei=false;
        show=false;
        
        showedImeiinput=false;
       //isInputDisabled = false;
       @track inputdisabled = false;
       @track selectedRow = null;
       @track selectedRowIds = [];
       @track agencelivraisonvalue;
       @track idrec;
       @track optionsArray= [];
       __codeArticleaReserver;
    __item;
    __provider;
    __imeiAttributeCategoriesId;
    __imeiProductAttributesId;

    __marqueAttributeCategoriesId;
    __marqueProductAttributesId;

    __modeleAttributeCategoriesId;
    __modeleProductAttributesId;

    __marqueLabelAttributeCategoriesId;
    __marqueLabelProductAttributesId;

    __modeleLabelAttributeCategoriesId;
    __modeleLabelProductAttributesId;

    __serialTypeAttributeCategoriesId;
    __serialTypeProductAttributesId;

    __stockValidatedAttributeCategoriesId;
    __stockValidatedProductAttributesId;

    __technologyAttributeCategoriesId;
    __technologyProductAttributesId;

    __filteredByOfferAttributeCategoriesId;
    __filteredByOfferProductAttributesId;

    __profilAttributeCategoriesId;
    __profilProductAttributesId;
// Y-MH offre MC_MGEN3636SF_Ajustement FTTH Begin
    __TypeWifiAttributesCategoriesId;
    __TypeWifiAttributesId;
// Y-MH offre MC_MGEN3636SF_Ajustement FTTH End


    __validationErrors = [];

    __countEvents = 0;

    __imeiValue;

    __marqueOptions = [];
    __modeleOptions = [];
    __filteredModels = [];

    __modelFilter = '';
    __modelSelectioneValue ='';

    __terminalPrice;
    __family;
    __value;
    labelvalueImeiEsn='IMEI/ESN';
    labelvalueFTTH='ESN';
    //Y_MH  MC-MGEN3759 Parcours FTTH Propre - Séparation CPE_ONU begin
    labelValueESNFtthPropre = 'Identifiant équipement' ; 
    //Y_MH  MC-MGEN3759 Parcours FTTH Propre - Séparation CPE_ONU end

    

    _ns = getNamespaceDotNotation();
    _actionUtilClass;


    __typeparcour="";

    // Y_MH Operateur d'infra
    __operateur = "" ;

    // Y_MH begin (Get Operateur)
    @api
    set operateur (value) {
      this.__operateur = value;
    }
    get operateur () {
      return this.__operateur ;
    }
// Y_MH end

disableValiderTerm = false ; // Y_MH B-30334
    
    @api
    get isaccessoire() {
      return this.__isaccessoire;
    }
    set isaccessoire(value) {
      this.__isaccessoire = value;
    }

    @api
    get provider() {
      return this.__provider;
    }
    set provider(value) {
      this.__provider = value;
    }
// Younes Begin
__isrepriseeshop = false ;
    @api
    get isrepriseeshop() {
      return this.__isrepriseeshop;
    }
    set isrepriseeshop(value) {
      this.__isrepriseeshop = value;
    }
// younes End

    @api
    get typeparcour() {
      return this.__typeparcour;
    }
    set typeparcour(value) {
      this.__typeparcour = value;
    }
    @api 
    set item(value){
        this.__item = {...value};
    }
    get item (){
        return this.__item;

    }

    get itemString (){
        return JSON.stringify(this.item);
    }

    __product;
    @api
    set product(value) {
        this.__product = {...value};
    }
    get product() {
        return this.__product;
    }
    __paiement='';
    @api
    get paiement(){
        return this.__paiement;
      }
    set paiement(value){
      this.__paiement = value;
    }

    __modelivraison="";
    @api
    get modelivraison() {
      return this.__modelivraison;
    }
    set modelivraison(value) {
      this.__modelivraison = value;
    }
    __nameagencelivraison="";
   
      @api
      set nameagencelivraison(value) {
        this.__nameagencelivraison = value;
      }
      get nameagencelivraison() {
        return this.__nameagencelivraison;
      }
      
      __codeagencelivraison="";
   
      @api
      set codeagencelivraison(value) {
        this.__codeagencelivraison = value;
      }
      get codeagencelivraison() {
        return this.__codeagencelivraison;
      }
       categorie='';
      
      __selectedmodel=false;
   
      @api
      set selectedmodel(value) {
        this.__selectedmodel = value;
      }
      get selectedmodel() {
        return this.__selectedmodel;
      }
  
     
      __displayimeiftth = true;
      @api
      set displayimeiftth(value) {
        this.__displayimeiftth = value !== undefined ? value : true;
    }
      get displayimeiftth() {
         return this.__displayimeiftth;
      }
    
      
      __reprisesuitelivraison=false;
      @api
      set  reprisesuitelivraison(value) {
        this.__reprisesuitelivraison = value;
    
      }
      get reprisesuitelivraison() {
        return this.__reprisesuitelivraison;
      } 

    
      get iseshop(){
        return this.__reprisesuitelivraison== true ||this.typeparcour === "eshop" && this.paiement==='exist' && (this.__product && !this.__product.vlocity_cmt__Type__c.includes('FTTH')) && (!this.__product.vlocity_cmt__Type__c.includes('ADSL')) ;
      

       }
      //Amine Brm B11661  
    get  CheckdisponibiliteReservationterminaux(){
        return this.modelivraison === "En Agence";

    } 

     // H-M: Disable IMEI input for a domicile eShop and televente cases (LASTMILE)
    __disabledinputimei = true;
    @api
    set disabledinputimei(value) {
      this.__disabledinputimei = value !== undefined ? value : true;
  }
    get disabledinputimei() {
       return this.__disabledinputimei;
    }
  // H-M: Disable table model for agency validation BO CRC D2D
   __isagencevalidationbocrcd2d = false;
   @api
    set isagencevalidationbocrcd2d(value){
    this.__isagencevalidationbocrcd2d = value;
   }

   get isagencevalidationbocrcd2d(){
   return this.__isagencevalidationbocrcd2d;
   }

     //Amine Brm B11661  fin
    connectedCallback() {
       

        this._actionUtilClass = new OmniscriptActionCommonUtil();
        if(this.__product && this.__product.vlocity_cmt__Type__c && this.__product.vlocity_cmt__Type__c.includes('FTTH') || (this.typeparcour ==='RepriseD2D')){
            this.isftth=true;
    }
    if(this.__product && this.__product.vlocity_cmt__Type__c && this.__product.vlocity_cmt__Type__c=='Accessoire'){
        this.isaccessoire=true;
}
    
        console.log('this.product'+this.__product);
        console.log('this.product'+this.__product);
        console.log('displayimeiftth'+this.__displayimeiftth);
        console.log('disabledinputimei'+this.__disabledinputimei);
        console.log('isftth'+this.isftth);

        console.log(("__family",this.__family));
        console.log("__nameagencelivraison",this.nameagencelivraison);
        console.log("TerminalParcoursTypeforEshopV2" +this.__typeparcour);
        console.log("__codeagencelivraison" +this.__codeagencelivraison);
        console.log('showedImeiinput' +this.showedImeiinput);
        console.log('CheckdisponibiliteReservationterminaux' +this.CheckdisponibiliteReservationterminaux);
        console.log('provider1' +this.__provider);

        console.log('provider' +this.provider);

    }

  

     
    



    get modelColumns(){

        this.__item.attributeCategories.records[0].productAttributes.records.map((item2, index) => {
         
            if (item2.code == "INWIB2C_ATT_RT_ShowPrice") {
                 this.__value = item2.userValues;
            }
        })
        
       // if (this.__family && this.__family == "Home" && value == false) {
            if (this.__value != true) {
            return [
                { label: 'Code Article', hideDefaultActions: true, fieldName: 'codeArticle',initialWidth: 150 },
                { label: 'Modèle', hideDefaultActions: true, fieldName: 'Name' }
            ];
        }else{
            return [
                { label: 'Code Article', hideDefaultActions: true, fieldName: 'codeArticle',initialWidth: 150 },
                { label: 'Modèle', hideDefaultActions: true, fieldName: 'Name'},
                { label: 'Prix', fieldName: 'price', hideDefaultActions: true, type: 'currency', typeAttributes: { currencyCode: 'MAD' },initialWidth: 200,cellAttributes: {alignment: 'center'}}
            ];
        }

    }
		
		
	get rootItemId(){
        return this.__item.vlocity_cmt__RootItemId__c.value;
    }


    get imeiAttribute (){

        let attributeCategories = this.__item.attributeCategories;
        //et imeiValue = null;

        if (attributeCategories.records){

            attributeCategories.records.forEach ((attributeCategory, index1) => {
                //console.log("index1:" + index1)

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        //console.log("index2:" + index2)
                        if (productAttribute.code == "INWIB2C_ATT_RT_IMEI"){
                            
                            console.log('found INWIB2C_ATT_RT_IMEI');

                            this.__imeiAttributeCategoriesId = index1;
                            this.__imeiProductAttributesId = index2;
                            
                        }

                        if (productAttribute.code == "INWIB2C_OFFERING_MARQUE"){
                            console.log('found INWIB2C_OFFERING_MARQUE');

                            this.__marqueAttributeCategoriesId = index1;
                            this.__marqueProductAttributesId = index2;
                        }
                        if (productAttribute.code == "INWIB2C_ATT_RT_MODELE"){
                            console.log('found INWIB2C_ATT_RT_MODELE');
                            
                            this.__modeleAttributeCategoriesId = index1;
                            this.__modeleProductAttributesId = index2;
                            console.log('found INWIB2C_ATT_RT_MODELE');
                            console.log('found INWIB2C_ATT_RT_MODELE2: '+ this.__modeleAttributeCategoriesId + ' found INWIB2C_ATT_RT_MODELE3 ' + this.__modeleProductAttributesId);
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_SerialType"){


                            this.__serialTypeAttributeCategoriesId = index1;
                            this.__serialTypeProductAttributesId = index2;
                    
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_StockValidated"){
                            
                            this.__stockValidatedAttributeCategoriesId = index1;
                            this.__stockValidatedProductAttributesId = index2;
                            console.log('StockValidatProduct'+this.__stockValidatedProductAttributesId);
                            console.log('StockValidatattribute'+this.__stockValidatedAttributeCategoriesId);
                            console.log("typeparcour"+this.__typeparcour);
                            console.log("Ftth" +this.isftth);
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_MARQUELABEL"){
                            
                            this.__marqueLabelAttributeCategoriesId = index1;
                            this.__marqueLabelProductAttributesId = index2;
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_DC_MODELELABEL"){
                            
                            this.__modeleLabelAttributeCategoriesId = index1;
                            this.__modeleLabelProductAttributesId = index2;
                    
                        }

                        if (productAttribute.code === "INWIB2C_ATT_RT_Technology"){
                            console.log('found INWIB2C_ATT_RT_Technology');
                            
                            this.__technologyAttributeCategoriesId = index1;
                            this.__technologyProductAttributesId = index2;
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_FilteredByOffer"){
                            console.log('found INWIB2C_ATT_RT_FilteredByOffer');
                            
                            this.__filteredByOfferAttributeCategoriesId = index1;
                            this.__filteredByOfferProductAttributesId = index2;
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_PROFIL"){
                            
                            console.log('found INWIB2C_ATT_RT_PROFIL');
                            this.__profilAttributeCategoriesId = index1;
                            this.__profilProductAttributesId = index2;
                            
                        }
// Y-MH offre MC_MGEN3636SF_Ajustement FTTH Begin recupérer type wifi
                        if (productAttribute.code === "INWIB2C_ATT_RT_WIFI_VERSION"){
                            
                            console.log('found INWIB2C_ATT_RT_WIFI_VERSION');
                            this.__TypeWifiAttributesCategoriesId = index1;
                            this.__TypeWifiAttributesId = index2;
                            
                        }
// Y-MH offre MC_MGEN3636SF_Ajustement FTTH end 



                    });
                }else {
                    return null;
                }
             });


             if (!this.__modeleOptions || (this.__modeleOptions && this.__modeleOptions.length == 0)){
                this.getmodeleOptions ();
             }

        }else{
            return null;
        }

        if (this.stockValidatedAttributeValue == null || this.stockValidatedAttributeValue != 'VALID'){
            let attributeError = {
                message: this.serialTypeAttributeValue + " doit être valide et oblogatoire!"
            }
    
            this.__validationErrors = [];
            this.__validationErrors.push(attributeError);
            let detail = {
                item: this.__item.Id.value,
                errors: this.__validationErrors
            };
    
            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });
      
            // Dispatches the event.
            this.dispatchEvent(customitemvalidationerror);
    
        }

        

        return this.__item.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId];
    }


    get imeiAttributeValue(){

        if (this.__imeiAttributeCategoriesId >= 0 && this.__imeiProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId].userValues;

        }else return null; 

    }

    // Y-MH offre MC_MGEN3636SF_Ajustement FTTH Begin 
    get TypeWifiAttributeValue(){

        if (this.__TypeWifiAttributesCategoriesId >= 0 && this.__TypeWifiAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__TypeWifiAttributesCategoriesId].productAttributes.records[this.__TypeWifiAttributesId].userValues;

        }else return null; 

    }
   

    set TypeWifiAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__TypeWifiAttributesCategoriesId >= 0 && this.__TypeWifiAttributesId >= 0) {

            localItem.attributeCategories.records[this.__TypeWifiAttributesCategoriesId].productAttributes.records[this.__TypeWifiAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));
        

    }
     // Y-MH offre MC_MGEN3636SF_Ajustement FTTH End


    get profilAttributeValue(){

        if (this.__profilAttributeCategoriesId >= 0 && this.__profilProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__profilAttributeCategoriesId].productAttributes.records[this.__profilProductAttributesId].userValues;

        }else return null; 

    }

    get technologyAttributeValue(){

        if (this.__technologyAttributeCategoriesId >= 0 && this.__technologyProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__technologyAttributeCategoriesId].productAttributes.records[this.__technologyProductAttributesId].userValues;

        }else return null; 

    }
    value = '';

    get options() {
        return [
            { label: 'Terminal', value: 'Terminal' },
            { label: 'Accessoire', value: 'Accesoires' },
        ];
    }
    get filteredByOfferAttributeValue(){

        if (this.__filteredByOfferAttributeCategoriesId >= 0 && this.__filteredByOfferProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__filteredByOfferAttributeCategoriesId].productAttributes.records[this.__filteredByOfferProductAttributesId].userValues;

        }else return null; 

    }

    set technologyAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__technologyAttributeCategoriesId >= 0 && this.__technologyProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__technologyAttributeCategoriesId].productAttributes.records[this.__technologyProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));
        

    }

    set filteredByOfferAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__filteredByOfferAttributeCategoriesId >= 0 && this.__technologyProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__filteredByOfferAttributeCategoriesId].productAttributes.records[this.__technologyProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));
        

    }


    

    get marqueAttributeValue () {

        if (this.__marqueAttributeCategoriesId >= 0 && this.__marqueProductAttributesId >= 0) {
            

            return this.__item.attributeCategories.records[this.__marqueAttributeCategoriesId].productAttributes.records[this.__marqueProductAttributesId].userValues;

        }else return null;

    }


    get modeleAttributeValue () {

        if (this.__modeleAttributeCategoriesId >= 0 && this.__modeleProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__modeleAttributeCategoriesId].productAttributes.records[this.__modeleProductAttributesId].userValues;

        }else return null;

    }

    get marqueLabelAttributeValue () {

        if (this.__marqueLabelAttributeCategoriesId >= 0 && this.__marqueLabelProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__marqueLabelAttributeCategoriesId].productAttributes.records[this.__marqueLabelProductAttributesId].userValues;

        }else return null;

    }


    get modeleLabelAttributeValue () {

        if (this.__modeleLabelAttributeCategoriesId >= 0 && this.__modeleLabelProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__modeleLabelAttributeCategoriesId].productAttributes.records[this.__modeleLabelProductAttributesId].userValues;

        }else return null;

    }

    

    set marqueAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__marqueAttributeCategoriesId >= 0 && this.__marqueProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__marqueAttributeCategoriesId].productAttributes.records[this.__marqueProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));
        

    }
    
    set modeleAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__modeleAttributeCategoriesId >= 0 && this.__modeleProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__modeleAttributeCategoriesId].productAttributes.records[this.__modeleProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));

    }

    set marqueLabelAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__marqueLabelAttributeCategoriesId >= 0 && this.__marqueLabelProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__marqueLabelAttributeCategoriesId].productAttributes.records[this.__marqueLabelProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));
        //this.getmodeleOptions();

    }
    
    set modeleLabelAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__modeleLabelAttributeCategoriesId >= 0 && this.__modeleLabelProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__modeleLabelAttributeCategoriesId].productAttributes.records[this.__modeleLabelProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));

    }

    set imeiAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__imeiAttributeCategoriesId >= 0 && this.__imeiProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));

    }


    get serialTypeAttributeValue () {

        if (this.__serialTypeAttributeCategoriesId >= 0 && this.__serialTypeProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__serialTypeAttributeCategoriesId].productAttributes.records[this.__serialTypeProductAttributesId].userValues;

        }else return null;

    }

    get stockValidatedAttributeValue () {

        if (this.__stockValidatedAttributeCategoriesId >= 0 && this.__stockValidatedProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__stockValidatedAttributeCategoriesId].productAttributes.records[this.__stockValidatedProductAttributesId].userValues;

        }else return null;

    }

    set stockValidatedAttributeValue (value) {

        let localItem = JSON.parse(JSON.stringify(this.__item));

        if (this.__stockValidatedAttributeCategoriesId >= 0 && this.__stockValidatedProductAttributesId >= 0) {

            localItem.attributeCategories.records[this.__stockValidatedAttributeCategoriesId].productAttributes.records[this.__stockValidatedProductAttributesId].userValues = value;

        }

        this.__item = JSON.parse(JSON.stringify(localItem));

    }

    /*filterModels (evt){

        evt.stopPropagation();

        //console.log(evt.keyCode);
        var filterInput = this.template.querySelector(".modelFilterInput");
        var value = filterInput.value;

        console.log(value);

        if (value && value !== '' ){

            this.__filteredModels = this.__modeleOptions.filter(model => {

                return (model.codeArticle.toUpperCase().includes(value.toUpperCase()) || model.Name.toUpperCase().includes(value.toUpperCase()));

            });


        }else {
            this.__filteredModels = this.__modeleOptions;
        }

        //console.log(this.__filteredModels);
    }*/

    searchTerminal(evt){
        evt.stopPropagation();
        this.getmodeleOptions();


    }
    handleChangeSelection(event){
        this.categorie = event.target.value;
    }
    hanldleFilterEntry(event){

        event.stopPropagation();
        this.__modelFilter = event.detail.value;
        
    }


    getmodeleOptions (){


            console.log("this.filteredByOfferAttributeValue: "+ this.filteredByOfferAttributeValue);
            console.log("this.technologyAttributeValue: "+ this.technologyAttributeValue);
            console.log("this.profilAttributeValue: "+ this.profilAttributeValue);
            console.log("this.operateur: "+ this.operateur);
            console.log("this.isrepriseeshop "+ this.isrepriseeshop);
            console.log("this.typeparcourEshop : "+ this.typeparcour);

            this.__modeleOptions = [];
            //this.__modelSelectioneValue= this.modeleAttributeValue +' : '+ this.modeleLabelAttributeValue;

            const filter = (! this.__modelFilter || (this.__modelFilter && (this.__modelFilter.replace(/\s\s+/g, ' ') == ' ' || this.__modelFilter == '')))?'%':this.__modelFilter;
        if (this.provider!='' && this.provider != null && (this.operateur == '' || this.operateur == null || this.operateur == 'INWI')) {
        // Y-MH offre MC_MGEN3636SF_Ajustement FTTH Begin 
        if (this.typeparcour === 'eshop' && this.isrepriseeshop == true ) {
            let input = '{"rootItemId": "' + this.__item.vlocity_cmt__RootItemId__c.value+  '", "filteredByOffer": "'+ this.filteredByOfferAttributeValue+ '","technology": "'+ this.technologyAttributeValue +'","profilIN": "'+ this.profilAttributeValue+ '","modelName": "'+ filter+ '","codeArticle": "'+ filter+ '","categorie": "'+this.categorie+ '" , "provider": "'+this.provider+ '" , "TypeWifi": "'+this.TypeWifiAttributeValue+ '"}';

            console.log('input : ' + input);

            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_GetModelWithTypeWifi',
                options: '{}',
            };
       
            console.log('before call inwib2c_inwiB2C_GetModelWithTypeWifi' + params);
        
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log((response));
                    if (response.error == false) {
                        //console.log(response);

                        if (response.result && response.result.IPResult && response.result.IPResult.Modeles) {

                            let modeles = response.result.IPResult.Modeles;

                            /*this.__modeleOptions = modeles.map(modele => {

                                let newOption = [];
                                newOption.label = modele.NameModel;
                                newOption.value = modele.codeArticle;
                                return newOption;

                            });*/

                            

                            this.__modeleOptions = JSON.parse(JSON.stringify(modeles));
                            this.__family = response.result.IPResult.Family;

                           if(this.typeparcour === "eshop" || this.typeparcour === 'RepriseD2D' ||  this.typeparcour === 'Televente' ){ 
 
                            console.log('le code article correspend est' +this.modeleAttributeValue);
                               // Find the row that matches the desired value ('desiredValue')
                            const desiredValue = this.modeleAttributeValue.trim(); // '000056085'
                            console.log('Desired Value: ' + desiredValue);
                            console.log('Modele Options: ' + JSON.stringify(this.__modeleOptions));
                            const matchedRow = this.__modeleOptions.find(row => row.codeArticle === desiredValue);
                            //const matchedRow1 =  this.__modeleOptions.find(row => row.codeArticle === '100001978');
                            console.log('matchedRow: ' +JSON.stringify(matchedRow));
                            console.log('AmineNEW');                        
                            //console.log('matchedRow1: ' +stringify(matchedRow1));
                            // Set the selectedRowIds to the matched row ID, if found
                            this.selectedRowIds = matchedRow ? [matchedRow.codeArticle] : [];
                            console.log('selectedRowIds: ' +this.selectedRowIds);
                            this.__terminalPrice = matchedRow ? matchedRow.price : null;
                            console.log('terminalPriceMatched' +this.__terminalPrice);
                            //this.adjustPrice();
                            //     // Disable other rows
                            //     this.__modeleOptions = this.__modeleOptions.map((row) => ({
                            //     ...row,
                            //    //disabled: row.codeArticle !== desiredValue,
                            //    disabled: matchedRow ? row.codeArticle !== desiredValue : true,
                            //    }));
                             }

              
                            
                        
                        }
                    }else {
                        console.log('Erreur lors de la récupération des modèles');
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération des modèles',
                            variant: 'error'
                            }),
                        );
                    }


                })
                .catch(error => {
                    window.console.log(error);
                });    
        } // Y-MH offre MC_MGEN3636SF_Ajustement FTTH End 
        else {
            let input = '{"rootItemId": "' + this.__item.vlocity_cmt__RootItemId__c.value+  '", "filteredByOffer": "'+ this.filteredByOfferAttributeValue+ '","technology": "'+ this.technologyAttributeValue +'","profilIN": "'+ this.profilAttributeValue+ '","modelName": "'+ filter+ '","codeArticle": "'+ filter+ '","categorie": "'+this.categorie+ '" , "provider": "'+this.provider+ '"}';

            console.log('input : ' + input);

            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_inwiB2C_GetModelWithPriceANDProvider',
                options: '{}',
            };
       
            console.log('before call inwib2c_inwiB2C_GetModelWithPrice' + params);
        
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log((response));
                    if (response.error == false) {
                        //console.log(response);

                        if (response.result && response.result.IPResult && response.result.IPResult.Modeles) {

                            let modeles = response.result.IPResult.Modeles;

                            /*this.__modeleOptions = modeles.map(modele => {

                                let newOption = [];
                                newOption.label = modele.NameModel;
                                newOption.value = modele.codeArticle;
                                return newOption;

                            });*/

                            

                            this.__modeleOptions = JSON.parse(JSON.stringify(modeles));
                            this.__family = response.result.IPResult.Family;

                           if(this.typeparcour === "eshop" || this.typeparcour === 'RepriseD2D' ||  this.typeparcour === 'Televente' ){ 
 
                            console.log('le code article correspend est' +this.modeleAttributeValue);
                               // Find the row that matches the desired value ('desiredValue')
                            const desiredValue = this.modeleAttributeValue.trim(); // '000056085'
                            console.log('Desired Value: ' + desiredValue);
                            console.log('Modele Options: ' + JSON.stringify(this.__modeleOptions));
                            const matchedRow = this.__modeleOptions.find(row => row.codeArticle === desiredValue);
                            //const matchedRow1 =  this.__modeleOptions.find(row => row.codeArticle === '100001978');
                            console.log('matchedRow: ' +JSON.stringify(matchedRow));
                            console.log('AmineNEW');                        
                            //console.log('matchedRow1: ' +stringify(matchedRow1));
                            // Set the selectedRowIds to the matched row ID, if found
                            this.selectedRowIds = matchedRow ? [matchedRow.codeArticle] : [];
                            console.log('selectedRowIds: ' +this.selectedRowIds);
                            this.__terminalPrice = matchedRow ? matchedRow.price : null;
                            console.log('terminalPriceMatched' +this.__terminalPrice);
                            //this.adjustPrice();
                            //     // Disable other rows
                            //     this.__modeleOptions = this.__modeleOptions.map((row) => ({
                            //     ...row,
                            //    //disabled: row.codeArticle !== desiredValue,
                            //    disabled: matchedRow ? row.codeArticle !== desiredValue : true,
                            //    }));
                             }

                            // const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                            //    detail: this.__item
                            //});
                             
                            // Dispatches the event.
                           // this.dispatchEvent(selectedEvent);
                            
                        
                        }
                    }else {
                        console.log('Erreur lors de la récupération des modèles');
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération des modèles',
                            variant: 'error'
                            }),
                        );
                    }


                })
                .catch(error => {
                    window.console.log(error);
                });

            }}
            // Y_MH begin (appel a la vip inwiB2C_GetModelWithPriceANDOperatorOI dans le cas operateur different de inwi ) 
         else if (this.operateur == 'ORANGE' || this.operateur == 'IAM') { //Y_MH B-31701	
            let input = '{"rootItemId": "' + this.__item.vlocity_cmt__RootItemId__c.value+  '", "filteredByOffer": "'+ this.filteredByOfferAttributeValue+ '","technology": "'+ this.technologyAttributeValue +'","profilIN": "'+ this.profilAttributeValue+ '","modelName": "'+ filter+ '","codeArticle": "'+ filter+ '","categorie": "'+this.categorie+ '" , "operateur": "'+this.operateur+ '"}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_GetModelWithPriceANDOperatorOI',
            options: '{}',
        };
   
        console.log('before call inwiB2C_GetModelWithPriceANDOperator' + params);
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    //console.log(response);

                    if (response.result && response.result.IPResult && response.result.IPResult.Modeles) {

                        let modeles = response.result.IPResult.Modeles;

                        /*this.__modeleOptions = modeles.map(modele => {

                            let newOption = [];
                            newOption.label = modele.NameModel;
                            newOption.value = modele.codeArticle;
                            return newOption;

                        });*/

                        

                        this.__modeleOptions = JSON.parse(JSON.stringify(modeles));
                        this.__family = response.result.IPResult.Family;

                       if(this.typeparcour === "eshop" || this.typeparcour === 'RepriseD2D' ||  this.typeparcour === 'Televente' ){ 

                        console.log('le code article correspend est' +this.modeleAttributeValue);
                           // Find the row that matches the desired value ('desiredValue')
                        const desiredValue = this.modeleAttributeValue.trim(); // '000056085'
                        console.log('Desired Value: ' + desiredValue);
                        console.log('Modele Options: ' + JSON.stringify(this.__modeleOptions));
                        const matchedRow = this.__modeleOptions.find(row => row.codeArticle === desiredValue);
                        //const matchedRow1 =  this.__modeleOptions.find(row => row.codeArticle === '100001978');
                        console.log('matchedRow: ' +JSON.stringify(matchedRow));
                        console.log('AmineNEW');                        
                        //console.log('matchedRow1: ' +stringify(matchedRow1));
                        // Set the selectedRowIds to the matched row ID, if found
                        this.selectedRowIds = matchedRow ? [matchedRow.codeArticle] : [];
                        console.log('selectedRowIds: ' +this.selectedRowIds);
                        this.__terminalPrice = matchedRow ? matchedRow.price : null;
                        console.log('terminalPriceMatched' +this.__terminalPrice);
                        //this.adjustPrice();
                        //     // Disable other rows
                        //     this.__modeleOptions = this.__modeleOptions.map((row) => ({
                        //     ...row,
                        //    //disabled: row.codeArticle !== desiredValue,
                        //    disabled: matchedRow ? row.codeArticle !== desiredValue : true,
                        //    }));
                         }

                         

          
                    }
                }else {
                    console.log('Erreur lors de la récupération des modèles');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération des modèles',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
        }
// Y_MH end 
            else {
            let input = '{"rootItemId": "' + this.__item.vlocity_cmt__RootItemId__c.value+  '", "filteredByOffer": "'+ this.filteredByOfferAttributeValue+ '","technology": "'+ this.technologyAttributeValue +'","profilIN": "'+ this.profilAttributeValue+ '","modelName": "'+ filter+ '","codeArticle": "'+ filter+ '","categorie": "'+this.categorie+ '" }';

            console.log('input : ' + input);

            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_inwiB2C_GetModelWithPrice',
                options: '{}',
            };
       
            console.log('before call inwib2c_inwiB2C_GetModelWithPrice' + params);
        
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log((response));
                    if (response.error == false) {
                        //console.log(response);

                        if (response.result && response.result.IPResult && response.result.IPResult.Modeles) {

                            let modeles = response.result.IPResult.Modeles;

                            /*this.__modeleOptions = modeles.map(modele => {

                                let newOption = [];
                                newOption.label = modele.NameModel;
                                newOption.value = modele.codeArticle;
                                return newOption;

                            });*/

                            

                            this.__modeleOptions = JSON.parse(JSON.stringify(modeles));
                            this.__family = response.result.IPResult.Family;

                           if(this.typeparcour === "eshop" || this.typeparcour === 'RepriseD2D' ||  this.typeparcour === 'Televente' ){ 
 
                            console.log('le code article correspend est' +this.modeleAttributeValue);
                               // Find the row that matches the desired value ('desiredValue')
                            const desiredValue = this.modeleAttributeValue.trim(); // '000056085'
                            console.log('Desired Value: ' + desiredValue);
                            console.log('Modele Options: ' + JSON.stringify(this.__modeleOptions));
                            const matchedRow = this.__modeleOptions.find(row => row.codeArticle === desiredValue);
                            //const matchedRow1 =  this.__modeleOptions.find(row => row.codeArticle === '100001978');
                            console.log('matchedRow: ' +JSON.stringify(matchedRow));
                            console.log('AmineNEW');                        
                            //console.log('matchedRow1: ' +stringify(matchedRow1));
                            // Set the selectedRowIds to the matched row ID, if found
                            this.selectedRowIds = matchedRow ? [matchedRow.codeArticle] : [];
                            console.log('selectedRowIds: ' +this.selectedRowIds);
                            this.__terminalPrice = matchedRow ? matchedRow.price : null;
                            console.log('terminalPriceMatched' +this.__terminalPrice);
                            //this.adjustPrice();
                            //     // Disable other rows
                            //     this.__modeleOptions = this.__modeleOptions.map((row) => ({
                            //     ...row,
                            //    //disabled: row.codeArticle !== desiredValue,
                            //    disabled: matchedRow ? row.codeArticle !== desiredValue : true,
                            //    }));
                             }

              
                            
                        
                        }
                    }else {
                        console.log('Erreur lors de la récupération des modèles');
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération des modèles',
                            variant: 'error'
                            }),
                        );
                    }


                })
                .catch(error => {
                    window.console.log(error);
                });

            }   
    }

    get marqueAttribute(){

        console.log('this.__marqueAttributeCategoriesId: '+ this.__marqueAttributeCategoriesId + ' this.__marqueProductAttributesId: ' + this.__marqueProductAttributesId);

        if (this.__marqueAttributeCategoriesId >= 0 && this.__marqueProductAttributesId >= 0) {
            return this.__item.attributeCategories.records[this.__marqueAttributeCategoriesId].productAttributes.records[this.__marqueProductAttributesId];
        } else return null;
        

    }

    get modelAttribute(){
        console.log('this.__modeleAttributeCategoriesId: '+ this.__modeleAttributeCategoriesId + ' this.__modeleProductAttributesId: ' + this.__modeleProductAttributesId);

        if (this.__modeleAttributeCategoriesId >= 0 && this.__modeleProductAttributesId >= 0) {
            return this.__item.attributeCategories.records[this.__modeleAttributeCategoriesId].productAttributes.records[this.__modeleProductAttributesId];
        }else return null;
        

    }

    

    

  
    // handleChangeModele(event) {
    //     event.stopPropagation();
    //     const selectedRows = event.detail.selectedRows;


    //     if (selectedRows.length > 0) {
    //         this.modeleAttributeValue = selectedRows[0].codeArticle;
    //         this.modeleLabelAttributeValue = selectedRows[0].Name;
    //         this.__terminalPrice = selectedRows[0].price;
    //     }
    
        
    // }
 
    

     handleChangeModele(event) {
        event.stopPropagation();
        const selectedRows = event.detail.selectedRows;
        
        this.selectedRowIds = [...selectedRows.map(row => row.codeArticle)];
        console.log("Saved selection:", this.selectedRowIds);
    
        if (selectedRows.length > 0) {
            const currentSelectedRowId = selectedRows[0].codeArticle;
    
            if (currentSelectedRowId !== this.previousSelectedRowId) {
                this.previousSelectedRowId = currentSelectedRowId;
    
                this.modeleAttributeValue = selectedRows[0].codeArticle;
                this.modeleLabelAttributeValue = selectedRows[0].Name;
                this.__terminalPrice = selectedRows[0].price;
                this.__codeArticleaReserver = selectedRows[0].codeArticle;
                //this.__modelSelectioneValue = `${selectedRows[0].codeArticle} : ${selectedRows[0].Name}`;
                this.__modelSelectioneValue= selectedRows[0].codeArticle +' : '+ selectedRows[0].Name;

                if ((this.typeparcour === 'Televente' && this.selectedmodel) || (this.typeparcour === 'eshop' && this.selectedmodel)) {
                   this.updateOngoing = true;
                   this.AdjustPriceWithoutImei();
                   
                
                  const customEvent = new CustomEvent("customvalidatecodearticle", {
                      detail: {
                          displayconfigurationanderror: false
                     } 
                  });
    
                  this.dispatchEvent(customEvent);
                }
        }
    }
}
   
    ValidateCodeArticle() {
        try {
            this.AdjustPriceWithoutImei();
    
            // Préparation et dispatch de l'événement personnalisé
            const customEvent = new CustomEvent("customvalidatecodearticle", {
                detail: {
                    displayconfigurationanderror: false
                }
            });
    
            this.dispatchEvent(customEvent);
        } catch (error) {
            // Gestion des erreurs éventuelles lors de l'exécution
            console.error('Error during handleButtonClick:', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Une erreur est survenue lors de l\'exécution.',
                    variant: 'error'
                })
            );
        }
    }
    
    
    



    hanldleImeiEntry(event) {
        event.stopPropagation();

        let imei = event.detail.value;

        //console.log(icc + '  ' +  event.keyCode);

        this.__imeiValue = imei;

        //console.log("In manage end : " + JSON.stringify(this.__item));
    }

    validateIMEI(event) {
        event.stopPropagation();
        this.disableValiderTerm = true ; // Y_MH B-30334
        console.log('disableValiderTerm a lappelll', this.disableValiderTerm  ) ; 
            // Search B.E. service

            var imeiInput = this.template.querySelector(".imeiInput");
            var value = imeiInput.value;
            // is input valid text?
            if (this.serialTypeAttributeValue == 'IMEI'){
              //  if (value.length != 15 || ! value.match(/^[0-9]+$/)) {
              //      imeiInput.setCustomValidity("L'IMEI saisi est incorrect. il doit être sur 15 caractères et ne doit comporter que des chiffre.");
             //   } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();

                    
                    /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                        detail: this.__item
                    });
              
                    // Dispatches the event.
                    this.dispatchEvent(selectedEvent);*/
             //   }

            }
            else if (this.serialTypeAttributeValue == 'ESN'){
               // if (value.length != 12 || ! value.match(/^[0-9A-Za-z]+$/)) {
                //    imeiInput.setCustomValidity("L'ESN saisi est incorrect. il doit être sur 12 caractères.");
              //  } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();
               // }

            }


            else if (this.serialTypeAttributeValue == 'MAC'){
                // Amine brm Suite Ano B-15997 
                // if (value.length != 12 || ! value.match(/^[0-9A-Za-z]+$/)) {
                //     imeiInput.setCustomValidity("Le MAC saisi est incorrect. il doit être sur 12 caractères.");
                // } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();
                //}

            }
            imeiInput.reportValidity(); // Tells lightning-input to show the error right away without needing interaction
      

           
        
    }

    get imeiLabel(){
        //Y_MH  MC-MGEN3759 Parcours FTTH Propre - Séparation CPE_ONU begin
        if (this.operateur == '' || this.operateur == null || this.operateur == 'INWI')  {
            return this.labelValueESNFtthPropre ; 
        }else{
            if (this.serialTypeAttributeValue == 'IMEI' || this.serialTypeAttributeValue =='ESN') {
         
         return this.labelvalueImeiEsn;

      
        }else if(this.serialTypeAttributeValue =='MAC' && this.isftth==true){
            //Amine Brm Ano B-15384
            return this.labelvalueFTTH;

        }
        else{    
        return this.serialTypeAttributeValue 
    }       
        }
        //Y_MH  MC-MGEN3759 Parcours FTTH Propre - Séparation CPE_ONU end
    }
    get imeiDisabled(){
        console.log('Valeur de this.typeparcour:', this.typeparcour);
        let disabled;
        console.log('Valeur de stock :',this.stockValidatedAttributeValue );
        if (this.typeparcour && this.typeparcour === 'RepriseD2D') {
            disabled = false;
        }else {
            disabled = (this.stockValidatedAttributeValue != null && this.stockValidatedAttributeValue == 'VALID');
        }
         
        // Log la valeur de 'disabled' avant de la retourner
        console.log('Valeur de imeiDisabled:', disabled);
        return disabled;
    }

    get modelSelectioneValue(){
        if(this.modeleAttributeValue != null && this.modeleLabelAttributeValue != null){
            console.log('codearticle'+this.modeleAttributeValue);
           return this.__modelSelectioneValue= this.modeleAttributeValue +' : '+ this.modeleLabelAttributeValue;

        } else return this.__modelSelectioneValue;
    }

    get isCodeArticleNotEmpty() {
        console.log('La valeure de modele est ' +this.modeleAttributeValue);
        return this.modeleAttributeValue != null;
    }
    // get inputdisabled() {
    //     return  this.validateEshopImei ;
        
    //  }

    //  set inputdisabled(value){
    //      this.validateEshopImei=value ;

    // //         const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
    // //             detail: this.__item
    // //         });
    // //         this.dispatchEvent(selectedEvent);

        


    //  }
    searchIMEI() {
        this.updateOngoing=true;

        let input = '{"orderId": "'+ this.__item.OrderId.value+ '","handset": [{"code":"' + this.modeleAttributeValue + '","serialNumber": "'+ this.__imeiValue + '","type": "'+ this.serialTypeAttributeValue + '","technology": "GSM","offerType": "FM","orderType": "MOBILE",';
        input += '"vendor": "CPD01","distributorCode": "CPD01","region": "PGSM","quantity": "1"}],"operation": "RS", "username": "Djamel", "rootItemId" : "'+ this.rootItemId+ '"}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_LockArticle2',
            options: '{}',
        };

        console.log('before call apex1' + params);
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    //console.log(response);

                    if (response.result && response.result.IPResult && response.result.IPResult.CSOperationResultInfo) {
                        if (response.result.IPResult.CSOperationResultInfo.isOK &&  response.result.IPResult.CSOperationResultInfo.isOK == "1"){
                            this.imeiAttributeValue = this.__imeiValue;
                            this.stockValidatedAttributeValue = 'VALID';
                            
                            // Dispatches the event.
                            /*this.dispatchEvent(selectedEvent);

                            let detail = {
                                item: this.__item.Id.value,
                                errors: []
                            };
                            */
                            // if (this.__family && this.__family != "Home") {

                    //H-M Dispatch vers le parent pour indiquer que le champ ESN est bien rempli le reprise eshop et televnte suite livraion Begin 
                    const customDeviceAccessValidated = new CustomEvent('customdeviceaccessvalidated', {
                        detail: {
                            isValid: true
                        }
                    });
                    this.dispatchEvent(customDeviceAccessValidated);
                    //H-M Dispatch vers le parent pour indiquer que le champ ESN est bien rempli le reprise eshop et televnte suite livraion END
                               
                                if ( this.__value == true) {
                                    this.adjustPrice();
                            }
                            else {

                                const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                                    detail: this.__item
                                });
                                this.dispatchEvent(selectedEvent);

                            }

                            let detail = {
                                item: this.__item.Id.value,
                                errors: []
                            };
                    
                            const attributeErrorEvent = new CustomEvent("customitemvalidationerror", {
                                detail: detail
                            });
                      
                            // Dispatches the event.
                            this.dispatchEvent(attributeErrorEvent);

                            
                        }else{
                            this.updateOngoing=false;
                            this.disableValiderTerm = false ; // Y_MH B-30334
                            console.log('disableValiderTerm cas erreur', this.disableValiderTerm  ) ; 
                            

                            if (response.result.IPResult.CSValidateLineAttributesInteraction && response.result.IPResult.CSValidateLineAttributesInteraction.length >0 && response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange && response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange.length > 0){
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur :' + response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorCode ,
                                    message: response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorMessage,
                                    variant: 'error'
                                    }),
                                );
                            }else {

                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Le Pack n\'est plus disponible. Veuillez choisir un autre pack',
                                    variant: 'error'
                                    }),
                                );

                            }

                            

                        }
                    
                    }
                }else {
                    this.disableValiderTerm = false ; // Y_MH B-30334
                    console.log('disableValiderTerm cas erreur 1', this.disableValiderTerm  ) ; 
                    console.log('Erreur lors de la récupération de la SIM');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération des informations de la du terminal',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });


    }

 
    async AdjustPriceWithoutImei() {
        try {
            const orderId = this.__item.OrderId.value;
            const itemId = this.__item.Id.value;
    
            const inputParams = {
                adjustments: [
                    {
                        AdjustmentMethod: "Absolute",
                        AdjustmentType: "Override",
                        AdjustmentValue: this.__terminalPrice,
                        DetailType: "OVERRIDE",
                        Field: "vlocity_cmt__OneTimeCharge__c",
                        PricingVariableCode: "OT_STD_PRC"
                    }
                ],
                cartId: orderId,
                id: itemId,
                methodName: "applyAdjustment"
            };
    
            const params = {
                input: JSON.stringify(inputParams),
                sClassName: 'vlocity_cmt.CpqAppHandler',
                sMethodName: 'applyAdjustment',
                options: '{}',
            };
    
            console.log('Before calling applyAdjustment');
    
            const response = await this._actionUtilClass.executeAction(params, null, this, null, null);
    
            console.log(response);
    
            const selectedEvent = new CustomEvent("customitemattributeswithoutimei", {
                detail: this.__item
            });
    
            this.dispatchEvent(selectedEvent);
    
            this.updateOngoing = false; 
            console.log('Before dispatching success toast');
    
        } catch (error) {
            window.console.log(error);
            this.updateOngoing = false; 
        }
    }
    

   


    adjustPrice (){

        //console.log(JSON.stringify(updatedItemAttributes));

        console.log('In Adjust Price');
        console.log('In Adjust Price add'+this.__terminalPrice);
    


        const orderId = this.__item.OrderId.value;
        const itemId = this.__item.Id.value;

        const inputParams = {
            adjustments: [
              {
                AdjustmentMethod: "Absolute",
                AdjustmentType: "Override",
                AdjustmentValue: this.__terminalPrice,
                DetailType: "OVERRIDE",
                Field: "vlocity_cmt__OneTimeCharge__c",
                PricingVariableCode: "OT_STD_PRC"
              }
            ],
            cartId: orderId,
            id: itemId,
            methodName: "applyAdjustment"
          };

          console.log('inputParams' +inputParams);


        const params = {
            input: JSON.stringify(inputParams),
            sClassName: 'vlocity_cmt.CpqAppHandler',
            sMethodName: 'applyAdjustment',
            options: '{}',
        };

        console.log('before call applyAdjustment');
        
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));

                const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                    detail: this.__item
                });
          
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);

                this.updateOngoing=false;

            })
            .catch(error => {
                window.console.log(error);
        });

    }

    //AmineBrm debut Evolution B-11661
    handleChanged(event){

  
        this.agencelivraisonvalue= event.target.value; 
        if (this.agencelivraisonvalue=='') {
          this.show=false;
          
        } else {
          this.show=true;
          
        }
      
        this._actionUtil = new OmniscriptActionCommonUtil();
          
        const params = {
         input: '{"search":"'+this.agencelivraisonvalue+'"}',
         sClassName: `${this._ns}IntegrationProcedureService`,
         sMethodName: "inwib2c_Get_All_Agence",
         options: '{}'
       };
       this._actionUtil
         .executeAction(params, null, this, null, null)
         .then(response => {
          console.log('response');
           console.log('response' + response.result.IPResult);
           console.log(JSON.stringify(response.result.IPResult));
           JSON.parse(JSON.stringify(response.result.IPResult));
           let res = response.result.IPResult.List;
           
       
           console.log('res');
           console.log(res);
            
           this.optionsArray=res ;
           
           console.log('thisoptions:' +res);
      
         })
         .catch(error => {
           console.log("error");
           window.console.log(error);
         });
        
      }

      handleSelect(event) {
        this.show=false;
        this.agencelivraisonvalue=event.target.dataset.codeagence+', '+event.target.dataset.name  ;
        this.idrec = event.target.dataset.idacc;
        console.log('handleSelect');
        console.log(this.idrec);
        console.log(this.agencelivraisonvalue);
      
      this.template.querySelector(".agenceName").value= this.agencelivraisonvalue;
      console.log("JustAfterSelectedValue");
      let code= event.target.dataset.codeagence;
      console.log("selectedCodeAgence");
      console.log("selectedCodeAgenceValue"+code)
      this.__codeagencelivraison= event.target.dataset.codeagence;
      this.__nameagencelivraison=event.target.dataset.codeagence+', '+event.target.dataset.name;
      this.modifiedNameAgenceLivraison = event.target.dataset.codeagence + ', ' + event.target.dataset.name;      console.log("this.codeAgenceValue"+this.__codeagencelivraison);
      console.log("this.__nameagencelivraison"+this.__nameagencelivraison);

            //   this.omniUpdateDataJson(AgenceResult);
            //   this.omniSaveState(AgenceResult, true);
              this.optionsArray=[];
      
      
      }  


      CheckDisponibiliteTerminal(){
        this.updateOngoing=true;
        console.log("TEST");
        //this.selectedRowIds = [...selectedRows.map(row => row.codeArticle)];
        // this.__codeArticleaReserver = this.selectedRowIds;
        /* B-20905 M-Dj bien recuperer le code article pour cette fonction begin */
        this.__codeArticleaReserver = this.modeleAttributeValue;
        /* B-20905 M-Dj bien recuperer le code article pour cette fonction end */
        console.log("RowSelected3" +this.selectedRowIds);
        console.log("modeleAttributeValueTest3", +this.__codeArticleaReserver);


        let input = '{"orderId": "'+ this.__item.OrderId.value+ '","handset": [{"code":"' + this.__codeArticleaReserver + '","serialNumber": "","type": "'+ this.serialTypeAttributeValue + '","technology": "GSM","offerType": "FM","orderType": "MOBILE",';
        input += '"vendor": "'+ this.__codeagencelivraison+ '","distributorCode": "'+ this.__codeagencelivraison+ '","region": "PGSM","quantity": "1"}],"operation": "RS", "username": "Amine Brm", "rootItemId" : "'+ this.rootItemId+ '"}';

        console.log('input CheckDisponibiliteTerminal: ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_ReservationTerminalAgence', 
            options: '{}',
        };

        console.log('before call api CheckDisponibiltéTerminal' + params);

        this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
            console.log((response));
            if (response.error == false) {

                if (response.result && response.result.IPResult && response.result.IPResult.CSOperationResultInfo) {
                    if (response.result.IPResult.CSOperationResultInfo.isOK &&  response.result.IPResult.CSOperationResultInfo.isOK == "1"){
                        let valueImei =  response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSMobileEquipmentIdentity[0].imei;
                        console.log('imeiReturne est' +valueImei);
                        this.imeiAttributeValue=  response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSMobileEquipmentIdentity[0].imei;
                        this.stockValidatedAttributeValue = 'VALID';
                       
                            const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                                detail: this.__item
                            });
                            
                            this.dispatchEvent(selectedEvent);

                            // Update the nameagencelivraison value
                      this.nameagencelivraison = this.modifiedNameAgenceLivraison;
                      console.log('agenceTest'+this.nameagencelivraison);

                    
                    this.template.querySelector(".agenceName").value= this.agencelivraisonvalue;
                   
                        let detail = {
                            item: this.__item.Id.value,
                            errors: []
                        };
                
                        const attributeErrorEvent = new CustomEvent("customitemvalidationerror", {
                            detail: detail
                        });
                  
                        // Dispatches the event.
                        this.dispatchEvent(attributeErrorEvent);

                        
                    }else{
                        this.updateOngoing=false;

                        // if (response.result.IPResult.CSValidateLineAttributesInteraction && response.result.IPResult.CSValidateLineAttributesInteraction.length >0 && response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange && response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange.length > 0){
                        //     this.dispatchEvent(
                        //         new ShowToastEvent({
                        //         title: 'Erreur :' + response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorCode ,
                        //         message: response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorMessage,
                        //         variant: 'error'
                        //         }),
                        //     );
                        // }else {

                        //     this.dispatchEvent(
                        //         new ShowToastEvent({
                        //         title: 'Erreur',
                        //         message: 'Le Pack n\'est plus disponible. Veuillez choisir un autre pack',
                        //         variant: 'error'
                        //         }),
                        //     );

                        // }

                        //D'apres MOA  on retourne Un message Generique dans cas reservation n'est pas réussi
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message:'La réservation de l\'article a échoué',
                                variant: 'error'
                                }),
                            );

                           

                    }
                
                }
            }
            else {
                console.log('Erreur lors de la récupération API TIME OUT');
                this.updateOngoing=false;


                        //D'apres MOA  on retourne Un message Generique dans cas reservation n'est pas réussi
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message:'La réservation de l\'article a échoué',
                                variant: 'error'
                                }),
                            );

                  
            }




        })
        .catch(error => {
            window.console.log(error);
        });

    
      }
    //Fin Evolution B-11661
    renderedCallback(){
        console.log('error'+this.__product);
  
    }

    validateTerminalOnly(event){
        event.stopPropagation();
        this.stockValidatedAttributeValue = 'VALID'

        const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });
        this.dispatchEvent(selectedEvent);
    }


}