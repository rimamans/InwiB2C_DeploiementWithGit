import { LightningElement,api } from 'lwc';
import template from './inwiB2C_DisplayDemandeDeg.html';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_DisplayDemandeDeg extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    __records = [];
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
        }

        /*
     columns = [
        { label: 'N° Ordre', fieldName: 'InwiB2C_ORDER_DEGROUPAGE_NUM__c',hideDefaultActions: 'true',initialWidth: 80 },
        { label: 'Numéro', fieldName: 'InwiB2C_SEQ_NUM__c',hideDefaultActions: 'true' ,initialWidth: 60 },
        { label: 'Type de la demande', fieldName: 'InwiB2C_typeCommande__c',hideDefaultActions: 'true',initialWidth: 140 },
        { label: 'Nom', fieldName: 'InwiB2C_LastName__c',hideDefaultActions: 'true',initialWidth: 60 },
        { label: 'Prénom', fieldName: 'InwiB2C_FirstName__c',hideDefaultActions: 'true',initialWidth: 70 },
        { label: 'ND', fieldName: 'nd' ,hideDefaultActions: 'true',initialWidth: 60 },
        { label: 'N° Identification', fieldName: 'InwiB2C_Nationalid__c' ,hideDefaultActions: 'true',initialWidth: 60},
        { label: 'Date de création', fieldName: 'CreatedDate', type: 'date' ,hideDefaultActions: 'true',initialWidth: 120},
        { label: 'Porté', fieldName: 'InwiB2C_portabilite__c', hideDefaultActions: 'true',initialWidth: 50 },
        { label: 'Statut de la demande', fieldName: 'InwiB2C_Statutdegroupage__c' ,hideDefaultActions: 'true',initialWidth: 150},
        { label: 'Numéro de contact', fieldName: 'InwiB2C_numeroContact__c' ,hideDefaultActions: 'true',initialWidth: 150},
        { label: 'Motif de rejet', fieldName: 'InwiB2C_Motif__c' ,hideDefaultActions: 'true',initialWidth: 110},
        {type: "button", typeAttributes: {   label: "Voir",  name: 'View', variant: 'brand',disabled: false, value: 'view', iconPosition: 'left', },initialWidth: 80},
        {type: "button", typeAttributes: {   label: "Annuler",  name: 'Cancel', variant: 'brand',disabled:{ fieldName: 'DisableAnnuler' }, value: 'view', iconPosition: 'left', },initialWidth: 95},
        {type: "button",typeAttributes: {   label: "Recycler",  name: 'Recycle', variant: 'brand',disabled: { fieldName: 'DisableRecycler' }, value: 'view', iconPosition: 'left', },initialWidth: 100},
        {type: "button",typeAttributes: {   label: "Changement de technologie",  name: 'techno', variant: 'brand',disabled: { fieldName: 'DisableChgmt' }, value: 'view', iconPosition: 'left', },initialWidth: 220},
        {type: "button",typeAttributes: {   label: "Relancer",  name: 'relance', variant: 'brand',disabled: { fieldName: 'DisableRelancer' }, value: 'view', iconPosition: 'left', },initialWidth: 100}
    ]; 
    */


   handlesClick(event){
        var buttonName = event.target.dataset.name;;
        const row = event.target.name;
        let recycledirect = false;
        let canceldirect = false;
        let recycleErreur = false;
        let technodirect = false;
        let voir = false;
        /**MGEN3568 07/08/24 ILA Start*/
        let traitementRecyclage = 'new';
        let traitementAnn = 'old';
        let relance = false;
        /**MGEN3568 07/08/24 ILA End*/
        this.omniUpdateDataJson({ 'selectedRow':row});
        if(buttonName == 'Recycle'){
            if(row.InwiB2C_Statutdegroupage__c=='En erreur')
                recycleErreur = true;
            recycledirect = true;
            /**MGEN3568 07/08/24 ILA Start*/
            if(row.InwiB2C_Statutdegroupage__c=='Suspendue'){
                if(row.InwiB2C_CodeMotifRejet__c=='63' || row.InwiB2C_CodeMotifRejet__c=='24' || row.InwiB2C_CodeMotifRejet__c=='56' || row.InwiB2C_CodeMotifRejet__c=='70' || row.InwiB2C_CodeMotifRejet__c=='71' || row.InwiB2C_CodeMotifRejet__c=='73' || row.InwiB2C_CodeMotifRejet__c=='48' || row.InwiB2C_CodeMotifRejet__c=='66' )
                    traitementRecyclage = 'date';
            }
            /**MGEN3568 07/08/24 ILA End*/
        }
        else if(buttonName == 'Cancel'){
            /**MGEN3568 07/08/24 ILA Start*/
            if(row.InwiB2C_Statutdegroupage__c== 'Mise en service')
                traitementAnn='date';
            /**MGEN3568 07/08/24 ILA Start*/
            canceldirect = true;   
        }
        else if(buttonName == 'techno'){
            technodirect = true;
        }
        /**MGEN3568 07/08/24 ILA Start*/
        else if(buttonName == 'relance'){
            relance = true;
        }
        /**MGEN3568 07/08/24 ILA End*/
        else{
            voir = true;
        }
        this.omniUpdateDataJson({ 'recycledirect':recycledirect});
        this.omniUpdateDataJson({ 'canceldirect':canceldirect});
        this.omniUpdateDataJson({ 'recycleErreur':recycleErreur});
        this.omniUpdateDataJson({ 'technodirect':technodirect});
        this.omniUpdateDataJson({ 'voir':voir});
        /**MGEN3568 07/08/24 ILA Start*/
        this.omniUpdateDataJson({ 'traitementRecyclage':traitementRecyclage});
        this.omniUpdateDataJson({ 'traitementAnn':traitementAnn});
        this.omniUpdateDataJson({ 'relance':relance});
        /**MGEN3568 07/08/24 ILA End*/
        this.omniNextStep();

     }  

     connectedCallback(){
        console.log('demandes: ', JSON.stringify(this.records));
     }
    get isDemandesEmpty() {
        return this.__records.length == 0 ? true : false;
    }

    render(){
        return template;
    }
}