import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class inwiB2C_DisplayChFC extends OmniscriptBaseMixin(LightningElement) {
    @api documentid;
    @track allsubscriptions = [];
    @track isLoading = false;
    @track selectedRows = [];
    _actionUtilClass;

    columns = [
        { label: 'Compte de Facturation', fieldName: 'CompteFacturation' },
        { label: 'MDN', fieldName: 'MDN' },
        { label: 'Offre', fieldName: 'Offre' },
        { label: 'Statut', fieldName: 'Statut' },
        { label: 'Date de Création', fieldName: 'DateCreation', type: 'date' },
       // { label: 'Id Treatment', fieldName: 'IdTreatment', type: 'text' }
    ];

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
     /*   if (this.documentid) {
            this.fetchSubscriptions();
        } else {
            this.showToast('Warning', 'Document ID is not provided.', 'warning');
        }*/
    }
    actualise(){
        if (this.documentid) {
            this.fetchSubscriptions();
        } else {
            this.showToast('Warning', 'Document ID is not provided.', 'warning');
        }
    }
    fetchSubscriptions() {
        this.isLoading = true;
        const params = {
            input: JSON.stringify({ documentId: this.documentid }),
            sClassName: 'inwiB2C_CFDataController',
            sMethodName: 'getDataByDocumentId',
            options: '{}',
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then((response) => {
                this.isLoading = false;
                if (response && response.result && response.result.List) {
                    this.allsubscriptions = response.result.List;
                    console.log('Fetched Data: ', JSON.stringify(this.allsubscriptions));
                    if (this.allsubscriptions.length === 0) {
                        this.showToast('Info', 'No records found for the given Document ID.', 'info');
                    }
                } else {
                    this.showToast('Info', 'No data found for the given Document ID.', 'info');
                }
            })
            .catch((error) => {
                this.isLoading = false;
                console.error('Error fetching data: ', JSON.stringify(error));
                this.showToast('Error', 'An error occurred while fetching data.', 'error');
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(`Action: ${actionName}, Row Data:`, JSON.stringify(row));

        if (actionName === 'select') {
            this.omniUpdateDataJson({ selectedSubscription: row });
            this.omniSaveState({ selectedSubscription: row }, true);
        }
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows.map(row => row.IdTreatment);
        console.log('Selected Treatment Row IDs:', JSON.stringify(this.selectedRows));

        this.omniApplyCallResp({ selectedRows: this.selectedRows });
    }

    handlePublishButtonClick() {
        if (this.selectedRows.length === 0) {
            this.showToast('Warning', 'Please select at least one row.', 'warning');
            return;
        }

        this.isLoading = true;
        const params = {
            input: JSON.stringify({ selectedRowIds: this.selectedRows, contentDocumentId: this.documentid }),
            sClassName: 'inwiB2C_CFDataController',
            sMethodName: 'processSelectedRows',
            options: '{}',
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then((response) => {
                this.isLoading = false;
                this.showToast('Success', 'Selected rows processed successfully.', 'success');
                console.log('Process Response: ', JSON.stringify(response));
                this.next();
            })
            .catch((error) => {
                this.isLoading = false;
                console.error('Error processing selected rows: ', JSON.stringify(error));
                this.showToast('Error', 'An error occurred while processing the rows.', 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            })
        );
    }
    next(){
        this.omniNextStep();
    }
}