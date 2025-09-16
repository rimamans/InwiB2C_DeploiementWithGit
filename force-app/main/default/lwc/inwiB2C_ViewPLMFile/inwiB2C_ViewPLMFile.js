import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_ViewPLMFile extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api documentid;
    @track data = [];
    _actionUtilClass;
    
    @track columns = [
        { label: 'Document Id', fieldName: 'DocumentId', type: 'text', hideDefaultActions: true },
        { label: 'Code Article', fieldName: 'CodeArticle', type: 'text', hideDefaultActions: true },
        { label: 'Start Date', fieldName: 'StartDate', type: 'date', hideDefaultActions: true },
        { label: 'End Date', fieldName: 'EndDate', type: 'date', hideDefaultActions: true },
        { label: 'Price', fieldName: 'Price', type: 'currency', hideDefaultActions: true },
        { label: 'Canal', fieldName: 'Canal', type: 'text', hideDefaultActions: true },
        { label: 'Status', fieldName: 'Status', type: 'text', hideDefaultActions: true },
        { label: 'Message', fieldName: 'Message', type: 'text', hideDefaultActions: true }
    ];
    

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.fetchData();        
    }

    fetchData() {
        console.log('Fetching data for documentId:', this.documentid);
        
        let input = {
            "documentId": this.documentid
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: 'inwiB2C_PLMFileHandler',
            sMethodName: 'getRecordsByDocumentId',
            options: '{}',
        };

        this._actionUtilClass.executeAction(params, null, this, null, null)
            .then(response => {
                if (response && response.result && response.result.List) {
                    this.data = response.result.List;
                    this.omniApplyCallResp({ 'operation':'resilok' });
                } else {
                    console.warn('No data returned or empty response');
                }
            })
            .catch(error => {
                console.error('Error fetching records: ', error);
                this.showToast('Erreur', 'Une erreur est survenue lors de la récupération des données', 'error');
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
}