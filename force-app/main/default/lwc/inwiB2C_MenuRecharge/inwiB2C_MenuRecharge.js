import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_MenuRecharge.html";

export default class InwiB2C_MenuRecharge extends OmniscriptBaseMixin(
  LightningElement
) {
  @track value = "";

  @api index = 0;
  @track MenuChoix;

  @api options;
  @api userprofile;
  @api dealer;

  getoptions() {
    console.log("this.userprofile == " + this.userprofile);
    console.log("this.userprofile == " + this.dealer);
    if(this.dealer=="Dealer"){
        return [
          {
            label: "Déblocage de la méthode de recharge",
            value: "UnlockRecharge",
          },       
          {
            label: "Problème recharge en ligne",
            value: "OnlineRechargeProblem",
          },
          { label: "Recharge manuelle", value: "ManualRecharge" }
        ];
      }
    switch (this.userprofile) {
      case "Administrateur système":
      case "System Administrator":
      case "SC Agents CRC N1 Ext_Ph2":
      case "SC Agents CRC Helpdesk N1 Ext_Ph2":
      case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph2":
      case "SC Agents BO réclamation N2_Ph2":
      case "SC Superviseur CRC Ext_Ph2":
      case "SC Superviseur BO CRC Ext_Ph2":
      case "SC Superviseur BO CRC Int_Ph2":
      case "SC Superviseur FO CRC Int_Ph2":
      case "SC Agent VIP Int_Ph2":
      case "SC Agents BO_Controle PDV N2 Ext_Ph2":
      case "SC Formation Int_Ph2":
      case "SC Agents CRC N1 Ext_Ph3":
      case "SC Agents CRC Helpdesk N1 Ext_Ph3":
      case "SC Agents CRC Savedesk_Recouv N1 Ext_Ph3":
      case "SC Agents BO réclamation N2_Ph3":
      case "SC Superviseur CRC Ext_Ph3":
      case "SC Superviseur BO CRC Ext_Ph3":
      case "SC Superviseur BO CRC Int_Ph3":
      case "SC Superviseur FO CRC Int_Ph3":
      case "SC Agent VIP Int_Ph3":
      case "SC Agents BO_Controle PDV N2 Ext_Ph3":
      case "SC Formation Int_Ph3":
        return [
          {
            label: "Déblocage de la méthode de recharge",
            value: "UnlockRecharge",
          },
          { label: "Problème de la Scratch Card", value: "ScratchCardProblem" },
          {
            label: "Problème recharge en ligne",
            value: "OnlineRechargeProblem",
          },
          { label: "Recharge manuelle", value: "ManualRecharge" },
          { label: "Services Pass et sous produit IN", value: "Services_PASS" },
          { label: "Service contenu", value: "Services_VAS" },
        ];

      case "Support N3 SI_Ph2":
      case "Support N3 SI_Ph3":
        return [
          {
            label: "Déblocage de la méthode de recharge",
            value: "UnlockRecharge",
          },
          { label: "Problème de la Scratch Card", value: "ScratchCardProblem" },
          { label: "Recharge manuelle", value: "ManualRecharge" },
          { label: "Services Pass et sous produit IN", value: "Services_PASS" },
          { label: "Service contenu", value: "Services_VAS" },
        ];

      case "Support N3 Réseau_Ph2":
     
        return [
          {
            label: "Déblocage de la méthode de recharge",
            value: "UnlockRecharge",
          },
          { label: "Problème de la Scratch Card", value: "ScratchCardProblem" },
          { label: "Services Pass et sous produit IN", value: "Services_PASS" },
        ];
      case "Support N3 Réseau_Ph3":
        return [
          {
            label: "Déblocage de la méthode de recharge",
            value: "UnlockRecharge",
          },
          { label: "Problème de la Scratch Card", value: "ScratchCardProblem" },
          { label: "Services Pass et sous produit IN", value: "Services_PASS" },
          { label: "Service contenu", value: "Services_VAS" },
        ];

      case "SC Agents CRC Outbound N1 Ext_Ph2":
      case "SC Agents BO Eshop_Televente N2 Int_Ph2":
      case "SC Agents CRC Outbound N1 Ext_Ph3":
      case "SC Agents BO Eshop_Televente N2 Int_Ph3":
        return [
          { label: "Services Pass et sous produit IN", value: "Services_PASS" },
          { label: "Service contenu", value: "Services_VAS" },
        ];

      case "Fraude Int_Ph2":
      case "Fraude Int_Ph3":
        return [
          { label: "Problème de la Scratch Card", value: "ScratchCardProblem" },
        ];
      default:
        return [
          {
            label: "Déblocage de la méthode de recharge",
            value: "UnlockRecharge",
          },
          { label: "Problème de la Scratch Card", value: "ScratchCardProblem" },
          { label: "Recharge manuelle", value: "ManualRecharge" },
          { label: "Services Pass et sous produit IN", value: "Services_PASS" },
          { label: "Service contenu", value: "Services_VAS" },
        ];
    }
  }

  ChangeMenuEvent(event) {
    this.MenuChoix = event.detail.label;

    let selectedLine = this.options.find(x => x.value === event.detail.value);

    //console.log(JSON.stringify(selectedLine));

    let MenuChoix = {
      SelectedChoiceId: selectedLine.value,
      SelectedQueueName: selectedLine.label,
    };

    this.omniUpdateDataJson(MenuChoix);
    this.omniSaveState(MenuChoix, true);
  }

  render() {
    if (this.index == 0) {
      this.index = 1;
      console.log("here before jo");
      console.log(this.userprofile);
      console.log(this.getoptions());
      //let selectedLine = this.options[0];
      this.options = this.getoptions();
      let selectedLine = this.options[0];
      console.log("here jo");
      let MenuChoix = {
        SelectedChoiceId: selectedLine.value,
        SelectedQueueName: selectedLine.label,
      };

      this.value = this.options[0].value;

      this.omniUpdateDataJson(MenuChoix);
      this.omniSaveState(MenuChoix, true);
    }
    return template;
  }
}