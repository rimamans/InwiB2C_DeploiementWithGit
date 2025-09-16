import { LightningElement, track, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_DisplayItemAttributes_v2 extends OmniscriptBaseMixin(LightningElement) {
    __item;
    __actionType;
    __userProfile;
    __itemsValidationErrors = [];
    @track monProfile;

    @api
    typeTerminal;

    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    __typeparcour="";
    

    get typeparcour() {
    return this.__typeparcour;
    }

    @api
     set typeparcour(value) {
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
    set userProfile(value) {

        this.__userProfile = value;

    }
    get userProfile() {
        return this.__userProfile;
    }
    get itemString() {
        return JSON.stringify(this.item);
    }

    get isModifNumber() {
        //console.log(this.__actionType);
        this.monProfile = this.__userProfile;
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
        //console.log(this.__actionType);
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
        console.log("CHOPTION===>", this.__actionType.includes("CHOPTION"));
        return (this.__actionType.includes("CHOPTION"));
    }

    get isMigration() {
        return (this.__actionType.includes("migrationPostpaye"));
    }

    // Var to check eligibilite NAFIDA et Collaborateur => Djamel OUAMER
    __username;
    @api
    set username(value) {
        this.__username = value;
    }
    get username() {
        return this.__username;
    }
    __accountid;
    @api
    set accountid(value) {
        this.__accountid = value;
    }
    get accountid() {
        return this.__accountid;
    }
    __cin;
    __demenagement;
    __provider;

    // Y_MH begin  Operateur
    __operateur ; 
    @api
    set operateur(value) {
        this.__operateur = value;
    }
    get operateur() {
        return this.__operateur;
    }
    // Y_MH END

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

    // Y-MH Begin 
__isrepriseeshop ;
@api
  set isrepriseeshop(value) {
    this.__isrepriseeshop = value;
  }
  get isrepriseeshop() {
    return this.__isrepriseeshop;
  }
// Y-MH End 

    @api
    set cin(value) {
        this.__cin = value;
    }
    get cin() {
        return this.__cin;
    }
    @api
    set demenagement(value) {
        this.__demenagement = value;
    }
    get demenagement() {
        return this.__demenagement;
    }
    @api
    set provider(value) {
        this.__provider = value;
    }
    get provider() {
        return this.__provider;
    }
    @api
    set isfar(value) {
        this.__isfar = value;
    }
    get isfar() {
        return this.__isfar;
    }
    __typepos;
    @api
    set typepos(value) {
        this.__typepos = value;
    }
    get typepos() {
        return this.__typepos;
    }
    //CHB 28/11/2023 DGSN DGPC begin */
    __permissiondgsndgpc;
    @api
    set permissiondgsndgpc(value) {
        this.__permissiondgsndgpc = value;
    }
    get permissiondgsndgpc() {
        return this.__permissiondgsndgpc;
    }
     //CHB 28/11/2023 DGSN DGPC end */
    /* ILA 19/01/2024 PUPPILLES DGPC Start */
    __permissionpuppilesdgpc;
    @api
    set permissionpuppilesdgpc(value) {
        this.__permissionpuppilesdgpc = value;
    }
    get permissionpuppilesdgpc() {
        return this.__permissionpuppilesdgpc;
    }
    /* ILA 19/01/2024 PUPPILLES DGPC End */

  //CH-Y MigrationPrePostBackOffice Begin
  __iswakil = false;
  @api
  set iswakil(value) {
      this.__iswakil = value ;
  }
  get iswakil() {
      return this.__iswakil;

}
//CH-Y MigrationPrePostBackOffice End


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
    set product(value) {
        this.__product = {...value};
    }
    get product() {
        return this.__product;
    }

    __typecanal; 
    @api
    set  typecanal(value){
      this.__typecanal = {...value};
    }
    get typecanal(){
      return this.__typecanal;
    }

    //AmineBrm Evolution B11661
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
      //FinEvolution B 11661

      __selectedmodel=false;
   
      @api
      set selectedmodel(value) {
        this.__selectedmodel = value;
      }
      get selectedmodel() {
        return this.__selectedmodel;
      }

    
     __displayimeiftth
    @api
    set  displayimeiftth(value) {

      this.__displayimeiftth = value;
    }
    get displayimeiftth() {
      return this.__displayimeiftth;
    }  
    __modepaiment='';
      @api
      get modepaiment(){
          return this.__modepaiment;
        }
      set modepaiment(value){
        this.__modepaiment = value;
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
    
    __isagencevalidationbocrcd2d;
    @api
    set isagencevalidationbocrcd2d(value){
      this.__isagencevalidationbocrcd2d = value;
     }
 
    get isagencevalidationbocrcd2d(){
    return this.__isagencevalidationbocrcd2d;
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

    // B-31963 M_DJ 28/08/2025 begin
   __statutligne
   @api
   get statutligne() {
    return this.__statutligne
   }
   set statutligne(value) {
    this.__statutligne = value
   }
   // B-31963 M_DJ 28/08/2025 end

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
/*R-SL 03/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 end*/
    
    connectedCallback() {
        console.log("demenagment1"+this.demenagement);
        console.log("wakilDisplayitemAttributes"+this.__iswakil);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log("selectedmodel" +this.selectedmodel);
     console.log("typeparcourPostPaye"+this.__typeparcour);
     console.log("__permissionpuppilesdgpc",this.__permissionpuppilesdgpc);
     console.log("provider" +this.__provider);
     console.log("disabledinputimei in v2" +this.__disabledinputimei);
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



    hanldeCustomItemAttributesValueChange(event) {

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
        const selectedEvent = new CustomEvent("itemattributesvaluechange", {
            detail: eventPayload
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);


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


    }
   
    handleChangeLigneType(event) {
        event.stopPropagation();
        console.log(JSON.stringify(event.detail));
        let inputItem = event.detail;
        const eventPayload = {
            item: JSON.parse(JSON.stringify(inputItem))
        };

        //Creates the event with the data.
        const selectedEvent = new CustomEvent("changelignetype", {
            detail: eventPayload
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    hanldeLineItemAttributesValueChange(event) {

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
        let RIOInfo = event.detail.RIOInfo;
    
        let index = this.__itemsValidationErrors.findIndex(itemValidation => {
            return itemValidation.item == eventItem;
        });
    
        if (index >= 0) {
            console.log('index is: ' + index);
            this.__itemsValidationErrors[index] = {
                item: eventItem,
                validationErrors: validationErrors,
                RIOInfo: RIOInfo
            };
        } else {
            this.__itemsValidationErrors.push({
                item: eventItem,
                validationErrors: validationErrors,
                RIOInfo: RIOInfo
            });
        }
    
        console.log(index + '__itemsValidationErrors ' + JSON.stringify(this.__itemsValidationErrors));
    
        /***************** */
    
        // Propagate the original error list
        const itemAttributesValidationErrorEvent = new CustomEvent("itemattributesvalidationerror", {
            detail: this.__itemsValidationErrors
        });
    
        // Dispatch the validation error event
        this.dispatchEvent(itemAttributesValidationErrorEvent);
    
        if (RIOInfo == false) {
            const rioCodeInvalidEvent = new CustomEvent("riocodeinvalid", {
                detail: { message: "Invalid RIO code" }
            });
            console.log('Dispatching rioCodeInvalid event');
            this.dispatchEvent(rioCodeInvalidEvent);
        } else if (RIOInfo == true) {
            const rioCodeValidEvent = new CustomEvent("riocodevalid", {
                detail: { message: "Valid RIO code" }
            });
            console.log('Dispatching rioCodeValid event');
            this.dispatchEvent(rioCodeValidEvent);
        }
    }
    

    handlelineitemattributesvalidationerror(event) {

        event.stopPropagation();
        console.log('toto');

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

    get isParent() {
        return this.item.vlocity_cmt__ParentItemId__c.value == null && this.item.Product2.vlocity_cmt__Type__c != 'Accesoire Idar';
    }


    get isSim() {

        return this.item.ProductCode.includes("OFFERING_SIM");

        // return (this.item.ProductCode == "INWIB2C_OFFERING_SIM"
        //     || this.item.ProductCode == "INWIB2C_MOB01_OFFERING_SIM"
        //     || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_SIM"
        // );
    }

    //Atos LDA add terminal custom LWC

    get isTerm() {
        return this.item.ProductCode.includes("OFFERING_TERMINAL")|| this.item.ProductCode.includes('InwiB2C_TELEPHONE_FIXE');

        // return (this.item.ProductCode == "INWIB2C_OFFERING_TERMINAL"
        //     || this.item.ProductCode == "INWIB2C_MOB01_OFFERING_TERMINAL"
        //     || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_TERMINAL");
    }

    get isMDN() {
        return this.item.ProductCode.includes("MSISDN_STANDARD");

        // return (this.item.ProductCode == "INWIB2C_OFFERING_MSISDN_STANDARD"
        //     || this.item.ProductCode == "INWIB2C_MOB01_OFFERING_MSISDN_STANDARD"
        //     || this.item.ProductCode == "INWIB2C_MOB02_OFFERING_MSISDN_STANDARD")
        //     ;
    }
    get isChTerm() {

        return this.item.ProductCode == "INWIB2C_OFFERING_TERMINAL" ||  this.item.ProductCode =="INWIB2C_OPB2C_OFFERING_TERMINAL";
    }


    get isStandardItem() {
        console.log("--->isStandardItem", (!this.isSim && !this.isMDN && !this.isTerm && !this.isParent))
        return (!this.isSim && !this.isMDN && !this.isTerm && !this.isParent);
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

    handlecustomitemattribvaluechangewithnext(event) {


        const selectedEvent = new CustomEvent("customitemattribvaluechangewithnext", {
            detail: event.detail
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    handleChangeLigneType(event) {


        const selectedEvent = new CustomEvent("changelignetype", {
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
            price: true,
            validate: true,
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
                console.log('response::');
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
                console.log('putItemAttributes_error' + error);
            });

    }

    handleCustomValidateCodeArticle(event) {
        this.displayconfigurationanderror = event.detail.displayconfigurationanderror;
        console.log('Display Configuration and Error v2 :', this.displayconfigurationanderror);

        const selectedEvent = new CustomEvent("customvalidatecodearticle", {
            detail: {
                displayconfigurationanderror: this.displayconfigurationanderror
            }
        });
     
        this.dispatchEvent(selectedEvent);
    }

    // handlecustomitemrioinfo(event) {
    //     this.RIOInfo = event.detail.RIOInfo;

    //     console.log('V2:', this.RIOInfo);
        

    //     //propagate updated error lost
    //     const selectedEvent = new CustomEvent("itemattributesrioinfo", {
    //         detail: this.RIOInfo
    //     });

    //     // Dispatches the event.
    //     this.dispatchEvent(selectedEvent);
    // }
    
    handleCustomimeivalidated(event){

        this.isValid = event.detail.isValid;
        console.log('IsDeviceAccessValidated lwc v2 :', this.isValid );
        const customDeviceAccessValidated = new CustomEvent('customdeviceaccessvalidated', {
            detail: {
                 isValid:  this.isValid
                }
             });
         this.dispatchEvent(customDeviceAccessValidated );

    }

    handleMdnProvisoireSuccess(event) {
    this.mdnProvisoireSelected = event.detail.success;
    console.log('mdnProvisoireValid :', this.mdnProvisoireSelected);

    const mdnValidEvent = new CustomEvent('mdnprovisoiresuccess', {
        detail: {
            mdnProvisoireSelected: this.mdnProvisoireSelected
        }
    });
    this.dispatchEvent(mdnValidEvent);
}





}