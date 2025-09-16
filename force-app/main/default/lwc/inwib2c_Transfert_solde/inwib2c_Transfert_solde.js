import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwib2c_Transfert_solde.html";


export default class Inwib2c_Transfert_solde extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {

    //
    errorMessage = "";
    __saving = false;
    __data = [];
    __dataErrors = [];
    // APIs
    __montant;
    @api
    get montant() {
        return this.__montant;
    }
    set montant(value) {
        this.__montant = value;
    }

    __records;
    @api
    get records() {
        return this.__records;
    }
    set records(value) {
        this.__records = value;
    }

    __sourceaccountid;
    @api
    get sourceaccountid() {
        return this.__sourceaccountid;
    }
    set sourceaccountid(value) {
        this.__sourceaccountid = value;
    }

    // 
    getData() {
        console.log(this.montant)
        let records = JSON.parse(JSON.stringify(this.__records))
        let data = [];
        console.log(records)
        console.log(records.lenght)
        console.log(JSON.stringify(this.__records))
        records.map((item, index) => {
            if (!this.__sourceaccountid || this.__sourceaccountid !== item.Id) {
                item.ligneNumber = index + 1;
                item.index = index;
                item.montantVerse = 0;
                data.push(item);
            }
        })
        this.__data = data;
    }

    // 
    handleChangeMontant(event) {
        let data = [...this.__data];
        var selectedItem = this.__data[event.target.name];
        selectedItem.montantVerse = parseFloat(event.target.value);
        data[event.target.name] = selectedItem;

        this.__data = [...data];
        console.log(this.__data);
    }

    //
    get showErrors() {
        return this.__dataErrors.length > 0
    }

    handleValidate() {
        let dataErrors = []; this.errorMessage = ""
        let sum = 0;
        this.__data.map(item => {
            console.log(item.montantVerse < 0);
            console.log(item.montantVerse);
            console.log(isNaN(item.montantVerse));
            if (isNaN(item.montantVerse) || item.montantVerse < 0) {
                dataErrors.push("Le montant est incorrecte (Ligne " + (item.index + 1) + ")");
            } else {
                sum = sum + parseFloat(item.montantVerse);
            }
        });

        if (sum == 0) {
            dataErrors.push("Le total versé doit être supérieur à zéro");
        } else if (sum > this.__montant) {
            dataErrors.push("Le total versé ne doit pas dépasser le montant restant");
        }

        this.__dataErrors = [...dataErrors];

        if (dataErrors.length == 0) {
            this.__saving = true;
            let dataTransfertAccount = [];
            let dataPayedInvoices = [];

            this.__data.map(item => {
                if (item.montantVerse > 0) {
                    dataTransfertAccount.push(item);
                    dataPayedInvoices.push({
                        "amount": item.montantVerse,
                        "billingAccountTargetID": item.AccountNumber
                    });
                }
            });

            let myData = {
                dataTransfertAccount,
                totalTransfert: parseFloat(sum)
            };

            if (myData.totalTransfert > 0) {
                const input = {
                    "billingAccountID": this.__sourceaccountid,
                    "billingAccountTarget": dataPayedInvoices,
                    "transferType": "C"
                };

                console.log(input)

                const params = {
                    input: JSON.stringify(input),
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: "inwib2c_inwib2c_transfert_lettrage",
                    options: "{}",
                };

                this._actionUtilClass
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                        this.__saving = false;

                        console.log("paiement transfert");
                        console.log(JSON.stringify(response));
                        if (response.result && response.result.IPResult && response.result.IPResult.status === "1") {
                            this.omniApplyCallResp(myData);
                            this.omniNextStep();
                        } else {
                            this.errorMessage = "Une erreur est survenue.."
                        }
                    })
                    .catch(error => {
                        console.log("showVars_error:: " + error);
                    });
            } else {
                this.__saving = false;
                this.omniApplyCallResp(myData);
                this.omniNextStep();
            }
        }
    }

    //
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.getData();
    }

    render() {
        return template;
    }


}