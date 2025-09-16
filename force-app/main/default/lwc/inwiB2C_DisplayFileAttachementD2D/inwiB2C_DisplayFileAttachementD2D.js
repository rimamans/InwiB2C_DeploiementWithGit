import { LightningElement, track, api } from 'lwc';
    import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
    import { NavigationMixin } from 'lightning/navigation';
    import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
    import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
    import { ShowToastEvent } from 'lightning/platformShowToastEvent';

    export default class InwiB2C_DisplayFileAttachementD2D extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
        @track showModal = false;
        fileName = '';
        fileContent = '';
        __businessReferenceType;
        __recordId;
        __documentList;
        fileName = '';
        fileContent = '';
        @track __existingDocuments;
    

        
        @api
        get checkorderisavecporta() {
            return this.__checkorderisavecporta;
        }
        set checkorderisavecporta(value) {
            this.__checkorderisavecporta = value;
        }
    
        @api
        get statutlivraison() {
            return this.__statutlivraison;
        }
        set statutlivraison(value) {
            this.__statutlivraison = value;
        }
    
        __existingDocuments = [];
    
        columnsFilesDisplay = [
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
            },
            { label: 'Nom', fieldName: 'documentName', hideDefaultActions: true },
            { label: 'Type de Document', fieldName: 'docTypeLabel', hideDefaultActions: true, initialWidth: 200 },
            { label: 'Date du Chargement', fieldName: 'uploadDate', hideDefaultActions: true, initialWidth: 150 }
        ];
    
        // documentTypeLabels = [
        //     {
        //         documentType: "000001",
        //         docTypeLabel: "Pièce d'identité",
        //     },
        //     {
        //         documentType: "000002",
        //         docTypeLabel: "Contrat",
        //     },
        //     {
        //         documentType: "000003",
        //         docTypeLabel: "Scan ICC",
        //     },
        //     {
        //         documentType: "000004",
        //         docTypeLabel: "Attestation sur l'honneur",
        //     },
        //     {
        //         documentType: "000005",
        //         docTypeLabel: "Mandat de portabilité",
        //     },
        //     {
        //         documentType: "000006",
        //         docTypeLabel: "Bon de livraison",
        //     },
        //     {
        //         documentType: "000007",
        //         docTypeLabel: "Formulaire Changement Carte Sim",
        //     },
        //     {
        //         documentType: "000008",
        //         docTypeLabel: "Autres",
        //     }
        // ];
    
    
    
        
 get documentTypeLabels() {
    console.log("Check porta ", this.checkorderisavecporta);
    console.log("statut de livraison", this.statutlivraison);

    let result;

    switch (true) {
        case this.checkorderisavecporta === false && this.statutlivraison !== "inwiB2C_Commande_livrée":
            result = [
                { documentType: "000001", docTypeLabel: "Pièce d'identité" },
                { documentType: "000002", docTypeLabel: "Contrat" },
            ];
            break;
        case this.checkorderisavecporta === true && this.statutlivraison !== "inwiB2C_Commande_livrée":
            result = [
                { documentType: "000001", docTypeLabel: "Pièce d'identité" },
                { documentType: "000002", docTypeLabel: "Contrat" },
                { documentType: "000005", docTypeLabel: "Mandat de portabilité" },
            ];
            break;
        case this.statutlivraison === "inwiB2C_Commande_livrée" && this.checkorderisavecporta === true:
            result = [
                { documentType: "000001", docTypeLabel: "Pièce d'identité" },
                { documentType: "000002", docTypeLabel: "Contrat" },
                { documentType: "000005", docTypeLabel: "Mandat de portabilité" },
                { documentType: "000006", docTypeLabel: "Bon de livraison" },
            ];
            break;
        case this.statutlivraison === "inwiB2C_Commande_livrée" && this.checkorderisavecporta === false:
            result = [
                { documentType: "000001", docTypeLabel: "Pièce d'identité" },
                { documentType: "000002", docTypeLabel: "Contrat" },
                { documentType: "000006", docTypeLabel: "Bon de livraison" },
            ];
            break;
        default:
            result = [];
            break;
    }

    return result;
}
            
        
    
        @api
        get businessReferenceType() {
            return this.__businessReferenceType;
        }
        set businessReferenceType(value) {
            this.__businessReferenceType = value;
        }
    
        @api
        get recordId() {
            return this.__recordId;
        }
        set recordId(value) {
            this.__recordId = value;
        }
    
        @api
        get documentList() {
            return this.__documentList;
        }
        set documentList(value) {
            this.__documentList = JSON.parse(JSON.stringify(value));
        }
    
        
    
        _ns;
        _actionUtilClass;
    
        connectedCallback() {
            this._ns = getNamespaceDotNotation();
            this._actionUtilClass = new OmniscriptActionCommonUtil();
    
            this.getDocumentList();
        }
    
    
        getDocumentList() {
    
            //ATOS function to get label of doc type
    
            const getDocTypeLabel = (docTypeId) => {
    
                let label = '';
    
                this.__documentList.forEach(item => {
                    if (item.documentType == docTypeId) {
                        label = item.docTypeLabel;
                    }
                });
    
                return label;
    
            };
    
    
            //console.log('in getDocumentList');
    
            //let input = '{"mdnType":"MO", "offerType":"Pre", "category":"' + this.__mdnTypeValue+ '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId+ '","nbrResult": 3 }';
    
            /**
             * START MODIFICATION
             *  ADDED BY AMINE ARRAMA 08/12/2021 TO CORRECT THE B-3196
             */
    
            let brf = this.businessReferenceType;
            if (brf == 'UNKNOWN')
                brf = 'CONTRACT';
    
            let input = '{"businessReferenceType": "' + brf + '", "businessReference": "' + this.recordId + '"}'
            console.log('input : ' + JSON.stringify(input));
    
            /**
             * END MODIFICATION OF AMINE ARRAMA
             */
    
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
                if (response.error == false && response.result) {
                    let docs = response.result.IPResult.documents;
    
                    this.__existingDocuments = docs.map(doc => {
                        doc.docTypeLabel = getDocTypeLabel(doc.documentType);
    
                   //  H-M Ajout de l'heure et des secondes dans uploadDate
                   if (doc.uploadDate) {
                    doc.uploadDate = doc.uploadDate.replace(/\[UTC\]/, '');
                    let dateObj = new Date(doc.uploadDate);

                    if (!isNaN(dateObj)) {
                        let day = String(dateObj.getDate()).padStart(2, '0');
                        let month = String(dateObj.getMonth() + 1).padStart(2, '0');
                        let year = dateObj.getFullYear();
                        let hours = String(dateObj.getHours()).padStart(2, '0');
                        let minutes = String(dateObj.getMinutes()).padStart(2, '0');
                        let seconds = String(dateObj.getSeconds()).padStart(2, '0');

                        // Format : JJ/MM/AAAA HH:MM:SS
                        doc.uploadDate = `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`;
                    }
                }

    
                        return doc;
                    });
                }
            })
            .catch(error => {
                console.log('error');
                window.console.log(error);
            });
    
        }
    
        handleRowAction(event) {
    
    
            const action = event.detail.action;
            const row = event.detail.row;
            switch (action.name) {
                case 'view_File':
                    console.log('button view_Invoice clicked');
                    console.log(row.documentId, row.documentName);
                    this.getFile(row.documentId, row.documentName);
                    //this.getInvoice(row.Id );
                    break;
    
                    // ADDED DELETE_FILE 16/04/2024 15:15
                case 'delete_File':
                    console.log('button delete_File clicked');
                    console.log(row.documentId, row.documentName);
                    this.deleteDocumentIndex(row.documentId);
                    console.log(this.deleteDocumentIndex);
                    break;
                default:
                    console.log('nothing');
                    break;
            }
    
    
        }
    
        // // ADDED DELETEDOCUMENTINDEX 16/04/2024 15:15
    
    
        deleteDocumentIndex(documentId) {
            const params = {
                input: JSON.stringify({
                    documentID: documentId,
                    documentCharacteristic: [{
                        businessReferenceType: this.businessReferenceType || 'CONTRACT',
                        businessReference: this.recordId
                    }]
                }),
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_inwiB2C_deleteDocumentIndex',
                options: '{}',
            };
        
            console.log('Before calling executeAction for deletion:', params);
        
            this._actionUtilClass.executeAction(params)
                .then(response => {
                    console.log('Response after deleting document:', response);
                    if (!response.error && response.result) {
                        // Document deleted successfully, update the document list
                        console.log('Document deleted successfully:', documentId);
                        this.getDocumentList();
                    } else {
                        console.error('Error deleting document:', response.message);
                    }
                })
                .catch(error => {
                    console.error('Error deleting document:', error);
                });
        }
        
    
        // deleteDocumentIndex(documentId) {
    
        
        //     //console.log('in getDocumentList');
    
        //     //let input = '{"mdnType":"MO", "offerType":"Pre", "category":"' + this.__mdnTypeValue+ '", "mdn":"' + this.mdnFilterAttributeValue + '","lockToken":"' + this.orderId+ '","nbrResult": 3 }';
            
            
        //     let input = '{"documentID": "' + documentId + '", "documentCharacteristic" : [{ "businessReferenceType": "'+ this.documentstype.BusinessReferenceType + '", "businessReference": "' + this.documentstype.BusinessReference + '"}]}'
            
        //     console.log(input);
            
        //     const params = {
        //         input: input,
        //         sClassName: `${this._ns}IntegrationProcedureService`,
        //         sMethodName: 'inwib2c_inwiB2C_deleteDocumentIndex',
        //         options: '{}',
        //     };
    
        //     console.log('before call deleteDocumentIndex' + JSON.stringify(params));
        
        //     this._actionUtilClass
        //         .executeAction(params, null, this, null, null)
        //         .then(response => {
        //             console.log(response);
        //             if (response.error == false) {
                        
    
        //                 if (response.result) {
        //                     //console.log(response);
    
        //                     this.getDocumentList();
                           
    
        //                 }
        //             }
        //             else{
        //                 console.log('erreur lors de la suppression du document');
        //             }
        //         })
        //         .catch(error => {
        //             console.log('error');
        //             window.console.log(error);
        //         });
                
    
    
        // }
    
    
        getFile(documentId, documentName) {
    
            const b64toBlob = (b64Data, contentType = '', sliceSize = 512) => {
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
    
                const blob = new Blob(byteArrays, { type: contentType });
                return blob;
            }
    
            const showFile = function (blob, documentType, documentExtention) {
    
    
    
                //console.log(documentName);
                //console.log('in Show');
                var link = document.createElement('a');
    
                link.href = 'data:application/octet-stream;base64,' + blob;
                //link.download= documentId + "_" + documentType+  +"." + documentExtention;
                link.download = documentName;
                link.click();
    
            }
    
    
            const params = {
                input: '{"recordId": "' + documentId + '", "typeDoc": "other"}',
                sClassName: 'InwiB2C_FileExchangeManagementOS',
                sMethodName: 'retrieveDocument',
                options: '{}',
            };
    
            console.log('before call apex1');
    
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    //console.log(JSON.stringify(response));
                    if (!response.error && response.result.result.File) {
                        console.log(JSON.stringify(response));
                        showFile(response.result.result.File, response.result.result.DocumentType, response.result.result.DocumentExtention, response.result.result.documentName);
                    } else {
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
    
    
    
    
        /*
            
            @api filetodispaly;
        
            @api  isdisplay  ;
            @api isupload;
        
            @api documentstype;
            shoImg(){
                console.log("start shoImg");
                this.url = null;
                console.log("this.url : " +this.url)
                var theimage = this.template.querySelector(`[data-idimage="theimg"]`);
                var img  = 'data:image/'+this.filetodispaly.DocumentExtention+';base64,'+this.filetodispaly.File;
        
                theimage.src = img;
                console.log("end shoImg");
        
            }
        
        
        
            get acceptedFormats() {
                return ['.pdf', '.png'];
            }
        
        
        
            
            render() {
        
                return template;
            }
        */
    
    
    
        /*
    
        handleUploadFinished(event) {
            console.log('start handleUploadFinished')
            // Get the list of uploaded files
            const uploadedFiles = event.detail.files;
            console.log('uploadedFiles.length : '+ uploadedFiles.length);
    
            if (uploadedFiles.length > 0) {
                this.getBase64(uploadedFiles[0]);
              }
            
        }
    
        getBase64(file) {
            try {
                var reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = function () {
                  console.log(reader.result);
                };
          
            } catch (error) {
                console.log('Error: ', error);
     
            }
         }
         */
    
    
    
             //ADDED 17/05/2024 10:56 by Soufiane BOUTKHIL
        // handleFileChange(event) {
        //     const file = event.target.files[0];
        //     if (file) {
        //         this.fileName = file.name;
        //         const reader = new FileReader();
        //         reader.onload = () => {
        //             const base64 = reader.result.split(',')[1];
        //             this.fileContent = base64;
    
        //             console.log('File name:', this.fileName);
        //             console.log('File content (base64):', this.fileContent);
        //         };
        //         reader.readAsDataURL(file);
        //     }
        // }
        
        // handleAddDocument() {
        //     if (!this.fileContent) {
        //         console.error('No file selected or file content is empty');
        //         return;
        //     }
        
        //     const input = JSON.stringify({
        //         businessReferenceType: this.businessReferenceType,
        //         businessReference: this.recordId,
        //         documentType: '000001', // Pièce d'identité
        //         fileName: this.fileName,
        //         fileContent: this.fileContent
        //     });
        
        //     const params = {
        //         input: input,
        //         sClassName: 'InwiB2C_FileExchangeManagementOS',
        //         sMethodName: 'sendDocument',
        //         options: '{}',
        //     };
        
        //     console.log('Before calling sendDocument:', params);
        
        //     this._actionUtilClass.executeAction(params)
        //         .then(response => {
        //             console.log('Response after adding document:', response);
        //             if (!response.error && response.result) {
        //                 console.log('Document added successfully');
        //             } else {
        //                 console.error('Error adding document:', response.message);
        //             }
        //             this.getDocumentList();
        //         })
        //         .catch(error => {
        //             console.error('Error adding document:', error);
        //         });
        // }
    
        //END 17/05/2024 10:56 by Soufiane BOUTKHIL
    
    
        handleFileChange(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = () => {
                    const base64 = reader.result.split(',')[1];
                    console.log('File name:', file.name);
                    console.log('File content (base64):', base64);
        
                    // Stocker les données du fichier pour une utilisation ultérieure
                    this.fileName = file.name;
                    this.fileContent = base64;
        
                    // Ouvrir la modal de sélection du type de document
                    this.showModal = true;
                };
                reader.readAsDataURL(file);
            }
        }
 
         isDocumentAlreadyUploaded(docTypeId) {
            return this.__existingDocuments.some(doc => doc.documentType === docTypeId);
            }
            getCountOfUploadedDocuments(documentTypeLabel) {
              return this.__existingDocuments.filter(doc => doc.docTypeLabel === documentTypeLabel).length;
          }
  
            handleDocumentTypeSelection(event) {
              const documentTypeId = event.target.dataset.docTypeId;
              const documentTypeLabel = event.target.dataset.docTypeLabel;
          
              // Vérifier si un document avec ce type est déjà téléchargé
              if (documentTypeLabel === 'Pièce d\'identité' && this.isDocumentAlreadyUploaded(documentTypeId)) {
                  // Vérifier si le nombre de téléchargements pour ce type est déjà de 2 (c'est-à-dire un recto verso)
                  if (this.getCountOfUploadedDocuments(documentTypeLabel) >= 2) {
                      // Afficher un message d'erreur
                      this.showToast('Erreur', `Vous avez déjà téléchargé deux documents pour ${documentTypeLabel}.`, 'error');
                      return;
                  }
              } else {
                // Pour les autres types de documents, vérifier si un document avec ce type est déjà téléchargé
                if ( documentTypeLabel !== 'Pièce d\'identité' &&  this.isDocumentAlreadyUploaded(documentTypeId)) {
                    // Afficher un message d'erreur
                    this.showToast('Erreur', `Un document avec le type ${documentTypeLabel} est déjà téléchargé.`, 'error');

                    return;
                }
            }
          
              // Fermer la modal
              this.showModal = false;
          
              // Appeler la fonction d'ajout de document avec les données sélectionnées
              this.callApex(this.fileContent, documentTypeId, documentTypeLabel, this.fileName);
          } 
         


showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    this.dispatchEvent(event);
}
     
        hideModal() {
            this.showModal = false;
        }
    
        callApex(image64, docTypeId, docTypeLabel, docName) {
            const documentCharacteristic = JSON.stringify([
                {
                    businessReferenceType: this.businessReferenceType,
                    businessReference: this.recordId
                }
            ]);
        
            const input = '{"base64Image":"' + image64 + '","documentCharacteristic":' + documentCharacteristic + ',"docTypeId":"' + docTypeId + '","docTypeLabel":"' + docTypeLabel + '","docName":"' + docName + '"}';
        
            const params = {
                input: input,
                sClassName: 'InwiB2C_FileExchangeManagementOS',
                sMethodName: 'sendDocument',
                options: '{}'
            };
    

            console.log('params:', params);
        
            this._actionUtilClass.executeAction(params)
                .then(response => {
                    console.log('Response after adding document:', response);
                    if (!response.error && response.result && response.result.resultBody) {
                        const resultBody = JSON.parse(response.result.resultBody);
                        const tempId = resultBody.documentId;
        
                        let docList = JSON.parse(JSON.stringify(this.documentList));
        
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
        
                        this.documentList = docList;
                        this.getDocumentList();
                    } else {
                        console.error('Error adding document:', response.message);
                    }
                })
                .catch(error => {
                    console.error('Error adding document:', error);
                });
        }
        
       
        handleAddDocument() {
            if (!this.fileContent) {
                console.error('Aucun fichier sélectionné ou le contenu du fichier est vide');
                return;
            }
        
            this.callApex(`data:application/octet-stream;base64,${this.fileContent}`, '000001', 'Pièce d\'identité', this.fileName)
                .then(() => {
                    // Rafraîchir la liste des documents après l'ajout réussi
                    this.getDocumentList();
                })
                .catch(error => {
                    console.error('Erreur lors de l\'ajout du document:', error);
                });
        }

        
        gotonextStep() {
            this.omniNextStep();
            console.log('Navigué à l\'étape suivante.');
        }
    
        // Méthode pour revenir à l'étape précédente
        gotopreviousStep() {
            this.omniPrevStep();
            console.log('Revenu à l\'étape précédente.');
        }


        
    
    

    }