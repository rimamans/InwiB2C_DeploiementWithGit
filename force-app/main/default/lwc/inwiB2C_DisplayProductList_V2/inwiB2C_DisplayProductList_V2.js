import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

//import OFFRE1 from '@salesforce/resourceUrl/offres_img';

import template from './inwiB2C_DisplayProductList_V2.html';

export default class InwiB2C_DisplayProductList_V2 extends OmniscriptBaseMixin(LightningElement) {

    // offre1image =     OFFRE1 + '/CARTE_SIM_4G.png';  ;

    @api products;


    get productList() {
        let temp = JSON.parse(JSON.stringify(this.products.records));
        var modifTemp;

        console.log("temp");
        console.log(temp);

        modifTemp = temp.map((produit) => {
            if (typeof produit.Product2.Description === 'undefined' || produit.Product2.Description === null)
                produit.Product2.Description = ""

            if (typeof produit.Attachments === 'undefined' || produit.Attachments === null) 
                produit.Attachments = null;

            console.log('produit: ');
            console.log(produit);
            return produit;
        })

        let finalList = modifTemp.filter(prod => {
            return (prod.category && prod.category == 'Qualified');
        })


        console.log("modifTemp");
        console.log(modifTemp);
        console.log("finalList");
        console.log(finalList);

        return finalList;

    }


    connectedCallback() {
        /*
                Promise.all([
                    loadScript(this, '/resource/inwiB2C_xlsx')
                  ]).then(() => {
                      
                    console.log('script loaded');
                  });
                */
    }

    render() {
        return template;
    }


    handleProductSelectionFromDev(event) {
        console.log('handleProductSelectionFromDev executed');

        

        // get Selected Item
        let selectedLine = event.currentTarget.dataset.idproduct;
        let selectedLineName = event.currentTarget.dataset.productname;
        
        console.log("selectedLine: ");
        console.log(selectedLine);
        console.log(selectedLineName);


        let selectedItems ={ 
            'items': [{
                "itemId": selectedLine
                    }],
            'OfferName': selectedLineName
            }

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems, true);
        this.omniNextStep();

    }

    handleProductSelectionFromImg(event) {
        console.log('handleRowAction executed');

        // get Selected Item
        var selectedLine = event.target.name;

        console.log("selectedLine: ")
        console.log(selectedLine)


        let selectedItems = [{
            "itemId": selectedLine
        }]

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems, true);
        this.omniNextStep();

    }

    handleProductSelection(event) {
        console.log('handleRowAction executed');

        // get Selected Item
        var selectedLine = event.target.name;

        console.log(JSON.stringify(selectedLine));

        let selectedItems = [{
            "itemId": selectedLine.Id.value
        }]

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems, true);
        this.omniNextStep();






    }


}