import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayProductListCameleon.html';

export default class InwiB2C_DisplayProductListCameleon extends OmniscriptBaseMixin(LightningElement) {
    __offres;
    @api
    get offres(){
        return this.__offres;
    }
    set offres(value){
        this.__offres=value;
    }
    render() {
        return template;
    }
    
    get sortedOffers(){
       return this.__offres.sort((a, b) => Number(a.prix)-Number(b.prix))
    }

    get isOffresToDisplayEmpty() {
        return this.__offres.length == 0 ? true : false;
    }

    handleProductSelectionFromDev(event) {
        let selectedLine = event.currentTarget.dataset;
        this.omniUpdateDataJson({ 'selectedOffer':selectedLine});
        this.omniNextStep();

    }
}