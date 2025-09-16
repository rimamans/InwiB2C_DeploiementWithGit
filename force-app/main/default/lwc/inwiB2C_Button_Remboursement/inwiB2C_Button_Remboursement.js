import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_Button_Remboursement extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {


    // flage;
    
    gotonextStep(){
        this.omniNextStep();
    }

    // goonnextRetention(){
    //     this.omniNextStep();
    //     this.flage = "Retention"
    //     this.omniUpdateDataJson({ "flage":this.flage });
    // }
}