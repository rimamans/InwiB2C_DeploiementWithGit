import { LightningElement,api, wire  } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_ModificationMdn.html";

export default class InwiB2C_ModificationMdn extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    __data = [];
    __userprofile;
    __orderId;
    __isFormGenerated = false;

    @api
    get userprofile() {
        return this.__userprofile;
    }
    set userprofile(value) {
        this.__userprofile = value;
    }

  
    
    @api 
    get orderid(){
        return this.__orderId;
    }
    set orderid(value){
        this.__orderId = value;
    }

    get buttonLabel() {
        return this.__isFormGenerated ? "Document de modification" : "Générer Formulaire";
    }


    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        // order = this.__orderId;
         console.log('ORDEER'+this.__orderId);
        //console.log('orderid'+this.orderId);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
        
    }

    async generateData() {
        console.log("generateData");
        // this.data = JSON.parse(JSON.stringify(this.__orderId));

        let input =
        `{
        "orderid": "` + this.orderid + `"
        }`;

            console.log('Input');
            console.log(input);

      
        const contents = await this.getInvoiceData(input);

        console.log(contents);
        let responsevip = contents.result.IPResult;
        this.__data.push(responsevip)


        this.__data.forEach(item =>{

            if (item.TypeModification == 'Modification de forfait'){
                 this.__isFormGenerated = true;
      
        }
        });

    }

    async getInvoiceData(input) {
        console.log("call vip")
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "InwiB2C_GetInfoDocModificationMdnFromOrderId",
            options: "{}",
        };

        return this._actionUtilClass
            .executeAction(params, null, this, null, null);

       
    }







//     handlePrint(event) {
//     let inputList = [];
//     console.log(this.__data)
   
//     this.__data.map(item => {
//         const item_Sim = {
//         name:item.name,
//         cin : item.cin,
//         OldMdn:item.OldMdn,
//         POSCode :item.POSCode,
//         Offre: encodeURIComponent(item.Offre),
//         OrderNumber:item.OrderNumber,
//         CategorieMdn:item.CategorieMdn,
//         TypeModification:item.TypeModification,
//         FraisChangmentMdn:item.FraisChangmentMdn,
//         NewMdn:item.NewMdn,
//         DateDeFacturation:item.DateDeFacturation,
//         AncienneValeur: encodeURIComponent(item.AncienneValeur),
//         NewMontant :item.NewMontant,
//         OldMontant :item.OldMontant,
//         FraisAmount:item.FraisAmount,
//         MotifModification:item.MotifModification
//         }

//         if (inputList) {
//             inputList.push(item_Sim);
//         }
      
//         console.log('inputlist:'+JSON.stringify(inputList));

//     })
//     event.stopPropagation();

//     const input = { data: inputList };
//   console.log('inputtttt:', input);
//     let url = this.__userprofile == "Inwi POS" ? "../apex/inwiB2C_ModificationMdn?input=" : "/apex/inwiB2C_ModificationMdn?input=";
    
//     this[NavigationMixin.GenerateUrl]({
//         type: "standard__webPage",
//         attributes: {
//             url: url + JSON.stringify(input),
//         },
//     }).then(generatedUrl => {
//         window.open(generatedUrl);
//     });
// }

handlePrint(event) {
    console.log(this.__data);

    this.__data.forEach(item => {
        // Initialisez inputList pour chaque élément
        let inputList = [];

        const item_Sim = {
            name: item.name,
            cin: item.cin,
            OldMdn: item.OldMdn,
            POSCode: item.POSCode,
            Offre: encodeURIComponent(item.Offre),
            OrderNumber: item.OrderNumber,
            CategorieMdn: item.CategorieMdn,
            TypeModification: item.TypeModification,
            FraisChangmentMdn: item.FraisChangmentMdn,
            NewMdn: item.NewMdn,
            DateDeFacturation: item.DateDeFacturation,
            AncienneValeur: encodeURIComponent(item.AncienneValeur),
            NewMontant: item.NewMontant,
            OldMontant: item.OldMontant,
            FraisAmount: item.FraisAmount,
            MotifModification: item.MotifModification
        };

        if (item.TypeModification == 'Modification de forfait') {
            let url = this.__userprofile == "Inwi POS" ? "../apex/InwiB2C_ModificationForfait?input=" : "/apex/InwiB2C_ModificationForfait?input=";
            inputList.push(item_Sim); // Ajoutez les données à inputList
            this.generateAndOpenUrl(url, inputList);
        } else {
            let url = this.__userprofile == "Inwi POS" ? "../apex/inwiB2C_ModificationMdn?input=" : "/apex/inwiB2C_ModificationMdn?input=";
            inputList.push(item_Sim); // Ajoutez les données à inputList
            this.generateAndOpenUrl(url, inputList);
        }

        console.log('inputlist:' + JSON.stringify(inputList));
    });

    event.stopPropagation();
}

generateAndOpenUrl(url, inputList) {
    const input = { data: inputList };
    console.log('inputtttt:', input);

    this[NavigationMixin.GenerateUrl]({
        type: "standard__webPage",
        attributes: {
            url: url + JSON.stringify(input),
        },
    }).then(generatedUrl => {
        window.open(generatedUrl);
    });
}


render() {
    return template;
}

}