import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

import template from './inwiB2C_DisplayProductList_V3.html';

export default class InwiB2C_DisplayProductList_V3 extends OmniscriptBaseMixin(LightningElement) {

    // offre1image =     OFFRE1 + '/CARTE_SIM_4G.png';  ;
    /*B-4061 ILA 19-04-2022 start*/
    __ismigration;
    __oldforfait;
    __oldforfaitname;
    __offrevacancier;
    __offrecameleon;
    __userprofil = "";


    @api
    set ismigration(value) {
        this.__ismigration = value;
    }
    get ismigration() {
        return this.__ismigration;

    }
    @api
    set oldforfait(value) {
        this.__oldforfait = value;
    }
    get oldforfait() {
        return this.__oldforfait;
    }
    @api
    set oldforfaitname(value) {
        this.__oldforfaitname = value;
    }
    get oldforfaitname() {
        return this.__oldforfaitname;
    }


    @api
    set offrevacancier(value) {
        this.__offrevacancier = value;
    }
    get offrevacancier() {
        return this.__offrevacancier;
    }

    @api
    set offrecameleon(value) {
        this.__offrecameleon = value;
    }
    get offrecameleon() {
        return this.__offrecameleon;
    }
    @api
    set userprofil(value) {
        this.__userprofil = value;
    }
    get userprofil() {
        return this.__userprofil;
    }
    /*B-4061 ILA 19-04-2022 end*/

    @api products;
    @api freeoffers;
    offresToDisplay = [];
    structuredOffre = [];

    categoriesOptions = [{ label: 'All', value: 'allCategories' }];

    connectedCallback() {
        this.setCategoriesOptions();

        // if(this.offresToDisplay.length==0)
        this.offresToDisplay = this.structuredOffre;
        console.log("Migration=> ", this.__ismigration);
        console.log("Forfait=> ", this.__oldforfait);
        console.log("ForfaitName=> ", this.__oldforfaitname);
    }

    get dataOffers() {
        //console.log(JSON.stringify(this.offresToDisplay))
        if (this.__ismigration === "true") {
           
                let array = [...this.offresToDisplay];
                console.log(array);

                array = array.filter(item => {
                    return item.name != this.__oldforfaitname
                })

            console.log(array);


            return array.sort((a, b) => a.price - b.price);
            // return this.offresToDisplay.filter(item=>{
            //     return item.name != this.__oldforfaitname
            // }).sort((a, b) => a.price - b.price)

        }
        else {
            return this.offresToDisplay.sort((a, b) => a.price - b.price)
        }

    }


    get isOffresToDisplayEmpty() {
        return this.offresToDisplay.length == 0 ? true : false;
    }
    handleCategoryChange(e) {

        let selectedOption = e.detail.value;
        //console.log('handleCategoryChange_selectedOption: ' + selectedOption);

        if (selectedOption == 'allCategories') {
            //console.log('handleCategoryChange_here1');

            this.offresToDisplay = this.structuredOffre;

        }
        else
            try {
                //console.log('handleCategoryChange_here2');

                this.offresToDisplay = []
                this.structuredOffre.map(element => {
                    //console.log('handleCategoryChangeelement.category==selectedOption ' + element.category+' == '+selectedOption);

                    if (element.category.includes(selectedOption))
                        this.offresToDisplay.push(element);
                });

            } catch (error) {
                console.error('handleCategoryChange_error: ' + error);
            }

        //console.log('handleCategoryChange_this.offresToDisplay.length: ' + this.offresToDisplay.length);



    }

    getType_de_forfait_label(api) {

        switch (api) {
            case 'InwiB2C_MAX_RS':
                return 'Max de Réseaux Sociaux';

            case 'InwiB2C_MAX_IN':
                return 'Max d\'internet';

            case 'InwiB2C_MAX_AP':
                return 'Max d\'appels';

            case 'InwiB2C_MAX_AP_ILLM':
                return 'Appels illimités';
            case 'Collaborateur Inwi':
                return 'Collaborateur Inwi';
            case 'Collaborateur Ona':
                return 'Collaborateur Ona';
            case 'Grand Public':
                return 'Grand Public';
            case 'NAFIDA_2022':
                return 'NAFIDA_2022';

            case 'INWIB2C_Us_quot_Internet':
                return "Usage quotidien d'internet";
            case 'INWIB2C_US_Int_IPTV_streamingSD':
                return 'Usage internet, IPTV et streaming SD';
            case 'INWIB2C_Us_Int_gaming_IPTV_streamingHD':
                return 'Usage internet, gaming, IPTV et streaming HD';
            
            // M-DJ 26/05/25 MGEN3675B-Eclipse_Offre 5G Mobile psp ajouter le filter par serivce 5G begin
            case 'INWIB2C_5G':
                return '5G';
            // M-DJ 26/05/25 MGEN3675B-Eclipse_Offre 5G Mobile psp ajouter le filter par serivce 5G end

            default:
                break;
        }
    }

