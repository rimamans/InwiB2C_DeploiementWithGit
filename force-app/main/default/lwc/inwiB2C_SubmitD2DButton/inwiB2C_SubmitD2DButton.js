import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class InwiB2C_SubmitD2DButton extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    gotonextStep(){
        this.omniNextStep();
    }
}