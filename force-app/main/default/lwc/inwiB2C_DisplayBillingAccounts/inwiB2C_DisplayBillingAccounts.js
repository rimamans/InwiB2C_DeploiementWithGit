import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from './inwiB2C_DisplayBillingAccounts.html';

export default class inwiB2C_DisplayBillingAccounts extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    __data = [];
    __selectedItem;
    __size = -1;

    //
    __records;
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
    }

    __typeclient;
    @api
    get typeclient() {
        return this.__typeclient;
    }

    set typeclient(value) {
        this.__typeclient = value;
    }

    //
    __sourceaccountid;
    @api
    get sourceaccountid() {
        return this.__sourceaccountid;
    }

    set sourceaccountid(value) {
        this.__sourceaccountid = value;
    }

    //
    get isLoading() {
        const list = JSON.parse(JSON.stringify(this.records));
        console.log("list.lenght !== this.__data.length");
        console.log(list.length, this.__data.length);
        if (!this.__selectedItem && list.length == this.__data.length) {
            console.log("selectedItem INIT start")
            if (this.__data && this.__data.length == 1) {
                var accounts = JSON.parse(JSON.stringify(this.__data));
                let selectedBillingAccount = {
                    "selectedBillingAccountId": accounts[0].Id,
                    "sourceBillingAccount": !this.__sourceaccountid ? accounts[0] : {},
                    "targetBillingAccount": this.__sourceaccountid ? accounts[0] : {}
                }
                this.omniUpdateDataJson(selectedBillingAccount);
                this.omniSaveState(selectedBillingAccount, true);
                this.omniApplyCallResp(selectedBillingAccount);

            } else if (this.__data && this.__data.length > 1) {
                var accounts = JSON.parse(JSON.stringify(this.__data));
                var lenght = this.__data.length - 1;
                let selectedBillingAccount = {
                    "selectedBillingAccountId": accounts[lenght].Id,
                    "sourceBillingAccount": !this.__sourceaccountid ? accounts[lenght] : {},
                    "targetBillingAccount": this.__sourceaccountid ? accounts[lenght] : {}
                }
                this.omniApplyCallResp(selectedBillingAccount);
                this.omniUpdateDataJson(selectedBillingAccount);
                this.omniSaveState(selectedBillingAccount, true);
            }
        }
        return this.__size !== this.__data.length;
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.getFreeAmount();
    }

    getFreeAmount() {


        const list = JSON.parse(JSON.stringify(this.records));
        let clientId;
        console.log("list = ", list);
        if (list && list.length > 0) {
            clientId = list[0].clientAccountNumber;
            console.log("list[0] = ", list[0]);
            let dataSize = [];
            list.map(item => {
                if (!this.__sourceaccountid || item.Id !== this.__sourceaccountid) {
                    dataSize.push(item);
                }
            });
            this.__size = dataSize.length;
        }
        if (this.__typeclient == "b2b") {
            this.__data = [...list];
        } else {

            console.log("clientId = ", clientId);

            if (clientId) {
                console.log("getFreeAmount clientId", clientId);
                const input = `{
                "party": {
                    "marketSegment": "B2C",
                    "clientId": "`+ clientId + `"
                }
            }`;
                const params = {
                    input,
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: "inwib2c_inwiB2C_IP_GetFreeAmount",
                    options: "{}",
                };

                console.log("before call InwiB2C_DisplayContentServices" + input);
                let data = []
                this._actionUtilClass
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                        console.log(response);
                        let dataResponse = response.result && response.result.IPResult && response.result.IPResult.customerAccounts ? response.result.IPResult.customerAccounts : [];
                        list.map(item => {
                            if (!this.__sourceaccountid || item.Id !== this.__sourceaccountid) {
                                const itemResponse = dataResponse.filter(compte => compte.id == item.AccountNumber);
                                try {
                                    item.MontantLibre = 0;
                                    item.AccountNumber = item.AccountNumber == null || item.AccountNumber == '' ? item.AccountNumber_SF : item.AccountNumber;
                                    dataResponse.map(itemDataRespense => {
                                        itemDataRespense.accounts.map(itemDataRespenseAccount => {
                                            console.log('item.id' + itemDataRespenseAccount.id);
                                            console.log('item.AccountNumber' + item.AccountNumber);
                                            if (itemDataRespenseAccount.id == item.AccountNumber) {
                                                console.log('item.AccountNumber' + item.AccountNumber);
                                                item.MontantLibre = itemDataRespenseAccount.freeAmount;
                                            }
                                        })
                                    })
                                } catch (error) {
                                    item.MontantLibre = 0;

                                }
                                console.log("dataResponse", dataResponse)
                                console.log("itemResponse", itemResponse)
                                console.log("add item", item)
                                this.__data = this.__data.concat(item);
                                console.log("this.__data.len", this.__data.length)

                            }
                        })
                    })
                    .catch(error => {
                        console.log("error");
                        window.console.log(error);
                    });
            }
        }
    }

    handleSelectedAccounts(event) {
        console.log('handleSelectedSubscription' + event.target.dataset.idacc);
        this.haschoose = true;
        //
        var accounts = JSON.parse(JSON.stringify(this.__data));
        let selectedItem = {};
        accounts.map(item => {
            if (item.Id == event.target.dataset.idacc) {
                selectedItem = { ...item }
            }
        })
        this.__selectedItem = selectedItem.Id;
        let selectedBillingAccount = {
            "selectedBillingAccountId": event.target.dataset.idacc,
            "sourceBillingAccount": !this.__sourceaccountid ? selectedItem : {},
            "targetBillingAccount": this.__sourceaccountid ? selectedItem : {}
        }
        console.log("__selectedItem");
        console.log(this.__selectedItem);
        console.log(JSON.stringify(selectedBillingAccount));
        this.omniUpdateDataJson(selectedBillingAccount);
        this.omniSaveState(selectedBillingAccount, true);
        this.omniApplyCallResp(selectedBillingAccount);
    }

    //
    render(event) {
        return template;
    }
}