import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_MenuModificationPhase2.html";

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_MenuModificationPhase2 extends OmniscriptBaseMixin(LightningElement) {
  @track value = "";

  @api index = 0;
  @track MenuChoix;

  @api options;
  @api profile;
  @api dealer;

  _actionUtilClass;
  _ns = getNamespaceDotNotation();

  renderedCallback() {
    //this.value = undefined;
  }

  connectedCallback() {
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

    if(this.dealer=="Dealer"){
      if( this.profile=="Inwi POS"){
        return [
          { label: "Suspension", value: "Suspension" },
          {
            label: "Changement de carte SIM",
            value: "Changement_de_carte_SIM",
          },
          {
            label: "Changement de Terminal/Modem",
            value: "Changement_de_Terminal_Modem",
          }];
      }else{
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          {
            label: "Changement de carte SIM - SAV interne",
            value: "Changement_de_carte_SIM_SAV",
          },
          {
            label: "Changement de Terminal/Modem - SAV interne",
            value: "Changement_de_Terminal_SAV",
          }];
      }
    }

    switch (this.profile) {
      case "Administrateur système":
      case "System Administrator":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          {
            label: "Changement de carte SIM - SAV interne",
            value: "Changement_de_carte_SIM_SAV",
          },
          {
            label: "Changement de Terminal/Modem - SAV interne",
            value: "Changement_de_Terminal_SAV",
          },
          { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
          {
            label: "Changement de carte SIM",
            value: "Changement_de_carte_SIM",
          },
          {
            label: "Changement de Terminal/Modem",
            value: "Changement_de_Terminal_Modem",
          },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
          { label: "Migration d'offre ", value: "Migration_Offre" },
        ];

      case "SC Agents CRC N1 Ext_Ph2":
      case "SC Agents CRC Helpdesk N1 Ext_Ph2":
      case "SC Superviseur CRC Ext_Ph2":
      case "SC Superviseur FO CRC Int_Ph2":
      case "SC Agents BO_Controle PDV N2 Ext_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
          { label: "Migration d'offre ", value: "Migration_Offre" },
        ];
      case "Inwi POS_Ph2":
      case "Inwi POS":
      case "Commercial Nomade":
      case "Commercial Chef d'agence":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          {
            label: "Changement de carte SIM",
            value: "Changement_de_carte_SIM",
          },
          {
            label: "Changement de Terminal/Modem",
            value: "Changement_de_Terminal_Modem",
          },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
          { label: "Migration d'offre ", value: "Migration_Offre" },
        ];

      case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph2":
      case "SC Formation Int_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
        ];

      case "SC Agents BO réclamation N2_Ph2":
      case "SC Superviseur BO CRC Int_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          {
            label: "Changement de carte SIM - SAV interne",
            value: "Changement_de_carte_SIM_SAV",
          },
          {
            label: "Changement de Terminal/Modem - SAV interne",
            value: "Changement_de_Terminal_SAV",
          },
          { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
          { label: "Migration d'offre ", value: "Migration_Offre" },
        ];
      case "SC Superviseur BO CRC Ext_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          {
            label: "Changement de carte SIM - SAV interne",
            value: "Changement_de_carte_SIM_SAV",
          },
          {
            label: "Changement de Terminal/Modem - SAV interne",
            value: "Changement_de_Terminal_SAV",
          },
          { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
          { label: "Changment de profil", value: "Changment_de_profil" },
        ];
      case "Support N3 SI_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
        ];
      case "SC Superviseur BO CRC Ext_Ph2":
      case "SC Agent VIP Int_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          { label: "Changement de numéro", value: "Changement_de_Numero" },
          {
            label: "Changement de carte SIM - SAV interne",
            value: "Changement_de_carte_SIM_SAV",
          },
          {
            label: "Changement de Terminal/Modem - SAV interne",
            value: "Changement_de_Terminal_SAV",
          },
          { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
          {
            label: "Changement Options/Attributs",
            value: "Changement_Options_Attributs",
          },
          { label: "Migration d'offre ", value: "Migration_Offre" },
        ];

      case "SC Agents CRC Outbound N1 Ext_Ph2":
        return [{ label: "Migration d'offre ", value: "Migration_Offre" }];
      case "Support N3 Réseau_Ph2":
        return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];
      case "Fraude Int_Ph2":
        return [
          { label: "Suspension", value: "Suspension" },
          { label: "Réhabilitation", value: "Rehabilitation" },
          {
            label: "Suspension de ligne par fichier",
            value: "Suspension_par_fichier",
          },
          {
            label: "Réhabilitation de ligne par fichier",
            value: "Rehabilitation_par_fichier",
          },
        ];
      case "SPOC SAV_Ph2":
        return [
          {
            label: "Changement de carte SIM - SAV interne",
            value: "Changement_de_carte_SIM_SAV",
          },
          {
            label: "Changement de Terminal/Modem - SAV interne",
            value: "Changement_de_Terminal_SAV",
          },
        ];
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

    this.omniUpdateDataJson(MenuChoix);
    this.omniSaveState(MenuChoix, true);
  }

  render() {
    return template;
  }
}