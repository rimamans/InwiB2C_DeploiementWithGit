import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import template from './inwiB2C_ManageBundleHierarchyAttributesForEshop.html';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class InwiB2C_ManageBundleHierarchyAttributesForEshop extends OmniscriptBaseMixin(LightningElement) {

    
    __item;
    __isaccessoire;
    __actionType = 'ACQ';
    __userProfile='';
    __segmentOffer='';
    __productOffer;
    __itemsValidationErrors = [];
    isModalOpen = false;
    errorList = [];
    @track __typeparcourvalue;
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    updateOngoing = false;

    @api 
    set item(value){
        this.__item = {...value};
    }
    get item (){
        return this.__item;

    }

    @api
    set actionType (value){

        this.__actionType = value? value: 'ACQ';

    }
    get actionType (){
        return this.__actionType;
    }
    @api
    set userProfile (value){

        this.__userProfile = value;

    }
    get userProfile (){
        return this.__userProfile;
    }
    @api
    set isaccessoire (value){

        this.__isaccessoire = value;

    }
    get isaccessoire (){
        return this.__isaccessoire;
    }

    @api
    set segmentOffer (value){

        this.__segmentOffer = value;

    }
    get segmentOffer (){
        return this.__segmentOffer;
    }

    @api
    set productoffer(value){

        this.__productOffer = value;

    }
    get productoffer (){
        return this.__productOffer;
    }
    
    __selectedmodel=false;
    @api 
    set selectedmodel(value) {
      this.__selectedmodel = value;
    }
    get selectedmodel() {
      return this.__selectedmodel;
    }

    


    get actionTypeString (){
        return JSON.stringify(this.__actionType);
    }

    get itemString (){

        
            return JSON.stringify(this.item);
        
    }

    @api livraison = '';
    
  __displayconfigurationanderror=true;
  @api
  set displayconfigurationanderror(value) {
    this.__displayconfigurationanderror = value ;
  }
  get displayconfigurationanderror() {
    return this.__displayconfigurationanderror;
  }
  __typeparcour="";
  @api
  set typeparcour(value) { 
        this.__typeparcour = value;
    
  }
  get typeparcour() {
    return this.__typeparcour;
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
    inInputTypeDropDown (value) {
        return value === 'inputType';
    }
    __reprisesuitelivraison=false;
      @api
      set  reprisesuitelivraison(value) {
        this.__reprisesuitelivraison = value;
    
      }
      get reprisesuitelivraison() {
        return this.__reprisesuitelivraison;
      } 
      @api
      set disabledinputimei(value) {
        this.__disabledinputimei = value;
    }
      get disabledinputimei() {
         return this.__disabledinputimei;
      }

      __valeurpreordersap='';
      @api
      get valeurpreordersap(){
          return this.__valeurpreordersap;
        }
      set valeurpreordersap(value){
        this.__valeurpreordersap = value;
      }

      // Y_MH begin Eclipse_Offre 5G
 
  showservice = false; 


//    @api
//   get showservice () {
//     console.log ('ShowService5G  manage options ' , this.__showservice ) ;
//     return this.__showservice ;   
//   }  

//   set showservice(value) {
//     this.__showservice = value;
//     console.log ('ShowService5G  manage options ' , this.__showservice ) ; 
//   }
  
// Y_MH end Eclipse_Offre 5G


    // getTypeParcour() {
    //     return this.__typeparcour; // Return the current value of typeparcour
    // }

    // //__typeParcourValue = this.getTypeParcour();
    // __typeparcourvalue = this.getTypeParcour();
    
    // getTypeParcour = this.__typeparcour;
    printrResults (event){

        //console.log(JSON.stringify(this.item));

    }
    get ShowButton(){
        return this.modelivraison==="Domicile" && this.valeurpreordersap ==="DEFAULT"
      }

    hanldeItemAttributesValueChange(event) {

        

        //console.log (JSON.stringify(event));

        let updatedItem = event.detail.item;
        let updatedItemAttributes = event.detail.attributeItem;

       // console.log('updatedItemAttributes : '+JSON.stringify(event.detail.attributeItem));

        let itemId = updatedItem.Id.value;

        let oldItems = JSON.parse(JSON.stringify(this.__item));
        console.log('oldItems' + oldItems);
        let oldItemsRecords = oldItems.records;
        console.log('oldItemsrecords' + oldItems.records);
        let changedItemsRecords = oldItemsRecords.map(function (itemOccur) {

            if (itemOccur.Id.value === itemId) return updatedItem;
            else return itemOccur;
        }
        );

        oldItems.records = changedItemsRecords;
        this.__item = JSON.parse(JSON.stringify(oldItems));
        console.log('this.item : '+this.__item);
        //console.log("In manage end : " + JSON.stringify(this.__item));

        this.updateItemAttribute (updatedItemAttributes);


        
    }

    handleItemAttributesWithoutImei(event) {

        
        //console.log (JSON.stringify(event));

        let updatedItem = event.detail.item;
        let updatedItemAttribute = event.detail.attributeItem;

       // console.log('updatedItemAttributes : '+JSON.stringify(event.detail.attributeItem));

        let itemId = updatedItem.Id.value;

        let oldItems = JSON.parse(JSON.stringify(this.__item));
        console.log('oldItems' + oldItems);
        let oldItemsRecords = oldItems.records;
        console.log('oldItemsrecords' + oldItems.records);
        let changedItemsRecords = oldItemsRecords.map(function (itemOccur) {

            if (itemOccur.Id.value === itemId) return updatedItem;
            else return itemOccur;
        }
        );

        oldItems.records = changedItemsRecords;
        this.__item = JSON.parse(JSON.stringify(oldItems));
        console.log('this.item : '+this.__item);
        //console.log("In manage end : " + JSON.stringify(this.__item));

        this.updateItemAttributeWithoutImei(updatedItemAttribute);


        
    }

    updateItemAttributeWithoutImei(updatedItemAttribute){


        let items = {};
        items.records = [];
        items.records.push(updatedItemAttribute);

               

        const orderId = this.__item.records[0].OrderId.value;
        console.log('__items'+this.__item);
        const itemId = this.__item.records[0].Id.value;

        const inputParams = {
            cartId : orderId,
            items: items,
            price : true,
            validate: true,
            includeAttachment: false,
            pagesize: 20,
            hierarchy: -1,
            methodName : "putCartsItems"

        }


        const params = {
            input: JSON.stringify(inputParams),
            sClassName: 'vlocity_cmt.CpqAppHandler',
            sMethodName: 'putCartsItems',
            options: '{}',
        };

        console.log('before call putCartsItems');
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));

                 this.getCartItem (orderId, itemId)
                /*if (response.result.pdf) {
                    console.log(JSON.stringify(response));
                }else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la mise à jour',
                        variant: 'error'
                        }),
                    );
                }*/

            })
            .then(() =>{
                if(this.actionType.includes("REHAB")){
                    this.omniNextStep();
                }
            })
            .catch(error => {
                window.console.log(error);
        });

    }

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('__items'+this.__item);
        console.log('__items2'+JSON.stringify(this.__item)); 
        console.log('updateOngoing'+this.updateOngoing);
        console.log('ProductOffer'+this.__productOffer);
        console.log('la Livraison est:'+this.livraison);
        console.log('typeParcoursmanageeshop:'+this.__typeparcour);
        console.log('this.__reprisesuitelivraison:'+this.__reprisesuitelivraison);
        console.log('displayconfigurationanderror:'+this.displayconfigurationanderror);
        //const typeParcourValue = this.getTypeParcour();
        //console.log('getTypeParcour3:'+this.__typeparcourvalue);
    }

    updateItemAttribute (updatedItemAttributes){

        //console.log(JSON.stringify(updatedItemAttributes));

        let items = {};
        items.records = [];
        items.records.push(updatedItemAttributes);

        this.updateOngoing = true;

        const orderId = this.__item.records[0].OrderId.value;
        console.log('__items'+this.__item);
        const itemId = this.__item.records[0].Id.value;

        const inputParams = {
            cartId : orderId,
            items: items,
            price : true,
            validate: true,
            includeAttachment: false,
            pagesize: 20,
            hierarchy: -1,
            methodName : "putCartsItems"

        }


        const params = {
            input: JSON.stringify(inputParams),
            sClassName: 'vlocity_cmt.CpqAppHandler',
            sMethodName: 'putCartsItems',
            options: '{}',
        };

        console.log('before call putCartsItems');
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));

                this.getCartItem (orderId, itemId)
                /*if (response.result.pdf) {
                    console.log(JSON.stringify(response));
                }else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la mise à jour',
                        variant: 'error'
                        }),
                    );
                }*/

            })
            .then(() =>{
                if(this.actionType.includes("REHAB")){
                    this.omniNextStep();
                }
            })
            .catch(error => {
                window.console.log(error);
        });

    }

    getCartItem (cartId, itemId){

        const inputParams = {
            cartId : cartId,
            id: itemId,
            price : false,
            validate: true,
            includeAttachment: false,
            pagesize: 20,
            hierarchy: -1,
            methodName : "getCartsItemsById"

        }


        const params = {
            input: JSON.stringify(inputParams),
            sClassName: 'vlocity_cmt.CpqAppHandler',
            sMethodName: 'getCartsItemsById',
            options: '{}',
        };

        console.log('before call getCartsItemsById');
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));
                if (response.error) {
                    //console.log(JSON.stringify(response));
                    this.__item = JSON.parse(JSON.stringify(response.result)); 
                    this.updateOngoing = false;
                    
                   
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Success',
                        message: 'Success',
                        variant: 'success'
                        }),
                    );

                }else {

                    this.updateOngoing = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la mise à jour',
                        variant: 'error'
                        }),
                    );
                }

            })
            .catch(error => {
                window.console.log(error);
        });

    }
    
    /* Atos: Modification 2021-06-28
    
    get isHidden(){
         return ((this.actionType.includes("SUSP"))||(this.actionType.includes("REHAB"))||(this.actionType.includes("CHSIM"))|| (this.actionType.includes("MODN")) ||(this.actionType.includes("CHTERM")) ||(this.actionType.includes("CHMODEM")) );
    }
    */

    get isHidden(){
        console.log('Type action: '+this.actionType);
        return ((this.actionType.includes("SUSP"))||(this.actionType.includes("REHAB"))||(this.actionType.includes("CHSIM"))|| (this.actionType.includes("CHTERM")) ||(this.actionType.includes("CHMODEM")) );
   }


    handleSave (event){
        /*let selectedPersonContact = {
            "personIdAccount" : selectedcontact.AccountId,
            "personIdContact" : selectedcontact.IdContact,
            "personLastName" : selectedcontact.LastName,
            "personFirstName" : selectedcontact.FirstName, 
            "navigateTo360": "Yes"
        }*/

        this.errorList = [];
        this.__itemsValidationErrors.forEach(itemValidationErrors => {
            itemValidationErrors.validationErrors.forEach(validationError => {
                this.errorList.push(validationError);
            });
        });

        console.log('errorList ' + JSON.stringify(this.errorList));
        console.log(this.livraison);

        if (this.errorList && this.errorList.length > 0 && this.displayconfigurationanderror==true){
            //console.log('errorlist ' + this.errorList.length)
            this.isModalOpen = true;
        }else{

            let oldItems = JSON.parse(JSON.stringify(this.__item));


            delete oldItems.records[0].messages;
            delete oldItems.records[0].actions;

            let reponse = {
                records : oldItems.records
            }
            
            this.omniUpdateDataJson(reponse);
            this.omniSaveState(reponse,true);
            this.omniNextStep();


        }


        
    }

     // Handle validation error from Custom Item Display

     handleitemattributesvalidationerror(event) {

        event.stopPropagation();

        //console.log (JSON.stringify(event));

        //let eventItem = event.detail.item;
        //let validationErrors = event.detail.errors;

        
        let itemsValidationErrors = event.detail;

        itemsValidationErrors.forEach(itemValidationErrors => {

            //console.log('itemValidationErrors ' + JSON.stringify(itemValidationErrors));

            let eventItem = itemValidationErrors.item;
            let validationErrors = itemValidationErrors.validationErrors;

            let index = this.__itemsValidationErrors.findIndex(itemValidation => {
                return itemValidation.item == eventItem;
            });

            //console.log('index ' + index);
    
            if (index >= 0) {
                //console.log('index is: ' + index);
                this.__itemsValidationErrors [index] = {
                    item: eventItem,
                    validationErrors: validationErrors
                };
    
            } else{
                this.__itemsValidationErrors.push({
                    item: eventItem,
                    validationErrors: validationErrors
                })
    
            }


        });


        

        //console.log(' __itemsValidationErrors ' + JSON.stringify(this.__itemsValidationErrors));

        this.errorList = [];

        

      }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    handlecustomitemattribvaluechangewithnext(event){
        console.log(JSON.stringify(event.detail));

        let nextStep = event.detail.nextStep;

        if (nextStep){
           this.omniNextStep();

        }

    }

    CheckArticleCodeAvailabilityInSAP() {



     this.errorList = [];
       console.log('itemsValidationErrors22:', this.__itemsValidationErrors);
          this.__itemsValidationErrors.forEach(itemValidationErrors => {
              itemValidationErrors.validationErrors.forEach(validationError => {
                this.errorList.push(validationError);
              });
          });

         // Exclure l’erreur spécifique "IMEI doit être valide et obligatoire!" this.errorList = this.errorList.filter(
          this.errorList = this.errorList.filter(
          error => error.message !== "IMEI doit être valide et oblogatoire!"
          );

           console.log('errorList après filtre: ' + JSON.stringify(this.errorList));

          if (this.errorList.length > 0) {
              console.log('ErreurLength:', this.errorList.length);
               this.isModalOpen = true;
               return;
            } else {
             this.isModalOpen = false;
           }
 
        console.log('This is the current item:', this.__item);

        
        // Vérifiez si __item et records sont bien définis
        if (this.__item && this.__item.records && this.__item.records.length > 0) {
            let input = '{"orderId": "' + this.__item.records[0].OrderId.value + '"}';
            console.log('Input code Article SAP:', input);
    
            const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'Inwi_InwiB2C_CheckArticleCodeAvailabilitySAP', 
                options: '{}',
            };
    
            this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('Response from SAP:', response);

               // Vérifiez si la réponse indique une erreur de timeout
            //    if (response.error === "Read timed out") {
            //     this.dispatchEvent(
            //        new ShowToastEvent({
            //        title: 'Erreur',
            //        message: 'Le délai d\'attente a été dépassé lors de la vérification des codes articles sur SAP',
            //       variant: 'error'
            //      })
            //     );
            //     return;
            //    }

                const articles = response.result.IPResult.articles;
                console.log('Articles:', articles);
                const allAvailableQuantity = articles.every(article => article.isAvailable === true);
    
                if (response.error === false) {
                    if (allAvailableQuantity) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Succès',
                                message: 'Tous les codes articles sont disponibles Sur SAP',
                                variant: 'success'
                            })
                        );
                        this.omniNextStep();
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Les codes articles ne sont pas disponibles Sur SAP',
                                variant: 'error'
                            })
                        );
                    }
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur s\'est produite lors de la vérification des codes articles sur SAP',
                            variant: 'error'
                        })
                    );
                }
            })
            .catch(error => {
                console.error('Error during SAP check:', error);
            });
        } else {
            console.error('Invalid item structure:', this.__item);
        }
    }


}