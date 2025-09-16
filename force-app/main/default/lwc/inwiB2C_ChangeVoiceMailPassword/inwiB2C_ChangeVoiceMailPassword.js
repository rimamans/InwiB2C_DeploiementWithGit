import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_ChangeVoiceMailPassword.html";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class InwiB2C_ChangeVoiceMailPassword extends OmniscriptBaseMixin(
  LightningElement
) {
  __mdn;
  __canal;
  __subscriptionid;
  __loading;
  __codelength;
  __password;
  __error = false;
  __success;

  @api
  set mdn(value) {
    this.__mdn = value;
  }
  get mdn() {
    return this.__mdn;
  }
  @api
  set canal(value) {
    this.__canal = value;
  }
  get canal() {
    return this.__canal;
  }
  @api
  set subscriptionid(value) {
    this.__subscriptionid = value;
  }
  get subscriptionid() {
    return this.__subscriptionid;
  }

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.__loading = false;
  }

  callVIP(event) {
    this.__loading = true;
    let input =
      `{
        "CSSubscriber": {
            "mdn": ` +
      this.mdn +
      `,
            "CSNetworkProduct": {
                "action": "DIS"
            }
        }
    }`;

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_InwiB2C_HandleVmsSecretCode",
      options: "{}",
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
      });
  }

  handleChange(event) {
    this[event.target.name] = event.target.value;
  }

  handleActivate(event) {
    if (this.mdn) {
      this.__loading = true;
      let input =
        `{
      "CSSubscriber": {
          "mdn": ` +
        this.mdn +
        `,
          "CSNetworkProduct": {
              "action": "ACT"
          }
      }
  }`;

      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: "inwib2c_InwiB2C_HandleVmsSecretCode",
        options: "{}",
      };

      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then(response => {
          console.log(response);
          this.__loading = false;
        })
        .catch(error => {
          console.log("error");
          window.console.log(error);
        });
    }
  }

  showToast(variant, title, message) {
    const event = new ShowToastEvent({
      variant,
      title,
      message,
    });
    this.dispatchEvent(event);
  }

  handleModify(event) {
    console.log("------- mdn = " + this.mdn);
    console.log("------- canal = " + this.canal);
    console.log("------- subid = " + this.subscriptionid);
    if (this.mdn) {
      if (this.__password && String(this.__password).length !== 4) {
        this.showToast(
          "error",
          "Erreur",
          "Le code doit être composer de 4 chiffres"
        );
      } else {
        this.__loading = true;
        this.__error = false;
        let status = false;
        let erreur = "";

        let input =
          `{
            "CSOperationInfo": {
                "user": "SF-user",
                "channel": "SF-B2C",
                "uuid": "11222-6456554-65465-65165156"
            },
            "CSSubscriber": {
                "mdn": "` +
          this.mdn +
          `",
                "CSNetworkProduct": {
                    "CSNetworkAttribut": [
                        {
                            "name": "MediaBoxNum",
                            "value": ""
                        },
                        {
                            "name": "SecretCodeLength",
                            "value": "4"
                        },
                        {
                            "name": "passwordskipenabled",
                            "value": ""
                        },
                        {
                            "name": "numericpassword",
                            "value": "` +
          this.__password +
          `"
                        }
                    ],
                    "action": "MOD"
                }
            }
        }`;
        console.log(input);

        const params = {
          input,
          sClassName: `${this._ns}IntegrationProcedureService`,
          sMethodName: "inwib2c_InwiB2C_HandleVmsSecretCode",
          options: "{}",
        };

        this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
            console.log(response);
            console.log(response.result);
            this.__loading = false;
            if (!response.error) {
              this.__codelength = null;
              if (
                response.result &&
                response.result.IPResult &&
                response.result.IPResult.CSOperationResultInfo &&
                response.result.IPResult.CSOperationResultInfo.isOK == "1"
              ) {
                this.__password = null;
                status = true;
                this.handleShowToaster(
                  "success",
                  "Succés",
                  "La modification a été effectuée avec succés."
                );
              } else {
                erreur =
                  response.result.IPResult.CSOperationResultInfo.errorMessage;
                this.handleShowToaster(
                  "error",
                  "Erreur",
                  response.result.IPResult.CSOperationResultInfo.errorMessage
                );
              }
            } else {
              this.handleShowToaster(
                "error",
                "Erreur",
                "Une erreur est survenue, veuillez réessayer !!!"
              );
              try {
                console.log("-------------try");
                erreur = response.result.IPResult.error;
              } catch (error) {
                console.log("-------------catch");
              }
            }
            this.handleCreateAction(status, erreur);
          })
          .catch(error => {
            window.console.log(error);
          });
      }
    }
  }

  handleShowToaster(variant, title, message) {
    const event = new ShowToastEvent({
      variant,
      title,
      message,
    });
    this.dispatchEvent(event);
  }

  handleCreateAction(status, code) {
    const optionStatus = status ? "OK" : "KO";
    const erreur = status ? "" : code;
    console.log(erreur);
    let options =
      '{"SubscriptionId":"' +
      this.subscriptionid +
      '","Canal":"' +
      this.canal +
      '","StatutOperation":"' +
      optionStatus +
      '","ErrorCodeOperation":"' +
      erreur +
      ' "' +
      ',"Mdn":"' +
      this.mdn +
      '" , "ActionOperation":"Modification Mot de passe BV", "TypeAction": "InwiB2C_Modification"  }';

    const params5 = {
      input: "{}",
      sClassName: "InwiB2C_OperationHistory",
      sMethodName: "AddOperationHistory",
      options,
    };

    console.log(JSON.stringify(params5));
    this._actionUtilClass
      .executeAction(params5, null, this, null, null)
      .then(response => {
        console.log("Success row inserted");
        console.log(response);
        if (status) {
          this.omniNextStep();
        }
      })
      .catch(error => {
        window.console.log(error);
      });
  }
}