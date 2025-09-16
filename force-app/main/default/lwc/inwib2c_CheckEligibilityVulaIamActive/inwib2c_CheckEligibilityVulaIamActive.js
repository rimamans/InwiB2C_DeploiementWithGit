import { LightningElement, track } from "lwc";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

export default class Inwib2c_CheckEligibilityVulaIamActive extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  login = "";
  ND = "";

  actionUtil;
  _ns = getNamespaceDotNotation();

  connectedCallback() {
    this._actionUtil = new OmniscriptActionCommonUtil();
  }

  handleLogin(event){
    this.login = event.target.value;
    console.log("My Login is", this.NDlogin);
  }

  handleND(event){
    this.ND= event.target.value;
    console.log("My ND is", this.NDlogin);
  }
}