import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";


import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwiB2C_panier_Migration.html";


export default class InwiB2C_panier_Migration extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {


  __fraiadd;
  __vlccart;
  isModalOpen = false;
  __displayErrors = false;
  __recap = false;
  __typerecap = "ACQ";
  __orderid;
  __data = [];
  __dataErrors = [];
  __offerSegement = "prépayé";
  __family;
  //__updatedCart = [];
  __dataCart = [];
  __disableValidate = false;
  __userprofile;
  __offrecameleon;





  // simulation facture var
  __cf_exist = false;
  isModalOpenBill = false;
  dataBill = [];
  selectedBill = {};

  @api
  get fraiadd() {
    return this.__fraiadd;
  }
  set fraiadd(value) {
    this.__fraiadd = value;
  }



  @api
  get cf_exist() {
    return this.__cf_exist;
  }
  set cf_exist(value) {
    this.__cf_exist = value ? true : false;
  }

  @api
  get orderid() {
    return this.__orderid;
  }
  set orderid(value) {
    this.__orderid = value;
  }

  @api
  get userprofile() {
    return this.__userprofile;
  }
  set userprofile(value) {
    this.__userprofile = value;
  }

  @api
  get vlccart() {
    return this.__vlccart;
  }
  set vlccart(value) {
    this.__vlccart = { ...value };
  }

  @api
  get displayErrors() {
    return this.__displayErrors;
  }
  set displayErrors(value) {
    this.__displayErrors = value;
  }

  @api
  get recap() {
    return this.__recap;
  }
  set recap(value) {
    this.__recap = value;
  }

  @api
  get typerecap() {
    console.log("typerecap : " + this.__typerecap);
    return this.__typerecap;
  }
  set typerecap(value) {
    this.__typerecap = value;
  }

  @api
  get family() {
    return this.__family;
  }
  set family(value) {
    this.__family = value;
  }
  