    setCategoriesOptions() {
        console.log('setCategoriesOptions_start');

        /*  if(typeof this.products.records != 'undefined')
              return ;*/

        try {
            console.log("offers" + JSON.stringify(this.products.records));
            this.products.records.map(offre => {
                //console.log('setCategoriesOptions_InwiB2C_Type_de_forfait__c ' + offre.Product2.InwiB2C_Type_de_forfait__c);
                if ((!offre.ProductCode.value.includes("VACANCIER") || (this.__offrevacancier && offre.ProductCode.value.includes("VACANCIER"))) || (!offre.ProductCode.value.includes("CAMELEON") || (this.__offrecameleon && offre.ProductCode.value.includes("CAMELEON")))) {
                    if (this.__offrecameleon == true && this.__userprofil != "Inwi POS" && this.__ismigration === "true") {
                        this.freeoffers.map(offreCameleon => {
                            if (offreCameleon.Name == offre.ProductCode.value) {
                                let tc = {
                                    id: offre.Id.value,
                                    name: offre.Name.value,
                                    idproduit: offre.productId,

                                    price: offre.UnitPrice.value,//.split('.')[0],
                                    category: (typeof offre.Product2.InwiB2C_Type_de_forfait__c != 'undefined') ? offre.Product2.InwiB2C_Type_de_forfait__c : 'otherCategory',
                                    description: (typeof offre.Product2.Description === 'undefined' || offre.Product2.Description === null) ? "" : offre.Product2.Description,
                                    attachments: (typeof offre.Attachments === 'undefined' || offre.Attachments === null) ? null : offre.Attachments,
                                    isQualified: (offre.category && offre.category == 'Qualified') ? true : false,
                                    isVisible: true
                                }
                                this.structuredOffre.push(tc);
                            }
                        })
                    } else {
                        let t = {
                            id: offre.Id.value,
                            name: offre.Name.value,
                            idproduit: offre.productId,

                            price: offre.UnitPrice.value,//.split('.')[0],
                            category: (typeof offre.Product2.InwiB2C_Type_de_forfait__c != 'undefined') ? offre.Product2.InwiB2C_Type_de_forfait__c : 'otherCategory',
                            description: (typeof offre.Product2.Description === 'undefined' || offre.Product2.Description === null) ? "" : offre.Product2.Description,
                            attachments: (typeof offre.Attachments === 'undefined' || offre.Attachments === null) ? null : offre.Attachments,
                            isQualified: (offre.category && offre.category == 'Qualified') ? true : false,
                            isVisible: true
                        }
                        this.structuredOffre.push(t);
                    }

                    //this.structuredOffre.push(t);


                    if (typeof offre.Product2.InwiB2C_Type_de_forfait__c != 'undefined') {
                        try {
                            const typeArray = offre.Product2.InwiB2C_Type_de_forfait__c.split(";");
                            typeArray.map(type => {
                                this.categoriesOptions.push({ label: this.getType_de_forfait_label(type), value: type });
                            })
                        } catch (error) {

                        }
                        // this.categoriesOptions.push({ label: this.getType_de_forfait_label(offre.Product2.InwiB2C_Type_de_forfait__c), value: offre.Product2.InwiB2C_Type_de_forfait__c });
                    } else
                        this.categoriesOptions.push({ label: 'Autre', value: 'otherCategory' });
                }
            });


            //console.log('setCategoriesOptions_categoriesOptions ' + JSON.stringify(this.categoriesOptions));
            this.categoriesOptions = [...new Map(this.categoriesOptions.map(o => [o['label'], o])).values()];

            //console.log('setCategoriesOptions_categoriesOptions ' + JSON.stringify(this.categoriesOptions));


        } catch (error) {
            console.error('setCategoriesOptions_error ' + error);
        }



    }

    showVars(e) {

        //console.log('Start_showVars');

        //console.log('showVars__this.categoriesOptions ' + JSON.stringify(this.categoriesOptions));



    }




    render() {
        return template;
    }


    handleProductSelectionFromDev(event) {
        //console.log('handleProductSelectionFromDev executed');



        // get Selected Item
        let selectedLine = event.currentTarget.dataset.idproduct;
        let selectedLineName = event.currentTarget.dataset.productname;
        let selectedLineProductId = event.currentTarget.dataset.idproduit;


        //console.log("selectedLine: ");
        //console.log(selectedLine);
        //console.log(selectedLineName);


        let selectedItems = {
            'items': [{
                "itemId": selectedLine
            }],
            'OfferName': selectedLineName,
            'productId': selectedLineProductId
        }

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems, true);
        this.omniNextStep();

    }

    handleProductSelectionFromImg(event) {
        //console.log('handleRowAction executed');

        // get Selected Item
        var selectedLine = event.target.name;

        //console.log("selectedLine: ")
        //console.log(selectedLine)


        let selectedItems = [{
            "itemId": selectedLine
        }]

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems, true);
        this.omniNextStep();

    }

    handleProductSelection(event) {
        //console.log('handleRowAction executed');

        // get Selected Item
        var selectedLine = event.target.name;

        //console.log(JSON.stringify(selectedLine));

        let selectedItems = [{
            "itemId": selectedLine.Id.value
        }]

        this.omniUpdateDataJson(selectedItems);
        this.omniSaveState(selectedItems, true);
        this.omniNextStep();






    }


}