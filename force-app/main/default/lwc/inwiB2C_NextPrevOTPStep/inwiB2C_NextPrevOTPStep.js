import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class inwiB2C_NextPrevStep extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
 
    
    
@api resiliation 
@api
   
    get otpok (){
        return this.__OTPOk;
    }



    set otpok(value){
        this.__OTPOk= value;
    }


    get disableButton(){
    return !(this.__OTPOk);
    
    }   

    

    // showNotificationValide() {
    //     const evt = new ShowToastEvent({
    //         title: 'Validé',
    //         message: 'Code OTP validé',
    //         variant: 'Success',
    //         mode: 'dismissable'
    //     });
    //     this.dispatchEvent(evt);
    // }
    
    gotonextStep(){
        if (this.otpok==true){

            
       
            this.omniNextStep();
        }
        else if (this.otpok==false){
            alert("Erreur: Code OTP invalide !");
        }
    }   
    gotopreviousStep(){
        this.omniPrevStep();
    }
    



}