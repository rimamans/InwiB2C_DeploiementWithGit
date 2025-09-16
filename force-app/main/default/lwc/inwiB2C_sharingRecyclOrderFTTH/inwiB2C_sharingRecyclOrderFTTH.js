import { LightningElement,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import getStatutDemande from "@salesforce/apex/StatutLigneDemandeRecycl.getStatutDemande";



export default class InwiB2C_sharingRecyclOrderFTTH extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    _actionUtil;
    _actionUtilClass;
    _ns = getNamespaceDotNotation();
    @track optionsArrayOrder= [];
    @track valueOrder;
    @track idOrder;
    @track valueAccount;
    @track idAccount;
    @track optionsArrayAccount= [];
    
    @track valueStatut = '';
    @track statutDemandePicklist = [];

    
    isLoading= false;

/*Recuperer la commande depuis la vip inwib2c_GetLookupForDegroupage*/
handleChangedOrder(event){
    let value= event.target.value; 
    this._actionUtil = new OmniscriptActionCommonUtil();
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
       console.log("error");
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
    console.log("Réponse trrt ");
    let value= event.target.value; 
    this._actionUtil = new OmniscriptActionCommonUtil();
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
       console.log("error");
       window.console.log(error);
     });
    
  }
/* Selection un client depuis la liste affiché */
  handleSelectAccount(event) {
    this.valueAccount=event.target.dataset.number ;
    this.idAccount = event.target.dataset.id;
    this.optionsArrayAccount= [];
  }

/*connectedCallback() {
  getStatutDemande().
  then(result => {
    this.statutDemandePicklist = result.map(item => ({
      label: item,
      value: item
    }));
  }).
  catch(error => {
    this.statutDemandePicklist = undefined;
  } );
}*/
 handlepicklistchange(event) {
    console.log(" Appel à handlepicklistchange !");
    this._actionUtil = new OmniscriptActionCommonUtil();
    const params = {
        input: "{}",
      sClassName: "inwiB2C_StatutLigneDemandeRecycl",
      sMethodName: "getStatutDemande",
        options: '{}'
    };
    this._actionUtil
        .executeAction(params, null, this, null, null)
        .then(response => {
            console.log(" Réponse reçue :", response);
            if (response && response.result) {
                this.statutDemandePicklist = response.result.statutList;
                console.log(" Liste des statuts mis à jour :", this.statutDemandePicklist);
            } else {
                console.error(" Aucune donnée reçue !");
                console.error(" Réponse inattendue :", response);
            }
        })
        .catch(error => {
            console.error("Erreur lors de l'appel Apex :", error);
        });
}

handleSelectPicklist(event) { 
  this.valueStatut = event.detail.value; 
  console.log("Statut sélectionné :", this.valueStatut);
}

/* recuperer les valeurs de la picklist depuis l'objet InwiB2C_Demande_de_recyclage_FTTH__c




get statutDemandePicklist(){
  return [
    { label: 'A recycler', value: 'A recycler' },
    { label: 'recyclée', value: 'recyclée' },
    { label: 'annulée', value: 'annulée' },
];
}*/

handleSearch(){
  console.log('debut search' );
  //recuperation des inputs
  let orderId= this.idOrder;
  let motif=this.template.querySelector('[data-id="MotifEchec"]').value;
  let IdClient=this.idAccount;
  let numContact=this.template.querySelector('[data-id="Num contact"]').value;
  let cin=this.template.querySelector('[data-id="CIN"]').value;
  let statutDemande=this.template.querySelector('[data-id="statutDemande"]').value;
  let contRepechage=this.template.querySelector('[data-id="Compteur_repéchage"]').value;
  console.log('champs bien recuperer'+orderId );
 //afficher erreur si l'un des champs est vide
 if(!orderId && !motif && !IdClient && !numContact && !cin && !statutDemande && !contRepechage){
     const event = new ShowToastEvent({
      title: 'Erreur',
      message: 'Attention, vous devez saisir au moins un critère pour la recherche.',
      variant: 'error'
       
   });
 this.dispatchEvent(event);
 console.log('champs vide');
 //this.showErrorToast('Attention, vous devez saisir au moins un critère pour la recherche.');
 //alert('Attention, vous devez saisir au moins un critère pour la recherche.');
 
 
 }
 //appeler la classe apex de recherche des demandes de recyclage ftth
 else{
   this.isLoading=true;
   this._actionUtil = new OmniscriptActionCommonUtil();
   let input = {"InwiB2C_commande__c": orderId,
               "InwiB2C_Motif_d_chec_de_raccordement__c": motif,
               "InwiB2C_client__c": IdClient,
               "InwiB2C_client__r.InwiB2C_Num_ro_de_contact__c": numContact,
               "InwiB2C_client__r.Inwib2c_CIN__c": cin,
               "InwiB2C_Statut__c": statutDemande,
               "InwiB2C_Compteur_de_rep_chage__c": contRepechage
               
            }
            console.log('champs recupereé'+ JSON.stringify(input, null, 2) );
            const params = {
             input: JSON.stringify(input),
             sClassName: 'InwiB2C_SharingDemandeRecyclageFTTH',
             sMethodName: 'searchDemandeRecyclage',
             options: '{}',
           };
           this._actionUtil
           .executeAction(params, null, this, null, null)
           .then(response => {
             console.log('response:',response);
               if (response != null && response.result.requestList != null ) {
                 this.omniUpdateDataJson({ 'requestList':response.result.requestList});
               }
               this.omniNextStep(); 
           })
           .catch(error => {
               console.log('error' + JSON.stringify(error));
               window.console.log(error);
           });
             
       }
       
}

}