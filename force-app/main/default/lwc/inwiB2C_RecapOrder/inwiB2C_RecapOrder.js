import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwiB2C_RecapOrder.html";

export default class inwiB2C_RecapOrder extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
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

  // simulation facture var
  __cf_exist = false;
  isModalOpenBill = false;
  dataBill = [];
  selectedBill = {};

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

  get isLivraison() {
    return this.typerecap === "LIVR";
  }

  @api
  get family() {
    return this.__family;
  }
  set family(value) {
    this.__family = value;
  }

  __actegestion;
  @api
  get actegestion() {
    return this.__actegestion;
  }
  set actegestion(value) {
    this.__actegestion = value;
  }


  get isChangementOption() {
    return this.__actegestion == "inwiB2C_ChangementOptionsAttributs";
  }

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    if (this.isChangementOption) this.updatedCartChangementOptions()
    else this.getMessages();

  }

  //
  updatedCartChangementOptions() {
    const cart = JSON.parse(JSON.stringify(this.vlccart));
    this.__data = cart.records;
    // let oldCart = JSON.parse(JSON.stringify(this.vlccart));
    console.log("this.updatedCart");
    console.log(this.__data);
    let array = [];
    // eslint-disable-next-line no-unused-expressions
    this.__data &&
      this.__data.forEach(async (item, index) => {
        array = [];
        let item_index = 1;
        // eslint-disable-next-line no-unused-expressions
        item.lineItems.records &&
          item.lineItems.records.map(item2 => {
            if (item2.name == "Options") {
              // eslint-disable-next-line no-unused-expressions
              item2.lineItems && item2.lineItems.records.map(item3 => {
                if (
                  item3.action !== "Existing" && item3.action !== "Disconnect" && (item3.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                    item3.vlocity_cmt__RecurringCharge__c.value > 0)
                ) {
                  item3.index = item_index;
                  item3.useraction = item3.action == "Add" ? "Activation" : "Modification";
                  item_index++;
                  item3.itemname = item3.name;
                  item3.price = 0;

                  item3.next_bill =
                    item3.vlocity_cmt__RecurringCharge__c &&
                      item3.vlocity_cmt__RecurringCharge__c.value
                      ? item3.vlocity_cmt__RecurringCharge__c.value * 2
                      : 0;

                  item3.option_price =
                    item3.vlocity_cmt__RecurringCharge__c &&
                      item3.vlocity_cmt__RecurringCharge__c.value
                      ? item3.vlocity_cmt__RecurringCharge__c.value
                      : 0;

                  array.push(item3);
                }
              });
            }
          });
        console.log("Call this.sortarray(array, index)");
        let sortedArray = this.sortarrayChangementOption(array, index + 1);
        this.__dataCart = this.__dataCart.concat(sortedArray);
        console.log("lenghts", index + 1, this.__data.length);
      });
  }

  sortarrayChangementOption(items, index) {
    let array = items;
    array.sort(function (a, b) {
      return a.index - b.index;
    });
    return array;
  }

  get __updatedCartChangementOptions() {
    console.log("******************Global ***************");
    if (this.__dataCart && this.__dataCart.length > 0) {
      let data = [];
      let totalprice = 0;
      let totalnext_bill = 0;
      let totaloption_price = 0;
      this.__dataCart.map(async item => {
        data.push(item)
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


  //
  getMessages() {
    let __data = [];
    let oldCart = JSON.parse(JSON.stringify(this.vlccart));

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

          // eslint-disable-next-line no-unused-expressions
          oldCart.records &&
            oldCart.records.map((item, index) => {
              // eslint-disable-next-line no-unused-expressions
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
              // eslint-disable-next-line eqeqeq
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
    // eslint-disable-next-line no-unused-expressions
    this.__data &&
      this.__data.forEach(async (item, index) => {
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
                let pourcentage = 0;
                console.log('Resultat:', result.status );
                if (result.status == "1") {
                  item.data_simulation = response.result.IPResult;
                  item.data_simulation.offer = item.Name;
                  let vipinput = {
                    orderid: item.OrderId.value,
                    activation_date: datestring,
                    fms: item.InwiB2C_FMS__c.value,
                    prix_forfait: item.vlocity_cmt__RecurringPrice__c,
                    orderitemid: item.Id.value,
                  }
                  item.data_simulation.vipinput = vipinput;
                  // eslint-disable-next-line no-unused-expressions
                  console.log("------------- item databill---------"),
                    console.log(item.data_simulation)
                  this.dataBill.push(item.data_simulation);

                  pourcentage = parseFloat(parseFloat((result.prorata_period_amount * 100) / result.prix_forfait).toFixed(2));
                 console.log('Pourcentage:', pourcentage);
                 console.log('period Amount:', result.prorata_period_amount);
                 console.log('pris forfait :',result.prix_forfait);


                }
                array = [];
                item.index = 1;
                // set promotion
                if (promotions.length > 0) {
                  promotions.map(itempromotion => {
                    if (itempromotion.orderItemId__c === item.Id.value) {
                      item.promotion = item.promotion ? item.promotion + itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c + "\n" : itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c + "\n";
                    }
                  })
                }
                item.itemname = item.Name;
                item.price = item.vlocity_cmt__OneTimeCharge__c.value;
                item.price_abonnement =
                  item.vlocity_cmt__RecurringCharge__c.value;
                item.has_error_messages = item.messages && item.messages.length > 0;
                item.price_first_bill =
                  item.vlocity_cmt__RecurringCharge__c.value;
                array.push(item);
                // FMS & FMD
                array.push({
                  itemname: "FMS",
                  index: 2,
                  price_first_bill: 0,
                  price:
                    item.InwiB2C_FMS__c && item.InwiB2C_FMS__c.value
                      ? item.InwiB2C_FMS__c.value
                      : 0,
                  price_abonnement: 0,
                });

                array.push({
                  itemname: "FMD",
                  index: 3,
                  price_first_bill: 0,
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
                  price_first_bill: result.status == "1" ? result.prix_forfait == 49 ? 0 : result.prorata_period_amount : "",
                  // price_first_bill: 0,
                });

                let item_index = 5;
                // eslint-disable-next-line no-unused-expressions
                item.lineItems.records &&
                  item.lineItems.records.map(item2 => {
                    if (
                      item2.name !== "Options" &&
                      (item2.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                        item2.vlocity_cmt__RecurringCharge__c.value > 0)
                    ) {
                      item2.index = item_index;
                      item_index++;
                      item2.price = item2.Product2.InwiB2C_Mode_de_paiement__c !== "Sur facture" ?
                        item2.vlocity_cmt__OneTimeCharge__c.value : 0;
                      item2.price_first_bill = item2.Product2.InwiB2C_Mode_de_paiement__c == "Sur facture" ?
                        item2.vlocity_cmt__OneTimeCharge__c.value : 0;
                      item2.price_abonnement =
                        item2.vlocity_cmt__RecurringCharge__c.value;
                      item2.itemname = item2.name;
                      array.push(item2);
                    } else if (item2.name == "Options") {
                      // eslint-disable-next-line no-unused-expressions
                      item2.lineItems && item2.lineItems.records.map(item3 => {
                        if (
                          (item3.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                            item3.vlocity_cmt__RecurringCharge__c.value > 0) && item3.action != "Disconnect"
                        ) {
                          item3.index = item_index;
                          item_index++;
                          item3.itemname = item3.name;
                          item3.price =
                            item3.vlocity_cmt__OneTimeCharge__c &&
                              item3.vlocity_cmt__OneTimeCharge__c.value
                              ? item3.vlocity_cmt__OneTimeCharge__c.value
                              : 0;

                             //pourcentage
                             let recurring_price = item3.vlocity_cmt__RecurringCharge__c &&
                             item3.vlocity_cmt__RecurringCharge__c.value
                            ? item3.vlocity_cmt__RecurringCharge__c.value
                            : 0;

                            // eslint-disable-next-line eqeqeq
                            let is_option_prorata = result.status == "1" && result.prix_forfait != 49 && item3.Product2.InwiB2C_Prorat_e__c && item3.Product2.InwiB2C_Prorat_e__c == "Oui" ? 1 : 0;
                            console.log('IsOption:', is_option_prorata);
                            item3.price_abonnement = recurring_price;
                        

                            item3.price_first_bill = recurring_price + parseFloat(parseFloat((is_option_prorata * recurring_price * pourcentage) / 100).toFixed(2));
                            console.log('Price first bill:',  item3.price_first_bill );
                          array.push(item3);
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