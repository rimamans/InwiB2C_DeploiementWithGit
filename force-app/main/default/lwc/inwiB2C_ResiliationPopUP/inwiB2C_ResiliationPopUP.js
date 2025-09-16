import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_ResiliationPopUP.html';

export default class inwiB2C_ResiliationPopUP extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    get alert() {
        try {
            let v = JSON.parse(JSON.stringify(this.records));
            console.log('v' + JSON.stringify(v))

            if (v[0].statut == 'false')
                return false;
            else
                return true;

        } catch (error) {
            console.log('error: ' + error)
        }
    }
    set alert(v) { }
    render() {
        return template;
    }


}