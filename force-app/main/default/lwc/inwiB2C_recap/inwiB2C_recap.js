// characterLimitComponent.js
import { LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
export default class InwiB2C_recap extends OmniscriptBaseMixin(LightningElement)
{
    @track recap = '';
    @track isError = false;

    handleTextareaChange(event) {
        this.recap = event.target.value;
        console.log('textareaValue'+this.recap);
        this.isError = this.recap.length > 100;        
        this.omniUpdateDataJson({'recap':this.recap});

    }
}