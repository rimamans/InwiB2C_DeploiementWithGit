import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwib2c_Lettrage_Facture.html";


export default class Inwib2c_Lettrage_Facture extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    //
    errorMessage = ""
    __saving = false;
    __data = [];
    __dataErrors = [];
    totalVersement = 0;
    // APIs
    __montant;
    @api
    get montant() {
        return this.__montant;
    }
    set montant(value) {
        this.__montant = parseFloat(value);
    }

    __montantlibre;
    @api
    get montantlibre() {
        return this.__montantlibre;
    }
    set montantlibre(value) {
        this.__montantlibre = parseFloat(value);
    }

    __records;
    @api
    get records() {
        return this.__records;
    }
    set records(value) {
        this.__records = value;
    }

    __poscode;
    @api
    get poscode() {
        return this.__poscode;
    }
    set poscode(value) {
        this.__poscode = value;
    }

    __cycle;
    @api
    get cycle() {
        return this.__cycle;
    }
    set cycle(value) {
        this.__cycle = value;
    }

    __accountsource;
    @api
    get accountsource() {
        return this.__accountsource;
    }
    set accountsource(value) {
        console.log("accountsource--->")
        console.log(value)
        this.__accountsource = value;
    }


    get montantTotal() {
        return parseFloat(this.__montantlibre) + parseFloat(this.__montant);
    }

    // 
    getData() {
        console.log("get data")
        console.log(this.__accountsource)
        console.log(this.montant)
        let records = JSON.parse(JSON.stringify(this.__records))
        let data = [];
        console.log(records)
        console.log(records.length)
        console.log(typeof records.length);
        //console.log(typeof records.length == "number");
        if (records) {
            if (typeof records.length == "number") {
                console.log("it's an array")
                let index_ligne = 0;
                records.map((item, index) => {
                    console.log("index => ", index)
                    if (item.status == "Impayée" || item.status == "Partiellement payée") {
                        item.selected = false;
                        item.cycle = this.__cycle,
                            item.ligneNumber = index_ligne + 1;
                        item.index = index_ligne;
                        item.montantVerse = 0;
                        item.invoice_month = item.invoiceStartDate.substring(3);
                        item.invoice_ht = parseFloat(item.invoiceAmount / 1.2).toFixed(2);
                        item.styleColor = ""
                        data.push(item);
                        index_ligne = index_ligne + 1;
                    }
                })
            } else {
                if (records.mois) {
                    console.log("it's an object")
                    item.selected = false;
                    item.cycle = this.__cycle,
                        records.ligneNumber = 1;
                    records.index = 0;
                    records.montantVerse = 0;
                    records.styleColor = ""
                    data.push(records);
                }
            }
        }

        console.log("push", data.length)
        this.__data = data;
    }

    // 
    handleChangeMontant(event) {
        let data = [...this.__data];
        var filteredData = this.__data.filter(item => item.index == event.target.name);
        var selectedItem = filteredData[0];
        console.log(selectedItem);

        if (event.target.value != 0 && event.target.value != '') {
            console.log(event.target.value)
            console.log(typeof event.target.value)
            const montantVerser = parseFloat(event.target.value);
            if (typeof montantVerser == "number") {

                if (montantVerser <= parseFloat(selectedItem.remainingAmount)) {
                    if (montantVerser <= parseFloat(this.montantTotal - this.totalVersement)) {
                        console.log(event.target.name)
                        console.log(event.target.value)
                        console.log(JSON.stringify(selectedItem))
                        console.log(selectedItem.montantVerse);
                        selectedItem.montantVerse = parseFloat(event.target.value);
                        const index = data.findIndex(item => item.index === event.target.name);
                        data[index] = selectedItem;
                        this.__data = [...data];
                        console.log(this.__data)
                        this.countTotalVersement()
                    } else {
                        console.log("check 1")
                        selectedItem.montantVerse = 0;
                        const index = data.findIndex(item => item.index === event.target.name);
                        data[index] = selectedItem;
                        this.__data = [...data];
                        console.log(this.__data);
                        this.countTotalVersement();

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: 'Le montant saisie doit être inferieur au reste',
                                variant: 'error'
                            }),
                        );
                    }

                } else {
                    console.log("check 2")
                    selectedItem.montantVerse = 0;
                    const index = data.findIndex(item => item.index === event.target.name);
                    data[index] = selectedItem;
                    this.__data = [...data];
                    console.log(this.__data);
                    this.countTotalVersement();

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Le montant saisie doit être inferieur au reste à payer',
                            variant: 'error'
                        }),
                    );
                }

            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Le montant saisie est incorrecte',
                        variant: 'error'
                    }),
                );
            }
        }


    }

    countTotalVersement() {
        let data = [...this.__data];
        let count = 0;
        data.map(item => {
            if (typeof item.montantVerse == "number") {
                count = count + item.montantVerse;
            }
        });

        this.totalVersement = count;
    }

    handleSelectLigne(event) {
        let data = [...this.__data];
        var filteredData = this.__data.filter(item => item.index == event.target.name);
        var selectedItem = filteredData[0];
        console.log(selectedItem);

        if (!selectedItem.selected) {
            if (parseFloat(selectedItem.remainingAmount) <= parseFloat(this.montantTotal - this.totalVersement)) {
                console.log(event.target.name)
                console.log(event.target.value)
                console.log(JSON.stringify(selectedItem))
                console.log(selectedItem.montantVerse);
                selectedItem.montantVerse = parseFloat(selectedItem.remainingAmount);
                selectedItem.selected = true;
                const index = data.findIndex(item => item.index === event.target.name);
                data[index] = selectedItem;
                this.__data = [...data];
                console.log(this.__data)
                this.countTotalVersement();
            } else {
                console.log("check 1")
                selectedItem.selected = false;
                selectedItem.montantVerse = 0;
                const index = data.findIndex(item => item.index === event.target.name);
                data[index] = selectedItem;
                this.__data = [...data];
                console.log(this.__data);
                this.countTotalVersement();

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Le montant saisie doit être inferieur au reste',
                        variant: 'error'
                    }),
                );
            }
        } else {
            selectedItem.montantVerse = 0;
            selectedItem.selected = true;
            const index = data.findIndex(item => item.index === event.target.name);
            data[index] = selectedItem;
            this.__data = [...data];
            console.log(this.__data)
            this.countTotalVersement();
        }



    }

    //
    get showErrors() {
        return this.__dataErrors.length > 0
    }


    handleValidate() {
        this.errorMessage = ""
        let dataErrors = [];
        let sum = 0;
        this.__data.map(item => {
            console.log(item.montantVerse < 0);
            console.log(item.montantVerse);
            console.log(isNaN(item.montantVerse));
            if (isNaN(item.montantVerse) || item.montantVerse < 0) {
                dataErrors.push("Le montant est incorrecte (Ligne " + (item.index + 1) + ")");
            } else if (parseFloat(item.montantVerse) > parseFloat(item.remainingAmount) || parseFloat(item.montantVerse) > parseFloat(this.montantTotal)) {
                dataErrors.push("Le montant versé doit être inférieur au montant restant (Ligne " + (item.index + 1) + ")");
            } else {
                sum = sum + parseFloat(item.montantVerse);
            }
        });
        console.log(this.__montant + this.__montantlibre);
        console.log(sum)
        if (parseFloat(sum) > parseFloat(this.montantTotal)) {
            dataErrors.push("Le total versé ne doit pas dépasser le montant restant");
        }

        this.__dataErrors = [...dataErrors];
        console.log(dataErrors);
        if (dataErrors.length == 0) {
            console.log("saving........")
            this.__saving = true;
            let modifiedLigneData = [];
            let dataPayedInvoices = [];
            this.__data.map(item => {
                if (item.montantVerse > 0) {
                    modifiedLigneData.push(item);
                    dataPayedInvoices.push({
                        "amount": item.montantVerse,
                        "billingAccountTargetID": item.billingAccountId,
                        "refInvoice": item.Id
                    });

                }
            });

            let myData = {
                modifiedLigneData,
                montantRestantLettrage: parseFloat(this.montant) + parseFloat(this.montantlibre) - parseFloat(sum),
                totalLettrage: parseFloat(sum)
            };
            console.log(myData);
            console.log(myData.totalLettrage, myData.totalLettrage > 0);

            if (myData.totalLettrage > 0) {
                console.log("saving........1", this.__accountsource)

                const input = {
                    "billingAccountID": this.__accountsource,
                    "billingAccountTarget": dataPayedInvoices,
                    "transferType": "C"
                };

                console.log(JSON.stringify(input));
                console.log(dataPayedInvoices)

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
                        console.log("paiement invoices");
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

    handleBack(evt) {
        if (evt) {
            this.omniPrevStep();
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