import { LightningElement, api, track ,wire} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_ResilSms extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api numeromdn;
    @api messagesms;
    _ns = getNamespaceDotNotation();
    _actionUtilClass;
  
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }
    
    gotopreviousStep() {
        this.omniPrevStep();
    }
    
    gotonextStep(){
        console.log(this.numeromdn)  ;
        
        let sender = "220";
        let receiver=this.numeromdn;
        let message = this.messagesms;
        console.log('message '+message);
        let body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
        console.log(JSON.parse(JSON.stringify(body))) ;

        const params1 = {
            input: JSON.parse(JSON.stringify(body)),
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwib2c_InwiB2C_SendPassWordSMS',
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

        this.omniNextStep();
    }
    
}