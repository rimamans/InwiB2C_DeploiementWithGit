import { LightningElement, api, wire,track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

import template from "./inwiB2C_CheckProduct.html";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class InwiB2C_CheckProduct extends OmniscriptBaseMixin(
  LightningElement
) {
  showIMEI = false;
  //checkorder=false;
 // showIMSI = false;
 // showESN = false;
 // @api imsi;
 // @api imei;
  requestdate;
  //@api esn;
  @api name;
  @api poscode;
  @api districode;
  @track transactionid;
  @track codearticle;
  @api msisdn;
  @api subscriptionid;
  @api accountid;
  _ns = getNamespaceDotNotation();
  _actionUtilClass;
  dataProducts = [];
  loadingProduct = false;
 /* columns = [
    { label: "Transaction Id", fieldName: "id", hideDefaultActions: true },
    {
      label: "Nom du produit",
      fieldName: "offerName",
      hideDefaultActions: true,
    },
    {
      label: "exchangeCode",
      fieldName: "exchangeCode",
      hideDefaultActions: true,
    },
   
  ];*/
  /*handleOpenModal(event) {
    console.log("selectedProduct: " + event.detail.selectedRows);
    this.selectedRow = null;
    if(event.detail.selectedRows=='undefined'){
      this.selected=false;
      //this.exchangecode='';
    }else{
      this.selected=true;
      const selectedRows = event.detail.selectedRows;
      this.selectedRow = selectedRows[selectedRows.length - 1];
      console.log(this.selectedRow);
      //this.exchangecode=this.selectedRow.exchangeCode;
      //console.log("transaction Id: " + this.selectedRow.id);
      }
    
    
    
  }*/
  getProducts = e => {
   // let date = this.formatDate();
    //let datestart = new Date(date);
   // datestart.setMonth(datestart.getMonth() + 3);
   console.log('mdn:',this.msisdn);
    let enddate = this.getFormattedDateWithAddedDay(1);
    this.loadingProduct = true;
    /* chb 04/07/2024 TTM B-17739 SF23-044_Refonte du programme de fidélité begin */
    //let input ='{"accountId": "' +this.accountid +'","endDate": "'+enddate+'","loyaltyTransaction": {"numberOfTransactions": 1,"status": 1},"offerType": 2,"specialAchouraOffer": "true","startDate": "2000-08-01","mdn": "' +this.msisdn +'"}';
    let input ='{"SubscriptionId": "'+this.subscriptionid+'","EndDate": "'+enddate+'","StartDate": "2000-08-01"}';
    /* chb 04/07/2024 TTM B-17739 SF23-044_Refonte du programme de fidélité end */
    // '{"accountId":"' +this.accountid +'","msisdn":"' +this.msisdn +'","offerType": "2","subsriptionId":"' +this.subscriptionid +'", "startDate": "'+datestart+'","endDate":"'+date+'" ,"specialAchouraOffer":true,"loyaltyTransaction":[{"numberOfTransactions":1,"status":1}]}';
    //'{"accountId":"' +this.accountid +'","subsriptionId":"' +this.subscriptionid +'","offerType": "2", "startDate": "2000-08-01" ,"endDate":"'+date+'","specialAchouraOffer":"true","loyaltyTransaction":{"numberOfTransactions":1,"status":1}}';
//valeur =1  (statut d’une commande initiée en attente de finalisation.)
    console.log("******* getProducts input **************", input);
     const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
       /* chb 04/07/2024 TTM B-17739 SF23-044_Refonte du programme de fidélité begin */
      //chb 10/09/2024 en seance Avec fatima EMAIL :RE: Refonte clubinwi - Statut d'avancement UAT
      sMethodName: "inwib2c_getClubRedeemsHistoryForOSFidelisation",
     //sMethodName: "inwib2c_getClubRedeemsHistory",
     // sMethodName: "inwib2c_getClubRedeemsHistoryForOS",
      //chb 10/09/2024 en seance Avec fatima EMAIL :RE: Refonte clubinwi - Statut d'avancement UAT
      
        /* chb 04/07/2024 TTM B-17739 SF23-044_Refonte du programme de fidélité end */
      options: "{}",
    };

    console.log("******* params **************", params);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (!response.error) {
            /* chb 04/07/2024 TTM B-17739 SF23-044_Refonte du programme de fidélité begin */
          let dataProducts = response.result.IPResult.result.loyaltyTransaction;
          console.log("******* this.dataProducts **************", dataProducts);
          this.dataProducts = dataProducts;
          this.loadingProduct = false;
          this.transactionid=response.result.IPResult.result.loyaltyTransaction[0].id;
          this.codearticle=response.result.IPResult.result.loyaltyTransaction[0].offer_subtype;
          this.offerName=response.result.IPResult.result.loyaltyTransaction[0].offerName;
          this.msisdn=response.result.IPResult.result.loyaltyTransaction[0].beneficiary_MSISDN;
          this.requestdate=response.result.IPResult.result.loyaltyTransaction[0].createdDate;
            /* chb 04/07/2024 TTM B-17739 SF23-044_Refonte du programme de fidélité end */
          const params2= {
            input: '{"CodeArticle":"'+this.codearticle+'"}',
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "inwib2c_CheckArticleSerialiseFidelisation",
            options: "{}",
          };  
          this._actionUtilClass
          .executeAction(params2, null, this, null, null)
          .then(response => {
            console.log(response);
            if (!response.error) {
             let IsSerialisable = response.result.IPResult.IsSerialisable;
             console.log('this.IsSerialisable: ',IsSerialisable);
             if(IsSerialisable){
              this.showIMEI=true;
             }
             }
            })
          
        }
        this.loadingProduct = false;
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
        this.loadingProduct = false;
      });

    console.log("******* 3 **************", input);
  
  };

  formatDate = () => {
    var d = new Date(),
      month = "" + (d.getMonth() + 1),
      day = "" + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2) month = "0" + month;
    if (day.length < 2) day = "0" + day;

    return [year, month, day].join("-");
  };
  getFormattedDateWithAddedDay = (daysToAdd) => {
    var currentDate = new Date();
    currentDate.setDate(currentDate.getDate() + daysToAdd);

    var month = "" + (currentDate.getMonth() + 1),
        day = "" + currentDate.getDate(),
        year = currentDate.getFullYear();

    if (month.length < 2) month = "0" + month;
    if (day.length < 2) day = "0" + day;

    return [year, month, day].join("-");
};

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    //this.showIMEI = this.imei == 1 || this.imei == "1";
    //this.showIMSI = this.imsi == 1 || this.imsi == "1";
    //this.showESN = this.esn == 1 || this.esn == "1";
    console.log("name", this.name);
   // console.log("imsi", this.imsi);
    //console.log("imei", this.imei, typeof this.imei);
   // console.log("esn", this.esn);
    console.log("districode", this.districode);
    console.log("poscode", this.poscode);
    //console.log("exchangecode", this.exchangecode);
    console.log("codearticle", this.codearticle);
    this.getProducts();
  }
  
  checkCode() {
    console.log('in checkCode');
    
    //if (this.showIMEI) {
      console.log('in checkCode2');
      let valSaisie = this.template.querySelector(`[data-theid="imei"]`).value;
      console.log('in valSaisie',valSaisie);
      if (valSaisie.length !== 15) {
        console.log('in checkCode +-15');
        const event = new ShowToastEvent({
          variant: "error",
          title: "Erreur",
          message: "Le IMEI que vous avez saisi est incorrecte !",
        });
        this.dispatchEvent(event);
      } //else {
        //let valCodeSaisie = this.template.querySelector(`[data-theid="code"]`)
        //  .value;
       /* if (valCodeSaisie !== this.exchangecode) {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message: "Le Code que vous avez saisi est incorrecte !",
          });
          this.dispatchEvent(event);
        } */else {
          this.omniUpdateDataJson({
            imei: valSaisie,
            transactionid:  this.transactionid,
            requestdate:this.requestdate,
            offernameSelected: this.offerName
          });
          let input =
            `
            {
              "handset": [
                  {
                      "code": "` +
            this.codearticle +
            `",
                      "serialNumber": "` +
            valSaisie +
            `",
            "type": "IMEI",
                      "quantity": "1"
                  }
              ],
              "operation": "RS",
              "username": "Djamel"
          }
            `;
          console.log(input);

          const params = {
            input: input,
            sClassName: `${this._ns}IntegrationProcedureService`,
            sMethodName: "Inwi_InwiB2C_LockArticle",
            options: "{}",
          };

          this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
              console.log(response);
              if (!response.error) {
                try {
                  if (
                    response.result.IPResult
                      .CSValidateLineAttributesInteraction[0].CSStoreChange[0]
                      .status == "1"
                  ) {
                    const event = new ShowToastEvent({
                      variant: "success",
                      title: "Succés",
                      message: "Le produit a été réservé avec succés !",
                    });
                    this.dispatchEvent(event);
                    // Go To Next Step
                    this.omniUpdateDataJson({
                      imei: valSaisie,
                      transactionid:  this.transactionid,
                      requestdate:this.requestdate,
                      offernameSelected: this.offerName,
                      codearticle:this.codearticle
                    });
                    this.omniNextStep();
                  } else {
                    const event = new ShowToastEvent({
                      variant: "error",
                      title: "Erreur",
                      message:
                        response.result.IPResult
                          .CSValidateLineAttributesInteraction[0]
                          .CSStoreChange[0].errorMessage,
                    });
                    this.dispatchEvent(event);
                  }
                } catch (error) {
                  const event = new ShowToastEvent({
                    variant: "error",
                    title: "Erreur",
                    message:
                      "Une erreur est survenue, veuillez réessayer plutard !",
                  });
                  this.dispatchEvent(event);
                }
              } else {
                const event = new ShowToastEvent({
                  variant: "error",
                  title: "Erreur",
                  message:
                    "Une erreur est survenue, veuillez réessayer plutard !",
                });
                this.dispatchEvent(event);
              }
            })
            .catch(error => {
              console.log("error");
              window.console.log(error);
            });
        }
      }//}
    
      NextStep(){
        this.omniUpdateDataJson({
          transactionid:  this.transactionid,
          requestdate:this.requestdate,
          offernameSelected: this.offerName,
          codearticle:this.codearticle
        });
        this.omniNextStep();
      }
      gotopreviousStep() {
             this.omniPrevStep();
     }
  resentCode() {}

  render() {
    return template;
  }
}