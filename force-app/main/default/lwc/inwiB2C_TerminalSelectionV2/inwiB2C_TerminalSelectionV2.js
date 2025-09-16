import { LightningElement, api } from 'lwc';

import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_TerminalSelectionV2 extends OmniscriptBaseMixin(LightningElement) {

    __item;
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

    __validationErrors = [];

    __countEvents = 0;

    __imeiValue;

    __marqueOptions = [];
    __modeleOptions = [];

    _ns = getNamespaceDotNotation();
    _actionUtilClass;



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

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        this.getmarqueOptions ();

 
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
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_SerialType"){


                            this.__serialTypeAttributeCategoriesId = index1;
                            this.__serialTypeProductAttributesId = index2;
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_StockValidated"){
                            
                            this.__stockValidatedAttributeCategoriesId = index1;
                            this.__stockValidatedProductAttributesId = index2;
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_RT_MARQUELABEL"){
                            
                            this.__marqueLabelAttributeCategoriesId = index1;
                            this.__marqueLabelProductAttributesId = index2;
                            
                        }
                        if (productAttribute.code === "INWIB2C_ATT_DC_MODELELABEL"){
                            
                            this.__modeleLabelAttributeCategoriesId = index1;
                            this.__modeleLabelProductAttributesId = index2;
                            
                        }

                        


                    });
                }else {
                    return null;
                }
             });

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

        //this.getmarqueOptions ();
    
        //this.getmodeleOptions ();
        

        return this.__item.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId];
    }

    get imeiAttributeValue(){

        if (this.__imeiAttributeCategoriesId >= 0 && this.__imeiProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId].userValues;

        }else return null; 

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
        this.getmodeleOptions();

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

    getmarqueOptions (){

        

        let input = '{}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_GetMarque',
            options: '{}',
        };

        console.log('before call getMarque' + params);
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('réponse getmarque');
                console.log((response));
                if (response.error == false) {
                    //console.log(response);

                    if (response.result && response.result.IPResult && response.result.IPResult.marques) {
                        
                        let marques = response.result.IPResult.marques;

                        console.log(marques);

                        let marqueOptions = marques.map(marque => {

                            let newOption = [];
                            newOption.label = marque.Name;
                            newOption.value = marque.Id;
                            return newOption;

                        });

                        this.__marqueOptions = marqueOptions;
                        this.getmodeleOptions ();
                   }
                }else {
                    console.log('Erreur lors de la récupération des marques');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération des informations des marques',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });


    }

    getmodeleOptions (){

        

        if (this.marqueAttributeValue){

            let input = '{"IdModel": "'+ this.marqueAttributeValue+ '"}';

            console.log('input : ' + input);

            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'Inwi_InwiB2C_GetModele',
                options: '{}',
            };

            console.log('before call inwiB2C_GetModelfromMarque' + params);
        
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log((response));
                    if (response.error == false) {
                        //console.log(response);

                        if (response.result && response.result.IPResult && response.result.IPResult.modeles) {

                            let modeles = response.result.IPResult.modeles;

                            this.__modeleOptions = modeles.map(modele => {

                                let newOption = [];
                                newOption.label = modele.Name;
                                newOption.value = modele.codeArticle;
                                return newOption;

                            });
                            
                        
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

        





    /*    let  o = [];

        console.log('modeleOptions: this.__modeleAttributeCategoriesId: '+ this.__modeleAttributeCategoriesId + ' this.__modeleProductAttributesId: ' + this.__modeleProductAttributesId);


        if (this.__modeleAttributeCategoriesId >= 0 && this.__modeleProductAttributesId >= 0) {

            let LocalAttribute = this.__item.attributeCategories.records[this.__modeleAttributeCategoriesId].productAttributes.records[this.__modeleProductAttributesId];

            if (LocalAttribute && LocalAttribute.values) {

                o = LocalAttribute.values.map(function(option){

                    let newOption = [];
                    newOption.label = option.label;
                    newOption.value = option.value;
                    return newOption;

                    });
            }
        }
        return(o);*/

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

    

    handleChangeMarque(event) {
        event.stopPropagation();

        this.marqueAttributeValue = event.detail.value;


        this.__marqueOptions.forEach(marque=>{
            if (marque.value == event.detail.value){
                this.marqueLabelAttributeValue = marque.label;

            }
        });

        

        

        //Creates the event with the data.
        /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });*/
  
        // Dispatches the event.
        //this.dispatchEvent(selectedEvent);
    }

    handleChangeModele(event) {
        event.stopPropagation();
        this.modeleAttributeValue = event.detail.value;

        this.__modeleOptions.forEach(modele=>{
            if (modele.value == event.detail.value){
                this.modeleLabelAttributeValue = modele.label;

            }
        });

        //Creates the event with the data.
        /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });*/
  
        // Dispatches the event.
        //this.dispatchEvent(selectedEvent);
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
        
        
            // Search B.E. service

            var imeiInput = this.template.querySelector(".imeiInput");
            var value = imeiInput.value;
            // is input valid text?
            if (this.serialTypeAttributeValue == 'IMEI'){
                if (value.length != 15 || ! value.match(/^[0-9]+$/)) {
                    imeiInput.setCustomValidity("L'IMEI saisi est incorrect. il doit être sur 15 caractères et ne doit comporter que des chiffre.");
                } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();
                    /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                        detail: this.__item
                    });
              
                    // Dispatches the event.
                    this.dispatchEvent(selectedEvent);*/
                }

            }else if (this.serialTypeAttributeValue == 'ESN'){
                if (value.length != 15 || ! value.match(/^[0-9A-Za-z]+$/)) {
                    imeiInput.setCustomValidity("L'ESN saisi est incorrect. il doit être sur 15 caractères.");
                } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();
                }

            }
            imeiInput.reportValidity(); // Tells lightning-input to show the error right away without needing interaction
      

        
    }

    get imeiLabel(){
        return this.serialTypeAttributeValue 
    }

    get imeiDisabled(){

        return (this.stockValidatedAttributeValue != null && this.stockValidatedAttributeValue == 'VALID') ;

    }



    searchIMEI() {
        

        let input = '{"orderId": "'+ this.__item.OrderId.value+ '","handset": [{"code":"' + this.modeleAttributeValue + '","serialNumber": "'+ this.__imeiValue + '","type": "'+ this.serialTypeAttributeValue + '","technology": "GSM","offerType": "FM","orderType": "MOBILE",';
        input += '"vendor": "CPD01","distributorCode": "CPD01","region": "PGSM","quantity": "1"}],"operation": "RS", "username": "Djamel"}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_LockArticle',
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

                            
                        }else{

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


}