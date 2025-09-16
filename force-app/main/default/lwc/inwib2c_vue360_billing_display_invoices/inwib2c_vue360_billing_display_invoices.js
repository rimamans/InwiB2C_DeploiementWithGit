import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import temp from "./inwib2c_vue360_billing_display_invoices.html";

export default class Inwib2c_vue360_billing_display_invoices extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @track records = [];
    @track filterdrecords = [];
    @track draftValues = [];
    @track __selectedRows = [];
    pickListvalues2 = [];
    stockeceddata = [];
    @track __accountid;
    @track __checkuserprofile;
    
    @track __email;

    @track __saving = false;
    @track __loading = true;
    @track __send = false;
    today = new Date();
    @track start_date;
    @track end_date;
    @track status_value = "all";
    @track range;
    @track canShowReceiptButton = false;

    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'Succes';
    @api
    get accountid() {
        return this.__accountid;
    }

    set accountid(value) {
        this.__accountid = value;
    }
    @api
    get checkuserprofile() {
        return this.__checkuserprofile;
    }

    set checkuserprofile(value) {
        this.__checkuserprofile = value;
    }
    @api
    get email() {
        return this.__email;
    }

    set email(value) {
        this.__email = value;
    }



    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    get columns2() {
        return [{ "label": "Voir Facture", "type": "button-icon", "typeAttributes": { "label": "Voir Facture", "iconName": "utility:download", "name": "view_Invoice", "title": "Cliquer ici pour télécharger la facture" } }, { "fieldName": "Id", "label": "Numéro de facture" }, { "fieldName": "invoiceAmount", "label": "Montant TTC", "type": "currency", "typeAttributes": { "currencyCode": "MAD" } }, { "fieldName": "remainingAmount", "label": "Reste à payer", "type": "currency", "typeAttributes": { "currencyCode": "MAD" } }, { "fieldName": "invoicePaymentDueDate", "label": "Date d'échéance" }, { "fieldName": "status", "label": "Statut paiement", "sortable": "true" }, { "fieldName": "InvoiceDate", "label": "Date de facturation", "sortable": "false", "type": "date", "typeAttributes": { "year": "numeric", "month": "2-digit", "day": "2-digit" }, "editable": false }, { "fieldName": "invoiceStartDate", "label": "Période Début", "editable": false }, { "fieldName": "invoiceEndDate", "label": "Période Fin", "editable": false }]
    }

    handleRowAction(event) {
        console.log("handleRowAction clicked")

        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'view_details':
                console.log('button clicked');
                console.log(row.Id);
                this.navigateToRecordPage('Case', row.Id);
                break;
            case 'view_Invoice':
                console.log('button view_Invoice clicked');
                console.log(row.Id);
                this.getInvoice(row.Id);
                break;
            default:
                console.log('nothing');
                break;
        }


    }



    handleChangeStatus(event) {
        console.log('event.target.value :' + event.target.value)
        this.status_value = event.target.value;
        if (event.target.value !== "all") {
            this.filterdrecords = this.records.filter(item => {
                return item.status == event.target.value;
            }
            );
        } else this.filterdrecords = [...this.records]

    }



    navigateToRecordPage(sObject, recordId) {
        console.log(recordId);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    // Used to sort the 'Date' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        console.log('start onHandleSort : ');
        try {

            const { fieldName: sortedBy, sortDirection } = event.detail;

            console.log('-this.sortData(sortedBy, sortDirection);');
            this.sortData(sortedBy, sortDirection);

            this.sortDirection = sortDirection;
            this.sortedBy = sortedBy;
            console.log('end onHandleSort : ');

        } catch (error) {
            console.log(error);

        }

    }

    sortData(fieldName, sortDirection) {
        try {
            let sortResult = [...this.records]; // Same as Object.assign([], this.data)
            let parser = (v) => v;
            let column = this.columns2.find(c => c.fieldName === fieldName);
            if (column.type === 'date' || column.type === 'datetime') {
                parser = (v) => (v && new Date(v));
            }
            let sortMult = sortDirection === 'asc' ? 1 : -1;
            this.records = sortResult.sort((a, b) => {
                let a1 = parser(a[fieldName]), b1 = parser(b[fieldName]);
                let r1 = a1 < b1, r2 = a1 === b1;
                return r2 ? 0 : r1 ? -sortMult : sortMult;
            });
        } catch (error) {
            console.log(error);
        }

    }

    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.getDataInvoices();

        this.start_date = (this.start_date) ? this.start_date : this.today.toJSON().slice(0, 10);
        this.end_date = (this.end_date) ? this.end_date : this.addDays(this.today, 1).toJSON().slice(0, 10);
        this.range = this.diff(this.start_date, this.end_date);
    }




    getDataInvoices() {
        this.__loading = true;
        const input = `{"Id": "` + this.__accountid + `"}`;
        console.log(this.__accountid);
        console.log(input);

        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "Inwi_Inwib2CInvoiceByBillingAccount",
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("call getDataInvoices");
                this.__loading = false;
                this.records = [];
                this.filterdrecords = [];
                console.log(response);
                // check type of api response
                let apiList = [];
                if (response && response.result && response.result.IPResult && response.result.IPResult.list) {
                    if (response.result.IPResult.list instanceof Array) {
                        apiList = [...response.result.IPResult.list];
                    } else if (response.result.IPResult.list instanceof Object) {
                        if (response.result.IPResult.list.status) {
                            apiList.push(response.result.IPResult.list);
                        }
                    }
                }

                //

                this.records = [...apiList];
                this.filterdrecords = [...apiList];
                console.log("filter record");
                console.log("filter record");
                let temp = []


                let t = [...apiList];
                console.log("filter record" + t);

                for (var key in t) {
                    temp.push(t[key]);
                    console.log(" temp" + temp);

                }

                if (this.stockeceddata.length == 0) {
                    this.stockeceddata = temp;


                    this.pickListvalues2 = this.stockeceddata.map(element => {
                        let v2 = {
                            "value": element.status,
                            "label": element.status
                        }
                        return v2;
                    })

                    let allElement = {
                        "value": 'all',
                        "label": 'Tout'
                    }
                    this.pickListvalues2.unshift(allElement)
                    this.pickListvalues2 = this.pickListvalues2.filter((thing, index, self) =>
                        index === self.findIndex((t) => (
                            t.value === thing.value && t.label === thing.label
                        ))
                    )
                }

                if (temp.length != 0)

                    return temp;

                console.log('t :')
                console.log(t)
            })
            .catch(error => {
                console.log("error");
                window.console.log(error);
            });





    }


    addDays = (sd, days) => {
        const d = new Date(Number(sd));
        d.setDate(sd.getDate() + days);
        return d;
    }

    diff = (sdate, edate) => {
        let diffTime = Math.abs(new Date(edate).getTime() - new Date(sdate).getTime());
        return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    }

    valid_date = (sdate, edate) => {
        console.log("date")
        return new Date(edate) >= new Date(sdate);
    }

    handleDateChange = (evt) => {
        let field_name = evt.target.name;
        console.log(evt.target.value);

        if (field_name === 'startdate')
            this.start_date = evt.target.value;
        if (field_name === 'enddate')
            this.end_date = evt.target.value;

        this.filterdrecords = this.records.filter(item => {
            const sd = item.invoiceStartDate.substring(6) + "-" + item.invoiceStartDate.substring(3, 5) + "-" + item.invoiceStartDate.substring(0, 2);
            const ed = item.invoiceEndDate.substring(6) + "-" + item.invoiceEndDate.substring(3, 5) + "-" + item.invoiceEndDate.substring(0, 2);
            return new Date(sd).getTime() >= new Date(this.start_date).getTime() && new Date(sd).getTime(this.end_date) >= new Date(sd).getTime(ed)


        })

        // if (this.valid_date(this.start_date, this.end_date) === true) {
        //     this.range = this.diff(this.start_date, this.end_date);
        //     console.log("datarange" + this.range);
        //     console.log("this.start_date" + this.start_date);
        //     console.log("this.this.end_date" + this.end_date);
        // } else {
        //     let inputfield = this.template.querySelector("." + field_name);
        //     inputfield.setCustomValidity('End date must be greater than the Start date');
        //     inputfield.reportValidity();
        // }
    }




    getInvoice(invoiceId) {

        const b64toBlob = (b64Data, contentType = '', sliceSize = 512) => {
            const byteCharacters = atob(b64Data);
            const byteArrays = [];

            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                const slice = byteCharacters.slice(offset, offset + sliceSize);

                const byteNumbers = new Array(slice.length);
                for (let i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }

                const byteArray = new Uint8Array(byteNumbers);
                byteArrays.push(byteArray);
            }

            const blob = new Blob(byteArrays, { type: contentType });
            return blob;
        }

        const showFile = function (blob, invoiceId) {



            //console.log('in Show');
            var link = document.createElement('a');

            link.href = 'data:application/octet-stream;base64,' + blob;
            link.download = invoiceId + ".pdf";
            link.click();

        }


        const params = {
            input: '{"invoiceId": "' + invoiceId + '"}',
            sClassName: 'inwiB2C_InvoiceIntegration',
            sMethodName: 'getInvoice',
            options: '{}',
        };

        console.log('before call apex1');

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                //console.log(JSON.stringify(response));
                if (response.result.pdf) {
                    showFile(response.result.pdf, invoiceId);
                } else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: 'Erreur lors de la récupération de la facture PDF',
                            variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }
    
    // ODE parcours facture en litige 
    get showButtons() {
        return this.__selectedRows.length > 0
    }
    get showlitige() {
        return this.__checkuserprofile
    }
   
    getSelectedRecord(event) {
     const selectedRows = event.detail.selectedRows;
     this.__selectedRows = selectedRows;
    console.log('selectedRows:',  this.__selectedRows);

  // H-M : un contrôle sur le bouton "Générer reçu de paiement" afin qu’il ne s’affiche pas lorsque le statut de paiement est "Impayé".
     if (selectedRows.length > 0) {

        const Rows = JSON.parse(JSON.stringify(selectedRows));
        // Vérifier les statuts
        this.canShowReceiptButton = Rows.every(row => row.status !== 'Impayée');
        console.log('canShowReceiptButton:', this.canShowReceiptButton);
     } else {
        this.canShowReceiptButton = false;
     }
  }

    handleFactureEnLitige(event) {
        const dataCount = this.__selectedRows.filter(item => item.status === "Impayée" || item.status === "Partiellement payée" || item.status === "En Relance" || item.status === "En Contentieux");
        if (dataCount && dataCount.length === this.__selectedRows.length) {
            this.__saving = true;
            const invoiceId = dataCount[0].Id;

            //const input = `{"invoiceId": "` + invoiceId + `", "inDispute": true}`;
            const input = `{
                "customerbill": [
                    {
                        "inDispute": true,
                        "invoiceId": "` + invoiceId + `"
                    }
                ]
            }`;

            console.log(input)
            const params = {
                input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_update_litige_flag",
                options: "{}",
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log("call inwib2c_update_litige_flag");
                    console.log(response);
                    this.__saving = false;
                    if (!response.error) {
                        if (response.result && response.result.IPResult && response.result.IPResult.status == "OK") {
                            this.__selectedRows = [];
                            this.getDataInvoices();
                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Erreur',
                                    message: "Erreur Status KO",
                                    variant: 'error'
                                }),
                            );
                        }

                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: response.result.IPResult.error,
                                variant: 'error'
                            }),
                        );
                    }

                })
                .catch(error => {
                    console.log("error");
                    window.console.log(error);
                });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Il faut séléctionner que des facture dont le status est Impayée ou ....',
                    variant: 'error'
                }),
            );
        }
    }

    handleSortieLitige(event) {
        console.log("handleSortieLitige");
        const dataCount = this.__selectedRows.filter(item => item.status === "En litige");
        if (dataCount && dataCount.length === this.__selectedRows.length) {
            this.__saving = true;
            console.log("call vip sortie de litige");
            const invoiceId = dataCount[0].Id;

            // const input = `{"invoiceId": "` + invoiceId + `", "inDispute": false }`;
            const input = `{
                "customerbill": [
                    {
                        "inDispute": false,
                        "invoiceId": "` + invoiceId + `"
                    }
                ]
            }`;
            console.log(input);
            
            const params = {
                input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_update_litige_flag",
                options: "{}",
            };

            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    console.log("call inwib2c_update_litige_flag");
                    this.__saving = false;
                    if (!response.error) {
                        if (response.result && response.result.IPResult && response.result.IPResult.status == "OK") {
                            this.__selectedRows = [];
                            this.getDataInvoices();
                        } else {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Erreur',
                                    message: "Erreur Status KO",
                                    variant: 'error'
                                }),
                            );
                        }

                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Erreur',
                                message: response.result.IPResult.error,
                                variant: 'error'
                            }),
                        );
                    }
                })
                .catch(error => {
                    console.log("error");
                    window.console.log(error);
                });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Il faut séléctionner que des facture en litige',
                    variant: 'error'
                }),
            );
        }
    }



    handleSendEmail(event) {
        console.log("handleSendEmail");
        console.log("dataCount");
        console.log("this.__selectedRows" + this.__selectedRows);

        const dataCount = this.__selectedRows;

        console.log("call vip send");
        const invoiceId = dataCount[0].Id;
        console.log("invoiceId" + invoiceId);
        console.log("email" + this.email);


        const input = `{"invoiceId": "` + invoiceId + `", "email": "` + this.email + `" }`;
        console.log(input)
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_SendEmail",
            options: "{}",
        };

        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log("call inwib2c_InwiB2C_SendEmail");
                this.__saving = false;
                if (!response.error) {
                    if (response.result && response.result.IPResult && response.result.IPResult.status == "OK") {
                        console.log("Succes true ");

                        this.__send = true,
                            this.__selectedRows = [];
                        this.getDataInvoices();
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Succes',
                                message: "Votre email est bien envoyé au client",
                                variant: 'Succes'
                            }),
                        );
                    }
                    else {
                        const evt = new ShowToastEvent({
                            title: 'Toast Success',
                            message: 'Opearion sucessful',
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }

                }

            })
            .catch(error => {
                console.log("error");
                window.console.log(error);
            });

    }

    navigateToVFPage() {
        const dataCount = this.__selectedRows;
        const invoiceId = dataCount[0].Id;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/inwiB2C_RecuPaiementInvoice?accountId=' + this.__accountid + '&invoiceId=' + invoiceId
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
            // window.location.replace(generatedUrl);


        });
    }

    render() {
        return temp;
    }

}