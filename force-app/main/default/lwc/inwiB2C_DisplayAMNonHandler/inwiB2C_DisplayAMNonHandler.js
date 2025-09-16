import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_DisplayAMNonHandler.html';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';


//import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

//import { publish, MessageContext } from 'lightning/messageService';
//import inwiB2CupdateVlocityInteractionId__c from '@salesforce/messageChannel/vlocity_cmt_inwiB2CupdateVlocityInteractionId__c';

export default class inwiB2C_DisplayAMNonHandler extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    constructor() {
        super();

        var AccountId = '';
        var IdContact = '';
        var userprofile = '';
        var numbercontact = 0;
        var allcontact = [];
        var allcontactsub = [];

        var allcontactlead = [];
        var IdLead = [];

        var isLeadAuthorized = true;

        var isAllContactTableDisplay = false;
        var allcontactcustomer = [];
        var allcontactanonyme = [];

    }


    @api allcontactcustomer;
    @api allcontactanonyme;

    @api AccountId;
    @api IdContact;
    @api NumeroContact;
    @api numbercontact;
    @api Cin;
    @api Status;
    @api SegmentMarch;

    @api allcontactlead;
    @api IdLead;
    @api userprofile;
    @api FirstName;
    @api LastName;
    @api Adresse;
    @api Region;
    @api Ville;



    // merge allcontactAnonyme and allcontactCustomer
    get allcontact() {
        var results = [];
    
        if (this.allcontactcustomer) {
            results = this.allcontactcustomer.map(contact => {
                return {
                    ...contact,
                    Region: contact.Region ? contact.Region.replace("inwib2c_", "") : ""
                };
            });
        }
    
        return results;
    }
    

    get isAllContactTableDisplay() {

        /*if (this.allcontact) {
                return (this.allcontact.length == 0 || ((this.allcontact.length == 1 && Object.keys(this.allcontact).length == 1  ) && this.allcontact[0].IdContact == null))? false:true ;

        }else return false;*/


        return this.allcontact.length > 0;





    }
    handleAccountSelection(event) {

        console.log('handleAccountSelection executed');

        var selectedcontact = event.target.name;
       

        
        let selectedPersonContact = {
            "personIdAccount": selectedcontact.Id,
            "redirectToAccountDispaly": true,
            "navigateTo360": true
        }
        this.omniUpdateDataJson(selectedPersonContact);
        this.omniSaveState(selectedPersonContact, true);
        this.omniNextStep();
        }

 



    



    get isLeadAuthorized() {
        return (this.userprofile == 'Inwi Pos' ? false : true);
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

        console.log('navigateToRecordPage end');

    }


 




    render() {
        return template;
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {

        this._actionUtilClass = new OmniscriptActionCommonUtil();

        /*Promise.all([
            loadScript(this, '/support/api/50.0/lightning/opencti_min.js')
          ]).then(() => {
            
            console.log('script loaded');
          });*/
    }

    createInteraction(accountId, selectedPersonContact) {

        console.log('in createInteraction');

        var omnidata = this.omniJsonData;


        //console.log(JSON.stringify(omnidata));

        var inputApex = '{"ctiSource":"' + omnidata.ctiSource + '","AccountId":"' + accountId + '","ctiEmailSource":"' + omnidata.ctiEmailSource + '","ctiFacebookId":"' + omnidata.ctiFacebookId + '","ctiTwitterId":"' + omnidata.ctiTwitterId + '","ctiIteractionNumber":"' + omnidata.ctiIteractionNumber + '","ctiMDN":"' + omnidata.ctiMDN + '"}';

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
                            value: { interaction: response.result.vlocityInteractionId }
                        });
                    }


                    this.omniUpdateDataJson(selectedPersonContact);
                    this.omniSaveState(selectedPersonContact, true);
                    this.omniNextStep();

                } else {
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