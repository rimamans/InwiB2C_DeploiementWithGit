import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiB2C_DisplayUnpaidBillsByBillingsAccount extends OmniscriptBaseMixin(LightningElement) {

  _actionUtilClass;
  _ns = getNamespaceDotNotation();
  @api searchby;
  @api cin;
  @api mdn;
  @api billingaccount;
  @api invid;
  @api selectedBillingAccount
  isloading = true

  /* billingAccounts = [
    {
      id: '1',
      name: 'Billing Account 1',
      isChecked: false,
      bills: [
        { id: '101', amount: 100, description: 'Bill 1 for Billing Account 1', isChecked: false, isDisabled:true },
        { id: '102', amount: 200, description: 'Bill 2 for Billing Account 1', isChecked: false, isDisabled: true },
        { id: '103', amount: 200, description: 'Bill 3 for Billing Account 1', isChecked: false, isDisabled: true }
      ]
    },
    {
      id: '2',
      name: 'Billing Account 2',
      isChecked: false,
      bills: [
        { id: '201', amount: 150, description: 'Bill 1 for Billing Account 2', isChecked: false, isDisabled: true },
        { id: '202', amount: 250, description: 'Bill 2 for Billing Account 2', isChecked: false, isDisabled: true }
      ]
    }
  ];  */


  billingAccounts = [];


  get isbillingAccountsEmpty() {
    return this.billingAccounts.length === 0
  }

  get disableSave() {
    return this.billingAccounts.every(account => account.isChecked === false) ||
      (this.billingAccounts.some(account => account.isChecked === true && account.bills.every(bill => bill.isChecked === false)))
  }
  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();

    console.log('Search by', this.searchby,
      '\n MDN', this.mdn,
      "\n CIN ", this.cin,
      '\n billing account ', this.billingaccount,
      '\n invoice number ', this.invid
    )
    this.FindInvoices()

    console.log(this.billingAccounts)

  }

  handleCheckboxChange(event) {
    const billaccountId = event.target.name;
    console.log(billaccountId)

    this.billingAccounts = this.billingAccounts.map(account => {
      if (account.id === billaccountId) {
        account.isChecked = event.target.checked;
        account.bills = account.bills.map(bill => {
          bill.isChecked = event.target.checked;
          bill.isDisabled = bill.isDisabled && false;
          return bill;
        });
      } else {
        account.isChecked = false;
        account.bills = account.bills.map(bill => {
          bill.isChecked = false;
          bill.isDisabled = true;
          return bill;
        });
      }
      return account;
    });
  }

  handleBillCheckboxChange(event) {
    const billId = event.target.name;
    this.billingAccounts = this.billingAccounts.map(account => {
      account.bills = account.bills.map(bill => {
        if (bill.id === billId) {
          bill.isChecked = event.target.checked;
        }
        return bill;
      });
      return account;
    });
  }
  formatDate(dateString) {
    dateString = dateString.replace("[UTC]", '')
    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  getInvoiceStatusLabel(status) {
    switch (status) {
      case "0":
        return "Impayée"
      case "1":
        return "Partiellement payée"
      case "2":
        return "Payée"
      default:
        return status
    }
  }

  FindInvoices() {

    let input = null;
    input = {
      status: "1101",
      ...(this.searchby === "CIN" && { idType: "CIN", idValue: this.cin }),
      ...(this.searchby === "MDN" && { mdn: this.mdn }),
      ...(this.searchby === "BillingAccount" && { accountId: this.billingaccount }),
      ...(this.searchby === "Bill" && { billNo: this.invid }),
    };

    console.log('input', input);

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: 'inwib2c_FindInvoices',
      options: '{}',
    };

    console.log('before call apex1' + JSON.stringify(params));

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log('just after response');
        console.log(response);
        if (response.error == false) {
          console.log(response);

          if (response.result) {
            console.log(response.result);
            if (response.result.IPResult.success == false) {
              this.isloading = false;
              this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Erreur',
                  message: 'Erreur lors de la recherche des factures',
                  variant: 'error'
                }),
              );
            }
            else if (response.result.IPResult?.invoices?.length === 0 || !response.result.IPResult?.invoices) {
              this.isloading = false;
              this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Erreur',
                  message: 'Aucune factures impayées trouvées',
                  variant: 'error'
                }),
              );
            }
            else {
              let billingAccountList = []
              let SubsList = []
              let invoiceslist = [];
              let invoicesResponse = response.result.IPResult?.invoices

              for (const invoice of response.result.IPResult?.invoices) {
                let billingAccountId = invoice?.billingAccount?.id
                if (!billingAccountList.find(item => item.Id === invoice?.billingAccount?.id)) {
                  billingAccountList.push({
                    Id: invoice?.billingAccount?.id,
                    Account: invoice.relatedParty[0].id,
                  })
                }

                if (!invoiceslist.find(item => item.id === billingAccountId)) {
                    invoiceslist.push({
                      id: billingAccountId,
                      isChecked: false,
                      accountnumber: invoice.relatedParty[0].id,
                      bills: [],
                      Subs: []
                    })
                  }

                  invoiceslist.map(item => item.id === billingAccountId && item.bills.push({
                    id: invoice.billNo,
                    Id: invoice.billNo,
                    amount: invoice.remainingAmount.value,
                    montant: invoice.remainingAmount.value + "DH",
                    paymentDueDate: this.formatDate(invoice.paymentDueDate),
                    status: this.getInvoiceStatusLabel(invoice.status),
                    billDate: this.formatDate(invoice.billDate),
                    invoiceAmount: invoice.remainingAmount.value,
                    invoicePaymentDueDate: this.formatDate(invoice.paymentDueDate),
                    InvoiceDate: this.formatDate(invoice.billDate),
                    isChecked: false,
                    isDisabled: true
                  }))  
              }

              console.log('invoiceslist', invoiceslist)
              this.billingAccounts = invoiceslist
              this.billingAccounts = this.billingAccounts.map(account => {
                account.countBills = account.bills.length + 1
                return account
              })
              console.log('invoiceslist', this.billingAccounts)
              console.log('billing list', billingAccountList)
              let input = {
                "BillingAccounts": billingAccountList
              }
              console.log('input bi', input)
              this.isloading = true;
              const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: 'inwib2c_getBillingAccountsSubInfo',
                options: '{}',
              };

              this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                  console.log('billing respons', response)
                  if (response.result?.IPResult?.Subs) {
                    SubsList = response.result.IPResult?.Subs
                    for (const invoice of invoiceslist) {
                      let billingAccountId = invoice?.id
                      let AccountSubList = SubsList.filter(billingAcc => billingAcc.AccountNumber === billingAccountId)
                      invoice.Subs =  AccountSubList     
                      invoice.FirstName = AccountSubList[0]?.FirstName || ""
                      invoice.LastName = AccountSubList[0]?.LastName || ""          
                      }

                    console.log('invoiceslist', invoiceslist)
                    this.billingAccounts = invoiceslist
                    console.log('invoiceslist', this.billingAccounts)
                  }
                  this.isloading = false;
                })
                .catch(error => {
                  console.log('error ', error);
                  this.dispatchEvent(
                    new ShowToastEvent({
                      title: 'Erreur',
                      message: 'Problème technique lors de la recherche des souscriptions',
                      variant: 'error'
                    }),
                  );
                  this.isloading = false;
                });

              /* for (const invoice of invoicesResponse) {
                let billingAccountId = invoice?.billingAccount?.id
                let AccountSubList = SubsList.filter(billingAcc => billingAcc.AccountNumber === billingAccountId)
                if (!invoiceslist.find(item => item.id === billingAccountId)) {
                  invoiceslist.push({
                    id: billingAccountId,
                    isChecked: false,
                    accountnumber: invoice.relatedParty[0].id,
                    bills: [],
                    FirstName: AccountSubList[0]?.FirstName || "",
                    LastName: AccountSubList[0]?.LastName || "",
                    Subs: AccountSubList
                  })
                }
                invoiceslist.map(item => item.id === billingAccountId && item.bills.push({
                  id: invoice.billNo,
                  Id: invoice.billNo,
                  amount: invoice.amountDue.value,
                  montant: invoice.amountDue.value + "DH",
                  paymentDueDate: this.formatDate(invoice.paymentDueDate),
                  status: this.getInvoiceStatusLabel(invoice.status),
                  billDate: this.formatDate(invoice.billDate),
                  invoiceAmount: invoice.amountDue.value,
                  invoicePaymentDueDate: this.formatDate(invoice.paymentDueDate),
                  InvoiceDate: this.formatDate(invoice.billDate),
                  isChecked: false,
                  isDisabled: true
                }))
              } */
            }

          }
        }
        else {
          this.isloading = false;
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Erreur',
              message: 'Problème technique, Merci de ressayer plus tard',
              variant: 'error'
            }),
          );
        }
      })
      .catch(error => {
        console.log('error');
        window.console.log(error);
        this.isloading = false;
      });
  }

  handleNextStep() {
    let selectedAccountinvoice = this.billingAccounts?.filter(
      item => item.isChecked === true
    )[0]
    selectedAccountinvoice.bills = selectedAccountinvoice?.bills?.filter(
      item => item.isChecked === true
    ) || []
    console.log('selectedAccountinvoice', selectedAccountinvoice)

    let selectedinfo = {
      BillingAccount: selectedAccountinvoice.id,
      selectedInvoices: selectedAccountinvoice.bills,
      numberofunpayedinvoices: selectedAccountinvoice?.bills?.length,
      totalamount: selectedAccountinvoice?.bills?.reduce((acc, item) => acc + item.amount, 0),
      accountnumber: selectedAccountinvoice.accountnumber
    }
    this.omniUpdateDataJson(selectedinfo);
    this.omniSaveState(selectedinfo, true);
    this.omniNextStep();
  }

  handlePreviousStep() {
    this.omniPrevStep();
  }
}