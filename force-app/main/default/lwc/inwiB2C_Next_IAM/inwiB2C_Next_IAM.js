import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class inwiB2C_Next_IAM extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    

    gotonextStep(){
        this.omniNextStep();
    }
    gotoDemandeIAM(){
    }

}