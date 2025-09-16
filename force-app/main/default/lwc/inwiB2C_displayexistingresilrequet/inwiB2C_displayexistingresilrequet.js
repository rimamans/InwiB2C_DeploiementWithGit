import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_displayexistingresilrequet.html';

export default class InwiB2C_displayexistingresilrequet extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
  
    __allrequests;
    selectedsubscriptionmdn;
    selectedsubstatus;
    selectedsubscriptionprofile;
    //canal;
    @track displaydossiercomplet;
    dossiercomplet;
    @api numeromdn;
    @api profilecom;
    @api id;
    @api
    get allrequests (){
        return this.__allrequests;
    }
    set allrequests(value){
        this.__allrequests = value;
    }
    @api
    get selectedsubscriptionmdn (){
        return this.__selectedsubscriptionmdn;
    }
    set selectedsubscriptionmdn(value){
        this.__selectedsubscriptionmdn = value;
    }

    @api
    get selectedsubstatus (){
        return this.__selectedsubstatus;
    }
    set selectedsubstatus(value){
        this.__selectedsubstatus = value;
    }

    @api
    get selectedsubscriptionprofile (){
        return this.__selectedsubscriptionprofile;
    }
    set selectedsubscriptionprofile(value){
        this.__selectedsubscriptionprofile = value;
    }

   /* @api
    get canal (){
        return this.__canal;
    }
    set canal(value){
        this.__canal = value;
    }*/
    id;
    connectedCallback() {
        
    }
    
    renderedCallback() {
    }

    get options() {
        return [
            { label: 'Oui', value: 'Oui' },
            { label: 'Non', value: 'Non' }
        ];
    }

    render() {
        return template;
    }

    onsendsmsresil(){
        console.log(this.numeromdn);        
        let sender = "220";
        let receiver = this.numeromdn;
        let message = this.messagesms;
        console.log('message '+message);
        let input1='{ "content":"'+message+'", "sender": {"phoneNumber":"'+sender+'"}, "receiver": [{"phoneNumber":"'+receiver+'"}]}';       
        console.log(JSON.parse(JSON.stringify(input1))) ;

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
    }
    Updatedemanderesiliation(){

        let input2 = '{"id":"'+id+'","statutresil":"'+this.statutresil+'","statutretention":"'+this.statutretention+'"}';
        const params = {
            input: input2,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_InwiB2C_UpdateDemandeResiliation',
            options: '{}'
        };
    }
    
    /*handleChange(event){
        this.dossiercomplet = event.detail.value;
        if(this.dossiercomplet == 'Non'){
            this.displaydossiercomplet = true;
            this.statutresil == 'En cours';
            this.statutretention == 'Non Retenu';
            this.messagesms == ' Inwi vous remercie pour votre fidélité, prière de passer à votre boutique afin de finaliser votre demande';
            this.Updatedemanderesiliation();
            this.onsendsmsresil();
        }else{
            this.displaydossiercomplet = false;
            this.statutresil == 'En attente de résiliation';
            this.statutretention == 'Non Retenu';
            this.messagesms == 'Cher client(e), votre ligne sera résiliée dans'+ X +'jours';
            this.Updatedemanderesiliation();
            this.onsendsmsresil();
        }
    }*/
   

}