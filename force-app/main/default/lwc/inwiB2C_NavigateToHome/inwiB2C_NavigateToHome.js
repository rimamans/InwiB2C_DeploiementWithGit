import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_NavigateToHome.html';


export default class InwiB2C_NavigateToHome extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
@api isok;

    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }
    gotopreviousStep(){
        this.omniPrevStep();
    }
    connectedCallback(){

console.log("isok"+this.isok);
}
    render() {
       
        return template;
    }
}