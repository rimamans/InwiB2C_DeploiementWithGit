import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_UpdateTechnoDemandeDeg.html';

export default class InwiB2C_UpdateTechnoDemandeDeg extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {



    newTechnoValues;
    newTechno;
    nd;
    techno;
    newDemande = [];
    __demande;
    @api
    get demande(){
        this.__demande;
    }
    set demande(value){
        this.__demande = value;
    }

    NewTechno(){
        if(this.__demande.InwiB2C_Technologie__c == 'VULA'){
            this.newTechno ='BitStream';
        }
        else{
            this.newTechno ='VULA';
        }
    }

    Nd(){
        if(this.__demande.InwiB2C_StatutLigneIam__c == 'LA'){
            this.nd = this.__demande.InwiB2C_NumeroDesignation__c;
        }
        else{
            this.nd = this.__demande.InwiB2C_ndOperateur__c;
        }

    }

    previous(){
        this.omniPrevStep();
    }

    cancel(){
        this.omniUpdateDataJson({'exit':true});
        this.omniNextStep();
    }

    submit(){
        /**B-14273 ILA 21/02/2024 Start */
        /*
        let newDemande = [];
        for (let [key, value] of Object.entries(this.__demande)){
            switch(key){
                case 'InwiB2C_SEQ_NUM__c':
                    newDemande.push({[key]:1});
                    break;
                case 'InwiB2C_Statutdegroupage__c':
                    newDemande.push({[key]:'NOU'});
                    break;
                case 'InwiB2C_DEGROUPAGE_NUM__c':
                    break;
                case 'InwiB2C_typeCommande__c':
                    break;
                case 'InwiB2C_Technologie__c':
                    newDemande.push({[key]:this.newTechno});
                    break;
                case 'Id':
                    break;
                case 'InwiB2C_Order__c':
                    break;
                default : 
                    newDemande.push({[key]:value});
                    break; 
            }}
        newDemande.push({'InwiB2C_typeCommande__c':'CT'});
        this.omniUpdateDataJson({ 'newDemande':newDemande});
        */
        /**B-14273 ILA 21/02/2024 Start */
        this.omniUpdateDataJson({ 'createNewDemande':true});
        this.omniUpdateDataJson({ 'oldTechno':this.__demande.InwiB2C_Technologie__c});
        this.omniUpdateDataJson({ 'newTechno':this.newTechno});
        this.omniNextStep();
    }

    connectedCallback(){
        this.NewTechno();
        this.Nd();
    }

    render(){
        return template;
    }
}