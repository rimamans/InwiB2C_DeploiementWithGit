import { LightningElement, api } from 'lwc';

import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_DisplaySearchedSubscritions.html';

export default class InwiB2C_DisplaySearchedSubscritions extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {


    constructor() {
        super();

        var subscriptiontodispaly = [];

    }

@api subscriptiontodispaly;


handleSubSelected(event){
    var  selectedsubscription = event.target.name;

    let selectedSubscription = {
        "selectedSubscription" : {
            "theId" : selectedsubscription.Id,
            "redirectToVue360Subscription" : true

        }
    }

    this.omniUpdateDataJson(selectedSubscription);
    this.omniSaveState(selectedSubscription,true);
    this.omniNextStep();

}


    render() {   
        return template;
    }

}