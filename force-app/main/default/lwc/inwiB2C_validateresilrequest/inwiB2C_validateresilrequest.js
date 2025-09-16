import { LightningElement, api} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_validateresilrequest extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api numeromdn;
    @api messagesms;
    @api idrequesttoresil;
    @api dossiercompletcond;
    //@api signaturedate;
    @api isfromsubscription;
    @api isfromaccount;
    __restartresil;
    @api subscriptionid;
    @api demandeid;
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    @api
   get restartresil (){
       return this.__restartresil;
   }
   set restartresil(value){
       this.__restartresil = value;
   }
   /*@api
    get subscriptionid (){
        return this.__subscriptionid;
    }
    set subscriptionid(value){
        this.__subscriptionid = value;
    }
    @api
    get demandeid (){
        return this.__demandeid;
    }
    set demandeid(value){
        this.__demandeid = value;
    }*/
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }
    
    
    onsendsmsresil(){
        let input1='{ "content":"'+this.messagesms+'", "sender": {"phoneNumber":"220"}, "receiver": [{"phoneNumber":"'+this.numeromdn+'"}]}';
        const params1 = {
            input: input1,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_SendPassWordSMS',
            options: '{}'
        };
         this._actionUtilClass
            .executeAction(params1, null, this, null, null)
            .then(response => {
                 console.log('Success message sent successfully');  
                 console.log(response);
                 if (response.error===false)
                 {
                    this.dispatchEvent(
                        new ShowToastEvent({
                         title: 'success',
                        message: 'Le message a bien été envoyé au client',
                        variant: 'success'
                        }),
                    );
                  }else{
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

        //this.omniNextStep();
    }
  /*  Updateafterjustificatifs(){
        console.log('Success messsssage sent successfully');  
        console.log('subscriptionid'+subscId);
        console.log('demandeid'+demandeId);  
        let subscId = this.subscriptionid;
        let demandeId = this.demandeid;
        let input2 = '{"id":"'+subscId+'","idemande":"'+demandeId+'"}';
        const params = {
            input: input2,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_UpdateInResiliation',
            options: '{}'
        };
    }*/
    Updateafterjustificatifs(){
            console.log('in Updateafterjustificatifs');
             this._actionUtilClass = new OmniscriptActionCommonUtil();
            let input ='{"SubscriptionId":"'+this.subscriptionid+'","idrequesttoresil":"'+this.idrequesttoresil+'"}';
             const params = {
                 input,
                 sClassName: `${this._ns}IntegrationProcedureService`,
                 sMethodName: "inwib2c_InwiB2C_UpdateInResiliation",
                 options: "{}"
             };
             this._actionUtilClass
             .executeAction(params, null, this, null, null)
             .then(response => {
                 console.log('response1',response);
                 
                 if (!response.error) {
                     if (response.result.IPResult) {                 
                                console.log('reponseOK');       
                        }
                     } 
                     else {
                      console.log('error');     
                     }
                 }
             )
             .catch(error => {
                 window.console.log(error);            
             });     
           }
        /*this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                 console.log('Success message sent successfully');  
                 console.log(response) ;
                 if (response.error===false)
                 {
                    this.dispatchEvent(
                        new ShowToastEvent({
                         title: 'success',
                        message: 'Le message a bien été envoyé au client',
                        variant: 'success'
                        }),
                    ); 
                  }           
                 })
                .catch(error => {
                     window.console.log(error);
                    });*/
    

    gotonextStep(){
        this.onsendsmsresil();
        console.log("dossiercomplet = : "+this.dossiercompletcond);
        if(this.dossiercompletcond == true){
            this.Updateafterjustificatifs();
        }
        /**** 
        let idrequesttoresil = this.idrequesttoresil;
        //let signaturedate = this.signaturedate;
        //let input='{"idrequesttoresil":"'+idrequesttoresil+'","signaturedate":"'+signaturedate+'"}';
        let input='{"idrequesttoresil":"'+idrequesttoresil+'"}';
        console.log(JSON.parse(JSON.stringify(input))) ;

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_UpdateNeedApprovalResilRequest',
            options: '{}'
        };

         this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                 console.log(response) ;
                 if (response.error===false)
                 {
                    this.onsendsmsresil(); 
                        
                  }else{
                     this.dispatchEvent(
                         new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Une erreur est produite ',
                            variant: 'error'
                             }),
                    );
                  }
                            
                 })
                .catch(error => {
                     window.console.log(error);
                    });

        */
        let selectedStep = {
           "steplabel" : "ResilStep"
        }        
        this.omniApplyCallResp(selectedStep);
        this.omniNextStep();      

    }

    gotopreviousStep(){
        /*console.log(this.isfromsubscription); 
        console.log(this.isfromaccount); 
        
        if(this.isfromaccount == true){
            this.omniPrevStep();
        }
        else if (this.isfromsubscription == true){
            let selectedStep = {
                "steplabel" : "EndStep"
            }        
            this.omniApplyCallResp(selectedStep);
            this.omniNextStep();
        }*/

        this.omniPrevStep();
        
    }
}