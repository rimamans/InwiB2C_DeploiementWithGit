import { LightningElement,wire,track, api } from 'lwc';
import template from './inwiB2C_DisplaySingleDemandeDeg.html';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';

/*import DEMANDE_Object from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c';
import STATUT_DEMANDE_FIELD from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c.InwiB2C_Statutdegroupage__c';
import MOTIF_ANNUALATION from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c.InwiB2C_MotifAnnulation__c';*/

export default class InwiB2C_DisplaySingleDemandeDeg  extends OmniscriptBaseMixin(NavigationMixin(LightningElement))  {

    modify=true;
    requiredMotifAnn = false;
    motifAnn=true;
    requiredStatut=false;
    boutonLabel = "Modifier"
    demandeDeg = {};
    statutValue;
    __demande;
    @api
    get demande(){
        this.__demande;
    }
    set demande(value){
        this.__demande = value;
    }
    __profile;
    @api
    get profile(){
        this.__profile;
    }
    set profile(value){
        this.__profile=value;
    }
    __displayinfo;
    @api
    get displayinfo(){
        this.__displayinfo;
    }
    set displayinfo(value){
        this.__displayinfo=value;
    }
    nomClient;
    nomSite;
    createdByName;
    lastModifiedName;
    __showmodify;
        @api 
    get showmodify(){
        this.__showmodify;
    }
    set showmodify(value){
        this.__showmodify=value;
    }
    __showrecyclage;
    @api 
    get showrecyclage(){
    this.__showrecyclage;
    }
    set showrecyclage(value){
    this.__showrecyclage=value;
    }
    __canceldirect;
    @api 
    get canceldirect(){
    this.__canceldirect;
    }
    set canceldirect(value){
    this.__canceldirect=value;
    }
    
