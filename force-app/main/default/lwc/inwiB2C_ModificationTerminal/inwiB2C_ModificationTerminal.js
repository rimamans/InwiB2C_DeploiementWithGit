import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class InwiB2C_ModificationTerminal extends OmniscriptBaseMixin(LightningElement) {
    records;
    __firstGet = true;
    __item;
    __selectedterminal = '';
    terminalChoice;

    __actionType;
    _actionUtilClass;
    _ns = getNamespaceDotNotation();

    isidarvacay= false;
    restitue= true;
    retourne = 'inwib2c_Retourne';
    disableSearchButtom = true;
    terminalOldIMEIValue;
    modellist = [];
    selectedModel;
    errorImei=false;
    isloading=true;
    disableBtnSearch;
    disableRadio= false;
    valideIMEI=false;
    selectedModelPrice=0;
    isSwapONTFTTH = false
    isFTTHVulaOrangeIam =  false;


    //Eclipse_Offre 5G Home B2C_LotA
    isIdarOffer
    //Eclipse_Offre 5G Home B2C_LotA

   
    terminalFilterAttributeValue = '';
    __validationErrors = [];


    @track __oldIMEI;


    // update Islam
    __modelAttributeCategoriesId;
    __modelProductAttributesId;

    __imeiAttributeCategoriesId;
    __imeiProductAttributesId;

    __modelLabelAttributeCategoriesId;
    __modelLabelProductAttributesId;

    __serialTypeAttributeCategoriesId;
    __serialTypeProductAttributesId;


    __cpeMACProductAttributesId
    __cpeMACAttributeCategoriesId



    //end UPDATE
    __terminalModeleValue;
    __terminalMarqueAttributeValue;
    __terminalIMEIValue;
    __terminalNewIMEIValue;

    @api
    set item(value) {
        this.__item = { ...value };
    }
    get item() {
        return this.__item;
    }
    @api
    set actionType(value) {

        this.__actionType = value;

    }
    get actionType() {
        return this.__actionType
    }
    @api
    typeTerminal;
    get isModem() {
        console.log('action:'+this.__actionType);
        return (this.typeTerminal.includes("Home"));
    }
    ismodem=false;
    
    handleSave(event) {
        this.__isNext = true;
        this.goToNext();
    }
    goToNext() {

        //Creates the event with the data.
        const detailParam = {
            item: this.__item,
            nextStep: this.__isNext
        };


        const selectedEvent = new CustomEvent("customitemattribvaluechangewithnext", {
            detail: detailParam
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

    }
    get terminalModeleValue() {

        let attributeCategories = this.__item.attributeCategories;
        let terminalModeleValue = null;

        if (attributeCategories.records) {

            attributeCategories.records.forEach((attributeCategory, index1) => {

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {

                        if (productAttribute.code.includes("INWIB2C_ATT_RT_MODELE")) {
                            terminalModeleValue = productAttribute.userValues;
                            this.__modelAttributeCategoriesId = index1;
                            this.__modelProductAttributesId = index2;
                        }

                        if (productAttribute.code.includes("INWIB2C_ATT_RT_IMEI")) {
                            this.__selectedterminal = productAttribute.userValues;
                            this.__imeiAttributeCategoriesId = index1;
                            this.__imeiProductAttributesId = index2;

                        }
                        if (productAttribute.code.includes("INWIB2C_ATT_DC_MODELELABEL")) {
                            this.__modelLabelAttributeCategoriesId = index1;
                            this.__modelLabelProductAttributesId = index2;

                        }
                        if (productAttribute.code.includes("INWIB2C_ATT_RT_SerialType")) {
                            this.__serialTypeAttributeCategoriesId = index1;
                            this.__serialTypeProductAttributesId = index2;

                        }
                         if (productAttribute.code.includes("INWIB2C_ATT_RT_CPEMAC")) {
                            this.__cpeMACAttributeCategoriesId = index1;
                            this.__cpeMACProductAttributesId = index2;

                        }

                    });
                } else {
                    return null;
                }
            });


        } else {
            return null;
        }

        return terminalModeleValue;
    }

    

    set terminalModeleValue(value) {

        this.__terminalModeleValue = value;

        if (this.__modelAttributeCategoriesId >= 0 && this.__modelProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__modelAttributeCategoriesId].productAttributes.records[this.__modelProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

        }
    }

    get terminalModelLabelValue() {

  

        if (this.__modelLabelAttributeCategoriesId >= 0 && this.__modelLabelProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__modelLabelAttributeCategoriesId].productAttributes.records[this.__modelLabelProductAttributesId].userValues;
        }else return null;
    }

    set terminalModelLabelValue(value) {


        if (this.__modelLabelAttributeCategoriesId >= 0 && this.__modelLabelProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__modelLabelAttributeCategoriesId].productAttributes.records[this.__modelLabelProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

        }
    }

    get iemiValue() {


        if (this.__imeiAttributeCategoriesId >= 0 && this.__imeiProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId].userValues;
        }else return null;
    }

    set iemiValue(value) {


        if (this.__imeiAttributeCategoriesId >= 0 && this.__imeiProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__imeiAttributeCategoriesId].productAttributes.records[this.__imeiProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

        }
    }

    get serialTypeValue() {

        if (this.__serialTypeAttributeCategoriesId >= 0 && this.__serialTypeProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__serialTypeAttributeCategoriesId].productAttributes.records[this.__serialTypeProductAttributesId].userValues;
        }else return null;
    }

    set serialTypeValue(value) {


        if (this.__serialTypeAttributeCategoriesId >= 0 && this.__serialTypeProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__serialTypeAttributeCategoriesId].productAttributes.records[this.__serialTypeProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

        }
    }


    get cpeMACValue() {

        if (this.__cpeMACAttributeCategoriesId >= 0 && this.__cpeMACProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__cpeMACAttributeCategoriesId].productAttributes.records[this.__cpeMACProductAttributesId].userValues;
        }else return null;
    }

    set cpeMACValue(value) {


        if (this.__cpeMACAttributeCategoriesId >= 0 && this.__cpeMACProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__cpeMACAttributeCategoriesId].productAttributes.records[this.__cpeMACProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

        }
    }


    get changeType(){
        console.log('this.__actionType'+this.__actionType);
        if(this.__actionType =='CHMODEM'){
            
            this.ismodem=true;
            console.log('this.__actionType'+this.ismodem);
            return 'Choix Modem';
        }else{
            return 'Choix Terminal';
        }   
    }
    get labelOldIMEI(){

        return 'Ancien ' + this.serialTypeValue;

    }
    get labelNewIMEI(){

        return 'Nouvel ' + this.serialTypeValue;

    }

    get orderId() {
        return this.__item.OrderId.value;
    }

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.getModelPriceIdarVacay();
        if (this.__actionType == 'CHMODEM') {
            let parametreSwapONT = {  "OrderId": this.__item.OrderId.value };
            const paramsSwapONT = {
                input: JSON.stringify(parametreSwapONT),
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_CheckSwapONTEquipmentRule',
                options: '{}',
            };

            this._actionUtilClass
                .executeAction(paramsSwapONT, null, this, null, null)
                .then(response => {
                    console.log('response swap ont:');
                    console.log(response);
                    if (response.error == false) {
                        if (response.result && response.result.IPResult) {

                            console.log(response.result);
                            console.log(response.result.IPResult)

                          this.isSwapONTFTTH =  response?.result?.IPResult?.isSwapONTFTTH;
                          this.isFTTHVulaOrangeIam = response?.result?.IPResult?.isFTTHVulaOrangeIam;
                          this.offreFTTH = response?.result?.IPResult?.offreFTTH
                        }
                    }
                })
            }
    //Eclipse_Offre 5G Home B2C_LotA
            let inputVerify5G = {
              OrderId: this.__item.OrderId.value,
              Action: "getOfferType",
            };
            const paramsVerify5G = {
              input: JSON.stringify(inputVerify5G),
              sClassName: `${this._ns}IntegrationProcedureService`,
              sMethodName: "inwib2c_verifyIdar5GTerminal",
              options: "{}",
            };

            this._actionUtilClass
              .executeAction(paramsVerify5G, null, this, null, null)
              .then((response) => {
                console.log("response Offer type:");
                console.log(response);
                if (response.error == false) {
                  if (response.result && response.result.IPResult) {
                    console.log(response.result);
                    console.log(response.result.IPResult);

                    this.isIdarOffer = response?.result?.IPResult?.OfferType == 'idar duo';
                  }
                }
              });
    //Eclipse_Offre 5G Home B2C_LotA

        
    }
    get disableSave() {

        return !this.item.action.includes("Change")

    }

    get Changed() {

        return this.item.action.includes("Change")

    }


    get itemString() {
        return JSON.stringify(this.item);
    }

    hanldleImeiEntry(event) {

        
        this.terminalNewIMEIValue = event.detail.value;

    }

    searchIMEIButton() {

        var imeiInput = this.template.querySelector(".imeiInput");
            var value = imeiInput.value;
            console.log("Value IMEI" + value.length);

            if (this.serialTypeValue == 'IMEI'){
                if (value.length < 13 || value.length > 15 || !value.match(/^[0-9]+$/)) {
                    imeiInput.setCustomValidity("L'IMEI saisi est incorrect. il doit être sur 15 caractères maximum et ne doit comporter que des chiffre.");
                } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();
                }

            }else if(this.serialTypeValue=='MAC'){
                this.searchIMEI();
            }
            else {
                if (value.length != 8 || !value.match(/^[a-zA-Z0-9]+$/)) {
                    imeiInput.setCustomValidity("Le code ESN saisi est incorrect. il doit être sur 8 caractères (comportant des chiffres et des lettres).");
                } else {
                    imeiInput.setCustomValidity(""); // if there was a custom error before, reset it
                    this.searchIMEI();
                }

            }
            
            imeiInput.reportValidity(); // Tells lightning-input to show the error right away without needing interaction

    }

    searchIMEI() {

        console.log('in searchIMEI');
        console.log('mac:'+this.serialTypeValue);
        let input;

        if (this.serialTypeValue == 'MAC' && this.isSwapONTFTTH == false){
            input = '{"handset": [{"serialNumber": "' + this.terminalNewIMEIValue + '","type": "MAC","technology": "MAC","offerType": "FM","orderType": "SMO",';
      
        } else if (this.serialTypeValue == 'MAC' && this.offreFTTH == true){
            input = '{"handset": [{"serialNumber": "' + this.terminalNewIMEIValue + '","type": "MAC","technology": "FO","offerType": "FM","orderType": "SMO",';
        }
        else{
            input = '{"handset": [{"serialNumber": "' + this.terminalNewIMEIValue + '","type": "' + this.serialTypeValue+ '","technology": "GSM","offerType": "FM","orderType": "SMO",';
       }
       input += '"vendor": "CPD01","distributorCode": "CPD01","region": "PGSM","quantity": "1"}],"operation": "RS", "username": "Djamel"}';
        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_LockArticle',
            options: '{}',
        };

        console.log('before call Inwi_InwiB2C_LockArticle' + params);

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    //console.log(response);

                    if (response.result && response.result.IPResult && response.result.IPResult.CSOperationResultInfo) {
                        if (response.result.IPResult.CSOperationResultInfo.isOK && response.result.IPResult.CSOperationResultInfo.isOK == "1") {
                            let codearticle = response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].CSProduct[0].code;
                            
                            //Réccupérer le libelé du Modèle réservé.
                            let parametre = { "CodeArticle": codearticle };
                            console.log('parametre:');
                            console.log(parametre);

                            this.isidarvacay && this.updateOrder();
                            //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Vula Orange/IAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                            if (this.__actionType == 'CHMODEM' && this.isFTTHVulaOrangeIam == true) {
                                let parametreSwapONT = { "Action":"VerifyOIVula" ,"newCodeArticle": codearticle, "OrderId": this.__item.OrderId.value, "oldCodeArticle": this.terminalModeleValue };
                                //let parametreSwapONT = { "newCodeArticle": "100002569", "OrderId": this.__item.OrderId.value, "oldCodeArticle": this.terminalModeleValue };
                                console.log('parametreVula:');
                                console.log(parametreSwapONT);
                                const paramsSwapONT = {
                                    input: JSON.stringify(parametreSwapONT),
                                    sClassName: `${this._ns}IntegrationProcedureService`,
                                    sMethodName: 'inwib2c_CheckSwapONTEquipmentRule',
                                    options: '{}',
                                };

                                this._actionUtilClass
                                    .executeAction(paramsSwapONT, null, this, null, null)
                                    .then(response => {
                                        console.log('response swap ont:');
                                        console.log(response);
                                        if (response.error == false) {
                                            if (response.result && response.result.IPResult) {

                                                console.log(response.result);
                                                console.log(response.result.IPResult)
                                                const ipResult = response.result.IPResult;
                                                const values = Object.values(ipResult);
         
                                                if (response?.result?.IPResult?.isSameOperateur) {
                                                    const params3 = {
                                                        input: JSON.stringify(parametre),
                                                        sClassName: `${this._ns}IntegrationProcedureService`,
                                                        sMethodName: 'inwib2c_GetModelNameByCodeArticle',
                                                        options: '{}',
                                                    };

                                                    this._actionUtilClass
                                                        .executeAction(params3, null, this, null, null)
                                                        .then(response => {
                                                            console.log('voiçi le libelé article:');
                                                            console.log(response);
                                                            console.log(response.result.IPResult.Name);

                                                            const modelLabel = response.result.IPResult.Name;
                                                            this.setReturnedAttributeValue(codearticle, modelLabel)
                                                        })
                                                        .catch(error => {
                                                            window.console.log(error);
                                                        });
                                                }
                                                else if (!response?.result?.IPResult?.isSameOperateur) {

                                                    let input = '{    "handset": [{"code": "' + codearticle + '","serialNumber": "' + this.terminalNewIMEIValue + '","orderType": "SMO", "vendor": "CPD01","quantity": "1"}],"action": "OS","mode": "SALE","channel": "SF","orgID": "INWI","marketSegment": "B2C","offerType": "MOBILE"}';

                                                    const params = {
                                                        input: input,
                                                        sClassName: `${this._ns}IntegrationProcedureService`,
                                                        sMethodName: 'Inwi_InwiB2C_UnLockArticle',
                                                        options: '{}',
                                                    };

                                                    console.log('before call InwiB2C_UnLockArticlev');

                                                    this._actionUtilClass
                                                        .executeAction(params, null, this, null, null)
                                                        .then(response => {
                                                            console.log((response));
                                                        })
                                                        .catch(error => {
                                                            console.log(error);
                                                        });
                                                    for (let value of Object.values(ipResult)) {
                                                        console.log(values[value])
                                                        value !== null && this.dispatchEvent(
                                                            new ShowToastEvent({
                                                                title: 'Erreur',
                                                                message: value,
                                                                variant: 'error'
                                                            }),
                                                        );

                                                    }
                                                }
                                            }
                                            else {
                                                this.dispatchEvent(
                                                    new ShowToastEvent({
                                                        title: 'Erreur',
                                                        message: 'Erreur lors de la récupération des informations du terminal',
                                                        variant: 'error'
                                                    }),
                                                );

                                            }
                                        }
                                    })
                                    .catch(error => {
                                        window.console.log(error);
                                    });
                            }

                            //!!!!!!!!!!!!!!!!!!!!!!!!!!! TTM: Swap ONT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                            if (this.__actionType == 'CHMODEM' && this.isSwapONTFTTH == true) {
                                let parametreSwapONT = { "Action":"VerifySwapONT" ,"newCodeArticle": codearticle, "OrderId": this.__item.OrderId.value, "oldCodeArticle": this.terminalModeleValue };
                                //let parametreSwapONT = { "newCodeArticle": "100002569", "OrderId": this.__item.OrderId.value, "oldCodeArticle": this.terminalModeleValue };
                                console.log('parametreSwapONT:');
                                console.log(parametreSwapONT);
                                const paramsSwapONT = {
                                    input: JSON.stringify(parametreSwapONT),
                                    sClassName: `${this._ns}IntegrationProcedureService`,
                                    sMethodName: 'inwib2c_CheckSwapONTEquipmentRule',
                                    options: '{}',
                                };

                                this._actionUtilClass
                                    .executeAction(paramsSwapONT, null, this, null, null)
                                    .then(response => {
                                        console.log('response swap ont:');
                                        console.log(response);
                                        if (response.error == false) {
                                            if (response.result && response.result.IPResult) {

                                                console.log(response.result);
                                                console.log(response.result.IPResult)
                                                const ipResult = response.result.IPResult;
                                                const values = Object.values(ipResult);
         
                                                if ((response?.result?.IPResult?.error == true && response?.result?.IPResult?.offreFTTH == false) || values.every(value => value === null)) {
                                                    const params3 = {
                                                        input: JSON.stringify(parametre),
                                                        sClassName: `${this._ns}IntegrationProcedureService`,
                                                        sMethodName: 'inwib2c_GetModelNameByCodeArticle',
                                                        options: '{}',
                                                    };

                                                    this._actionUtilClass
                                                        .executeAction(params3, null, this, null, null)
                                                        .then(response => {
                                                            console.log('voiçi le libelé article:');
                                                            console.log(response);
                                                            console.log(response.result.IPResult.Name);

                                                            const modelLabel = response.result.IPResult.Name;
                                                            this.setReturnedAttributeValue(codearticle, modelLabel)
                                                        })
                                                        .catch(error => {
                                                            window.console.log(error);
                                                        });
                                                }
                                                else if (values.some(value => value !== null)) {

                                                    let input = '{    "handset": [{"code": "' + codearticle + '","serialNumber": "' + this.terminalNewIMEIValue + '","orderType": "SMO", "vendor": "CPD01","quantity": "1"}],"action": "OS","mode": "SALE","channel": "SF","orgID": "INWI","marketSegment": "B2C","offerType": "MOBILE"}';

                                                    const params = {
                                                        input: input,
                                                        sClassName: `${this._ns}IntegrationProcedureService`,
                                                        sMethodName: 'Inwi_InwiB2C_UnLockArticle',
                                                        options: '{}',
                                                    };

                                                    console.log('before call InwiB2C_UnLockArticlev');

                                                    this._actionUtilClass
                                                        .executeAction(params, null, this, null, null)
                                                        .then(response => {
                                                            console.log((response));
                                                        })
                                                        .catch(error => {
                                                            console.log(error);
                                                        });
                                                    for (let value of Object.values(ipResult)) {
                                                        console.log(values[value])
                                                        value !== null && this.dispatchEvent(
                                                            new ShowToastEvent({
                                                                title: 'Erreur',
                                                                message: value,
                                                                variant: 'error'
                                                            }),
                                                        );

                                                    }
                                                }
                                            }
                                            else {
                                                this.dispatchEvent(
                                                    new ShowToastEvent({
                                                        title: 'Erreur',
                                                        message: 'Erreur lors de la récupération des informations du terminal',
                                                        variant: 'error'
                                                    }),
                                                );

                                            }
                                        }
                                    })
                                    .catch(error => {
                                        window.console.log(error);
                                    });
                            }
                        //Eclipse_Offre 5G Home B2C_LotA
                             else if (this.isIdarOffer) {
                              let parametreVerifyTerminal5G = {
                                newTerminalCode: codearticle,
                                OrderId: this.__item.OrderId.value,
                                oldTeminalCode: this.terminalModeleValue,
                                Action: "verifyTerminal",
                              };
                              console.log("parametreVerifyTerminal5G:");
                              console.log(parametreVerifyTerminal5G);
                              const paramsVIP = {
                                input: JSON.stringify(parametreVerifyTerminal5G),
                                sClassName: `${this._ns}IntegrationProcedureService`,
                                sMethodName: "inwib2c_verifyIdar5GTerminal",
                                options: "{}",
                              };

                              this._actionUtilClass
                                .executeAction(paramsVIP,null,this,null,null)
                                .then((response) => {
                                  console.log( "response inwib2c_verifyIdar5GTerminalt:");
                                  console.log(response);
                                  if (response.error == false) {
                                    if (response.result && response.result.IPResult) {
                                      console.log(response.result);
                                      console.log(response.result.IPResult);
                                      const ipResult = response.result.IPResult;

                                      if ( response?.result?.IPResult?.isCorresponding) {
                                        const params3 = {
                                            input: JSON.stringify(parametre),
                                            sClassName: `${this._ns}IntegrationProcedureService`,
                                            sMethodName: 'inwib2c_GetModelNameByCodeArticle',
                                            options: '{}',
                                        };

                                        this._actionUtilClass
                                            .executeAction(params3, null, this, null, null)
                                            .then(response => {
                                                console.log('voiçi le libelé article:');
                                                console.log(response);
                                                console.log(response.result.IPResult.Name);

                                                const modelLabel = response.result.IPResult.Name;
                                                this.setReturnedAttributeValue(codearticle, modelLabel)
                                            })
                                            .catch(error => {
                                                window.console.log(error);
                                            });
                                      } else if (!response?.result?.IPResult?.isCorresponding ) {
                                         this.dispatchEvent(
                                          new ShowToastEvent({
                                            title: "Erreur",
                                            message: "L’équipement saisi à remplacer, ne correspond pas à l’équipement en votre possession",
                                            variant: "error",
                                          })
                                        );
                                        let input =
                                          '{    "handset": [{"code": "' +
                                          codearticle +
                                          '","serialNumber": "' +
                                          this.terminalNewIMEIValue +
                                          '","orderType": "SMO", "vendor": "CPD01","quantity": "1"}],"action": "OS","mode": "SALE","channel": "SF","orgID": "INWI","marketSegment": "B2C","offerType": "MOBILE"}';

                                        const params = {
                                          input: input,
                                          sClassName: `${this._ns}IntegrationProcedureService`,
                                          sMethodName: "Inwi_InwiB2C_UnLockArticle",
                                          options: "{}",
                                        };

                                        console.log( "before call InwiB2C_UnLockArticlev" );

                                        this._actionUtilClass
                                          .executeAction( params,null,this,null,null)
                                          .then((response) => {
                                            console.log(response);
                                          })
                                          .catch((error) => {
                                            console.log(error);
                                          });

                                       
                                      }
                                    } else {
                                      this.dispatchEvent(
                                        new ShowToastEvent({
                                          title: "Erreur",
                                          message: "Erreur lors de la récupération des informations du terminal",
                                          variant: "error",
                                        })
                                      );
                                    }
                                  }
                                })
                                .catch((error) => {
                                  window.console.log(error);
                                });
                            }
                        //Eclipse_Offre 5G Home B2C_LotA                      
                            else {
                                const params3 = {
                                    input: JSON.stringify(parametre),
                                    sClassName: `${this._ns}IntegrationProcedureService`,
                                    sMethodName: 'inwib2c_GetModelNameByCodeArticle',
                                    options: '{}',
                                };

                                this._actionUtilClass
                                    .executeAction(params3, null, this, null, null)
                                    .then(response => {
                                        console.log('voiçi le libelé article:');
                                        console.log(response);
                                        console.log(response.result.IPResult.Name);

                                        const modelLabel = response.result.IPResult.Name;
                                        this.setReturnedAttributeValue(codearticle, modelLabel)
                                    })
                                    .catch(error => {
                                        window.console.log(error);
                                    });
                            }
                          
                            //!!!!!!!!!!!!!!!!!!!!!!!!!!! TTM: Swap ONT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        }
                        // Meryem Yahya SF24-042 B-30509
                        else if(response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorMessage){
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur: ' + response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorCode,
                                message: response.result.IPResult.CSValidateLineAttributesInteraction[0].CSStoreChange[0].errorMessage,
                                variant: 'error'
                                }),
                            );
                        }
                        // Meryem Yahya SF24-042 B-30509
                        else {

                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Erreur',
                                    message: 'Le Pack n\'est plus disponible. Veuillez choisir un autre pack',
                                    variant: 'error'
                                }),
                            );

                        }

                    }
                } else {
                    console.log('Erreur lors de la récupération du terminal');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération des informations du terminal',
                            variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });


    }

    setReturnedAttributeValue(codeArticle, modelLabel) {

        this.terminalModeleValue = codeArticle;
        this.terminalModelLabelValue = modelLabel;
        this.iemiValue = this.terminalNewIMEIValue;
        console.log(this.cpeMACValue);
        if(this.cpeMACValue ){
            this.cpeMACValue = codeArticle
        }

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
    getModelPriceIdarVacay() {

        let input = '{"OrderId": "' + this.__item.OrderId.value + '"}';

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_GetModelChangeSAVTerminalIdarVacay',
            options: '{}',
        };

        console.log('before call getExistingIcc' + params);

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    console.log('response      -->', response);
                    this.isloading = false;
                    if (response.result && response.result.IPResult) {
                        this.isidarvacay = response.result.IPResult.isIdarVacay
                        this.modellist = response.result.IPResult.Modeles
                        if (response.result.IPResult.Motif === 'inwiB2C_PerduVole'){                        
                            this.retourne = 'inwib2c_NonRetourne';
                            this.restitue = false;
                            this.disableRadio = true ;
                            this.disableSearchButtom = false;
                        }
                    }
                } else {
                    this.isloading = false;
                    console.log('Erreur lors de la récupération des terminaux');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération des informations des terminaux',
                            variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
                this.isloading = false;
            });


    }

    updateOrder() {

        let input = `{"OrderId": "${this.__item.OrderId.value}","retourne":"${this.retourne}","PriceSAV": ${this.selectedModelPrice} }`;

        console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_updateOrderStatus',
            options: '{}',
        };

        console.log('before call inwib2c_inwiB2C_updateOrderStatus' + params);

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error == false) {
                    console.log('response      -->', response);
                } else {
                    console.log('Erreur lors de la update de la commande');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la update de la commande',
                            variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });


    }

    
    handleSelectedRestitueOption(event){
        this.retourne = event.detail.value;
        this.restitue = event.detail.value === 'inwib2c_Retourne' ?  true: false ;
        this.disableSearchButtom = event.detail.value === 'inwib2c_Retourne' ? true : false;
        
        this.valideIMEI =  false ;
        this.errorImei = false;

        console.log('this.restitue ', this.restitue);
        console.log('this.retourne ', this.retourne);
       
    }
    
    get options() {
        return [
            { label: 'Réstituer', value: 'inwib2c_Retourne' },
            { label: 'Non Réstituer', value: 'inwib2c_NonRetourne' },
        ];
    }


    hanldleOldImeiEntry(event){
        this.terminalOldIMEIValue = event.detail.value;
        console.log('this.terminalOldIMEIValue ', this.terminalOldIMEIValue)
    }

    validateOldIMEI(event){
        //iemiValue
        this.errorImei = this.iemiValue !== this.terminalOldIMEIValue ? true : false 
        this.valideIMEI = this.iemiValue === this.terminalOldIMEIValue ? true : false 
        this.disableSearchButtom = this.iemiValue === this.terminalOldIMEIValue ? false : true 
        console.log('this.terminalOldIMEIValue ',this.terminalOldIMEIValue)
        console.log('this.iemiValue ',this.iemiValue)
    }
    handleModelSelection(event){
        this.selectedModel = event.target.value;
        let filtredModels = JSON.parse(JSON.stringify(this.modellist)).filter(elem =>{
            if (elem.Id === event.target.value ) return elem
        })
        let filtredModel = filtredModels[0] || {};
        console.log(filtredModel);
        this.selectedModelPrice = filtredModel?.price || 0;
        console.log('this.selectedModelPrice ',this.selectedModelPrice)

        console.log('this.selectedModel ', this.selectedModel)
    }
}