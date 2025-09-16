import { LightningElement,wire,track, api } from 'lwc';
import template from './inwiB2C_DisplaySharingRequest.html';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';

/*import DEMANDE_Object from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c';
import STATUT_DEMANDE_FIELD from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c.InwiB2C_Statutdegroupage__c';
import MOTIF_ANNUALATION from '@salesforce/schema/INWIB2C_DEMANDE_DEGROUPAGE__c.InwiB2C_MotifAnnulation__c';*/

export default class inwiB2C_DisplaySharingRequest  extends OmniscriptBaseMixin(NavigationMixin(LightningElement))  {


    // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation Begin
    @track isLoading = false;
    @track buttonLabel = "Valider";
    // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation End
    @track isViewMode = false; 
    @track statutLabel; 
    @track demandeInfos = new Map();
    @track __StatutDemande;
    @track __Account;
    @track __Code_Commune;
    @track __Code_Numero_Voie;
    @track __Code_Motif;
    @track __Code_Province;
    @track __Code_Quartier;
    @track __Code_Statut;
    @track __Code_Voie;
    @track __Code_Routage;
    @track __Commande_de_partage;
    @track __LastName;
    @track __Installation_CPE;
    @track __Identifiant_CPE;
    @track __FirstName;
    @track __Commune;
    @track __Commentaire;
    @track __Level_Signal;
    @track __LineId;
    @track __Login;
    @track __Motif;
    @track __Nationalid;
    @track __Nd_Attribut;
    @track __Numero_Voie;
    @track __Numero_Partage;
    @track __Portabilite;
    @track __Order;
    @track __SubId;
    @track __Operateur_Infrastructure;
    @track __Operateur_Commercial;
    @track __NumeroDesignation;
    @track __NumeroContact;
    @track __Province;
    @track __Quartier;
    @track __Rendezvous;
    @track __Rio;
    @track __SavPlus;
    @track __Sequence;
    @track __Site;
    @track __Voie;
    @track __Vitesse;
    @track __Compteur_Recyclage;
    @track __Type_d_operation;
    @track __Statut_Ligne;
    @track __Motif_Annulation;
    @track __Type_de_partage;
    @track motifAnnulationPicklist;
    @track __OrchPlanId;

    @track __nomSite;
    @track __OrderNumber;
    @track __LastModifiedBy;
    @track __CreatedBy;
    @track __AccountName;
    //R-SL Ticket B-29934 19/06/2025 start
    @track __DateMiseEnService;
    //R-SL Ticket B-29934 19/06/2025 end

    modify=true;
    requiredMotifAnn = false;
    motifAnn=true;
    requiredStatut=false;
    boutonLabel = "Modifier"
    demandeDeg = {};
    statutValue;
    __demande;
    __action;
    _actionUtilClass;
    nomClient;
    // statutAnnulation;




    @api
    get demande(){
        this.__demande;
    }
    set demande(value){
        this.__demande = value;
        console.log("demandeIdset", this.__demande)
    }
    @api
    get action(){
        this.__action;
    }
    set action(value){
        this.__action = value;
        console.log("ActionSet", this.__action);
        if(this.__action == 'view'){
            this.isViewMode=true;
            console.log("ActionSet2", this.__action)
        }else{
            this.motifAnn=false;
            this.requiredMotifAnn=true;
            console.log("motifAnn", this.motifAnn);
            console.log("requiredMotifAnn", this.requiredMotifAnn);
        }
    }



    handlePrevious() {
        console.log('Retour en arrière...');
        this.omniPrevStep();
    }

    
    renderedCallback() {

    }
    render(){
        return template;
    }

    


