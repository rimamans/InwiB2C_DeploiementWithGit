import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwib2c_postpaid_cart_change_options.html";

export default class Inwib2c_postpaid_cart_change_options extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  __vlccart;
  __orderid;
  __data = [];
  __dataErrors = [];
  __offerSegement = "prépayé";
  //__updatedCart = [];
  __dataCart = [];
  __disableValidate = false;

  actionuser;
  actionnameuser;
  
  @api
  get vlccart() {
    return this.__vlccart;
  }
  set vlccart(value) {
    this.__vlccart = { ...value };
  }

  @api
  get orderid() {
    return this.__orderid;
  }
  set orderid(value) {
    this.__orderid = value ;
  }
  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.getMessages();
  }

  getMessages() {
    let __data = [];
    let oldCart = JSON.parse(JSON.stringify(this.vlccart));
    console.log(JSON.stringify(this.vlccart));

    if (oldCart.records && oldCart.records.length > 0) {
      const params = {
        input:
          '{"cartId":"' +
          this.__orderid +
          '","price":"false","validate":false}',
        sClassName: "vlocity_cmt.CpqAppHandler",
        sMethodName: "getCarts",
        options: "{}",
      };

      this._actionUtilClass
        .executeAction(params, null, this, null, null)
        .then((response) => {
          console.log("log cons postpaid");

          
          // eslint-disable-next-line no-unused-expressions
          oldCart.records &&
            oldCart.records.map((item, index) => {
              // eslint-disable-next-line no-unused-expressions
              response &&
                response.result &&
                response.result.messages.map((message) => {
                  console.log(message);
                  console.log((message.bundleId, item.Id.value));
                  if (message.bundleId && message.bundleId === item.Id.value) {
                    item.messages.push(message);
                    item.inwiB2C_Error = true;
                    this.__disableValidate = true;
                  }
                });
              this.__data.push(item);
              if (index + 1 == oldCart.records.length) this.updatedCart();
            });
        })
        .catch((error) => {
          console.log("showVars_error:: " + error);
        });
    }
  }

















  updatedCart() {
    let cart = [];
    let oldCart = JSON.parse(JSON.stringify(this.vlccart));
  console.log('oldCart:', oldCart);
    console.log("this.updatedCart");
    console.log(this.__data);
    let array = [];
    // eslint-disable-next-line no-unused-expressions
    this.__data &&
      this.__data.forEach(async (item, index) => {
        array = [];
        let item_index = 1;

 // get bill simulation
 // eslint-disable-next-line vars-on-top
 var datestring =
 new Date().getFullYear() +
 "-" +
 ("0" + (new Date().getMonth() + 1)).slice(-2) +
 "-" +
 ("0" + new Date().getDate()).slice(-2) +
 "T" +
 new Date().toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1") +
 "Z";
let input =
 `{
     "orderid": "` + item.OrderId.value + `",
     "activation_date": "` + datestring + `",
     "prix_forfait": ` + item.vlocity_cmt__RecurringCharge__c.value + `,
     "fms": ` + item.InwiB2C_FMS__c.value + `,
     "orderitemid": "` + item.Id.value + `"
       }`;

     console.log("input simulation facture------->");
     console.log(input);

          const response = await this.getfirstinvoice(input);
          let result = response.result.IPResult;
          let pourcentage = 0;
          pourcentage = parseFloat(parseFloat((result.prorata_period_amount * 100) / result.prix_forfait).toFixed(2));

          console.log('pourcentage:',pourcentage);
        // eslint-disable-next-line no-unused-expressions
        item.lineItems.records &&
          // eslint-disable-next-line array-callback-return
          item.lineItems.records.map((item2) => {
            // eslint-disable-next-line eqeqeq
            if (item2.name == "Options") {
              // eslint-disable-next-line no-unused-expressions
              item2.lineItems &&
                item2.lineItems.records.map((item3) => {
                  if (
                    // eslint-disable-next-line eqeqeq
                    (item3.action == "Add" || item3.action == "Change") &&
                    (item3.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                      item3.vlocity_cmt__RecurringCharge__c.value >= 0)
                  ) {
                    item3.index = item_index;
                    item3.useraction =
                      // eslint-disable-next-line eqeqeq
                      item3.action == "Add"
                        ? "Activation"
                        // eslint-disable-next-line eqeqeq
                        : item3.action == "Change"
                        ? "Modification"
                        : "Désactivation";
                    item_index++;
                    item3.itemname = item3.name;
                    // item3.price =
                    //     item3.vlocity_cmt__RecurringCharge__c &&
                    //         item3.vlocity_cmt__RecurringCharge__c.value
                    //         ? item3.vlocity_cmt__RecurringCharge__c.value
                    //         : 0;

                    item3.price = 0;

                    // item3.next_bill =
                    //   item3.vlocity_cmt__RecurringCharge__c &&
                    //   item3.vlocity_cmt__RecurringCharge__c.value
                    //     ? item3.vlocity_cmt__RecurringCharge__c.value * 2
                    //     : 0;

                    item3.option_price =
                      item3.vlocity_cmt__RecurringCharge__c &&
                      item3.vlocity_cmt__RecurringCharge__c.value
                        ? item3.vlocity_cmt__RecurringCharge__c.value
                        : 0;

                let recurring_price = item3.vlocity_cmt__RecurringCharge__c &&
                        item3.vlocity_cmt__RecurringCharge__c.value
                        ? item3.vlocity_cmt__RecurringCharge__c.value *2
                        : 0;   
                        
                        
              console.log('recurring_price:', recurring_price);
                // eslint-disable-next-line eqeqeq
        
               console.log('InwiB2C_Prorat_e__c:',item3.Product2.InwiB2C_Prorat_e__c );
             let is_option_prorata = result.status === "1" && (result.prix_forfait === 49 || result.prix_forfait === 99) && item3.Product2.InwiB2C_Prorat_e__c && item3.Product2.InwiB2C_Prorat_e__c === "Oui" ? 1 : 0;

                // let is_option_prorata = result.status == "1" && (result.prix_forfait === 49 || result.prix_forfait === 99) && result.IsProrate == "Oui" ? 1 : 0;
       
                console.log('InwiB2C_Prorat_e__c:',item3.Product2.InwiB2C_Prorat_e__c );
                console.log('is_option_prorata:',is_option_prorata );
             
                item3.next_bill = recurring_price + parseFloat(parseFloat((is_option_prorata * recurring_price * pourcentage) / 100).toFixed(2));

                 console.log('next_bill:', item3.next_bill);

                array.push(item3);

                  } else if (item3.action === "Disconnect") {
                    this.actionuser = "Désactivation";
                    this.actionnameuser = item3.name;
                  }
                });
            }
          });
        console.log("Call this.sortarray(array, index)");
        let sortedArray = this.sortarray(array, index + 1);
        this.__dataCart = this.__dataCart.concat(sortedArray);
        console.log("lenghts", index + 1, this.__data.length);
      });
  }


 //  call VIP invoice simulation p
  async getfirstinvoice(input) {
    console.log("call vip getfirstinvoice")
    const params = {
      input,
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_invoice_simulation",
      options: "{}",
    };

    return this._actionUtilClass
      .executeAction(params, null, this, null, null);
  }


  sortarray(items, index) {
    let array = items;
    array.sort(function(a, b) {
      return a.index - b.index;
    });
    return array;
  }

  get __updatedCart() {
    console.log("******************Global ***************");
    if (this.__dataCart && this.__dataCart.length > 0) {
      let data = [];
      let totalprice = 0;
      let totalnext_bill = 0;
      let totaloption_price = 0;
      this.__dataCart.map(async (item) => {
        data.push(item);
        totalprice = totalprice + item.price;
        totalnext_bill = totalnext_bill + item.next_bill;
        totaloption_price = totaloption_price + item.option_price;
      });
      data.push({
        index: 100,
        itemname: "Total global",
        price: totalprice,
        next_bill: totalnext_bill,
        option_price: totaloption_price,
        styleColor: "background-color: #A846A9; color: white;",
      });
      return data;
    } else return [];
  }

  gotoprecedentstep() {
    console.log('this.__orderid'+this.__orderid);
    const inputParams = {
      cartId: this.__orderid,
      fields:
      "vlocity_cmt__BillingAccountId__c,vlocity_cmt__ServiceAccountId__c,Quantity,vlocity_cmt__RecurringTotal__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__OneTimeCharge__c,ListPrice,vlocity_cmt__ParentItemId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__PremisesId__r.Name,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__EffectiveQuantity__c,Product2.INWIB2C_visibilit_options__c,Product2.vlocity_cmt__SpecificationType__c,Product2.Name,Product2.vlocity_cmt__SellingEndDate__c,vlocity_cmt__Product2Id__r.Family,Product2.InwiB2C_Type_offre__c,Product2.vlocity_cmt__Type__c,Product2.InwiB2C_Type_offre__c",  
      validate: false,
      price: false,
    };

    const params = {
      input: JSON.stringify(inputParams),
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "getCartsItems",
      options: "{}",
    };

    console.log("before call getCartsItems");

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log("correction anos" + response);
        let myData = {
          restart: false,
          vlcCart: JSON.parse(JSON.stringify(response.result)),
        };

        this.omniApplyCallResp(myData);
        this.omniNavigateTo("ModificationAttOptions");
      })
      .catch((error) => {
        window.console.log(error);
      });
  }

  selectItem(event) {
    let myData = {
      restart: false,
    };

    this.omniApplyCallResp(myData);
    this.omniNavigateTo("ModificationAttOptions");
  }

  get hasErrors() {
    let error = false;
    if (this.vlccart && this.vlccart.records) {
      this.vlccart.records.forEach((item) => {
        if (item.messages) {
          item.messages.forEach((message) => {
            if (message && message.severity && message.severity == "ERROR") {
              error = error || true;
            }
          });
        }
      });
    }
    return error;
  }

  get validateDisabled() {
    if (this.vlccart && this.vlccart.records) {
      return this.hasErrors || this.vlccart.records.length == 0;
    } else return true;
  }

  deleteItem(event) {
    console.log("Delete Item");
    console.log(JSON.stringify(event.target.name));

    let item = event.target.name;

    let apexParams = JSON.stringify(item.actions.deleteitem.remote.params);
    let cartId = item.actions.deleteitem.remote.params.cartId;
    console.log("apexarams");
    console.log(apexParams);
    const params = {
      input: apexParams,
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "deleteCartsItems",
      options: "{}",
    };
    console.log("button supp clicked");

    console.log(params);

    this.dispatchEvent(
      new ShowToastEvent({
        title: "Suppression",
        message: "Suppression de " + item.Name,
        variant: "info",
      })
    );

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then((response) => {
        console.log(response);
        this.getCart(cartId);
      })
      .catch((error) => {
        window.console.log(error);
      });
  }

  SaveAndNext(evt) {
    console.log(JSON.stringify(this.__updatedCart));
    let modifiedList = {};
    if (this.__updatedCart.length === 2) {
      this.__updatedCart.map((item) => {
        if (item.index !== 100) {
          this.actionuser = item.useraction;
          this.actionnameuser = item.itemname;
        }
      });
    }

    console.log((modifiedList = ""));
    this.omniApplyCallResp({
      actionuser: this.actionuser,
      actionnameuser: this.actionnameuser,
    });
    this.omniNextStep();
  }

  gotopreviousStep() {
    this.omniPrevStep();
  }

  render() {
    return template;
  }
}