import { LightningElement , api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_AmendmentSIM.html";

export default class Inwib2c_AmendmentSIM extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) 
{ 
   
   
    __data = [];
    __userprofile;
    
    __vlccart;
    __orderId;
    

    @api
    get vlccart() {
        return this.__vlccart;
    }
    set vlccart(value) {
        this.__vlccart = { ...value };
    }

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

   

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        // order = this.__orderId;
         console.log('ORDEER'+this.__orderId);
        //console.log('orderid'+this.orderId);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
        
    }

    // printDocument(event){



    // }


    async generateData() {
        console.log("generateData");
        //let data = JSON.parse(JSON.stringify(this.__vlccart));
       // console.log(data);
        var datestring =
            new Date().getFullYear() +
            "-" +
            ("0" + (new Date().getMonth() + 1)).slice(-2) +  
            "-" +
            ("0" + new Date().getDate()).slice(-2) +
            "T" +
            new Date().toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1") +
            "Z";
          


            
            console.log('debuguer');
             

       
        let input =
        `{
        "orderid": "` + this.orderid + `"
        }`;
        // `{
        //     "OrderId": "` + this.__orderId + `"}`;
            console.log('Input');
            console.log(input);

      
        const contents = await this.getInvoiceData(input);

        console.log(contents);
        let responsevip = contents.result.IPResult;

        responsevip.activationdate = datestring;

       
        //return item;
        this.__data.push(responsevip);


    }

   

    async getInvoiceData(input) {
        console.log("call vip")
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_inwiB2C_GetFacturePaiement",
            options: "{}",
        };

        return this._actionUtilClass
            .executeAction(params, null, this, null, null);
    }


    formatPrice(n) {
        if (Number(n) === n && n % 1 === 0) {
            return n + ".00"
        } else {
            return n;
        }
    }

    handledisplay(event) {
        let inputList = [];
        console.log(this.__data)
       
        this.__data.map(item => {
            const item_Sim = {
                TypeacteGestion : item.TypeacteGestion,
                clientname: item.clientname,
                offer: encodeURIComponent(item.TypeOffe),
                num_cf: item.num_cf ? item.num_cf : "",
                gamme: item.gamme,
                activationdate: item.today.substring(0, 10),
                address: item.address,
                pays: item.pays,
                ville: item.ville,
                region: item.region,
                numfacture: item.Code_de_transaction,
                numligne: item.numligne,
                //montantHT: this.formatPrice(parseFloat(item.onetimeTotal / 1.2).toFixed(2)),
                montantHT: this.formatPrice(parseFloat(item.onetimeTotal * 1)),
                montantTVA: this.formatPrice(parseFloat(item.onetimeTotal - parseFloat(item.onetimeTotal / 1.2)).toFixed(2)),
                timbre: "0.00",
                totalttc: this.formatPrice(parseFloat(item.onetimeTotal * 1)),
                avancepaiement: this.formatPrice(parseFloat(item.onetimeTotal * 1)),

            }
            inputList.push(item_Sim);
            console.log('inputlist:'+JSON.stringify(inputList));

        })
        event.stopPropagation();

        const input = { data: inputList };
        console.log(input);
        let url = this.__userprofile == "Inwi POS" ? "../apex/inwib2c_FacturePaiement?input=" : "/apex/inwib2c_FacturePaiement?input=";
        
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