import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';


export default class InwiB2C_addProducts extends OmniscriptBaseMixin(LightningElement) {


    @api number;

    BackToProdList(evt) {

        console.log (this.number);
        
        if (!this.number) this.number = 1;

        

        if (evt) {
            this.omniNavigateTo(this.omniScriptHeaderDef.asIndex - this.number);
        }
    }

    SaveAndNext(evt) {
        if (evt) {
            this.omniNextStep();
        }
    }



}