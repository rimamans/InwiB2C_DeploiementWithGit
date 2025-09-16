import { LightningElement, api, track ,wire} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import template from './inwiB2C_CancelResilRequest.html';

export default class InwiB2C_CancelResilRequest extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api numeromdn;
    //@api messagesms;
    @api idrequesttocancel;
    @api subscriptionid;
    @api recordId;
    @api title;
    @api iconName;
    @api resiliation;
   // @api contactersavedesk;
    secret='12345';
    code;
    counter2 = 0;
    refreshCounter;
    counter=1;
    __OTPOk;
    @track loaded=false;
    @track disabled=false;
    @track verifDisabled=true;

    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    __retenuFlag=false;
    //__displaySave=false;
    __message; 
    messageNotif="";

    @api
    get message (){
        return this.__message;
    }
    set message(value){
        this.__message = value;
    }
    @api
   
    get OTPOk (){
        return this.__OTPOk;
    }
    set OTPOk(value){
        this.__OTPOk = value;
    }
    /*@api
    get displaySave (){
        return this.__displaySave;
    }
    set displaySave(value){
        this.__displaySave = value;
    }*/
    @api
    get retenuFlag (){
        return this.__retenuFlag;
    }
    set retenuFlag(value){
        this.__retenuFlag = value;
    }
    @api
   
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('otp'+this.__OTPOk);
        console.log('code'+this.code);
        }
    
    handleMotifAnnul(event){
        this.motifcancel = event.target.value;
        console.log('this.motifcancel'+ event.target.value);
        if(event.target.value == null || event.target.value == ''){
           this.retenuFlag= false;
           //this.displaySave=false;
        }
        else
            this.retenuFlag= true;
     }

     

    onsendsmsresil(){ 
        //this.messageNotif="Cher client, inwi vous informe que votre demande de résiliation est bien annulée, merci pour votre fidélité."
        // Meryem Yahya MGEN3645SF_SMS Résiliation
        this.messageNotif = "inwi : nous vous informons que votre demande de résiliation a bien été annulée. Merci pour votre fidélité."
        // Meryem Yahya MGEN3645SF_SMS Résiliation
        let input1='{ "content":"'+this.messageNotif+'", "sender": {"phoneNumber":"220"}, "receiver": [{"phoneNumber":"'+this.numeromdn+'"}],"requestId":"'+this.idrequesttocancel+'","subscId":"'+this.subscriptionid+'"}';
        console.log('requete send SMS '+this.input1);
        console.log(JSON.parse(JSON.stringify(input1))) ;

        const params1 = {
            input: input1,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_SendSMS_Resil',
            options: '{}'
        };

         this._actionUtilClass
            .executeAction(params1, null, this, null, null)
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

    callvipsaveStep(){
      
        let input='{"idrequesttocancel":"'+this.idrequesttocancel+'","subscriptionid":"'+this.subscriptionid+'" ,"motifcancel":"'+this.motifcancel+'"}';
        console.log(JSON.parse(JSON.stringify(input))) ;

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_CancelResilRequest',
            options: '{}'
        };
        //CHB 19/07/2023 rendre cancel request asynchrone 
      /*  const params = {
            input: input,
            sClassName: 'inwiB2C_AsynchUpdateResiliation',
            sMethodName: 'CancelRequest',
            options: '{}',
        }*/
         this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                 console.log('Request cancelled successfully');  
                 console.log(response) ;
                 if (response.error===false)
                 {
                    this.onsendsmsresil(); 
                    this.dispatchEvent(
                        new ShowToastEvent({
                         title: 'success',
                        message: 'Cette demande a été annulée',
                        variant: 'success'
                        }),
                    );
                        
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

                  

    }

    Updatedemanderesiliation(){

        let input2 ='{"idrequesttocancel":"'+idrequesttocancel+'","subscriptionid":"'+subscriptionid+'" ,"motifcancel":"'+this.motifcancel+'"}';
        const params = {
            input: input2,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_UpdateDemandeResilInCancelDemande',
            options: '{}'
        };
    }
    gotonextStep(){
        console.log("next")  ;
        let selectedStep = {
            "steplabel" : "EndStep"
            }        
            this.omniApplyCallResp(selectedStep);
            this.callvipsaveStep();
            this.omniNextStep();
    }

    gotopreviousStep() {
        this.omniPrevStep();
    }
    render() {
        return template;
    }
    /*handlecustomotpvaluechange(event){
        event.stopPropagation();
        console.log(JSON.stringify(event.detail));
        this.OTPOk =  event.detail.OTPOk;
        this.displaySave =  event.detail.OTPOk;
        
       }*/
       getotpfromchildtoResilRequest(event){
        //event.stopPropagation();
        let detail = event.detail;
        console.log('detail event : ' + JSON.stringify(detail));
        this.__OTPOk =  detail.otpOK;
        console.log("otpok"+this.__OTPOk);
        this.verifDisabled = !detail.otpOK;
       }   
}