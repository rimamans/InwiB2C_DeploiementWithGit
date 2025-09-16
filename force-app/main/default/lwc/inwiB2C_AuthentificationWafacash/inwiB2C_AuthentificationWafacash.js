import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

//import template from './inwiB2C_AuthentificationWafacash.html';
export default class InwiB2C_AuthentificationWafacash extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api cinvalide; 
    @track cinsaisi = '';
    @track message = '';

    // Récupère la valeur saisie
    handleInputChange(event) {
        this.cinsaisi = event.target.value;
    }

    // Vérifie la correspondance
    handleVerify() {
        console.log('cinSaisi:', this.cinsaisi);
        console.log('cinValide:', this.cinvalide);
        if (!this.cinsaisi) {
            this.message = 'Veuillez saisir un CIN.';
        } else if (this.cinsaisi == this.cinvalide) {
             this.omniNextStep();
           
             } else {
            this.message = 'CIN incorrect. Veuillez réessayer';
        }
    }
}