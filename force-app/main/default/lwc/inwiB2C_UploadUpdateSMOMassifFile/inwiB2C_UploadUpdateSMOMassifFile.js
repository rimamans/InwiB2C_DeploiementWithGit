import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_UploadUpdateSMOMassifFile.html';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class InwiB2C_UploadUpdateSMOMassifFile extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    
    _actionUtilClass;
    @track documentId;
    @track filename;
    @track isValidated;
    disableChoice=false;
    typeChargement;
    @track data = [];

    @track isFormat = true;
    @track data = [];
    @track valError;
    @track error;
    @track isFileUploadHidden = true;
    valueAction = '';
    valueOrigine = '';
    valueMotif = '';
    @track isActionHidden = false;
    @track isMotifHidden = false;
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
    typeChargementSelected;
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
        }
//tab hisotrique
    columns = [
        { label: 'Nom', fieldName: 'name',hideDefaultActions: 'true'},
        { label: 'UUID', fieldName: 'uuid',hideDefaultActions: 'true'},
        { label: 'Date', fieldName: 'date',hideDefaultActions: 'true'},
        { label: 'Type de chargement', fieldName: 'typeChargement',hideDefaultActions: 'true'},
        { label: 'Statut', fieldName: 'statut',hideDefaultActions: 'true',cellAttributes:{class:{fieldName:'statutColor'}}},
        {type: 'button-icon',typeAttributes:{iconName: 'action:preview',name: 'View',disabled: { fieldName: 'Disable' }},initialWidth: 40},
        {type: 'button-icon',typeAttributes:{iconName: 'action:edit',name: 'edit',disabled: { fieldName: 'DisableCF' }},initialWidth: 40},
        {type: 'button-icon',typeAttributes:{iconName: 'action:download',name: 'export',disabled: { fieldName: 'Disable' }},initialWidth: 40},
    ]; 
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
        this.dataTable = this.lignes.slice(0,this.pageSize);
        this.initialRecords = this.data;
        this.endingRecord = this.pageSize;
    }
    handlesClick(event){
        const row = event.detail.row;
        this.typeChargementSelected=event.detail.row;
        let view = false;
        console.log('View');
        if(event.detail.action.name == 'View'){
            this.omniApplyCallResp({ 'view': true });
            this.omniApplyCallResp({ 'action': 'view' });
            this.omniApplyCallResp({ 'documentId':row.uuid});
            this.omniApplyCallResp({ 'TypeChargement':row.typeChargement});
            this.omniApplyCallResp({ 'selectedFileName':row.name});
            this.omniNextStep();
        }
        if(event.detail.action.name == 'edit'){
            this.omniApplyCallResp({ 'view': true });
            this.omniApplyCallResp({ 'action': 'edit' });
            this.omniApplyCallResp({ 'documentId':row.uuid});
            this.omniApplyCallResp({ 'TypeChargement':row.typeChargement});
            this.omniApplyCallResp({ 'selectedFileName':row.name});
            this.omniNextStep();
        }
        if(event.detail.action.name == 'export'){
            console.log('export');
            let input ={"selectedFile": row.uuid,"typechargement":row.typeChargement};
            console.log('Input: ',input);
            const params = {
                input: JSON.stringify(input),
                sClassName: 'MDNFileHandler',
                sMethodName: 'getListByDocumentId',
                options: '{}',
            };
            this._actionUtilClass.executeAction(params, null, this, null, null).then(response => {
                console.log('response',response);
                if (response.result.List) {
                    let data= JSON.parse(JSON.stringify(response.result.List));
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
        let csvHeader;
        if(this.typeChargementSelected=='Chargement par MDN'){ csvHeader = 'UUID,Type de chargement,MDN,Action,Statut,Erreur';}
        else{csvHeader = 'Compte de facturation,UUID,Type de chargement,Action,Statut,Erreur';} 
        
        let csvBody = downloadRecords.map((currItem) => Object.values(currItem).toString());
        console.log('csvBody: ',csvBody);
        let csvFile = csvHeader + "\n" + csvBody.join("\n");
        return csvFile;
    }
    createLinkForDownload(csvFile) {
        const downLink = document.createElement("a");
        downLink.href = "data:text/csv;charset=utf-8," + encodeURI(csvFile);
        downLink.target = '_blank';
        downLink.download = "Resultat_SMO_Massif.csv"
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
    //tab Upload
    get optionChargement() {
        return [
          {label: `Chargement par MDN`,value: "CHMDN"},
          {label: "Chargement par compte de facturation", value: "CHCF" },
        ];
      }
    handleChangeTypeChargement(event){
        this.typeChargement=event.detail.value;
        console.log('type chargement',this.typeChargement);
    }

    connectedCallback() {
        this.setInfo();
        // Create instance of OmniscriptActionCommonUtil utility class for use in this class
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        console.log('records',this.records);
        
        
    }


    get acceptedCSVFormats() {
        return ['.csv'];
    }
    
    get optionsOrigine() {
        return [
            { label: 'Recouvrement', value: 'IMX' },
            { label: 'Fraude', value: 'FRAUDE' },
            { label: 'BO', value: 'BO' },
        ];
    }
    get optionsAction() {
        let origine = this.valueOrigine;
        if (origine == 'FRAUDE') {
            return [
                { label: 'Réhabilitation', value: 'REHA' },
                { label: 'Réhabilitation des appels internationaux', value: 'REHAI' },
                { label: 'Réhabilitation Roaming Data', value: 'REHA_ROAM_DATA' },
                { label: 'Réhabilitation des appels entrants', value: 'REHAE' },
                { label: 'Suspension totale', value: 'SUST' },
                { label: 'Suspension des appels sortants', value: 'SUSA' },
                { label: 'Suspension des appels entrants', value: 'SUSAE' },
                { label: 'Suspension des appels internationaux', value: 'SUSAI' },
                { label: 'Suspension Roaming Data', value: 'SUS_ROAM_DATA' },
            ];
        } else if (origine == 'IMX') {
            return [
                { label: 'Réhabilitation', value: 'REHAB' },
                { label: 'Suspension recouvrement', value: 'SUST' },
                { label: 'Restriction revouvrement', value: 'SUSA' },
                { label: 'Résiliation/Migration Prépayé', value: 'RESIL' },
                { label: 'Résiliation déconnecter service', value: 'RESILD' },
            ];
        } else {
            return [
                { label: 'Déconnecter service', value: 'DECONN' },
            ];
        }
    }
    get optionsMotif() {
        let origine = this.valueOrigine;
        let action = this.valueAction;
        if (origine == 'BO') {
            return [
                { label: 'Retard de paiement', value: 'Retarddepaiement' },
                { label: 'Manque de paiement', value: 'Manquedepaiement' },
                { label: 'Suite demande client', value: 'Suitedemandeclient' },
                { label: 'Suite passage contentieux', value: 'Suitepassagecontentieux' },
                { label: 'Résiliation auto ligne de test', value: 'Résiliationautolignedetest' },

            ];
        } else if ((action == 'SUST' || action == 'SUSA' || action == 'SUSAE' || action == 'SUSAI' || action == 'SUS_ROAM_DATA') && origine == 'FRAUDE') {
            return [
                { label: 'Usage indu', value: 'Usageindu' },
                { label: 'Fraude', value: 'FRAUDE' },
                { label: 'Préserver', value: 'Préserver' },
                { label: 'Usage indu PSP', value: 'UsageinduPSP' },
                { label: 'Préserver PSP', value: 'PréserverPSP' },
                { label: 'Usage indu PREP', value: 'UsageinduPREP' },
                { label: 'Préserver PREP', value: 'PréserverPREP' },
            ];
        }
    }

    uploadFileHandler(event) {
        console.log('uploadFileHandler SUCCESS');
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;
        this.documentId = uploadedFiles[0].documentId;
        this.filename = uploadedFiles[0].name;
        this.checkValidation();
        this.handlerSave();
        this.isFileUploadHidden = false;
        console.log('documentId : ' + this.documentId);
        this.disableChoice=true;
    }
    checkValidation() {
        this.isValidated = this.documentId != null ? true : false;
    }
    
    handlerSave() {
        let input = { "contentDocumentId": this.documentId ,"fileName":this.filename,"TypeChargement":this.typeChargement};
        console.log('in handlerSave',input);
        let sMethodName = '';
        if (this.typeChargement === 'CHMDN') {
            sMethodName = 'ReadMDNFile';
        } else if (this.typeChargement === 'CHCF') {
            sMethodName = 'ReadFCTFile';
        }
    
        const params = {
            input: JSON.stringify(input),
            sClassName: 'MDNFileHandler',
            sMethodName: sMethodName,
            options: '{}',
        };
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response != null && response.result.errorsValidation != null) {
                    this.valError = response.result.errorsValidation;

                   // this.isLoaded = false;
                } else if (response != null) {
                    //this.omniApplyCallResp({ 'documentId': this.documentId });
                   // console.log('Documentid: ' + this.documentId);
                   // this.isLoaded = false;
    
                    if (response.result.List != null) {
                        var conts = response.result.List;
                        let uniqueValues = new Set();
                        for (var key in conts) {
                            let normalizedValue = conts[key].trim();
                            if (!uniqueValues.has(normalizedValue)) {
                                uniqueValues.add(normalizedValue);
                                let keyValue = this.typeChargement === 'CHMDN' ? 'mdn' : 'fct';
                                this.data.push({ value: normalizedValue, key: keyValue });
                            }
                    }
                    }
    
                  
                    console.log('JSON.stringify' + JSON.stringify(this.data));
    
                    for (var mdn in this.data) {
                        console.log('IN LOOP: ' + this.data[mdn].value);
                        var t = this.data[mdn].value;
    
                        if (this.typeChargement === 'CHMDN' && !t.match(/^212[0-9]{9}/)) {
                            console.log('IN IF: ' + this.data[mdn].value);
                            this.isFormat = false;
                        }
                    }
                }
            })
            .catch(error => {
                console.log('error: ' + JSON.stringify(error));
                window.console.log(error);
            });
    }
    handleChangeOrigine(event) {
        this.isActionHidden = true;
        this.isMotifHidden = false;
        this.optionsAction;
        this.valueOrigine = event.detail.value;
        //this.omniApplyCallResp({ 'origine': this.valueOrigine });
    }
    handleChangeAction(event) {

        this.valueAction = event.detail.value;
        if (this.valueOrigine == 'BO' || ((this.valueAction == 'SUST' || this.valueAction == 'SUSA' || this.valueAction == 'SUSAE' || this.valueAction == 'SUSAI' || this.valueAction == 'SUS_ROAM_DATA') && this.valueOrigine == 'FRAUDE')){
            this.isMotifHidden = true;
        }else{
            this.isMotifHidden = false;
        }
        this.omniApplyCallResp({ 'action': this.valueAction });

    }
    handleChangeMotif(event) {
        this.valueMotif = event.detail.value;
      //  this.omniApplyCallResp({ 'motif':this.valueMotif });
    }
    handleSave() {
        
       // console.log('action:' + this.valueAction);
       // console.log('Origine:' + this.valueOrigine);
        
        if (!this.valueAction || !this.valueOrigine || !this.filename) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Veuillez saisir tous les champs',
                    variant: 'error'
                }),
            );
             } else if((this.valueOrigine == 'BO' && !this.valueMotif)|| ((this.valueAction == 'SUST' || this.valueAction == 'SUSA' || this.valueAction == 'SUSAE' || this.valueAction == 'SUSAI' || this.valueAction == 'SUS_ROAM_DATA') && this.valueOrigine == 'FRAUDE'&& !this.valueMotif)){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Veuillez saisir tous les champs',
                    variant: 'error'
                }),
            );
        }else if (this.isFormat == false) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Merci de vérifier le format du fichier',
                    variant: 'error'
                }),
            );
        }
        else {
            //chb 18/10/2024 
            this.insertFileMDNCF();
            //this.omniNextStep();
        }
    }/*chb 18/10/2024 begin*/
        insertFileMDNCF(){
             // this.isLoaded = true;
        let input = { "contentDocumentId": this.documentId ,"action":this.valueAction,"origine":this.valueOrigine,"motif":this.valueMotif,"data":this.data,"typechargement":this.typeChargement}     
        const params = {
            input: JSON.stringify(input),
            sClassName: 'MDNFileHandler',
            sMethodName: 'insertData',
            options: '{}',
        };
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response != null && response.result != null) {
                    this.valError = response.result;
                    this.isLoaded = false;
                    console.log('Result: ',response.result);
                    this.omniApplyCallResp({ 'view':false});
                    this.omniApplyCallResp({ 'operation':'soumissionok' });
                    this.omniNextStep();
                }})
        
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