    getStatutLabel(statutValue) {
        let statut = [
            { label: 'Acceptée', value: 'ACC' },
            { label: 'Pré-Annuler', value: 'ANN' },
            { label: 'Rejet définitif', value: 'DEF' },
            { label: 'Nouvelle', value: 'NOU' },
            { label: 'Rejeté Guichet', value: 'REG' },
            { label: 'Rejetée', value: 'REJ' },
            { label: 'Résiliée', value: 'RES' },
            { label: 'Mise en service', value: 'MES' },
            { label: 'En cours', value: 'SOU' },
            { label: 'Suspendue', value: 'SUS' },
            { label: 'A pré-annuler', value: 'TCA' },
            { label: 'Statut Temporaire', value: 'TEM' },
            { label: 'Ligne connectée', value: 'ACT' },
            { label: 'Recyclage automatique', value: 'RCA' },
            { label: 'annulation définitive', value: 'DAN' },
            { label: 'En erreur', value: 'InwiB2C_EnErreur' },
            { label: 'Recyclée', value: 'InwiB2C_Recyclee' },
            { label: 'En cours de résiliation', value: 'inwiB2C_en_cours_de_resiliation' },
            { label: 'Recylée IN', value: 'InwiB2C_Recyclee_IN' },
            { label: 'Echec de mise en service', value: 'InwiB2C_EchecMES' },
        ];
    
        // Cherche le label correspondant à la valeur donnée
        let statutObj = statut.find(item => item.value === statutValue);
        
        // Retourne le label, ou une valeur par défaut si non trouvé
        return statutObj ? statutObj.label : 'Statut inconnu';
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


     connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.GetDemandeInfos();
        this.motifAnnulation();
    }



