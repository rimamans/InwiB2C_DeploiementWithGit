import { LightningElement, track, wire, api } from 'lwc';
import getUsers from '@salesforce/apex/InwiCGC_GetUsersList.getUsers';
import getProfile from '@salesforce/apex/InwiCGC_GetUsersList.getProfile';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import assignVisitForUsers from '@salesforce/apex/InwiCGC_AssignUser.assignVisitForUsers';
import getVisitStatus from '@salesforce/apex/InwiCGC_GetUsersList.getVisitStatus';

export default class InwiCGC_AssignVisitModal extends LightningElement {
    @track showModal = false;
    @api recordId;
    @track selectedUserId;
    @track users;
    @track isDisabled = true;
    @api recordpage_display;
    @track isLoading = false;
    showButton = true;

    error;
    wiredActivities;

    @wire(getProfile)
    wiredActivities({ error, data }) {
        if (data){
        console.log('Data==> '+JSON.stringify(data));        

        this.data = data;
        if(this.data == 'CGC_User'){
            this.showButton = false;
        }else{
            this.showButton = true;
        }

        console.log(this.data);
        this.error = undefined;

        } else if (error) {
        this.error = error;
        this.data = undefined;
       }
    }

    connectedCallback(){
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
    
    openModal() {
        this.showModal = true;
        this.fetchUsers();
        console.log('Current record ID:', this.recordId); 
    }

    closeModal() {
        this.showModal = false;
    }

    fetchUsers() {
        getUsers({ recordId: this.recordId })
            .then(result => {
                this.users = result;
                this.isDisabled = true;
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    handleRadioChange(event) {
        const selectedUserId = event.target.value;
        this.users = this.users.map(user => ({
            ...user,
            selected: user.Id === selectedUserId
        }));
        this.isDisabled = !this.anyCheckboxSelected();
    }

    anyCheckboxSelected() {
        return this.users.some(user => user.selected);
    }

    handleOkClick() {
        this.isLoading = true;
        this.isDisabled= true;
        console.log('Current Visit ID:', this.recordId);

        const selectedUser = this.users.find(user => user.selected);

        if (selectedUser) {
            console.log('Assigning Visit to User: ', selectedUser.Id);
    
            assignVisitForUsers({ recordId: this.recordId, selectedUserId: selectedUser.Id })
            .then(() => {
                console.log('Visit assigned successfully');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: "L'assignation de la visite a réussi",
                        variant: 'success'
                    }),
                );
                this.isDisabled = false
                this.isLoading = false;
                this.closeModal();

                setTimeout(() => {
                    window.location.reload();
                }, 1500);
  
            })
            .catch(error => {
                console.error('Error in assigning visit:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: "Erreur lors de l'assignation de la visite",
                        variant: 'error'
                    }),
                );
                this.isDisabled = true
                this.isLoading = false;
            });
        } else {
            console.log('aucun user selectionné');
        }

    }
 
}