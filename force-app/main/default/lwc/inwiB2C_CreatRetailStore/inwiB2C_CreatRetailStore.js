import { LightningElement, api, track } from 'lwc';
import RetailStoreRecord from '@salesforce/apex/InwiB2C_RetailStore.RetailStoreRecord';
import { NavigationMixin } from "lightning/navigation";
import { getLocationService } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRVRName from '@salesforce/apex/InwiB2C_RetailStore.getRVRName';
import getRegions from '@salesforce/apex/InwiB2C_RetailStore.getRegions';
import getLocalisationsByRegion from '@salesforce/apex/InwiB2C_RetailStore.getLocalisationsByRegion';
import getCircuitsByLocalisation from '@salesforce/apex/InwiB2C_RetailStore.getCircuitsByLocalisation';
import getCurrentUserProfileName from '@salesforce/apex/InwiB2C_RetailStore.getCurrentUserProfileName';
import generateOtpLwc from '@salesforce/apex/inwiCGC_OTPController.generateOtpLwc';
import verifyOtpLwc from '@salesforce/apex/inwiCGC_OTPController.verifyOtpLwc';

import checkMdnsDifferent from '@salesforce/apex/InwiB2C_RetailStore.checkMdnsDifferent';
import checkMdnUniqueness from '@salesforce/apex/InwiB2C_RetailStore.checkMdnUniqueness';
import checkMdnSubscription from '@salesforce/apex/InwiB2C_RetailStore.checkMdnSubscription';


export default class InwiB2C_CreatRetailStore extends NavigationMixin(LightningElement) {
    @track FirstName = '';
    @track LastName = '';
    @track AccName = '';
    @track ActivityType = '';
    @api isLoading = false;
    MdnDealer;
    MdnDealer2;
    @track isDealer = false;
    @track segmentDealer = '';
    @track statusRS = 'inwiCGC_EnCours';
    @track contactNumber1 = '';
    @track contactNumber2 = '';
    @track distributeur = '';
    @track selectedCircuit = '';
    @track selectedLocalisation = '';
    @api recordId;
    myLocationService;
    @track isModalOpen = false;
    @track imageUrl;
    imageFileId;

    @track showStatusPicklist = false;

    @track regionOptions = [];
    @track localisationOptions = [];
    @track circuitOptions = [];

    @track isDealerIdentifier = false;
    @track isDistributeurAppMobile = false;
    selectedRegion;

    latitude = 0;
    longitude = 0;

    @track showOtpModal = false;
    @track otpCode = '';
    @track otpMessage = '';
    otpQueue = [];
    otpIndex = 0;
    otpCanal = 'CGC';
    otpMode  = 'sms';
    @track otpItems = [];

    get allOtpVerified() {
        return this.otpItems.length > 0 && this.otpItems.every(i => i.verified === true);
    }
    get isSaveDisabled() { return !this.allOtpVerified; }
    get saveOtpButtonLabel() { return this.allOtpVerified ? 'Enregistrer' : 'Vérifier tous puis enregistrer'; }

    handleFirstNameChange(event) {
        this.FirstName = event.target.value;
    }
    handleLastNameChange(event) {
        this.LastName = event.target.value;
    }
    handleAccountNameChange(event) {
        this.AccName = event.target.value;
    }
    handleActivityTypeChange(event) {
        this.ActivityType = event.target.value;
    }
    handleMdnDealerChange(event) {
        this.MdnDealer = event.target.value;
    }
    handleMdnDealer2Change(event) {
        this.MdnDealer2 = event.target.value;
    }
    handleIsDealerChange(event) {
        this.isDealer = event.target.checked;
    }
    handleSegmentChange(event) {
        this.segmentDealer = event.target.value;
    }
    handleStatusChange(event) {
        this.statusRS = event.target.value;
    }
    handleContactNumber1Change(event) {
        this.contactNumber1 = event.target.value;
    }
    handleContactNumber2Change(event) {
        this.contactNumber2 = event.target.value;
    }
    handleDisChange(event){
        this.distributeur = event.target.value;
    }
    handleRegionChange(event) {
        this.selectedRegion = event.detail.value;

        this.localisationOptions = [];
        this.circuitOptions = [];
        this.selectedLocalisation = '';
        this.selectedCircuit = '';
        
        getLocalisationsByRegion({ regionName: this.selectedRegion })
            .then(data => {
                this.localisationOptions = data.map(flag => ({
                    label: flag,
                    value: flag
                }));
            })
            .catch(error => {
                console.error('Error fetching localisations:', error);
            });
    }

