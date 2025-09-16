import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_FileAttachmentsUpload.html';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class InwiB2C_FileAttachmentsUpload extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    constructor() {
        super();
        var documentstype = [];
        var DocumentList;


    }

    isModalOpen;

    _ns = getNamespaceDotNotation();

    columnsFilesDisplay = [
        { label: 'Id', fieldName: 'documentId', hideDefaultActions: true ,initialWidth: 100},
        { label: 'Type de Document', fieldName: 'docTypeLabel', hideDefaultActions: true,initialWidth: 200 },
        { label: 'Nom', fieldName: 'documentName', hideDefaultActions: true ,initialWidth: 300},
        {
            label: "Télécharger",
            type: "button-icon",
            typeAttributes: {
              label: "Télécharger",
              iconName: "utility:download",
              name: "view_File",
              title: "Cliquer ici pour télécharger le document"
            }
        },
        {
            label: "Supprimer",
            type: "button-icon",
            typeAttributes: {
              label: "Supprimer",
              iconName: "utility:delete",
              name: "delete_File",
              title: "Cliquer ici pour supprimer le document"
            }
        }
    ];

    data = [

    ]

    __documentList;
    __documentstype;
    __existingDocuments = [];

    __loadDone = false;


    addRow(addition) {
        this.data = [...this.data, addition];
    }

    toReturn = [];

    @api checkValidity() { 
        console.log('in check validity');

        const reducer = (accumulator, currentValue) =>{
            console.log(currentValue);
            if (currentValue.mandatory && currentValue.uploaded) return accumulator && true;
            else if (currentValue.mandatory && !currentValue.uploaded) return accumulator && false;
            else return accumulator ;
        };

        if (this.DocumentList) {
            let validity = this.DocumentList.reduce(reducer,true);
            console.log('validity: ' + validity);

            if (!validity && this.__loadDone){
                this.dispatchEvent(
                    new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Certains documents obligatoires ne sont pas chargés',
                    variant: 'error'
                    }),
                );
            }else if (validity && this.__loadDone){
                this.omniNextStep();
                
                /*this.dispatchEvent(
                    new ShowToastEvent({
                    title: 'Succès',
                    message: 'Tous les documents obligatoires sont bien chargés. veuillez cliquer sur le bouton une seconde fois',
                    variant: 'success'
                    }),
                );*/
            }

            
            return validity;

        } else return false;

        
     }

    @api
    get documentstype() {
        return this.__documentstype;

    }
    set documentstype(value) {
        this.__documentstype = { ...value };
        this.__documentList = { ...value }.DocumentList;
    }

    get DocumentList() {
        // update uploaded fleg dependind on existing document in FileExcahnge
        const originalDocumentList = JSON.parse(JSON.stringify(this.__documentList));
        /*const docList = originalDocumentList.map((doc) => {
            if (this.__existingDocuments) {
                const found = this.__existingDocuments.find((existingDoc) =>{
                    console.log('existingDoc.documentType == doc.docTypeId' + existingDoc.documentType +' ' + doc.docTypeId)
                    return existingDoc.documentType == doc.docTypeId;
                });
                console.log(found);
                if (found) doc.uploaded = true;
                else doc.uploaded = false;

            }
            
            return doc;
        })*/
        return originalDocumentList;
    }
    set DocumentList(value){
        this.__documentList = value;
        this.omniUpdateDataJson(value);
                
        this.omniSaveState(value, true);
    }

    get uplodedDocumentList(){

        let docList = JSON.parse(JSON.stringify(this.DocumentList));

        return docList.filter((doc) => {

            return doc.uploaded;


        });

    }




    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        this.getDocumentList();
    }


    handleUploadFinished(event) {
        //console.log('start handleUploadFinished')

        let docid = event.target.name.docTypeId;
        let doclabel = event.target.name.docTypeLabel;

        console.log(JSON.stringify(event.target.name));


        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        this.isModalOpen = true;



        if (uploadedFiles.length > 0) {
            try {
                console.log('uploadedFiles[0].name : ' + uploadedFiles[0].name);

                var reader = new FileReader();
                reader.readAsDataURL(uploadedFiles[0]);
                reader.onload = () => {
                    console.log("reader.result: ")
                    console.log(reader.result)

                    this.callApex(reader.result, docid, doclabel, uploadedFiles[0].name);


                };

            } catch (error) {
                //console.log('Error: ', error);     
            }

        }

    }



    callApex(image64, docTypeId, docTypeLabel, docName) {
        //console.log('start callapex')
        let documentCharacteristic = '[' +
            '{"businessReferenceType": "' + this.documentstype.BusinessReferenceType + '",   ' +
            '"businessReference": "' + this.documentstype.BusinessReference + '"}' +
            ']';
        //console.log('documentCharacteristic: ')
        //console.log(documentCharacteristic)

        const input = '{"base64Image":"' + image64.split(',')[1] + '","documentCharacteristic":' + documentCharacteristic + ',"docTypeId":"' + docTypeId + '","docTypeLabel":"' + docTypeLabel + '","docName":"' + docName + '"}';
        //console.log('input: ')
        //console.log(input)

        const params = {
            input: input,
            sClassName: 'InwiB2C_FileExchangeManagementOS',
            sMethodName: 'sendDocument',
            options: '{}'
        };

        console.log('params: ')
        console.log(params)

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                //console.log('response: ')
                console.log(response);
                var tempId = typeof response.result.resultBody === 'undefined' ? "undef" : JSON.parse(response.result.resultBody).documentId;

                let docList = JSON.parse(JSON.stringify(this.DocumentList));

                docList = docList.map((doc) => {
                    if (doc.docTypeId == docTypeId) {
                        doc.documentId = tempId;
                        doc.uploaded = response.result.error === 'OK';
                        doc.docTypeLabel = docTypeLabel;
                        doc.error = response.result.error;
                        doc.resultBody = response.result.resultBody;
                        doc.documentName = docName;
                    }
                    return doc;
                });

                console.log(JSON.stringify(docList));

                this.DocumentList = JSON.parse(JSON.stringify(docList));

                this.isModalOpen = false;

                /*this.omniUpdateDataJson(this.DocumentList);
                //this.omniSaveState(this.toReturn, true);
                this.omniSaveState(this.DocumentList, true);*/

            })
            .catch(error => {
                window.console.log(error);
                console.log(error);
                return null;

            });
    }

    getBase64(file) {
        try {
            var reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = function () {
                this.tempRT = reader.result;
                //console.log("inside this.tempRT: " + this.tempRT)
            };

        } catch (error) {
            console.log('Error: ', error);
            return null;

        }
    }

    render() {
        //this.DocumentList = this.documentstype.DocumentList;

        return template;
    }

    getDocumentList() {

    
        //console.log('in getDocumentList');

        //let input = '{"mdnType":"MO", "offerType":"Pre", "category":"' + this.__mdnTypeValue+ '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId+ '","nbrResult": 3 }';

        let input = '{"businessReferenceType": "' + this.documentstype.BusinessReferenceType + '", "businessReference": "' + this.documentstype.BusinessReference + '"}'
        //console.log('input : ' + input);

        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_retreiveListDocument',
            options: '{}',
        };

        console.log('before call getDocumentList' + JSON.stringify(params));
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log(response);
                if (response.error == false) {
                    

                    if (response.result) {
                        //console.log(response);
                        this.__existingDocuments = response.result.IPResult.documents;
                        // update uploaded fleg dependind on existing document in FileExcahnge
                        const originalDocumentList = JSON.parse(JSON.stringify(this.__documentList));
                        const docList = originalDocumentList.map((doc) => {
                            if (this.__existingDocuments) {
                                const found = this.__existingDocuments.find((existingDoc) =>{
                                    //console.log('existingDoc.documentType == doc.docTypeId' + existingDoc.documentType +' ' + doc.docTypeId)
                                    return existingDoc.documentType == doc.docTypeId;
                                });
                                console.log(found);
                                if (found) {
                                    doc.uploaded = true;
                                    doc.documentId = found.documentId;
                                    doc.documentName = found.documentName;
                                }
                                else doc.uploaded = false;

                            }
                            
                            return doc;
                        });
                        //this.__documentList = JSON.parse(JSON.stringify(docList));

                        this.DocumentList = JSON.parse(JSON.stringify(docList));
                        this.__loadDone = true;

                    }
                }
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });


    }

    handleRowAction(event){
        

        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'delete_File':
                    console.log ('button delete_File clicked');
                    console.log(row.documentId);
                    this.deleteDocumentIndex(row.documentId);
                    //this.getInvoice(row.Id );
                    break;
            case 'view_File':
                console.log ('button view_Invoice clicked');
                console.log(row.documentId, row.documentName);
                this.getFile(row.documentId, row.documentName);
                //this.getInvoice(row.Id );
                break;
            default:
                console.log('nothing');
                break;
        }


    }
    deleteDocumentIndex(documentId) {

    
        //console.log('in getDocumentList');

        //let input = '{"mdnType":"MO", "offerType":"Pre", "category":"' + this.__mdnTypeValue+ '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId+ '","nbrResult": 3 }';
        
        
        let input = '{"documentID": "' + documentId + '", "documentCharacteristic" : [{ "businessReferenceType": "'+ this.documentstype.BusinessReferenceType + '", "businessReference": "' + this.documentstype.BusinessReference + '"}]}'
        
        console.log(input);
        
        const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: 'inwib2c_inwiB2C_deleteDocumentIndex',
            options: '{}',
        };

        console.log('before call deleteDocumentIndex' + JSON.stringify(params));
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log(response);
                if (response.error == false) {
                    

                    if (response.result) {
                        //console.log(response);

                        this.getDocumentList();
                       

                    }
                }
                else{
                    console.log('erreur lors de la suppression du document');
                }
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });
            


    }

    getFile(documentId, documentName) {

        const b64toBlob = (b64Data, contentType='', sliceSize=512) => {
            const byteCharacters = atob(b64Data);
            const byteArrays = [];
          
            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
              const slice = byteCharacters.slice(offset, offset + sliceSize);
          
              const byteNumbers = new Array(slice.length);
              for (let i = 0; i < slice.length; i++) {
                byteNumbers[i] = slice.charCodeAt(i);
              }
          
              const byteArray = new Uint8Array(byteNumbers);
              byteArrays.push(byteArray);
            }
          
            const blob = new Blob(byteArrays, {type: contentType});
            return blob;
        }

        const showFile = function (blob, documentType, documentExtention){

            

            //console.log(documentName);
            //console.log('in Show');
            var link = document.createElement('a');
            
            link.href = 'data:application/octet-stream;base64,' + blob;
            //link.download= documentId + "_" + documentType+  +"." + documentExtention;
            link.download= documentName;
            link.click();
            
          }


        const params = {
            input: '{"recordId": "' + documentId +'", "typeDoc": "other"}',
            sClassName: 'InwiB2C_FileExchangeManagementOS',
            sMethodName: 'retrieveDocument',
            options: '{}',
        };

        console.log('before call apex1');
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log(JSON.stringify(response));
                if (! response.error && response.result.result.File) {
                    console.log(JSON.stringify(response));
                    showFile(response.result.result.File, response.result.result.DocumentType, response.result.result.DocumentExtention, response.result.result.documentName);
                }else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    /*this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération de la facture PDF',
                        variant: 'error'
                        }),
                    );*/
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }


}