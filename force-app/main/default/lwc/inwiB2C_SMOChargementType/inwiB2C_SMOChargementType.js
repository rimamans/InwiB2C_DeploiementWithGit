import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_SMOChargementType extends OmniscriptBaseMixin(LightningElement) {
    @track selectedValue = '';
    
    connectedCallback() {
        // Create instance of OmniscriptActionCommonUtil utility class for use in this class
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.newJsonData = JSON.parse(JSON.stringify(this.omniJsonData));
    }

    get radioOptions() {
        return [
            { label: 'Chargement par MDN', value: 'MDN' },
            { label: 'Chargement par compte de facturation', value: 'facturation' }
        ];
    }

    handleChange(event) {
        this.selectedValue = event.detail.value;
        this.omniApplyCallResp({ 'chargementType': this.selectedValue });
    }
}