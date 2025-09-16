import { LightningElement,api } from 'lwc';
import template from './inwiB2C_DisplaySubsForRehab.html';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_DisplaySubsForRehab extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    __records = [];
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value;
        }

        columns = [
            { label: 'Souscription', fieldName: 'mdn',hideDefaultActions: 'true'},
            { label: 'Statut', fieldName: 'status',hideDefaultActions: 'true'},
            { label: 'Offre', fieldName: 'offre',hideDefaultActions: 'true' }
        ]; 

        render(){
            return template;
        }
}