/* eslint-disable eqeqeq */
/* eslint-disable no-else-return */
/* eslint-disable @lwc/lwc/no-api-reassignments */
/* eslint-disable no-unused-vars */
/* eslint-disable @lwc/lwc/valid-api */
/* eslint-disable @lwc/lwc/no-leading-uppercase-api-name */
import { LightningElement, api, wire, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_DisplayOperationChoice.html";

export default class inwiB2C_DisplayOperationChoice extends OmniscriptBaseMixin(
  LightningElement
) {
  @track
  value = "";
  @api
  _actionUtilClass;

  __iscameleon;

  @api
  get iscameleon() {
    return this.__iscameleon;
  }

  set iscameleon(value) {
    this.__iscameleon = value;
  }

  get options() {
    if (this.iscameleon == "true") {
      return [{ label: "Paiement des factures", value: "invoicePayment" }];
    } else {
      return [
        { label: "Paiement des factures", value: "invoicePayment" },
        { label: "Paiement en avance", value: "freeAmount" }
      ];
    }
  }

  connectedCallback() {
    console.log("selectedchoiceoperation" + this.options[0].value);

    let selectedchoiceoperation = {
      selectedchoiceoperation: this.options[0].value
    };
    this.omniUpdateDataJson(selectedchoiceoperation);
    this.omniSaveState(selectedchoiceoperation, true);
    this.value = this.options[0].value;
    //  console.log("CallBack"+this.options[0].value);
    this._actionUtilClass = new OmniscriptActionCommonUtil();
  }
  handleSelectedOperation(event) {
    console.log("selectedchoiceoperation" + event.detail.value);

    let selectedchoiceoperation = {
      selectedchoiceoperation: event.detail.value
    };
    this.omniUpdateDataJson(selectedchoiceoperation);
    this.omniSaveState(selectedchoiceoperation, true);
  }
  render() {
    return template;
  }
}