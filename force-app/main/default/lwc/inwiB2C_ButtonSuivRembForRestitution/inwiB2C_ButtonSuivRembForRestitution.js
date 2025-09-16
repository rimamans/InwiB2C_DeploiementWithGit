import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_ButtonSuivRembForRestitution.html';

export default class InwiB2C_ButtonSuivRembForRestitution extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api isok;

    gotonextStep(){
        this.omniNextStep();
    }

    connectedCallback(){

        console.log("isok"+this.isok);
        }
            render() {
                return template;
           
            }
}