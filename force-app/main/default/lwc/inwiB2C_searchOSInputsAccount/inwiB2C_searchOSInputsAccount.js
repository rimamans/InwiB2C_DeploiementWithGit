import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';


import template from './inwiB2C_searchOSInputsAccount.html';

export default class inwiB2C_searchOSInputsAccount extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {


    @api c;
    @api m;
    @api b;

    @api
    __fromos;
    @api
    get fromos() {
        return this.__fromos;
    }

    set fromos(value) {
        this.__fromos = value;
    }

    get showSearchByName() {
        return this.__fromos == "lettrage"
    }

    handleVisibilityNextButton() {
        console.log("this.c:" + this.c)
        console.log("this.m:" + this.m)
        try {
            let searchButton = this.template.querySelector(`[data-theid="searche"]`);

            let lastnamevalue = '';
            let firstnamevalue = '';
            try {
                lastnamevalue = this.template.querySelector(`[data-theid="lastname"]`).value;
                firstnamevalue = this.template.querySelector(`[data-theid="firstname"]`).value;
            } catch (error) {

            }

            let cinvalue = this.template.querySelector(`[data-theid="CIN"]`).value;
            let mdnvalue = this.template.querySelector(`[data-theid="MDN"]`).value;
            let BillingAccountNumvervalue = this.template.querySelector(`[data-theid="BAN"]`).value;
            let InvoiceNumbervalue = this.template.querySelector(`[data-theid="INV"]`).value;



            let case1 = cinvalue != '' && mdnvalue == '' && BillingAccountNumvervalue == '' && InvoiceNumbervalue == ''
            let case2 = cinvalue == '' && mdnvalue != '' && mdnvalue.length == 12 && BillingAccountNumvervalue.length == '' && InvoiceNumbervalue == '';
            let case3 = cinvalue == '' && mdnvalue == '' && BillingAccountNumvervalue != '' && InvoiceNumbervalue == '';
            let case4 = cinvalue == '' && mdnvalue == '' && BillingAccountNumvervalue == '' && InvoiceNumbervalue != '';
            let case5 = cinvalue == '' && mdnvalue == '' && BillingAccountNumvervalue == '' && InvoiceNumbervalue == '' && lastnamevalue !== '' && firstnamevalue !== '';

            if (case1 || case2 || case3 || case4 || case5)
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

    handleSearch(e) {
        this.omniNextStep();
    }

    render() {
        return template;
    }
}