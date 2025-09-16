import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_MdnResearch extends OmniscriptBaseMixin(LightningElement) {

    records;
    __item;
    __selectedmdn = '';
    __selectedmdnListItem = '';
    mdnChoice;
    RIOChecked;
    //MGEN3626SF Meryem Yahya
    RIOValid=false;
    //MGEN3626SF Meryem Yahya
    MDNChecked;

    
    @track selected = false;
    MDNRecoveredChecked;
    recoveredFlag = true;
    messageError;
    @track isRecovered = false;
    typeRecoveredMDN;
    showRecupOption = false;
    @track isMdnGenerated = true;
    isLoading = false; 
    _actionUtilClass;
    _ns = getNamespaceDotNotation();

    typemdnattributevalue;;
    OffreAttributeValue;
    CategoryAttributeValue;
    NbresultAttributeValue;
    mdnFilterAttributeValue = '';
    today;

    // Modif 

    __mdnTypeAttributeCategoriesId;
    __mdnTypeProductAttributesId;

    __mdnAttributeCategoriesId;
    __mdnProductAttributesId;

    __mdnTypeValue;
    __mdnPortedValue;
    __operatorValue;
    __portability;
    __mdnRecoveredValue

    __mdnPortedAttributeCategoriesId;
    __mdnPortedProductAttributesId;

    __operatorAttributeCategoriesId;
    __operatorProductAttributesId;

    __portabilityAttributeCategoriesId;
    __portabilityProductAttributesId;

    __mdnChoiceAttributeCategoriesId;
    __mdnChoiceProductAttributesId;

    __ocsIdAttributeCategoriesId;
    __ocsIdProductAttributesId;

    __elligiblePortaInAttributeCategoriesId;
    __elligiblePortaInProductAttributesId;

    __datePortaInAttributeCategoriesId;
    __datePortaInProductAttributesId;

    __rioAttributeCategoriesId;
    __rioProductAttributesId;

    //MGEN3626SF Meryem Yahya
    __rioValidAttributeCategoriesId;
    __rioValidProductAttributesId;
    //MGEN3626SF Meryem Yahya



    @api
    set item(value) {
        this.__item = { ...value };
    }
    get item() {
        return this.__item;

    }
    __product;
    @api
    set product(value) {
        this.__product = { ...value };
    }
   
    get product() {
        return this.__product;
    }

//CH-Y MigrationPrePostBackOffice Begin
    __iswakil =false;
  @api
  set iswakil(value) {
    this.__iswakil = value;
    console.log("is wakil aprés le setter", this.__iswakil)
  }
  get iswakil() {
      return this.__iswakil;

  }
//CH-Y MigrationPrePostBackOffice End
    __typeparcour="";

    @api
   get typeparcour() {
     return this.__typeparcour;
   }
   set typeparcour(value) {
     this.__typeparcour = value;
   }


   __typecanal; 
    @api
    set  typecanal(value){
      this.__typecanal = {...value};
    }
    get typecanal(){
      return this.__typecanal;
    }

    // B-31963 M_DJ 28/08/2025 begin
    __statutligne
    get statutligne() {
        return this.__statutligne
    }
    set statutligne(value) {
        this.__statutligne = value
    }
    // B-31963 M_DJ 28/08/2025 end

       

    get mdnChoiceAttributeValue() {

        let attributeCategories = this.__item.attributeCategories;
        let choice;


        if (attributeCategories.records) {

            attributeCategories.records.forEach((attributeCategory, index1) => {
                //console.log("index1:" + index1)

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        //console.log("index1:" + index1 + "index2:" + index2 + " : "  + productAttribute.code);

                        //console.log(productAttribute.code);

                        if (productAttribute.code == 'INWIB2C_ATT_RT_CHOIX_NUMERO') {

                            //console.log('found choice');

                            choice = productAttribute.userValues;
                            this.__mdnChoiceAttributeCategoriesId = index1;
                            this.__mdnChoiceProductAttributesId = index2;
                        }


                    });
                } else {
                    return null;
                }
            });
            console.log(this.__mdnChoiceAttributeCategoriesId + ' ' + this.__mdnChoiceProductAttributesId + ' ' + choice);

        } else {
            return null;
        }
        this.mdnChoice = choice;
        return choice;
    }

   
    get enableTypeMdn() {
         return !(this.__product && this.__product.InwiB2C_Type_offre__c != "Data" && ((this.__product.vlocity_cmt__Type__c === "Postpaye"&& this.typeparcour !="eshop") || this.__product.vlocity_cmt__Type__c === "Cameleon"))        
        //return !(this.__product && this.__product.InwiB2C_Type_offre__c != "Data" && (this.__product.vlocity_cmt__Type__c === "Postpaye" || this.__product.vlocity_cmt__Type__c === "Cameleon"))
    }

    

    set mdnChoiceAttributeValue(value) {

        //console.log('in set mdnChoiceAttributeValue : ' + value);

        this.mdnChoice = value;

        if (this.__mdnChoiceAttributeCategoriesId >= 0 && this.__mdnChoiceProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
            /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);*/

        }

        //console.log('After set mdnChoiceAttributeValue : ' + this.mdnChoice);

    }



    get mdnTypeAttributeValue() {

        let attributeCategories = this.__item.attributeCategories;
        let mdnTypeValue = null;

        console.log("attributeCategories 172");
        console.log(JSON.stringify(attributeCategories));

        if (attributeCategories.records) {

            attributeCategories.records.forEach((attributeCategory, index1) => {
                //console.log("index1:" + index1)

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        //console.log("index2:" + index2)

                        //console.log(productAttribute.code);

                        if (productAttribute.code.includes("TYPE_NULERO")) {
                            mdnTypeValue = productAttribute.userValues;
                            this.__mdnTypeAttributeCategoriesId = index1;
                            this.__mdnTypeProductAttributesId = index2;
                            console.log("TYPE_NULERO", index1, index2);
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_MSISDN') {
                            this.__selectedmdn = productAttribute.userValues;
                            this.__mdnAttributeCategoriesId = index1;
                            this.__mdnProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_MSISDN_PORTED') {
                            this.__mdnPortedValue = productAttribute.userValues;
                            this.__mdnPortedAttributeCategoriesId = index1;
                            this.__mdnPortedProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWI_ATT_RT_OPERATOR') {
                            this.__operatorValue = productAttribute.userValues;
                            this.__operatorAttributeCategoriesId = index1;
                            this.__operatorProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_BC_PORTABILITE') {
                            this.__portability = productAttribute.userValues;
                            this.__portabilityAttributeCategoriesId = index1;
                            this.__portabilityProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_OCSIDFINAL') {
                            this.__ocsIdAttributeCategoriesId = index1;
                            this.__ocsIdProductAttributesId = index2;
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_ElligibleForPortaIn') {
                            this.__elligiblePortaInAttributeCategoriesId = index1;
                            this.__elligiblePortaInProductAttributesId = index2;
                            console.log('eligible :' + productAttribute.userValues);
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_Datedeportabilite') {
                            this.__datePortaInAttributeCategoriesId = index1;
                            this.__datePortaInProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_RIO') {
                            this.__rioAttributeCategoriesId = index1;
                            this.__rioProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        //MGEN3626SF Meryem Yahya
                        if (productAttribute.code === 'INWIB2C_ATT_RT_RIO_VALIDE') {
                            this.__rioValidAttributeCategoriesId = index1;
                            this.__rioValidProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        //MGEN3626SF Meryem Yahya


                    });
                } else {
                    return 'NORMAL';
                }
            });

            //console.log(this.__mdnAttributeCategoriesId + ' ' + this.__mdnProductAttributesId);

        } else {
            return 'NORMAL';
        }
        return mdnTypeValue ? mdnTypeValue : 'NORMAL';
    }

    get operatorAttributeValue() {

        let attributeCategories = this.__item.attributeCategories;
        let operatorValue = null;

        console.log("attributeCategories 264");
        console.log(JSON.stringify(attributeCategories));

        if (attributeCategories.records) {

            attributeCategories.records.forEach((attributeCategory, index1) => {
                //console.log("index1:" + index1)

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        //console.log("index2:" + index2)

                        //console.log(productAttribute.code);

                        if (productAttribute.code.includes("TYPE_NULERO")) {

                            this.__mdnTypeAttributeCategoriesId = index1;
                            this.__mdnTypeProductAttributesId = index2;
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_MSISDN') {
                            this.__selectedmdn = productAttribute.userValues;
                            this.__mdnAttributeCategoriesId = index1;
                            this.__mdnProductAttributesId = index2;
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_MSISDN_PORTED') {
                            this.__mdnPortedValue = productAttribute.userValues;
                            this.__mdnPortedAttributeCategoriesId = index1;
                            this.__mdnPortedProductAttributesId = index2;
                        }

                        if (productAttribute.code === 'INWI_ATT_RT_OPERATOR') {
                            this.__operatorValue = productAttribute.userValues;
                            this.__operatorAttributeCategoriesId = index1;
                            this.__operatorProductAttributesId = index2;
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_BC_PORTABILITE') {
                            this.__portability = productAttribute.userValues;
                            this.__portabilityAttributeCategoriesId = index1;
                            this.__portabilityProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_OCSIDFINAL') {
                            this.__ocsIdAttributeCategoriesId = index1;
                            this.__ocsIdProductAttributesId = index2;
                        }
                        if (productAttribute.code === 'INWIB2C_ATT_RT_ElligibleForPortaIn') {
                            this.__elligiblePortaInAttributeCategoriesId = index1;
                            this.__elligiblePortaInProductAttributesId = index2;
                            console.log('eligible :' + productAttribute.userValues);
                        }
                        if (productAttribute.code === 'INWIB2C_ATT_RT_Datedeportabilite') {
                            this.__datePortaInAttributeCategoriesId = index1;
                            this.__datePortaInProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        if (productAttribute.code === 'INWIB2C_ATT_RT_RIO') {
                            this.__rioAttributeCategoriesId = index1;
                            this.__rioProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        //MGEN3626SF Meryem Yahya
                        if (productAttribute.code === 'INWIB2C_ATT_RT_RIO_VALIDE') {
                            this.__rioValidAttributeCategoriesId = index1;
                            this.__rioValidProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        //MGEN3626SF Meryem Yahya


                    });
                } else {
                    return null;
                }
            });

            //console.log(this.__operatorAttributeCategoriesId + ' ' + this.__operatorProductAttributesId);

        } else {
            return null;
        }
        return this.__operatorValue;
    }

    set mdnTypeAttributeValue(value) {
        console.log("set mdnTypeAttributeValue", value)
        this.__mdnTypeValue = value;

        console.log("set mdnTypeAttributeValue before", this.__mdnTypeAttributeCategoriesId, this.__mdnTypeProductAttributesId)
        if (this.__mdnTypeAttributeCategoriesId >= 0 && this.__mdnTypeProductAttributesId >= 0) {
            console.log("set mdnTypeAttributeValue after", this.__mdnTypeAttributeCategoriesId, this.__mdnTypeProductAttributesId)


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnTypeAttributeCategoriesId].productAttributes.records[this.__mdnTypeProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

            /*//Creates the event with the data.
            const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);*/

        }



    }

    set mdnAttributeValue(value) {

        this.__selectedmdn = value;
        console.log("JSON.stringify(localItem)--- update mdn", value, this.__mdnAttributeCategoriesId, this.__mdnProductAttributesId);
        if (this.__mdnAttributeCategoriesId >= 0 && this.__mdnProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__mdnProductAttributesId].userValues = value;
            localItem.attributeCategories.records[this.__mdnTypeAttributeCategoriesId].productAttributes.records[this.__mdnTypeProductAttributesId].userValues = this.__mdnTypeValue;

            // change Portability to Yes
            if (this.__portabilityAttributeCategoriesId >= 0 && this.__portabilityProductAttributesId >= 0) {

                localItem.attributeCategories.records[this.__portabilityAttributeCategoriesId].productAttributes.records[this.__portabilityProductAttributesId].userValues = 'Non';

            }

            this.__item = JSON.parse(JSON.stringify(localItem));

            console.log("JSON.stringify(localItem)--- update mdn");
            console.log(JSON.stringify(localItem));

            //Creates the event with the data.
            const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });

            // Dispatches the event.
            this.dispatchEvent(selectedEvent);

        }

    }

    get mdnAttributeValue() {

        return this.__selectedmdn;
    }

    


    // LDA Add RIO
    set rioAttributeValue(value) {

        if (this.__mdnAttributeCategoriesId >= 0 && this.__mdnProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));


            if (this.__rioAttributeCategoriesId >= 0 && this.__rioProductAttributesId >= 0) {

                localItem.attributeCategories.records[this.__rioAttributeCategoriesId].productAttributes.records[this.__rioProductAttributesId].userValues = value;

            }

            this.__item = JSON.parse(JSON.stringify(localItem));
        }

    }

    get rioAttributeValue() {

        if (this.__mdnAttributeCategoriesId >= 0 && this.__rioProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__rioProductAttributesId].userValues;

        } else {
            return null;
        }

    }
    //MGEN3626SF Meryem Yahya
    set rioValidAttributesValue(value) {

        if (this.__rioValidAttributeCategoriesId >= 0 && this.__rioValidProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));


            if (this.__rioAttributeCategoriesId >= 0 && this.__rioValidProductAttributesId >= 0) {

                localItem.attributeCategories.records[this.__rioAttributeCategoriesId].productAttributes.records[this.__rioValidProductAttributesId].userValues = value;

            }

            this.__item = JSON.parse(JSON.stringify(localItem));
        }

    }

    get rioValidAttributesValue() {

        if (this.__rioValidAttributeCategoriesId >= 0 && this.__rioValidProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__rioValidAttributeCategoriesId].productAttributes.records[this.__rioValidProductAttributesId].userValues;

        } else {
            return null;
        }
        //MGEN3626SF Meryem Yahya
    }

    handleRioChange(event) {
        //MGEN3626SF Meryem Yahya
        //this.RIOValid = false
        this.rioAttributeValue = event.detail.value;
        this.rioValidAttributesValue = false

        var RIOInput = this.template.querySelector(".RIOInput");
        RIOInput.setCustomValidity("");

        if (!this.rioAttributeValue || this.rioAttributeValue.trim() === "") {
            this.RIOChecked = true;
            RIOInput.setCustomValidity("");
            console.log('RIO code is empty, setting RIOChecked to true');
            this.DisplayErrors();
            return; 
        }
        //MGEN3626SF Meryem Yahya
    }

    get displayRIO() {
        return (this.operatorAttributeValue == 'WIN' || this.RIOValid == true || this.rioValidAttributesValue == true );
    }

    /*get recoverMDN() {
        return this.isRecovered == true;
    }*/

    //LDA END RIO






    set operatorAttributeValue(value) {

        this.__operatorValue = value;

        if (this.__operatorAttributeCategoriesId >= 0 && this.__operatorProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__operatorAttributeCategoriesId].productAttributes.records[this.__operatorProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
            /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);*/

        }

    }

    set ocsIdAttributeValue(value) {



        if (this.__ocsIdAttributeCategoriesId >= 0 && this.__ocsIdProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__ocsIdAttributeCategoriesId].productAttributes.records[this.__ocsIdProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));
        }

    }

    set elligiblePortaInAttributeValue(value) {


        if (this.__elligiblePortaInAttributeCategoriesId >= 0 && this.__elligiblePortaInProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__elligiblePortaInAttributeCategoriesId].productAttributes.records[this.__elligiblePortaInProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));
        }

    }

    get elligiblePortaInAttributeValue() {


        if (this.__elligiblePortaInAttributeCategoriesId >= 0 && this.__elligiblePortaInProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__elligiblePortaInAttributeCategoriesId].productAttributes.records[this.__elligiblePortaInProductAttributesId].userValues;

        }

    }

 
    set datePortaInAttributeValue(value) {


        if (this.__datePortaInAttributeCategoriesId >= 0 && this.__datePortaInProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__datePortaInAttributeCategoriesId].productAttributes.records[this.__datePortaInProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));
        }

    }

    // get datePortaInAttributeValue() {


    //     if (this.__datePortaInAttributeCategoriesId >= 0 && this.__datePortaInProductAttributesId >= 0) {

    //         return this.__item.attributeCategories.records[this.__datePortaInAttributeCategoriesId].productAttributes.records[this.__datePortaInProductAttributesId].userValues;

    //     }

    // }
    // H-M Reformater la date suite au Ticket B-14319 Begin 
    get datePortaInAttributeValue() {
        if (this.__datePortaInAttributeCategoriesId >= 0 && this.__datePortaInProductAttributesId >= 0) {
            const userValues = this.__item.attributeCategories.records[this.__datePortaInAttributeCategoriesId].productAttributes.records[this.__datePortaInProductAttributesId].userValues;
            if (userValues) {
                // Divise la date en parties : jour, mois, année
                const parts = userValues.split('/');
                // Reformate la date en "année-mois-jour"
                const formattedDate = `${parts[2]}-${parts[1]}-${parts[0]}`;
                console.log("Date récupérée (formatée) :", formattedDate);
                return formattedDate;
            } else {
                console.error("Erreur .");
                return null; 
            }
        }
    }
   // H-M Reformater la date suite au Ticket B-14319 END

    set mdnPortedAttributeValue(value) {

        this.__mdnPortedValue = value;

        if (this.__mdnPortedAttributeCategoriesId >= 0 && this.__mdnPortedProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__mdnPortedAttributeCategoriesId].productAttributes.records[this.__mdnPortedProductAttributesId].userValues = value;

            // change Portability to Yes
            if (this.__portabilityAttributeCategoriesId >= 0 && this.__portabilityProductAttributesId >= 0) {

                localItem.attributeCategories.records[this.__portabilityAttributeCategoriesId].productAttributes.records[this.__portabilityProductAttributesId].userValues = 'Oui';

            }

            this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
            /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);*/

        }

    }


    set mdnRecoveredAttributeValue(value) {

        this.__mdnRecoveredValue = value;
    }

    set portabilityAttributeValue(value) {

        this.__portability = value;

        if (this.__portabilityAttributeCategoriesId >= 0 && this.__portabilityProductAttributesId >= 0) {


            let localItem = JSON.parse(JSON.stringify(this.__item));

            localItem.attributeCategories.records[this.__portabilityAttributeCategoriesId].productAttributes.records[this.__portabilityProductAttributesId].userValues = value;

            this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
            /*const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                detail: this.__item
            });
    
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);*/

        }

    }

    get orderId() {
        return this.__item.OrderId.value;
    }

    get rootItemId(){
        return this.__item.vlocity_cmt__RootItemId__c.value;
    }

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        var today = new Date();
        var dd = today.getDate();

        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }

        if (mm < 10) {
            mm = '0' + mm;
        }

        this.today = yyyy + '-' + mm + '-' + dd;
        this.init();
        this.getPermissionRecupMDN()

      // H-M Vérifie si la valeur de mdnChoiceAttributeValue est 'porter' et si typeparcour est égal à 'RepriseD2D'.
      // H-M Si ces conditions sont vraies, réinitialise mdnChoiceAttributeValue à une valeur vide pour qu'aucune option ne soit sélectionnée par défaut.
         if (this.mdnChoiceAttributeValue === 'porter' && this.typeparcour ==='RepriseD2D' && this.statutligne !='Ligne Active') {
            this.mdnChoiceAttributeValue = '';  // Réinitialise la valeur pour éviter qu'une option par défaut ne soit sélectionnée.
        }
    }
    

    init() {

        let attributeCategories = this.__item.attributeCategories;
        let mdnTypeValue = null;

        console.log("init 652");
        console.log(JSON.stringify(attributeCategories));

        if (attributeCategories.records) {

            attributeCategories.records.forEach((attributeCategory, index1) => {
                //console.log("index1:" + index1)

                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                        //console.log("index2:" + index2)

                        //console.log(productAttribute.code);

                        if (productAttribute.code.includes("TYPE_NULERO")) {
                            mdnTypeValue = productAttribute.userValues;
                            this.__mdnTypeValue = productAttribute.userValues;
                            this.__mdnTypeAttributeCategoriesId = index1;
                            this.__mdnTypeProductAttributesId = index2;
                            console.log("TYPE_NULERO", index1, index2);
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_MSISDN') {
                            this.__selectedmdn = productAttribute.userValues;
                            this.__mdnAttributeCategoriesId = index1;
                            this.__mdnProductAttributesId = index2;
                            this.mdnRecoveredAttributeValue = this.__selectedmdn;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_MSISDN_PORTED') {
                            this.__mdnPortedValue = productAttribute.userValues;
                            this.__mdnPortedAttributeCategoriesId = index1;
                            this.__mdnPortedProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWI_ATT_RT_OPERATOR') {
                            this.__operatorValue = productAttribute.userValues;
                            this.__operatorAttributeCategoriesId = index1;
                            this.__operatorProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_BC_PORTABILITE') {
                            this.__portability = productAttribute.userValues;
                            this.__portabilityAttributeCategoriesId = index1;
                            this.__portabilityProductAttributesId = index2;
                        }

                        if (productAttribute.code == 'INWIB2C_ATT_RT_OCSIDFINAL') {
                            this.__ocsIdAttributeCategoriesId = index1;
                            this.__ocsIdProductAttributesId = index2;
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_ElligibleForPortaIn') {
                            this.__elligiblePortaInAttributeCategoriesId = index1;
                            this.__elligiblePortaInProductAttributesId = index2;
                            console.log('eligible :' + productAttribute.userValues);
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_Datedeportabilite') {
                            this.__datePortaInAttributeCategoriesId = index1;
                            this.__datePortaInProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }

                        if (productAttribute.code === 'INWIB2C_ATT_RT_RIO') {
                            this.__rioAttributeCategoriesId = index1;
                            this.__rioProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        //MGEN3626SF Meryem Yahya
                        if (productAttribute.code === 'INWIB2C_ATT_RT_RIO_VALIDE') {
                            this.__rioValidAttributeCategoriesId = index1;
                            this.__rioValidProductAttributesId = index2;
                            console.log('date :' + productAttribute.userValues);
                        }
                        //MGEN3626SF Meryem Yahya


                    });
                }
            });

            //console.log(this.__mdnAttributeCategoriesId + ' ' + this.__mdnProductAttributesId);

        }
    }



    get itemString() {
        return JSON.stringify(this.item);
    }



    get mdntyperecords() {
        this.__mdnTypeValue = this.__mdnTypeValue ? this.__mdnTypeValue : 'NORMAL';
        return [
            { label: 'Normal', value: 'NORMAL' },
            { label: 'Bronze', value: 'BRONZE' },
            { label: 'Silver', value: 'SILVER' },
            { label: 'Gold', value: 'GOLD' }
        ];

       /* if (this.__mdnTypeAttributeCategoriesId >= 0 && this.__mdnTypeProductAttributesId >= 0) {


            let attrValueList = this.__item.attributeCategories.records[this.__mdnTypeAttributeCategoriesId].productAttributes.records[this.__mdnTypeProductAttributesId].values;

            return attrValueList.map(function(e){
                let attVal = {};
                attVal.label = e.label;
                attVal.value = e.value;
                return attVal;
            });

           

        }*/


    }

    get operatorOptions() {

        if (this.__operatorAttributeCategoriesId >= 0 && this.__operatorProductAttributesId >= 0) {

            //console.log(JSON.stringify(this.__item.attributeCategories.records[this.__operatorAttributeCategoriesId].productAttributes.records[this.__operatorProductAttributesId]));


            return this.__item.attributeCategories.records[this.__operatorAttributeCategoriesId].productAttributes.records[this.__operatorProductAttributesId].values;

        } else return [];


    }


    getMdnList(event) {


        let offerType = "Pre";
        if (this.__product && (this.__product.vlocity_cmt__Type__c === "Postpaye" || this.__product.vlocity_cmt__Type__c === "Cameleon") )offerType = "Post";

        let input = '{"mdnType":"MO", "offerType":"' + offerType + '", "category":"' + this.__mdnTypeValue + '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId + '","nbrResult": 3, "rootItemId" : "'+ this.rootItemId+ '" }';

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
                if (response.error == false) {
                    console.log(response);

                    if (response.result) {
                        console.log(response);
                        var returnOptions = [];

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
            });


    }


    lockMDN() {
        if(this.__product.vlocity_cmt__Type__c =='FTTH'){
            this.selected = true;
        }
        console.log('selectedFlag'+this.selected);
        let mdn = this.__selectedmdnListItem;
        //console.log('in getMdnlist');

        let input = '{"MDN": {"mdn": "' + mdn + '","lockToken": "' + this.orderId + '"}}';


        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_LockMdn',
            options: '{}'
        };

        console.log('before call lockMDN' + JSON.stringify(params));

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response.error == false) {
                    console.log(response);
                    if (response.result) {
                        console.log(response);
                        if (response.result.IPResult && response.result.IPResult.Eligibilite && response.result.IPResult.Eligibilite=="NotEligible"){
                            console.log('Erreur Le MDN de la carte SIM existe déja dans SF');
    
                            this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Le MDN de la carte SIM existe déja dans SF',
                                variant: 'error'
                                }),
                            ); 


                        }
                        else{
                        let ocsId = response.result.IPResult.OCSID;

                        this.ocsIdAttributeValue = ocsId;
                        this.mdnAttributeValue = mdn;
                        let detail = {
                            item: this.__item.Id.value,
                            errors: [] 
                        };

                        const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                            detail: detail
                        });
                        this.dispatchEvent(customitemvalidationerror);
                        // update oneTimeCharge by mdn type
                        let oneCharge = 0;
                        switch (this.__mdnTypeValue) {
                            case "BRONZE":
                                oneCharge = 10;
                                break;
                            case "SILVER":
                                oneCharge = 200;
                                break;
                            case "GOLD":
                                oneCharge = 1000;
                                break;
                            default:
                                oneCharge = 0;
                                break;
                        }
                        this.callApplyAdjustment(oneCharge);
                    }
                }}
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });

                
        
    }

   

    callApplyAdjustment(oneCharge) {
        // const input = {
        //     orderitemid: this.__item.Id.value,
        //     price: oneCharge
        // }
        // console.log("inwib2c_update_mdn_price input");
        // console.log(input);
        // const params = {
        //     input: JSON.stringify(input),
        //     sClassName: `${this._ns}IntegrationProcedureService`,
        //     sMethodName: "inwib2c_update_mdn_price",
        //     options: "{}",
        // };

        // return this._actionUtilClass
        //     .executeAction(params, null, this, null, null)
        //     .then(response => {
        //         console.log("inwib2c_update_mdn_price response");
        //         console.log(response);
        //     })
        //     .catch(error => {
        //         console.log("inwib2c_update_mdn_price error");
        //         console.log(error);
        //     });
    }


    handleTypeMdnChange(event) {
        console.log(event.target.value);
        this.mdnTypeAttributeValue = event.target.value;
        this.__mdnTypeValue = event.target.value;
        console.log(this.__mdnTypeValue);
        //this.ocsIdAttributeValue = null;
        //this.mdnAttributeValue = null;
        this.callApplyAdjustment(0);

    }

    handleMdnFilterChange(event) {
     
        this.mdnFilterAttributeValue = event.target.value;
    }

    handleMdnSelection(event) {

        this.__selectedmdnListItem = event.detail.value;
    
        //this.lockMDN(event.detail.value);

        //this.mdnAttributeValue = event.detail.value;
    }

    handleOperatorChange(event) {
        this.MDNChecked = false;
        //MGEN3626SF Meryem Yahya
        this.RIOValid = false;
        this.rioValidAttributesValue = false
        //MGEN3626SF Meryem Yahya
        this.rioAttributeValue = null;
        let RioField = this.template.querySelector(".RIOInput");
        RioField.value = "";
        RioField.setCustomValidity("");
        RioField.reportValidity();
        this.operatorAttributeValue = event.detail.value;

        // ATOS: Add management of Win Portability


        //if (this.operatorAttributeValue === 'WIN'){
        let attributeError = {
            message: "Vous devez valider le numéro à porter pour continuer. Sinon, choisir une autre option"
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

        /*}else{
            // remove error
                            
            let detail = {
                item: this.__item.Id.value,
                errors: []
            };
    
            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });
        
            // Dispatches the event.
            this.dispatchEvent(customitemvalidationerror);
        }*/
    }

    handleMdnPortedChange(event) {
        //MGEN3626SF Meryem Yahya
        this.rioAttributeValue = null;
        this.RIOValid = false;
        this.rioValidAttributesValue = false
        let RioField = this.template.querySelector(".RIOInput");
        RioField.value = "";
        RioField.setCustomValidity("");
        RioField.reportValidity();
        //MGEN3626SF Meryem Yahya
        this.mdnPortedAttributeValue = event.detail.value;

      
    }
    handleMdnRecoveredChange(event) {
        this.mdnRecoveredAttributeValue = event.detail.value;

    }

    handleDatePortedChange(event) {


        let dateString = event.detail.value;
        var d = new Date(dateString);

        let dayName = d.getDay();

        console.log('day number ' + dayName + ' ' + typeof dayName);


        var dateField = this.template.querySelector(".DateInput");

        if (dayName === 6 || dayName === 0) {
            //console.log('in if');
            dateField.setCustomValidity("La date souhaitée de portabilité ne peut être un Samedi ou Dimanche.");
        } else {
            //console.log('in else');
            dateField.setCustomValidity(""); // if there was a custom error before, reset it
            this.datePortaInAttributeValue = event.detail.value;

        }
        dateField.reportValidity();


    }

    // handleMdnChoiceChange(event) {

    //     //console.log('in handleMdnChoiceChange : ' + event.detail.value);
    //     this.MDNChecked = false;
    //     this.mdnChoiceAttributeValue = event.detail.value;
    //     this.callApplyAdjustment(0);


    //     console.log('this.mdnChoiceAttributeValue: ' + this.mdnChoiceAttributeValue + ' this.operatorAttributeValue: ' + this.operatorAttributeValue);

    //     //if (this.mdnChoiceAttributeValue === 'porter' && this.operatorAttributeValue === 'WIN') {
    //     if (this.mdnChoiceAttributeValue === 'porter') {
    //         let attributeError = {
    //             message: "Vous devez valider le numéro à porter pour continuer. Sinon, choisir une autre option"
    //         }

    //         this.__validationErrors = [];
    //         this.__validationErrors.push(attributeError);
    //         let detail = {
    //             item: this.__item.Id.value,
    //             errors: this.__validationErrors
    //         };

    //         const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
    //             detail: detail
    //         });

    //         // Dispatches the event.
    //         this.dispatchEvent(customitemvalidationerror);

    //     } else if (this.mdnChoiceAttributeValue === 'recuperer') {
    //         let attributeError = {
    //             message: "Vous devez valider le numéro à récupérer pour continuer. Sinon, choisir une autre option"
    //         }

    //         this.__validationErrors = [];
    //         this.__validationErrors.push(attributeError);
    //         let detail = {
    //             item: this.__item.Id.value,
    //             errors: this.__validationErrors
    //         };

    //         const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
    //             detail: detail
    //         });

    //         // Dispatches the event.
    //         this.dispatchEvent(customitemvalidationerror);
    //     } else {
    //         // remove error
            
    //         let detail = {
    //             item: this.__item.Id.value,
    //             errors: []
    //         };

    //         const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
    //             detail: detail
    //         });

    //         // Dispatches the event.
    //         this.dispatchEvent(customitemvalidationerror);
    //     }

    //     this.updateAttributes();


    // }

    // H-M MC-SF24-040_Parcours Porta FTTH avec MDN provisoire begin
    get DisplayMdnProvisoire(){
       return this.__product.vlocity_cmt__Type__c ==='FTTH' && this.statutligne !=='Ligne Active'
     }
    // H-M MC-SF24-040_Parcours Porta FTTH avec MDN provisoire End

    async handleMdnChoiceChange(event) {
        this.rioValidAttributesValue = false
        this.MDNChecked = false;
        this.mdnChoiceAttributeValue = event.detail.value;
        this.isLoading = true;
        //  Cette ligne laisse le temps au DOM de rafraîchir et afficher le spinner
        await new Promise(resolve => setTimeout(resolve, 0));
        this.callApplyAdjustment(0);
        console.log('this.mdnChoiceAttributeValue: ' + this.mdnChoiceAttributeValue + ' this.operatorAttributeValue: ' + this.operatorAttributeValue);
  
 
    
           if(this.mdnChoiceAttributeValue === 'porter') {
            let attributeError = {
                message: "Vous devez valider le numéro à porter pour continuer. Sinon, choisir une autre option"
            };
    
            this.__validationErrors = [attributeError];
            let detail = {
                item: this.__item.Id.value,
                errors: this.__validationErrors
            };
    
            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", { detail });
            this.dispatchEvent(customitemvalidationerror);
     // H-M MC-SF24-040_Parcours Porta FTTH avec MDN provisoire begin
            // Get canal to order via getCanalToOrder
            const canal = await this.getCanalToOrder(this.orderId);
            console.log('Canal retrieved:', canal);
    
            // Vérification des conditions pour MDN provisoire
            if (this.__product.vlocity_cmt__Type__c === 'FTTH' &&
                ["inwiB2C_D2D", "inwiB2C_Eshop", "inwiB2C_Televente", "Point de vente","inwiB2C_D2DBackUp"].includes(canal)) {
    
                try {
                    // Étape 1: Obtenir la liste des MDNs disponibles
                    let offerType = this.__product && ["Postpaye", "Cameleon"].includes(this.__product.vlocity_cmt__Type__c) ? "Post" : "Pre";
    
                    let input = JSON.stringify({
                        mdnType: "MO",
                        offerType,
                        category: this.__mdnTypeValue,
                        mdn: this.mdnFilterAttributeValue,
                        lockToken: this.orderId,
                        nbrResult: 3,
                        rootItemId: this.rootItemId
                    });
    
                    console.log('getMdnList : ' + input);
    
                    const params = {
                        input,
                        sClassName: `${this._ns}IntegrationProcedureService`,
                        sMethodName: 'Inwi_InwiB2C_MdnSearch',
                        options: '{}'
                    };
    
                    console.log('before call apex1' + JSON.stringify(params));
    
                    let response = await this._actionUtilClass.executeAction(params, null, this, null, null);
                    console.log('Réponse de getMdnList:', response);
    
                    if (!response.error && response.result?.IPResult) {
                        let ipResult = response.result.IPResult;
                        let status = ipResult.result?.status;
                        let message = ipResult.result?.message;
    
                        console.log('statusError:', status);
                        console.log('messageError:', message);
    
                        if (status === '0') {
                            this.isMdnGenerated = false;  
                            throw new Error('Erreur retournée par la VIP MDN Recherche : ' + message);
                        }
                        if (ipResult.length > 0) {
                            // Étape 2: Verrouiller le MDN sélectionné
                            let mdn = ipResult[0].mdn;
                            this.__selectedmdnListItem = mdn;
                            if (this.__product.vlocity_cmt__Type__c == 'FTTH') {
                                this.selected = true;
                            }
                            console.log('selectedFlag' + this.selected);
                            
                            let inputLock = '{"MDN": {"mdn": "' + mdn + '","lockToken": "' + this.orderId + '"}}';
    
                            const paramsLock = {
                                input: inputLock,
                                sClassName: `${this._ns}IntegrationProcedureService`,
                                sMethodName: 'Inwi_InwiB2C_LockMdn',
                                options: '{}'
                            };
    
                            console.log('before call lockMDN' + JSON.stringify(paramsLock));
    
                            const lockResponse = await this._actionUtilClass.executeAction(paramsLock, null, this, null, null);
                            if (lockResponse.error == false) {
                                console.log(lockResponse);
                                if (lockResponse.result) {
                                    console.log(lockResponse);
                                    if (lockResponse.result.IPResult && lockResponse.result.IPResult.Eligibilite && lockResponse.result.IPResult.Eligibilite == "NotEligible") {
                                        console.log('Erreur Le MDN de la carte SIM existe déjà dans SF');
    
                                        this.dispatchEvent(
                                            new ShowToastEvent({
                                                title: 'Erreur',
                                                message: 'Le MDN de la carte SIM existe déjà dans SF',
                                                variant: 'error'
                                            }),
                                        );
                                    } else {
                                        let ocsId = lockResponse.result.IPResult.OCSID;
                                        this.ocsIdAttributeValue = ocsId;    
                                        this.mdnAttributeValue = mdn;
                                        console.log('mdnAttributeValue:', this.mdnAttributeValue);    
    
                                        // Display success message
                                        this.dispatchEvent(new ShowToastEvent({
                                            title: 'Succès',
                                            message: 'Le numéro provisoire a été sélectionné avec succès',
                                            variant: 'success'
                                        }));

                                        // Custom event vers le parent pour indiquer que le MDN provisoire a été sélectionné avec succès
                                        this.dispatchEvent(new CustomEvent('mdnprovisoiresuccess', {
                                         detail: { success: true }
                                          }));
     
                                          
                                        // update oneTimeCharge by mdn type
                                        let oneCharge = 0;
                                        switch (this.__mdnTypeValue) {
                                            case "BRONZE":
                                                oneCharge = 10;
                                                break;
                                            case "SILVER":
                                                oneCharge = 200;
                                                break;
                                            case "GOLD":
                                                oneCharge = 1000;
                                                break;
                                            default:
                                                oneCharge = 0;
                                                break;
                                        }
                                         this.callApplyAdjustment(oneCharge);
                                    }
                                }
                            } else {
                                this.isMdnGenerated = false;
                                this.mdnChoiceAttributeValue = null;
                                throw new Error(lockResponse.result?.IPResult?.message || 'Le MDN n\'a pas pu être réservé');
                            }
                        } else {
                            this.isMdnGenerated = false;
                            let statusmessage = ipResult.info?.status;
                            let statusCode = ipResult.info?.statusCode;
                            
                            throw new Error('Erreur retournée par la VIP MDN Recherche : ' + statusmessage + ' (statusCode: ' + statusCode + ')');
                        }
                    } else {
                        this.isMdnGenerated = false;
                        throw new Error('Erreur retournée par la VIP MDN Recherche : ' + message);
                    }
                } catch (error) {
                    this.isMdnGenerated = false;
                    console.error('Erreur lors de la génération et du verrouillage du MDN:', error);
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Erreur',
                        message: error.message || 'Une erreur est survenue lors de la génération et du verrouillage du MDN',
                        variant: 'error'
                    }));
                }
            } else {
                this.isLoading = false;
            }
           // H-M MC-SF24-040_Parcours Porta FTTH avec MDN provisoire 
        } else if (this.mdnChoiceAttributeValue === 'recuperer') {
            let attributeError = {
                message: "Vous devez valider le numéro à récupérer pour continuer. Sinon, choisir une autre option"
            };
    
            this.__validationErrors = [attributeError];
            let detail = {
                item: this.__item.Id.value,
                errors: this.__validationErrors
            };
    
            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", { detail });
            this.dispatchEvent(customitemvalidationerror);

        } else if(this.mdnChoiceAttributeValue ==='personaliser'){
            let attributeError = {
            message: "Le numéro de téléphone est obligatoire"
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
        this.dispatchEvent(customitemvalidationerror);
        
        
      } else {
            // Remove error
            let detail = {
                item: this.__item.Id.value,
                errors: []
            };
    
            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", { detail });
            this.dispatchEvent(customitemvalidationerror);
        }
    
        if (this.isMdnGenerated) {
            this.updateAttributes();
        }
    }
    

