import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayAccountSameContactNum.html';

export default class InwiB2C_DisplayAccountSameContactNum extends OmniscriptBaseMixin(LightningElement) {

  __records;
  __userprofile;
  @api
  get userprofile() {
    return this.__userprofile;
  }
  set userprofile(value) {
    this.__userprofile = value;
  }
  @api
  get records() {
    return this.__records;
  }

  set records(value) {
    this.__records = JSON.parse(JSON.stringify(value));
  }

  get listaccount() {
    let data = [];

    this.__records &&
      this.__records.map((row, index) => {
        let account_link;
        if (this.__userprofile == "Inwi POS")
          account_link = `/PortailPDVPhase2/s/account/${row.AccountDuplicateNumContact}/view`;
        else
          account_link = `/lightning/r/Account/${row.AccountDuplicateNumContact}/view`;
        row.index = index + 1;
        row.account_link = account_link;
        data.push(row)
      });

    console.log("dataa", JSON.stringify(data))

    return data;
  }

  @track columns = [
    {
      label: "Compte",
      fieldName: "account_link",
      type: "url",
      hideDefaultActions: true,
      typeAttributes: {
        label: {
          fieldName: "Name",
        },
        target: "_blank",
      },
    }
  ];

  connectedCallback() {
  }

}