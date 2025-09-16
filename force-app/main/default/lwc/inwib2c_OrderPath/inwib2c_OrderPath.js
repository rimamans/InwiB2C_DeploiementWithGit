import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwib2c_OrderPath.html";

export default class Inwib2c_OrderPath extends OmniscriptBaseMixin(
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
    console.log("__records1" + JSON.stringify(this.__records));
    this.initSteps();
  }

  allSteps = [
    { label: "En cours", value: "inwiB2C_EnCours", index: "12345" },
    { label: "Paiement", value: "inwiB2C_Paiement", index: "12345" },
    { label: "Finalisation", value: "inwiB2C_Finalisation", index: "12345" },
    { label: "En cours de validation BO", value: "En attente d'approbation", index: "15" },
    { label: "Activation", value: "inwiB2C_Activation", index: "12345" },
     { label: "A Annuler", value: "inwiB2C_A_Annuler", index: "12345" },
    { label: "Annulée", value: "inwiB2C_Annulee", index: "12345" },
    { label: "Activée", value: "inwiB2C_Activee", index: "12345" },
    // { label: "Conforme", value: "inwiB2C_Conforme", index: "1" },
    // { label: "Non Conforme", value: "inwiB2C_NonConforme", index: "1" },
    { label: "Validée BO", value: "inwiB2C_ValideeBO", index: "235" },
    { label: "Refusée BO", value: "inwiB2C_RefuseeBO", index: "235" },
  ];

  connectedCallback() {
    console.log("dddddd records ----------");
    console.log(JSON.stringify(this.__records));
    //this.initSteps();
    //window.location.reload();
  }

  initSteps() {
    console.log("initSteps");
    let index = "0";
    let data = this.__records[0];
    console.log("initSteps");
    this.status = data.status;
    console.log("this.status", this.status);
   // H-M MC_MGEN3604SF-FTTH_Attribution AP  ajouter le nouveau type la commande "InwiB2C_Acquisition_Accessoire_Gratuit"
    if (data.typecommande == "inwiB2C_Acquisition"  || data.typecommande == "InwiB2C_Acquisition_Accessoire_Gratuit") {
      index = "1";
    } else if (data.typecommande == "inwiB2C_Migration") {
      index = "3";
    } else if (
      data.typecommande == "inwiB2C_Modification" &&
      (data.reglegestion == "inwiB2C_Rehabilitation" ||
        data.reglegestion == "inwiB2C_Suspension")
    ) {
      index = "4";
    } else if (
      data.typecommande == "inwiB2C_Modification" &&
      (data.reglegestion == "inwiB2C_RegroupementCompte" ||
        data.reglegestion == "inwiB2C_ChangementTitulaire")
    ) {
      index = "5";
    } else if (
      data.typecommande == "inwiB2C_Modification" &&
      data.reglegestion !== "inwiB2C_Rehabilitation" &&
      data.reglegestion != "inwiB2C_Suspension"
    ) {
      index = "2";
    }
    console.log("index path = ", index);

    // get steps array
    this.steps = this.allSteps.filter(item => {
      return item.index.includes(index);
    });
    console.log("this.steps", JSON.stringify(this.steps));
  }

  render() {
    return template;
  }
}