    GetDemandeInfos(){
        var inputApex = JSON.stringify({ "demandeId": this.__demande });
        console.log("inputApex", inputApex);
        console.log("GetDemandeInfos");
        console.log("demandeIdGetDemandeInfos", this.__demande)
        const params = {
            input: inputApex,
            sClassName: 'InwiB2C_CancelDemandePartage',  // Classe Apex
            sMethodName: 'getDemandeById',  // Méthode Apex à appeler
            options: '{}',
        };

        this._actionUtilClass.executeAction(params, null, this, null, null)
            .then(response => {
                console.log("beforeResponse");
                if (response && response.result) {
                    console.log('Réponse de l\'interaction:', response.result);
                    this.demandeInfos = new Map(Object.entries(response.result.resultdata));
                    // this.demandeInfos = response.result.resultdata;
                    console.log("DemandeInfosV2", this.demandeInfos);
                    this.__StatutDemande = this.demandeInfos.get('InwiB2C_Statut_demande__c');
                    if(this.__action == 'cancel'){
                        this.__StatutDemande = 'ANN' }
                    this.statutLabel = this.getStatutLabel(this.__StatutDemande);
                    console.log("statutLabel",this.statutLabel);
                    const order = this.demandeInfos.get('InwiB2C_Order__r');
                    const Account = this.demandeInfos.get('InwiB2C_Account__r');
                    const Site = this.demandeInfos.get('InwiB2C_Site__r');
                    const LastModifiedBy = this.demandeInfos.get('LastModifiedBy');
                    const CreatedBy = this.demandeInfos.get('CreatedBy');

                    this.__OrchPlanId = order.vlocity_cmt__OrchestrationPlanId__c;
                    console.log("OrchPlanId", this.__OrchPlanId);
                    this.__OrderNumber = order.OrderNumber;  
                    console.log("OrderNumber", this.__OrderNumber);
                    this.__AccountName= Account.Name;
                    console.log("AccountName",  this.__AccountName);

                    this.__nomSite= Site.Name;
                    console.log("nomSite",  this.__nomSite);
                    this.__LastModifiedBy= LastModifiedBy.Name;
                    console.log("LastModifiedBy", this.__LastModifiedBy);
                    this.__CreatedBy= CreatedBy.Name;
                    console.log("CreatedBy",  this.__CreatedBy);

                    this.__Account = this.demandeInfos.get('InwiB2C_Account__c');
                    this.__Code_Commune = this.demandeInfos.get('InwiB2C_Code_Commune__c');
                    this.__Code_Numero_Voie = this.demandeInfos.get('InwiB2C_Code_de_Numero_de_la_voie__c');
                    this.__Code_Motif = this.demandeInfos.get('Motif_d_annulation__c');
                    this.__Code_Province = this.demandeInfos.get('InwiB2C_Code_Province__c');
                    this.__Code_Quartier = this.demandeInfos.get('InwiB2C_Code_Quartier__c');
                    this.__Code_Statut = this.demandeInfos.get('InwiB2C_Statut_demande__c');
                    this.__Compteur_Recyclage = this.demandeInfos.get('InwiB2C_Compteur_recyclage__c');
                    this.__Code_Voie = this.demandeInfos.get('InwiB2C_Code_Voie__c');
                    this.__Code_Routage = this.demandeInfos.get('InwiB2C_codeRoutage__c');
                    this.__Commande_de_partage = this.demandeInfos.get('InwiB2C_Commande_de_partage__c');
                    this.__LastName = this.demandeInfos.get('InwiB2C_LastName__c');
                    this.__Installation_CPE = this.demandeInfos.get('InwiB2C_Installation_CPE__c');
                    this.__Identifiant_CPE = this.demandeInfos.get('InwiB2C_Identifiant_CPE__c');  
                    this.__FirstName = this.demandeInfos.get('InwiB2C_FirstName__c');
                    this.__Commune = this.demandeInfos.get('InwiB2C_Commune__c');
                    this.__Commentaire = this.demandeInfos.get('InwiB2C_Commentaire__c');  
                    this.__Level_Signal = this.demandeInfos.get('InwiB2C_Level_Signal__c');  
                    this.__LineId = this.demandeInfos.get('InwiB2C_lineId__c');  
                    this.__Login = this.demandeInfos.get('InwiB2C_Login__c');  
                    this.__Motif = this.demandeInfos.get('Motif_d_annulation__c');
                    this.__Nationalid = this.demandeInfos.get('InwiB2C_Nationalid__c');
                    this.__Nd_Attribut = this.demandeInfos.get('InwiB2C_nd_Attribut__c');
                    this.__Numero_Voie = this.demandeInfos.get('InwiB2C_Numero_de_la_voie__c');
                    this.__Numero_Partage = this.demandeInfos.get('InwiB2C_Numero_Partage__c');
                    this.__Portabilite = this.demandeInfos.get('InwiB2C_Portabilite__c');
                    this.__Order = this.demandeInfos.get('InwiB2C_Order__c');
                    this.__SubId = this.demandeInfos.get('InwiB2C_Subscription__c');
                    this.__Operateur_Infrastructure = this.demandeInfos.get('InwiB2C_Operateur_Infrastructure__c');
                    this.__Operateur_Commercial = this.demandeInfos.get('InwiB2C_Operateur_commercial__c');
                    this.__NumeroDesignation = this.demandeInfos.get('InwiB2C_NumeroDesignation__c');
                    this.__NumeroContact = this.demandeInfos.get('InwiB2C_numeroContact__c');
                    this.__Province = this.demandeInfos.get('InwiB2C_Province__c');
                    this.__Quartier = this.demandeInfos.get('InwiB2C_Quartier__c');
                    this.__Rendezvous = this.demandeInfos.get('InwiB2C_rendezvous__c');  
                    this.__Rio = this.demandeInfos.get('InwiB2C_Rio__c');  
                    this.__SavPlus = this.demandeInfos.get('InwiB2C_savPlus__c');
                    this.__Sequence = this.demandeInfos.get('InwiB2C_Sequence__c');
                    this.__Voie = this.demandeInfos.get('InwiB2C_Voie__c');
                    this.__Vitesse = this.demandeInfos.get('InwiB2C_Vitesse__c');  
                    this.__Type_d_operation = this.demandeInfos.get('InwiB2C_Type_d_operation__c');  
                    this.__Statut_Ligne = this.demandeInfos.get('InwiB2C_Statut_ligne__c');
                    this.__Motif_Annulation = this.demandeInfos.get('Motif_d_annulation__c');
                    this.__Type_de_partage = this.demandeInfos.get('Type_de_partage__c');
                    //R-SL Ticket B-29934 19/06/2025 start
                    this.__DateMiseEnService = this.demandeInfos.get('InwiB2C_Date_de_mise_en_service__c');
                    //R-SL Ticket B-29934 19/06/2025 end
                    this.nomClient= this.__Account;
                    
                    console.log("this.__LineId", this.__LineId);

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

    get urlOrder(){
        return "/PortailPDVPhase2/s/order/"+this.__Order+"/view";
        
    }
    get urlCompte(){
        return "/PortailPDVPhase2/s/account/"+this.__Account+"/view";
    }

    get urlSite(){
        return "/PortailPDVPhase2/s/account/"+this.__nomSite+"/view";
    }


    get urlCreatedBy(){
        return "/PortailPDVPhase2/s/profile/"+this.__CreatedBy;
    }

    get urlModifiedBy(){
        return "/PortailPDVPhase2/s/profile/"+this.__LastModifiedBy;
    }

    showMessage(t, m, type) {
        const toastEvt = new ShowToastEvent({
            title: t,
            message: m,
            variant: type
        });
        this.dispatchEvent(toastEvt);
    }

    handleCancel(event){
        //  const combobox = this.template.querySelector('lightning-combobox').value;
        //  console.log("combobox", combobox);
        //  this.__Motif_Annulation = combobox ? combobox.value : "";

        // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation Begin
        if (this.isLoading) {
            return;
        }

        this.isLoading = true;
        this.buttonLabel = "Traitement...";
        // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation End

        console.log("isLoading", this.isLoading)
        this.__Motif_Annulation = (this.template.querySelector('lightning-combobox').value != undefined) ?this.template.querySelector('lightning-combobox').value : "";
        console.log("motifAnnulationCancelAfter", this.__Motif_Annulation);
        // if(this.__Motif_Annulation == null || this.__Motif_Annulation == ""|| this.__Motif_Annulation == undefined){
             if (!this.__Motif_Annulation || this.__Motif_Annulation == "") {

                console.log("motifAnnulationCancelBeforeToast");
                // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation Begin
                this.isLoading = false;
                this.buttonLabel = "Valider";
                // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation End
                
                this.showMessage('Erreur', 'Champs Obligatoire Manquants', 'error');
            // this._actionUtilClass.showToast('Veuillez remplir le champ Motif Annulation', 'Error', 'error');
            return;
        }

        if(this.__Motif_Annulation != null && this.__Motif_Annulation != "" && this.__Motif_Annulation != undefined){
        console.log("__Motif_AnnulationHandleCancel", this.__Motif_Annulation);
        var input = '{ "requestId":"' + this.__Numero_Partage  + '","lineId":"' + this.__LineId + '","motifAnnulation":"' + this.__Motif_Annulation  + '","demandeId":"' + this.__demande + '", "CommPartage":"' + this.__Commande_de_partage + '","OrchPlanId":"' + this.__OrchPlanId + '","orderId":"' + this.__Order + '","operator":"' + this.__Operateur_Infrastructure + '", "SubId":"' + this.__SubId + '" }';
        console.log("inputHandleCancel",input)
        const params = {
            input: input,
            sClassName: 'InwiB2C_CancelDemandePartage',  
            sMethodName: 'CancelDemande', 
            options: '{}',
        };
        this._actionUtilClass.executeAction(params, null, this, null, null)
        .then(response => {
            console.log("beforeResponseHandleCancel");
            if (response && response.result) {
                let statutAnnulation;
                let ErreurAnnualtion;
                let IdDemandeANN;

                console.log('Réponse de l\'interaction:', response.result);
                statutAnnulation = response.result.Annulation.AcqIAM;
                console.log("statutAnnulation", response.result.Annulation.AcqIAM);
                ErreurAnnualtion  = response.result.Annulation.message;
                console.log("messageAnnulation", response.result.Annulation.message)
                IdDemandeANN   = response.result.IdDemandeANN;
                console.log("IdDemande", response.result.IdDemandeANN);

                if (statutAnnulation == 'KO'){
                        // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation Begin
                        this.isLoading = false;
                        this.buttonLabel = "Valider";
                        // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation End
                        this.showMessage('Erreur', ErreurAnnualtion, 'error');
                }else{
                this.buttonLabel = "Succès";

                this.omniUpdateDataJson({ 'statutAnnulation':statutAnnulation});
                this.omniUpdateDataJson({ 'messageAnnulation':ErreurAnnualtion});
                this.omniUpdateDataJson({ 'IdDemande':IdDemandeANN});
                this.omniNextStep();
                }

            } else {
                // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation Begin
                this.isLoading = false;
                this.buttonLabel = "Valider";
                // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation End
                this._actionUtilClass.showToast('Erreur lors de la récupération de la demande', 'Error', 'error');
                console.log("ErrorResponse1");
            }
        })
        .catch(error => {
            // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation Begin
            this.isLoading = false;
            this.buttonLabel = "Valider";
            // CH-Y B-32288 Ajouter un spinner loading aprés validation de l'annulation End
            console.error('Erreur lors de la création de l\'interaction:', error);
            this._actionUtilClass.showToast('Erreur lors de l\'interaction', 'Error', 'error');
            console.log("ErrorResponse2");
        });
    }

    }








}