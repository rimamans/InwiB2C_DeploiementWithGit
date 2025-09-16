import { LightningElement, api,  } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/*import template from './inwiB2C_simEntry.html';*/

export default class InwiB2C_simEntry extends OmniscriptBaseMixin(LightningElement) {

    __item;
    __iccAttributeCategoriesId;
    __iccProductAttributesId;

    __icc
    __modeleCarteAttributeCategoriesId;
    __modeleCarteProductAttributesId;

    __pukAttributeCategoriesId;
    __pukProductAttributesId;

    __imsiAttributeCategoriesId;
    __imsiProductAttributesId;

    __kiAttributeCategoriesId;
    __kiProductAttributesId;

    __mdnAttributeCategoriesId;
    __mdnProductAttributesId;

    __profileAttributeCategoriesId;
    __profileProductAttributesId;

    __ocsIdAttributeCategoriesId;
    __ocsIdProductAttributesId;
    
    __typeSimIdAttributeCategoriesId;
    __typpeSimIdProductAttributesId;

    __iccValue;

    __validationErrors = [];

    __countEvents = 0;

    __type;
    
    disableValiderIcc = false ; 
    

    _ns = getNamespaceDotNotation();
    _actionUtilClass;



    @api 
    set item(value) {
        this.__item = {...value};
    }
    get item() {
        return this.__item;

    }




    @api
    set type(value) {
      this.__type = value;
    }
    get type() {
      return this.__type;
  
    }
    get showbutton() {
      return (this.__type != "migration" && this.__type != "migrationPostpaye")
    }

    get itemString() {
        return JSON.stringify(this.item);
    }

    get rootItemId(){
        return this.__item.vlocity_cmt__RootItemId__c.value;
    }
    __typeparcour="";

    @api
   get typeparcour() {
     return this.__typeparcour;
   }
   set typeparcour(value) {
     this.__typeparcour = value;
   }



//CH-Y MigrationPrePostBackOfficeWakil Begin
//    @api
//    set icc(value) {
//      this.__icc = value;
//      console.log("icc aprés le setter", this.__icc)
//    }
//    get icc() {
//        return this.__icc;
 
//    }
 //CH-Y MigrationPrePostBackOfficeWakil End

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        /*let attributeError = {
            attributeId: this.__item.attributeCategories.records[this.__iccAttributeCategoriesId].productAttributes.records[this.__iccProductAttributesId].attributeId,
            message: "ICC doit être valide et oblogatoire"
        }*/

        console.log('In Connected Call back : ' + this.pukAttributeValue)

        /*if (this.pukAttributeValue == null){
            let attributeError = {
                message: "ICC doit être valide et oblogatoire"
            }
    
            this.__validationErrors = [];
            this.__validationErrors.push(attributeError);
            let detail = {
                item: this.__item.Id.value,
                errors: this.__validationErrors
            };
    
            const selectedEvent = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });
      
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);

        }*/