    handleDistributeurAppMobileChange(event) {
        this.isDistributeurAppMobile = event.target.checked;
        if (this.isDistributeurAppMobile) {
            this.isDealerIdentifier = true;
        }
    }

    handleDealerIdentifierChange(event) {
        this.isDealerIdentifier = event.target.checked;
    }

    handleCircuitChange(event) {
        this.selectedCircuit = event.detail.value;
    }

    handleLocalisationChange(event) {
        this.selectedLocalisation = event.detail.value;

        this.circuitOptions = [];
        this.selectedCircuit = '';
    
        getCircuitsByLocalisation({ 
            selectedLocalisation: this.selectedLocalisation, 
            selectedRegion: this.selectedRegion 
        })
        .then(data => {
            this.circuitOptions = data.map(circuit => ({
                label: circuit.label,
                value: circuit.value
            }));
        })
        .catch(error => {
            console.error('Error fetching circuits:', error);
        });
    }

    connectedCallback() {
        this.statusRS = 'inwiCGC_EnCours';
        this.myLocationService = getLocationService();
        this.disablePullToRefresh();

        getCurrentUserProfileName()
            .then(profileName => {
                if(profileName === 'CGC_RVR' || profileName === 'CGC_FDV_Manager' || profileName === 'System Administrator') {
                    this.showStatusPicklist = true;
                    this.statusRS = 'inwiCGC_EnCours';
                }
            })
            .catch(error => {
                console.error('Error retrieving user profile name:', error);
            });

        getRVRName()
            .then(result => {
                console.log('RVR Name:', result);
                this.IdRVR = result;
            })
            .catch(error => {
                console.error('Error retrieving RVR Name:', error);
            });
        getRegions()
            .then(data => {
                this.regionOptions = data.map(region => ({
                    label: region.Name,
                    value: region.Name
                }));
            })
            .catch(error => {
                console.error('Error fetching regions:', error);
            });
    }

