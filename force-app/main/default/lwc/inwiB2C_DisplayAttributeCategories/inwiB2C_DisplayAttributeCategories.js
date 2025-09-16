import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class InwiB2C_DisplayAttributeCategories extends OmniscriptBaseMixin(LightningElement) {

    __attributeCategories

    @api
    get attributeCategories (){
        return this.__attributeCategories;
    }
    set attributeCategories (value){
        this.__attributeCategories = {...value};
    }

    get attributeCategoriesString(){
        return JSON.stringify(this.attributeCategories);
    }
    
     // Y_MH begin Eclipse_Offre 5G
      __showservice ; 
    
       @api
     
      
      get showservice () {
        console.log ('ShowService5G  manage options ' , this.__showservice ) ;
        return this.__showservice ;   
      } 
      set showservice(value) {
        this.__showservice = value;
        console.log ('ShowService5G  manage options ' , this.__showservice ) ; 
      } 
    // Y_MH end Eclipse_Offre 5G
    

    hanldeAttributeCategroryValueChange(event) {

        //console.log(JSON.stringify(event.detail));

        let attributeCategory = event.detail;
        let attributeCategoryId = attributeCategory.Id;

        //console.log("attribute : " + JSON.stringify(attribute));

        let oldAttributeCategories = JSON.parse(JSON.stringify(this.__attributeCategories));

        let oldAttributeCategoriesRecords = oldAttributeCategories.records;

        let changedAttributeCategoriesRecords = oldAttributeCategoriesRecords.map(function (category) {

                if (category.Id === attributeCategoryId) return attributeCategory;
                else return category;
            }
            );
       
     

        oldAttributeCategories.records = changedAttributeCategoriesRecords;
        this.__attributeCategories = JSON.parse(JSON.stringify(oldAttributeCategories));

        //console.log('attributeCategories : ' + JSON.stringify( this.__attributeCategories))

        
        // Creates the event with the data.
        const selectedEvent = new CustomEvent("attributecategoriesvaluechange", {
            detail: this.__attributeCategories
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

        
      }




}