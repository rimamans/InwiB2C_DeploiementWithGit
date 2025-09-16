import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from './inwiB2C_next.html';

export default class inwiB2C_next extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
   
    __labelstep;
    @api 
    get labelstep() {
        return this.__labelstep;
    }
    set labelstep(value){
        this.__labelstep=value;
    }
    gotonextStep() {
        this.omniNextStep();
    }

    gotopreviousStep() {
        this.omniPrevStep();

    }

}