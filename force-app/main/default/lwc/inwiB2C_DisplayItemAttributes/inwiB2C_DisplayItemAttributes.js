import { LightningElement, track, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_DisplayItemAttributes extends OmniscriptBaseMixin(LightningElement) {

    hasterminal;
    __item;
    __isaccessoire;
    __actionType;
    __userProfile;
    __segmentOffer;
    __productOffer;
    /**Fraude 05/07/24 Ila Start */
    __allowsusproaming;
    __passfraude;
    __allowrehabappintern;
    __allowrehabroaming;
    /**Fraude 05/07/24 Ila End */
    __itemsValidationErrors = [];
    @track monProfile;
    @track monSegment;

    @api
    typeTerminal;

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    @api
    set item(value) {
        this.__item = { ...value };
    }
    get item() {
        return this.__item;

    }
    
    @api
    set actionType(value) {

        this.__actionType = value ? value : 'ACQ';

    }
    get actionType() {
        return this.__actionType
    }
    
    @api
    set isaccessoire(value) {

        this.__isaccessoire = value;

    }
    get isaccessoire() {
        return this.__isaccessoire;
    }
    /**Fraude 05/07/24 Ila Start */
    @api
    set allowsusproaming(value){
        this.__allowsusproaming = value;
    }
    get allowsusproaming(){
        return this.__allowsusproaming;
    }
    @api 
    set passfraude(value){
        this.__passfraude= value;
    }
    get passfraude (){
        return this.__passfraude;

    }
    @api 
    set allowrehabappintern(value){
        this.__allowrehabappintern= value;
    }
    get allowrehabappintern (){
        return this.__allowrehabappintern;

    }
    @api 
    set allowrehabroaming(value){
        this.__allowrehabroaming= value;
    }
    get allowrehabroaming (){
        return this.__allowrehabroaming;
    }
    /**Fraude 05/07/24 Ila End */ 
    @api
    set userProfile(value) {

        this.__userProfile = value;

    }
    get userProfile() {
        return this.__userProfile;
    }

    __typeparcour="";

    
    get typeparcour(){
        return this.__typeparcour;
        }
    
    @api
     set typeparcour(value){
        
            this.__typeparcour = value;
        
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

    @api
    set segmentOffer(value) {

        this.__segmentOffer = value;

    }
    get segmentOffer() {
        return this.__segmentOffer;
    }

    @api
    set productoffer(value) {

        this.__productOffer = value;

    }
    get productoffer() {
        return this.__productOffer;
    }

    get itemString() {
        return JSON.stringify(this.item);
    }

    get isModifNumber() {
        //console.log(this.__actionType);
        this.monProfile = this.__userProfile;
        this.monSegment = this.__segmentOffer;
        return (this.__actionType.includes("MODN"));
    }

    get isAcquisition() {
        //console.log(this.__actionType);
        return (this.__actionType.includes("ACQ"));
    }

    get isAcquisitionSuspension() {
        //console.log(this.__actionType);
        return (this.__actionType.includes("SUSP"));
    }
    get isSMOSim() {
        //console.log('actiontype'+this.__actionType);
        return (this.__actionType.includes("CHSIM"));
    }
    get isRehabilitation() {
        //console.log(this.__actionType);
        return (this.__actionType.includes("REHAB"));
    }
    get isSMOTerm() {
        console.log("ActionType DiplayItem" + this.__actionType);

        if (this.__actionType.includes("CHTERM")) {
            this.typeTerminal = "Mobile";
            return true;
        }
        else if (this.__actionType.includes("CHMODEM")) {
            this.typeTerminal = "Home";
            return true;
        }
        else
            return false;

    }
    get isSMOModem() {
        //console.log(this.__actionType);
        return (this.__actionType.includes("CHMODEM"));
    }


    get isChangeOption() {
        //console.log(this.__actionType);
        return (this.__actionType.includes("CHOPTION"));
    }

    __selectedmodel=false;
    @api 
    set selectedmodel(value) {
      this.__selectedmodel = value;
    }
    get selectedmodel() {
      return this.__selectedmodel;
    }

    __reprisesuitelivraison=false;
      @api
      get reprisesuitelivraison() {
        return this.__reprisesuitelivraison;
      } 
      set  reprisesuitelivraison(value) {
        this.__reprisesuitelivraison = value;
    
      }

      @api
      set disabledinputimei(value) {
        this.__disabledinputimei = value;
    }
      get disabledinputimei() {
         return this.__disabledinputimei;
      }

          
    __haspermissionsetlastmile;
    @api
    set haspermissionsetlastmile(value){
      this.__haspermissionsetlastmile = value;
    }
   get haspermissionsetlastmile(){
    return this.__haspermissionsetlastmile;
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
   
  __showservice ; 

   @api
  get showservice () {
    console.log ('ShowService5G  displayitemattributes ' , this.__showservice ) ;
    return this.__showservice ;   
  }  

  set showservice(value) {
    this.__showservice = value;
    console.log ('ShowService5G  displayitemattributes' , this.__showservice ) ; 
  }
   
// Y_MH end Eclipse_Offre 5G



 // H-M TTM LASTMILE TELEVNETE Begin 
    get shouldHideSimComponent() {
        return this.item.Name === 'SIM' && (
            (this.typeparcour === 'Televente' && this.haspermissionsetlastmile === true) || 
            (this.typeparcour === 'eshop' && this.valeurpreordersap === "DEFAULT"));
                

    }

    //Meryem Yahya && Y_MH end Eclipse_Offre 5G
      get shouldHideServic5GComponent() {
        return this.item.Name === 'Service 5G' &&  this.__showservice == false;
                

    }

    get cardTitle() {
        return this.shouldHideSimComponent || this.shouldHideServic5GComponent ? '' : this.item.Name;
    }
  
    //Meryem Yahya && Y_MH end Eclipse_Offre 5G
  // H-M TTM LASTMILE TELEVNETE END

  
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('ProductOfferDisplay' + this.__productOffer);
        console.log('SegmentOfferDisplay' + this.__segmentOffer);
        console.log('typeparcourManageItemeshopV2' +this.__typeparcour);
        console.log('this.__reprisesuitelivraisonItemAttri' +this.__reprisesuitelivraison);
        console.log('mode Livraion :', this.modelivraison);
        console.log('shouldHideSimComponent :', this.shouldHideSimComponent);
        console.log('valeurpreordersap:', this.valeurpreordersap);
       console.log("this.item.Name",this.item.Name);
       console.log("this.showservice",this.__showservice);

      


      
    }


    hanldeAttributeCategroriesValueChange(event) {

        event.stopPropagation();

        //console.log(JSON.stringify(event.detail));

        let attributeCategories = event.detail;

        let oldItem = JSON.parse(JSON.stringify(this.__item));


        oldItem.attributeCategories = attributeCategories;

        this.__item = JSON.parse(JSON.stringify(oldItem));

        this.updateItemAttribute();

        /*
                //add and remove fields to make update cart item work
                oldItem.processingLine = true;
                oldItem.i18TranslationComplete = true;
        
                delete oldItem.childProducts;
                delete oldItem.lineItems;
        
                //console.log(JSON.stringify( this.__item))
        
                const eventPayload = {
                    item: this.__item,
                    attributeItem: oldItem,
                    level: 0
                };
        
                
                //Creates the event with the data.
                const selectedEvent = new CustomEvent("itemattributesvaluechange", {
                    detail: eventPayload
                });
          
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
        
                */

    }
    handlecustomItemAttributesWithoutImei(event) {

        event.stopPropagation();

        console.log(JSON.stringify(event.detail));

        let inputItem = event.detail;

        this.__item = JSON.parse(JSON.stringify(inputItem));

        let oldItem = JSON.parse(JSON.stringify(this.__item));

        //add and remove fields to make update cart item work
        oldItem.processingLine = true;
        oldItem.i18TranslationComplete = true;

        delete oldItem.childProducts;
        delete oldItem.lineItems;

        //console.log(JSON.stringify( this.__item))

        const eventPayload = {
            item: this.__item,
            attributeItem: oldItem,
            level: 0
        };


        //Creates the event with the data.
        const selectedEvent = new CustomEvent("itemattributeswithoutimei", {
            detail: eventPayload
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        console.log('After dispatching success' +  this.dispatchEvent(selectedEvent));

    }
    hanldeLineItemAttributesValueChangeWithoutimei(event) {

        event.stopPropagation();

        console.log(JSON.stringify(event.detail));

        let lineItems = event.detail.lineItems;
        let attributeLineItems = event.detail.attributeLineItems;
        let level = event.detail.level;

        let oldItem = JSON.parse(JSON.stringify(this.__item));

        oldItem.lineItems = lineItems;

        this.__item = JSON.parse(JSON.stringify(oldItem));

        //add and remove fields to make update cart item work
        oldItem.processingLine = false;
        oldItem.i18TranslationComplete = true;

        delete oldItem.childProducts;
        delete oldItem.lineItems;

        oldItem.lineItems = attributeLineItems;

        let eventPayload = {};

        if (level == 1) {

            eventPayload = {
                item: this.__item,
                attributeItem: attributeLineItems,
                level: level
            };


        } else {

            level++;

            eventPayload = {
                item: this.__item,
                attributeItem: oldItem,
                level: level
            };

        }


        //Creates the event with the data.
        const selectedEvent = new CustomEvent("itemattributeswithoutimei", {
            detail: eventPayload
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);


    }


    hanldeCustomItemAttributesValueChange(event) {

        event.stopPropagation();

        console.log("Sortie de l'événement détaillé Custom:",JSON.stringify(event.detail));

        let inputItem = event.detail;

        this.__item = JSON.parse(JSON.stringify(inputItem));

        let oldItem = JSON.parse(JSON.stringify(this.__item));

        //add and remove fields to make update cart item work
        oldItem.processingLine = true;
        oldItem.i18TranslationComplete = true;

        delete oldItem.childProducts;
        delete oldItem.lineItems;

        //console.log(JSON.stringify( this.__item))

        const eventPayload = {
            item: this.__item,
            attributeItem: oldItem,
            level: 0
        };




        //Creates the event with the data.
        const selectedEvent = new CustomEvent("itemattributesvaluechange", {
            detail: eventPayload
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
       


    }

    hanldeLineItemAttributesValueChange(event) {

        event.stopPropagation();

        console.log("Sortie de l'événement détaillé Line:",JSON.stringify(event.detail));

        let lineItems = event.detail.lineItems;
        let attributeLineItems = event.detail.attributeLineItems;
        let level = event.detail.level;

        let oldItem = JSON.parse(JSON.stringify(this.__item));

        oldItem.lineItems = lineItems;

        this.__item = JSON.parse(JSON.stringify(oldItem));

        //add and remove fields to make update cart item work
        oldItem.processingLine = false;
        oldItem.i18TranslationComplete = true;

        delete oldItem.childProducts;
        delete oldItem.lineItems;

        oldItem.lineItems = attributeLineItems;

        let eventPayload = {};

        if (level == 1) {

            eventPayload = {
                item: this.__item,
                attributeItem: attributeLineItems,
                level: level
            };


        } else {

            level++;

            eventPayload = {
                item: this.__item,
                attributeItem: oldItem,
                level: level
            };

        }


        //Creates the event with the data.
        const selectedEvent = new CustomEvent("itemattributesvaluechange", {
            detail: eventPayload
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);


    }

   

    // Handle validation error from Custom Item Display

    handlecustomitemvalidationerror(event) {

        event.stopPropagation();

        console.log(JSON.stringify(event));
        console.log('handlecustomitemvalidationerror ' + this.__item.Name);


        /***************** */


        let eventItem = event.detail.item;
        let validationErrors = event.detail.errors;

        //Search for Item errors in itemsValidationErrors variable and add or replace the error list for the item

        let index = this.__itemsValidationErrors.findIndex(itemValidation => {
            return itemValidation.item == eventItem;
        });

        if (index >= 0) {
            console.log('index is: ' + index);
            this.__itemsValidationErrors[index] = {
                item: eventItem,
                validationErrors: validationErrors
            };

        } else {
            this.__itemsValidationErrors.push({
                item: eventItem,
                validationErrors: validationErrors
            })

        }

        console.log(index + '__itemsValidationErrors ' + JSON.stringify(this.__itemsValidationErrors));


        /***************** */


        //propagate updated error lost
        const selectedEvent = new CustomEvent("itemattributesvalidationerror", {
            detail: this.__itemsValidationErrors
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

    }

    handlelineitemattributesvalidationerror(event) {

        event.stopPropagation();
        console.log('toto Islam');

        console.log(JSON.stringify(event));
        console.log('handlelineitemattributesvalidationerror ' + this.__item.Name);

        let itemsValidationErrors = event.detail;

        itemsValidationErrors.forEach(itemValidationErrors => {

            let eventItem = itemValidationErrors.item;
            let validationErrors = itemValidationErrors.validationErrors;

            let index = this.__itemsValidationErrors.findIndex(itemValidation => {
                return itemValidation.item == eventItem;
            });

            if (index >= 0) {
                console.log('index is: ' + index);
                this.__itemsValidationErrors[index] = {
                    item: eventItem,
                    validationErrors: validationErrors
                };

            } else {
                this.__itemsValidationErrors.push({
                    item: eventItem,
                    validationErrors: validationErrors
                })

            }


        });




        console.log('__itemsValidationErrors 1' + JSON.stringify(this.__itemsValidationErrors));

        const selectedEvent = new CustomEvent("itemattributesvalidationerror", {
            detail: this.__itemsValidationErrors
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);


    }


    get isSim() {
       console.log('Itemmm:', this.item);
        return this.item.ProductCode == "INWIB2C_OFFERING_SIM" || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_SIM" || this.item.ProductCode == "INWIB2C_MOB01_OFFERING_SIM" || this.item.ProductCode == "INWIB2C_OPB2C_OFFERING_SIM";
    }

    //Atos LDA add terminal custom LWC

    get isTerm() {

        return this.item.ProductCode == "INWIB2C_FOB2C_OFFERING_TERMINAL"  || this.item.ProductCode == "INWIB2C_OPB2C_OFFERING_TERMINAL" || this.item.ProductCode == "INWIB2C_OFFERING_TERMINAL" || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_TERMINAL"  || this.item.ProductCode == "InwiB2C_TELEPHONE_FIXE" || this.item.ProductCode == "INWIB2C_OFFERING_MONTRECONN" || this.item.ProductCode === "INWIB2C_OFFRING_ATTRIBUTION_POINT_ACCESS";
    }

    get isMDN() {

        //return this.item.ProductCode == "INWIB2C_OFFERING_MSISDN_STANDARD";
        return  this.item.ProductCode=='INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD' || this.item.ProductCode== "INWIB2C_OPB2C_OFFERING_MSISDN_STANDARD" || this.item.ProductCode == "INWIB2C_OFFERING_MSISDN_STANDARD" || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_MSISDN_STANDARD" || this.item.ProductCode == "INWIB2C_MOB01_OFFERING_MSISDN_STANDARD";
    }
    get isChTerm() {
 
        return this.item.ProductCode=='INWIB2C_DEG01_OFFERING_TERMINAL' || this.item.ProductCode=="INWIB2C_FOB2C_OFFERING_TERMINAL" || this.item.ProductCode == "INWIB2C_OFFERING_TERMINAL" || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_TERMINAL" || this.item.ProductCode=="INWIB2C_OPB2C_OFFERING_TERMINAL";
    }
   


    get isStandardItem() {


     
        return (!this.isSim && !this.isMDN && !this.isTerm);  
    }

    get isServRoam() {

        return this.item.ProductCode == "INWIB2C_OFFERING_SRV_ROAMING";
    }

    get hasAttributes() {

        if (this.item.attributeCategories && this.item.attributeCategories.records) {

            let toDisplay = false;

            this.item.attributeCategories.records.forEach(attributeCategory => {
                attributeCategory.productAttributes.records.forEach(attribute => {

                    toDisplay = toDisplay || !attribute.hidden;
                });
            });

            return toDisplay;

        } else {
            return false;
        }

    }
    get hasterminal() {

        if (this.item.lineItems && this.item.lineItems.records) {

           

            this.item.lineItems.records.forEach(lineItem => {
                if(lineItem.ProductCode.includes("OFFERING_TERMINAL")){
                    this.hasterm = true;
                    this.item=lineItem;
                }

            });

            return this.hasterm;

        } else {
            return false;
        }

    }

    handlecustomitemattribvaluechangewithnext(event) {


        const selectedEvent = new CustomEvent("customitemattribvaluechangewithnext", {
            detail: event.detail
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }


    updateItemAttribute() {

        console.log('in updateItemAttribute');

        //console.log(JSON.stringify(updatedItemAttributes));

        let localItem = JSON.parse(JSON.stringify(this.__item));

        let sentItem = {};

        sentItem.attributeCategories = localItem.attributeCategories;
        sentItem.Id = localItem.Id;
        sentItem.Product2 = localItem.Product2;
        sentItem.PricebookEntry = localItem.PricebookEntry;
        sentItem.PricebookEntryId = localItem.PricebookEntryId;


        console.log('in updateItemAttribute22');

        let items = {};
        items.records = [];
        items.records.push(sentItem);

        console.log('in updateItemAttribute32');

        const orderId = localItem.actions.modifyattributes.remote.params.cartId;
        const itemId = localItem.actions.modifyattributes.remote.params.itemId;
        const Id = localItem.actions.modifyattributes.remote.params.Id;

        const inputParams = {
            cartId: orderId,
            items: items,
            itemId: itemId,
            id: Id,
           
            methodName: "putItemAttributes"

        }


        const params = {
            input: JSON.stringify(inputParams),
            sClassName: 'vlocity_cmt.CpqAppHandler',
            sMethodName: 'putItemAttributes',
            options: '{}',
        };

        console.log('before call putItemAttributes');

        console.log(params);

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log((response));

                //add and remove fields to make update cart item work
                localItem.processingLine = true;
                localItem.i18TranslationComplete = true;
                localItem.attributeCategories = response.result.records[0].attributeCategories;

                delete localItem.childProducts;
                delete localItem.lineItems;

                //console.log(JSON.stringify( this.__item))

                const eventPayload = {
                    item: this.__item,
                    attributeItem: localItem,
                    level: 0
                };


                //Creates the event with the data.
                const selectedEvent = new CustomEvent("itemattributesvaluechange", {
                    detail: eventPayload
                });

                // Dispatches the event.
                this.dispatchEvent(selectedEvent);



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
            .catch(error => {
                window.console.log(error);
            });

    }












}