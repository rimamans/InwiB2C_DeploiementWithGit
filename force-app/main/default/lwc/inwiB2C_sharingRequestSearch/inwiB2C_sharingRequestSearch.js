/**
 * @description       : Lwc pour la saisie des critères de recherche sur la table demande de partage et la recherche.
 * @author            : Imane Lakrari
 * @last modified on  : 25-12-2024
 * @last modified by  : Imane Lakrari
**/

import { LightningElement,track,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_sharingRequestSearch extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    @track optionsArrayOrder= [];
    @track valueOrder;
    @track idOrder;

    @track valueAccount;
    @track idAccount;
    @track optionsArrayAccount= [];

    //  K-KA 16-06-2025 - B-29805 START
    @track valueAgence;
    @track idAgence;
    @track optionsArrayAgence= [];
    //  K-KA 16-06-2025 - B-29805 END

    isLoadinginModal=false;

    @track statutDemandePicklist = [];
    @track statutLignePicklist = [];

    __profile;
    @api
    get profile() {
      return this.__profile;
    }
    set profile(value) {
      this.__profile = value;
    }
    //  Recuperer les picklists 
    getPicklistValues(fieldName) {
      this._actionUtil = new OmniscriptActionCommonUtil();
      // const fieldName = event.target.name === 'statutDemande'?'InwiB2C_Statut_demande__c':'InwiB2C_Statut_ligne__c'
      const params = {
        input: '{"fieldName":"'+fieldName+'"}',
        sClassName: "InwiB2C_SharingRequestManagementVI",
        sMethodName: "getRequestStatus",
          options: '{}'
      };
      this._actionUtil
          .executeAction(params, null, this, null, null)
          .then(response => {
              console.log(" Réponse reçue :", response);
              if (response && response.result) {
                if(fieldName==='InwiB2C_Statut_demande__c')
                  this.statutDemandePicklist = response.result.statutList;
                else
                  this.statutLignePicklist = response.result.statutList;
              } else {
                  console.error(" Aucune donnée reçue !");
                  console.error(" Réponse inattendue :", response);
              }
          })
          .catch(error => {
              console.error("Erreur lors de l'appel Apex :", error);
          });
    }

    // Recuperer la commande et le client depuis IP 
    getObjectsRecords(event){
        //  K-KA 16-06-2025 - B-29805 START
        const objectName = event.target.name === 'Commande' ? 'searchOrder' : event.target.name === 'Agence' ? 'searchAgence': 'searchAccount'
        //  K-KA 16-06-2025 - B-29805 END

        const value= event.target.value; 
        this._actionUtil = new OmniscriptActionCommonUtil();
        const params = {
          input: '{"'+objectName+'":"'+value+'"}',
         sClassName: `${this._ns}IntegrationProcedureService`,
         sMethodName: "inwib2c_GetLookupForDegroupage",
         options: '{}'
       };
       this._actionUtil
         .executeAction(params, null, this, null, null)
         .then(response => {
           JSON.parse(JSON.stringify(response.result.IPResult));
           if(objectName === 'searchOrder')
            this.optionsArrayOrder=response.result.IPResult.ListOrder;
          //  K-KA 16-06-2025 - B-29805 START
          else if (objectName === 'searchAgence')
          this.optionsArrayAgence = response.result.IPResult.ListAgence;
          //  K-KA 16-06-2025 - B-29805 END
          else
            this.optionsArrayAccount=response.result.IPResult.List;
         })
         .catch(error => {
           console.log("error");
           window.console.log(error);
         });
      }

    // Selectionner la commande depuis le resultat affiché
      handleSelectOrder(event) {
        this.valueOrder=event.target.dataset.number ;
        this.idOrder = event.target.dataset.id;
        this.optionsArrayOrder = [];
      }
    
    // selectionner le client depuis le resultat affiché
    handleSelectAccount(event) {
      this.valueAccount=event.target.dataset.number ;
      this.idAccount = event.target.dataset.id;
      this.optionsArrayAccount= [];
    }

    //  K-KA 16-06-2025 - B-29805 START
    handleSelectAgence(event) {
      this.valueAgence=event.target.dataset.number ;
      this.idAgence = event.target.dataset.id;
      this.optionsArrayAgence= [];
    }
//  K-KA 16-06-2025 - B-29805 END

    /**Appel a apex pour faire la recherche et renvoyer le resultat a l'OS*/
      Search(){
        //recuperer les inputs
        const numPartage=this.refs.NumParatge.value;
        const lineId=this.refs.lineId.value;
        const nd=this.refs.numDesignation.value;
        const statutDemande=this.refs.statutDemande.value;
        const nomClient=this.refs.nomClient.value;
        const numContact=this.refs.numContact.value;
        const statutLigne=this.refs.statutLigne.value;
        const Createddate=this.refs.Createddate.value;
        const startDate=this.refs.startDate.value;
        const endDate=this.refs.endDate.value;
        const orderId= this.idOrder;
        let accountId = this.idAccount;
        //  K-KA 16-06-2025 - B-29805 START
        let agenceId = this.idAgence;
        //  K-KA 16-06-2025 - B-29805 END
        console.log('iiiOrder',orderId);
        console.log('iiiaccount',accountId);
        //afficher erreur si aucun critere de recherche n'est renseigné
         //  K-KA 16-06-2025 - B-29805 START
        if(numPartage == "" && lineId == "" && nd == "" && orderId == undefined && statutDemande == null && nomClient == "" && numContact == "" && statutLigne == null && Createddate == "" && startDate == "" && endDate == "" && accountId == undefined && agenceId == undefined){
        //  K-KA 16-06-2025 - B-29805 END
            const event = new ShowToastEvent({
                message: 'Attention, vous devez saisir au moins un critère pour la recherche',
                variant: 'error',
                mode: 'dismissable'
            });
          this.dispatchEvent(event);
        }
        //appeler la classe apex de recherche des demandes de partage
        else{
          //decider si la recherche est avec scope
          const scoppedSearch=numPartage != "" || lineId != "" || nd != "" || orderId != undefined ? 'searchForScopedRequest':'searchForUnscopedRequest';
          this.isLoadinginModal=true;
          this._actionUtilClass = new OmniscriptActionCommonUtil();
          let input = {"InwiB2C_Numero_Partage__c": numPartage,
                      "InwiB2C_lineId__c": lineId,
                      "InwiB2C_NumeroDesignation__c": nd,
                      "InwiB2C_Order__c": orderId,
                      "InwiB2C_Statut_demande__c": statutDemande,
                      "InwiB2C_LastName__c":nomClient,
                      "InwiB2C_numeroContact__c":numContact,
                      "InwiB2C_Statut_ligne__c":statutLigne,
                      "CreatedDate":Createddate,
                      "startDate":startDate,
                      "endDate":endDate,
                      "InwiB2C_Account__c":accountId,
                      //  K-KA 16-06-2025 - B-29805 START
                      "InwiB2C_Order__r.inwib2c_Partenaire__c":agenceId,
                      //  K-KA 16-06-2025 - B-29805 END
                      "profile":this.__profile
                   }
          console.log('Input Search: ',JSON.stringify(input));
          const params = {
            input: JSON.stringify(input),
            sClassName: 'InwiB2C_SharingRequestManagementVI',
            sMethodName: scoppedSearch,
            options: '{}',
          };
          this._actionUtilClass
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

      connectedCallback(){
        //recuperer la picklist statut de la demande
        this.getPicklistValues('InwiB2C_Statut_demande__c');
        //recuperer la picklist statut de la ligne
        this.getPicklistValues('InwiB2C_Statut_ligne__c');
      }
}