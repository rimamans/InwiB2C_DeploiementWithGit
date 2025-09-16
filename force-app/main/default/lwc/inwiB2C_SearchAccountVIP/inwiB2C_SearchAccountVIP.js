import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_SearchAccountVIP.html';

export default class InwiB2C_SubscriptionDisplay extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();
        var accountid = '';
        var numberaccountvip = 0;
        var allaccountvip  = [];
        var allsubvip  = [];


   //     var sumofcontacts = 0;
   //     var allcontacts  = [];

    }
    @api accountid; 

    @api numberaccountvip; 
    @api allaccountvip;
    @api allsubvip;



 //   @api sumofcontacts; 
  //  @api allcontacts;
  handleCaseSelection(event) {
    const allValid = [...this.template.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);
    if (allValid) {
        alert(' Vous n êtes pas habilité à accéder à ce client VIP.  Merci de rediriger le client vers le service VIP ');
    }
  }
    
    renderedCallback() {
    }

    



}