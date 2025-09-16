/**
 * description : lwc pour le parcours recyclage ftth partie details pour afficher les informations de la demande
 * author : slimani rosa 16/02/2025
 */

import { LightningElement,track,api } from 'lwc';

import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from './inwib2c_DisplayDemandeRecyclageDetails.html';


export default class Inwib2c_DisplayDemandeRecyclageDetails extends OmniscriptBaseMixin(NavigationMixin(LightningElement))  {


   
    // Déclaration des variables avec @track pour assurer leur réactivité
    @track demandeInfos = new Map(); // Stocke les informations récupérées sur la demande 
    @track __OrderNumber; 
    @track __MotifEchec;
    @track __AccountName;
    @track __NumCIN;
    @track __NumContact;
    @track __statutLigne;
    @track __cptRepechage;
    @track __numLigneFTTH; 
    @track __rdv; 
    @track __DateDP; 
    @track __workOrder; 
    @track __workOrderTask; 
    @track __OwnerId; 
    @track __CreatedBy; 
    @track __LastModifiedBy; 
    
    @track __Order;
    @track __Account;
    @track __CreatedById; 
    @track __LastModifiedById; 
    
    __RecycleDisabled = true;
    __CancelDisabled = true;
   
    __demande; // Stocker l'identifiant de la demande
    __comefromdemande; // pour conditionner l'affichage des boutons recycler et annuler
    _actionUtilClass;

@api
    get demande(){
        this.__demande;
    }
    set demande(value){
        this.__demande = value;
       
    }

@api
   set comefromdemande(value) {
    this.__comefromdemande = value;
  
    }
    get comefromdemande() {
        return this.__comefromdemande;   
    }

    
// Méthode appelée après le rendu du composant
renderedCallback() {}

// Définition du template à utiliser pour ce composant
render(){
    return template;
}

// Gestion du bouton précédent pour revenir à l'étape précédente 
handlePrevious() {
    this.omniPrevStep();
}

 // Méthode appelée lors de la connexion du composant
 connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.GetDemandeInfos();
        
}

GetDemandeInfos(){
    
    var inputApex = JSON.stringify({ "demandeId": this.__demande });

   // this._actionUtilClass = new OmniscriptActionCommonUtil();
    const params = {
        input: inputApex,
        sClassName: 'inwib2c_DemandeRecyclageInfo',  // Classe Apex
        sMethodName: 'getDemandeById',  // Méthode Apex à appeler
        options: '{}',
    };
    this._actionUtilClass.executeAction(params, null, this, null, null)
        .then(response => {
            if (response && response.result) {
                this.demandeInfos = new Map(Object.entries(response.result.result));

                 // Extraction des valeurs retournées et assignation aux variables 
                const order = this.demandeInfos.get('InwiB2C_commande__r');
                const Account = this.demandeInfos.get('InwiB2C_client__r');
                const rdv = this.demandeInfos.get('InwiB2C_Id_Rendez_vous__r');
                const LastModifiedBy = this.demandeInfos.get('LastModifiedBy');
                const CreatedBy = this.demandeInfos.get('CreatedBy');

               // Assignation des valeurs avec fallback pour éviter les erreurs
                this.__OrderNumber = order?.OrderNumber || "";
                this.__AccountName = Account?.Name || "";
                this.__NumCIN = Account?.Inwib2c_CIN__c || "";
                this.__NumContact = Account?.InwiB2C_Num_ro_de_contact__c || "";
                this.__rdv = rdv?.inwiB2C_Date_RDV__c || "";
                this.__LastModifiedBy = LastModifiedBy?.Name || "";
                this.__CreatedBy = CreatedBy?.Name || "";

                this.__MotifEchec = this.demandeInfos.get('InwiB2C_Motif_d_chec_de_raccordement__c');
                this.__statutLigne = this.demandeInfos.get('InwiB2C_Statut__c');
                this.__cptRepechage = this.demandeInfos.get('InwiB2C_Compteur_de_rep_chage__c');
                this.__numLigneFTTH = this.demandeInfos.get('InwiB2C_ND__c');
                this.__DateDP = this.demandeInfos.get('InwiB2C_Date_debut_planifiee__c');
                this.__workOrder = this.demandeInfos.get('InwiB2C_work_order_Id__c');
                this.__workOrderTask = this.demandeInfos.get('InwiB2C_Workordertask_Id__c');
                this.__Order = this.demandeInfos.get('InwiB2C_commande__c');
                this.__Account = this.demandeInfos.get('InwiB2C_client__c');
                this.__CreatedById = this.demandeInfos.get('CreatedById');
                this.__LastModifiedById = this.demandeInfos.get('LastModifiedById');

                
                if(this.__statutLigne == "A recycler" && this.__comefromdemande == true){
                    
                    this.__RecycleDisabled = false;
                    this.__CancelDisabled = false;
                }


            } else {
                this._actionUtilClass.showToast('Erreur lors de la récupération de la demande', 'Error', 'error');
                console.log("ErrorResponse1");
            }
        })
        .catch(error => {
            console.error('Erreur lors de la création de l\'interaction:', error);
            this._actionUtilClass.showToast('Erreur lors de l\'interaction', 'Error', 'error');
            console.log("ErrorResponse2");
        });

        
}


// Génération des URL dynamiques vers les objets Salesforce
get urlOrder() {
    return this.__Order ? `/lightning/r/Order/${this.__Order}/view` : "";
}

get urlCompte() {
    return this.__Account ? `/lightning/r/Account/${this.__Account}/view` : "";
}

get urlCreatedBy() {
    return this.__CreatedById ? `/lightning/r/User/${this.__CreatedById}/view` : "";
}

get urlModifiedBy() {
    return this.__LastModifiedById ? `/lightning/r/User/${this.__LastModifiedById}/view` : "";
}

//bouton recycler
handleRecycle(){
     const action = 'recycle';
    this.omniUpdateDataJson({ 'action':action});
    this.omniUpdateDataJson({ 'orderNumber': this.__OrderNumber});
    this.omniNextStep();

}
//bouton annuler
handleCancel(){
    const action = 'cancel';
    this.omniUpdateDataJson({ 'action':action});
    this.omniUpdateDataJson({ 'orderNumber': this.__OrderNumber});
    this.omniNextStep();

}
   // Affichage d'un message toast
showMessage(t, m, type) {
    const toastEvt = new ShowToastEvent({
        title: t,
        message: m,
        variant: type
    });
    this.dispatchEvent(toastEvt);
}

}