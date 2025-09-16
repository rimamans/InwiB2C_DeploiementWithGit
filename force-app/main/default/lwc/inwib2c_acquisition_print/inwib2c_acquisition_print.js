/* eslint-disable vars-on-top */
import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_acquisition_print.html";

export default class Inwib2c_acquisition_print extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    __bills;
    __data = [];
    __userprofile;
    __loading = true;
    __vlccart;
    // __isidarduo;
    // __istrue;
    // __ISDisable;

    __disablefristbilling = false;
    __displayFactureFMSFMD 
    __buttonLabel 
    __displayFmd = false;


    __FactureFMSFMD 
    __FactureFMD 


    @api
    get bills() {
        return this.__bills;
    }
    set bills(value) {
        this.__bills = value;
    }

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

    // @api
    // get isidarduo() {
    //     return this.__isidarduo;
    // }
    // set isidarduo(value) {
    //     this.__isidarduo = value;
    // }
    // @api
    // get istrue() {
    //     return this.__istrue;
    // }
    // set istrue(value) {
    //     this.__istrue = value;
    // }
    @api
    get disablefristbilling () {
        return this.__disablefristbilling;
    }
    set disablefristbilling (value) {
        this.__disablefristbilling = value;

    }
    get buttonLabel() {
        return this.__displayFmd ? "Facture Frais" : "Facture FMS";
        // return this.__buttonLabel;
    }


    __eshopemode='';
    @api
    set eshopemode(value){
      this.__eshopemode = value;
    }
    get eshopemode(){
      return this.__eshopemode;
    }

    __paiement='';
    @api
    get paiement(){
        return this.__paiement;
      }
    set paiement(value){
      this.__paiement = value;
    }
    __modepaiement='';
    @api
    get modepaiement(){
        return this.__modepaiement;
    }
    set modepaiement(value){
        this.__modepaiement= value;
    }
   
    get isShowed(){
        return this.eshopemode!='Domicile' ||( this.eshopemode==='Domicile' && this.paiement==='exist') ? true : false; 
      }

      __canal ='';
      @api
      get canal(){
        return this.__canal;
      }
      set canal(value){
        this.__canal = value;
      }



    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
         console.log('Eshop', this.eshopemode);
         console.log('Eshop', this.isEshop);
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
    }

    // generateData() {
    //     console.log("generateData");
    //     let data = JSON.parse(JSON.stringify(this.__vlccart));
    //     console.log(data);
    //     var datestring =
    //         new Date().getFullYear() +
    //         "-" +
    //         ("0" + (new Date().getMonth() + 1)).slice(-2) +
    //         "-" +
    //         ("0" + new Date().getDate()).slice(-2) +
    //         "T" +
    //         new Date().toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1") +
    //         "Z";
    //     data && data.records.map((item, index) => {

    //         let input =
    //             `{
    //         "orderid": "` + item.OrderId.value + `",
    //         "activation_date": "` + datestring + `",
    //         "prix_forfait": ` + item.vlocity_cmt__RecurringCharge__c.value + `,
    //         "fms": ` + item.InwiB2C_FMS__c.value + `,
    //         "orderitemid": "` + item.Id.value + `"
    //           }`;
    //         const params = {
    //             input,
    //             sClassName: `${this._ns}IntegrationProcedureService`,
    //             sMethodName: "inwib2c_inwib2c_invoice_simulation",
    //             options: "{}",
    //         };

    //         this._actionUtilClass
    //             .executeAction(params, null, this, null, null)
    //             .then(response => {
    //                 console.log("callInvoiceSimulation");
    //                 console.log(response);
    //                 let responsevip = response.result.IPResult;
    //                 responsevip.id = index;
    //                 responsevip.offer = item.Name;
    //                 //return item;
    //                 this.__data.push(responsevip);
    //                 console.log(this.__data);
    //                 console.log(this.__data.length, data.records.length);
    //                 if (this.__data.length === data.records.length) {
    //                     this.__loading = false
    //                 }
    //             })
    //             .catch(error => {
    //                 console.log("error");
    //                 window.console.log(error);
    //             });

    //     });

    // }

    async generateData() {
        console.log("generateData");
        let data = JSON.parse(JSON.stringify(this.__vlccart));
        console.log(data);
        var datestring =
            new Date().getFullYear() +
            "-" +
            ("0" + (new Date().getMonth() + 1)).slice(-2) +
            "-" +
            ("0" + new Date().getDate()).slice(-2) +
            "T" +
            new Date().toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1") +
            "Z";

        let filtredData = data.records.filter(item => item.action !== "Disconnect" && item.vlocity_cmt__Product2Id__r != null && item.vlocity_cmt__Product2Id__r.Family !== 'Accessoire');

        console.log("filtredData");
        console.log(filtredData);
        console.log(filtredData.length);
 
        // SOL1
        for (let index = 0; index < data.records.length; index++) {
            console.log(index);
            const item = data.records[index];
            if (item.action !== "Disconnect" && item.vlocity_cmt__Product2Id__r != null && item.vlocity_cmt__Product2Id__r.Family !== 'Accessoire') {
                let input =
                    `{
                    "orderid": "` + item.OrderId.value + `",
                    "activation_date": "` + datestring + `",
                    "prix_forfait": ` + item.vlocity_cmt__RecurringCharge__c.value + `,
                    "fms": ` + item.InwiB2C_FMS__c.value + `,
                    "orderitemid": "` + item.Id.value + `"
                    }`;

                // eslint-disable-next-line no-await-in-loop
                const contents = await this.getfirstinvoice(input);
                console.log(contents);
                let responsevip = contents.result.IPResult;
                responsevip.id = index;
                responsevip.offer = item.Name;
                // eslint-disable-next-line eqeqeq
                if (responsevip.prix_forfait == 49) {
                    responsevip.prorata_period_amount = 0;
                    responsevip.fstinvoice_amount = 49;
                }

                responsevip.fmd = item.InwiB2C_FMD__c ? item.InwiB2C_FMD__c.value : 0;
                
                //return item;
                this.__data.push(responsevip);
                if (this.__data.length === filtredData.length) {
                    this.__loading = false
                }
            }
        }


        
     //Display First Billing 

        this.__data.forEach(item =>{
            // eslint-disable-next-line eqeqeq
            console.log('Type Canal:', this.__canal);
            if (item.IsProrate == "Oui"  && !this.__disablefristbilling && this.__canal !="D2D"){
                    
                this.__disablefristbilling = true;
            }
            console.log('isprorata:', item.IsProrate);
            console.log('Display first billing:', this.__disablefristbilling);
            });
        
   
     // Display billing facture Fms 
  
        this.__data.forEach(item =>{

            // eslint-disable-next-line eqeqeq
            if ( (item.fms > 0 && item.fmd == 0 ) && !this.__FactureFMSFMD ){
                 this.__FactureFMSFMD = true;

           }else if ((item.fms > 0 && item.fmd > 0 ) && !this.__FactureFMSFMD ){
               this.__FactureFMSFMD = true;
               this.__displayFmd = true;

            // eslint-disable-next-line eqeqeq
            }else if((item.fms == 0 && item.fmd == 0 ) && !this.__FactureFMD){
                 this.__FactureFMD = false;
             
            }else  if(item.fmd > 0  && !this.__FactureFMD){
                 this.__displayFmd = true;
                 this.__FactureFMD = true;
            }
            
        });
 
        this.__displayFactureFMSFMD  = this.__FactureFMSFMD ? this.__FactureFMSFMD : this.__FactureFMD;
        console.log('displayFactureFMSFMD :',this.__displayFactureFMSFMD );
        console.log('FactureFMSFMD :', this.__FactureFMSFMD );
        console.log('FactureFMD:', this.__FactureFMD );
        


    }


    async getfirstinvoice(input) {
        console.log("call vip")
        const params = {
            input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_inwib2c_invoice_simulation",
            options: "{}",
        };

        return this._actionUtilClass
            .executeAction(params, null, this, null, null);
    }


    handlePrint(event) {
        console.log("print simulation");
        let inputList = [];
        // eslint-disable-next-line array-callback-return
        this.__data.map(item => {
            console.log(JSON.stringify(item));
 
                let text = item.activation_date;
                console.log('text:', text);
                
             
                text = text.substring(0, 10);
                text =
                text.substring(6) +
                "-" +
                text.substring(3, 5) +
                "-" +
                text.substring(0, 2);

                
          // reformate la date au format "jj-mm-aaaa"
                const  Dateactiavte = text;
                let DateActvation = Dateactiavte.split("-").reverse().join("-").replace(/-/g, '/');
                console.log('DateActvation:', DateActvation);

            // eslint-disable-next-line eqeqeq
            const item_billing_cycle = item.billing_cycle.toString().length == 1 ? "0" + item.billing_cycle : item.billing_cycle;


            var date = new Date(text);
            date.setDate(date.getDate() + item.prorata_period - 1);
            var dateFirstdaycycle = new Date(text);
         
          if(item.TypeDeMigration === 'MigIdarVerFtth' || item.TypeDeMigration === 'MigIdarVerADSL' ||  item.TypeDeMigration === 'MigADSLVersFtth' || item.TypeDeMigration ==='MigVersIdar'){
            // eslint-disable-next-line radix
            if(item.billing_cycle === 18){
                dateFirstdaycycle.setMonth(dateFirstdaycycle.getMonth()) 
                console.log('dateFirstdaycycle: ' + dateFirstdaycycle)
            }else {
                dateFirstdaycycle.setMonth(dateFirstdaycycle.getMonth()+ 1 ) 
                console.log('dateFirstdaycycle: ' + dateFirstdaycycle)
            }
       
            
            var FirstcycledayMigidar =
            item_billing_cycle +
            "/" +
            ("0" + (dateFirstdaycycle.getMonth() + 1)).slice(-2) +
            "/" +
            (dateFirstdaycycle.getMonth() == 0 ? date.getFullYear()  : date.getFullYear());
 
            var dateLastCycle = (dateFirstdaycycle.getMonth() == 0 ? date.getFullYear()  : date.getFullYear()) +
            "-" + ("0" + (dateFirstdaycycle.getMonth() + 1)).slice(-2) +
            "-" + item_billing_cycle;

            console.log('dateLastCycle: ' + dateLastCycle);
            var dateLast = new Date(dateLastCycle);
            // datedf.setMonth(datedf.getMonth() + 1);
            dateLast.setMonth(dateLast.getMonth() + 1);

          // Récupérer le mois suivant
           var nextMonth = parseInt(item_billing_cycle, 10) + 1;

          // Créer une date pour le premier jour du mois suivant
           var nextMonthDate = new Date(dateLastCycle);
           nextMonthDate.setMonth(nextMonth - 1, 1);
  
           // Récupérer le dernier jour du mois suivant
           var lastDayNextMonth = new Date(nextMonthDate.getFullYear(), nextMonth, 0).getDate();

           // Ajuster la date en fonction du dernier jour du mois suivant
            var day = Math.min(lastDayNextMonth, dateLast.getDate());
            dateLast.setDate(day);
            // eslint-disable-next-line eqeqeq
            const dayLastCycle = day.toString().length == 1 ? "0" + day : day;

            var LastDaycycle =
            dayLastCycle +
                "/" +
                ("0" + (dateLast.getMonth() + 1)).slice(-2) +
                "/" +
                // date.getFullYear();
            // eslint-disable-next-line eqeqeq
             dateLast.getFullYear();
             
             console.log('LastDaycycle: ' + LastDaycycle)

             // Convertir la date LastDaycycle en objet Date
           var lastDayCycleDate = new Date(LastDaycycle.split('/').reverse().join('/'));

           // Soustraire un jour à la date LastDaycycle
            var lastDayCycleDateMinusOneDay = new Date(lastDayCycleDate.getTime() - 24 * 60 * 60 * 1000);

            var lastDayCycleDateMinusOneDayFormatted = lastDayCycleDateMinusOneDay.toLocaleDateString('fr-FR');

             
            // eslint-disable-next-line eqeqeq
            var dateNextCycle = (dateFirstdaycycle.getMonth() == 0 ? date.getFullYear()  : date.getFullYear()) +
            "-" + ("0" + (dateFirstdaycycle.getMonth() + 1)).slice(-2) +
            "-" + item_billing_cycle;

            console.log('dateNextCycle: ' + dateNextCycle);
            var dateNext = new Date(dateNextCycle);
            dateNext.setMonth(dateNext.getMonth() + 1);

            var NextCycle =

                item_billing_cycle +
                "/" +
                ("0" + (dateNext.getMonth() + 1)).slice(-2) +
                "/" +
                dateNext.getFullYear();
             
             console.log('NextCycle: ' + NextCycle)

                     
           var periodfactureedMig = lastDayCycleDateMinusOneDayFormatted;
   
           var startday_first_phraseMig = FirstcycledayMigidar.substring(0, 1) === "0" ? FirstcycledayMigidar.substring(1, 2) + "er" : FirstcycledayMigidar.substring(0, 2);

           var startdayMig = parseFloat(item.billing_cycle) === 1 ? "20" : "7";
           var firstPhraseMig = "Votre cycle de facturation démarre le " + startday_first_phraseMig + " de chaque mois.";
           var secondPhraseMig = FirstcycledayMigidar.substring(0, 1) === "0" ? "et prend fin le dernier jour du mois" : "et prend fin le " + periodfactureedMig.substring(0, 2) + " du mois suivant";


          }
   
            dateFirstdaycycle.setDate(dateFirstdaycycle.getDate() + parseInt(item.prorata_period));
            console.log('dateFirstdaycycle: ' + dateFirstdaycycle)

          
            var firstdaycycle =
                item_billing_cycle +
                "/" +
                ("0" + (dateFirstdaycycle.getMonth() + 1)).slice(-2) +
                "/" +
                dateFirstdaycycle.getFullYear();
             
             console.log('firstdaycycle: ' + firstdaycycle)

             const datedfString =
             dateFirstdaycycle.getFullYear() +
             "-" +
             ('0' + (dateFirstdaycycle.getMonth() + 1)).slice(-2) +
             "-" +
             item_billing_cycle;
     
           console.log('datedfString: ' + datedfString);
          

           const datedf = new Date(datedfString.replace(/-/g, '/'));
           datedf.setMonth(datedf.getMonth() + 1);
       
           console.log('datedf: ' + datedf);
 
            var secondbill =
                item_billing_cycle +
                "/" +
                ("0" + (datedf.getMonth() + 1)).slice(-2) +
                "/" +
                datedf.getFullYear();
        
           console.log('secondbill: ' + secondbill);
      
        
            const periodfactureedf = secondbill;
            // Phrases
            // const startday = firstdaycycle.substring(0, 1) == "0" ? firstdaycycle.substring(1, 2) + "er" : firstdaycycle.substring(0, 2); ano B-5083

            const startday_first_phrase = firstdaycycle.substring(0, 1) == "0" ? firstdaycycle.substring(1, 2) + "er" : firstdaycycle.substring(0, 2);

            const startday = parseFloat(item.billing_cycle) === 1 ? "20" : "7";
            const firstPhrase = "Votre cycle de facturation démarre le " + startday_first_phrase + " de chaque mois.";
            const secondPhrase = firstdaycycle.substring(0, 1) == "0" ? "et prend fin le dernier jour du mois" : "et prend fin le " + periodfactureedf.substring(0, 2) + " du mois suivant";

            inputList.push({
                TypeDeMigration : item.TypeDeMigration,
                TypeContrat : item.TypeContratDoc,
                clientname: item.clientname,
                periodfactureedd:DateActvation,
                periodfactureedf: periodfactureedf,
                periodfactureedMig :periodfactureedMig,
                offer: item.offer,
                activationdate:DateActvation,
                FirstcycledayMigidar:FirstcycledayMigidar,
                LastDaycycle : lastDayCycleDateMinusOneDayFormatted,
                firstdaycycle: firstdaycycle,
                startday,
                startdayMig,
                secondbill: secondbill,
                NextCycle: NextCycle,
                days: item.prorata_period,
                priceprorata: item.prorata_period_amount,
                pricefirstmonth: item.prix_forfait,
                total: item.fstinvoice_amount,
                totalMig :item.prix_forfait,
                firstPhrase,
                secondPhrase,
                firstPhraseMig,
                secondPhraseMig
            });

       


        })


        event.stopPropagation();
        const input = { data: inputList };

        // eslint-disable-next-line eqeqeq
        let url = this.__userprofile == "Inwi POS" || this.__userprofile == "BackOffice Wakil" || this.__userprofile == "Wafacash"  ? "../apex/inwib2c_first_bill?input=" : "/apex/inwib2c_first_bill?input=";
        console.log(JSON.stringify(input));
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

    formatPrice(n) {
        if (Number(n) === n && n % 1 === 0) {
            return n + ".00"
        // eslint-disable-next-line no-else-return
        } else {
            return n;
        }
    }

    handlePrintFMS(event) {
        let inputList = [];
        console.log(this.__data)
        // eslint-disable-next-line array-callback-return
        this.__data.map(item => {
            const item_fms = {
                TypeContrat : item.TypeContratDoc,
                TypeDoc : item.TypeDoc,
                clientname: item.clientname,
                offer: encodeURIComponent(item.offer),
                num_cf: item.num_cf ? item.num_cf : "",
                gamme: item.gamme,
                activationdate: item.activation_date.substring(0, 10),
                address: item.address,
                pays: item.pays,
                ville: item.ville,
                region: item.region,
                numfacture: "FMS" + item.Code_de_transaction_FMS,
                idpanier: "C" +item.ordernumber,
                numligne: item.numligne,
                fmd : item.fmd,
                fms: this.formatPrice(parseFloat(item.fms / 1.2).toFixed(2)),
                tva: this.formatPrice(parseFloat(item.fms - parseFloat(item.fms / 1.2)).toFixed(2)),
                timbre: "0.00",
                totalttc: this.formatPrice(parseFloat(item.fms * 1)),
                avancepaiement: this.formatPrice(parseFloat(item.fms * 1)),

            }

            console.log("parseFloat(item.fms)", parseFloat(item.fms));
            console.log("parseFloat(item.fmd)", parseFloat(item.fmd));
            if ( !this.__displayFmd || ( this.__displayFmd && parseFloat(item.fms) > 0)) inputList.push(item_fms);


            if (this.__displayFmd && parseFloat(item.fmd) > 0) {
                inputList.push({
                    TypeContrat : item.TypeContratDoc,
                    TypeDoc : item.TypeDoc,
                    clientname: item.clientname,
                    offer: encodeURIComponent(item.offer),
                    num_cf: item.num_cf ? item.num_cf : "",
                    gamme: item.gamme,
                    activationdate: item.activation_date.substring(0, 10),
                    address: item.address,
                    pays: item.pays,
                    ville: item.ville,
                    region: item.region,
                    numfacture: "FMD" + item.Code_de_transaction_FMD,
                    idpanier: "C" +item.ordernumber,
                    numligne: item.numligne,
                    fmd : item.fmd,
                    fms: this.formatPrice(parseFloat(item.fmd / 1.2).toFixed(2)),
                    tva: this.formatPrice(parseFloat(item.fmd - parseFloat(item.fmd / 1.2)).toFixed(2)),
                    timbre: "0.00",
                    totalttc: this.formatPrice(parseFloat(item.fmd * 1)),
                    avancepaiement: this.formatPrice(parseFloat(item.fmd * 1)),

                })
            }
        })
        event.stopPropagation();
        const input = { data: inputList };
        let url = this.__userprofile == "Inwi POS" || this.__userprofile === "BackOffice Distributeur D2D" || this.__userprofile == "BackOffice Wakil" || this.__userprofile == "Wafacash"  ? "../apex/inwib2c_fms_bill?input=" : "/apex/inwib2c_fms_bill?input=";
      console.log('ValueUserprofile :', this.__userprofile );
        console.log(input);
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