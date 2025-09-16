import { LightningElement, api,track  } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_DisplayMDN extends OmniscriptBaseMixin(LightningElement) {


    __item;
  

    __mdnAttributeCategoriesId;
    __mdnProductAttributesId;



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
        console.log("in mdn");
    }
    get mdnAttributeValue () {
      
        let attributeCategories = this.__item.attributeCategories;
        
        if (attributeCategories.records){
            attributeCategories.records.forEach ((attributeCategory, index1) => {
           
                let productAttributes = attributeCategory.productAttributes.records;

                if (productAttributes) {

                    productAttributes.forEach((productAttribute, index2) => {
                       
                        if (productAttribute.code.includes("MSISDN")){
                            this.__mdnAttributeCategoriesId = index1;
                            this.__mdnProductAttributesId = index2;
                        }
                        


                    });
                }else {
                    return null;
                }
             });

        }else{
            return null;
        }

        if (this.__mdnAttributeCategoriesId >= 0 && this.__mdnProductAttributesId >= 0) {

            return this.__item.attributeCategories.records[this.__mdnAttributeCategoriesId].productAttributes.records[this.__mdnProductAttributesId].userValues;

        }else return null;

    }
   

}