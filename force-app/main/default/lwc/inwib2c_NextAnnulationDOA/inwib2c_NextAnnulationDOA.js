import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class Inwib2c_NextAnnulationDOA extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    connectedCallback() {
    this.omniUpdateDataJson({ ISDOA: false });
console.log('ISDOA CALLBACK', this.omniJsonData.ISDOA);}

    gotonextStep() {

        // Mise à jour du Data avec ISDOA = true
        this.omniUpdateDataJson({ ISDOA: true });
        console.log('ISDOA gotonextStep', this.omniJsonData.ISDOA); 
        // Aller à l'étape suivante
        this.omniNextStep();
    }
}