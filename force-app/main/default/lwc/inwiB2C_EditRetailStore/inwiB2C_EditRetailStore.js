import { LightningElement, api, track, wire } from 'lwc';
import EditRetailInformations from '@salesforce/apex/inwiB2C_EditRetail_Informations.EditRetailInformations';
import GetRetailStoreInformations from '@salesforce/apex/InwiB2C_RetailStore.GetRetailStoreInformations';
import { NavigationMixin } from "lightning/navigation";
import { getLocationService } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRegions from '@salesforce/apex/InwiB2C_RetailStore.getRegions';
import getLocalisationsByRegion from '@salesforce/apex/InwiB2C_RetailStore.getLocalisationsByRegion';
import getCircuitsByLocalisation from '@salesforce/apex/InwiB2C_RetailStore.getCircuitsByLocalisation';
import getCurrentUserProfileName from '@salesforce/apex/InwiB2C_RetailStore.getCurrentUserProfileName';
import getRVRName from '@salesforce/apex/InwiB2C_RetailStore.getRVRName';
import checkMdnUniqueness from '@salesforce/apex/inwiB2C_EditRetail_Informations.checkMdnUniqueness';
import checkMdnSubscription from '@salesforce/apex/inwiB2C_EditRetail_Informations.checkMdnSubscription';

import generateOtpLwc from '@salesforce/apex/inwiCGC_OTPController.generateOtpLwc';
import verifyOtpLwc   from '@salesforce/apex/inwiCGC_OTPController.verifyOtpLwc';

import checkUserProximity from '@salesforce/apex/inwiB2C_EditRetail_Informations.checkUserProximity';

export default class InwiB2C_EditRetailStore extends NavigationMixin(LightningElement) {
    @api recordId2;
    @track getPrenom;
    @track getNom;
    @track getNomActeurMarche;
    @track getMDNDealer;
    @track getTypeactivite;
    @track getMDNDealer2;
    @track getIsDealer;
    @track getSegment;
    @track getContactNumber1;
    @track getContactNumber2;
    @track selectedCircuit;
    @track selectedLocalisation;
    @track selectedRegion;
    @track isDealerIdentifier;
    @track isDistributeurAppMobile;
    @api isLoading = false;
    @track imageUrl; 
    @track isModalOpen = false;
    @track getDistributeur;
    messageSuccess;
    @track commentRejet = '';


    MdnDealer;
    MdnDealer2;
    
    @track showStatusPicklist = false;
    @track statusRS = 'inwiCGC_EnCours';



    @track regionOptions = [];
    @track localisationOptions = [];
    @track circuitOptions = [];


    rvrId;
    

    @track showOtpModal = false;
    @track otpItems = [];
    otpMode  = 'sms';
    otpCanal = 'CGC';

    get allOtpVerified() {
        return this.otpItems.length > 0 && this.otpItems.every(i => i.verified === true);
    }
    get isSaveDisabled() { return !this.allOtpVerified; }
    get saveOtpButtonLabel() { return this.allOtpVerified ? 'Enregistrer' : 'Vérifier tous puis enregistrer'; }

    @wire(getCurrentUserProfileName)
    wiredProfileName({ error, data }) {
        if (data) {
            if (data === 'CGC_User') {
                this.messageSuccess = 'Veuillez attendre que votre demande de modification soit accepté par votre Manager';
            } else {
                this.messageSuccess = 'Acteur Marché Créé';
            }
        } else if (error) {
            console.error('Error fetching profile name:', error);
            this.messageSuccess = 'Erreur lors de la récupération du profil utilisateur.';
        }
    }
    handleStatusChange(event) {
        this.statusRS = event.target.value;
        console.log('Status ', this.statusRS);
    }
 

 
   get isRejected() {
    return this.statusRS === 'Rejeté' || this.statusRS === 'inwiCGC_Rejete';
   }


