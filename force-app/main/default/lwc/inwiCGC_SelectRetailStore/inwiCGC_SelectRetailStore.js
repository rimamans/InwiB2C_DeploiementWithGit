import { LightningElement, track, api } from 'lwc';
import getUsers from '@salesforce/apex/InwiCGC_GetUsersList.getUsers';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getCloseRetailStores from '@salesforce/apex/InwiCGC_GetUsersList.getCloseRetailStores';
import getActionPlanByVisitId from '@salesforce/apex/InwiCGC_CloneVisit.getActionPlanByVisitId';

import { NavigationMixin } from "lightning/navigation";
import { getLocationService } from 'lightning/mobileCapabilities';

import cloneVisitAndAssignRetailStore from '@salesforce/apex/InwiCGC_CloneVisit.cloneVisitAndAssignRetailStore';
import getVisitStatus from '@salesforce/apex/InwiCGC_GetUsersList.getVisitStatus';


export default class InwiCGC_SelectRetailStore extends LightningElement {
    @track showModal = false;
    @api recordId;
    @track selectedUserId;
    @track isDisabled = true;
    myLocationService;
    @api recordpage_display;
    @track isLoading = false;
    @track showRSModal = false;
    @track loadingMessage = '';
    @track addresses = [];
    showButton = true;


    visitPage = this.recordId

    openCreateRetailStoreModal() {
        this.showRSModal = true;
        this.showModal = false;
    }

    closeCreateRetailStoreModal() {
        this.showRSModal = false;
        this.showModal = true;
    }


    latitude = 0;
    longitude = 0;
    
    openModal() {
        console.log('Fetching Action Plan for Visit ID:', this.recordId);
    
        getActionPlanByVisitId({ recordId: this.recordId })
            .then((actionPlan) => {
                console.log('Received Action Plan:', actionPlan);
                if (actionPlan && actionPlan.Id) {
                    console.log('Action Plan found:', actionPlan);
                    this.showModal = true;
                } else {
                    console.log('No Action Plan found.');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Action Plan Absent',
                            message: 'Veuillez assigner un plan d\'action afin de continuer.',
                            variant: 'error'
                        })
                    );
                }
            })
            .catch((error) => {
                console.error('Error fetching Action Plan:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération du plan d\'action.',
                        variant: 'error'
                    })
                );
            });
    }

    closeModal() {
        this.showModal = false;
    }

    connectedCallback() {
        this.myLocationService = getLocationService();
        this.fetchCurrentLocation();
        this.visitStatus();
    }

    visitStatus(){
        getVisitStatus({ visitId: this.recordId })
            .then(result =>{
                console.log('result :' , result)
                if(result == 'Completed'){
                    this.showButton = false;
                } else {
                    this.showButton = true;
                }
            })
            
    }

    fetchCurrentLocation() {
        if (navigator.geolocation) {
            this.loadingMessage = 'Chargement en cours...';
            navigator.geolocation.getCurrentPosition((position) => {
              this.latitude = position.coords.latitude;
              this.longitude = position.coords.longitude;
              this.fetchAddresses();
              console.log('my coordinates: lat:', this.latitude, 'long:', this.longitude)
            },
            () => {
                this.loadingMessage = 'Erreur lors de la récupération de la position.';
            }
        );
          } else {
            console.log("Error");
            this.loadingMessage = "Le service de géolocalisation n'est pas disponible.";
          }
    }

    fetchAddresses() {
        getCloseRetailStores({ longitude: this.longitude, latitude: this.latitude })
        .then(result => {
            if (result.length > 0) {
            this.addresses = result.map(address => ({
                ...address,
                displayName: `${address.Name} (${this.formatDistance(address.expr0)})`
            }));
            this.loadingMessage = ''; 
            this.isDisabled = true;
        } else {
            this.loadingMessage = 'Aucun point de vente trouvé à proximité.';
        }
        })
            .catch(error => {
                console.error('Error:', error);
            });

    }

    formatDistance(distance) {
        if (distance < 1.0) {
            return Math.round(distance * 1000) + ' m';
        } else {
            return (Math.round(distance * 10) / 10).toFixed(1) + ' km';
        }
    }


    handleRadioChange(event) {
        const selectedAddressId = event.target.value;
        this.addresses = this.addresses.map(address => ({
            ...address,
            selected: address.Id === selectedAddressId
        }));
        this.isDisabled = !this.anyCheckboxSelected();
    }
    
    anyCheckboxSelected() {
        return this.addresses.some(address => address.selected);
    }
    

    handleOkClick() {
        this.isLoading = true;
        this.isDisabled= true;
        const selectedAddress = this.addresses.find(address => address.selected);
        console.log('adresses:', selectedAddress.expr0)
        console.log('my coordinates: lat:', this.latitude, 'long:', this.longitude)
         
        if (selectedAddress) {
            cloneVisitAndAssignRetailStore({ recordId: this.recordId, retailStoreId: selectedAddress.Id })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Visite dupliquée et assignée au point de vente sélectionné',
                        variant: 'success'
                    }),
                );
                this.isDisabled = false
                this.isLoading = false;
                this.closeModal();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error cloning visit',
                        message: error.body.message,
                        variant: 'error'
                    }),
                );
                this.isDisabled = true
                this.isLoading = false;
            });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Selection Error',
                    message: 'selectionnez un point de vente',
                    variant: 'warning'
                }),
            );
        }
    }
        
}