import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_SearchAccount.html';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import pubsub from 'vlocity_cmt/pubsub';

//import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

//import { publish, MessageContext } from 'lightning/messageService';
//import inwiB2CupdateVlocityInteractionId__c from '@salesforce/messageChannel/vlocity_cmt_inwiB2CupdateVlocityInteractionId__c';

export default class inwiB2C_SearchAccount extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();

        var AccountId = '';
        var IdContact = '';
        var userprofile ='';
        var numbercontact = 0;
        var allcontact = [];
        var allcontactsub = [];

        var allcontactlead = [];
        var IdLead = [];

        var isLeadAuthorized=true;
        
        var isAllContactTableDisplay=false;
        var allcontactcustomer = [];
        var allcontactanonyme = [];

    }

    __phase = 'P2'

    @api allcontactsub;

    @api allcontactcustomer;
    @api allcontactanonyme;

    @api AccountId ;
    @api IdContact ;

    @api numbercontact; 
    
    @api allcontactlead;
    @api IdLead;
    @api userprofile;
    @api
    get phase(){
        return this.__phase;
    }
    set phase(value){
        this.__phase = value;
    }

    get isphase2(){
        return this.__phase === 'P2';
    }

    

    // merge allcontactAnonyme and allcontactCustomer
    get allcontact(){



        var results = [];

        if(this.allcontactcustomer) {results = results.concat(this.allcontactcustomer)}

        if(this.allcontactanonyme) {results = results.concat(this.allcontactanonyme)}
       

        return results;

    }

    get isAllContactTableDisplay(){

        /*if (this.allcontact) {
                return (this.allcontact.length == 0 || ((this.allcontact.length == 1 && Object.keys(this.allcontact).length == 1  ) && this.allcontact[0].IdContact == null))? false:true ;

        }else return false;*/


        return this.allcontact.length > 0;


        


    }

    


    get isLeadAuthorized () {
        return (this.userprofile == 'Inwi POS' ? false:true );
    }






    renderedCallback() {

    }

    

    



    
   
   

    navigateToRecordPage(sObject, recordId) {

    console.log('navigateToRecordPage executed');
    
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            actionName: 'view'
        }
    });

    console.log('navigateToRecordPage end') ;

    }
    handleSubSelection(event){
        console.log('start handleSubSelection')
        var  selectedsubscription = event.target.name;
        console.log('selectedsubscription.AccountId: '+ selectedsubscription.AccountId)

        let selectedSubscription = {
            "selectedSubscription" : {
                "theId" : selectedsubscription.AccountId,
                "redirectToSubscriptionDispaly" : true
            }
        }

        this.omniUpdateDataJson(selectedSubscription);
        this.omniSaveState(selectedSubscription,true);
        this.omniNextStep();

    }


    handleAccountSelection(event) {
        
        console.log('handleAccountSelection executed') ;

        var  selectedcontact = event.target.name;
        console.log('display If');
        console.log(selectedcontact.type=='Contact');
        console.log('da');

        if(selectedcontact.Type=='Contact'){
            let selectedPersonContact = {
                "personIdAccount" : selectedcontact.AccountId,
                "personIdContact" : selectedcontact.IdContact,
                "personLastName" : selectedcontact.LastName,
                "personFirstName" : selectedcontact.FirstName, 
                "navigateTo360": "No"
            }
            this.omniUpdateDataJson(selectedPersonContact);
            this.omniSaveState(selectedPersonContact,true);

            let selectedSubscription = {
                "selectedSubscription" : {
                    "theId" : null,
                    "redirectToSubscriptionDispaly" : false
                }
            }
    
            this.omniUpdateDataJson(selectedSubscription);
            this.omniSaveState(selectedSubscription,true);
            this.omniNextStep();
    

        }
        else{

            let selectedPersonContact = {
                "personIdAccount" : selectedcontact.AccountId,
                "personIdContact" : selectedcontact.IdContact,
                "personLastName" : selectedcontact.LastName,
                "personFirstName" : selectedcontact.FirstName, 
                "navigateTo360": "Yes"
            }
            let selectedSubscription = {
                "selectedSubscription" : {
                    "theId" : null,
                    "redirectToSubscriptionDispaly" : false
                }
            }
    
            this.omniUpdateDataJson(selectedSubscription);
            this.omniSaveState(selectedSubscription,true);
            
            this.createInteraction(selectedcontact.AccountId, selectedPersonContact);
            /*this.omniUpdateDataJson(selectedPersonContact);
            this.omniSaveState(selectedPersonContact,true);
            this.omniNextStep();*/

        
            //this.navigateToRecordPage('Compte', selectedcontact.AccountId);

            console.log('handleRowAction end');
        }
        console.log(selectedcontact.AccountId);
         
      
        console.log('handleRowAction end');



    }
    handleLeadSelection(event) {
        console.log('handleRowAction executed') ;

        var  selectedcontact = event.target.name;
        
        console.log(selectedcontact.IdLead);
         
        this.navigateToRecordPage('Lead', selectedcontact.IdLead);

        console.log('handleRowAction end');



    }


    

    render() {
        

        
        return template;
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    /*@wire(MessageContext)
    messageContext;*/

    connectedCallback() {
        
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        /*Promise.all([
            loadScript(this, '/support/api/50.0/lightning/opencti_min.js')
          ]).then(() => {
            
            console.log('script loaded');
          });*/
    }

    createInteraction(accountId, selectedPersonContact){

        console.log('in createInteraction');

        var omnidata = this.omniJsonData;


        //console.log(JSON.stringify(omnidata));

        var inputApex = '{"ctiSource":"' + omnidata.ctiSource+ '","AccountId":"' + accountId + '","ctiEmailSource":"' + omnidata.ctiEmailSource+ '","ctiFacebookId":"' + omnidata.ctiFacebookId+ '","ctiTwitterId":"' + omnidata.ctiTwitterId+ '","ctiIteractionNumber":"' + omnidata.ctiIteractionNumber+ '","ctiMDN":"' +omnidata.ctiMDN + '"}';

        console.log(inputApex);
        
        const params = {
            input: inputApex,
            sClassName: 'inwiB2C_CustomerInteractionMgtOS',
            sMethodName: 'createInteraction',
            options: '{}',
        };

        console.log('before call apex1');
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log(JSON.stringify(response));
                if (response) {
                    console.log('response :' + response);

                    if (response.result && response.result.vlocityInteractionId) {
                        selectedPersonContact.vlocityInteractionId = response.result.vlocityInteractionId;

                        console.log('in fire');

                        pubsub.fire("Notify", "interactionChange", {
                            name: "Notify",
                            value: {interaction: response.result.vlocityInteractionId}
                        });
                    }


                    this.omniUpdateDataJson(selectedPersonContact);
                    this.omniSaveState(selectedPersonContact,true);
                    this.omniNextStep();

                }else {
                    console.log('Erreur lors de la création de l\'interaction');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la création de l\'interaction',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }

}