// H-M MC-SF24-040_Parcours Porta FTTH avec MDN provisoire (Une classe pour récupérer le canal de chaque parcours via l'OrderId ) Begin

    async getCanalToOrder(orderId) {
        let input = JSON.stringify({ orderId: orderId });
    
        const params = {
            input: input,
            sClassName: 'Inwib2c_GetCanalFromOrder', 
            sMethodName: 'getCanalToOrder', 
            options: '{}' 
        };
    
        console.log('Before calling Apex getCanalToOrder:', JSON.stringify(params));
    
        try {
            let response = await this._actionUtilClass.executeAction(params, null, this, null, null);
            console.log('Response from getCanalToOrder:', response);
    
            // Vérifier si la réponse est valide
            if (response && !response.error && response.result) {

                if (response.result.InwiB2C_Canal__c) {
                    let canal = response.result.InwiB2C_Canal__c;
                    return canal;
                } else {
                    throw new Error('InwiB2C_Canal__c not found in response');
                }
            } else {
                throw new Error('Error retrieving canal: ' + (response.error || 'Unknown error'));
            }
        } catch (error) {
            // Gérer les erreurs
            console.error('Error during getCanalToOrder call:', error);
            throw error;
        }
    }
    // H-M MC-SF24-040_Parcours Porta FTTH avec MDN provisoire (Une classe pour récupérer le canal de chaque parcours via l'OrderId ) End


    
    
    handleFocusOut(evt) {

        //Creates the event with the data.
        const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    updateAttributes() {

        //Creates the event with the data.
        const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
            detail: this.__item
        });
     console.log('isMdnGenerated in update attribute:', this.isMdnGenerated);
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    numberKeyUp(evt) {

        console.log(evt.keyCode + 'numberKeyUp');



        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            // Search B.E. service

            var mdn = this.template.querySelector(".MDNInput");
            var value = mdn.value;
            console.log(value + ' ' + value.match(/^212[0-9]+$/));
            // is input valid text?
            if (value.length != 12 || !value.match(/^212[0-9]+$/)) {
                mdn.setCustomValidity("Le numéro de téléphone saisi est incorrect. il doit être sur 12 caractères, commencer par 212 et ne doit comporter que des chiffres!");
            } else {
                mdn.setCustomValidity(""); // if there was a custom error before, reset it

                if (this.__operatorValue === 'WIN') {

                    this.checkWinEligibility(value);

                } else {

                    this.mdnPortedAttributeValue = value;
                    this.updateAttributes();
                }

            }
            mdn.reportValidity(); // Tells lightning-input to show the error right away without needing interaction


        }
    }

    numberValidation(evt) {

        console.log(evt.keyCode + 'numberValidation');


        var mdn = this.template.querySelector(".MDNInput");
        var value = mdn.value;


        console.log(value + ' ' + value.match(/^212[0-9]+$/));
        // is input valid text?
        if (value.length != 12 || !value.match(/^212[0-9]+$/)) {
            this.MDNChecked = false;
            if (this.__operatorValue != 'WIN') {
                this.DisplayErrors();
            }
            mdn.setCustomValidity("Le numéro de téléphone saisi est incorrect. il doit être sur 12 caractères, commencer par 212 et ne doit comporter que des chiffres!");
        }
        
    //    else if (this.__product && this.__product.vlocity_cmt__Type__c && (this.__product.vlocity_cmt__Type__c === "FTTH" || this.__product.vlocity_cmt__Type__c === "ADSL") && !value.match(/^212[58][0-9]+$/) ){
    //     this.MDNChecked = false;
    //         if (this.__operatorValue != 'WIN') {
    //             this.DisplayErrors();
    //         }
    //         mdn.setCustomValidity("Le numéro de téléphone saisi est incorrect. il doit être sur 12 caractères, commencer par 2125 ou 2128 et ne doit comporter que des chiffres!");
    //     }

    // H-M Ticket B-26254 : Permettre un numéro porté avec la tranche 2128 et 2125 pour le cas de FTTH - Begin
    else if ( this.__product && this.__product.vlocity_cmt__Type__c && ((this.__product.vlocity_cmt__Type__c === "FTTH" && !value.match(/^212[58][0-9]+$/)) || (this.__product.vlocity_cmt__Type__c === "ADSL" && !value.match(/^2125[0-9]+$/)))) { 
        this.MDNChecked = false;
         if (this.__operatorValue != 'WIN') {
            this.DisplayErrors();
        }
        // Définition du message d'erreur spécifique selon le type de produit
        if (this.__product.vlocity_cmt__Type__c === "FTTH") {
            mdn.setCustomValidity("Le numéro de téléphone saisi est incorrect. Il doit être sur 12 caractères, commencer par 2125 ou 2128 et ne comporter que des chiffres !");
        } else if (this.__product.vlocity_cmt__Type__c === "ADSL") {
            mdn.setCustomValidity("Le numéro de téléphone saisi est incorrect. Il doit être sur 12 caractères, commencer par 2125 et ne comporter que des chiffres !");
        }
    }
    // H-M Ticket B-26254 : Permettre un numéro porté avec la tranche 2128 et 2125 pour le cas de FTTH - End

        
        else {
            mdn.setCustomValidity(""); // if there was a custom error before, reset it

            if(this.__product && this.__product.vlocity_cmt__Type__c && this.__product.vlocity_cmt__Type__c =='FTTH' && this.option3 === true ){

            let localItem = JSON.parse(JSON.stringify(this.__item));
           //H-M MC-SF24-040_Parcours Portage FTTH avec MDN provisoire (désactiver la mise à jour de MSISDN par la valeur du numéro porté) Begin
           // localItem.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__mdnProductAttributesId].userValues = this.__mdnPortedValue;
           //H-M MC-SF24-040_Parcours Portage FTTH avec MDN provisoire (désactiver la mise à jour de MSISDN par la valeur du numéro porté)END 

           this.__item = JSON.parse(JSON.stringify(localItem));

            //Creates the event with the data.
             const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
               detail: this.__item
             });

             // Dispatches the event.
             this.dispatchEvent(selectedEvent);


           }

            if (this.__operatorValue === 'WIN') {

                this.checkWinEligibility(value);

            }
            else {


                mdn.setCustomValidity(""); // if there was a custom error before, reset it

                let mdnprovisional = '';
                let input = '{"OrderId": "' + this.__item.OrderId.value + '"}';
                console.log(input);
                const params = {
                    input: input,
                    sClassName: 'vlocity_cmt.IntegrationProcedureService',
                    sMethodName: 'Inwi_InwiB2C_GetMDNFromSIM',
                    options: '{}'
                };

                this._actionUtilClass
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                        console.log('response sara1');
                        console.log(response);
                        if (response.error == false) {
                            //console.log(JSON.parse(JSON.stringify(response)));
                            console.log('response sara2');
                            console.log(response);
                            if (response.result) {
                                console.log('response.result.IPResult.mdnprovisional');
                                console.log(response.result.IPResult.mdnprovisional);
                                mdnprovisional = response.result.IPResult.mdnprovisional;
                                if (mdnprovisional === this.__mdnPortedValue) {
                                    mdn.setCustomValidity("Le mdn saisi et le mdn par défaut sont identiques!");
                                    mdn.reportValidity();
                                    this.MDNChecked = false;
                                }
                                else {

                                    this.mdnPortedAttributeValue = value;
                                    this.MDNChecked = true;
                                    /* let detail = {
                                         item: this.__item.Id.value,
                                         errors: []
                                     };
                             
                                     const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                                         detail: detail
                                     });
                                     this.dispatchEvent(customitemvalidationerror);
 
                                     this.updateAttributes();*/
                                }
                                this.DisplayErrors();
                            }


                        }
                    })
                    .catch(error => {
                        console.log('error');
                        window.console.log(error);

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Erreur récuperation du mdn de la SIM',
                                variant: 'error'
                            }),
                        );
                    });

            }

        }
        mdn.reportValidity(); // Tells lightning-input to show the error right away without needing interaction



    }

    checkWinEligibility(mdn) {


        console.log('in checkWinEligibility');

        let input = '{"MDN": "' + mdn + '","Uuid": "12345","OrderId": "' + this.__item.OrderId.value + '"}';


        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_CheckEligPortaWin',
            options: '{}'
        };

        console.log('before call InwiB2C_CheckEligPortaWin' + JSON.stringify(params));

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response.error == false) {
                    console.log(response);

                    if (response.result && response.result.IPResult) {

                        let winEligibilityResult = JSON.parse(response.result.IPResult);

                        console.log(response.result.IPResult + ' ' + winEligibilityResult.status);

                        if (winEligibilityResult.status == 'OK') {

                            this.elligiblePortaInAttributeValue = true;
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: 'La ligne ' + mdn + ' est bien éligible à la portabilité',
                                    variant: 'success'
                                }),
                            );

                            // remove error

                            let detail = {
                                item: this.__item.Id.value,
                                errors: []
                            };

                            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                                detail: detail
                            });

                            // Dispatches the event.
                            this.dispatchEvent(customitemvalidationerror);

                            // in case on eligible Win number update both MDN and Ported MDN attributes. 
                            this.mdnPortedAttributeValue = mdn;
                            this.mdnAttributeValue = mdn;

                            this.updateAttributes();

                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Erreur',
                                    message: winEligibilityResult.ErrorMessage,
                                    variant: 'error'
                                }),
                            );
                        }

                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Erreur lors de la vérification de l\'éligibilité',
                                variant: 'error'
                            }),
                        );

                    }
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la vérification de l\'éligibilité',
                            variant: 'error'
                        }),
                    );

                }
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la vérification de l\'éligibilité',
                        variant: 'error'
                    }),
                );
            });


    }

    //MGEN3626SF Meryem Yahya
    CheckRIO() {
        var mdnValue = this.__mdnPortedValue;
        console.log('mdnValue 19 44: ' + mdnValue);
        
        var RIOInput = this.template.querySelector(".RIOInput");

        console.log('RIOATTRIBTEVALUE ' + this.rioAttributeValue);
        var CodeRio = this.rioAttributeValue;
        console.log('rioCode : ' + CodeRio);
        
        let operateur = this.operatorAttributeValue;
        RIOInput.setCustomValidity("");

        if (CodeRio) {
            if (CodeRio.length != 12) {                
                RIOInput.setCustomValidity("Le code RIO doit être de 12 caractères.");
                this.rioAttributeValue = '';
                this.RIOChecked = false;
                this.DisplayErrors();
            } else {
                
                RIOInput.setCustomValidity("");
                let CRioDebut = CodeRio.substring(0, 2);
                
                /*CHB 25/01/2024 B-13954 B-15649 begin*/
            // if ((operateur == 'MARM1' && CRioDebut != 'MI') || (operateur == 'MARMT' && CRioDebut != 'MM')) {
                if (this.__product.vlocity_cmt__Type__c == 'FTTH' && 
                    (this.__typecanal == "InwiB2C_D2D" || this.__typecanal == "inwiB2C_D2DBackUp")) {
                } else {
                    if (!CodeRio.match(/^[A-Z]{2}[E,P][1-2][A-Z0-9+]+$/)) {
                        this.RIOChecked = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Veuillez saisir un code RIO valide',
                                variant: 'error'
                            })
                        );
                        RIOInput.setCustomValidity("Veuillez saisir un code RIO valide");
                        this.rioAttributeValue = '';
                        this.DisplayErrors();
                        return;
                    }
                }
                
                if (((this.__product.vlocity_cmt__Type__c == 'Postpaye' || this.__product.vlocity_cmt__Type__c == 'Prepaye') 
                && ((operateur == 'MARM1' && CRioDebut != 'MI') || (operateur == 'MARMT' && CRioDebut != 'MM')))
                || ((this.__product.vlocity_cmt__Type__c == 'FTTH' || this.__product.vlocity_cmt__Type__c == 'ADSL' || this.__product.vlocity_cmt__Type__c == 'idar duo')
                && ((operateur == 'MARM1' && CRioDebut != 'FI') || (operateur == 'MARMT' && CRioDebut != 'FM')))) {
                //CHB 25/01/2024 B-13954  B-15649 END
                    RIOInput.setCustomValidity("Veuillez saisir un code RIO valide");
                    this.RIOChecked = false;
                    this.rioAttributeValue = '';
                    this.DisplayErrors();
                } else { 
                    RIOInput.setCustomValidity("");
                    // this.rioAttributeValue = CodeRio;

                   // if ((CodeRio.length == 12 || this.__typecanal == "inwiB2C_D2DBackUp")){
                    if (CodeRio.length == 12) {
                        let input = '{"rioCode": "' + CodeRio + '", "mdn": "' + mdnValue + '"}';
                        console.log('input : ' + JSON.stringify(input));
        
                        const params = {
                            input: input,
                            sClassName: `${this._ns}IntegrationProcedureService`,
                            sMethodName: 'Inwi_InwiB2C_CheckCodeRIO',
                            options: '{}'
                        }
        
                        this._actionUtilClass
                            .executeAction(params, null, this, null, null)
                            .then(response => {
                                if (response){
                                    console.log('RESPONSE 16 35 : ', response);
                                    console.log('RESPONSE Message 16 35 : ', response.result.IPResult.isResponse.message);
                                    
                                
                                if (response.result.IPResult.isResponse.message == 'OK') {
                                    this.RIOValid = true
                                    this.rioValidAttributesValue = true
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Succès',
                                            message: 'Le code RIO saisi est correct et correspond bien au numéro de téléphone fourni',
                                            variant: 'success'
                                        })
                                    );
                                    console.log('ShowToastEvent', response.result.IPResult.isResponse.message);
                                    this.RIOChecked = true;                                    
                                    this.DisplayErrors();
                                    RIOInput.setCustomValidity("");

                              // H-M : Déclenche la mise de l'attribut code RIO si il est valide
                              let localItem = JSON.parse(JSON.stringify(this.__item));
                                this.__item = JSON.parse(JSON.stringify(localItem));
                         
                                const selectedEvent = new CustomEvent("customitemattributesvaluechange", {
                                 detail: this.__item
                                });
 
                               this.dispatchEvent(selectedEvent);
 
                                    
                                } else if (response.result.IPResult.isResponse.message == 'KO') {
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Erreur',
                                            message: 'Le Code RIO saisi est incorrect. Veuillez vérifier et réessayer une nouvelle fois',
                                            variant: 'error'
                                        })
                                    );
                                    RIOInput.setCustomValidity("Erreur du code RIO");
                                    this.RIOChecked = false;
                                    this.rioAttributeValue = '';
                                    this.DisplayErrors();
                                }
        
                            }
                                
        
                                
        
        
                        })
                    }

                    
                    /* if (((this.__product.vlocity_cmt__Type__c == 'FTTH' && this.__typecanal == "InwiB2C_D2D")
                            && ((operateur == 'MARM1' && CRioDebut != 'FI') || (operateur == 'MARMT' && CRioDebut != 'FM')))) {
                            let input = '{"rioCode": "' + CodeRio + '", "mdn": "' + mdnValue + '"}';
                            console.log('input : ' + JSON.stringify(input));
    
                        const params = {
                            input: input,
                            sClassName: `${this._ns}IntegrationProcedureService`,
                            sMethodName: 'Inwi_InwiB2C_CheckCodeRIO',
                            options: '{}'
                        }
    
                        this._actionUtilClass
                            .executeAction(params, null, this, null, null)
                            .then(response => {
                                if (response.error === false) {
                                    if (response.result.IPResult.isResponse.message === 'OK') {
                                        this.dispatchEvent(
                                            new ShowToastEvent({
                                                title: 'Succès',
                                                message: 'Le code RIO est valide: ' + CodeRio,
                                                variant: 'success'
                                            })
                                        );
                                        RIOInput.setCustomValidity("Code RIO OK");
                                        this.RIOChecked = true;
                                        this.DisplayErrors();
                                    } else if (response.result.IPResult.isResponse.message === 'KO') {
                                        this.dispatchEvent(
                                            new ShowToastEvent({
                                                title: 'Erreur',
                                                message: 'code RIO saisi est invalide',
                                                variant: 'error'
                                            })
                                        );
                                        RIOInput.setCustomValidity("Erreur du code RIO");
                                        this.RIOChecked = false;
                                        this.rioAttributeValue = '';
                                        this.DisplayErrors();
                                    }
                                }
                        }
                            )};*/
                }
            }
            RIOInput.reportValidity();
        } else {
            RIOInput.reportValidity();
            // this.rioAttributeValue = CodeRio;
        }
    }
    //MGEN3626SF Meryem Yahya
    DisplayErrors() {
        this.__validationErrors = [];
        if (this.RIOChecked == false && this.MDNChecked != true && this.MDNChecked != undefined) {
            let attributeErrorMDN = {
                message: "Vous devez saisir un code RIO valide pour continuer. Sinon, choisir une autre option"
            }
            let attributeErrorRIO = {
                message: "Vous devez valider le numéro à porter pour continuer. Sinon, choisir une autre option"
            }
            this.__validationErrors.push(attributeErrorMDN);
            this.__validationErrors.push(attributeErrorRIO);
            let detail = {
                item: this.__item.Id.value,
                errors: this.__validationErrors,
                RIOInfo: this.RIOChecked,
            };

            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });

            // Dispatches the event.
            this.dispatchEvent(customitemvalidationerror);

        } else if (this.RIOChecked == false) {
            this.detail = [];
            this.RIOChecked = [];
            let attributeError = {
                message: "Vous devez saisir un code RIO valide pour continuer. Sinon, choisir une autre option RIO ONLY"
            }

            this.__validationErrors.push(attributeError);
            let detail = {
                item: this.__item.Id.value,
                errors: this.__validationErrors,
                RIOInfo: false,
            };

            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });

            // Dispatches the event.
            this.dispatchEvent(customitemvalidationerror);
        } else if (this.MDNChecked != true && this.MDNChecked != undefined) {
            let attributeError = {
                message: "Vous devez valider le numéro à porter pour continuer. Sinon, choisir une autre option"
            }
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
        }else if (this.RIOChecked == true) {
            this.detail = [];
            this.RIOChecked = [];
            
            let detail = {
                RIOInfo: true,
            };

            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });

            // Dispatches the event.
            this.dispatchEvent(customitemvalidationerror);
        } else {
            // this.mdnPortedAttributeValue = value;
            let detail = {
                item: this.__item.Id.value,
                errors: []
            };
            const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                detail: detail
            });
            this.dispatchEvent(customitemvalidationerror);
            this.updateAttributes();
        } 
    }
    //MGEN3626SF Meryem Yahya

    get mdnChoiceOptions() {
        
        /*return [
            { label: 'Garder Le numéro par défaut', value: 'option1' },
            { label: 'Personaliser le numéro', value: 'option2' },
            { label: 'Porter un numéro', value: 'option3' }
        ];*/

        let choice = this.mdnChoiceAttributeValue;


        //console.log("options Id: " + this.__mdnChoiceAttributeCategoriesId + ' ' + this.__mdnChoiceProductAttributesId);


        if (this.__mdnChoiceAttributeCategoriesId >= 0 && this.__mdnChoiceProductAttributesId >= 0) {

            //console.log(JSON.stringify(this.__item.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId]));
            
            console.log("************** this.__product ***************");
            //ANO B-11756 CHB -MHD 13/11/2023
            if(!this.__product){
                this.__product = {
                    vlocity_cmt__Type__c: 'Prepaye',
                    // ... autres champs de l'objet product
                };
            }
            console.log(this.__product);
            console.log(JSON.stringify(this.__item.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId].values));
            let list = [];


      
            
                this.__item.attributeCategories.records[this.__mdnChoiceAttributeCategoriesId].productAttributes.records[this.__mdnChoiceProductAttributesId].values.map(itemoption => {
                    console.log("iswakilMdnreseach", this.__iswakil);
                    console.log("itemOption", itemoption);


                    //CH-Y 13/05/2025 MGEN3677 Vente de forfaits Postpaid iDar via Wakil_V1.0 Begin
                    const label = itemoption.label?.toLowerCase();
                    console.log("itemOption.label", label);
                    //CH-Y 13/05/2025 MGEN3677 Vente de forfaits Postpaid iDar via Wakil_V1.0 End

                    if (itemoption.value === "porter" && this.__product && this.__product.InwiB2C_Type_offre__c === "Data") {
                //H-M Ajouter uniquement la valeur du numéro à porter à la liste dans le cas d'une commande de type RepriseD2D pour l'afficher sur le bouton radio 
                    }else if(this.typeparcour ==='RepriseD2D' && itemoption.value === "porter" && this.__iswakil === false && this.__product.vlocity_cmt__Type__c == 'FTTH'){
                //H-M Si ce n'est pas le type de parcours 'RepriseD2D', ajouter l'option entière à la liste  
                      list.push(itemoption);
                // H-M le cas de ADSL D2D on recois le numero porté dans on affiche direct les details choix numéro porté sans cliquer sur le button radio sera postioner par defaut sur porter
                    }else if(this.typeparcour ==='RepriseD2D' && itemoption.value === "porter" && this.__product.vlocity_cmt__Type__c == 'ADSL') {
                         this.mdnChoiceAttributeValue = "porter" ;
                    
                    }
                    
                    else if(this.typeparcour !='RepriseD2D' ) {
                    list.push(itemoption);
                    }
                    if(this.__iswakil === true){
                            list = list.filter((option) => option.label != "porter un numéro");
                            console.log("listFiltré", list);               
                        }
                     })
    
            let list2 = list;
            list2.forEach(itemoption => {
                //this.itemoption.value = index3;
                if(itemoption.value === "personaliser"  && this.mdnAttributeValue != null && this.mdnAttributeValue != '' ){
                    console.log('produit type '+this.__product.vlocity_cmt__Type__c);
                    console.log('flag selected '+this.mdnAttributeValue);
                    console.log('valeur de itemoption'+itemoption.value);
                    list = [];
                    list.push(itemoption);
                    console.log('liste des options '+list);
                } 
            
            });

            console.log('liste des options 2'+list);
            console.log('recup option', list.filter(option => option.value !== "recuperer"))
            return this.showRecupOption ? list : list.filter(option => option.value !== "recuperer");
            
        } else return null;
    }

    RecoverMdn() {

        var MDNRecov = this.template.querySelector(".MDNRecoveredInput");
        var MDNRecovered = MDNRecov.value;

        //Check MDN recovered Length/Format
        if (MDNRecovered.length != 12 || !MDNRecovered.match(/^212[0-9]+$/)) {
            // this.MDNRecoveredChecked = false;
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
                    if (response.result.IPResult.reason) this.messageError = response.result.IPResult.reason;
                    else this.messageError = 'Erreur lors de la vérification de l\'éligibilité';

                    if (response.error == false) {
                        console.log(response);
                        if (response.result && response.result.IPResult) {
                            console.log('isEligible' + response.result.IPResult.isEligible);
                            if (response.result.IPResult.isEligible == 'true') {
                                //Call  MDN Reservation

                                //this.typeRecoveredMDN = response.result.IPResult.mdnType;
                                this.typeRecoveredMDN = response.result.IPResult?.typeMDN ? response.result.IPResult?.typeMDN : 'NORMAL' 
                                console.log('typeRecoveredMDN' + this.typeRecoveredMDN);
                                let input = '{"mdn": "' + MDNRecovered + '","lockToken": "' + this.orderId + '","operationType": "RECOVERY"}';

                                const params = {
                                    input: input,
                                    sClassName: `${this._ns}IntegrationProcedureService`,
                                    sMethodName: 'inwib2c_InwiB2C_RECOVER_NUMBER',
                                    options: '{}'
                                };

                                console.log('params:' + params);
                                this._actionUtilClass
                                    .executeAction(params, null, this, null, null)
                                    .then(response => {

                                        if (response.error == false) {
                                            console.log(response);

                                            if (response.result && response.result.IPResult) {

                                                console.log('isReserved:' + response.result.IPResult.isReserved);
                                                if (response.result.IPResult.isReserved == true) {
                                                    //this.mdnRecoveredAttributeValue = MDNRecovered;
                                                    this.__mdnRecoveredValue = MDNRecovered;

                                                    this.dispatchEvent(
                                                        new ShowToastEvent({
                                                            title: 'Success',
                                                            message: 'La ligne ' + MDNRecovered + ' est réservée ',
                                                            variant: 'success'
                                                        }),
                                                    );

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

                                                    let detail = {
                                                        item: this.__item.Id.value,
                                                        errors: []
                                                    };

                                                    const customitemvalidationerror = new CustomEvent("customitemvalidationerror", {
                                                        detail: detail
                                                    });

                                                    // Dispatches the event.
                                                    this.dispatchEvent(customitemvalidationerror);

                                                    // in case on eligible Recovered MDN.
                                                    this.mdnAttributeValue = MDNRecovered;
                                                    this.mdnTypeAttributeValue = this.typeRecoveredMDN;

                                                    this.updateAttributes();
                                                    this.isRecovered = true;
                                                    console.log("isRecovered ", this.isRecovered)

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
                                        console.log('error');
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
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Erreur',
                                        message: this.messageError,
                                        variant: 'error'
                                    }),
                                );
                            }

                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Erreur',
                                    message: this.messageError,
                                    variant: 'error'
                                }),
                            );

                        }
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: this.messageError,
                                variant: 'error'
                            }),
                        );

                    }
                })
                .catch(error => {
                    console.log('error');
                    window.console.log(error);

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: this.messageError,
                            variant: 'error'
                        }),
                    );
                });
        }
        MDNRecov.reportValidity();
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

    get option1() {
        //console.log('option1 ' + this.mdnChoice);
        if (this.mdnChoice) return this.mdnChoice == 'garder';
        else return false;
    }

    get option2() {
        //console.log('option2 ' + this.mdnChoice);
        if (this.mdnChoice) return this.mdnChoice == 'personaliser';
        else return false;
    }

    get option3() {
        //console.log('option3 ' + this.mdnChoice);
        if (this.mdnChoice) return this.mdnChoice == 'porter';
        else return false;
    }

    get option4() {
        if (this.mdnChoice) return this.mdnChoice == 'recuperer';
        else return false;
    }
    get displayMDNChoice() {
        if (this.mdnAttributeValue) return false;
        else return true;
    }

}