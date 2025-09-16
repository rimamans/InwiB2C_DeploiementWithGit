import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./inwiB2C_TicketAVRD.html";
export default class InwiB2C_TicketAVRD extends OmniscriptBaseMixin(LightningElement) {

  hideTableHeader = true;

  @api records;

  @track text = "";

  connectedCallback() {
    console.log('Records:', this.records);
    this.text = this.records ? "Aucun ticket AVRD à afficher" : "Tickets AVR éligibles" ;
  }

  @track columns =[
    {fieldName: 'AdvanceAmount', hideDefaultActions: true ,type: "currency",typeAttributes: { currencyCode: "MAD" }, initialWidth: 200,editable: false}
  ]
  @track usageData = [];
  
  render() {
    return template;
  }

  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;
    this.usageData = row.usages;
    this.openmodal();
  }
  @track openUsageDetail = false;
  openmodal() {
    this.openUsageDetail = true
}
closeModal() {
    this.openUsageDetail = false
} 

handleBlur(evt) {
this.omniUpdateDataJson(evt.target.value);
}
}