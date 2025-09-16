import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class Inwib2c_PreviousAnnulationDOA extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    goToPreviousStep() {
        this.omniUpdateDataJson({ ISDOA: false });
        this.omniPrevStep();
    }
}