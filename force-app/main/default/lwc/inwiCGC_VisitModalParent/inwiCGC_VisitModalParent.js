import { LightningElement, track, wire, api } from 'lwc';
import getUsers from '@salesforce/apex/InwiCGC_GetUsersList.getUsers';
import cloneVisitForUsers from '@salesforce/apex/InwiCGC_CloneVisit.cloneVisitForUsers';
import checkManagerProfileAndRole from '@salesforce/apex/InwiCGC_GetUsersList.checkManagerProfileAndRole';
import getActionPlanByVisitId from '@salesforce/apex/InwiCGC_CloneVisit.getActionPlanByVisitId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import USER_ID from '@salesforce/user/Id';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
import getVisitStatus from '@salesforce/apex/InwiCGC_GetUsersList.getVisitStatus';




export default class InwiCGC_VisitModalParent extends LightningElement {
    @track showModal = false;
    @api recordId;
    @api selectedUserIds;
    @track users;
    @track isDisabled = true;
    @api recordpage_display;
    @track isLoading = false;
    @track showButton = true;

    @wire(checkManagerProfileAndRole)
    wiredActivities({ error, data }) {
        if (data) {
            this.showButton = false;
        } else if (error) {
            console.error('Error fetching manager profile and role:', error);
        }
    }


    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
    currentUser;
    currentUserId = USER_ID;

    get userName() {
        return getFieldValue(this.currentUser.data, NAME_FIELD);
    }

    

    openModal() {
        console.log('Fetching Action Plan for Visit ID:', this.recordId);
    
        getActionPlanByVisitId({ recordId: this.recordId })
            .then((actionPlan) => {
                console.log('Received Action Plan:', actionPlan);
                if (actionPlan && actionPlan.Id) {
                    console.log('Action Plan found:', actionPlan);
                    this.showModal = true;
                    this.fetchUsers();
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
        console.log('Current User Name:', this.userName);
        console.log('Current User ID:', this.currentUserId);
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

    handleCheckboxChange(event) {
        const userId = event.target.value;
        const isChecked = event.target.checked;
    
        this.users = this.users.map(user => {
            if (user.Id === userId) {
                return { ...user, isChecked };
            }
            return user;
        });
    
        this.isDisabled = !this.anyCheckboxSelected();
    }
    
    anyCheckboxSelected() {
        return this.users.some(user => user.isChecked);
    }
    
    handleOkClick() {
        this.isLoading = true;
        this.isDisabled= true;
        console.log('Current Visit ID:', this.recordId);

        const selectedUsers = this.users.filter(user => user.isChecked);

        const selectedUserIds = selectedUsers.map(user => user.Id);
        console.log(' - Clone to Users: ', selectedUserIds);

        cloneVisitForUsers({ recordId: this.recordId, selectedUserIds: selectedUserIds })
        .then(() => {
            console.log('Visit cloned successfully');
            this.dispatchEvent(
                new ShowToastEvent({
                title: 'Success ' ,
                message: 'La duplication de la visite à réussi',
                variant: 'success'
                }),
            );
            this.isLoading = true;
            this.isDisabled= true;
            this.closeModal();
        })
        .catch(error => {
            console.error('Error in cloning visit:', error);

            this.dispatchEvent(
                new ShowToastEvent({
                title: 'Erreur ' ,
                message: 'Erreur lors de la duplication de la visite',
                variant: 'error'
                }),
            );
            this.isLoading = true;
            this.isDisabled= true;
        });
    }
 
}