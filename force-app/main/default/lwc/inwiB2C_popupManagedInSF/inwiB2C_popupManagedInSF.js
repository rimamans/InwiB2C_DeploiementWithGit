import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_popupManagedInSF.html';

export default class InwiB2C_popupManagedInSF extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    // M-dj 26/06/25 afficher different message si statut migration ftth diff null begin 
    get isStatutNull() {
        console.log("statutMigration", this.statutMigration)
        return this.statutMigration === undefined;
    }
    
    get statutMigration() {
        try {
            let statut = JSON.parse(JSON.stringify(this.records));
            console.log('statut' + JSON.stringify(statut))
            return statut[0].statutMigration;

        } catch (error) {
            console.log('error: ' + error)
        }
    }
    // M-dj 26/06/25 afficher different message si statut migration ftth diff null begin

    get alert() {
        try {
            let v = JSON.parse(JSON.stringify(this.records));
            console.log('v' + JSON.stringify(v))

            return v[0].managedInSF;

        } catch (error) {
            console.log('error: ' + error)
        }
    }
    set alert(v) { }
    render() {
        return template;
    }


}