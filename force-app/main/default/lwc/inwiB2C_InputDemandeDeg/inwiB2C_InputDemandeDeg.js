import { LightningElement, wire, track } from 'lwc';
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import template from './inwiB2C_InputDemandeDeg.html';


/*import DEMANDE_Object from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c';
import STATUT_DEMANDE_FIELD from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c.InwiB2C_Statutdegroupage__c';
import STATUT_LIGNE_FIELD from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c.InwiB2C_StatutLigneIam__c';
*/
export default class InwiB2C_InputDemandeDeg extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

  _ns = getNamespaceDotNotation();
    //@track statutDemandePicklist;
    //@track statutLignePicklist;
    @track valueAccount;
    @track idAccount;
    @track optionsArrayAccount= [];
    @track valueOrder;
    @track idOrder;
    @track optionsArrayOrder= [];
    @track valueAgence;
    @track idAgence;
    @track optionsArrayAgence= [];

    /*
    @wire(getObjectInfo, { objectApiName: DEMANDE_Object })
    DemandeDegInfo;
  
 
    @wire(getPicklistValues, {
      recordTypeId: '$DemandeDegInfo.data.defaultRecordTypeId',
      fieldApiName: STATUT_DEMANDE_FIELD
    })
    stautDemande({error, data}){
        if (data){
            this.statutDemandePicklist=data.values;
        } 
        if(error){
            console.log('Ereur de récuperation de statut demande',error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$DemandeDegInfo.data.defaultRecordTypeId',
        fieldApiName: STATUT_LIGNE_FIELD
  
      })
      stautLigne({error,data}){
        if(data){
            this.statutLignePicklist = data.values;
        }
        if(error){
            console.log('Ereur de récuperation de statut ligne',error);
        }
      }
      */
      get statutDemandePicklist() {
        return [
            { label: 'Acceptée', value: 'ACC' },
            { label: 'Pré-Annuler', value: 'ANN' },
            { label: 'Rejet définitif', value: 'DEF' },
            { label: 'Nouvelle', value: 'NOU' },
            { label: 'Rejeté Guichet', value: 'REG' },
            { label: 'Rejetée', value: 'REJ' },
            { label: 'Résiliée', value: 'RES' },
            { label: 'Mise en service', value: 'REU' },
            { label: 'En cours', value: 'SOU' },
            { label: 'Suspendue', value: 'SUS' },
            { label: 'A pré-annuler', value: 'TCA' },
            { label: 'Statut Temporaire', value: 'TEM' },
            { label: 'Ligne connectée', value: 'ACT' },
            { label: 'Recyclage automatique', value: 'RCA' },
            { label: 'annulation définitive', value: 'DAN' },
            { label: 'En erreur', value: 'InwiB2C_EnErreur' },
            { label: 'Recyclée', value: 'InwiB2C_Recyclee' },
            { label: 'Recyclée IN', value: 'InwiB2C_Recyclee_IN' },
            { label: 'Echec de mise en service', value: 'InwiB2C_EchecMES' },
            // B-29368 28/05/25 ILA Start
            { label: 'Annulee_Delai_Reg', value: 'InwiB2C_Annulee_Delai_Reg' },
            { label: 'Annulee_3_Susp', value: 'InwiB2C_Annulee_3_SuspAnnulee_3_Susp' },
            // B-29368 28/05/25 ILA End
        ];
    }

    get statutLignePicklist(){
      return [
        { label: 'Ligne active', value: 'LA' },
        { label: 'Ligne inactive', value: 'LI' },
    ];
    }
      handleSearch(){
        let numOrder = this.template.querySelector('[data-id="numOrder"]').value;
        let statutDemande = this.template.querySelector('[data-id="statutDemande"]').value;
        let nd = this.template.querySelector('[data-id="numDesignation"]').value;
        let nomClient = this.template.querySelector('[data-id="nomClient"]').value;
        let statutLigne = this.template.querySelector('[data-id="statutLigne"]').value;
        let numContact = this.template.querySelector('[data-id="numContact"]').value;
        let date = this.template.querySelector('[data-id="date"]').value;
        let startDate = this.template.querySelector('[data-id="startDate"]').value;
        let endDate = this.template.querySelector('[data-id="endDate"]').value;
        let order = this.idOrder;
        let agence = this.idAgence;
        let account = this.idAccount;
        if(order != null || account != null || nd !='' || agence != null || statutDemande !=null || nomClient !='' || numContact !='' || numOrder !=''|| date !='' || startDate !='' || endDate !=''){
          let inputs= [];
          inputs.push({'numOrder':numOrder,'statutDemande':statutDemande,'nd':nd,'nomClient':nomClient,'statutLigne':statutLigne,
          'date':date,'order':order,'account':account,'agence':agence,'numContact':numContact,'endDate':endDate,'startDate':startDate});
          this.omniUpdateDataJson({ 'inputs':inputs});
          this.omniNextStep();
        }
        else{
          const event = new ShowToastEvent({
            message: 'Attention, vous devez saisir au moins un critère pour la recherche',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
          //alert(' Attention, vous devez saisir au moins un critère pour la recherche');
        }
        
      }
      
      handleChangedAccount(event){
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

      handleSelectAccount(event) {
        this.valueAccount=event.target.dataset.number ;
        this.idAccount = event.target.dataset.id;
        this.optionsArrayAccount= [];
      }

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

      handleSelectOrder(event) {
        this.valueOrder=event.target.dataset.number ;
        this.idOrder = event.target.dataset.id;
        this.optionsArrayOrder = [];
      }

      handleChangedAgence(event){
        let value= event.target.value; 
        this._actionUtil = new OmniscriptActionCommonUtil();
        const params = {
         input: '{"searchAgence":"'+value+'"}',
         sClassName: `${this._ns}IntegrationProcedureService`,
         sMethodName: "inwib2c_GetLookupForDegroupage",
         options: '{}'
       };
       this._actionUtil
         .executeAction(params, null, this, null, null)
         .then(response => {
           JSON.parse(JSON.stringify(response.result.IPResult));
           let res = response.result.IPResult.ListAgence;
           this.optionsArrayAgence=res ;
      
         })
         .catch(error => {
           console.log("error");
           window.console.log(error);
         });
        
      }

      handleSelectAgence(event) {
        this.valueAgence=event.target.dataset.number ;
        this.idAgence = event.target.dataset.id;
        this.optionsArrayAgence = [];
      }

    render(){
        return template;
    }
}