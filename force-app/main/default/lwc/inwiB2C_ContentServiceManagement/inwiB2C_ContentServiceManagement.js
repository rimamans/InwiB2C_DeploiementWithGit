import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

import template from "./inwiB2C_ContentServiceManagement.html";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class InwiB2C_ContentServiceManagement extends OmniscriptBaseMixin(
  LightningElement
) {
  __profile;
  __mdn;
  __subscriptionid;

  __returnedProduct;
  __dataServices;
  __dataHistory;

  @api
  set profile(value) {
    this.__profile = value;
  }
  get profile() {
    return this.__profile;
  }

  @api
  set mdn(value) {
    this.__mdn = value;
  }
  get mdn() {
    return this.__mdn;
  }

  @api
  set subscriptionid(value) {
    this.__subscriptionid = value;
  }
  get subscriptionid() {
    return this.__subscriptionid;
  }

  contentServiceColumns = [
    {
      label: "Service",
      fieldName: "name",
      type: "text",
      hideDefaultActions: true,
      initialWidth: 100,
    },
  ];

  columns = [
    { label: "Description", fieldName: "description" },
    { label: "Prix", fieldName: "combination_price", type: "currency" },
    {
      type: "button",
      label: "Action",
      fixedWidth: 150,
      typeAttributes: {
        label: "Activer",
        title: "Activer",
        variant: "brand",
      },
    },
  ];

  history_columns = [
    { label: "Produit", fieldName: "product_name" },
    { label: "Description", fieldName: "description" },
    {
      type: "button",
      label: "Action",
      fixedWidth: 150,
      typeAttributes: {
        label: "Renvoyer le code",
        title: "Renvoyer le code",
        variant: "brand",
      },
    },
  ];

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();

    //this.getContectServices();
  }

  getContectServices(event) {
    console.log(this.mdn + " - " + this.profile + " - " + this.subscriptionid);
    if (this.mdn && this.profile && this.subscriptionid) {
      let input =
        '{"mdn": "' +
        this.mdn +
        '", "profile_id": "' +
        this.profile +
        '", "subscription_Id": "' +
        this.subscriptionid +
        '"}';
      //console.log('input : ' + input);

      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_InwiB2C_DisplayContentServices",
        options: "{}",
      };

      console.log("before call InwiB2C_DisplayContentServices" + input);

      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log(response);
          if (response.error === false) {
            if (
              response.result &&
              response.result.IPResult &&
              response.result.IPResult.product
            ) {
              this.__returnedProduct = JSON.parse(
                JSON.stringify(response.result.IPResult.product)
              );
              console.log("this.__returnedProduct");
              console.log(this.__returnedProduct);

              // Get services
              let dataServices = this.__returnedProduct.serviceRef;
              dataServices.forEach((item, idx) => {
                item.serviceCombinations.forEach((item2, idx2) => {
                  let description = "";
                  item2.attributes.forEach((item3, idx3) => {
                    description =
                      description +
                      item3.attribute_id +
                      ": " +
                      item3.attribute_value +
                      "\n";
                  });
                  item2.description = description;
                });
              });
              this.__dataServices = dataServices;

              // Get History
              let dataHistory = this.__returnedProduct.lineScHistory;
              // get product description
              dataHistory.forEach((item, idx) => {
                let description = "";
                item.attributes.forEach((item2, idx3) => {
                  description =
                    description +
                    item2.attribute_id +
                    ": " +
                    item2.attribute_value +
                    "\n";
                });
                item.description = description;
              });
              this.__dataHistory = dataHistory;
            }
          } else {
            const event = new ShowToastEvent({
              variant: "error",
              title: "Erreur",
              message: "Une erreur est survenue, veuillez réessayer !!!",
            });
            this.dispatchEvent(event);
          }
        })
        .catch(error => {
          console.log("error");
          window.console.log(error);
        });
    }
  }

  handleActivate(event) {
    window.console.log(JSON.stringify(event.detail.row));
    const row = event.detail.row;
    let input =
      `{
          "mdn" : "` +
      this.mdn +
      `",
          "profile_id" : "` +
      this.profile +
      `",
          "reservationToken" : "` +
      String(this.__returnedProduct.reservationToken) +
      `",
          "applyFee" : "false",
          "feeAmount" : 0,
          "productOrderItems" :
          [
               {
                   "combination_id" : ` +
      row.combination_id +
      `,
                   "combination_price" :  ` +
      row.combination_price +
      `
               }
          ]
       }`;

    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_ActivateContentServices",
      options: "{}",
    };
    console.log(input);
    console.log(params);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log("response of inwib2c_InwiB2C_ActivateContentServices");
        console.log(response);
        if (response.error) {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message: response.result.error,
          });
          this.dispatchEvent(event);
        } else {
          if (
            response.result &&
            response.result.IPResult &&
            response.result.IPResult.status === "1"
          ) {
            const event = new ShowToastEvent({
              variant: "success",
              title: "Succés",
              message: "L'activation a été effectuée avec succés.",
            });
            this.dispatchEvent(event);
            this.omniNextStep();
          } else {
            const event = new ShowToastEvent({
              variant: "error",
              title: "Erreur",
              message: response.result.IPResult.message,
            });
            this.dispatchEvent(event);
          }
        }
      })
      .catch(error => {
        window.console.log(error);
        const event = new ShowToastEvent({
          variant: "error",
          title: "Erreur",
          message: "Une erreur est survenue veuillez réessayer.",
        });
        this.dispatchEvent(event);
      });
  }

  handleResendCode(event) {
    window.console.log(JSON.stringify(event.detail.row));
    const row = event.detail.row;
    let input =
      `{
          "mdn" : "` +
      this.mdn +
      `",
      "reservation_id" : ` +
      row.transaction_id +
      `
       }`;

    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwiB2C_resendServiceActivationCode",
      options: "{}",
    };
    console.log(input);
    console.log(params);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (response.error) {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message: response.result.error,
          });
          this.dispatchEvent(event);
        } else {
          const event = new ShowToastEvent({
            variant: "success",
            title: "Succés",
            message: "Le Code a été renvoyer avec succés.",
          });
          this.dispatchEvent(event);
          this.omniNextStep();
        }
      })
      .catch(error => {
        window.console.log(error);
        const event = new ShowToastEvent({
          variant: "error",
          title: "Erreur",
          message: "Une erreur est survenue veuillez réessayer.",
        });
        this.dispatchEvent(event);
      });
  }
}