  @api
  get offrecameleon() {
    return this.__offrecameleon;
  }
  set offrecameleon(value) {
    this.__offrecameleon = value;
  }

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.getMessages();
    console.log('fraisdemigration : ' + this.__fraiadd);
  }

  getMessages() {
    let __data = [];
    let oldCart = JSON.parse(JSON.stringify(this.vlccart));
    console.log('__iscameleon: ' + this.__offrecameleon);
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
        .then(response => {
          console.log("log cons postpaid");

          oldCart.records &&
            oldCart.records.map((item, index) => {
              response &&
                response.result &&
                response.result.messages.map(message => {
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
        .catch(error => {
          console.log("showVars_error:: " + error);
        });
    }
  }

  updatedCart() {
    let cart = [];
    // let oldCart = JSON.parse(JSON.stringify(this.vlccart));
    console.log("this.updatedCart");
    console.log(this.__data);
    let array = [];
    this.__data &&
      this.__data.forEach(async (item, index) => {
        if (item.vlocity_cmt__Action__c.value != "Disconnect") {
          let promotions = [];
          // get promotions
          const params2 = {
            input: '{ "orderId":"' + item.OrderId.value + '" }',
            sClassName: 'inwib2c_promotion_functions',
            sMethodName: 'getAppliedPromotionsForCart',
            options: '{}',
          };
          this._actionUtilClass
            .executeAction(params2, null, this, null, null)
            .then(responsepromotion => {
              console.log("getAppliedPromotionsForCart");
              console.log(responsepromotion);
              if (!responsepromotion.error && responsepromotion.result && responsepromotion.result.promotions) {
                promotions = responsepromotion.result.promotions;
              }

              console.log(item);
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
            
            "orderitemid": "` + item.Id.value + `"
              }`;

              console.log("input simulation facture------->");
              console.log(input);

              const params = {
                input: input,
                sClassName: `${this._ns}IntegrationProcedureService`,
                sMethodName: "inwib2c_inwib2c_invoice_simulation",
                options: "{}",
              };

              this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                  console.log("callInvoiceSimulation");
                  console.log(response);
                  let result = response.result.IPResult;
                  if (result.status == "1") {
                    item.data_simulation = response.result.IPResult;
                    item.data_simulation.offer = item.Name;
                    let vipinput = {
                      orderid: item.OrderId.value,
                      activation_date: datestring,
                      prix_forfait: item.vlocity_cmt__RecurringPrice__c,
                      orderitemid: item.Id.value,
                    }
                    item.data_simulation.vipinput = vipinput;
                    console.log("------------- item databill---------"),
                      console.log(item.data_simulation)
                    this.dataBill.push(item.data_simulation);
                  }
                  array = [];
                  item.index = 1;
                  // set promotion
                  if (promotions.length > 0) {
                    promotions.map(itempromotion => {
                      if (itempromotion.orderItemId__c === item.Id.value) {
                        item.promotion = itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c;
                      }
                    })
                  }
                  item.itemname = item.Name;
                  item.price = item.vlocity_cmt__OneTimeCharge__c.value;
                  item.price_abonnement =
                    item.ListPrice.value;
                  item.has_error_messages = item.messages && item.messages.length > 0;
                  item.price_first_bill =
                    item.vlocity_cmt__RecurringCharge__c.value;
                  array.push(item);
                  //Frai Add migration
                  if (this.__offrecameleon == true) {
                    array.push({
                      itemname: "Frais additionnels",
                      index: 2,
                      price: this.__fraiadd,
                      price_abonnement: 0,
                      price_first_bill: 0,
                    });
                  } else {
                    array.push({
                      itemname: "Frais additionnels",
                      index: 2,
                      price: 0,
                      price_abonnement: 0,
                      price_first_bill: this.__fraiadd,
                    });
                  }


                  // FMS & FMD

                  /* array.push({
                     itemname: "FMS",
                     index: 2,
                     price:
                       item.InwiB2C_FMS__c && item.InwiB2C_FMS__c.value
                         ? item.InwiB2C_FMS__c.value
                         : 0,
                     price_abonnement: 0,
                   });
                   array.push({
                     itemname: "FMD",
                     index: 3,
                     price:
                       item.InwiB2C_FMD__c && item.InwiB2C_FMD__c.value
                         ? item.InwiB2C_FMD__c.value
                         : 0,
                     price_abonnement: 0,
                   });
                   array.push({
                     itemname: "Prorata premiere facture",
                     index: 4,
                     price: 0,
                     price_abonnement: 0,
                     price_first_bill:
                       result.status == "1" ? result.prorata_period_amount : "",
                   });*/

                  let item_index = 5;
                  item.lineItems.records &&
                    item.lineItems.records.map(item2 => {
                      if (
                        item2.name !== "Options" &&
                        (item2.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                          item2.vlocity_cmt__RecurringCharge__c.value > 0)
                      ) {
                        item2.index = item_index;
                        item_index++;
                        item2.price =
                          item2.vlocity_cmt__OneTimeCharge__c.value;
                        item2.price_abonnement =
                          item2.vlocity_cmt__RecurringCharge__c.value;
                        item2.itemname = item2.name;
                        //array.push(item2);
                      } else if (item2.name == "Options") {
                        item2.lineItems && item2.lineItems.records.map(item3 => {
                          if (
                            item3.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                            item3.vlocity_cmt__RecurringCharge__c.value > 0
                          ) {
                            item3.index = item_index;
                            item_index++;
                            item3.itemname = item3.name;
                            item3.price =
                              item3.vlocity_cmt__OneTimeCharge__c &&
                                item3.vlocity_cmt__OneTimeCharge__c.value
                                ? item3.vlocity_cmt__OneTimeCharge__c.value
                                : 0;
                            item3.price_abonnement =
                              item3.vlocity_cmt__RecurringCharge__c &&
                                item3.vlocity_cmt__RecurringCharge__c.value
                                ? item3.vlocity_cmt__RecurringCharge__c.value
                                : 0;
                            // array.push(item3);
                          }
                        });
                      }
                    });
                  console.log("Call this.sortarray(array, index)");
                  let sortedArray = this.sortarray(array, index + 1);
                  this.__dataCart = this.__dataCart.concat(sortedArray);
                  console.log("lenghts", index + 1, this.__data.length);
                  //if ((index + 1) == this.__data.length) this.setGlobalTotal();
                })
                .catch(error => {
                  console.log("error");
                  window.console.log(error);
                });

            })
            .catch(error => {
              window.console.log(error);
            });
          // end get promotions
        }
      });
  }

  sortarray(items, index) {
    let forfaitItem = {
      index: 0,
      styleColor: "background-color: #D9D9D9;",
      isparent: true,
    };
    let totalprice = 0;
    let totalpriceabonnement = 0;
    let totalpricefature = 0;
    items.map(item => {
      if (item.index == 1) {
        forfaitItem.itemname = "Total " + item.itemname;
        forfaitItem.parent = item;

      }
      totalpricefature = item.price_first_bill
        ? totalpricefature + item.price_first_bill
        : totalpricefature;
      totalprice = totalprice + item.price;
      totalpriceabonnement = totalpriceabonnement + item.price_abonnement;

    });
    forfaitItem.price = totalprice;
    forfaitItem.price_abonnement = totalpriceabonnement;
    forfaitItem.price_first_bill = totalpricefature;

    let array = [forfaitItem].concat(items);

    array.sort(function (a, b) {
      return a.index - b.index;
    });
    return array;
    // let data = [...this.updatedCart];
    // data.push(array);
    // this.__updatedCart = data;

    // if (data.length == this.__data.length) this.setGlobalTotal();
  }

  get __updatedCart() {
    console.log("******************Global ***************");
    if (this.__dataCart && this.__dataCart.length > 0) {
      let data = [];
      let totalprice = 0;
      let totalpriceabonnement = 0;
      let totalpricefature = 0;
      this.__dataCart.map(async item => {
        if (item.index != 100) {
          data.push(item);
        }
        if (item.index == 0) {
          totalprice = totalprice + item.price;
          totalpriceabonnement = totalpriceabonnement + item.price_abonnement;
          totalpricefature = item.price_first_bill
            ? totalpricefature + item.price_first_bill
            : totalpricefature;
        }
      });
      data.push({
        index: 100,
        itemname: "Total global",
        price: totalprice,
        price_first_bill: totalpricefature,
        price_abonnement: totalpriceabonnement,
        styleColor: "background-color: #A846A9; color: white;",
      });
      return data;
    } else return [];

  }

  print(event) {
    let item = event.target.name;
    let simulation = item.data_simulation;

    // cycle first day
    let text = simulation.activation_date;
    text = text.substring(0, 10);
    text =
      text.substring(6) +
      "-" +
      text.substring(3, 5) +
      "-" +
      text.substring(0, 2);

    var date = new Date(text);
    date.setDate(date.getDate() + simulation.prorata_period);

    const firstdaycycle =
      ("0" + date.getDate()).slice(-2) +
      "/" +
      ("0" + (date.getMonth() + 1)).slice(-2) +
      "/" +
      date.getFullYear();

    // secondbill
    var datedf = date;
    console.log("datedf");
    datedf.setMonth(datedf.getMonth() + 1);
    const secondbill =
      ("0" + datedf.getDate()).slice(-2) +
      "/" +
      ("0" + (datedf.getMonth() + 1)).slice(-2) +
      "/" +
      datedf.getFullYear();

    // periodfactureedf
    var dateau = datedf;
    dateau.setDate(dateau.getDate() - 1);
    const periodfactureedf =
      ("0" + dateau.getDate()).slice(-2) +
      "/" +
      ("0" + (dateau.getMonth() + 1)).slice(-2) +
      "/" +
      dateau.getFullYear();

    event.stopPropagation();
    this.selectedBill = {
      numligne: simulation.numligne,
      clientname: simulation.clientname,
      periodfactureedd: simulation.activation_date.substring(0, 10),
      periodfactureedf: periodfactureedf,
      offer: item.Name,
      activationdate: simulation.activation_date.substring(0, 10),
      firstdaycycle: firstdaycycle,
      secondbill: secondbill,
      days: simulation.prorata_period,
      priceprorata: simulation.prorata_period_amount,
      pricefirstmonth: simulation.prix_forfait,
      total: simulation.fstinvoice_amount,
    };

    this.isModalOpenBill = true;
    console.log(this.dataBill);

  }

  closeModalBill() {
    this.isModalOpenBill = false;
  }

  getCart(cartId) {
    const inputParams = {
      cartId: cartId,
      methodName: "getCartsItems",
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
      .then(response => {
        console.log(response);
        if (!response.error) {
          //console.log(JSON.stringify(response));

          this.vlccart = JSON.parse(JSON.stringify(response.result));
          this.getMessages();
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "Success",
              variant: "success",
            })
          );
        } else {

          this.dispatchEvent(
            new ShowToastEvent({
              title: "Erreur",
              message: "Erreur lors de la mise à jour",
              variant: "error",
            })
          );
        }
      })
      .catch(error => {
        window.console.log(error);
      });
  }

  selectItem(event) {
    console.log("Select Item");
    console.log(this.__data);
    console.log(JSON.stringify(event.target.name));
    let selected = {};
    this.__data.map(item => {
      if (item.Id.value == event.target.name.Id.value) selected = item;
    });
    console.log("selected---");
    console.log(selected);
    let items = {};
    items.records = [];
    items.records.push(selected);

    let myData = {
      currentItem: items,
      restart: false,
    };

    console.log("recap: " + this.recap);

    this.omniApplyCallResp(myData);
    this.omniNavigateTo("Options");
  }

  get hasErrors() {
    let error = false;
    if (this.vlccart && this.vlccart.records) {
      this.vlccart.records.forEach(item => {
        if (item.messages) {
          item.messages.forEach(message => {
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
      .then(response => {
        console.log(response);
        this.getCart(cartId);
      })
      .catch(error => {
        window.console.log(error);
      });
  }

  openModal(event) {
    // to open modal set isModalOpen tarck value as true
    this.isModalOpen = true;
    var selected = event.target.name;
    this.__dataErrors = selected.messages;
    console.log(selected);
    console.log("this.__dataErrors");
    console.log(this.__dataErrors);
  }
  closeModal() {
    // to close modal set isModalOpen tarck value as false
    this.isModalOpen = false;
  }
  submitDetails() {
    // to close modal set isModalOpen tarck value as false
    //Add your code to call apex method or do some processing
    this.isModalOpen = false;
  }

  get cartTotalAmount() {
    let total = 0;

    if (this.vlccart.records) {
      this.vlccart.records.forEach(item => {
        total += item.vlocity_cmt__OneTimeTotal__c.value;
      });
    }

    return total;
  }

  addProduct(evt) {
    console.log("family" + this.__family);

    if (this.__family != null) {
      if (
        this.__family.includes("postpayé") ||
        this.__family.includes("Postpayé")
      )
        this.__offerSegement = "postpayé";
      //else
      //  if(this.__family.includes("Mobile") || this.__family.includes("mobile")|| this.__family.includes("Home") || this.__family.includes("home"))
      //     this.__offerSegement ='prépayé';
    }

    let myData = {
      currentItem: null,
      restart: false,
      offerSegement: this.__offerSegement,
    };

    this.omniApplyCallResp(myData);

    this.omniNavigateTo("SetOrderStepFamilyChoice");
  }

  SaveAndNext(evt) {
    let myData = {
      currentItem: null,
      restart: false,
      dataBill: this.dataBill,
    };

    this.omniApplyCallResp(myData);

    this.omniNextStep();
  }

  get cartTotalAmount() {
    let total = 0;

    if (this.vlccart.records) {
      this.vlccart.records.forEach(item => {
        total += item.vlocity_cmt__EffectiveOneTimeTotal__c.value;
      });
    }

    return total;
  }

  render() {
    return template;
  }

  name(params) {
    let players = [1, 2, 3, 4];
    Promise.all(players.forEach(async (player) => {
      let value = await givePrizeToPlayer(player);
    }));
  }

  givePrizeToPlayer(params) {
    return params * 10;
  }
}