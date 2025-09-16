import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_Bouton_Valider_remb extends OmniscriptBaseMixin(NavigationMixin(LightningElement))  {

    handleCheckboxChange(event) {
        const selectedOption = event.target.value;
        if (selectedOption === 'rembourser') {
            this.rembourser();
        } else {
            this.suivant();
        }
    }

    rembourser() {
        let NoRefund = { NoRefund : false } 
        this.omniUpdateDataJson(NoRefund);
        this.omniSaveState(NoRefund, true);
        this.omniNextStep();
    }

    suivant() {
        let NoRefund = { NoRefund : true } 
        this.omniUpdateDataJson(NoRefund);
        this.omniSaveState(NoRefund, true);
        this.omniNextStep();
    }

}