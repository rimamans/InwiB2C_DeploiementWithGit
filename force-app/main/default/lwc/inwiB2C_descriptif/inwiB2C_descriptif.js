// characterLimitComponent.js
import { LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
export default class InwiB2C_descriptif extends OmniscriptBaseMixin(LightningElement)
{
    @track textareaValue = '';
    @track isError = false;

    handleTextareaChange(event) {
        this.textareaValue = event.target.value;
        console.log('textareaValue'+this.textareaValue);
        this.isError = this.textareaValue.length > 4000;
        // var descriptif = '';
        // this.descriptif = this.textareaValue;
        // console.log('descriptif'+this.descriptif);        
        this.omniUpdateDataJson({ 'descriptif':this.textareaValue});
                        // this.omniUpdateDataJson(descriptif);
                        // this.omniSaveState(descriptif, true);
    }
}