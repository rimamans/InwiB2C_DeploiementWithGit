import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwib2c_NextStepGestionRDV.html';


export default class Inwib2c_NextStepGestionRDV extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
@api isok;
@api updaterdv;

    
    
    connectedCallback(){

console.log("isok"+this.isok);
console.log("updaterdv"+this.updaterdv);
}
gotonextStep(){
    this.omniNextStep();
    
}
gotopreviousStep(){
    this.omniPrevStep();
}
    render() {
       
        return template;
    }
}