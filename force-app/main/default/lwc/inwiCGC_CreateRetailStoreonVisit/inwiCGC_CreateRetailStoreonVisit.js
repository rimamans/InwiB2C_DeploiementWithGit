import { LightningElement, api, track } from 'lwc';
import RetailStoreRecord from '@salesforce/apex/InwiB2C_RetailStore.RetailStoreRecord';
import { NavigationMixin } from "lightning/navigation";
import { getLocationService } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cloneVisitAndAssignNewRetailStore from '@salesforce/apex/InwiB2C_RetailStore.cloneVisitAndAssignNewRetailStore';
import getRVRName from '@salesforce/apex/InwiB2C_RetailStore.getRVRName';
import getRegions from '@salesforce/apex/InwiB2C_RetailStore.getRegions';
import getLocalisationsByRegion from '@salesforce/apex/InwiB2C_RetailStore.getLocalisationsByRegion';
import getCircuitsByLocalisation from '@salesforce/apex/InwiB2C_RetailStore.getCircuitsByLocalisation';

export default class InwiCGC_CreateRetailStoreonVisit extends NavigationMixin(LightningElement) {
    handleCancel() {
        const closeModalEvent = new CustomEvent('closemodal');
        this.dispatchEvent(closeModalEvent);
    }

    @track FirstName = '';
    @track LastName = '';
    @track AccName = '';
    @track ActivityType = '';
    @api isLoading = false;
    MdnDealer;
    MdnDealer2;
    @track isDealer = false;
    @track segmentDealer = '';
    @track contactNumber1 = '';
    @track contactNumber2 = '';
    @track selectedCircuit = '';
    @track selectedLocalisation = '';
    @api recordId;
    myLocationService;
    @api visitPage;
    @track distributeur = '';

    @track regionOptions = [];
    @track localisationOptions = [];
    @track circuitOptions = [];
    // @track localisationOptions = [
    //     { label: 'RTM Urbaine', value: 'RTMU' },
    //     { label: 'RTM Rural', value: 'RTMR' },
    //     { label: 'RTM Semi Urbain', value: 'SEMI_URBAIN' }
    // ];

    @track isDealerIdentifier = false;
    @track isDistributeurAppMobile = false;
    selectedRegion;

    @track isModalOpen = false;
    @track imageUrl;
    imageFileId;


    myLocationService;


    latitude = 0;
    longitude = 0;

    
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

    handleCircuitChange(event) {
        this.selectedCircuit = event.detail.value;
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
        this.myLocationService = getLocationService();
        this.disablePullToRefresh();

        console.log("new rs visitpage", this.visitPage);
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
    
    handleSave() {
        console.log('handleSave called');
        console.log('ActivityType:', this.ActivityType);

        if (!this.AccName) {
            this.AccName = `${this.FirstName} ${this.LastName}`;
            console.log('AccName was empty, set to:', this.AccName);
        }    
        
        if (this.FirstName && this.LastName && this.ActivityType && (!this.isDealer ||  (this.isDealer && this.segmentDealer))) {
            console.log('All required fields are filled');
            
            if (navigator.geolocation) {
                console.log('Navigator supports geolocation');
                
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        console.log('Geolocation success');
                        this.latitude = position.coords.latitude;
                        this.longitude = position.coords.longitude;
                        
                        let tel = this.template.querySelector(`[data-theid="Tel"]`).value;
                        if (tel && tel.length !== 10) {
                            console.log('Invalid phone number length');
                            const event = new ShowToastEvent({
                                message: 'Attention, le numéro de téléphone doit contenir 10 chiffres',
                                variant: 'error',
                                mode: 'dismissable'
                            });
                            this.dispatchEvent(event);
                            this.isLoading = false;
                        } else {
                            console.log('Phone number valid, calling SaveToSF');
                            this.SaveToSF();
                            this.isLoading = true;
                        }
                    },
                    (error) => {
                        console.error('Geolocation error:', error);
                        if (error.code === error.PERMISSION_DENIED || this.latitude == null || this.longitude == null) {
                            const event = new ShowToastEvent({
                                message: 'Localisation non partagée, veuillez activer la localisation pour continuer',
                                variant: 'error',
                                mode: 'dismissable'
                            });
                            this.dispatchEvent(event);
                        } else {
                            const event = new ShowToastEvent({
                                message: `Geolocation error: ${error.message}`,
                                variant: 'error',
                                mode: 'dismissable'
                            });
                            this.dispatchEvent(event);
                        }
                        this.isLoading = false;
                    },
                    {
                        timeout: 10000
                    }
                );
            } 
        } else {
            console.error('All fields are required');
            const event = new ShowToastEvent({
                message: 'Veuillez remplir tous les champs avant d\'enregistrer.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
        
    }


    get currentLocationAsString() {
        return `Lat: ${this.latitude}, Long: ${this.longitude}`;
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

    SaveToSF() {
        this.isLoading = true;
    
        RetailStoreRecord({
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
        })
        .then(newRetailStoreId => {
            cloneVisitAndAssignNewRetailStore({ 
                recordId: this.visitPage,
                retailStoreId: newRetailStoreId
            })
            .then(clonedVisitId => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Visite dupliquée et assignée au point de vente créé',
                        variant: 'success'
                    }),
                );
                this.FirstName = '';
                this.LastName = '';
                this.AccName = '';
                this.ActivityType = '';
                this.isLoading = false;
                this.MdnDealer = '';
                this.MdnDealer2 = '';
                this.isDealer = false;
                this.segmentDealer = '';
                this.contactNumber1 = '';
                this.contactNumber2 = '';
                this.IdRVR = '';
                console.log('cloned visit id', clonedVisitId);
                console.log('new retail store id', newRetailStoreId);

                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error cloning visit',
                        message: error.body.message,
                        variant: 'error'
                    }),
                );
                console.log('error in Save', error);
                this.isLoading = false;
            });
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error cloning visit',
                    message: error.body.message,
                    variant: 'error'
                }),
            );
            console.log('error in Save', error);
            this.isLoading = false;
        });
    }
    
}