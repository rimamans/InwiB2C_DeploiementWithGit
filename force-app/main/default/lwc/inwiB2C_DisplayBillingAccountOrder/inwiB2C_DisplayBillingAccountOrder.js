import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { createRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_DisplayBillingAccountOrder.html";
// import { loadStyle } from 'lightning/platformResourceLoader';
// import lwcDatatableStyle from './inwiB2C_DisplayBillingAccountOrder.css'

export default class inwiB2C_DisplayBillingAccountOrder extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  isModalOpen = false;
  @api compteclientid;
  haserror = false;
  _ns = getNamespaceDotNotation();
  isRendered = false

  // @api p;
  // @api r;

  // @api v;
  // @api q;
  // @api pq;

  // _List = [];
  @track loading;
  __records;

  ALLRECORDS = [];

  __records;
  @api
  get records() {
    this.loading = false;

    if (this.ALLRECORDS.length == 0) this.ALLRECORDS = this.__records;
    return this.__records;
  }

  set records(value) {
    this.loading = false;
    console.log("value =", JSON.stringify(value));
    this.__records =
      value &&
      value.map((row, index) => {
        let account_link = `/PortailPDVPhase2/s/account/${row.Id}`;
        return { ...row, account_link, index: index + 1 };
      });
    console.log("__records1" + JSON.stringify(this.__records));
  }

  // get list() {
  //   this.loading = false;

  //   try {
  //     console.log("__records" + JSON.stringify(this.__records));

  //     if (this.__records) {
  //       let history = JSON.parse(JSON.stringify(this.__records));

  //       console.log(JSON.stringify(this._properties));
  //       return this._properties;
  //     } else {
  //       return [];
  //     }
  //   } catch (error) {
  //     console.log("error: " + error);
  //     return [];
  //   }
  // }

  next(event) {
    //console.log('ChangeQuartier')
    this.haserror = false;
    if (this.preSelectedRows == "") {
      this.haserror = true;
      this.errormessage = "Veuillez Séléctionner un compte ";
      console.log('errorrrrrrr');
      console.log(this.preSelectedRows);

    }
    else {
      this.haserror = false;
      console.log('errorrrrrrr222');
      this.omniNextStep();

    }

    //  //console.log('changing region values')
  }
  gotopreviousStep() {
    this.omniPrevStep();

  }


  @track
  columns = [
    //B-0875 RMA 07/05/2021 end

    //{
    //  fieldName: 'AccountNumber', label: 'numéro compte', hideDefaultActions: true, type: "url", target: '_blank',editable: false
    //  },
    {
      label: "numéro compte",
      fieldName: "account_link",
      type: "url",
      typeAttributes: {
        label: {
          fieldName: "AccountNumber",
        },
        target: "_blank",
      },
    },
    {
      fieldName: "Statut",
      label: "Statut",
      hideDefaultActions: true,
      type: "text",
      editable: false,
    },
    {
      fieldName: "ModePaiement",
      label: "Mode de paiement",
      hideDefaultActions: true,
      type: "text",
      editable: false,
    },

    {
      fieldName: "Cycle",
      label: "cycle de facturation",
      hideDefaultActions: true,
      type: "text",
      editable: false,
    },
  ];

  // ModePaiementPicklistvalues = [
  //   { value: "Guichet", label: "Guichet" },
  //   {
  //     value: "Prélèvement automatique (RIB)",
  //     label: "Prélèvement automatique (RIB)",
  //   },
  // ];

  // openModal() {
  //   this.haserror = false;
  //   if (!IdAccountbill == "") {
  //     this.haserror = true;
  //     this.errormessage = "Veuillez Séléctionner un compte ";
  //     console.log('errorrrrrrr');
  //     console.log(IdAccountbill);

  //   }
  //    else {
  //     this.haserror = true;
  //     this.isModalOpen = true;
  //     console.log('errorrrrrrr222');

  //   }
  //   }
  // closeModal() {
  //   this.isModalOpen = false;
  // }

  preSelectedRows = [];
  lastslectedId;
  getSelectedName(event) {
    this.loading = false;
    let selectedRows = event.detail.selectedRows;
    let old_selected = [...this.preSelectedRows];
    console.log("old_selected: ", old_selected);
    console.log("-----------------------");
    let my_ids = [];
    let new_index = 0;
    selectedRows.map((row, index) => {
      console.log(row.index);
      if (!old_selected.includes(row.index)) my_ids.push(row.index);
      else new_index = index;
    });
    let IdAccountbill = selectedRows[new_index].Id;

    this.omniUpdateDataJson({ IdselectedAcc: IdAccountbill });
    //let my_ids = [];
    //my_ids.push(selectedRows[event.detail.selectedRows.length - 1].index);
    this.preSelectedRows = my_ids;
    console.log(this.preSelectedRows);
    /*
           // event.detail.selectedRows = event.detail.selectedRows[event.detail.selectedRows.length-1];

            var el = this.template.querySelector('lightning-datatable');
            console.log('el.SelectedRows::');
            console.log(el.SelectedRows);

           //  this.preSelectedRows=event.detail.selectedRows[event.detail.selectedRows.length-1];
             console.log('selectedRows[event.detail.selectedRows.length-1].AgenceName::');
             console.log(selectedRows[event.detail.selectedRows.length-1].AgenceName);

             if(event.detail.selectedRows.length==2){
                this.lastslectedId=selectedRows[event.detail.selectedRows.length-1].AgenceName;
                 my_ids.push(selectedRows[event.detail.selectedRows.length-1].AgenceName);
             }else{

                this.lastslectedId=selectedRows[event.detail.selectedRows.length-1].AgenceName;

             }

             this.preSelectedRows = my_ids;*/
  }

  render() {
    //console.log(this.omniJsonData);
    return template;
  }

  strName;
  strAccountNumber;
  strPhone;
  // Change Handlers.
  nameChangedHandler(event) {
    this.strName = event.target.value;
  }
  numberChangedHandler(event) {
    this.strAccountNumber = event.target.value;
  }
  phoneChangedHandler(event) {
    this.strPhone = event.target.value;
  }
  gotopreviousStep() {
    this.omniPrevStep();

  }

  renderedCallback() {
    console.log(this.isRendered);
    if (this.isRendered) {
      return;
    }
    this.isRendered = true;

    let style = document.createElement('style');
    style.innerText = '.tableCss table>thead .slds-th__action{background-color: var(--lwc-brandTextLink,rgb(153, 80, 150)); color: white}';
    this.template.querySelector('lightning-datatable').appendChild(style);
  }





}