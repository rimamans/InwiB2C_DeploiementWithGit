import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createUser from '@salesforce/apex/UserController.createUser';
import assignPermissionSets from '@salesforce/apex/UserController.assignPermissionSets';
import assignPermissionSetLicenses from '@salesforce/apex/UserController.assignPermissionSetLicenses';
import createContact from '@salesforce/apex/UserController.createContact';
import updateAccountContactRelation from '@salesforce/apex/UserController.updateAccountContactRelation';
import addUserToQueue from '@salesforce/apex/UserController.addUserToQueue';
import getAgenceQueueName from '@salesforce/apex/UserController.getAgenceQueueName';
import { NavigationMixin } from 'lightning/navigation'; // renvoyer vers d'autre page 



export default class ParentComponent extends NavigationMixin(LightningElement) {
    @track selectedType = '';
    @track distributorId = '';
    @track showHelloWorld = true;
    @track showDistributeur = false;
    @track showSection3 = false;
    @track helloWorldValidated = false;
    @track distributeurValidated = false;
    @track Error = '';
    @track agenceId;
    @track agenceName;
    @track nom = '';
    @track prenom = '';
    @track civilite = '';
    @track email = '';
    @track username = '';
    @track produit = [];


    handleTypeChange(event) {
        this.selectedType = event.detail; // Récupère le type d'utilisateur sélectionné
        console.log('Selected Type in handleTypeChange:', this.selectedType);
        this.template.querySelector('c-agence').reset();
        this.agenceId = '';
        console.log('Agence in handleTypeChange:', this.agenceId);

    }


    lookupUpdatehandler(event) {
        const detail = event.detail;
        this.distributorId = detail ? detail : ''; // Set to empty string if distributor is removed
        this.Error = '';
        console.log('distributeur in lookupUpdatehandler:', this.distributorId);

        this.template.querySelector('c-agence').reset();
        this.agenceId = '';
    }

    lookupUpdatehandlerAgence(event) {
        const detail = event.detail;
        this.agenceId = detail ? detail : '';
        console.log('Agence in handleAgenceChange:', this.agenceId);
    }

    handleCancel() {
        this.resetForm(); // Réinitialiser le formulaire
    }

    handleSave() {
        this.handleSaveUsersContact()
            .then(contactId => {
                // Rediriger vers la page de contact
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: contactId,
                        objectApiName: 'Contact',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                console.error('Error during saving and creating a new user: ', error);
            });
    }

    handleSaveAndNew() {
        this.handleSaveUsersContact()
            .then(() => {
                this.resetForm(); // Réinitialiser le formulaire après la sauvegarde
            })
            .catch(error => {
                console.error('Error during saving and creating a new user: ', error);
            });
    }

