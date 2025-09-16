import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./iniwB2C_FideliteFinalStep.html";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class IniwB2C_FideliteFinalStep extends OmniscriptBaseMixin(
  LightningElement
) {
  @api mdn;
  @api accountid;
  //@api poscode;
  //@api districode;
  @api produit;
  @api exchangecode;
  @api imei;
  @api codearticle;
  @api terminal;
@api orderid;
@api requestdate;
showIMEI=false;
  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    console.log("orderid", this.orderid);
    console.log("accountId", this.accountid);
    console.log("requestdate", this.requestdate);
    //console.log("districode", this.districode);
    console.log("exchangecode", this.exchangecode);
    //console.log("codearticle", this.codearticle);
    console.log("imei", this.imei);
    if(this.imei !=0){
      this.showIMEI=true;
    }
  }

  burnPoints(event) {
    // `+this.+`
    //var newDate = new Date(); 
    //var now = newDate.toISOString().replace('Z', '').replace('T', ' ');
    let input =
      '{"offerOrderType":"REDEEM_PHYSICAL","accountId":"' +this.accountid +'", "requestDate":"' +this.requestdate +'","orderId":"' +this.orderid +'","freeText":"'+this.produit+'","externalOrderRef":"","formRef":"","imei":"'+this.imei+'","imsi":0,"esn":0}'
    console.log(input);

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_CompleteClubOrder",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (!response.error) {
          try {
            if (response.result.IPResult.transactionId) {
              const event = new ShowToastEvent({
                variant: "success",
                title: "Succés",
                message: "Le commande a été finalisé avec succès !!",
              });
              this.dispatchEvent(event);
              // Go To Next Step
              this.omniUpdateDataJson({
                transactionid: response.result.IPResult.transactionId,
              });
              
              this.omniNextStep();
            } else {
              const event = new ShowToastEvent({
                variant: "error",
                title: "Erreur",
                message:  response.result.IPResult.result.message,
              });
              this.dispatchEvent(event);
            }
          } catch (error) {
            const event = new ShowToastEvent({
              variant: "error",
              title: "Erreur",
              message: "Une erreur est survenue, veuillez réessayer plutard !",
            });
            this.dispatchEvent(event);
            }
        } else {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message: "Une erreur est survenue, veuillez réessayer plutard !",
          });
          this.dispatchEvent(event);
        }
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
      });
  }
/*
  burnPointsStatic(event) {
    this.omniUpdateDataJson({
      transactionid: "8764764567834786",
    });
    this.omniNextStep();
  }*/

  render() {
    return template;
  }
}