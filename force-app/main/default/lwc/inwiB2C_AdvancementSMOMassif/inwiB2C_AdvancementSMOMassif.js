import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class inwiB2C_AdvancementSMOMassif extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
   
   @api documentid;
  
    showButtonNext=false;
    _actionUtilClass;
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }

    actualise(){
        console.log("actualise");
        //this.isLoading = true;
        const params = {
            input: JSON.stringify({ documentId: this.documentid }),
            sClassName: 'inwiB2C_CFDataController',
            sMethodName: 'checkProcessBatch',
            options: '{}',
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then((response) => {
                console.log("response.result",response.result.result);
                //this.isLoading = false;
                if (response && response.result) {
                    this.showButtonNext = response.result.result;
                    console.log("response.result",response.result.result);
            }})
            .catch((error) => {
               // this.isLoading = false;
                console.error('Error fetching data: ', JSON.stringify(error));
                this.showToast('Error', 'An error occurred while fetching data.', 'error');
            });
    }
    next() {
        this.omniNextStep();
    }
   }