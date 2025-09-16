import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from "./inwiB2C_DisplayContractElectr.html"

const columns = [
    { label: 'contract', fieldName: 'contract' },
    { label: 'souscription', fieldName: 'souscription' },
    { label: 'order', fieldName: 'order' },
];
export default class InwiB2C_DisplayContractElectr extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    
        constructor() {
            super();
            var contracts = [];
    
        }
        @api contracts;
        @api contractData;
        
        columns = columns
        

        connectedCallback() {
            this.contractData = JSON.parse(JSON.stringify(this.contracts))
            console.log("contractData", this.contractData)
        }

        handleSelectContract(event) {
            console.log(JSON.parse(JSON.stringify(event.detail.selectedRows[0])))
            let selectedContract = JSON.parse(JSON.stringify(event.detail.selectedRows[0]))
            this.omniUpdateDataJson(selectedContract);
            this.omniSaveState(selectedContract, true);
        }
    
        render() {
            return template;
        }
        
}