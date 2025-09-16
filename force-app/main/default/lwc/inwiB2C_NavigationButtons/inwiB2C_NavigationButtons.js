import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_NavigationButtons extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {


    @track inputValue;

    
    // @api displaybutton = 'false';
    // @api
    // set displaybutton(value) {
    //   this.__displaybutton = value ;
    // }
    // get displaybutton() {
    //   return this.__displaybutton;
    // }

   
    
    connectedCallback() {
        // Ajoutez l'écouteur d'événement lors de la connexion du composant
        console.log('Connected callback called');
        window.addEventListener('inputvaluechange', this.handleInputValueChange.bind(this), false);
    }
    
    handleInputValueChange(event) {
        console.log('Agence Selected Event:', event);
        console.log('Is Agence Selected:', event.detail.inputValue);
        this.inputValue = event.detail.inputValue;
        console.log('Display Button:', this.inputValue);
    }
    @api
    get isPreviousDisabled() {
        // Ajoutez votre logique pour déterminer si le bouton "Précédent" doit être désactivé
        return false;
    }

   

    handlePrevious() {
    
            this.omniPrevStep();
        }
    

    
     handleNext() {
        this.omniNextStep();
  
}
}