    handleContactNumber1Change(event) {
        this.contactNumber1 = event.target.value;
    }
    connectedCallback() {
        this.myLocationService = getLocationService();
        this.loadRetailStoreInformation();

          getCurrentUserProfileName()
                    .then(profileName => {
                        if(profileName === 'CGC_RVR' || profileName === 'CGC_FDV_Manager' || profileName === 'System Administrator') {
                            this.showStatusPicklist = true;
                        }
                    })
                    .catch(error => {
                        console.error('Error retrieving user profile name:', error);
                    });
        

        this.loadRVRName();
        this.loadRegions();
    }

   
    loadRegions() {
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

    normalizeMdn(n) { return (n || '').toString().replace(/\D/g, ''); }

    loadRetailStoreInformation() {
        GetRetailStoreInformations({ recordId2: this.recordId2 })
            .then(response => {
                console.log('storeResponse', response);
                this.getPrenom = response.FirstName;
                this.getNom = response.LastName;
                this.getNomActeurMarche = response.Name;
                this.getMDNDealer = response.MdnDealer;
                this.getTypeactivite = response.TypeActivite;
                this.getIsDealer = response.isDealer;
                this.getMDNDealer2 = response.MdnDealer2;
                this.getSegment = response.Segment;
                this.getContactNumber1 = response.contactNumber1;
                this.getContactNumber2 = response.contactNumber2;
                this.selectedCircuit = response.Circuit;
                this.selectedLocalisation = response.Localisation;
                this.selectedRegion = response.Region;
                this.isDealerIdentifier = response.isDealerIdentifier;
                this.isDistributeurAppMobile = response.isDistributeurAppMobile;
                this.getDistributeur = response.Distributeur;
                this.imageUrl = response.imageUrl;

                this._origMDNDealer  = response.MdnDealer || '';
                this._origMDNDealer2 = response.MdnDealer2 || '';

                this.handleRegionChange({ detail: { value: this.selectedRegion } });
                this.handleLocalisationChange({ detail: { value: this.selectedLocalisation } });
            })
            .catch(error => {
                console.error('Error retrieving retail store information:', error);
            });
    }

     loadRVRName() {
        getRVRName()
            .then(result => {
                console.log('RVR Name:', result);
                this.rvrId = result;
            })
            .catch(error => {
                console.error('Error retrieving RVR Name:', error);
            });
    }  

    handleChange(event) {
        const field = event.target.name;
        if (field === 'Prenom') this.getPrenom = event.target.value;
        if (field === 'Nom') this.getNom = event.target.value;
        if (field === 'NomActeurMarche') this.getNomActeurMarche = event.target.value;
        if (field === 'Typeactivite') this.getTypeactivite = event.target.value;
         if (field === 'IsDealer') {
        this.getIsDealer = event.target.checked;
        if (!this.getIsDealer) {
            this.getMDNDealer = '';
            this.getMDNDealer2 = '';
        }
    }
        if (field === 'MDNDealer') this.getMDNDealer = event.target.value;
        if (field === 'MDNDealer2') this.getMDNDealer2 = event.target.value;
      //  if (field === 'IsDealer') this.getIsDealer = event.target.checked;
        if (field === 'Segment') this.getSegment = event.target.value;
        if (field === 'ContactNumber1') this.getContactNumber1 = event.target.value;
        if (field === 'ContactNumber2') this.getContactNumber2 = event.target.value;
        if (field === 'Region') this.selectedRegion = event.detail.value;
        if (field === 'Localisation') this.selectedLocalisation = event.detail.value;
        if (field === 'Circuit') this.selectedCircuit = event.detail.value;
        if (field === 'isDistributeurAppMobile') this.isDistributeurAppMobile = event.target.checked;
        if (field === 'isDealerIdentifier') this.isDealerIdentifier = event.target.checked;
        if (field === 'Distributeur') this.getDistributeur = event.target.value;
        if (field === 'CommentRejet') {this.commentRejet = event.target.value;}
    }

    handleFileUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.imageFileId = uploadedFiles[0].documentId;
        if (uploadedFiles.length > 0) {
            this.imageUrl = `/sfc/servlet.shepherd/document/download/${uploadedFiles[0].documentId}`;
            this.showToast('Photo uploaded successfully', 'success');
        }
    }

    openModal() {
        if (this.imageUrl) {
            this.isModalOpen = true;
        } else {
            this.showToast('No image available to preview', 'warning');
        }
    }
    
    closeModal() {
        this.isModalOpen = false;
    }
    
    

