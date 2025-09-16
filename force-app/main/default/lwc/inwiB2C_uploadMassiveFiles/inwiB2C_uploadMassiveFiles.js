import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class InwiB2C_uploadMassiveFiles extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @track documentId;
    @track filename;
    _actionUtilClass;

    @track data; //data diplayed on table
    @track startingRecord = 1;
    @track page = 1;
    @track endingRecord = 0;
    @track totalRecordCount = 0;
    @track totalPage= 0;
    @track pageSize = 50;
    @track initialRecords; 
    lignes=[];
    __records = [];
    _ns = getNamespaceDotNotation();
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
        }

        columns = [
            { label: 'Nom', fieldName: 'name',hideDefaultActions: 'true'},
            { label: 'UUID', fieldName: 'uuid',hideDefaultActions: 'true'},
            { label: 'Statut', fieldName: 'statut',hideDefaultActions: 'true',cellAttributes:{class:{fieldName:'statutColor'}}},
            {type: 'button-icon',typeAttributes:{iconName: 'action:preview',name: 'View',disabled: { fieldName: 'Disable' }},initialWidth: 40},
            {type: 'button-icon',typeAttributes:{iconName: 'action:download',name: 'export',disabled: { fieldName: 'Disable' }},initialWidth: 40},
        ]; 

    get acceptedCSVFormats() {
        return ['.csv'];
    }
    setInfo(){
        this.lignes=this.__records.map(item=>{
            let statutColor = item.statut == "En attente de traitement" ? "slds-text-color_error":"slds-text-color_success"
            return {...item, 
                "statutColor":statutColor,
                "ErrorColor":"slds-text-color_error"
            }
        });
        this.totalRecordCount = this.lignes.length;
        this.totalPage = Math.ceil(this.totalRecordCount/this.pageSize);
        this.data = this.lignes.slice(0,this.pageSize);
        this.initialRecords = this.data;
        this.endingRecord = this.pageSize;
    }
    handlesClick(event){
        const row = event.detail.row;
        let view = false;
        if(event.detail.action.name == 'View'){
            view=true;
            this.omniUpdateDataJson({ 'view':view});
            this.omniUpdateDataJson({ 'selectedFile':row.uuid});
            this.omniUpdateDataJson({ 'selectedFileName':row.name});
            this.omniNextStep();
        }
        if(event.detail.action.name == 'export'){
            let vipInput ='{"selectedFile": "'+row.uuid+'"}';
            console.log('vipInput: ',vipInput);
            const params = {
                input: vipInput,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_getCTRecordsForDownoaldAM",
                options: "{}"
            };
            this._actionUtilClass.executeAction(params, null, this, null, null).then(response => {
                //console.log('response',JSON.stringify(response));
                if (response.result.IPResult.lignes) {
                    let data=JSON.parse(JSON.stringify(response.result.IPResult.lignes));
                    let csvFile = this.convertArrayToCsv(data);
                    this.createLinkForDownload(csvFile);
                }
                else
                    this.showMessage('Erreur','une erreur est survenue,merci de réessayer plus tard','error');
                    
            }
            ).catch(error => {
                console.log('error');
                window.console.log('lignesNOK: ',error);
      });
        }
    }
    convertArrayToCsv(downloadRecords) {
        let csvHeader = 'Segment,ParentId,Type,Nom,Prénom,Pièce d\'identité,Type pièce d\'identité,Code,Numéro de contact 1,Numéro de contact 2,Adresse mail,Région,Adresse,Précision Quartier,Ville/Douar , Flag Rural ou Urbain, Canal(RTM,Classique),Longitude,Latitude,Vendeur, Sous-Région(RVR)';
        let csvBody = downloadRecords.map((currItem) => Object.values(currItem).toString());
        console.log('csvBody: ',csvBody);
        let csvFile = csvHeader + "\n" + csvBody.join("\n");
        return csvFile;
    }
    createLinkForDownload(csvFile) {
        const downLink = document.createElement("a");
        downLink.href = "data:text/csv;charset=utf-8," + encodeURI(csvFile);
        downLink.target = '_blank';
        downLink.download = "Resultat_Changrgement_fichierAM.csv"
        downLink.click();
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
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.setInfo();

    }

    uploadFileHandler(event) {
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;
        this.documentId = uploadedFiles[0].documentId;
        this.filename = uploadedFiles[0].name;
        this.checkValidation();
        this.handlerSave();
    }

    checkValidation() {
        this.isValidated = this.documentId != null ? true : false;
    }

    showMessage( title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            }),
        );
    }
    handlerSave() {
        let input = { "contentDocumentId": this.documentId, "fileName": this.filename }
        const params = {
            input: JSON.stringify(input),
            sClassName: 'InwiB2C_UTMassiveFile',
            sMethodName: 'ReadFile',
            options: '{}',
        };
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response != null && response.result.Retour.error != null ) {
                    if(response.result.Retour.error == true){
                        this.showMessage('Erreur',response.result.Retour.Message,'error');
                    }
                    else{
                        this.showMessage('','upload successuful','success');
                        this.omniNextStep();
                } 
    }})
            .catch(error => {
                console.log('error' + JSON.stringify(error));
                window.console.log(error);
            });
    }
    
}