import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import template from './inwiB2C_DisplayProductList.html';

export default class InwiB2C_DisplayProductList  extends OmniscriptBaseMixin(LightningElement) {


    @api products;

    get productList (){

        return this.products.records
    }

    render() {

        
        return template;
    }

    

    handleProductSelection(event) {
        console.log('handleRowAction executed') ;

        // get Selected Item
        var  selectedLine = event.target.name;
        
        console.log(JSON.stringify(selectedLine));

        let selectedItems = [{
            "itemId" : selectedLine.Id.value
        }]

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems,true);
        this.omniNextStep();
        
       




    }


}