    handleSaveUsersContact() {
        const agenceComponent = this.template.querySelector('c-agence');
        const isAgenceValid = agenceComponent && agenceComponent.validateLookup();

        const distributeurComponent = this.template.querySelector('c-distributeur');
        const isDistributeurValid = distributeurComponent && distributeurComponent.validateLookup();

        const typeUserComponent = this.template.querySelector('c-type-user');
        const isTypeUserValid = typeUserComponent && typeUserComponent.validateType();

        const contactUserComponent = this.template.querySelector('c-information-contact-user');
        const isContactUserValid = contactUserComponent && contactUserComponent.validateFields();

        if (!isAgenceValid || !isDistributeurValid || !isTypeUserValid || !isContactUserValid) {
            this.showToast('Error', 'Please complete all fields', 'error');
        }

        this.showForm = false; // Masquer le formulaire après avoir sauvegardé
        this.showToast('Info', `Selected Type: ${this.selectedType}`, 'info');
        console.log('Selected Type in handleSave:', this.selectedType);
        let userId; // Déclaration de userId pour qu'il soit accessible dans toute la méthode handleSave
        let contactId;

        if (this.selectedType === 'Livreur' || this.selectedType === 'Animateur') {
            return createUser({
                username: this.username,
                firstName: this.nom,
                lastName: this.prenom,
                email: this.email,
                profileName: 'CGC_User',
                contactId: null
            })
                .then(result => {
                    userId = result;
                    let permSetLicenseNames = ['ActionPlansPsl','IndustriesVisitPsl', 'LightningRetailExecutionStarterPsl', 'SFMaps_Maps_Advanced', 'SFMaps_Maps_LiveMobileTracking'];
                    return assignPermissionSetLicenses({ permSetLicenseNames: permSetLicenseNames, userId: userId });
                }).then(() => {
                    let permSetNames = ['ActionPlans','LightningRetailExecutionStarterPsl','CGCloud_Mobility_Addon','CGCloud_Sales_User','Sync_User', 'MapsUser','Advanced','LiveMobile'];

                    if (this.selectedType === 'Livreur') {
                        permSetNames.push('fdvlivreuradsl');
                    }

                    for (let item of this.produit) {
                        if (this.selectedType === 'Animateur' && item === 'ADSL') {
                            permSetNames.push('fdvanimateuradsl');
                        } else if (this.selectedType === 'Animateur' && item === 'FTTH') {
                            permSetNames.push('fdvanimateurftth');
                        }
                    }

                    return assignPermissionSets({ permSetNames: permSetNames, userId: userId });
                })
                .then(() => {
                    this.showToast('Success', 'User"' + this.nom + this.prenom + '"with permissions created ', 'success');
                    return createContact({
                        civilite: this.civilite,
                        firstName: this.nom,
                        lastName: this.prenom,
                        email: this.email,
                        userId: userId,
                        accountId: this.agenceId,
                        inwiCGC_UserCGC__c: userId
                    });
                })
                .then(result => {
                    contactId = result;
                    this.showToast('Success', 'Contact"' + this.nom + this.prenom + '"created and related to AGENCE', 'success');

                    if (this.selectedType === 'Livreur') {
                        return updateAccountContactRelation({
                            contactId: contactId,
                            accountId: this.agenceId,
                            role: 'inwiB2C_ChefEquipe'
                        });
                    }
                })
                .then(() => {
                    return contactId;
                })
                .catch(error => {
                    if (error.body && error.body.message.includes('DUPLICATE_USERNAME')) {
                        this.showToast('Error', 'the username already exists, please use another one', 'error');
                    
                    }
                    else if (error.body && error.body.message.includes('INVALID_EMAIL_ADDRESS')) {
                        this.showToast('Error', ' invalid format for Username', 'error');
                    }
                     else {
                        this.showToast('Error', 'Erreur lors de la création de l\'utilisateur ou de l\'attribution des permissions : ' + (error.body ? error.body.message : error.message), 'error');
                    }
                    console.error('Erreur lors de la création de l\'utilisateur ou de l\'attribution des permissions : ', error);
                    throw error;
                });
        } else if (this.selectedType === 'Utilisateur BO') {
            return createContact({
                civilite: this.civilite,
                firstName: this.nom,
                lastName: this.prenom,
                email: this.email,
                userId: userId,
                accountId: this.agenceId,
                inwiCGC_UserCGC__c: null
            })
                .then(result => {
                    contactId = result;
                    this.showToast('Success', 'Contact"' + this.nom + this.prenom + '"created successfully', 'success');
                    return createUser({
                        username: this.username,
                        firstName: this.nom,
                        lastName: this.prenom,
                        email: this.email,
                        profileName: 'BackOffice Distributeur D2D',
                        contactId: contactId
                    });
                })
                .then(result => {
                    userId = result;
                    return getAgenceQueueName({ agenceId: this.agenceId });
                })
                .then(queueName => {
                    if (queueName) {
                        return addUserToQueue({
                            userId: userId,
                            queueName: queueName
                        });
                    } else {
                        throw new Error('Aucun nom de file d\'attente trouvé pour l\'agence spécifiée.');
                    }
                })
                .then(() => {
                    this.showToast('Success', 'User"' + this.nom + this.prenom + '"created and added to Queue', 'success');
                    return contactId;
                })
                .catch(error => {
                    if (error.body && error.body.message.includes('DUPLICATE_USERNAME')) {
                        this.showToast('Error', 'the username already exists, please use another one', 'error');
                    }
                    else if (error.body && error.body.message.includes('INVALID_EMAIL_ADDRESS')) {
                        this.showToast('Error', ' invalid format for Email', 'error');
                    }
                    else if (error.body && error.body.message.includes('FIELD_INTEGRITY_EXCEPTION')) {
                        this.showToast('Error', ' invalid format for Username', 'error');
                    }
                     else {
                        this.showToast('Error', 'Erreur lors de la création de l\'utilisateur ou de l\'attribution des permissions : ' + (error.body ? error.body.message : error.message), 'error');
                    }
                    console.error('Erreur lors de la création de l\'utilisateur ou de l\'ajout a la queu: ', error);
                    throw error;
                });
        }
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    handleNomUpdate(event) {
        this.nom = event.detail;
    }

    handlePrenomUpdate(event) {
        this.prenom = event.detail;
    }

    handleCiviliteUpdate(event) {
        this.civilite = event.detail;
    }

    handleEmailUpdate(event) {
        this.email = event.detail;
    }

    handleUsernameUpdate(event) {
        this.username = event.detail;
    }

    handleProduitUpdate(event) {
        this.produit = event.detail;
    }

    resetForm() {
        // Réinitialiser toutes les valeurs des champs
        this.nom = '';
        this.prenom = '';
        this.civilite = '';
        this.email = '';
        this.username = '';
        this.produit = [];
        this.selectedType = '';
        this.distributorId = '';
        this.agenceId = '';

        // Réinitialiser les composants enfants
        this.template.querySelectorAll('c-agence, c-distributeur, c-type-user, c-information-contact-user').forEach(cmp => {
            if (cmp.reset) {
                cmp.reset();
            }
        });

        // Ajouter la classe pour l'effet visuel
        this.formReset = true;
        setTimeout(() => {
            this.formReset = false;
        }, 5000); // Durée de l'effet visuel (1.5 secondes)
    }
}