import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_popUpBlacklist.html'; 

export default class InwiB2C_popUpBlacklist extends OmniscriptBaseMixin(LightningElement) {
    @api records;
    @track motif;
    get alert() {
        try {
            let v = JSON.parse(JSON.stringify(this.records));
            console.log('v' + JSON.stringify(v))

            this.motif = v[0].motif ;
            return v[0].isBlackListed;

        } catch (error) {
            console.log('error: ' + error)
        }
    }
    set alert(v) { }
    render() {
        return template;
    }
}