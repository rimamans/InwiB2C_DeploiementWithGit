import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_SubscriptionDisplayV2.html';

export default class InwiB2C_SubscriptionDisplayV2 extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();
        var accountid = '';
        var numberofsubscriptions = 0;
        var allsubscriptions  = [];

   //     var sumofcontacts = 0;
   //     var allcontacts  = [];

    }
    @api accountid; 

    @api numberofsubscriptions; 
    @api allsubscriptions;

 //   @api sumofcontacts; 
  //  @api allcontacts;

    
    renderedCallback() {
    }

    handleSelectedSubscription(event) {
        console.log('handleSelectedSubscription');
        
        console.log('idsub: ' + event.target.dataset.idsub);
        console.log('accountnumber: ' + event.target.dataset.accountnumber);
        console.log('idprofileoffre: ' + event.target.dataset.idprofileoffre);
        console.log('selectedsubstatus: ' + event.target.dataset.selectedsubstatus);

        
//        let selectedSubscriptionMdn = { "selectedSubscriptionMdn" : event.target.dataset.mdn}
//        let selectedSubscriptionAccountNumber = { "selectedSubscriptionAccountNumber" : event.target.dataset.accountnumber}
        let selectedSubscription = { 
            "selectedSubscriptionId" : event.target.dataset.idsub,
            "selectedSubscriptionMdn" : event.target.dataset.mdn,
            "selectedSubsidprofileoffre" : event.target.dataset.idprofileoffre,
            "selectedSubStatus" : ((event.target.dataset.selectedsubstatus == undefined  )  ? 'undef' : event.target.dataset.selectedsubstatus),
            "selectedSubscriptionAccountNumber" : event.target.dataset.accountnumber,
            "selectedSubscriptionprofile" : event.target.dataset.profile
        }
        this.omniUpdateDataJson(selectedSubscription);
        this.omniSaveState(selectedSubscription,true);

        let selectedPersonContact = {
            "personContactId" : event.target.dataset.personcontacid,
            "personContactName" : event.target.dataset.personcontacname
        }
        this.omniUpdateDataJson(selectedPersonContact);
        this.omniSaveState(selectedPersonContact,true);

        console.log('end handleSelectedSubscription');

        //this.omniNextStep();
    }

    render() {

       /* if(this.numberofsubscriptions == 1){
            
        let selectedSubscription = { 
            "selectedSubscriptionId" : this.allsubscriptions[0].IdSubscription,
            "selectedSubscriptionMdn" : this.allsubscriptions[0].MDN,
            "selectedSubsidprofileoffre" : this.allsubscriptions[0].Offre,
            "selectedSubStatus" : ((this.allsubscriptions[0].Status == undefined  )  ? 'undef' : this.allsubscriptions[0].Status),
            "selectedSubscriptionAccountNumber" : this.allsubscriptions[0].AccountNumber,
            "selectedSubscriptionprofile" : this.allsubscriptions[0].profile
        }
        this.omniUpdateDataJson(selectedSubscription);
        this.omniSaveState(selectedSubscription,true);

        let selectedPersonContact = {
            "personContactId" : this.allsubscriptions[0].PersonContactID,
            "personContactName" : this.allsubscriptions[0].PersonContactName
        }
        this.omniUpdateDataJson(selectedPersonContact);
        this.omniSaveState(selectedPersonContact,true);
        this.omniNextStep();   
    }*/

    //else if (this.numberofsubscriptions > 1)
    //{
        for( var i = 0; i < this.allsubscriptions.length; i++){ 

            if ( this.allsubscriptions[i].Status === 'EXPIRED' ) { 
                this.allsubscriptions.splice(i, 1); 
                i--;
            }
        
        }

   //}
        return template;
    }
   

}