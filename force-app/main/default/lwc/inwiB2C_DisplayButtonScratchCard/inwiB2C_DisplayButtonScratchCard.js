import { api,LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
export default class InwiB2C_DisplayButtonScratchCard extends OmniscriptBaseMixin(LightningElement) {
    @api serialnumber;
    @api operationreason;
    @api operationtype;
    _actionUtilClass;
    _ns = getNamespaceDotNotation();
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        //this.checkConditions();
    }
handleChangeStatus() {
    const params = {
        input: '{"ModifyVoucherLockValidation":{"serialNumber":"' +this.serialnumber + '","operationReason":"' +this.operationreason + '","operationType":"1"}}',
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: 'Inwi_InwiB2C_IP_ModifyVoucherLock',
        options: '{}',
    };
    this._actionUtilClass
    .executeAction(params, null, this, null, null)
    .then((response) => {
        console.log(response.result?.IPResult);
        if (response.result?.IPResult) {
            this.omniUpdateDataJson({ "ModifyVoucherLockStatus": response.result?.IPResult?.status });
            console.log('Status changed successfully');
        } else {
            console.error('Error changing status: ', response.errorMessage);
        }
    })
    .catch((error) => {
        console.error('An unexpected error occurred: ', error);
    });
}
}