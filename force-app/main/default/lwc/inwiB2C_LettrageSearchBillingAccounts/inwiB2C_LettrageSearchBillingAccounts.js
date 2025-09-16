import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from './inwiB2C_LettrageSearchBillingAccounts.html';

export default class inwiB2C_LettrageSearchBillingAccounts extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    type = 'B2C';
    searchButtonDisabled = false;
    get options() {
        return [
            { label: 'B2C', value: 'B2C' },
            { label: 'B2B', value: 'B2B' },
        ];
    }

    get showB2C() {
        return this.type == "B2C";
    }

    handleChangeType(event) {
        this.type = event.target.value;
    }

    handleVisibilityNextButton() {
        console.log("this.c:" + this.c)
        console.log("this.m:" + this.m)
        try {
            let searchButton = this.template.querySelector(`[data-theid="search"]`);

            let lastnamevalue = '';
            let firstnamevalue = '';
            let cinvalue = '';
            let mdnvalue = '';
            let BillingAccountNumvervalue = '';
            let InvoiceNumbervalue = '';

            //
            let raisonSocialeValue = '';
            let RCValue = '';

            if (this.type == 'B2C') {
                lastnamevalue = this.template.querySelector(`[data-theid="lastname"]`).value;
                firstnamevalue = this.template.querySelector(`[data-theid="firstname"]`).value;
                cinvalue = this.template.querySelector(`[data-theid="CIN"]`).value;
                mdnvalue = this.template.querySelector(`[data-theid="MDN"]`).value;
                BillingAccountNumvervalue = this.template.querySelector(`[data-theid="BAN"]`).value;
                InvoiceNumbervalue = this.template.querySelector(`[data-theid="INV"]`).value;
            } else {
                raisonSocialeValue = this.template.querySelector(`[data-theid="raisonsociale"]`).value;
                RCValue = this.template.querySelector(`[data-theid="rc"]`).value;
            }


            let case1 = this.type == 'B2C' && cinvalue != '' && mdnvalue == '' && BillingAccountNumvervalue == '' && InvoiceNumbervalue == ''
            let case2 = this.type == 'B2C' && cinvalue == '' && mdnvalue != '' && mdnvalue.length == 12 && BillingAccountNumvervalue.length == '' && InvoiceNumbervalue == '';
            let case3 = this.type == 'B2C' && cinvalue == '' && mdnvalue == '' && BillingAccountNumvervalue != '' && InvoiceNumbervalue == '';
            let case4 = this.type == 'B2C' && cinvalue == '' && mdnvalue == '' && BillingAccountNumvervalue == '' && InvoiceNumbervalue != '';
            let case5 = this.type == 'B2C' && cinvalue == '' && mdnvalue == '' && BillingAccountNumvervalue == '' && InvoiceNumbervalue == '' && lastnamevalue !== '' && firstnamevalue !== '';

            let case6 = this.type == 'B2B' && raisonSocialeValue != '' && RCValue == '';
            let case7 = this.type == 'B2B' && raisonSocialeValue == '' && RCValue !== '';

            if (case1 || case2 || case3 || case4 || case5 || case6 || case7)
                searchButton.style.display = "block"
            else
                searchButton.style.display = "none"

            let saveObj = {
                "IsExecuteDataraptor1": case1,
                "IsExecuteDataraptor2": case2,
                "IsExecuteDataraptor3": case3,
                "IsExecuteDataraptor4": case4,
                "IsExecuteDataraptor5": case5
            }
            this.omniUpdateDataJson(saveObj);
            this.omniSaveState(saveObj, true);


        } catch (error) {
            console.log('error: ' + error)
        }

    }


    handleCINChange(e) {
        this.handleVisibilityNextButton();

        try {
            let CINinput = this.template.querySelector(`[data-theid="CIN"]`);

            CINinput.value = CINinput.value.replace(/ /g, "");
            let saveObj = {
                "cinvalue": CINinput.value
            }
            this.omniUpdateDataJson(saveObj);
            this.omniSaveState(saveObj, true);

        } catch (error) {
            console.log('error: ' + error)

        }
    }

    handleMDNChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "mdnvalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleBillingAccChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "BillingAccountNumbervalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }
    handleInvoiceNumberChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "InvoiceNumbervalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    // ODE 04/08/2022
    handleLastNameChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "LastNamevalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleFirstNameChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "FirstNamevalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    // B2C
    handleRaisonSocialeChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "RaisonSocialevalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleRCChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "RCvalue": e.detail.value
        }
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleSearch(e) {
        if (this.type == 'B2C') {
            let saveObj = {
                "clienttype": "b2c"
            }
            this.omniSaveState(saveObj, true);
            this.omniApplyCallResp(saveObj);
            this.omniNextStep();
        } else {
            this.searchButtonDisabled = true;

            const raisonSocialeValue = this.template.querySelector(`[data-theid="raisonsociale"]`).value;
            const RCValue = this.template.querySelector(`[data-theid="rc"]`).value;
            const input = {
                "party": {
                    "marketSegment": "B2B",
                    "Identification": {
                        "type": "RT"
                    }
                }
            };

            if (raisonSocialeValue && raisonSocialeValue != '') {
                input.party.OrganizationName = {
                    "tradingName": raisonSocialeValue
                }
            } else if (RCValue && RCValue != '') {
                input.party.Identification.code = RCValue;
            }

            console.log(JSON.stringify(input));


            const params = {
                input: JSON.stringify(input),
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_inwiB2C_IP_GetFreeAmount",
                options: "{}",
            };


            console.log("before call InwiB2C_DisplayContentServices" + JSON.stringify(params));
            let data = []
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log(JSON.stringify(response));
                    let dataResponse = response.result && response.result.IPResult && response.result.IPResult.customerAccounts ? response.result.IPResult.customerAccounts : [];
                    dataResponse.map(item => {
                        data.push({
                            "CIN": item.party && item.party.identification ? item.party.identification.code : "",
                            "customerAccountId": "",
                            "clientAccountNumber": item.party ? item.party.clientId : "",
                            "LastName": item.accounts && item.accounts[0] ? item.accounts[0].name : "",
                            "FirstName": "",
                            "Id": item.party ? item.party.clientId : "",
                            "CycleDeFacturation": "",
                            "ModeDePaiement": "",
                            "BillingAddress": item.urbanPropertyAddress ? item.urbanPropertyAddress.address : "",
                            "AccountNumber": item.accounts && item.accounts[0] ? item.accounts[0].id : "",
                            "MontantLibre": item.accounts && item.accounts[0] ? item.accounts[0].freeAmount : 0,
                        })
                    })
                    this.searchButtonDisabled = false;
                    let saveObj = {
                        "BillingAccounts": data,
                        "numberofaccounts": data.length,
                        "clienttype": "b2b"
                    }
                    this.omniSaveState(saveObj, true);
                    this.omniApplyCallResp(saveObj);
                    this.omniNextStep();

                })
                .catch(error => {
                    this.searchButtonDisabled = false;
                    console.log("error");
                    window.console.log(error);
                });
        }
    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }


    render() {
        return template;
    }
}