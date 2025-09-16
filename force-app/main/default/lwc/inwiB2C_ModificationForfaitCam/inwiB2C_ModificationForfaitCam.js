import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_ModificationForfaitCam.html";
export default class InwiB2C_ModificationForfaitCam extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {

    __data = [];
    __userprofile;
    __demandeId;
    __isFormGenerated = false;

    @api
    get userprofile() {
        return this.__userprofile;
    }
    set userprofile(value) {
        this.__userprofile = value;
    }

  
    
    @api 
    get demandeid(){
        return this.__demandeId;
    }
    set demandeid(value){
        this.__demandeId = value;
    }

    get buttonLabel() {
        // return this.__isFormGenerated ? "Document de modification" : "Générer Formulaire";
         return "Document de modification" ;
    }


    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        // order = this.__orderId;
         console.log('demandeId'+this.__demandeId);
        //console.log('orderid'+this.orderId);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
        
    }

    async generateData() {
        console.log("generateData");
        // this.data = JSON.parse(JSON.stringify(this.__orderId));

        let input =
        `{
        "demandeId": "` + this.demandeid + `"
        }`;

            console.log('Input');
            console.log(input);

      
        const contents = await this.getInvoiceData(input);

        console.log(contents);
        let responsevip = contents.result.IPResult;
        this.__data.push(responsevip)


        // this.__data.forEach(item =>{

        //     if (item.TypeModification == 'Modification de forfait'){
        //          this.__isFormGenerated = true;
      
        // }
        // });

    }

    async getInvoiceData(input) {
        console.log("call vip")
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwiB2C_GetFromDemandeChForfaitCameleon",
            options: "{}",
        };

        return this._actionUtilClass
            .executeAction(params, null, this, null, null);

       
    }







    handlePrint(event) {
    let inputList = [];
    console.log(this.__data)
   
    this.__data.map(item => {
        const item_Sim = {
        name:item.clientname,
        cin : item.cin,
        OldMdn:item.numligne,
        POSCode :item.POSCode,
        Offre: encodeURIComponent(item.TypeOffe),
        OrderNumber:item.DemandeNumber,
        CategorieMdn:item.CategorieMdn,
        TypeModification:item.TypeModification,
        FraisChangmentMdn:item.FraisChangmentMdn,
        NewMdn:item.NewMdn,
        DateDeFacturation:item.DateDeFacturation,
        AncienneValeur: encodeURIComponent(item.AncienneValeur),
        NewMontant :item.NewMontant,
        OldMontant :item.OldMontant,
        FraisAmount:item.FraisAmount,
        }

        if (inputList) {
            inputList.push(item_Sim);
        }
      
        console.log('inputlist:'+JSON.stringify(inputList));

    })
    event.stopPropagation();

    const input = { data: inputList };
  console.log('inputtttt:', input);
    let url = this.__userprofile == "Inwi POS" ? "/apex/InwiB2C_ModificationForfait?input=" : "/apex/InwiB2C_ModificationForfait?input=";
    console.log('userprofile:', this.__userprofile);
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