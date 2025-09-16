import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_MenuChoixBanc.html";

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_MenuChoixBanc extends OmniscriptBaseMixin(LightningElement) {
      @track value = "";
    
      @api index = 0;
      @track MenuChoix;
      @api profile;
      @api options;
      @api countcameleon;
     
      _actionUtilClass;
      _ns = getNamespaceDotNotation();
    
      renderedCallback() {
        //this.value = undefined;
      }
    
      connectedCallback() {
        console.log('countcameleon'+this.countcameleon);
        if (this.index == 0) {
          this.index = 1;
          this.options = this.getoptions();
          let selectedLine = this.options[0];
    
          let MenuChoix = {
            SelectTypeModif: selectedLine.value,
            SelectedQueueName: selectedLine.label,
          };
    
          this.value = this.options[0].value;
    
          this.omniUpdateDataJson(MenuChoix);
         this.omniSaveState(MenuChoix, true);
        }
        this._actionUtilClass = new OmniscriptActionCommonUtil();
      }
      getoptions() {
      //  console.log('countcameleon'+this.countcameleon);
       
              switch (this.profile) {
                case "Administrateur système":
                case "System Administrator":
                  if(this.countcameleon==0 ){
                    return [
                                  
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
                      //{ label: "Regroupement du compte de facturation", value: "Regroupement_compte_facturation" },
                       //ANO B-9823 CHB 26/05/2023
                  // { label: "Parcours Gestion d'avoirs", value: "Gestion_d_avoir" },
                    ];
                  }else{
                    return [
                                  
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      // { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
                      //{ label: "Regroupement du compte de facturation", value: "Regroupement_compte_facturation" },
                       //ANO B-9823 CHB 26/05/2023
                  // { label: "Parcours Gestion d'avoirs", value: "Gestion_d_avoir" },
                    ];
                  }
                case "SC Agents CRC N1 Ext_Ph3":
                case "SC Agents CRC Helpdesk N1 Ext_Ph3":
                case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
                case "SC Superviseur CRC Ext_Ph3":
                case "SC Superviseur FO CRC Int_Ph3":
                case "SC Formation Int_Ph3":
                  if(this.countcameleon==0 ){
                    return [
                    //  { label: "Regroupement du compte de facturation", value: "Regroupement_compte_facturation" },
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
              
                    ];
                  }else{
                    return [
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                    ];
                  }
                case "SC Agents CRC Outbound N1 Ext_Ph3":
                case "SC Agents BO_Controle PDV N2 Ext_Ph3":
                  if(this.countcameleon==0 ){
                    return [
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
              
                    ];
                  }else{
                    return [
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                    ];
                  }

                case "SC Agents BO réclamation N2_Ph3":
                case "SC Superviseur BO CRC Ext_Ph3":
                case "SC Superviseur BO CRC Int_Ph3":
                  if(this.countcameleon==0 ){
                    return [
                  //   { label: "Regroupement du compte de facturation", value: "Regroupement_compte_facturation" },
                  //ANO B-9823 CHB 26/05/2023
                  //   { label: "Parcours Gestion d'avoirs", value: "Gestion_d_avoir" },
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
                
                    ];
                  }else{
                    return [
                    //ANO B-9823 CHB 26/05/2023
                  //   { label: "Parcours Gestion d'avoirs", value: "Gestion_d_avoir" },
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                    ];
                  }
                case "Inwi POS_Ph3":
                case "Inwi POS":
                case "Commercial Nomade":""
                case "Commercial Chef d'agence":
                  if(this.countcameleon==0 ){
                    return [
                //     { label: "Regroupement du compte de facturation", value: "Regroupement_compte_facturation" },
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement  des coordonnées bancaires", value: "UpdateBankInfo" },

                    ];
                  }else{
                    return [
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                    ];
                  }
          
                case "SC Agent VIP Int_Ph3":
                  if(this.countcameleon==0 ){
            
                    return [
                  //    { label: "Regroupement du compte de facturation", value: "Regroupement_compte_facturation" },          
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
                    ];

                  }else{
                    return [
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                    ];
                  }
          
                case "NV3 Facturation & recouvrement_Ph3":
                  if(this.countcameleon==0 ){
                    return [      
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                      { label: "Changement des coordonnées bancaires", value: "UpdateBankInfo" },
                       //ANO B-9823 CHB 26/05/2023
                  // { label: "Parcours Gestion d'avoirs", value: "Gestion_d_avoir" },

                    ];

                  }else{
                    return [
                      { label: "Changement d'adresse de facturation", value: "UpdateAddBA" },
                     //ANO B-9823 CHB 26/05/2023
                  //  { label: "Parcours Gestion d'avoirs", value: "Gestion_d_avoir" },

                    ];
                  }
                
              
                default:
                  return null;
                }
         
      }
    
    
      
      
    
      ChangeMenuEvent(event) {
        this.MenuChoix = event.detail.label;
    
        let selectedLine = this.options.find(x => x.value === event.detail.value);
    
        //console.log(JSON.stringify(selectedLine));
    
        let MenuChoix = {
          SelectTypeModif: selectedLine.value,
          SelectedQueueName: selectedLine.label,
        };
        console.log(JSON.stringify(MenuChoix));
        this.omniUpdateDataJson(MenuChoix);
        this.omniSaveState(MenuChoix, true);
      }
    
      render() {
        return template;
      }
    }