    handleRegionChange(event) {
        this.selectedRegion = event.detail.value;       

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

    handleLocalisationChange(event) {
        this.selectedLocalisation = event.detail.value;

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

    handleCircuitChange(event) {
        this.selectedCircuit = event.detail.value;
    }



    async handleSave() {
        console.log('handleSave start');
        const mustCheckProximity = true;
        console.log('mustCheckProximity:', mustCheckProximity);

        const getBrowserLocation = () =>
            new Promise((resolve, reject) => {
                if (!navigator.geolocation) {
                    reject(new Error('no geolocation support'));
                    return;
                }
                navigator.geolocation.getCurrentPosition(
                    pos => resolve({ lat: pos.coords.latitude, lon: pos.coords.longitude }),
                    () => reject(new Error('geolocation error'))
                );
            });

        if (mustCheckProximity) {
            try {
                this.isLoading = true;
                const { lat, lon } = await getBrowserLocation();
                console.log('browser location:', lat, lon);
                this.latitude = lat;
                this.longitude = lon;

                const prox = await checkUserProximity({
                    storeId: this.recordId2,
                    userLat: this.latitude,
                    userLon: this.longitude,
                    thresholdMeters: 20
                });
                console.log('checkUserProximity result:', JSON.stringify(prox));

                if (!prox?.ok) {
                    const dist = prox?.distanceMeters != null ? Math.round(prox.distanceMeters) : null;
                    const msg = dist != null
                        ? `Vous êtes à ${dist} m du point de vente (maximum 20 m autorisés).`
                        : (prox?.message || 'Hors zone autorisée.');
                    this.showToast('Vérification de proximité', 'error', msg);
                    this.isLoading = false;
                    console.log('proximity failed, exiting');
                    return;
                }
            } catch (e) {
                this.isLoading = false;
                this.showToast('Localisation', 'error', e.message || 'Impossible de récupérer la position.');
                console.log('error during proximity check', e);
                return;
            } finally {
                this.isLoading = false;
            }
        }

        if (!this.AccName) {
            this.AccName = `${this.getPrenom} ${this.getNom}`;
            console.log('AccName fallback:', this.AccName);
        }

        const missing = [];
        if (!this.getPrenom) missing.push('Prénom');
        if (!this.getNom) missing.push('Nom');
        if (!this.getContactNumber1) missing.push('Numéro de contact');
        if (!this.getTypeactivite) missing.push('Type activité');
        if (!this.selectedRegion) missing.push('Région');
        if (!this.selectedLocalisation) missing.push('Route');
        if (!this.selectedCircuit) missing.push('Circuit');
        console.log('missing fields:', missing);

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

        if (!validNatOr212(this.getContactNumber1)) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Numéro invalide',
                message: 'Utilisez 10 chiffres (0XXXXXXXXX) ou 212XXXXXXXX.',
                variant: 'error'
            }));
            console.log('contact number invalid');
            return;
        }

        if ((this.getMDNDealer && !validNatOr212(this.getMDNDealer)) ||
            (this.getMDNDealer2 && !validNatOr212(this.getMDNDealer2))) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'MDN invalide',
                message: 'MDN doit être 10 chiffres ou 212XXXXXXXX.',
                variant: 'error'
            }));
            console.log('mdn invalid');
            return;
        }

        if (this.getMDNDealer && this.getMDNDealer2 && String(this.getMDNDealer) === String(this.getMDNDealer2)) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Conflit MDN',
                message: 'MDN Dealer 1 et 2 doivent être différents.',
                variant: 'error'
            }));
            console.log('mdn conflict');
            return;
        }

        const mdn1Old = this.normalizeMdn(this._origMDNDealer);
        const mdn2Old = this.normalizeMdn(this._origMDNDealer2);
        const mdn1New = this.normalizeMdn(this.getMDNDealer);
        const mdn2New = this.normalizeMdn(this.getMDNDealer2);

        const mdn1Changed = mdn1Old !== mdn1New;
        const mdn2Changed = mdn2Old !== mdn2New;

        const needsServerValidation = (mdn1Changed && !!mdn1New) || (mdn2Changed && !!mdn2New);

        if (needsServerValidation) {
            this.isLoading = true;
            try {
                const uniq = await checkMdnUniqueness({
                    mdn1: mdn1New || '',
                    mdn2: mdn2New || '',
                    currentStoreId: this.recordId2
                });
                console.log('checkMdnUniqueness:', JSON.stringify(uniq));
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
                    mdn1: mdn1New || '',
                    mdn2: mdn2New || ''
                });
                console.log('checkMdnSubscription:', JSON.stringify(sub));
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
                console.log('error during mdn checks', e);
                this.isLoading = false;
                return;
            }
            this.isLoading = false;
        }

        this.myLocationService = getLocationService();
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    this.latitude = position.coords.latitude;
                    this.longitude = position.coords.longitude;
                    console.log('final save location:', this.latitude, this.longitude);

                    const needsOtp = (mdn1Changed && !!mdn1New) || (mdn2Changed && !!mdn2New);

                    if (needsOtp) {
                        console.log('opening otp modal (changed MDN)');
                        this.openParallelOtpModal();
                    } else {
                        console.log('saving to salesforce directly (no MDN change)');
                        this.isLoading = true;
                        this.saveToSalesforce();
                    }
                },
                () => {
                    this.showToast('Erreur : géolocalisation requise.', 'error', 'Localisation');
                    console.log('geolocation error at final save');
                }
            );
        } else {
            this.showToast('Votre navigateur ne supporte pas la géolocalisation.', 'error', 'Localisation');
            console.log('no geolocation support final save');
        }
        console.log('handleSave end');
    }



     
  
    saveToSalesforce() {
        this.isLoading = true;
        EditRetailInformations({
            paramId: this.recordId2,
            firstName: this.getPrenom,
            lastName: this.getNom,
            AccountName: this.getNomActeurMarche,
            TypeActivite: this.getTypeactivite,
            longitude: this.longitude,
            latitude: this.latitude,
            MdnDealer: this.getMDNDealer,
            IdRVR: this.rvrId,
            MdnDealer2: this.getMDNDealer2,
            isDealer: this.getIsDealer,
            segmentDealer: this.getSegment,
            contactNumber1: this.getContactNumber1,
            contactNumber2: this.getContactNumber2,
            Circuit: this.selectedCircuit,
            Localisation: this.selectedLocalisation,
            Region: this.selectedRegion,
            isDealerIdentifier: this.isDealerIdentifier,
            isDistributeurAppMobile: this.isDistributeurAppMobile,
            imageUrl: this.imageUrl,
            imageFileId: this.imageFileId,
            Distributeur: this.getDistributeur,
            commentRejet: this.commentRejet
    }).then(response => {
            console.log(response);
            this.navigateToRecordPage();
            this.showToast(this.messageSuccess, 'success');
        }).catch(error => {
            console.error('Error saving retail information:', error);
            this.showToast('Error saving retail information', 'error');
        }).finally(() => {
            this.isLoading = false;
        });
    }

    navigateToRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                "recordId": this.recordId2,
                "objectApiName": "RetailStore",
                "actionName": "view"
            },
        });
    }


   showToast(message, variant, title = '') {
    this.dispatchEvent(new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    }));
    }


    openParallelOtpModal() {
        this.otpItems = [];

        const mdn1Old = this.normalizeMdn(this._origMDNDealer);
        const mdn2Old = this.normalizeMdn(this._origMDNDealer2);
        const mdn1New = this.normalizeMdn(this.getMDNDealer);
        const mdn2New = this.normalizeMdn(this.getMDNDealer2);

        const mdn1Changed = mdn1Old !== mdn1New && !!mdn1New;
        const mdn2Changed = mdn2Old !== mdn2New && !!mdn2New;

        if (mdn1Changed) {
            this.otpItems.push({
                key: 'mdn1',
                label: 'MDN Dealer',
                mdn: this.getMDNDealer,
                code: '',
                sent: false,
                verifying: false,
                verified: false,
                error: '',
                labelText: 'Code OTP pour ' + this.getMDNDealer,
                buttonLabel: 'Vérifier ce MDN',
                disableVerify: true
            });
        }
        if (mdn2Changed) {
            this.otpItems.push({
                key: 'mdn2',
                label: 'MDN Dealer 2',
                mdn: this.getMDNDealer2,
                code: '',
                sent: false,
                verifying: false,
                verified: false,
                error: '',
                labelText: 'Code OTP pour ' + this.getMDNDealer2,
                buttonLabel: 'Vérifier ce MDN',
                disableVerify: true
            });
        }

        if (this.otpItems.length === 0) {
            this.saveToSalesforce();
            return;
        }

        this.showOtpModal = true;
        this.sendOtpToAll();
    }


    sendOtpToAll() { this.otpItems.forEach((_, idx) => this.sendOtpForIndex(idx)); }

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
                    this.showToast(`Code envoyé à ${row.mdn}.`, 'success', 'OTP');
                } else {
                    row.error = res?.message || 'Échec d’envoi du code.';
                    this.showToast(`${row.label}: ${row.error}`, 'error', 'OTP');
                }
            })
            .catch(e => {
                row.error = e?.body?.message || 'Erreur OTP inattendue.';
                this.showToast(`${row.label}: ${row.error}`, 'error', 'OTP');
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

        const val = (e.detail?.value ?? e.target?.value ?? '').toString();
        row.code = val.replace(/\D/g, '');

        row.disableVerify = row.verified || row.verifying || row.code.length === 0;
        this.otpItems = [...this.otpItems];
    }

    verifySingleIndex(e) {
        const idx = Number(e.target.dataset.index);
        const row = this.otpItems[idx];
        if (!row) return;

        if (!row.code) {
            this.showToast(`Veuillez saisir le code pour ${row.label}.`, 'warning', 'OTP');
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
                    this.showToast(`${row.label} vérifié.`, 'success', 'OTP');
                } else {
                    row.error = 'Code invalide.';
                    row.disableVerify = row.verifying || row.code.length === 0;
                    this.showToast(`${row.label}: ${row.error}`, 'error', 'OTP');
                }
            })
            .catch(e => {
                row.error = e?.body?.message || 'Erreur de vérification.';
                this.showToast(`${row.label}: ${row.error}`, 'error', 'OTP');
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
            this.showToast('Veuillez vérifier tous les MDNs avant de sauvegarder.', 'warning', 'OTP');
            return;
        }
        this.showOtpModal = false;
        this.isLoading = true;
        this.saveToSalesforce();
    }

    closeOtpModal() { this.showOtpModal = false; }

    
}