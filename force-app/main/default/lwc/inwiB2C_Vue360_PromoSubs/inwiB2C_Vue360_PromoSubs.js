import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./inwiB2C_Vue360_PromoSubs.html";

export default class InwiB2C_Vue360_PromoSubs extends OmniscriptBaseMixin(LightningElement) {

    __promotions = [];
    columns =[

        {fieldName: 'produit', label: 'Produit', hideDefaultActions: true , editable: false},
        {fieldName: 'promotion', label: 'Promotion', hideDefaultActions: true ,editable: false}
         ];
    @api
    get promotions() {
        return this.__promotions;
    }

    set promotions(value) {
        this.__promotions = value;
    }
    render() {
        console.log("promotions ",this.__promotions);
        return template;
        
    }
}