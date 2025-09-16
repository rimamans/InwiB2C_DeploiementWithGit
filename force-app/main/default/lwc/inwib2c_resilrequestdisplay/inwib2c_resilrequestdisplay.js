import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from './inwib2c_resilrequestdisplay.html';

export default class inwiB2C_resilrequestdisplay extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    _ns = getNamespaceDotNotation();
    disabled = false;
    @api
    _actionUtilClass;
    __ligneid;
    __profilecom;
    __accountid;
    __labelstepcreate;
    __labelstepresil;
    __labelsteprestitution;
    __labelstepretention;
    __labelstepcancel;
    __numeromdn;
    __messagesms;
    __isfromaccount;
    __isfromsubscription;
    IdRequestCreated;
    __isftthadsl;
    eligibiliteCasSpecial = false;
    displayButtonCreateDemande;
    @api buttonterminepdv;
    @api labelstepexist;
    @api contactersavedesk;
    @api procederesil;
    @api iterminedrcrm;
    @api iiterminedrcrm;
    @api forjustificatifspdv;
    @api 
    get isfromsubscription() {
        return this.__isfromsubscription;
    }
    set isfromsubscription(value) {
        this.__isfromsubscription = value;
    }
    @api
    get isfromaccount() {
        return this.__isfromaccount;
    }
    set isfromaccount(value) {
        this.__isfromaccount = value;
    }

    @api
    get profilecom() {
        return this.__profilecom;
    }
    set profilecom(value) {
        this.__profilecom = value;
    }
    @api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }
    @api
    get numeromdn() {
        return this.__numeromdn;
    }
    set numeromdn(value) {
        this.__numeromdn = value;
    }
    @api
    get messagesms() {
        return this.__messagesms;
    }
    set messagesms(value) {
        this.__messagesms = value;
    }

    @api
    get labelstepcreate() {
        return this.__labelstepcreate;
    }
    set labelstepcreate(value) {
        this.__labelstepcreate = value;
    }
    

    @api
    get labelstepresil() {
        return this.__labelstepresil;
    }
    set labelstepresil(value) {
        this.__labelstepresil = value;
    }

    @api
    get labelsteprestitution() {
        return this.__labelsteprestitution;
    }
    set labelsteprestitution(value) {
        this.__labelsteprestitution = value;
    }

    @api
    get labelstepretention() {
        return this.__labelstepretention;
    }
    set labelstepretention(value) {
        this.__labelstepretention = value;
    }

    @api
    get ligneid() {
        return this.__ligneid;
    }
    set ligneid(value) {
        this.__ligneid = value;
    }

    @api
    get labelstepcancel() {
        return this.__labelstepcancel;
    }
    set labelstepcancel(value) {
        this.__labelstepcancel = value;
    }
    @api
    get isftthadsl() {
        return this.__isftthadsl;
    }
    set isftthadsl(value) {
        this.__isftthadsl = value;
    }

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log("Type :"+this.Type);
        //this.displayButtonCreateDemande=!this.isftthadsl;
        this.displayButtonCreateDemande=true;
    }

    handleTypeChange(event){
        this.Type = event.target.value;
        console.log("Type :"+this.Type);
        //this.displayButtonCreateDemande = false;
        if( this.Type!=null ||this.Type!= "undefined" || this.Type!=""){
            this.displayButtonCreateDemande = true;
            if(this.Type=="Cas spécial"){
                this.eligibiliteCasSpecial = true;
                this.displayButtonCreateDemande = false;
            }else{
                this.eligibiliteCasSpecial = false;
            }
        }
        if(this.Type==null ||this.Type== "undefined" || this.Type==""){
            this.displayButtonCreateDemande = false;
        }
        console.log("create demande :"+this.displayButtonCreateDemande);
    }

    handleMotifChange(event){
       
        this.Motif = event.target.value;
        if(this.Motif!=null ||this.Motif!= "undefined" || this.Motif!=""){
            this.displayButtonCreateDemande = true;
        }
        if(this.Motif==null ||this.Motif== "undefined" || this.Motif==""){
            this.displayButtonCreateDemande = false;
        }
     }

    onsendsms() {
        console.log(this.numeromdn);

        let sender = "220";
        let receiver = this.numeromdn;
        let message = this.messagesms;
        console.log('IdRequestCreated2 ' + this.IdRequestCreated);
        console.log('ligneid ' + this.ligneid);
        let requestId = this.IdRequestCreated;
        let subscId = this.ligneid;
        console.log('message ' + message);
        let body = '{ "content":"' + message + '", "sender": {"phoneNumber":"' + sender + '"}, "receiver": [{"phoneNumber":"' + receiver + '"}],"requestId":"' + requestId + '","subscId":"' + subscId + '"}';
        console.log(JSON.parse(JSON.stringify(body)));

        const params1 = {
            input: JSON.parse(JSON.stringify(body)),
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_SendSMS_Resil',
            options: '{}'
        };


        this._actionUtilClass
            .executeAction(params1, null, this, null, null)
            .then(response => {
                console.log('Success message sent successfully');
                console.log(response);
                if (response.error === false) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'success',
                            message: 'Le message a bien été envoyé au client',
                            variant: 'success'
                        }),
                    );


                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur est produite lors de la transmission du message',
                            variant: 'error'
                        }),
                    );

                }

            })
            .catch(error => {
                window.console.log(error);
            });


    }


    createnewrequest() {
        console.log(("dis1" + this.disabled));
        this.disabled = true;
        console.log(("dis2 " + this.disabled));
        let type = this.Type;
        let motif = this.Motif;
        let input = this.ligneid;
        let accountid = this.accountid;
        let profilecom = this.profilecom;
        let numeroligne = this.numeromdn;//
        // cas : cas spécial FTTH et ADSL
        if ((this.Type!= null || this.Type!= "undefined" || this.Type!="") && (this.Motif!=null ||this.Motif!= "undefined" || this.Motif!="")&& (this.isftthadsl==true))
        {
            this.Ipinput = '{ "SubscriptionId":"' + input + '","AccountId":"' + accountid + '","profilecom":"' + profilecom + '","NumeroLigne":"' + numeroligne + '","typeresil":"' + type + '","Motifresil":"' + motif + '"}';
        }
          // cas : demande suite client / déménagement FTTH et ADSL
        if((this.Motif==null ||this.Motif== "undefined" || this.Motif=="") && (this.Type!= null || this.Type!= "undefined" || this.Type!="")&& (this.isftthadsl==true))
        {
            this.Ipinput = '{ "SubscriptionId":"' + input + '","AccountId":"' + accountid + '","profilecom":"' + profilecom + '","NumeroLigne":"' + numeroligne + '","typeresil":"' + type + '"}';
        }
        // cas different FTTH et ADSL
        if(this.isftthadsl!=true)
        {
            this.Ipinput = '{ "SubscriptionId":"' + input + '","AccountId":"' + accountid + '","profilecom":"' + profilecom + '","NumeroLigne":"' + numeroligne + '"}';
        }
        console.log(("Ipinput " + this.Ipinput));
        const params = {
            input: this.Ipinput,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_VIPCreateResilRequest',
            options: '{}',
        };

        // if(this.profilecom != "Inwi POS"){
        //     this.contactersavedesktopRequest = true;
        // };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {

                console.log((response));
                if (response.error == false) {
                    if (response.result) {
                        console.log("IdRequest " + response.result.IPResult.InwiB2C_Demande_de_resiliation__c_1[0].Id);
                        this.IdRequestCreated = response.result.IPResult.InwiB2C_Demande_de_resiliation__c_1[0].Id;
                        this.onsendsms();
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'success',
                                message: ' La demande de résiliation ' + this.IdRequestCreated + ' est initiée',
                                variant: 'success'
                            }),
                        );
                        let mydata1={
                            checkrequest:true
                         }
                     
                           this.omniApplyCallResp(mydata1);
                           this.omniNavigateTo("DataRaptorExtractAllResiliationRequest");
                    }
                } else {
                    console.log(response);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la création de la demande de résiliation',
                            variant: 'error'
                        }),
                    );
                }


            })
            
    }

    gotoresilStep() {

        let selectedStep = {
            "steplabel": "ResilStep"
        }

        this.omniApplyCallResp(selectedStep);
        this.omniNextStep();
    }
