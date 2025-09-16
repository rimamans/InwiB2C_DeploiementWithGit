import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
export default class InwiB2C_ChargementAssetGeneration extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  @track isLoaded = true;
  _ns = getNamespaceDotNotation();
  @api orderid;
  _actionUtilClass;
  checkstatus() {
    console.log("avant while");
    //  while (this.isLoaded === true) {
    console.log(this.isLoaded);
    setTimeout(() => {
      let input = `{"orderid":"` + this.orderid + `"}`;
      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "InwiB2C_checkOrderStatut",
        options: "{}",
      };
      console.log(params);
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log(response);
          if (response.error == false) {
            //console.log(response);
            if (
              response.result &&
              response.result.IPResult &&
              response.result.IPResult.statut === "Completed"
            ) {
              this.isLoaded = false;
              this.omniNextStep();
            } else {
              this.checkstatus();
            }
          }
        })
        .catch(error => {
          window.console.log(error);
        });
    }, 3000);
    // }
  }
  connectedCallback() {
    console.log("connected callback");
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.checkstatus();
  }
}