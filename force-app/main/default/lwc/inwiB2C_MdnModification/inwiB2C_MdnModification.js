import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_MdnModification extends OmniscriptBaseMixin(LightningElement) {

    records ;
    __item;
    __selectedmdn = '';
    __userProfile;
    __segmentOffer;

    isCameleon=false;

    mdnChoice;
    isRecoverMdnOption = false;

    @track isRecovered = false;
    typeRecoveredMDN;
    __mdnchoice;
    isFTTHs=false;
    @track TypeDeNumero;
    @track isNumberChosen = false;
    @track __PriceNumber;
    recoveredFlag = true;
    showRecupOption = false;


    __selectedmdnListItem;


    _actionUtilClass;
    _ns = getNamespaceDotNotation();
   
     typemdnattributevalue;
     OffreAttributeValue;
     CategoryAttributeValue;
     NbresultAttributeValue;
     mdnFilterAttributeValue = '';
     __validationErrors = [];
    
    

     // Modif 

     __mdnTypeAttributeCategoriesId;
     __mdnTypeProductAttributesId;

     __mdnAttributeCategoriesId;
     __mdnProductAttributesId;

     __mdnTypeValue;

    __mdnChoiceAttributeCategoriesId;
    __mdnChoiceProductAttributesId;

    __ocsIdAttributeCategoriesId ;
    __ocsIdProductAttributesId ;
    @api regionName;

    
     @api 
    set item(value){
        this.__item = {...value};
    }

    get Changed(){

        return this.item.action.includes("Change")

    }
    
    get item(){
        return this.__item;

    }
    @api
    set userProfile (value){

        this.__userProfile = value;

    }
    get userProfile (){
        return this.__userProfile;
    }

    @api
    set segmentOffer (value){

        this.__segmentOffer = value;

    }
    get segmentOffer (){
        return this.__segmentOffer;
    }

    get mdnTypeAttributeValue (){

        let attributeCategories = this.__item.attributeCategories;
        let mdnTypeValue = null;

        if (attributeCategories.records){

            attributeCategories.records.forEach ((attributeCategory, index1) => {
               // console.log("index1:" + index1 );

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                       // console.log("index2:" + index2)

                        //console.log(productAttribute.code);

                        if (productAttribute.code.includes("TYPE_NULERO")){
                            mdnTypeValue = productAttribute.userValues;
                            this.__mdnTypeAttributeCategoriesId = index1;
                            this.__mdnTypeProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_MSISDN'){
                            this.__selectedmdn = productAttribute.userValues;
                            this.__mdnAttributeCategoriesId = index1;
                            this.__mdnProductAttributesId = index2;
                            //console.log('SELECTEDMND : '+ this.__selectedmdn);
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_CHOIX_NUMERO') {
                            this.mdnChoice = productAttribute.userValues;
                            this.__mdnChoiceAttributeCategoriesId = index1;
                            this.__mdnChoiceProductAttributesId = index2;
                            //console.log('SELECTEDMND : '+ this.__selectedmdn);
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_OCSIDFINAL'){
                            this.__ocsIdAttributeCategoriesId = index1;
                            this.__ocsIdProductAttributesId = index2;
                        }

                    });
                }else {
                    return null;
                }
             });

             //console.log(this.__mdnAttributeCategoriesId + ' ' + this.__mdnProductAttributesId);

        }else{
            return null;
        }
        console.log('isRecoverMdnOption' + this.isRecoverMdnOption);
        
        if ( this.__item.action == 'Existing' || (this.isRecoverMdnOption == 'true' && isRecovered == 'false')){
         // if(this.Changed){
            this.isNumberChosen= false;
            console.log('MDN VIDE, ERRORLIST');
            console.log('item',this.item);
            let attributeError = {
                message: "le MDN doit être valide et obligatoire"
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
    
        
        if ((this.mdnAttributeValue && this.__item.action != 'Existing') || this.isNumberChosen == true){
           // if (this.mdnAttributeValue){
            console.log('MDN CHOISI, ERRORLIST A VIDER');
            let detail = {
                item: this.__item.Id.value,
                errors: []
            };
    
            const attributeErrorEvent = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });
      
            // Dispatches the event.
            this.dispatchEvent(attributeErrorEvent);
        } 

        
        return mdnTypeValue;
    }
    get mdnChoiceAttributeValue() {
        //console.log('SELECTEDMND in mdnAttributeValue : '+ this.__selectedmdn + ' __' );
        return this.mdnChoice;

    }
    set mdnChoiceAttributeValue(value) {

        this.mdnChoice = value;

        if (this.__mdnChoiceAttributeCategoriesId >= 0 && this.__mdnChoiceProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));
        }


    }

    get mdnAttributeValue () {
        //console.log('SELECTEDMND in mdnAttributeValue : '+ this.__selectedmdn + ' __' );
        return this.__selectedmdn;
        
    }

    get mdnFilterAttributeValue () {
        return this.mdnFilterAttributeValue;

    }

    get rootItemId(){
        return this.__item.vlocity_cmt__RootItemId__c.value;
    }

    set ocsIdAttributeValue (value) {

        

        if (this.__ocsIdAttributeCategoriesId >= 0 && this.__ocsIdProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__ocsIdAttributeCategoriesId].productAttributes.records[this.__ocsIdProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));
        }

    }



    set mdnTypeAttributeValue (value) {

            this.__mdnTypeValue = value;
            if ( this.__mdnTypeValue == 'NORMAL')
                this.__PriceNumber = '5 DH';
            else if ( this.__mdnTypeValue == 'BRONZE')
            {  if(this.__segmentOffer.includes('Postpaye'))
    
                this.__PriceNumber = '100DH';
                    else
                this.__PriceNumber = '100DH';
    
            }
            else if ( this.__mdnTypeValue == 'SILVER')
                this.__PriceNumber = '200 DH';
            else if ( this.__mdnTypeValue == 'GOLD')
                this.__PriceNumber = '1000 DH';


        if (this.__mdnTypeAttributeCategoriesId >= 0 && this.__mdnTypeProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnTypeAttributeCategoriesId].productAttributes.records[this.__mdnTypeProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
           /* const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent); */

        }

        

    }

    set mdnAttributeValue (value) {

        this.__selectedmdn = value;
        

        if (this.__mdnAttributeCategoriesId >= 0 && this.__mdnProductAttributesId >= 0) {

            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__mdnProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
            const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);     


        }

    }
    

    get orderId (){
        return this.__item.OrderId.value;
    }

    connectedCallback() {
        console.log("omnijson ",JSON.stringify(this.omniJsonData));
        console.log('the profile connectedCallback is : '+ this.__userProfile);
        console.log('the offer segment is : '+ this.__segmentOffer);
       
        this.__PriceNumber = '5 DH';
        console.log("orderid ", this.__item?.OrderId?.value);
        
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('consoleproduct : ' + this.item.ProductCode);
        if(this.item.ProductCode == 'INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD')
        {
            console.log("consoleproduct true ");
            this.isFTTHs=true;
            console.log("Prix changement : "+this.__PriceNumber);
            
        }  
        else{
            console.log("consoleproduct false ");
            this.isFTTHs=false;
        }

        this.getisCameleon()
        console.log('@api isCameleon;;' + this.isCameleon);

        this.getPermissionRecupMDN()
    }

    renderedCallback(){
        console.log('rendred isCameleon;' + this.isCameleon);
    }


    get itemString (){
        return JSON.stringify(this.item);
    }

    
    
    get mdntyperecords() {

        //console.log('the profile is : ', data.fields.Profile.value.fields.Name.value);
        if((this.__userProfile.includes('Inwi POS')  || this.__userProfile.includes('Comercial Agents CDC')) && this.__segmentOffer == "InwiB2C_Prepaye" ){
            this.__mdnTypeValue = 'NORMAL';
        
        return [
            { label: 'Normal', value: 'NORMAL' }
        ]; 
    }
    else{
        if (this.__mdnTypeAttributeCategoriesId >= 0 && this.__mdnTypeProductAttributesId >= 0) {
            
            let attrValueList = this.__item.attributeCategories.records[this.__mdnTypeAttributeCategoriesId].productAttributes.records[this.__mdnTypeProductAttributesId].values;
            return attrValueList.map(function(e){
                let attVal = {};
                attVal.label = e.label;
                attVal.value = e.value;
                return attVal;
            });

           

        }

    }
    }

    getMdnList(event) {

            console.log('in getMdnlist');
            let input = null;
            if (this.__segmentOffer == "InwiB2C_Postpaye"){
                input = '{"mdnType":"MO", "offerType":"Post", "category":"' + this.mdnTypeAttributeValue+ '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId+ '","nbrResult": 40 ,"rootItemId" : "'+ this.rootItemId+ '"}';
                console.log("input get mdn : "+input);
            }
            else 
            {
                input = '{"mdnType":"MO", "offerType":"Pre", "category":"' + this.mdnTypeAttributeValue+ '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId+ '","nbrResult": 40 ,"rootItemId" : "'+ this.rootItemId+ '"}';
            }
            console.log('input 1: ' + input);
    
            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'Inwi_InwiB2C_MdnSearch',
                options: '{}',
            };
    
            console.log('before call apex1' + JSON.stringify(params));
        
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log('just after response');
                    console.log(response);
                    if (response.error == false) {
                        console.log(response);
    
                        if (response.result) {
                            console.log('we are here');
                            console.log(response.result);
                            if(response.result.IPResult.success== false && response.result.IPResult.result.reason!=null && response.result.IPResult.result.reason =='NOT_FOUND'){
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Aucun numéro disponible avec les critères sélectionnés',
                                    variant: 'error'
                                    }),
                                );
                            }
                    
                            var returnOptions = [];

                                response.result.IPResult.forEach(ele =>{
                                    returnOptions.push({label:ele.mdn , value:ele.mdn});
                                }); 
                                this.records = returnOptions;
                                
                                //this.TypeDeNumero = 'NORMAL';
                                let TypeDeNumero = { SelectedTypeLabel : this.mdnTypeAttributeValue, 
                                    SelectedTypeValue : this.mdnFilterAttributeValue};
                                    console.log('LE TYPE ACTUEL EST : '+ TypeDeNumero + TypeDeNumero.SelectedTypeLabel);        
                        
                                    
                //CameleonChoixNumero
               // if(this.isCameleon==true){
                   // this.__item.action=='Change';
               // }
                    
    
                                    this.omniUpdateDataJson(TypeDeNumero.SelectedTypeLabel);
                                    this.omniSaveState(TypeDeNumero.SelectedTypeLabel,true);
                               
                             }
                        }
                    else {
                     
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Problème technique, Merci de ressayer plus tard',
                                variant: 'error'
                                }),
                            );
                        

                    }
                })
                .catch(error => {
                    console.log('error');
                    window.console.log(error);
                });
    
    
        }


    handleFocusOut(evt) {

        //Creates the event with the data.
        const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

    }

    handleTypeMdnChange(event){
        this.mdnTypeAttributeValue = event.target.value;
    }
    
    handleMdnFilterChange(event){
        this.mdnFilterAttributeValue = event.target.value;
    }
    handleMdnSelection(event) {

        this.__selectedmdnListItem = event.detail.value;
        //this.mdnAttributeValue = event.detail.value;
    }

    get displayMDNChoice (){
        console.log("this.mdnAttributeValue ", this.mdnAttributeValue, " this.__item.action ", this.__item.action, " this.isRecoverMdnOption ", this.isRecoverMdnOption)
        console.log("this.__item ", this.__item)
        if ((this.mdnAttributeValue && this.__item.action != 'Existing') ||this.isRecoverMdnOption == true )
            return false;
        else
            return true;

    }
    get displayMDNChoice1(){
        if (this.mdnAttributeValue && this.__item.action != 'Existing') return false;
        else return true;
    }
    get displayMDNChoice2() {
        if (this.isRecovered == true) return true;
        else return false;
    }


    get disableMDNType (){
        return ! this.displayMDNChoice;
    }

    get hideRecuBtnRadio(){
        console.log("hide  ",this.isCameleon)
        return (this.__item.action == 'Existing' && this.isCameleon != true && this.showRecupOption === true) ; 
    }

   /* isFTTHs(){
        console.log('consoleproduct : ' + this.item.ProductCode);
        if(this.item.ProductCode == 'INWIB2C_OFFERING_FTTH50MG_349DH')
        {
            console.log("consoleproduct true ");
            return true;
        }  
        else{
            console.log("consoleproduct false ");
            return false;
        }
    }*/

    lockMDN() {

        this.isNumberChosen = true;
        let mdn = this.__selectedmdnListItem;
        //console.log('in getMdnlist');

        let input = '{"MDN": {"mdn": "'+ mdn +'","lockToken": "'+ this.orderId+ '"}}';

        
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_LockMdn',
            options:'{}' 
        };

        console.log('before call lockMDN' + JSON.stringify(params));
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response.error == false) {
                    console.log(response);

                    if (response.result) {
                        console.log(response);

                        let ocsId = response.result.IPResult.OCSID;
                        
                        this.ocsIdAttributeValue = ocsId;
                        this.mdnAttributeValue = mdn;

                           
                        }
                    }
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });


}
    handleSelectedRecoverOption(event) {
        this.isRecoverMdnOption = true;
        this.mdnChoiceAttributeValue = event.detail.value;
    }


    getisCameleon(){
        let productId = this.__item.productHierarchyPath.substring(0, this.__item.productHierarchyPath.indexOf("<"));
        console.log('productId ', productId)
        let input = '{"Id": "' + productId + '"}';
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_getProductInfoById',
            options: '{}',
        };

        console.log(this._actionUtilClass)
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {

                console.log(response);
                if (response.error == false) {
                    console.log(response?.result?.IPResult?.offerSegement);
                    if (response?.result?.IPResult?.offerSegement == 'Cameleon') {
                           this.isCameleon = true
                        }
                    else this.isCameleon = false;
                }
                else {

                 this.isCameleon = false

                }
                console.log('get isCameleon;;' + this.isCameleon);
            })
            .catch(error => {
                this.isCameleon = false
                console.log('error');
                window.console.log(error);
            });
    }

    getPermissionRecupMDN() {
        const params = {
            input: '{}',
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_PermissionSetRecupMDN',
            options: '{}',
        };

        console.log(this._actionUtilClass)
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {

                console.log(response);
                if (response.error == false) {
                    console.log(response?.result?.IPResult?.showRecupOption);
                    if (response?.result?.IPResult?.showRecupOption === true) {
                        this.showRecupOption = true
                    }
                }

                console.log('get PermissionSetRecupMDN;;' + this.showRecupOption);
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });
    }

    RecoverMdn() {

        var MDNRecov = this.template.querySelector(".MDNRecoveredInput");
        var MDNRecovered = MDNRecov.value;
        console.log('MDNRecovered' + MDNRecovered);
        //Check MDN recovered Length/Format
        if (MDNRecovered.length != 12 || !MDNRecovered.match(/^212[0-9]+$/)) {
            MDNRecov.setCustomValidity("Le numéro de téléphone saisi est incorrect. il doit être sur 12 caractères, commencer par 212 et ne doit comporter que des chiffres!");
        } else {
            MDNRecov.setCustomValidity("");
            let input = '{"mdn": "' + MDNRecovered + '","orderId": "' + this.orderId + '"}';


            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_checkMDNRecupEligble',
                options: '{}'
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log('response checknumberrecovery ' , response)
                    console.log('typeMDN ', response.result.IPResult.typeMDN)
                    if (response.error == false) {
                        console.log(response);

                        if (response.result && response.result.IPResult) {

                            console.log('IPResult checknmberrecovery ', response.result.IPResult)

                            if (response.result.IPResult.isEligible == 'true') {
                                //Call  MDN Reservation
                                console.log('response.result.IPResult.isEligible ', response.result.IPResult.isEligible)
                                console.log('typeMDN ', response.result.IPResult.typeMDN )
                                //this.typeRecoveredMDN = response.result.IPResult.typeMDN;
                                this.typeRecoveredMDN = 'NORMAL'
                                let input = '{"mdn": "' + MDNRecovered + '","lockToken": "' + this.orderId + '","operationType": "RECOVERY"}';


                                const params = {
                                    input: input,
                                    sClassName: `${this._ns}IntegrationProcedureService`,
                                    sMethodName: 'inwib2c_InwiB2C_RECOVER_NUMBER',
                                    options: '{}'
                                };


                                this._actionUtilClass
                                    .executeAction(params, null, this, null, null)
                                    .then(response => {
                                        console.log("inwib2c_InwiB2C_RECOVER_NUMBER", response)
                                        if (response.error == false) {
                                            console.log("response", response);

                                            if (response.result && response.result.IPResult) {

                                                console.log('isReserved:' + response.result.IPResult.isReserved);
                                                if (response.result.IPResult.isReserved == true) {
                                                    this.__mdnRecoveredValue = MDNRecovered;
                                                    this.mdnTypeAttributeValue = this.typeRecoveredMDN;
                                                    this.omniUpdateDataJson(this.mdnTypeAttributeValue);
                                                    this.omniSaveState(this.mdnTypeAttributeValue, true);
                                                    this.dispatchEvent(
                                                        new ShowToastEvent({
                                                            title: 'Success',
                                                            message: 'La ligne ' + MDNRecovered + ' est réservée ',
                                                            variant: 'success'
                                                        }),
                                                    );

                                                    // in case on eligible Recovered MDN.
                                                    this.mdnAttributeValue = MDNRecovered;
                                                    this.isRecovered = true;
                                                    if (this.typeRecoveredMDN == 'NORMAL')
                                                        this.__PriceNumber = '5 DH';
                                                    else if (this.typeRecoveredMDN == 'BRONZE') {
                                                        if (this.__segmentOffer.includes('Postpaye'))

                                                            this.__PriceNumber = '100DH';
                                                        else
                                                            this.__PriceNumber = '100DH';

                                                    }
                                                    else if (this.typeRecoveredMDN == 'SILVER')
                                                        this.__PriceNumber = '200 DH';
                                                    else if (this.__mdnTypeValue == 'GOLD')
                                                        this.__PriceNumber = '1000 DH';

                                                    console.log("orderid " + this.orderId);
                                                    console.log("recoveredFlag" + this.recoveredFlag);
                                                    //Set Recovered Flag on order
                                                    let input = '{"orderId": "' + this.orderId + '","recoveredFlag":' + this.recoveredFlag + '}';
                                                    console.log("input", input)
                                                    const params = {
                                                        input: input,
                                                        sClassName: `${this._ns}IntegrationProcedureService`,
                                                        sMethodName: 'inwib2c_InwiB2C_UpdateOrderRecoveredFlag',
                                                        options: '{}'
                                                    };
                                                    this._actionUtilClass
                                                        .executeAction(params, null, this, null, null)
                                                        .then(response => {
                                                            console.log("inwib2c_InwiB2C_UpdateOrderRecoveredFlag response ", response);
                                                        })
                                                        .catch(error => {
                                                            console.log("error InwiB2C_UpdateOrderRecoveredFlag");
                                                            window.console.log(error);
                                                        });
                                                } else {
                                                    this.dispatchEvent(
                                                        new ShowToastEvent({
                                                            title: 'Erreur',
                                                            message: 'Erreur lors de la résérvation',
                                                            variant: 'error'
                                                        }),
                                                    );
                                                }

                                            } else {
                                                this.dispatchEvent(
                                                    new ShowToastEvent({
                                                        title: 'Erreur',
                                                        message: 'Erreur lors de la résérvation',
                                                        variant: 'error'
                                                    }),
                                                );

                                            }
                                        } else {
                                            this.dispatchEvent(
                                                new ShowToastEvent({
                                                    title: 'Erreur',
                                                    message: 'Erreur lors de la résérvation',
                                                    variant: 'error'
                                                }),
                                            );

                                        }
                                    })
                                    .catch(error => {
                                        console.log('errorrrrr');
                                        window.console.log(error);

                                        this.dispatchEvent(
                                            new ShowToastEvent({
                                                title: 'Erreur',
                                                message: 'Erreur lors de la résérvation',
                                                variant: 'error'
                                            }),
                                        );
                                    });
                            } else {
                                console.log('reason ', response.result.IPResult?.reason )
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Erreur',
                                        message: response?.result?.IPResult?.reason,
                                        variant: 'error'
                                    }),
                                );
                            }

                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Erreur lors de la vérification de l\'éligibilité 2',
                                    variant: 'error'
                                }),
                            );

                        }
                    } else {

                        console.log('error = true', response?.result?.error?.reason)
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: response?.result?.error?.reason,
                                variant: 'error'
                            }),
                        );

                    }
                })
                .catch(error => {
                    console.log('error checknumberrecovery ' , error);
                    window.console.log(error);

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la vérification de l\'éligibilité 0',
                            variant: 'error'
                        }),
                    );
                });
        }
        MDNRecov.reportValidity();
    }
    handleMdnRecoveredChange() {

    }
    get options() {
        return [
            { label: 'Récupérer un numéro', value: 'recuperer' },
        ];
        /*return [
             { label: 'Garder Le numéro par défaut', value: 'option1' },
             { label: 'Personaliser le numéro', value: 'option2' },
             { label: 'Porter un numéro', value: 'option3' }
         ];*/

        /*   let choice = this.mdnChoiceAttributeValue;
    
    
           //console.log("options Id: " + this.__mdnChoiceAttributeCategoriesId + ' ' + this.__mdnChoiceProductAttributesId);
    
    
           if (this.__mdnChoiceAttributeCategoriesId >= 0 && this.__mdnChoiceProductAttributesId >= 0) {
    
               //console.log(JSON.stringify(this.__item.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId]));
               console.log("************** this.__product ***************");
               console.log(this.__product);
               console.log(JSON.stringify(this.__item.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId].values));
               let list = [];
               this.__item.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId].values.map(itemoption => {
                  console.log('itemoption.value'+itemoption.value);
                   if (itemoption.value === "recuperer") {
                       list.push(itemoption);
                   }  
               })
    
               return list;
    
           } else return null;*/
    }


}