import { LightningElement, api, track ,wire} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_CodeAuthentification extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api numeromdn;
    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    @track code;
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }
    onchangecode(event){
        this.code = event.target.value;
    }
    onsendsms(){
        console.log(this.numeromdn)  ;
        const params = {
            input: '{}',
            sClassName: 'InwiB2C_CodeAuthentification',
            sMethodName: 'AddPWDAuthentification',
            options: '{"Mdn": "'+this.numeromdn+'" }',
        };
   
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('Success new code generated successfully');  
                console.log(response.result.password) ;
                let sender = "212663208406";
                let receiver=this.numeromdn;

                let message = 'Cher(e) client(e), Votre mot de pass est le : '+response.result.password+' . Le service client inwi.';
                let body='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}] }';
                            //call the send sms api
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
                                            message: 'le message qui contient le mot de pass a bien été envoyé au client',
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

            })
            .catch(error => {
                window.console.log(error);
            });
    }
    onverify(){
        console.log(this.numeromdn)  ;
        console.log(this.code)  ;
        const params2 = {
            input: '{}',
            sClassName: 'InwiB2C_CodeAuthentification',
            sMethodName: 'verify',
            options: '{"Mdn": "'+this.numeromdn+'","code":"'+this.code+'" }',
        };
   
        this._actionUtilClass
            .executeAction(params2, null, this, null, null)
            .then(response => {
                console.log('Success verification in progress');  
                console.log(response) ;
                console.log(response.result.verification) ;
                if (response.result.verification===true)
                {
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'success',
                        message: 'le client a bien été authentifié ',
                        variant: 'success'
                        }),
                    );
                    this.omniNextStep();
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Le mot de pass est erroné',
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