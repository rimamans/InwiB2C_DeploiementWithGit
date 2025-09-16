import { LightningElement, api,  track } from 'lwc';
import pubsub from 'vlocity_cmt/pubsub';

import template from './inwiB2C_GetInteractionInformation.html';

import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_GetInteractionInformation extends OmniscriptBaseMixin(NavigationMixin(LightningElement))  {

    @track
    _interaction;

    @api ctiIteractionNumber;
    @api ctiSource;
    @api ctiEmailSource;
    @api ctiFacebookId;
    @api ctiTwitterId;
    @api ctiMDN;
    @api accountid;
    

    

    @api
    get interaction (){
        return this._interaction;
    }
    set interaction (value){
        this._interaction = value;

        
        /*let myInteraction = {
            "vlocityInteraction": value
        }

        console.log('in Set Interaction');

        console.log(JSON.stringify(myInteraction));
        console.log(this);
        console.log(this.omniUpdateDataJson);

        //let vlocityInteractionId = interaction;
        this.omniUpdateDataJson(myInteraction);
        this.omniSaveState(myInteraction,true);*/
    }


    connectedCallback() {
        
        pubsub.register("ReceiveInteractionNumber", {
            returnInteractionNumber: this.handleVlocityInteractionMessage.bind(this),
        });

        pubsub.fire("ReceiveInteractionNumber", "getInteractionNumber", {
            name: "ReceiveInteractionNumber"
        });

    }


    handleVlocityInteractionMessage(data){
        console.log('in handleVlocityInteractionMessage');
        console.log(data);
        console.log(data.value);
        console.log(data.value.interaction);
        
        //console.log(this);
        if (data.value && data.value.interaction){

            this.interaction = data.value.interaction;
            this.ctiIteractionNumber = data.value.ctiIteractionNumber;
            this.ctiSource = data.value.ctiSource;
            this.ctiEmailSource = data.value.ctiEmailSource;
            this.ctiFacebookId = data.value.ctiFacebookId;
            this.ctiTwitterId = data.value.ctiTwitterId;
            this.ctiMDN = data.value.ctiMDN;
            this.accountid = data.value.accountid;

            let myInteraction = {
                "vlocityInteraction": this.interaction,
                "ctiIteractionNumber_int" : this.ctiIteractionNumber,
                "ctiSource_int" : this.ctiSource,
                "ctiEmailSource_int" : this.ctiEmailSource,
                "ctiFacebookId_int" : this.ctiFacebookId,
                "ctiTwitterId_int" : this.ctiTwitterId,
                "ctiMDN_int" : this.ctiMDN,
                "accountid" : this.accountid
            }
    
            console.log(JSON.stringify(myInteraction));
            
            //let vlocityInteractionId = interaction;
            this.omniUpdateDataJson(myInteraction);
            this.omniSaveState(myInteraction,true);

            
        }
       
    }

    handleClick(){

        var ctiIteractionNumber = this.ctiIteractionNumber?this.ctiIteractionNumber:null;
        var ctiSource = this.ctiSource?this.ctiSource:null;
        var ctiEmailSource = this.ctiEmailSource?this.ctiEmailSource:null;
        var ctiFacebookId = this.ctiFacebookId?this.ctiFacebookId:null;
        var ctiTwitterId = this.ctiTwitterId?this.ctiTwitterId:null;
        var ctiMDN = this.ctiMDN?this.ctiMDN:null;
        var accountid = this.accountid?this.accountid:null;
        var interaction = this.interaction?this.interaction:null

        var URL = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:inwi360UpdateInteractionFrench&c__layout=lightning&c__tabIcon=utility:missed_call&c__tabLabel=Interaction&c__ctiIteractionNumber=' + ctiIteractionNumber + '&c__ctiSource=' + ctiSource + '&c__ctiEmailSource=' + ctiEmailSource + '&c__ctiFacebookId=' + ctiFacebookId + '&c__ctiTwitterId=' + ctiTwitterId + '&c__vlocityInteractionId=' + interaction + '&c__ctiMDN=' + ctiMDN + '&c__accountid=' + accountid;


        console.log('navigateToRecordPage executed');
    
        this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: URL
                }
            },
            true // Replaces the current page in your browser history with the URL
        );

    }

    render() {

        
        return template;
    }


}