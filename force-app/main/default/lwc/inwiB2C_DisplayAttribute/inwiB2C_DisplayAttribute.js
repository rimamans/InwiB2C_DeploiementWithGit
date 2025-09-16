import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import template from './inwiB2C_DisplayAttribute.html';

export default class InwiB2C_DisplayAttribute extends OmniscriptBaseMixin(LightningElement) {

    @track 
    _attribute = {};

    val;

  

    @api 
    get attribute(){
        return this._attribute
    }
    set attribute(value){
        this._attribute = {...value};
    }

    get value (){
        return this._attribute.userValues;

        //return this.val;
    }
    set value (selected){
    
        let oldAttribute = this._attribute;
        oldAttribute.userValues = selected;
        this._attribute = oldAttribute;

    }

    // Y_MH begin Eclipse_Offre 5G
  __showservice = true ; 

   @api
  set showservice(value) {
    this.__showservice = value;
    console.log ('ShowService5G  1 ' , this.__showservice ) ; 
  }
  
  get showservice () {
    console.log ('ShowService5G  2 ' , this.__showservice ) ;
    return this.__showservice ;   
  }  
// Y_MH end Eclipse_Offre 5G

connectedCallback() {
    console.log('ConnectedCallback - Attribute label:', this.attribute?.label);
} 


    get inInputTypeDropDown () {

        if (this.attribute && this.attribute.inputType === 'dropdown')
        return true;
        else return false;
    }

    get inInputTypeRadio () {

        if (this.attribute && this.attribute.inputType === 'radio')
        return true;
        else return false;
    }

    get inOtherInputType () {

        if (this.attribute.inputType === 'radio' || this.attribute.inputType === 'dropdown' )
        return false;
        else return true;
    }

    get isHidden (){
        return this.attribute.hidden;
    }


    get attributeString() {

        return JSON.stringify(this.attribute);
    }

    get options (){

        let  o = [];

        if (this.attribute.values) {

            o = this.attribute.values.map(function(option){

                let newOption = [];
                newOption.label = option.label;
                newOption.value = option.value;
                return newOption;

        });


        }

       

        return(o);

    }

    handleChangeDropDown(event) {
        this.value = event.detail.value;

        const selectedEvent = new CustomEvent("attributevaluechange", {
            detail: this._attribute
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    handleChange(event) {
        this.value = event.detail.value;
        
    }

    handleFocusOut(evt) {

        const selectedEvent = new CustomEvent("attributevaluechange", {
            detail: this._attribute
        });
  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }


    /*get options () {


        return this.attribute.map(function(option){

            var tempOption;

            tempOption.label = option.label;
            tempOption.value = option.value;

            return tempOption;


        });




    }*/




}