import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_SearchActor.html';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_SearchActor extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api cin;
    @api contactNumber;

    handleVisibilityNextButton() {
        try {
            let searchButton = this.template.querySelector(`[data-theid="searche"]`);

            let cin = this.template.querySelector(`[data-theid="CIN"]`).value;
            let contactValue = this.template.querySelector(`[data-theid="ContactNumber"]`).value;

            // Conditions: Either CIN is filled or Contact Number 
            let case1 = cin !== '' && cin.length > 0;
            let case2 = contactValue !== '' && contactValue.length > 0;

            if (case1 || case2) {
                searchButton.style.display = "block";
            } else {
                searchButton.style.display = "none";
            }

            let saveObj = {
                "IsExecuteSearchCIN": case1,
                "IsExecuteSearchContact": case2
            };
            this.omniUpdateDataJson(saveObj);
           this.omniSaveState(saveObj, true);

        } catch (error) {
            console.log('error: ' + error);
        }
    }

    handleCINChange(e) {
        this.handleVisibilityNextButton();
        let cinInput = this.template.querySelector(`[data-theid="CIN"]`);
        cinInput.value = cinInput.value.replace(/ /g, ""); // Remove spaces
        let saveObj = {
            "cin": cinInput.value
        };
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleContactChange(e) {
        this.handleVisibilityNextButton();
        let saveObj = {
            "contactNumber": e.detail.value
        };
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleSearch(e) {
        this.omniNextStep();
    }

    render() {
        return template;
    }
}