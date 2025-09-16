import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_UploadHistPriceListeMasse.html';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_UploadHistPriceListeMasse extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    _actionUtilClass;
    @track documentId;
    @track filename;
    @track isValidated;
    disableChoice=false;
    typeChargement;
    @track data = [];
    @track noHistoryMessage = '';

    @track isFormat = true;
    @track valError;
    @track error;
    @track isFileUploadHidden = true;
    @track IsButtonHidden = false;
    lignes=[];
    @track dataTable= [];
    __records = [];
    @track startingRecord = 1;
    @track page = 1;
    @track endingRecord = 0;
    @track totalRecordCount = 0;
    @track totalPage= 0;
    @track pageSize = 50;
    @track initialRecords; 
    _ns = getNamespaceDotNotation();

    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
    }
    
    // Tab Historique
    columns = [
        { label: 'Nom', fieldName: 'name',hideDefaultActions: 'true'},
        { label: 'UUID', fieldName: 'uuid',hideDefaultActions: 'true'},
        { label: 'Date', fieldName: 'date',hideDefaultActions: 'true'},
        { label: 'Statut', fieldName: 'statut',hideDefaultActions: 'true',cellAttributes:{class:{fieldName:'statutColor'}}},
        {type: 'button-icon',typeAttributes:{iconName: 'action:preview',name: 'View',disabled: { fieldName: 'Disable' }},initialWidth: 40},
        {type: 'button-icon',typeAttributes:{iconName: 'action:download',name: 'export',disabled: { fieldName: 'Disable' }},initialWidth: 40},
    ];

    setInfo() {
        if (!Array.isArray(this.__records) || this.__records.length === 0) {
            this.lignes = [];
            this.dataTable = [];
            this.noHistoryMessage = 'Aucune historique d\'insertion';
            this.totalRecordCount = 0;
            this.totalPage = 0;
        } else {
            this.lignes = this.__records.map(item => {
                let statutColor = item.statut == "En attente de traitement" ? "slds-text-color_error" : "slds-text-color_success"
                return {
                    ...item, 
                    "statutColor": statutColor,
                    "ErrorColor": "slds-text-color_error"
                }
            }
        );
            
            this.totalRecordCount = this.lignes.length;
            this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
            this.dataTable = this.lignes.slice(0, this.pageSize);
            this.initialRecords = this.data;
            this.endingRecord = this.pageSize;
            this.noHistoryMessage = '';
        }
    }

    handlesClick(event) {
        const row = event.detail.row;
        const actionName = event.detail.action.name;
    
        if (actionName === 'View') {
            this.omniApplyCallResp({ 'view': true });
            this.omniApplyCallResp({ 'action': 'view' });
            this.omniApplyCallResp({ 'documentId': row.uuid });
            this.omniApplyCallResp({ 'selectedFileName': row.name });
            this.omniNextStep();
        } 
        else if (actionName === 'export') {
            console.log('Export triggered for row: ', row);
            
            let input = {
                documentId: row.uuid
            };
    
            const params = {
                input: JSON.stringify(input),
                sClassName: 'inwiB2C_PLMFileHandler',
                sMethodName: 'getRecordsByDocumentId',
                options: '{}',
            };
    
            this._actionUtilClass.executeAction(params, null, this, null, null)
                .then(response => {
                    console.log('Response: ', response);
                    if (response.result && response.result.List) {
                        let data = JSON.parse(JSON.stringify(response.result.List));
                        let csvFile = this.convertArrayToCsv(data);
                        this.createLinkForDownload(csvFile);
                    } else {
                        this.showToast('Erreur', 'Une erreur est survenue, merci de réessayer plus tard', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error exporting data: ', error);
                    this.showToast('Erreur','Une erreur est survenue lors de l\'export','error');
                });
        }
    }

    convertArrayToCsv(downloadRecords) {
        if (!downloadRecords || !downloadRecords.length) {
            return '';
        }

        const keys = Object.keys(downloadRecords[0]);
        const csvHeader = keys.join(',');

        const csvBody = downloadRecords.map(record => {
            return keys
                .map(key => {
                    let val = record[key] === null || record[key] === undefined ? '' : record[key];
                    val = String(val).replace(/"/g, '""');
                    return `"${val}"`;
                })
                .join(',');
        });

        const csvFile = csvHeader + '\n' + csvBody.join('\n');
        return csvFile;
    }

    createLinkForDownload(csvFile) {
        const anchorElement = document.createElement('a');
        anchorElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvFile);
        anchorElement.target = '_blank';
        anchorElement.download = 'ExportedPLMRecords.csv';
        anchorElement.click();
    }

    

    prevHandler(event){
        if(this.page > 1){
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
    nextHandler(event){
        if(this.page < this.totalPage && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }
    }

    displayRecordPerPage(page){
        this.startingRecord = (page - 1) * this.pageSize;
        this.endingRecord = page * this.pageSize;
        this.endingRecord = (this.endingRecord > this.totalRecordCount)?this.totalRecordCount:this.endingRecord;
        this.data = this.lignes.slice(this.startingRecord,this.endingRecord);
        this.initialRecords = this.data;
        this.startingRecord = this.startingRecord + 1;
    }

    connectedCallback() {
        this.setInfo();
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('records', this.__records);
    
        let docIds = this.__records.map(row => row.uuid);
        let input = { docIds: docIds };
        const params = {
            input: JSON.stringify(input),
            sClassName: 'inwiB2C_PLMFileHandler',
            sMethodName: 'getDocStatusesForMultipleIds',
            options: '{}',
        };
    
        this._actionUtilClass.executeAction(params, null, this, null, null)
            .then(response => {
                console.log('Status response: ', response);
                if (response && response.result && response.result.DocStatusMap) {
                    let docStatusMap = response.result.DocStatusMap;
                    console.log('docStatusMap =>', docStatusMap);
    
                    let newRecords = this.__records.map(row => {
                        let newRow = { ...row }; 
                        let newStatus = docStatusMap[row.uuid] || 'En attente de traitement';
                        newRow.statut = newStatus;
                        return newRow;
                    });
    
                    this.__records = newRecords;
                    
                    this.setInfo();
                }
            })
            .catch(error => {
                console.error('Error fetching doc statuses =>', error);
                this.showToast('Erreur','Impossible de récupérer les statuts des documents','error');
            });
    }
    
    

    // Upload Tab 
    get acceptedCSVFormats() {
        return ['.csv'];
    }

    uploadFileHandler(event) {
        console.log('uploadFileHandler SUCCESS');
        const uploadedFiles = event.detail.files;
        this.documentId = uploadedFiles[0].documentId;
        this.filename = uploadedFiles[0].name;
        this.checkValidation();

        let input = { 
            "contentDocumentId": this.documentId,
            "fileName": this.filename
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: 'inwiB2C_PLMFileHandler',
            sMethodName: 'ReadPLMFile',
            options: '{}',
        };
        
        this._actionUtilClass.executeAction(params, null, this, null, null)
        .then(response => {
            console.log('response',response);            
            if (response && response.result && response.result.List) {
                this.data = response.result.List;
                console.log('File lines retrieved:', this.data);
                this.showToast('Succès','Le fichier a été lu avec succès','success');
            } else {
                this.showToast('Erreur','Aucune donnée n\'a été retournée','error');
                this.filename = null;
            }
        })
        .catch(error => {
            console.error('Error reading file data:', error);
            this.showToast('Erreur','Une erreur est survenue lors de la lecture du fichier','error');
        });
    }

    checkValidation() {
        this.isValidated = this.documentId != null ? true : false;
    }

    handlerSave() {
        console.log('handlerSave SUCCESS');
        
        if (!this.documentId || !this.data || this.data.length === 0) {
            this.showToast('Erreur','Aucune donnée de fichier à traiter','error');
            return;
        }
        
        let input = {
            "contentDocumentId": this.documentId,
            "data": this.data
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: 'inwiB2C_PLMFileHandler',
            sMethodName: 'InsertPLMData',
            options: '{}',
        };

        this._actionUtilClass.executeAction(params, null, this, null, null)
        .then(response => {
            if (response && response.result && response.result.List == true) {
                this.showToast('Succès','Les enregistrements ont été insérés avec succès','success');
                this.omniApplyCallResp({ 'view':false});
                this.omniApplyCallResp({ 'operation':'soumissionok' });
                this.omniNextStep();
            } else {
                this.showToast('Erreur','L\'insertion des enregistrements a échoué','error');
                console.log('Error inserting data:', response);                
            }
        })
        .catch(error => {
            console.error('Error inserting data:', error);
            this.showToast('Erreur','Une erreur est survenue lors de l\'insertion','error');
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