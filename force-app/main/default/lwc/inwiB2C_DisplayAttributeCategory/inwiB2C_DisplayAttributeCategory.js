import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class InwiB2C_DisplayAttributeCategory extends OmniscriptBaseMixin(LightningElement) {

    __attributeCategory = {};



    @api
    get attributeCategory (){
        return this.__attributeCategory;
    }
    set attributeCategory (value){
        this.__attributeCategory = JSON.parse(JSON.stringify(value));

        
    }

     // Y_MH begin Eclipse_Offre 5G
  __showservice ; 

   @api
  set showservice(value) {
    this.__showservice = value;
    console.log ('ShowService5G  manage options ' , this.__showservice ) ; 
  }
  
  get showservice () {
    console.log ('ShowService5G  manage options ' , this.__showservice ) ;
    return this.__showservice ;   
  }  
// Y_MH end Eclipse_Offre 5G



    hanldeAttributeValueChange(event) {

        

        let attribute = event.detail;
        let attributeId = attribute.attributeId;

        //console.log("attribute : " + JSON.stringify(attribute));

        let oldAttributeCategory = JSON.parse(JSON.stringify(this.__attributeCategory));

        let oldProductAttributes = oldAttributeCategory.productAttributes.records;

        let changedAttributes = oldProductAttributes.map(function (attr) {

                if (attr.attributeId === attributeId) return attribute;
                else return attr;
            }
            );
       
     

        oldAttributeCategory.productAttributes.records = changedAttributes;
        this.__attributeCategory = JSON.parse(JSON.stringify(oldAttributeCategory));

        // Creates the event with the data.
        const selectedEvent = new CustomEvent("attributecategoryvaluechange", {
            detail: this.__attributeCategory
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        
      }



}