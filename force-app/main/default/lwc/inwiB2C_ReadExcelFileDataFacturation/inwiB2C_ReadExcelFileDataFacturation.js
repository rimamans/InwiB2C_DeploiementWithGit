import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class inwiB2C_ReadExcelFileDataFacturation extends OmniscriptBaseMixin(LightningElement) {
    @api recordId;
    @api isLoaded
    @track error;
    @track valError;
    @track isValidated;
    uploadedFiles;
    newJsonData;
    @track data = [];
    demandeMassif;
    @track documentId;
    @track filename;
    valueAction = '';
    valueOrigine = '';
    valueMotif = '';
    @track isFileUploadHidden = true;
    @track isActionHidden = false;
    @track isMotifHidden = false;
    @track IsButtonHidden = false;
    @track isFormat = true;



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
                { label: 'Restriction revouvrement', value: 'SUSP' },
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
                { label: 'Fraude', value: 'Fraude' },
                { label: 'Préserver', value: 'Préserver' },
                { label: 'Usage indu PSP', value: 'UsageinduPSP' },
                { label: 'Préserver PSP', value: 'PréserverPSP' },
                { label: 'Usage indu PREP', value: 'UsageinduPREP' },
                { label: 'Préserver PREP', value: 'PréserverPREP' },
            ];
        }
    }

    get acceptedCSVFormats() {
        return ['.csv'];
    }

    connectedCallback() {
        // Create instance of OmniscriptActionCommonUtil utility class for use in this class
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.newJsonData = JSON.parse(JSON.stringify(this.omniJsonData));
    }

    uploadFileHandler(event) {
        console.log('uploadFileHandler SUCCESS');
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;
        this.documentId = uploadedFiles[0].documentId;
        this.filename = uploadedFiles[0].name;
        // this.valError = null;
        this.checkValidation();
        this.handlerSave();
        console.log('documentId : ' + this.documentId);
        this.isFileUploadHidden = false;
    }
    delFiles() {
        this.uploadedFiles = null;
        this.filename = null;
        checkValidation();
    }
    checkValidation() {
        this.isValidated = this.documentId != null ? true : false;
    }

    handlerSave() {
        // this.isLoaded = true;
        let input = { "contentDocumentId": this.documentId }
        const params = {
            input: JSON.stringify(input),
            sClassName: 'MDNFileHandler',
            sMethodName: 'ReadMDNFile',
            options: '{}',
        };
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                if (response != null && response.result.errorsValidation != null) {
                    this.valError = response.result.errorsValidation;
                    this.isLoaded = false;

                } else if (response != null) {
                    //  var data = [];

                    this.omniApplyCallResp({ 'documentId': this.documentId });
                    console.log('Documentid:' + this.documentId);
                    this.isLoaded = false;
                    if (response.result.List != null) {
                        var conts = response.result.List;
                        for (var key in conts) {
                            this.data.push({ value: conts[key], key: 'mdn' });
                        }
                    }

                    this.omniApplyCallResp({ 'portedExcel': this.data });
                    console.log('JSON.stringify' + JSON.stringify(this.data))
                }
                for (var mdn in this.data) {
                    console.log('IN LOOP' + this.data[mdn].value);
                    var t = this.data[mdn].value;
                    if (!t.match(/^212[0-9]{9}/)) {
                        console.log('IN IF' + this.data[mdn].value);
                        this.isFormat = false;
                    }
                }


                //console.log('response.result.porta' + response.result.List.split('\r'));

            })
            .catch(error => {
                console.log('error' + JSON.stringify(error));
                window.console.log(error);
            });
    }

    handleChangeOrigine(event) {
        this.isActionHidden = true;
        this.isMotifHidden = false;
        this.optionsAction;
        this.valueOrigine = event.detail.value;
        this.omniApplyCallResp({ 'origine': this.valueOrigine });
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
        this.omniApplyCallResp({ 'motif':this.valueMotif });
    }

    handleSave() {
        
        console.log('action:' + this.valueAction);
        console.log('Origine:' + this.valueOrigine);
        
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
            this.omniNextStep();
        }

    }
}