        /**/
    }


    // parse JSON item to get the ICC attribute value

    get iccAttributeValue (){

        let vlcCart = JSON.parse(JSON.stringify(this.__item));
        let attributeCategoriesWakil = JSON.parse(JSON.stringify(this.__item.attributeCategories));

        console.log("itemCart",vlcCart );
        console.log("attributeCategoriesWakil",attributeCategoriesWakil );

        let attributeCategories = this.__item.attributeCategories;
        let iccValue = null;

        if (attributeCategories.records) {

            attributeCategories.records.forEach((attributeCategory, index1) => {
                //console.log("index1:" + index1)


                let productAttributes = attributeCategory.productAttributes.records;
                let productAttributesWakil = JSON.parse(JSON.stringify(productAttributes));
                console.log("productAttributesWakil",productAttributesWakil );
                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        console.log("ProductAttributeCode", productAttribute.code);
                        console.log("uservalues", productAttribute.userValues);
                        //console.log("index2:" + index2)
                        if (productAttribute.code.includes("ICC")) {
                            //CH-Y MigrationPrePostBackOfficeWakil Begin

                            iccValue = productAttribute.userValues;
                            console.log("iccValue1", iccValue);
                            // iccValue = this.icc;
                             //CH-Y MigrationPrePostBackOfficeWakil End
                            this.__iccAttributeCategoriesId = index1;
                            this.__iccProductAttributesId = index2;
                            
                        }

                        if (productAttribute.code.includes("MODELE_CARTE")){
                            this.__modeleCarteAttributeCategoriesId = index1;
                            this.__modeleCarteProductAttributesId = index2;
                        }
                        if (productAttribute.code.includes("PUK")){
                            this.__pukAttributeCategoriesId = index1;
                            this.__pukProductAttributesId = index2;
                            /*if ((productAttribute.userValues == null || productAttribute.userValues.length == 0)){
                                let attributeError = {
                                    message: "ICC doit être valide et oblogatoire"
                                }
                        
                                this.__validationErrors = [];
                                this.__validationErrors.push(attributeError);
                                let detail = {
                                    item: this.__item.Id.value,
                                    errors: this.__validationErrors
                                };
                        
                                const selectedEvent = new CustomEvent("customitemvalidationerror", {
                                    detail: detail
                                });
                          
                                // Dispatches the event.
                                this.dispatchEvent(selectedEvent);
                            }*/
                        }
                        if (productAttribute.code.includes("IMSI")){
                            this.__imsiAttributeCategoriesId = index1;
                            this.__imsiProductAttributesId = index2;
                        }
                        if (productAttribute.code.includes("KI")){
                            this.__kiAttributeCategoriesId = index1;
                            this.__kiProductAttributesId = index2;
                        }
                        if (productAttribute.code.includes("MSISDN")){
                            this.__mdnAttributeCategoriesId = index1;
                            this.__mdnProductAttributesId = index2;
                        }
                        if (productAttribute.code.includes("PROFILE_IN")){
                            this.__profileAttributeCategoriesId = index1;
                            this.__profileProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_OCSID'){
                            this.__ocsIdAttributeCategoriesId = index1;
                            this.__ocsIdProductAttributesId = index2;
                        }
                           //Amine brm TTM ESIM
                        if(productAttribute.code == 'INWIB2C_ATT_RT_TYPESIM'){
                           this.__typeSimIdAttributeCategoriesId = index1;
                           this.__typpeSimIdProductAttributesId = index2;
                        }


                    });
                }else {
                    return null;
                }
             });

        }else{
            return null;
        }
    console.log("ICC value: " + iccValue);

    if (this.pukAttributeValue == null){
        let attributeError = {
            message: "ICC doit être valide et oblogatoire"
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
    return iccValue;
    }
    //set the value of the ICC attribute
    set iccAttributeValue (value) {

        this.__iccValue = value;


        if (this.__iccAttributeCategoriesId >= 0 && this.__iccProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__iccAttributeCategoriesId].productAttributes.records[this.__iccProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

        }

    }

    get modeleCarteAttributeValue () {

        if (this.__modeleCarteAttributeCategoriesId >= 0 && this.__modeleCarteProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__modeleCarteAttributeCategoriesId].productAttributes.records[this.__modeleCarteProductAttributesId].userValues;

        }else return null;

    }

    get pukAttributeValue () {

        if (this.__pukAttributeCategoriesId >= 0 && this.__pukProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__pukAttributeCategoriesId].productAttributes.records[this.__pukProductAttributesId].userValues;

        }else return null;

    }

    get imsiAttributeValue () {

        if (this.__imsiAttributeCategoriesId >= 0 && this.__imsiProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__imsiAttributeCategoriesId].productAttributes.records[this.__imsiProductAttributesId].userValues;

        }else return null;

    }
    get kiAttributeValue () {

        if (this.__kiAttributeCategoriesId >= 0 && this.__kiProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__kiAttributeCategoriesId].productAttributes.records[this.__kiProductAttributesId].userValues;

        }else return null;

    }

    get mdnAttributeValue () {

        if (this.__mdnAttributeCategoriesId >= 0 && this.__mdnProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__mdnProductAttributesId].userValues;

        }else return null;

    }

    get profileAttributeValue () {

        if (this.__profileAttributeCategoriesId >= 0 && this.__profileProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__profileAttributeCategoriesId].productAttributes.records[this.__profileProductAttributesId].userValues;

        }else return null;

    }

    get modeleSimLOV(){

        
        if (this.__modeleCarteAttributeCategoriesId >= 0 && this.__modeleCarteProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__modeleCarteAttributeCategoriesId].productAttributes.records[this.__modeleCarteProductAttributesId].values;

        }else return null;

    }
     
     //Amine Brm debut Evolution ESIM
    get typeSimAttributeValue () {

        if (this.__typeSimIdAttributeCategoriesId >= 0 && this.__typpeSimIdProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__typeSimIdAttributeCategoriesId].productAttributes.records[this.__typpeSimIdProductAttributesId].userValues;
            

        }else return null;

    }
    
     //Fin Evolution Esim

   setReturnedAttributeValue (puk, imsi, ki, mdn, profile, ocsId, codeArticle, typeSim) {
       
        let localItem = JSON.parse(JSON.stringify(this.__item));

        

        if (this.__pukAttributeCategoriesId >= 0 && this.__pukProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__pukAttributeCategoriesId].productAttributes.records[this.__pukProductAttributesId].userValues = puk;
        }
        if (this.__imsiAttributeCategoriesId >= 0 && this.__imsiProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__imsiAttributeCategoriesId].productAttributes.records[this.__imsiProductAttributesId].userValues = imsi;
        }
        if (this.__kiAttributeCategoriesId >= 0 && this.__kiProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__kiAttributeCategoriesId].productAttributes.records[this.__kiProductAttributesId].userValues = ki;
        }
        if (this.__mdnAttributeCategoriesId >= 0 && this.__mdnProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__mdnProductAttributesId].userValues = mdn;
        }
        if (this.__profileAttributeCategoriesId >= 0 && this.__profileProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__profileAttributeCategoriesId].productAttributes.records[this.__profileProductAttributesId].userValues = profile;
        }
        if (this.__ocsIdAttributeCategoriesId >= 0 && this.__ocsIdProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__ocsIdAttributeCategoriesId].productAttributes.records[this.__ocsIdProductAttributesId].userValues = ocsId;
        }
        if (this.__modeleCarteAttributeCategoriesId >= 0 && this.__modeleCarteProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__modeleCarteAttributeCategoriesId].productAttributes.records[this.__modeleCarteProductAttributesId].userValues = codeArticle;
        }
        //Amine brm TTM ESIM
        if (this.__typeSimIdAttributeCategoriesId >= 0 && this.__typpeSimIdProductAttributesId >= 0) {
            localItem.attributeCategories.records[this.__typeSimIdAttributeCategoriesId].productAttributes.records[this.__typpeSimIdProductAttributesId].userValues = typeSim;
        }

        this.__item = JSON.parse(JSON.stringify(localItem));

        //Creates the event with the data.
        const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

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

    hanldleIccEntry(event) {

        let icc = event.detail.value;

        //console.log(icc + '  ' +  event.keyCode);

        this.iccAttributeValue = icc;

        //console.log("In manage end : " + JSON.stringify(this.__item));
    }


    handleClick(event) {
        //console.log("In manage end : " + JSON.stringify(this.__item));

        //console.log('in handleClick');

        this.searchICC();

    }

    handleKeyUp(evt) {
        
        console.log(evt.keyCode);

        
        
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            // Search B.E. service

            var iccInput = this.template.querySelector(".iccInput");
            var value = iccInput.value;
            // is input valid text?
            if (value.length != 18 || ! value.match(/^[0-9]+$/)) {
                iccInput.setCustomValidity("L'ICCID saisi est incorrect. il doit être sur 18 caractères et ne doit comporter que des chiffres.");
            } else {
                iccInput.setCustomValidity(""); // if there was a custom error before, reset it
                this.searchICC();
            }
            iccInput.reportValidity(); // Tells lightning-input to show the error right away without needing interaction
        }
    }

    handleSearchICCbtn() {
        

            // Search B.E. service

            var iccInput = this.template.querySelector(".iccInput");
            var value = iccInput.value;
            // is input valid text?
            if (value.length != 18 || ! value.match(/^[0-9]+$/)) {
                iccInput.setCustomValidity("L'ICCID saisi est incorrect. il doit être sur 18 caractères et ne doit comporter que des chiffres.");
            } else {
                iccInput.setCustomValidity(""); // if there was a custom error before, reset it
                this.searchICC();
            }
            iccInput.reportValidity(); // Tells lightning-input to show the error right away without needing interaction
        
    }



    searchICC() {
        console.log("In manage end : " + JSON.stringify(this.__item));
        console.log("modeleSimLOV:", this.modeleSimLOV);

        if (this.modeleSimLOV) {
            this.modeleSimLOV.forEach(modelI =>{
                console.log('modelI.value ' + modelI.value + ' codeArticle ' + codeArticle);
            
            });
        }
        console.log('in handleClick');
        let input;
         if(this.typeparcour ==="eshop"){
            console.log('Amine Brm eshop EsimTest');
        input = '{"orderId": "' + this.__item.OrderId.value + '","handset": [{"code":"' + this.modeleCarteAttributeValue + '","serialNumber": "' + this.__iccValue + '","typeSim":"' + this.typeSimAttributeValue + '","type": "ICCID","technology": "GSM","offerType": "FM","orderType": "MOBILE",';
        input += '"vendor": "CPD01","distributorCode": "CPD01","region": "PGSM","quantity": "1"}],"operation": "RS", "username": "Djamel", "rootItemId" : "'+ this.rootItemId+ '"}';
          }else{
            console.log(' Amine Brm boutique EsimTest');
            input = '{"orderId": "' + this.__item.OrderId.value + '","handset": [{"code":"' + this.modeleCarteAttributeValue + '","serialNumber": "' + this.__iccValue + '","typeSim":"","type": "ICCID","technology": "GSM","offerType": "FM","orderType": "MOBILE",';
            input += '"vendor": "CPD01","distributorCode": "CPD01","region": "PGSM","quantity": "1"}],"operation": "RS", "username": "Amine BRM", "rootItemId" : "'+ this.rootItemId+ '"}';
          }
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
                        if (response.result.IPResult.CSOperationResultInfo.isOK &&  response.result.IPResult.CSOperationResultInfo.isOK == "1") {
                            let imsi = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSSubscriberIdentityModule[0].imsi;
                            let puk = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSSubscriberIdentityModule[0].puk;
                            let ki = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSSubscriberIdentityModule[0].ki;
                            let profile = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSMobileDirectoryNumber[0].mainNetworkOffer;
                            let mdn = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSMobileDirectoryNumber[0].mdn;
                            let ocsId = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].CSMobileDirectoryNumber[0].ocsId;
                            let codeArticle = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].code;
                            let typeSim = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].articleType;

                            let foundCodeArticle = false;

                            if (this.modeleSimLOV) {

                                this.modeleSimLOV.forEach(modelI =>{

                                    console.log('modelI.value ' + modelI.value + ' codeArticle ' + codeArticle);
                                    if (modelI.value == codeArticle) {
                                        foundCodeArticle = true;

                                        const customDeviceAccessValidated = new CustomEvent('customdeviceaccessvalidated', {
                                            detail: {
                                                isValid: true
                                            }
                                        });
                                        this.dispatchEvent(customDeviceAccessValidated);
                                    
                                        

                                    }
                                });

                                if (foundCodeArticle) {

                                    this.setReturnedAttributeValue(puk, imsi, ki, mdn, profile, ocsId, codeArticle, typeSim);

                                } else {

                                    //B-2435
                                    let vendor =  response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].vendor;
                                    this.unlockICC(codeArticle, this.__iccValue, vendor);
                                    this.disableValiderIcc = false ; //Y_MH B-21731

                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                        title: 'Erreur',
                                        message: 'Le modèle de la carte SIM n\'est pas autorisé !',
                                        variant: 'error'
                                        }),
                                    );

                                }
            
                            }else{
                                this.disableValiderIcc = false ; //Y_MH B-21731
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Aucun modèle de carte SIM n\'est configuré',
                                    variant: 'error'
                                    }),
                                );
                                console.log('Aucun modèle de carte SIM n\'est configuré');
                                
                            }


                            
                        }
                   
                        else{
                            this.disableValiderIcc = false ; //Y_MH B-21731
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur: ' + response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorCode,
                                message: response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorMessage,
                                variant: 'error'
                                }),
                            );

                        }
                    
                    }
                    else if (response.result.IPResult.MDNControl && response.result.IPResult.MDNControl== "NotEligible") {
                        this.disableValiderIcc = false ; //Y_MH B-21731
                        console.log('Erreur Le MDN de la carte SIM existe déja dans SF');
    
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Le MDN de la carte SIM existe déja dans SF',
                            variant: 'error'
                            }),
                        ); 
    
                    }
                }
              
                
                else {
                    console.log('Erreur lors de la récupération de la SIM');
                    this.disableValiderIcc = false ; //Y_MH B-21731
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération des informations de la SIM',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });


    }

    //B-2435
    unlockICC(codeArticle, iccValue, vendor) {
        

        let input = '{    "handset": [{"code": "' +codeArticle + '","serialNumber": "'+ iccValue + '","orderType": "MOBILE","vendor": "'+vendor+'","quantity": "1"}],"action": "OS","mode": "SALE","channel": "SF","orgID": "INWI","marketSegment": "B2C","offerType": "MOBILE"}';
        
        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_UnLockArticle',
            options: '{}',
        };

        console.log('before call InwiB2C_UnLockArticlev' + params);
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    //console.log(response);

                }else {
                    console.log('Erreur lors de l\'annulation de la réservation de la SIM');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de l\'annulation de la réservation de la SIM',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });


    }

    get iccDisabled() {

        return (this.pukAttributeValue != null && this.pukAttributeValue.length > 0) 

    }

        


}