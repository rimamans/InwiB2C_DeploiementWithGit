import { LightningElement, api } from 'lwc';

import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_RecuPaiementChangForfaitCameleon.html";

export default class InwiB2C_RecuPaiementChangForfaitCameleon extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {



    __data = [];
    __userprofile;
    __demandeId;
    __fraistimbre

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
    set  demandeid(value){
        this.__demandeId = value;
    }

    @api
    get fraistimbre() {
        return this.__fraistimbre;
    }
    set fraistimbre(value) {
        this.__fraistimbre = value;
    }

    
    

    // get buttonLabel() {
    //     return this.__isFormGenerated ? "Document de modification" : "Générer Formulaire";
    // }


    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        // order = this.__orderId;
         console.log('demandeId'+this.__demandeId);
        //console.log('orderid'+this.orderId);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
        console.log('modedepaiement:', this.modedepaiement);

        
    }

    async generateData() {
        console.log("generateData");
        // this.data = JSON.parse(JSON.stringify(this.__orderId));

        let input =
        `{
        "demandeId": "` + this.demandeid + `"
        }`;
        
        console.log('input Recu paiement:', input);

      
        const contents = await this.getInvoiceData(input);

        console.log(contents);
        let responsevip = contents.result.IPResult;
        this.__data.push(responsevip)


          // Mode de paiement


    }

    async getInvoiceData(input) {
        console.log("call vip")
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "InwiB2C_GetInfoDocChngForfaitCamByDemandeId",
            options: "{}",
        };

        return this._actionUtilClass
            .executeAction(params, null, this, null, null);

       
    }



    handlePrint(event) {
    let inputList = [];
    console.log(this.__data)
   
    // eslint-disable-next-line array-callback-return
    this.__data.map(item => {
        
  

        const item_Sim = {
            CodeAgent:item.CodeAgent,
            FullName:item.FullName,
            CodePdv:item.CodePdv,
            CreatedDate :item.CreatedDate,
            Nom:item.Nom,
            Prenom:item.Prenom,
            TotalAmount: item.InvoiceAmount,
            FraisTimbre: Math.round(this.__fraistimbre* 100) / 100,
            Id:item.invoicesId,
            NumeroDeRecu:item.Code_de_transaction,
            BillingAccount:item.BillingAccount,
            ModeDePaiement:item.ModeDePaiement === "inwiB2C_EnEspece" ? 'Espèce' : 'TPE', 
            // ModeDePaiement: this.modedepaiement === "CS" ? 'Espèce' : 'TPE', 
            InvoiceDate : item.InvoiceDate,
            invoicePaymentDueDate :item.InvoicepaymentDuedate,
            invoiceAmount : item.InvoiceAmount,  
        }


        


        if (inputList) {
            inputList.push(item_Sim);
        }
      
        console.log('inputlist:'+JSON.stringify(inputList));

    })
    event.stopPropagation();

    const input = { data: inputList };
  console.log('inputtttt:', input);
    // eslint-disable-next-line eqeqeq
    let url = this.__userprofile == "Inwi POS" ? "/apex/inwiB2C_RecuPaiementMigrationPostPaye?input=" : "/apex/inwiB2C_RecuPaiementMigrationPostPaye?input=";
    console.log('url:', url);
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