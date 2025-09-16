import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import template from './inwiB2C_OrdersDisplay.html';

export default class InwiB2C_OrdersDisplay extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {


    constructor() {
        super();
        var orders = [];
    }
    renderedCallback() {
    }
    

    @api orders; 


     open=false;
 label =  'textttttttttt';



    get sectionClass() {
        return this.open ? 'slds-section slds-is-open' : 'slds-section';
    }

    connectedCallback() {
        if (typeof this.open === 'undefined') this.open = true;
    }

    handleClick() {
        this.open = !this.open;
    }


    render() {

       return template;
    }

}