/*
    gotorestitutionStep(event) {
        console.log("handle gotorestitutionStep");
        event.stopPropagation();

        try {
            this[NavigationMixin.GenerateUrl]({
                type: 'comm__namedPage',// standard__component
                attributes: {
                    //componentName: 'vlocity_cmt__vlocityLWCOmniWrapper',
                    pageName:'lwcos'
                },
                state: {
                    c__target: 'c:inwib2cRestitutionEnglish',//c:inwib2cRestitutionEnglish
                    c__layout: 'lightning', // or 'newport'
                    c__tabIcon: 'custom:custom18',
                    c__tabLabel: 'Restitution Matériel',
                    c__ContextId: this.__ligneid ,
                    c__Motifinput:'InwiB2C_Demandederésiliation'         
                }
            }) .then(generatedUrl => {
                //this.omniUpdateDataJson({ "MotifRestitution" : "Demande client"});
                //console.log("motifff"+this.omniUpdateDataJson());
                console.log(generatedUrl)
                window.open(generatedUrl);
            });
        } catch (error) {
            console.log(error)
        }

    }
    */

    gotoretentionStep() {

        let selectedStep = {
            "steplabel": "RetentionStep"
        }
        this.omniApplyCallResp(selectedStep);
        this.omniNextStep();
    }

    gotocancelStep() {

        let selectedStep = {
            "steplabel": "CancelStep"
        }
        this.omniApplyCallResp(selectedStep);
        this.omniNextStep();
    }

    gotonextStep() {
        let selectedStep = {
            "steplabel": "EndStep"
        }
        this.omniApplyCallResp(selectedStep);
        this.omniNextStep();
    }

    /* gotocreateStep(){
         let selectedStep = {
             "steplabel" : "EndStep"
         }
         this.omniApplyCallResp(selectedStep);
         this.createnewrequest();
     }*/

    gotopreviousStep() {
        if (this.isfromsubscription == true) {
            let selectedStep = {
                "steplabel": "PrevStep"
            }
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }
        else if (this.isfromaccount == true) {
            this.omniPrevStep();
        }

    }

    render() {
        return template;
    }
}