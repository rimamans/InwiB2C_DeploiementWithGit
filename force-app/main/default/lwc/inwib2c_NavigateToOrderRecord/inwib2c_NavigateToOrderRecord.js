import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class Inwib2c_NavigateToOrderRecord extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    __orderid;
    @api 
    get orderid() {
        return this.__orderid;
    }
    set orderid(value){
        this.__orderid=value;
    }
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    
        console.log('orderid :' +this.__orderid);
    
      }
    gotonextStep(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.orderid,
                objectApiName:'Order',
                actionName:'view'
            },
        });
    }
    gotopreviousStep(){
        this.omniPrevStep();
    }

}