import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class Inwib2c_CheckEligibilityVulaOrangeActive extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  ND = "";

  actionUtil;
  _ns = getNamespaceDotNotation();

  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
  }


  handleND(event){
    this.ND= event.target.value;
    console.log("My ND is", this.NDlogin);
  }
}