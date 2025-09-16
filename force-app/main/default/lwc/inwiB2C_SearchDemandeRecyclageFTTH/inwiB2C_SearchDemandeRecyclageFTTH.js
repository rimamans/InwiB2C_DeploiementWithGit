import { LightningElement,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import getStatutDemande from "@salesforce/apex/StatutLigneDemandeRecycl.getStatutDemande";



export default class InwiB2C_SearchDemandeRecyclageFTTH extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    _actionUtil;
   
    _ns = getNamespaceDotNotation();
    @track optionsArrayOrder= [];
    @track valueOrder;
    @track idOrder;
    @track valueAccount;
    @track idAccount;
    @track optionsArrayAccount= [];
    
    @track valueStatut = '';
    @track valueMotif = '';
    @track statutDemandePicklist = [];
    @track MotifPicklist = [];

    
    //isLoading= false;

/*Recuperer la commande depuis la vip inwib2c_GetLookupForDegroupage*/
handleChangedOrder(event){
    let value= event.target.value; 
    this._actionUtil = new OmniscriptActionCommonUtil();
    //appel a la vip inwib2c_GetLookupForDegroupage 
    const params = {
     input: '{"searchOrder":"'+value+'"}',
     sClassName: `${this._ns}IntegrationProcedureService`,
     sMethodName: "inwib2c_GetLookupForDegroupage",
     options: '{}'
   };
   this._actionUtil
     .executeAction(params, null, this, null, null)
     .then(response => {
       JSON.parse(JSON.stringify(response.result.IPResult));
       let res = response.result.IPResult.ListOrder;
       this.optionsArrayOrder=res ;
  
     })
     .catch(error => {
       
       window.console.log(error);
     });
  }

/*Selectionner la commande depuis le resultat affiché */
  handleSelectOrder(event) {
    this.valueOrder=event.target.dataset.number ;
    this.idOrder = event.target.dataset.id;
    this.optionsArrayOrder = [];
  }

/* Recuperer les noms des client depuis la vip inwib2c_GetLookupForDegroupage*/
  handleChangedAccount(event){
    
    let value= event.target.value; 
    this._actionUtil = new OmniscriptActionCommonUtil();
    // appel a la vip
    const params = {
     input: '{"searchAccount":"'+value+'"}',
     sClassName: `${this._ns}IntegrationProcedureService`,
     sMethodName: "inwib2c_GetLookupForDegroupage",
     options: '{}'
   };
   this._actionUtil
     .executeAction(params, null, this, null, null)
     .then(response => {
       JSON.parse(JSON.stringify(response.result.IPResult));
       let res = response.result.IPResult.List;
       this.optionsArrayAccount=res ;
     })
     .catch(error => {
       
       window.console.log(error);
     });
    
  }
/* Selection un client depuis la liste affiché */
  handleSelectAccount(event) {
    this.valueAccount=event.target.dataset.number ;
    this.idAccount = event.target.dataset.id;
    this.optionsArrayAccount= [];
  }


  /* recuperer les motifs d'echec de la picklist depuis l'objet InwiB2C_Demande_de_recyclage_FTTH__c*/
handleMotifchange(event) {
  //console.log(" Appel à handleMotifchange !");
  this._actionUtil = new OmniscriptActionCommonUtil();
  // appel a la classe apex
  const params = {
      input: "{}",
    sClassName: "inwiB2C_StatutLigneDemandeRecycl",
    sMethodName: "getMotifEchec",
      options: '{}'
  };
  this._actionUtil
      .executeAction(params, null, this, null, null)
      .then(response => {
          
          if (response && response.result) {
              this.MotifPicklist = response.result.motifList;
             
          } else {
              console.error(" Aucune donnée reçue !");
              console.error(" Réponse inattendue :", response);
          }
      })
      .catch(error => {
          console.error("Erreur lors de l'appel Apex :", error);
      });
}
//selectionner une valeur de la liste
handleSelectMotif(event) { 
this.valueMotif = event.detail.value; 

}




/* recuperer les statuts de la picklist depuis l'objet InwiB2C_Demande_de_recyclage_FTTH__c*/
handleStatutchange(event) {
    console.log(" Appel à handleStatutchange !");
    this._actionUtil = new OmniscriptActionCommonUtil();
    // appel a la classe apex
    const params = {
        input: "{}",
      sClassName: "inwiB2C_StatutLigneDemandeRecycl",
      sMethodName: "getStatutDemande",
        options: '{}'
    };
    this._actionUtil
        .executeAction(params, null, this, null, null)
        .then(response => {
           
            if (response && response.result) {
                this.statutDemandePicklist = response.result.statutList;
                
            } else {
                console.error(" Aucune donnée reçue !");
                console.error(" Réponse inattendue :", response);
            }
        })
        .catch(error => {
            console.error("Erreur lors de l'appel Apex :", error);
        });
}
//selectionner une valeur de la liste
handleSelectStatut(event) { 
  this.valueStatut = event.detail.value; 
  console.log("Statut sélectionné :", this.valueStatut);
}

//effectuer la recherche des demandes de recyclage
handleSearch(){
  console.log('debut search' );
  //recuperation des inputs
  let orderId= this.idOrder;
  let motif=this.template.querySelector('[data-id="MotifEchec"]').value;
  let IdClient=this.idAccount;
  let numContact=this.template.querySelector('[data-id="Num contact"]').value;
  let cin=this.template.querySelector('[data-id="CIN"]').value;
  let statutDemande=this.template.querySelector('[data-id="statutDemande"]').value;
  let contRepechage=this.template.querySelector('[data-id="Compteur_repechage"]').value;
  let nd=this.template.querySelector('[data-id="ND"]').value;
 
 //afficher erreur si l'un des champs est vide
 if(!orderId && !motif && !IdClient && !numContact && !cin && !statutDemande && !contRepechage && !nd){
     const event = new ShowToastEvent({
      title: 'Erreur',
      message: 'Attention, vous devez saisir au moins un critère pour la recherche.',
      variant: 'error'
       
   });
 this.dispatchEvent(event);
 
 //this.showErrorToast('Attention, vous devez saisir au moins un critère pour la recherche.');
 //alert('Attention, vous devez saisir au moins un critère pour la recherche.');
 
 
 }else
 if((nd.length !== 12  || !nd.startsWith("212")) && nd){
   // Afficher une notification toast
   this.dispatchEvent(new ShowToastEvent({
    title: 'Erreur',
    message: 'Le numéro doit contenir exactement 12 chiffres et commence par 212.',
    variant: 'error'
}));

 }
 //appeler la classe apex de recherche des demandes de recyclage ftth
 else{
  // this.isLoading=true;
   this._actionUtil = new OmniscriptActionCommonUtil();
   let input = {"InwiB2C_commande__c": orderId,
               "InwiB2C_Motif_d_chec_de_raccordement__c": motif,
               "InwiB2C_client__c": IdClient,
               "InwiB2C_client__r.InwiB2C_Num_ro_de_contact__c": numContact,
               "InwiB2C_client__r.Inwib2c_CIN__c": cin,
               "InwiB2C_Statut__c": statutDemande,
               "InwiB2C_Compteur_de_rep_chage__c": contRepechage,
               "InwiB2C_ND__c":nd
               
            }
          
            //appel a la classe apex
            const params = {
             input: JSON.stringify(input),
             sClassName: 'InwiB2C_DemandeRecyclageFTTHManagement',
             sMethodName: 'searchDemandeRecyclage',
             options: '{}',
           };
           this._actionUtil
           .executeAction(params, null, this, null, null)
           .then(response => {
             
               if (response != null && response.result != null  && response.result.result != null ) {
                 this.omniUpdateDataJson({ 'requestList':response.result.result});
               }
               this.omniNextStep(); 
           })
           .catch(error => {
               console.log('error' + JSON.stringify(error));
               window.console.log(error);
           });
             
       }
       
}

//verifier si le numero de la ligne est valide
handleNDChange(event) {
  const inputElement = event.target;
  const inputValue = inputElement.value;

  // Vérification de la longueur 
  if (inputValue.length !== 12 || isNaN(inputValue) || !inputValue.startsWith("212") ) {
      inputElement.setCustomValidity("Le numéro doit contenir exactement 12 chiffres en commençant avec 212");
      inputElement.reportValidity(); // Affiche le message d'erreur sous l'input

     
  } else {
      inputElement.setCustomValidity(""); // Efface le message d'erreur si valide
      inputElement.reportValidity();
  }
}

}