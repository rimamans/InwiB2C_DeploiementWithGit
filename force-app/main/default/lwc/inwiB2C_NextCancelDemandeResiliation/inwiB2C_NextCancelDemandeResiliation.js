import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_NextCancelDemandeResiliation extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    gotocancelStep() {

        let selectedStep = {
            "steplabel": "CancelStep"
        }
        this.omniApplyCallResp(selectedStep);
        this.omniNextStep();
    }

}