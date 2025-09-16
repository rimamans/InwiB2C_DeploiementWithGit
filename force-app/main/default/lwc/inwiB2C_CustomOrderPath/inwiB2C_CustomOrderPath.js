import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_CustomOrderPath.html";

export default class InwiB2C_CustomOrderPath extends OmniscriptBaseMixin(
  LightningElement
) {
  @track steps;

  __records;
  @api
  get records() {
    return this.__records;
  }

  set records(value) {
    this.__records = value;
  }

  allSteps = [
    { label: "En cours", value: "inwiB2C_EnCours", index: "1234" },
    { label: "Paiement", value: "inwiB2C_Paiement", index: "1234" },
    { label: "Finalisation", value: "inwiB2C_Finalisation", index: "1234" },
    { label: "Activation", value: "inwiB2C_Activation", index: "1234" },
    { label: "Annulée", value: "inwiB2C_Annulee", index: "1234" },
    { label: "Activée", value: "inwiB2C_Activee", index: "1234" },
    { label: "Conforme", value: "inwiB2C_Conforme", index: "1" },
    { label: "Non Conforme", value: "inwiB2C_NonConforme", index: "1" },
    { label: "Validée BO", value: "inwiB2C_ValideeBO", index: "23" },
    { label: "Refusée BO", value: "inwiB2C_RefuseeBO", index: "23" },
  ];

  connectedCallback() {
    console.log("hello records ----------");
    console.log(this.__records);
    this.initSteps();
  }

  initSteps() {
    let index = "0";
    if (this.typecommande == "inwiB2C_Acquisition") {
      index = "1";
    } else if (this.typecommande == "inwiB2C_Migration") {
      index = "3";
    } else if (
      this.typecommande == "inwiB2C_Modification" &&
      (this.reglegestion == "inwiB2C_Rehabilitation" ||
        this.reglegestion == "inwiB2C_Suspension")
    ) {
      index = "4";
    } else if (
      this.typecommande == "inwiB2C_Modification" &&
      this.reglegestion !== "inwiB2C_Rehabilitation" &&
      this.reglegestion != "inwiB2C_Suspension"
    ) {
      index = "2";
    }

    // get steps array
    this.steps = this.allSteps.filter(item => {
      return item.index.includes(index);
    });
  }

  render() {
    //console.log(this.omniJsonData);
    return template;
  }
}