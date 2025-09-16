import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_Motif_MigrationPostPre.html";

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class inwiB2C_Motif_MigrationPostPre extends OmniscriptBaseMixin(LightningElement) {
  @track value = "";

  @api index = 0;
  @track MenuChoix;

  @api options;
  @api profile;
  @api dealer;
  @api typeoffre;
  @api statutmdn;
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


    if (this.profile == "Inwi POS") {
        return [
          { label: "Résiliation suite demande client", value: "ResiliationDemande" },
          { label: "Résiliation suite recouvrement", value: "ResiliationRecouvrement" },
        ];
      
    
    }

      if (this.profile != "Inwi POS") {
        return [
           { label: "Résiliation suite demande client", value: "ResiliationDemande" },
          { label: "Résiliation suite recouvrement", value: "ResiliationRecouvrement" },
          ];
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