    disablePullToRefresh () {
        // CustomEvent is standard JavaScript. See:
        // https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent
        const disable_ptr_event = new CustomEvent("updateScrollSettings", {
            detail: {
                isPullToRefreshEnabled: false
            },
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(disable_ptr_event);
    }

    async handleSave() {
        if (!this.AccName && this.FirstName && this.LastName) {
            this.AccName = `${this.FirstName} ${this.LastName}`;
        }

        const missing = [];
        if (!this.FirstName) missing.push('Prénom');
        if (!this.LastName) missing.push('Nom');
        if (!this.contactNumber1) missing.push('Numéro de contact');
        if (!this.imageUrl) missing.push('Photo du Magasin');
        if (!this.ActivityType) missing.push('Type d’activité');
        if (!this.selectedRegion) missing.push('Région');
        if (!this.selectedLocalisation) missing.push('Route');
        if (!this.selectedCircuit) missing.push('Circuit');
        if (!this.distributeur) missing.push('Distributeur');
        // if (this.isDealer && !this.segmentDealer) missing.push('Segment Dealer');

        if (missing.length > 0) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Champs manquants',
                message: 'Veuillez remplir: ' + missing.join(', '),
                variant: 'error'
            }));
            return;
        }

        const validNatOr212 = (n) => {
            const d = (n || '').replace(/\D/g, '');
            return d.length === 10 || (d.length === 12 && d.startsWith('212'));
        };

        if (!validNatOr212(this.contactNumber1)) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Numéro invalide',
                message: 'Utilisez 10 chiffres (0XXXXXXXXX) ou 212XXXXXXXX.',
                variant: 'error'
            }));
            return;
        }

        if ((this.MdnDealer && !validNatOr212(this.MdnDealer)) ||
            (this.MdnDealer2 && !validNatOr212(this.MdnDealer2))) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'MDN invalide',
                message: 'MDN doit être 10 chiffres ou 212XXXXXXXX.',
                variant: 'error'
            }));
            return;
        }

        if (this.MdnDealer && this.MdnDealer2 && String(this.MdnDealer) === String(this.MdnDealer2)) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Conflit MDN',
                message: 'MDN Dealer 1 et 2 doivent être différents.',
                variant: 'error'
            }));
            return;
        }

        if (this.MdnDealer || this.MdnDealer2) {
            this.isLoading = true;
            try {
                const uniq = await checkMdnUniqueness({
                    mdn1: this.MdnDealer || '',
                    mdn2: this.MdnDealer2 || ''
                });
                if (!uniq?.ok) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Validation',
                        message: uniq.message,
                        variant: 'error'
                    }));
                    this.isLoading = false;
                    return;
                }

                const sub = await checkMdnSubscription({
                    mdn1: this.MdnDealer || '',
                    mdn2: this.MdnDealer2 || ''
                });
                if (!sub?.ok) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Validation',
                        message: sub.message,
                        variant: 'error'
                    }));
                    this.isLoading = false;
                    return;
                }
            } catch (e) {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Erreur',
                    message: e?.body?.message || 'Erreur lors des validations serveur.',
                    variant: 'error'
                }));
                this.isLoading = false;
                return;
            }
            this.isLoading = false;
        }

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (pos) => {
                    this.latitude = pos.coords.latitude;
                    this.longitude = pos.coords.longitude;

                    if (this.MdnDealer || this.MdnDealer2) {
                        this.openParallelOtpModal();

                    } else {
                        this.isLoading = true;
                        this.SaveToSF();
                    }
                },
                (error) => {
                    const msg = (error && error.code === error.PERMISSION_DENIED)
                        ? 'Localisation non partagée, veuillez activer la localisation pour continuer'
                        : `Geolocation error: ${error?.message || ''}`;
                    this.dispatchEvent(new ShowToastEvent({ message: msg, variant: 'error' }));
                },
                { timeout: 10000 }
            );
        } else {
            this.dispatchEvent(new ShowToastEvent({
                message: 'La géolocalisation n’est pas supportée par ce navigateur.',
                variant: 'error'
            }));
        }
    }


    openParallelOtpModal() {
        this.otpItems = [];
        if (this.MdnDealer) {
            this.otpItems.push({
            key: 'mdn1',
            label: 'MDN Dealer',
            mdn: this.MdnDealer,
            code: '',
            sent: false,
            verifying: false,
            verified: false,
            error: '',
            labelText: 'Code OTP pour ' + this.MdnDealer,
            buttonLabel: 'Vérifier ce MDN',
            disableVerify: true
            });
        }
        if (this.MdnDealer2) {
            this.otpItems.push({
            key: 'mdn2',
            label: 'MDN Dealer 2',
            mdn: this.MdnDealer2,
            code: '',
            sent: false,
            verifying: false,
            verified: false,
            error: '',
            labelText: 'Code OTP pour ' + this.MdnDealer2,
            buttonLabel: 'Vérifier ce MDN',
            disableVerify: true
            });
        }
        this.showOtpModal = true;
        this.sendOtpToAll();
    }


    sendOtpToAll() {
        this.otpItems.forEach((_, idx) => this.sendOtpForIndex(idx));
    }

    sendOtpForIndex(i) {
        const row = this.otpItems[i];
        if (!row) return;
        this.isLoading = true;
        row.error = '';

        generateOtpLwc({
            mdn: row.mdn,
            mode: this.otpMode,
            canal: this.otpCanal,
            email: null,
            orderId: null,
            requestResilId: null
        })
        .then(res => {
            if (res?.success) {
                row.sent = true;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: `Code envoyé à ${row.mdn}.`,
                    variant: 'success'
                }));
            } else {
                row.error = res?.message || 'Échec d’envoi du code.';
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: `${row.label}: ${row.error}`,
                    variant: 'error'
                }));
            }
        })
        .catch(e => {
            row.error = e?.body?.message || 'Erreur OTP inattendue.';
            this.dispatchEvent(new ShowToastEvent({
                title: 'OTP',
                message: `${row.label}: ${row.error}`,
                variant: 'error'
            }));
        })
        .finally(() => {
            this.isLoading = false;
            this.otpItems = [...this.otpItems];
        });
    }

    handleOtpCodeChange(e) {
        const idx = Number(e.target.dataset.index);
        if (Number.isNaN(idx)) return;

        const row = this.otpItems[idx];
        if (!row) return;

        const val = (e.detail.value || '').toString();

        row.code = val.replace(/\D/g, '');

        row.disableVerify = row.verified || row.verifying || row.code.length === 0;

        this.otpItems = [...this.otpItems];
    }


    verifySingleIndex(e) {
        const idx = Number(e.target.dataset.index);
        const row = this.otpItems[idx];
        if (!row) return;

        if (!row.code) {
            this.dispatchEvent(new ShowToastEvent({
                message: `Veuillez saisir le code pour ${row.label}.`,
                variant: 'warning'
            }));
            return;
        }

        this.isLoading = true;
        row.verifying = true;
        row.error = '';

        verifyOtpLwc({
            mdn: row.mdn,
            codeOtp: row.code,
            email: null,
            canal: this.otpCanal
        })
        .then(res => {
            if (res?.ok === true) {
                row.verified = true;
                row.disableVerify = true;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: `${row.label} vérifié.`,
                    variant: 'success'
                }));
            } else {
                row.error = 'Code invalide.';
                row.disableVerify = row.verifying || row.code.length === 0;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: `${row.label}: ${row.error}`,
                    variant: 'error'
                }));
            }
        })
        .catch(e => {
            row.error = e?.body?.message || 'Erreur de vérification.';
            this.dispatchEvent(new ShowToastEvent({
                title: 'OTP',
                message: `${row.label}: ${row.error}`,
                variant: 'error'
            }));
        })
        .finally(() => {
            row.verifying = false;
            row.disableVerify = row.verified || row.verifying || row.code.length === 0;
            this.isLoading = false;
            this.otpItems = [...this.otpItems];
        });
    }

    resendForIndex(e) {
        const idx = Number(e.target.dataset.index);
        this.sendOtpForIndex(idx);
    }

    finishSaveAfterOtp() {
        if (!this.allOtpVerified) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'OTP',
                message: 'Veuillez vérifier tous les MDNs avant de sauvegarder.',
                variant: 'warning'
            }));
            return;
        }
        this.showOtpModal = false;
        this.isLoading = true;
        this.SaveToSF();
    }

    closeOtpModal() {
        this.showOtpModal = false;
    }



    handleFileUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            this.imageFileId = uploadedFiles[0].documentId;
            this.imageUrl = `/sfc/servlet.shepherd/document/download/${this.imageFileId}`;
        }
    }

    openModal() {
        if (this.imageUrl) {
            this.isModalOpen = true;
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "No Image Available",
                    message: "Please upload a photo to preview.",
                    variant: "warning"
                })
            );
        }
    }

    closeModal() {
        this.isModalOpen = false;
    }
    
    get currentLocationAsString() {
        return `Lat: ${this.latitude}, Long: ${this.longitude}`;
    }

    SaveToSF() {
        this.isLoading = true;
        console.log('in Save');
        console.log('in before save');
        console.log('imageURL', this.imageUrl);
        console.log('imageFileId', this.imageFileId);

        const statusToSave = this.statusRS || 'inwiCGC_EnCours';
        
        

        RetailStoreRecord({
            recordId: this.recordId,
            firstName: this.FirstName,
            lastName: this.LastName,
            Name: this.AccName,
            ActivityType: this.ActivityType,
            longitude: this.longitude,
            latitude: this.latitude,
            MdnDealer: this.MdnDealer,
            MdnDealer2: this.MdnDealer2,
            isDealer: this.isDealer,
            segmentDealer: this.segmentDealer,
            statusRS: statusToSave,
            contactNumber1: this.contactNumber1,
            contactNumber2: this.contactNumber2,
            IdRVR: this.IdRVR, 
            Region: this.selectedRegion,
            Localisation: this.selectedLocalisation,
            Circuit: this.selectedCircuit,
            isDistributeurAppMobile: this.isDistributeurAppMobile,
            isDealerIdentifier: this.isDealerIdentifier,
            imageUrl: this.imageUrl,
            imageFileId: this.imageFileId,
            distributeur: this.distributeur
        }).then(response => {
            console.log(response);

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    "recordId": response,
                    "objectApiName": "RetailStore",
                    "actionName": "view"
                },
            }, true);
        }).catch(error => {

        let msg = 'Erreur inattendue.';
        if (error && error.body && error.body.message) {
            msg = error.body.message; 
        }

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Erreur',
                message: msg,
                variant: 'error',
                mode: 'dismissable'
            })
        );
    })
    .finally(() => {
        this.isLoading = false;
    });
}

    beginOtpFlow() {
        this.otpQueue = [];
        if (this.MdnDealer)  this.otpQueue.push({ label: 'MDN Dealer', mdn: this.MdnDealer });
        if (this.MdnDealer2) this.otpQueue.push({ label: 'MDN Dealer 2', mdn: this.MdnDealer2 });
        this.otpIndex = 0;
        this.sendCurrentOtp();
    }

    sendCurrentOtp() {
        const current = this.otpQueue[this.otpIndex];
        if (!current) {
            this.showOtpModal = false;
            this.isLoading = true;
            this.SaveToSF();
            return;
        }

        this.isLoading = true;
        this.otpCode = '';
        this.otpMessage = `Envoi du code OTP pour ${current.label} (${current.mdn})...`;

        generateOtpLwc({
            mdn: current.mdn,
            mode: this.otpMode,
            canal: this.otpCanal,
            email: null,
            orderId: null,
            requestResilId: null
        })
        .then(res => {
            if (res?.success) {
                this.otpMessage = res.message || 'Code OTP envoyé. Veuillez le saisir.';
                this.showOtpModal = true;
            } else {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: res?.message || 'Échec d’envoi du code OTP.',
                    variant: 'error'
                }));
            }
        })
        .catch(e => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'OTP',
                message: e?.body?.message || 'Erreur OTP inattendue.',
                variant: 'error'
            }));
        })
        .finally(() => { this.isLoading = false; });
    }

    handleVerifyOtp() {
        const current = this.otpQueue[this.otpIndex];
        if (!current) return;

        if (!this.otpCode) {
            this.dispatchEvent(new ShowToastEvent({
                message: 'Veuillez saisir le code OTP.',
                variant: 'warning'
            }));
            return;
        }

        this.isLoading = true;
        verifyOtpLwc({
            mdn: current.mdn,
            codeOtp: this.otpCode,
            email: null,
            canal: this.otpCanal
        })
        .then(res => {
            if (res?.ok === true) {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: 'Vérification réussie.',
                    variant: 'success'
                }));
                this.showOtpModal = false;
                this.otpIndex += 1; 
                this.sendCurrentOtp(); 
            } else {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'OTP',
                    message: 'Code invalide. Réessayez.',
                    variant: 'error'
                }));
            }
        })
        .catch(e => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'OTP',
                message: e?.body?.message || 'Erreur lors de la vérification.',
                variant: 'error'
            }));
        })
        .finally(() => { this.isLoading = false; });
    }

    handleResendOtp() {
        this.sendCurrentOtp();
    }

    handleCancelOtp() {
        this.showOtpModal = false;
        this.dispatchEvent(new ShowToastEvent({
            title: 'OTP',
            message: 'Vérification annulée.',
            variant: 'info'
        }));
    }

}