import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_MenuModification.html";

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_MenuModification extends OmniscriptBaseMixin(LightningElement) {
  @track value = "";

  @api index = 0;
  @track MenuChoix;

  @api options;
  @api profile;
  @api dealer;
  @api typeoffre;
  @api statutmdn;
  @api productoffer;
  @api productvlocityoffer;
  @api offerproductcode;
  //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA start
  @api servicetechnologie;
  //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end
  _actionUtilClass;
  _ns = getNamespaceDotNotation();

  renderedCallback() {
  
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
    console.log('productoffer' + this.productoffer);
  }
  getoptions() {
    // A-TA 16/01/2025 modification du menu d'affichage pour le profil BackOffice Wakil 
    if(this.profile == 'BackOffice Wakil')
    {
      return [ 
        {
          label: "Migration Prépayée Postpayée",
          value: "migrationprepost",
        }
      ]
    }

    //CH-Y 11/09/2025 MGEN3688-B2C Vente Wafacash Begin
    if(this.profile == 'Wafacash')
    {
      return [ 
        {
              label: "Remboursement d'offre",
              value: "remboursement",
        },
        {
          label: "Migration Prépayée Postpayée",
          value: "migrationprepost",
        }
      ]
    }
    //CH-Y 11/09/2025 MGEN3688-B2C Vente Wafacash

    console.log('le service ' + this.servicetechnologie);
    console.log('productoffer' + this.productvlocityoffer);
    if (this.offerproductcode == 'INWIB2C_OFFERING_PACK_INTERNET_DIRECT' || this.offerproductcode == 'INWIB2C_OFFERING_PACK_INTERNET_DEPANNAGE') {
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":
          return [
            {
              label: "Rehabilitation",
              value: "RehabilitationPackDepannage",
            },
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Terminal/Modem - SAV interne",
              value: "Changement_de_Terminal_SAV",
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
          ];
        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
        case "SC Agents CRC N1 Ext_Ph3":
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
          return [
            {
              label: "Rehabilitation",
              value: "RehabilitationPackDepannage",
            },
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Terminal/Modem - SAV interne",
              value: "Changement_de_Terminal_SAV",
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
          ];




        case "Inwi POS":

          return [
            {
              label: "Changement de Terminal/Modem",
              value: "Changement_de_Terminal_Modem",
            },
            {
              label: "Changement de carte SIM",
              value: "Changement_de_carte_SIM",
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":
        case "SC Superviseur BO CRC Ext_Ph3":
        case "Support N3 SI_Ph3":
        case "NV3 Facturation & recouvrement_Ph3":


        case "SC Agents CRC Outbound N1 Ext_Ph3":

        case "Support N3 Réseau_Ph3":

        case "Fraude Int_Ph3":


        case "SPOC SAV_Ph3":
          return [
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Terminal/Modem - SAV interne",
              value: "Changement_de_Terminal_SAV",
            }, {
              label: "Restitution équipement",
              value: "restitution"
            },
          ];
      }

    }
    if (this.typeoffre == "InwiB2C_Postpaye" && this.productvlocityoffer == 'ADSL')  {
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
           /* { label: "Changement de numéro", value: "Changement_de_Numero" },*/
           /* {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },*/
            // {
            //   label: "Changement de Modem",
            //   value: "ChangeModem",
            // },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
           /* {
              label: "Changement de carte SIM",
              value: "Changement_de_carte_SIM",
            },*/
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
           /* {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre",
            },*/
            {
              label: "Migration ADSL vers FTTH",
              value: "MigrationIdarFTTH"
            },
            //Y_MH migration ftth vula begin 
            {label: "Migration ADSL vers FTTH VULA ORANGE",value: "MigrationIdarFTTHORANGE"},
            {label: "Migration ADSL vers FTTH VULA IAM",value: "MigrationIdarFTTHIAM"},
            //Y_MH migration ftth vula end
            {label: "Retention ADSL ",value: "Retention_ADSL"},

            {
              label: "Migration Télévente ADSL vers FTTH",
              value: "MigrationIdarFTTHTelevente"
            },
            //CH-Y MGEN3747 FTTH_VULA éligibilité exigences ANRT Begin
            {
              label: "Migration Télévente ADSL vers FTTH VULA",
              value: "MigrationIdarFTTHTeleventeVula"
            },
            //CH-Y MGEN3747 FTTH_VULA éligibilité exigences ANRT End
            {
              label: "Restitution équipement",
              value: "restitution"
            },
              /**Rollback 02/01/2025 acyl Start */
            {
              label: "Migration ADSL vers IDAR",
              value: "migrationFTTHversIDARorADSL"
            },
            /**Rollback 02/01/2025 acyl End */

          ];
        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
           /* { label: "Changement de numéro", value: "Changement_de_Numero" },*/
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            }, 
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            { 
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs" 
            },

          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            //ANO 13473 CHB 04/02/2024
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {label: "Migration ADSL vers FTTH",value: "MigrationIdarFTTH"},
            
            //Y_MH migration ftth vula begin
            {label: "Migration ADSL vers FTTH VULA ORANGE",value: "MigrationIdarFTTHORANGE"},
            {label: "Migration ADSL vers FTTH VULA IAM",value: "MigrationIdarFTTHIAM"},
            //Y_MH migration ftth vula end

            {label: "Retention ADSL ",value: "Retention_ADSL"}


          ];

        case "Inwi POS":

          return [
            { label: "Suspension", value: "Suspension" },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },


            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Remboursement d'offre",
              value: "remboursement"
            },

            {
              label: "Migration ADSL vers FTTH",
              value: "MigrationIdarFTTH"
            },
            //Y_MH migration ftth vula begin
            {
              label: "Migration ADSL vers FTTH VULA ORANGE",
              value: "MigrationIdarFTTHORANGE"
            },
            {
              label: "Migration ADSL vers FTTH VULA IAM",
              value: "MigrationIdarFTTHIAM"
            },
            //Y_MH migration ftth vula end
            {label: "Retention ADSL ",value: "Retention_ADSL"} ,
            {
              label: "Restitution équipement",
              value: "restitution"
            },
               /**Rollback 02/01/2025 acyl Start */
               {
                label: "Migration ADSL vers IDAR",
                value: "migrationFTTHversIDARorADSL"
              },
              /**Rollback 02/01/2025 acyl End */
              /**MGEN3720 13/06/2025 ILA Start */
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
              /**MGEN3720 13/06/2025 ILA End */
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
          /*  { label: "Changement de numéro", value: "Changement_de_Numero" },*/
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
           
          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":

      

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
          /*  { label: "Changement de numéro", value: "Changement_de_Numero" },*/
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV"
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem"
            },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

            {
              label: "Produit libre",
              value: "Produit_libre"
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },

            { label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs" 
            },

            {
              label: "Changement de Terminal/Modem - SAV interne",
              value: "Changement_de_Terminal_SAV",
            },
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
           /* { label: "Changement de numéro", value: "Changement_de_Numero" },*/
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

            { label: "Changment de profil", value: "Changment_de_profil" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            }

          ];

        case "Support N3 SI_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
          /*  { label: "Changement de numéro", value: "Changement_de_Numero" },*/

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

          ];
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
           /* { label: "Changement de numéro", value: "Changement_de_Numero" },*/
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },
            { label: "Gestion mot de passe de la BV", 
            value: "Chang_MDP" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
           

          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Migration Postpayée Prépayée", value: "migrationpostpre" },
          ];

        case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },

          ];

        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
          ];

        case "SPOC SAV_Ph3":
          return [
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },
          ];
        case "SC Agents BO Eshop_Televente N2 Int_Ph3":
          return [
            {
              label: "Migration Télévente ADSL vers FTTH ",
              value: "MigrationIdarFTTHTelevente"
            },
            //CH-Y MGEN3747 FTTH_VULA éligibilité exigences ANRT Begin
            {
              label: "Migration Télévente ADSL vers FTTH VULA",
              value: "MigrationIdarFTTHTeleventeVula"
            },
            //CH-Y MGEN3747 FTTH_VULA éligibilité exigences ANRT End
          ];
      }

    }
    if (this.typeoffre == "InwiB2C_Postpaye" && this.productvlocityoffer == 'idar duo') {
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
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre",
            },
            {
              label: "migration inter technologies",
              value: "MigrationIdarFTTH"
            },
            {
              label: "migration inter technologies Télévente",
              value: "MigrationIdarFTTHTelevente"
            },
             //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA start affichage 
            {
             label: this.servicetechnologie == '4G' ? 'Migration Idar 4G vers 5G' : 'Migration Idar 5G vers 4G',
             value: this.servicetechnologie == '4G' ? 'migrationIdar4GVers5G' : 'migrationIdar5GVers4G',
            },
            //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end
            // {
            //   label: "Remboursement d'offre",
            //   value: "remboursement"
            // },
            // {
            //   label: "Restitution équipement",
            //   value: "restitution"
            // },


          ];
        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            }, {
              label: "Cession De Ligne",
              value: "cessionligne",
            }

          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            //  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
             //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA start
            {
             label: this.servicetechnologie == '4G' ? 'Migration Idar 4G vers 5G' : 'Migration Idar 5G vers 4G',
             value: this.servicetechnologie == '4G' ? 'migrationIdar4GVers5G' : 'migrationIdar5GVers4G',
            },
            //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end
            {
              label: "migration inter technologies",
              value: "MigrationIdarFTTH"
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            }

          ];
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
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
             {
               label: "Offre Cascade",
               value: "retention"
             },    
            {
              label: "Remboursement d'offre",
              value: "remboursement"
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
             //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA start
            {
             label: this.servicetechnologie == '4G' ? 'Migration Idar 4G vers 5G' : 'Migration Idar 5G vers 4G',
             value: this.servicetechnologie == '4G' ? 'migrationIdar4GVers5G' : 'migrationIdar5GVers4G',
            },
            //SL-R 29/05/2025  MGEN3675A-Eclipse_Offre 5G Home B2C_LotA end
            {
              label: "migration inter technologies",
              value: "MigrationIdarFTTH"
            },
          ];
        case "Inwi POS_Ph3":

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
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


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
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            }
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

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
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            }
          ];

        case "Support N3 SI_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

          ];
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
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
            }
             ,
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Migration Postpayée Prépayée", value: "migrationpostpre" },
          ];

        case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
          ];

        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
          ];

        case "SPOC SAV_Ph3":
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
          case "SC Agents BO Eshop_Televente N2 Int_Ph3":
          return [
            {
              label: "migration inter technologies Télévente",
              value: "MigrationIdarFTTHTelevente"
            },
          ];
      }

    }
    if (this.typeoffre == "InwiB2C_Postpaye" && this.productvlocityoffer == 'FTTH') {
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            /*{
              label: "Changement de Modem",
              value: "ChangeModem",
            },*/
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },      
           // H-M Ne pas afficher ce button sur les lignes FTTH Begin 
            // { label: "migration inter technologies",
            // value: "MigrationIdarFTTH"
            // },
           // H-M Ne pas afficher ce button sur les lignes FTTH END

            // { label: "migration inter technologies Télévente",
            // value: "MigrationIdarFTTHTelevente"
            // },
            /*  {
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
                label: "Changement Options/Attributs",
                value: "Changement_Options_Attributs",
              },
              {
                label: "Produit libre",
                value: "Produit_libre",
              },
              {
                label: "Modification du forfait",
                value: "migrationpostpost",
              },
              {
                label: "Cession De Ligne",
                value: "cessionligne",
              },
              {
                label: "Changement type de ligne",
                value: "Changement_type_ligne"
              },
           /*   {
                label: "Migration Postpayée Prépayée",
                value: "migrationpostpre",
              },*/
            /* {
               label: "Offre Cascade",
               value: "retention"
             },    */
            // {
            //   label: "Remboursement d'offre",
            //   value: "remboursement"
            // },
            // {
            //   label: "Restitution équipement",
            //   value: "restitution"
            // },
            
            /**Rollback 02/01/2025 acyl Start */
            { label: "Migration Rollback Intertechnologie",
              value: "migrationFTTHversIDARorADSL"
              },
            /**Rollback 02/01/2025 acyl End */


          ];
        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            //  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
        
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            // H-M Ne pas afficher ce button sur les lignes FTTH Begin 
            // { label: "migration inter technologies",
            //   value: "MigrationIdarFTTH"
            // },
            // H-M Ne pas afficher ce button sur les lignes FTTH END
     

          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "migration inter technologies",value: "MigrationIdarFTTH" },

            
           
     

        
            



            //   { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

          ];
        case "Inwi POS":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            /*   {
                 label: "Changement de carte SIM",
                 value: "Changement_de_carte_SIM",
               },
               {
                 label: "Changement de Terminal/Modem",
                 value: "Changement_de_Terminal_Modem",
               },*/
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },
            {
              label: "Offre Cascade",
              value: "retention"
            },    
            {
              label: "Remboursement d'offre",
              value: "remboursement"
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
            {
              label: "Remboursement Suite Refus De Porta FTTH",
              value: "remboursementSuiteRefusDePortaFTTH"
            },
            /**Rollback 02/01/2025 acyl Start */
            { label: "Migration Rollback Intertechnologie",
              value: "migrationFTTHversIDARorADSL"
              },
            /**Rollback 02/01/2025 acyl End */
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            // { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
              {
              label: "Changement Options/Attributs",
               value: "Changement_Options_Attributs",
             },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
           
            /*   {
                 label: "Migration Postpayée Prépayée",
                 value: "migrationpostpre"
               },*/

          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },

            //  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },


            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            /*{
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },*/
              {
                label: "Produit libre",
                value: "Produit_libre"
              },
              {
                label: "Changement de Modem",
                value: "ChangeModem",
              },
           
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            

            //*  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },*/

          
            /*  {
                label: "Produit libre",
                value: "Produit_libre",
              },*/
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            /* {
               label: "Migration Postpayée Prépayée",
               value: "migrationpostpre"
             },*/
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },
          ];

        case "Support N3 SI_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

          ];
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            { label: "migration inter technologies",value: "MigrationIdarFTTH" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            }, 
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },
          
          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            //   {label: "Migration Postpayée Prépayée",value: "migrationpostpre"},
          ];

        case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
     
          ];

        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
             /**Boost FTTH 23/05/2024 Ila Start */
          { label: "Activation Boost", value: "Activation_Boost_FTTH" },
          /**Boost FTTH 23/05/2024 Ila End */
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
          ];

        case "SPOC SAV_Ph3":
          return [
            /**Boost FTTH 23/05/2024 Ila Start */
            { label: "Activation Boost", value: "Activation_Boost_FTTH" },
            /**Boost FTTH 23/05/2024 Ila End */
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Modem",
              value: "ChangeModem",
            },

          ];

      }

    }
    if (this.typeoffre == "InwiB2C_Postpaye" && this.productvlocityoffer == 'Cascade' ) {//CHB 18/07/2023 ano B-10342
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            /*{
              label: "Changement de Modem",
              value: "ChangeModem",
            },*/
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
          /*  {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            }*/
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end  
            { label: "migration inter technologies",
            value: "MigrationIdarFTTH"
            },
            { label: "migration inter technologies Télévente",
            value: "MigrationIdarFTTHTelevente"
            },
            /*  {
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
                label: "Changement Options/Attributs",
                value: "Changement_Options_Attributs",
              },
              {
                label: "Produit libre",
                value: "Produit_libre",
              },
              {
                label: "Modification du forfait",
                value: "migrationpostpost",
              },
              {
                label: "Cession De Ligne",
                value: "cessionligne",
              },
              {
                label: "Changement type de ligne",
                value: "Changement_type_ligne"
              },
           /*   {
                label: "Migration Postpayée Prépayée",
                value: "migrationpostpre",
              },*/
             {
               label: "Offre Cascade",
               value: "retention"
             },    
            // {
            //   label: "Remboursement d'offre",
            //   value: "remboursement"
            // },
            // {
            //   label: "Restitution équipement",
            //   value: "restitution"
            // },


          ];
        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            //  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
        
          //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
     
            { label: "migration inter technologies",
              value: "MigrationIdarFTTH"
            },

          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "migration inter technologies",value: "MigrationIdarFTTH" },

            
           
     

        
            



            //   { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end

          ];
        case "Inwi POS":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            /*   {
                 label: "Changement de carte SIM",
                 value: "Changement_de_carte_SIM",
               },
               {
                 label: "Changement de Terminal/Modem",
                 value: "Changement_de_Terminal_Modem",
               },*/
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
           /* {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },*/
            /* {
              label: "Changement de Modem",
              value: "ChangeModem",
            }, */
           {
              label: "Offre Cascade",
              value: "retention"
            },    
            {
              label: "Remboursement d'offre",
              value: "remboursement"
            },
            {
              label: "Restitution équipement",
              value: "restitution"
            },
            {
              label: "Remboursement Suite Refus De Porta FTTH",
              value: "remboursementSuiteRefusDePortaFTTH"
            },
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            // { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
              {
              label: "Changement Options/Attributs",
               value: "Changement_Options_Attributs",
             },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
           
            /*   {
                 label: "Migration Postpayée Prépayée",
                 value: "migrationpostpre"
               },*/

          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },

            //  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },


            /*{
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },*/
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
            /*{
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },*/
              {
                label: "Produit libre",
                value: "Produit_libre"
              },
           
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            

            //*  { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },*/

          
            /*  {
                label: "Produit libre",
                value: "Produit_libre",
              },*/
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
            /* {
               label: "Migration Postpayée Prépayée",
               value: "migrationpostpre"
             },*/
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
           /* {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },*/
            {
              label: "Restitution équipement",
              value: "restitution"
            },
          ];

        case "Support N3 SI_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            // {
            //   label: "Changement Options/Attributs",
            //   value: "Changement_Options_Attributs",
            // },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end

          ];
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
            { label: "migration inter technologies",value: "MigrationIdarFTTH" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
          
          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            //   {label: "Migration Postpayée Prépayée",value: "migrationpostpre"},
          ];

       /* case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [

            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  
            //R-SL 17/06/2025 ticket B-29358 end
          ];
*/
        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            //R-SL 17/06/2025 ticket B-29358 start
            /*{
              label: "Modification du forfait",
              value: "migrationpostpost",
            },  */
            //R-SL 17/06/2025 ticket B-29358 end
          ];

        case "SPOC SAV_Ph3":
          return [
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },

          ];
      }

    }




    if (this.productvlocityoffer == 'Cameleon') {
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre",
            },
            /**Campus connecte postpaye ILA 25/04/2024 Start */
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne",
            },
            /**Campus connecte postpaye ILA 25/04/2024 Start */
            
          ];
        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
            /**B-16596 ILA 30/05/2024 start */
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            /**B-16596 ILA 30/05/2024 end */           
          ];
        case "Inwi POS":
        case "Commercial Nomade":
        case "Commercial Chef d'agence":

          return [
            { label: "Suspension", value: "Suspension" },
            //{ label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {
              label: "Changement de carte SIM",
              value: "Changement_de_carte_SIM",
            },
            {
              label: "Résiliation",
              value: "DemandeResiliationCameleon",
            },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
            /**Campus connecte postpaye ILA 25/04/2024 Start */
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne",
            },
            /**Campus connecte postpaye ILA 25/04/2024 Start */
          ];
        case "Inwi POS_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {
              label: "Changement de carte SIM",
              value: "Changement_de_carte_SIM",
            },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            /*{
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },*/
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            /**B-14561 ILA 19/04/2024 Start  */
            /*
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Terminal/Modem - SAV interne",
              value: "Changement_de_Terminal_SAV",
            },
            */
            /**B-14561 ILA 19/04/2024 End  */
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            /**B-14561 ILA 19/04/2024 Start  */
            /*
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            */
            /**B-14561 ILA 19/04/2024 End  */
            /**Campus connecte postpaye ILA 25/04/2024 Start */
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne",
            },
            /**Campus connecte postpaye ILA 25/04/2024 Start */
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "Support N3 SI_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },

          ];
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
            /**B-14561 ILA 19/04/2024 Start  */
            /*{
              label: "Produit libre",
              value: "Produit_libre",
            },
            */
            /**B-14561 ILA 19/04/2024 Start  */
          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "demandemigrationcameleon",
            },
          ];

        case "SPOC SAV_Ph3":
          return [
            /**B-14561 ILA 19/04/2024 Start  */
            /*
            {
              label: "Changement de carte SIM - SAV interne",
              value: "Changement_de_carte_SIM_SAV",
            },
            {
              label: "Changement de Terminal/Modem - SAV interne",
              value: "Changement_de_Terminal_SAV",
            },
            */
            /**B-14561 ILA 19/04/2024 End  */
          ];
      }

    }



    // if (this.typeoffre == "InwiB2C_Postpaye" && this.productvlocityoffer == 'Postpaye') {
    //   switch (this.profile) {
    //     case "Administrateur système":
    //     case "System Administrator":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         {
    //           label: "Changement de carte SIM - SAV interne",
    //           value: "Changement_de_carte_SIM_SAV",
    //         },
    //         // {
    //         //   label: "Changement de Modem",
    //         //   value: "ChangeModem",
    //         // },
    //         { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
    //         {
    //           label: "Changement de carte SIM",
    //           value: "Changement_de_carte_SIM",
    //         },
    //         {
    //           label: "Changement Options/Attributs",
    //           value: "Changement_Options_Attributs",
    //         },
    //         {
    //           label: "Produit libre",
    //           value: "Produit_libre",
    //         },
    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },
    //         {
    //           label: "Cession De Ligne",
    //           value: "cessionligne",
    //         },
    //         {
    //           label: "Changement type de ligne",
    //           value: "Changement_type_ligne"
    //         },
    //         {
    //           label: "Migration Postpayée Prépayée",
    //           value: "migrationpostpre",
    //         },
    //         // {
    //         //   label: "Restitution équipement",
    //         //   value: "restitution"
    //         // },
    //       ];
    //     case "SC Agents CRC Helpdesk N1 Ext_Ph3":
    //     case "SC Superviseur CRC Ext_Ph3":
    //     case "SC Agents BO_Controle PDV N2 Ext_Ph3":
    //     case "SC Superviseur FO CRC Int_Ph3":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         }, {
    //           label: "Cession De Ligne",
    //           value: "cessionligne",
    //         }

    //       ];

    //     case "SC Agents CRC N1 Ext_Ph3":

    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },


    //       ];

    //     case "Inwi POS":

    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         {
    //           label: "Changement de carte SIM",
    //           value: "Changement_de_carte_SIM",
    //         },
    //         {
    //           label: "Changement de Terminal/Modem",
    //           value: "Changement_de_Terminal_Modem",
    //         },
    //         {
    //           label: "Changement Options/Attributs",
    //           value: "Changement_Options_Attributs",
    //         },

    //         { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
    //         { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },
    //         {
    //           label: "Cession De Ligne",
    //           value: "cessionligne",
    //         },
    //         {
    //           label: "Changement type de ligne",
    //           value: "Changement_type_ligne"
    //         },
    //       ];

    //     case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
    //     case "SC Formation Int_Ph3":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },
    //         {
    //           label: "Migration Postpayée Prépayée",
    //           value: "migrationpostpre"
    //         },
    //       ];

    //     case "SC Agents BO réclamation N2_Ph3":
    //     case "SC Superviseur BO CRC Int_Ph3":


    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         {
    //           label: "Changement de carte SIM - SAV interne",
    //           value: "Changement_de_carte_SIM_SAV",
    //         },
    //         {
    //           label: "Changement de Modem",
    //           value: "ChangeModem",
    //         },
    //         { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

    //         {
    //           label: "Produit libre",
    //           value: "Produit_libre",
    //         },
    //         {
    //           label: "Changement type de ligne",
    //           value: "Changement_type_ligne"
    //         },

    //         {
    //           label: "Cession De Ligne",
    //           value: "cessionligne",
    //         }
    //       ];

    //     case "SC Superviseur BO CRC Ext_Ph3":

    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         {
    //           label: "Changement de carte SIM - SAV interne",
    //           value: "Changement_de_carte_SIM_SAV",
    //         },
    //         {
    //           label: "Changement de Modem",
    //           value: "ChangeModem",
    //         },
    //         { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

    //         { label: "Changment de profil", value: "Changment_de_profil" },
    //         {
    //           label: "Produit libre",
    //           value: "Produit_libre",
    //         },
    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },
    //         {
    //           label: "Migration Postpayée Prépayée",
    //           value: "migrationpostpre"
    //         },
    //         {
    //           label: "Cession De Ligne",
    //           value: "cessionligne",
    //         },
    //         {
    //           label: "Changement type de ligne",
    //           value: "Changement_type_ligne"
    //         }
    //       ];

    //     case "Support N3 SI_Ph3":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },

    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },

    //       ];
    //     case "SC Superviseur BO CRC Ext_Ph3":
    //     case "SC Agent VIP Int_Ph3":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Changement de numéro", value: "Changement_de_Numero" },
    //         {
    //           label: "Changement de carte SIM - SAV interne",
    //           value: "Changement_de_carte_SIM_SAV",
    //         },
    //         {
    //           label: "Changement de Modem",
    //           value: "ChangeModem",
    //         },
    //         { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },

    //         {
    //           label: "Cession De Ligne",
    //           value: "cessionligne",
    //         },
    //         {
    //           label: "Modification Plafond risque",
    //           value: "Modification_Plafond_Risque",
    //         }

    //       ];
    //     case "NV3 Facturation & recouvrement_Ph3":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         { label: "Migration Postpayée Prépayée", value: "migrationpostpre" },
    //       ];

    //     case "SC Agents CRC Outbound N1 Ext_Ph3":
    //       return [

    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },

    //       ];

    //     case "Support N3 Réseau_Ph3":
    //       return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

    //     case "Fraude Int_Ph3":
    //       return [
    //         { label: "Suspension", value: "Suspension" },
    //         { label: "Réhabilitation", value: "Rehabilitation" },
    //         {
    //           label: "Modification du forfait",
    //           value: "migrationpostpost",
    //         },
    //       ];

    //     case "SPOC SAV_Ph3":
    //       return [
    //         {
    //           label: "Changement de carte SIM - SAV interne",
    //           value: "Changement_de_carte_SIM_SAV",
    //         },
    //         {
    //           label: "Changement de Modem",
    //           value: "ChangeModem",
    //         },
    //       ];
    //   }

    // }



    if (this.typeoffre == "InwiB2C_Postpaye" && this.productoffer == 'GSM') {


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
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre",
            },
            /* {
               label: "Déconnecter Service",
               value: "deconnecterservice"
             },*/
          ];



        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
          ];
        case "Inwi POS_Ph3":
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

            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Remboursement d'offre",
              value: "remboursement"
            }
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


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

            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            }
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

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
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Changement type de ligne",
              value: "Changement_type_ligne"
            }
          ];

        case "Support N3 SI_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            }, {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

          ];
        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
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
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Migration Postpayée Prépayée",
              value: "migrationpostpre"
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification Plafond risque",
              value: "Modification_Plafond_Risque",
               }
          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Migration Postpayée Prépayée", value: "migrationpostpre" }
            ,
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
          ];

        case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            { label: "Suspension de Facturation", value: "Suspension_de_Facturation" },
            { label: "Réhabilitation de Facturation", value: "rehabilitation_de_Facturation" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
          ];

        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
          ];

        case "SPOC SAV_Ph3":
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

    } else if (this.typeoffre == "InwiB2C_Postpaye" && this.productoffer == 'Data') {
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },


            {
              label: "Sharing data",
              value: "Sharing_data",
            },
            /*{
              label: "Déconnecter Service",
              value: "deconnecterservice"
            },*/
          ];



        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },


            {
              label: "Sharing data",
              value: "Sharing_data",
            },
          ];

        case "SC Agents CRC N1 Ext_Ph3":

          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },

            {
              label: "Sharing data",
              value: "Sharing_data",
            }
          ];
        case "Inwi POS_Ph3":
        case "Inwi POS":
        case "Commercial Nomade":
        case "Commercial Chef d'agence":


          return [
            { label: "Suspension", value: "Suspension" },
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
           // { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

            {
              label: "Cession De Ligne",
              value: "cessionligne",
            }
          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

            {
              label: "Sharing data",
              value: "Sharing_data",
            }
          ];

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


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
            },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

            {
              label: "Sharing data",
              value: "Sharing_data",
            },
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            }
          ];

        case "SC Superviseur BO CRC Ext_Ph3":

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
            },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "Changment de profil", value: "Changment_de_profil" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

            {
              label: "Sharing data",
              value: "Sharing_data",
            }
          ];

        case "Support N3 SI_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },

          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },

          ];

        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
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
            },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },

            {
              label: "Sharing data",
              value: "Sharing_data",
            }
            ,
            {
              label: "Cession De Ligne",
              value: "cessionligne",
            },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },
          ];

        case "SC Agents CRC Outbound N1 Ext_Ph3":
          return [
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },

            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },];

        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];

        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Modification du forfait",
              value: "migrationpostpost",
            },
          ];

        case "SPOC SAV_Ph3":
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

    if (this.dealer == "Dealer") {
      if (this.profile == "Inwi POS") {
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
      } else {
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
    if (this.productoffer == "Data") {
      switch (this.profile) {
        case "Administrateur système":
        case "System Administrator":


          return [
            { label: "Suspension", value: "Suspension" },
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
          ];


        case "SC Agents CRC Helpdesk N1 Ext_Ph2":
        case "SC Superviseur CRC Ext_Ph2":
        case "SC Agents BO_Controle PDV N2 Ext_Ph2":
        case "SC Superviseur FO CRC Int_Ph2":

        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },

          ];


        case "SC Agents CRC N1 Ext_Ph2":
        case "SC Agents CRC N1 Ext_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },

          ];
        case "Inwi POS_Ph2":
        case "Inwi POS":
        case "Commercial Nomade":
        case "Commercial Chef d'agence":


          return [
            { label: "Suspension", value: "Suspension" },
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },

          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph2":
        case "SC Formation Int_Ph2":

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
          ];

        case "SC Agents BO réclamation N2_Ph2":
        case "SC Superviseur BO CRC Int_Ph2":

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },


          ];

        case "SC Superviseur BO CRC Ext_Ph2":
        case "SC Superviseur BO CRC Ext_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
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

        case "Support N3 SI_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
          ];


        case "SC Superviseur BO CRC Ext_Ph2":
        case "SC Agent VIP Int_Ph2":

        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },

          ];

        case "SC Agents CRC Outbound N1 Ext_Ph2":
        case "SC Agents CRC Outbound N1 Ext_Ph3":


          return [{ label: "migration koulchi vers tic tac ", value: "Migration_Offre" },

          ];

        case "Support N3 Réseau_Ph2":
        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];
        case "Fraude Int_Ph2":
        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },


          ];
        case "SPOC SAV_Ph2":
        case "SPOC SAV_Ph3":
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
    } else {
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Migration Prépayée Postpayée",
              value: "migrationprepost",
            },
            {
              label: "Migration B2C vers B2B",
              value: "migrationB2CversB2B",
            },
            {
              label: "Migration Campus Connecté vers Prépayée ",
              value: "MigrationCampusConnectePrepaye",
            }
          ];


        case "SC Agents CRC Helpdesk N1 Ext_Ph2":
        case "SC Superviseur CRC Ext_Ph2":
        case "SC Agents BO_Controle PDV N2 Ext_Ph2":
        case "SC Superviseur FO CRC Int_Ph2":

        case "SC Agents CRC Helpdesk N1 Ext_Ph3":
        case "SC Superviseur CRC Ext_Ph3":
        case "SC Agents BO_Controle PDV N2 Ext_Ph3":
        case "SC Superviseur FO CRC Int_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Migration Prépayée Postpayée",
              value: "migrationprepost",
            },
            {
              label: "Migration B2C vers B2B",
              value: "migrationB2CversB2B",
            },
            {
              label: "Migration Campus Connecté vers Prépayée ",
              value: "MigrationCampusConnectePrepaye",
            }


          ];
        case "NV3 Facturation & recouvrement_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
          ];


        case "SC Agents CRC N1 Ext_Ph2":
        case "SC Agents CRC N1 Ext_Ph3":


          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            { label: "Changement de numéro", value: "Changement_de_Numero" },
            { label: "Gestion mot de passe de la BV", value: "Chang_MDP" },
            {
              label: "Changement Options/Attributs",
              value: "Changement_Options_Attributs",
            },
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            { label: "Migration Prépayée Postpayée", value: "migrationprepost" },
            {
              label: "Migration B2C vers B2B",
              value: "migrationB2CversB2B",
            },
                        {
              label: "Migration Campus Connecté vers Prépayée ",
              value: "MigrationCampusConnectePrepaye",
            }


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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Migration Prépayée Postpayée",
              value: "migrationprepost",
            },
            {
              label: "Migration B2C vers B2B",
              value: "migrationB2CversB2B",
            },
            {
              label: "Migration Prépayée vers Campus Connecté",
              value: "MigrationPrepayeCampusConnecte",
            }

          ];

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph2":
        case "SC Formation Int_Ph2":

        case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
        case "SC Formation Int_Ph3":


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

        case "SC Agents BO réclamation N2_Ph3":
        case "SC Superviseur BO CRC Int_Ph3":


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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },



          ];

        case "SC Superviseur BO CRC Ext_Ph2":
        case "SC Superviseur BO CRC Ext_Ph3":


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

        case "Support N3 SI_Ph3":


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

        case "SC Superviseur BO CRC Ext_Ph3":
        case "SC Agent VIP Int_Ph3":
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
            { label: "migration koulchi vers tic tac ", value: "Migration_Offre" },
            {
              label: "Produit libre",
              value: "Produit_libre",
            },


          ];

        case "SC Agents CRC Outbound N1 Ext_Ph2":
        case "SC Agents CRC Outbound N1 Ext_Ph3":


          return [{ label: "migration koulchi vers tic tac ", value: "Migration_Offre" },


          ];

        case "Support N3 Réseau_Ph2":
        case "Support N3 Réseau_Ph3":
          return [{ label: "Gestion mot de passe de la BV", value: "Chang_MDP" }];
        case "Fraude Int_Ph2":
        case "Fraude Int_Ph3":
          return [
            { label: "Suspension", value: "Suspension" },
            { label: "Réhabilitation", value: "Rehabilitation" },
            {
              label: "Migration Prépayée Postpayée",
              value: "migrationprepost",
            },
            {
              label: "Migration B2C vers B2B",
              value: "migrationB2CversB2B",
            },
            {
              label: "Migration Campus Connecté vers Prépayée ",
              value: "MigrationCampusConnectePrepaye",
            }


          ];
        case "SPOC SAV_Ph2":
        case "SPOC SAV_Ph3":
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