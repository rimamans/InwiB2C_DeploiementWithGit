import { api,LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_RetryButton extends OmniscriptBaseMixin(LightningElement) {
    _actionUtilClass;
    _ns = getNamespaceDotNotation();
@api vipinput;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }

    retryButton(){
        const params = {
            input: this.vipinput,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'Inwi_InwiB2C_CreateCustomerLegacy',
            options: "{}",
        };

       this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("reponse 1", response);
                if (response.result && response.error == false && response.result?.IPResult?.boID ){
                    let data = {
                        "boID": response.result.IPResult.boID
                    }
                    this.omniUpdateDataJson(data);
                    this.omniPrevStep();
                }
            
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });
    }
   
    
}