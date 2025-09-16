import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

import template from "./inwiB2C_DisplayFidelisationProducts.html";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class InwiB2C_DisplayFidelisationProducts extends OmniscriptBaseMixin(
  LightningElement
) {
  __produits;

  isCodeOk = false;
  isModalOpen = false;
  loadingProduct = false;
  selectedRow = null;
  isMemberClub = false;
  disableButton = false;
  dataProducts = [];
  @api secretcode;
  @api msisdn;
  @api accountid;
  @api ismember;
  @api poscode;
  @api sysdatevar;
  imei;
  @api souscriptionid;
  @api
  get produits() {
    return this.__produits;
  }
  set produits(value) {
    this.__produits = value;
  }

  columns = [
    {
      label: "Nom du produit",
      fieldName: "name",
      hideDefaultActions: true,
    },
    {
      label: "Description",
      fieldName: "description",
      hideDefaultActions: true,
    },
    { label: "Groupe", fieldName: "group", hideDefaultActions: true },
  ];

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    console.log(this.poscode, typeof this.poscode);
    this.isMemberClub = this.ismember ? true : false;
    if (this.isMemberClub) this.getProducts();
  }

  // S'inscrire au club INWI
  inscriptionClub(event) {
    this.disableButton = true;

    let input =
      `{
      "accountId":  "` +
      this.accountid +
      `",
      "mdn":  "` +
      this.msisdn +
      `",
      "status": 1
    }`;

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwiB2C_updateClubINWIStatus",
      options: "{}",
    };
    console.log("inscriptionClub ", input);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (response.result && response.result.IPResult && response.result.IPResult.success) {
          this.disableButton = false;
          this.isMemberClub = true;
          this.getProducts();
        } else {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message: "Une erreur est survenue. veuillez réessayer (API updateClubINWIStatus) !",
          });
          this.dispatchEvent(event);
        }
        // this.isMemberClub = true;
        // this.getProducts();
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
      });
  }

  // Confirmer produit et initialiser une commande
 /* getSelectedName(event) { #### a enlever CHB
    let input =
      `{
      "accountId":   "` +
      this.accountid +
      `",
      "msisdn":  "` +
      this.msisdn +
      `",
      "offerID": ` +
      this.selectedRow.offerId +
      `,
      "campaignCode": "7676767"
    }`;

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_RetreiveClubCampaignGift",
      options: "{}",
    };

    console.log("input code", input);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (
          response.result &&
          response.result.IPResult &&
          response.result.IPResult.loyaltyTransaction &&
          response.result.IPResult.loyaltyTransaction[0].status == "1"
        ) {
          this.omniUpdateDataJson({
            selectedProduct: this.selectedRow,
            loyaltyTransaction:
              response.result.IPResult.loyaltyTransaction[0].status,
          });
          this.omniNextStep();
        } else {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message:
              "Une erreur est survenue. veuillez réessayer (API RetreiveClubCampaignGift) !",
          });
          this.dispatchEvent(event);
        }
        // const loyaltyTransaction = {
        //   exchangeCode: "12345",
        //   id: "6688",
        //   quantity: 0,
        //   reasonCode: 0,
        //   reasonText: "",
        //   status: 1,
        //   type: 0,
        // };

        // this.omniUpdateDataJson({
        //   selectedProduct: this.selectedRow,
        //   loyaltyTransaction,
        // });
        // this.omniNextStep();
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
      });

    // const loyaltyTransaction = {
    //   exchangeCode: "",
    //   id: "6688",
    //   quantity: 0,
    //   reasonCode: 0,
    //   reasonText: "",
    //   status: 1,
    //   type: 0,
    // };

    // this.omniUpdateDataJson({
    //   selectedProduct: this.selectedRow,
    //   loyaltyTransaction,
    // });
    // this.omniNextStep();
  }
*/
//CHB 04/12/2023
getSelectedName(event){//create Order RQ-0069 
  // `+this.+`
  var newDate = new Date(); 
  var now = newDate.toISOString().replace('Z', '').replace('T', ' ');
  let offerOrderTypeVar=this.selectedRow.category=="Physical"?"redeemPhysical":"redeemNonPhysical";
  console.log('offerOrderTypeVar',offerOrderTypeVar);      
  let input =
    /*'{"offerOrderType":"'+offerOrderTypeVar+'","requestDate":"' +this.sysdatevar +'","billingAccount":"' +this.accountid +'","store":"' +this.poscode +'","offerId":"' +this.selectedRow.id+'","quantity":"1","msisdn":"' +
    this.msisdn +'","freeText":"'+this.selectedRow.description+'","externalOrderRef":"PRM00365887","pickUpStore":"' +this.poscode +'","pickUpDate":"' +this.sysdatevar +'","formRef":"","imei":"' +this.selectedRow.withIMEI +'","esn":"'+this.selectedRow.withESN+'","imsi":"'+this.selectedRow.withIMSI+'","mcAllow":true,"reengagementType":"0","autoComplete":true,"overdraftAllow":0,"bonusPoints":0,"generateExchangeCode":true}';
 */
    '{"offerOrderType":"'+offerOrderTypeVar+'","requestDate":"' +this.sysdatevar +'","billingAccount":"' +this.accountid +'","store":"' +this.poscode +'","offerId":"' +this.selectedRow.id+'","quantity":"1","msisdn":"' +
    this.msisdn +'","pickUpDate":"' +this.sysdatevar +'","freeText":"'+this.selectedRow.description+'","externalOrderRef":"","formRef":"","imei":"' +this.selectedRow.withIMEI +'","esn":"'+this.selectedRow.withESN+'","imsi":"'+this.selectedRow.withIMSI+'","mcAllow":true,"reengagementType":"0","autoComplete":true,"overdraftAllow":0,"bonusPoints":0,"generateExchangeCode":true}';
  
console.log(input);

  const params = {
    input: input,
    sClassName: `${this._ns}IntegrationProcedureService`,
    sMethodName: "Inwi_BurnLoyaltyPoint",
    options: "{}",
  };

  this._actionUtilClass
    .executeAction(params, null, this, null, null)
    .then(response => {
      console.log(response);
      if (!response.error) {
        try {
          if (response.result.IPResult.transactionId) {
            const event = new ShowToastEvent({
              variant: "success",
              title: "Succés",
              message: "Le commande a été enregistré avec succès !!",
            });
            this.dispatchEvent(event);
            // Go To Next Step
            this.omniUpdateDataJson({
              transactionid: response.result.IPResult.transactionId,
            });
            const params1 = {
              input: {},
              sClassName: 'InwiB2C_OperationHistory',
              sMethodName: 'AddOperationHistory',
              options: '{"SubscriptionId":"'+this.souscriptionid+'","ActionOperation": "Fidelisation","Mdn":"'+this.msisdn+'" ,"ShowIMEI":"'+this.selectedRow.withIMEI+'","transactionId":"'+response.result.IPResult.transactionId+'","SousProduitIN":"'+this.selectedRow.subType+'","BillingAccount":"'+this.accountid+'","StatutOperation":"OK","Canal":"Point de vente","SubActionOperation":"Initialisation" ,"produit":"'+this.selectedRow.name+'","category":"'+this.selectedRow.category+'","Description":"'+this.selectedRow.group+'"}'
          };
          console.log('params1',params1);
          this._actionUtilClass
              .executeAction(params1, null, this, null, null)
              .then(response => {
                  console.log('Success row inserted');  
                  console.log(response)  ;
  
              })
              .catch(error => {
                  window.console.log(error);
              });
            this.omniNextStep();
          } else {
            const event = new ShowToastEvent({
              variant: "error",
              title: "Erreur",
              message: 'Erreur rencontrée lors de l\'initialisation de la commande: '+response.result.IPResult.result.message ,
            });
            this.dispatchEvent(event);
          }
        } catch (error) {
          const event = new ShowToastEvent({
            variant: "error",
            title: "Erreur",
            message: "Une erreur est survenue, veuillez réessayer plutard !",
          });
          this.dispatchEvent(event);
          }
      } /*else {
        const event = new ShowToastEvent({
          variant: "error",
          title: "Erreur",
          message: "Une erreur est survenue, veuillez réessayer plutard !",
        });
        this.dispatchEvent(event);
      }*/
    })
    .catch(error => {
      console.log("error");
      window.console.log(error);
    });


}
  checkCode(event) {
    let valSaisie = this.template.querySelector(`[data-theid="code"]`).value;
    // console.log("valSaisie: " + valSaisie);
    // console.log("this.secretcode: " + this.secretcode);
    this.isCodeOk = valSaisie == "12345" ? true : false;
    this.getProducts(event);

    // let input =
    //   `{
    //   accountId:  ` +
    //   this.accountid +
    //   `,
    //   msisdn:  ` +
    //   this.msisdn +
    //   `,
    //   subsriptionId: "INS767675765765",
    //   offerType: "3",
    //   startDate: "2000-08-01",
    //   endDate: "2021-03-23",
    //   specialAchouraOffer: "true",
    //   loyaltyTransaction: {
    //     numberOfTransactions: 1,
    //     status: 2,
    //   },
    // }`;

    // const params = {
    //   input: input,
    //   sClassName: `${this._ns}IntegrationProcedureService`,
    //   sMethodName: "inwib2c_INWIB2C_retrieveClubRedeemsHistory",
    //   options: "{}",
    // };

    // this._actionUtilClass
    //   .executeAction(params, null, this, null, null)
    //   .then(response => {
    //     console.log(response);
    //     if (
    //       response.loyaltyTransaction &&
    //       response.loyaltyTransaction.status == 1
    //     ) {
    //       this.isCodeOk =
    //         valSaisie == response.loyaltyTransaction.exchangeCode
    //           ? true
    //           : false;
    //       this.getProducts();
    //     } else {
    //       const event = new ShowToastEvent({
    //         variant: "error",
    //         title: "Erreur",
    //         message: "Le code que vous avez saisi est incorrecte !",
    //       });
    //       this.dispatchEvent(event);
    //     }
    //   })
    //   .catch(error => {
    //     console.log("error");
    //     window.console.log(error);
    //   });
  }

  //
  getProducts = e => {
    let date = this.formatDate();

    this.loadingProduct = true;
    let input =
     // '{"accountId":   "' +this.accountid +'","msisdn":  "' +this.msisdn +'","offerOrderType": "1","store":"' +this.poscode +'","requestDate":"2023-10-16"}';
     '{"accountId":"' +this.accountid +'","mdn":"' +this.msisdn +'","offerOrderType": "2","store":"' +this.poscode +'","requestDate":"'+date+'" ,"profile":[{"id":"1","name":"","type":"0"}]}';

    console.log("******* getProducts input **************", input);

    const params = {
      input: input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_retrieveClubValidOffers",
      options: "{}",
    };

    console.log("******* params **************", params);

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (!response.error) {
          let dataProducts = response.result.IPResult.loyaltyOffer;
          console.log("******* this.dataProducts **************", dataProducts);
          this.loadingProduct = false;
          this.dataProducts = dataProducts;
          let category=response.result.IPResult.loyaltyOffer[0].category;
          this.omniUpdateDataJson({ "offerCategory":  category });
          //this.imei=response.result.IPResult.loyaltyOffer[0].withIMEI;
        }
        this.loadingProduct = false;
      })
      .catch(error => {
        console.log("error");
        window.console.log(error);
        this.loadingProduct = false;
      });

    console.log("******* 3 **************", input);

    // this.dataProducts = [
    //   {
    //     offerCategory: "Non  Physical",
    //     offerDescription: "SMS 24",
    //     offerEligibleAccountCategory: 0,
    //     offerEligibleAccountSegment: 0,
    //     offerEligibleSubscriptions: "",
    //     offerGroup: "B2B SMS GIFT",
    //     offerId: 1817940,
    //     offerName: "SMS 24",
    //     offerSubtype: "659926",
    //     offerSystem: 0,
    //     offerType: "DR non physique",
    //     offerValidFrom: "2013-03-27",
    //     offerValidTo: "2021-12-20",
    //     offerWithESN: 0,
    //     offerWithIMEI: 0,
    //     offerWithIMSI: 0,
    //   },
    // ];
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

  // Show Confirm Modal
  handleOpenModal(event) {
    console.log("selectedProduct: " + event.detail.selectedRows);
    this.selectedRow = null;
    const selectedRows = event.detail.selectedRows;
    this.selectedRow = selectedRows[selectedRows.length - 1];
    console.log(this.selectedRow);
    if (this.selectedRow) {
      this.isModalOpen = true;
    }
    console.log("selectedProduct: " + this.selectedRow.name);
  }

  handleCloseModal(event) {
    this.isModalOpen = false;
  }

  render() {
    return template;
  }
}