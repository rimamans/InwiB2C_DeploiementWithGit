import { LightningElement, api} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class InwiB2C_DisplayLineItemAttributes extends OmniscriptBaseMixin(LightningElement) {

    __lineItems;
    __actionType;
    __userProfile;
    __segmentOffer;

    __itemsValidationErrors = [];

    @api
    get lineItems (){
        return this.__lineItems;
    }
    set lineItems (value){
        this.__lineItems = {...value};
    }
    
    @api
    get actionType (){
        return this.__actionType
    }
    set actionType (value){
        this.__actionType = value? value: 'ACQ';
    }

    @api
    get userProfile (){
        return this.__userProfile;
    }
    set userProfile (value){
        this.__userProfile = value;
    }

    @api
    get segmentOffer (){
        return this.__segmentOffer;
    }
    set segmentOffer (value){

        this.__segmentOffer = value;

    }
    __typeparcour="";
    
    @api
    get typeparcour(){
        return this.__typeparcour;
        }

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
      get nameagencelivraison() {
        return this.__nameagencelivraison;
      }

      set nameagencelivraison(value) {
        this.__nameagencelivraison = value;
      }
     
      __codeagencelivraison="";
   
      @api
      get codeagencelivraison() {
        return this.__codeagencelivraison;
      }

      set codeagencelivraison(value) {
        this.__codeagencelivraison = value;
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

    
    handleitemattributesvalidationerror(event){

        event.stopPropagation();

        console.log (JSON.stringify(event));
        console.log('handleitemattributesvalidationerror ' );

        //let eventItem = event.detail.item;
        //let validationErrors = event.detail.errors;

        let itemsValidationErrors = event.detail;

        itemsValidationErrors.forEach(itemValidationErrors => {

            console.log('itemValidationErrors ' + JSON.stringify(itemValidationErrors));
            console.log('TypeParcoursLineItems ' + this.__typeparcour);
            console.log('disabledinputimeiLineItem ' + this.__disabledinputimei);
            console.log('valeurpreordersapLineItem:', this.valeurpreordersap);
            let eventItem = itemValidationErrors.item;
            let validationErrors = itemValidationErrors.validationErrors;

            let index = this.__itemsValidationErrors.findIndex(itemValidation => {
                return itemValidation.item == eventItem;
            });

            console.log('index ' + index);
    
            if (index >= 0) {
                console.log('index is: ' + index);
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


        

        console.log(' __itemsValidationErrors aa' + JSON.stringify(this.__itemsValidationErrors));

        

        const attributeErrorEvent = new CustomEvent("lineitemattributesvalidationerror", {
            detail: this.__itemsValidationErrors
        });
  
        // Dispatches the event.
        this.dispatchEvent(attributeErrorEvent);


    }
    
    handleItemAttributesWithoutImei(event){

        event.stopPropagation();

        console.log (JSON.stringify(event));

        let updatedItem = event.detail.item;
        let updatedAttributeItem = event.detail.attributeItem;
        let level = event.detail.level;

        //console.log('updatedItemAttributes : '+JSON.stringify(updatedItemAttributes));

        let itemId = updatedItem.Id.value;

        let oldLineItems = JSON.parse(JSON.stringify(this.__lineItems));

        let oldLineItemsRecords = oldLineItems.records;

        let changedLineItemsRecords = oldLineItemsRecords.map(function (itemOccur) {

            if (itemOccur.Id.value === itemId) return updatedItem;
            else return itemOccur;
        }
        );

        oldLineItems.records = changedLineItemsRecords;
        this.__lineItems = JSON.parse(JSON.stringify(oldLineItems));

        //console.log("In manage end : " + JSON.stringify(this.__item));

       
        oldLineItems.records = [];
        oldLineItems.records.push(updatedAttributeItem);

        //console.log(JSON.stringify( this.__item))

        let  eventPayload = {};

        if (level == 1) {

             eventPayload = {
                lineItems: this.__lineItems,
                attributeLineItems: updatedAttributeItem,
                level: level
            };

        }else {

             eventPayload = {
                lineItems: this.__lineItems,
                attributeLineItems: oldLineItems,
                level : level
            };

        }

        

        
        //Creates the event with the data.
        const selectedEvent = new CustomEvent("lineitemstemattributesvaluechangewithoutimei", {
            detail: eventPayload
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);


    }

    hanldeItemAttributesValueChange(event){

        event.stopPropagation();

        console.log (JSON.stringify(event));

        let updatedItem = event.detail.item;
        let updatedAttributeItem = event.detail.attributeItem;
        let level = event.detail.level;

        //console.log('updatedItemAttributes : '+JSON.stringify(updatedItemAttributes));

        let itemId = updatedItem.Id.value;

        let oldLineItems = JSON.parse(JSON.stringify(this.__lineItems));

        let oldLineItemsRecords = oldLineItems.records;

        let changedLineItemsRecords = oldLineItemsRecords.map(function (itemOccur) {

            if (itemOccur.Id.value === itemId) return updatedItem;
            else return itemOccur;
        }
        );

        oldLineItems.records = changedLineItemsRecords;
        this.__lineItems = JSON.parse(JSON.stringify(oldLineItems));

        //console.log("In manage end : " + JSON.stringify(this.__item));

       
        oldLineItems.records = [];
        oldLineItems.records.push(updatedAttributeItem);

        //console.log(JSON.stringify( this.__item))

        let  eventPayload = {};

        if (level == 1) {

             eventPayload = {
                lineItems: this.__lineItems,
                attributeLineItems: updatedAttributeItem,
                level: level
            };

        }else {

             eventPayload = {
                lineItems: this.__lineItems,
                attributeLineItems: oldLineItems,
                level : level
            };

        }

        

        
        //Creates the event with the data.
        const selectedEvent = new CustomEvent("lineitemstemattributesvaluechange", {
            detail: eventPayload
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);


    }

    handlecustomitemattribvaluechangewithnext(event){
        console.log(event);

        
         const selectedEvent = new CustomEvent("customitemattribvaluechangewithnext", {
              detail : event.detail
            });
    
        // Dispatches the event.
            this.dispatchEvent(selectedEvent);   
    }

    



}