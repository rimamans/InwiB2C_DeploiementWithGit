import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_display_billing_accounts.html";


export default class Inwib2c_display_billing_accounts extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {

    saving = false;
    loadindData = true;
    __hasError = false;
    __data = [];
    __addaccount = false;
    // Variables
    __accountid;
    __currentbillingaccount;
    __records;
    __orderid;
    __type;
    __newaccountid;
    __addressclient;
    @api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }

    @api
    get orderid() {
        return this.__orderid;
    }
    set orderid(value) {
        this.__orderid = value;
    }

    @api
    get currentbillingaccount() {
        return this.__currentbillingaccount;
    }
    set currentbillingaccount(value) {
        this.__currentbillingaccount = value;
    }

    @api
    get type() {
        return this.__type;
    }
    set type(value) {
        this.__type = value;
    }

    @api
    get newaccountid() {
        return this.__newaccountid;
    }
    set newaccountid(value) {
        this.__newaccountid = value;
    }

    @api
    get records() {
        return this.__records;
    }
    set records(value) {
        this.__records = JSON.parse(JSON.stringify(value));
    }

    get noData() {
        return this.__data.length == 0;
    }

    get displayNew() {
        return this.__type == "changementtitulaire";
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.displayAccounts();
    }

    displayAccounts() {
        let data = [];
        if (this.__records && this.__records.length > 0) {
            this.__records.map((item, index) => {
                this.__addressclient = item.address;
                if (item.Id != this.currentbillingaccount && item.AccountNumber!=null) {
                    item.checked = false;
                    item.index = index;
                    data.push(item);
                }
            })
            console.log(data)
            this.__data = [...data];
        }
    }

    selectItem(event) {
        let Id = event.target.name;
        let status = event.target.status;
        if (status) {
            let data = [...this.__data];
            data.map(item => {
                item.checked = false;
                return item
            });
            this.__data = data;
        } else {
            let data = [...this.__data];
            data.map(item => {
                if (Id == item.index) {
                    item.checked = true;
                } else {
                    item.checked = false;
                }
                return item
            });
            this.__data = data;
            console.log(data)
        }

    }

    SaveAndNext(evt) {
        console.log("save")
        let selected = this.__data.filter(item => {
            return item.checked;
        });

        if (selected.length > 0) {
            this.__hasError = false;
            this.saving = true;
            const selectedAccount = selected[0];
            console.log(selectedAccount);
            console.log(this.__type);
            let newId = this.__type != "changementtitulaire" ? this.__accountid : this.__newaccountid;

            let input =
                `{
                        "OrderId": "` + this.__orderid + `",
                        "BillingAccountId": "` + selectedAccount.Id + `",
                        "OldBillingAccountId": "` + this.__currentbillingaccount + `",
                        "NewAccountId":"`+ newId + `",
                        "oldAccountId":"`+ this.__accountid + `"
                    }`;
            console.log(input);

            const params = {
                input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_update_order_for_changement",
                options: "{}",
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    this.saving = false;
                    let data = { selectedAccount };
                    console.log(response);
                    this.omniApplyCallResp({ data });
                    this.omniNextStep();
                })
                .catch(error => {
                    window.console.log(error);
                });
        } else {
            this.__hasError = true;
        }
    }

    handleBack() {
        this.omniNavigateTo("TypeChangement");
    }


    // add new billing account
    addNewAccount() {
        this.__addaccount = !this.__addaccount;
    }

    handleAddBillingAccount(data) {
        console.log(JSON.stringify(data));
        const idaddress = data.detail.Idaddress ? data.detail.Idaddress : '';
        let input = `{
            "billingaccountInput":"`+ data.detail.IdselectedAcc + `",
            "billingcreate":"`+ data.detail.IdselectedAcc + `",
            "idaddress":"`+ idaddress + `",
            "idp":"`+ data.detail.fieldsbill.InwiB2C_Pays__c + `",
            "idpays":"`+ data.detail.fieldsbill.InwiB2C_Pays__c + `",
            "idville":"`+ data.detail.fieldsbill.inwiB2C_Ville__c + `",
            "idcodepostal":"`+ data.detail.fieldsbill.InwiB2C_Code_Postale__c + `",
            "complemntadress":"`+ data.detail.fieldsbill.InwiB2C_Rue_Complement_d_adresse__c + `",
            "complemntadress":"`+ data.detail.fieldsbill.InwiB2C_Rue_Complement_d_adresse__c + `",
            "idquartier":"`+ data.detail.fieldsbill.InwiB2C_Quartier__c + `"
        }`;
        console.log(input);
        this.saving = true;
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_UpdateAccountBiiling",
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log(response);
                let input =
                    `{
                        "OrderId": "` + this.__orderid + `",
                        "BillingAccountId": "` + data.detail.IdselectedAcc + `",
                        "OldBillingAccountId": "` + this.__currentbillingaccount + `",
                        "NewAccountId":"`+ this.__newaccountid + `",
                        "oldAccountId":"`+ this.accountid + `"
                    }`;
                console.log(input);

                const params = {
                    input,
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: "inwib2c_update_order_for_changement",
                    options: "{}",
                };

                this._actionUtilClass
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                        this.saving = false;
                        this.__addaccount = !this.__addaccount;
                        console.log(response);
                        let datatopush = { selectedAccount: data.detail };
                        this.omniApplyCallResp({ datatopush });
                        this.omniNextStep();
                    })
                    .catch(error => {
                        window.console.log(error);
                    });
            })
            .catch(error => {
                window.console.log(error);
            });
    }

    handleGoBack() {
        this.omniNavigateTo("TypeChangements");
    }

    render() {
        return template;
    }
}