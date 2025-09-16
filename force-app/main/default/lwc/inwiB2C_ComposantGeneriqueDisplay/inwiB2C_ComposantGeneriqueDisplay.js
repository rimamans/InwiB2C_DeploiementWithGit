//islam:Hammoudi
import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_ComposantGeneriqueDisplay.html';

export default class InwiB2C_ComposantGeneriqueDisplay extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();
        var allmdn  = [];
        var istext=false;
        var isselect=false;
    }
    
    @api allmdn;
    @track label;
    handleMsisdn(event){
        let userValues = {"userValues" : event.target.value}
        this.omniUpdateDataJson(userValues);
        this.omniSaveState(userValues,true);
    }
    handleItemClicked(event){
        let userValues = {"userValues" : event.target.dataset.label}
        this.omniUpdateDataJson(userValues);
        this.omniSaveState(userValues,true);
    }
  
    render() {
        console.log('this.allmdn');
        console.log(this.allmdn);

        if(this.allmdn.inputType=="text"){
            this.istext=true; 
        }

        if(this.allmdn.inputType=="dropdown"){
            this.isselect=true;
        }
            
            console.log('this.isselect');
            console.log(this.istext);
            console.log(this.isselect);
        return template;
    }
}