    @track statutDemandePicklist;
    @track motifAnnulationPicklist;
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
        fieldApiName: MOTIF_ANNUALATION
      })
      motifAnnulation({error, data}){
          if (data){
              this.motifAnnulationPicklist=data.values;
          } 
          if(error){
              console.log('Ereur de récuperation de statut demande',error);
          }
      }
      */
      statutDemande(){
        let statut= [
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
            //R-SL 07/05/2025  MGEN3698 start
            { label: 'Annulee_Delai_Reg', value: 'InwiB2C_Annulee_Delai_Reg' },
            { label: 'Annulee_3_Susp', value: 'InwiB2C_Annulee_3_SuspAnnulee_3_Susp' }
            //R-SL 07/05/2025 end
        ];
        this.statutDemandePicklist = statut;
        if(this.__canceldirect && this.__canceldirect == true ){
            /**B-14273 ILA 20/02/2024 Start*/
            //this.statutValue = "TCA";
            this.statutValue = "ANN";
            /**B-14273 ILA 20/02/2024 End*/
            this.motifAnn = false;
            this.requiredMotifAnn = true;
            this.modify=false;
            this.boutonLabel = "Valider";
        }
        else
            this.statutValue=this.__demande.InwiB2C_Statutdegroupage__c;
     }

      motifAnnulation(){
        let motifs= [
            { label: 'Désistement/Changement d’avis', value: 'CNN' },
            { label: 'Engagement chez la concurrence', value: 'ECC' },
            { label: 'Information incomplète au moment de la vente', value: 'IIV' },
            { label: 'Injoignable Permanent', value: 'PJN' },
            { label: 'Publicité mensongère', value: 'PUM' },
            { label: 'Retard d’installation', value: 'RIN' },
            { label: 'Zone non desservie', value: 'ZND' },
        ];
        this.motifAnnulationPicklist = motifs;
     }
      modifyDemande(e){
        let cancelOrder=false;
        let cancelIam=false;
        this.modify=false;
        this.requiredStatut=true;
        this.boutonLabel = "Valider";
        if(this.boutonLabel == "Valider"){
            let statutDemande = this.template.querySelector('[data-id="statutDemande"]').value;
            let motifAnnValue = this.template.querySelector('[data-id="MotifAnnValue"]').value;
            /**B-14273 ILA 20/02/2024 Start*/
            if(statutDemande != '' && (statutDemande == "NOU"||(statutDemande == "ANN" && motifAnnValue != ""))){
                cancelOrder = true;
                // R-SL 07/05/2025  MGEN3698 begin
                if(this.__demande.InwiB2C_Statutdegroupage__c != "InwiB2C_EnErreur" && this.__demande.InwiB2C_Statutdegroupage__c != "REJ" && this.__demande.InwiB2C_Statutdegroupage__c != "InwiB2C_Annulee_Delai_Reg" && this.__demande.InwiB2C_Statutdegroupage__c != "InwiB2C_Annulee_3_SuspAnnulee_3_Susp" )
                    //R-SL 07/05/2025  MGEN3698 end
                cancelIam = true;
                this.omniUpdateDataJson({ 'cancelIAM':cancelIam});
                this.omniUpdateDataJson({ 'cancelOrder':cancelOrder});
                this.omniUpdateDataJson({ 'motifAnnValue':motifAnnValue});
                this.omniUpdateDataJson({ 'createNewDemande':true});
                this.omniNextStep();
            }
            /*if(statutDemande != '' && (statutDemande == "NOU"||(statutDemande == "TCA" && motifAnnValue != ""))){
                
                const objEntries = Object.entries(this.__demande);
                let newDemande = [];
                for (let [key, value] of objEntries){
                    if(key=="InwiB2C_Statutdegroupage__c"){
                            newDemande.push({[key]:statutDemande});
                            //newDemande.set([key],statutDemande);
                    }
                    else if(key=="InwiB2C_MotifAnnulation__c"){
                        newDemande.push({[key]:motifAnnValue});
                    }
                    else if(key=="InwiB2C_SEQ_NUM__c"){
                        newDemande.push({[key]:Number(this.__demande.InwiB2C_SEQ_NUM__c)+1});
                    }
                    else if(key=="InwiB2C_typeCommande__c"){
                        newDemande.push({[key]:"RS2"});
                    }
                    else if(key=="Id"){
                        continue;
                    }
                    else{
                        newDemande.push({[key]:value});
                    }
                }
                if(statutDemande == "TCA"){
                    cancelOrder = true;
                    if(this.__demande.InwiB2C_Statutdegroupage__c != "InwiB2C_EnErreur" && this.__demande.InwiB2C_Statutdegroupage__c != "REJ")
                    cancelIam = true;
                    let newDemandeANN = [];
                    for (let [key1, value1] of objEntries){
                        if(key1=="InwiB2C_Statutdegroupage__c"){
                            newDemandeANN.push({[key1]:"ANN"});
                                //newDemande.set([key],statutDemande);
                        }
                        else if(key1=="InwiB2C_MotifAnnulation__c"){
                            newDemandeANN.push({[key1]:motifAnnValue});
                        }
                        else if(key1=="InwiB2C_SEQ_NUM__c"){
                            newDemandeANN.push({[key1]:Number(this.__demande.InwiB2C_SEQ_NUM__c)+2});
                        }
                        else if(key1=="InwiB2C_typeCommande__c"){
                            newDemandeANN.push({[key1]:"RS2"});
                        }
                        else if(key1=="Id"){
                            continue;
                        }

                        else{
                            newDemandeANN.push({[key1]:value1});
                        }
                    }
                    this.omniUpdateDataJson({ 'newDemandeANN':newDemandeANN});

                }
                //this.omniUpdateDataJson({'newDemande':new Map(newDemande.map((obj) => [obj.key, obj.value]))})
                this.omniUpdateDataJson({ 'cancelIAM':cancelIam});
                this.omniUpdateDataJson({ 'cancelOrder':cancelOrder});
                this.omniUpdateDataJson({ 'newDemande':newDemande});
                this.omniUpdateDataJson({ 'createNewDemande':true});
                this.omniNextStep(); 
            }   
            */ 
            /**B-14273 ILA 20/02/2024 End*/           
        }
        }
        next(){
            this.omniUpdateDataJson({ 'createNewDemande':false});
            this.omniNextStep();  
        }
        previous(){
            this.omniPrevStep();
        }
         /**B-14273 ILA 20/02/2024 Start*/
         /*
        get selection(){
            if(this.modify){
                return this.statutDemandePicklist;
            }
            else if(this.modify==false && (this.__demande.InwiB2C_Statutdegroupage__c =="REJ" || this.__demande.InwiB2C_Statutdegroupage__c =="InwiB2C_EnErreur")){
                return this.statutDemandePicklist=this.statutDemandePicklist.filter(item => {
                    return item.value == "TCA" || item.value == "NOU"
                  })
            }
            else{
                return this.statutDemandePicklist=this.statutDemandePicklist.filter(item => {
                    return item.value == "TCA"
                  })
            }
        }
        */
        get selection(){
            if(this.modify){
                return this.statutDemandePicklist;
            }
            else if(this.modify==false && (this.__demande.InwiB2C_Statutdegroupage__c =="REJ" || this.__demande.InwiB2C_Statutdegroupage__c =="InwiB2C_EnErreur")){
                return this.statutDemandePicklist=this.statutDemandePicklist.filter(item => {
                    return item.value == "ANN" || item.value == "NOU"
                  })
            }
            else{
                return this.statutDemandePicklist=this.statutDemandePicklist.filter(item => {
                    return item.value == "ANN"
                  })
            }
        }
        
         /**B-14273 ILA 20/02/2024 End*/

        get urlCompte(){
            if(this.__profile=="Inwi POS")
                return "/PortailPDVPhase2/s/account/"+this.__demande.InwiB2C_Account__c+"/view";
            else
                return "/lightning/r/Account/"+this.__demande.InwiB2C_Account__c+"/view";
        }

        get urlSite(){
            if(this.__profile=="Inwi POS")
                return "/PortailPDVPhase2/s/account/"+this.__demande.InwiB2C_Site__c+"/view";
            else
                return "/lightning/r/Account/"+this.__demande.InwiB2C_Site__c+"/view";
        }

        get urlOrder(){
            if(this.__profile=="Inwi POS")
                return "/PortailPDVPhase2/s/order/"+this.__demande.InwiB2C_Order__c+"/view";
            else
                return "/lightning/r/Order/"+this.__demande.InwiB2C_Order__c+"/view";
        }

        get urlCreatedBy(){
            if(this.__profile=="Inwi POS")
                return "/PortailPDVPhase2/s/profile/"+this.__demande.CreatedById;
            else
                return "/lightning/r/User/"+this.__demande.CreatedById+"/view";
        }

        get urlModifiedBy(){
            if(this.__profile=="Inwi POS")
                return "/PortailPDVPhase2/s/profile/"+this.__demande.LastModifiedById;
            else
                return "/lightning/r/User/"+this.__demande.LastModifiedById+"/view";
        }
        get urlAgence(){
            if(this.__profile=="Inwi POS")
                return "/PortailPDVPhase2/s/account/"+this.__demande.InwiB2C_Agence__c+"/view";
            else
                return "/lightning/r/Account/"+this.__demande.InwiB2C_Agence__c+"/view";
        }
        urlLabels(){
            this.nomClient=this.__displayinfo.nomClient;
            this.nomSite=this.__displayinfo.nomSite;
            this.createdByName=this.__displayinfo.createdByName;
            this.lastModifiedName=this.__displayinfo.lastModifiedName;
        }
        actionDirect(){
            if(this.__canceldirect && this.__canceldirect == true){
                /**B-14273 ILA 20/02/2024 Start*/
                //this.statutValue = "TCA";
                this.statutValue = "ANN";
                /**B-14273 ILA 20/02/2024 End*/
                this.modify = true;
            }
        }
        connectedCallback() {
            this.urlLabels();
            this.statutDemande();
            this.motifAnnulation();
            this.actionDirect();
        }

        handleSelection(event){
            let statut= event.detail.value;
             /**B-14273 ILA 20/02/2024 Start*/
            //if(statut=="TCA"){
            if(statut=="ANN"){
            /**B-14273 ILA 20/02/2024 Start*/
                this.motifAnn=false;
                this.requiredMotifAnn=true;
            }
            else{
                this.motifAnn=true;
                this.requiredMotifAnn=false;
            }

        }

    render(){
        return template;
    }
}