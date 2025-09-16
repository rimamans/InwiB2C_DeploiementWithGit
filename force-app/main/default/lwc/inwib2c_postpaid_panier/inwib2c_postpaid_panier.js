import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import template from "./inwib2c_postpaid_panier.html";

export default class inwib2c_postpaid_panier extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  __vlccart;
  isModalOpen = false;
  __displayErrors = false;
  __recap = false;
  __typerecap = "ACQ";
  __frommigration;
  __paiement =false;
  __orderid;
  __data = [];
  __dataErrors = [];
  __offerSegement = "prépayé";
  __family;
  //__updatedCart = [];
  __dataCart = [];
  __disableValidate = false;
  __disableAddProduct = false;
  __isPrintInvoice = false;
     //agencelivraison=true;
  __userprofile;
  __orderstep;
  __billingaccount;
  @api iscameleon;
  // simulation facture var
  __cf_exist = false;
  isModalOpenBill = false;
  dataBill = [];
  selectedBill = {};
  __loading = false;
  __loadingCart = true;
  __typeparcour="";
  __ismodepdv = true;
  __isagence = false; 
  __displaybuttonaddprodcut="";
  
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
  get paiement() {
    return this.__paiement;
  }
  set paiement(value) {
    this.__paiement = value;
  }
  @api
  get typeparcour() {
    return this.__typeparcour;
  }
  set typeparcour(value) {
    this.__typeparcour = value;
  }

  __agencelivraison=false;
  @api
  get agencelivraison(){
    return this.__agencelivraison;
  }
  set agencelivraison(value){
    this.__agencelivraison = value;
  }
 
 
  @api
  get billingaccount() {
    return this.__billingaccount;
  }
  set billingaccount(value) {
    this.__billingaccount = value;
  }

  @api
  get frommigration() {
    return this.__frommigration;
  }
  set frommigration(value) {
    this.__frommigration = value;
  }
  @api
  get orderstep() {
    return this.__orderstep;
  }
  set orderstep(value) {
    this.__orderstep = value;
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
    return this.typerecap === "LIVR" || this.typerecap === "RepriseD2D";
  }
  
  
  @api 
  get displaybuttonaddprodcut() {
     return this.__displaybuttonaddprodcut;
     }

  set displaybuttonaddprodcut(value){
     this.__displaybuttonaddprodcut = value;
  }
  __idsaporder=false;
  @api 
  get idsaporder() {
     return this.__idsaporder;
     }

  set idsaporder(value){
     this.__idsaporder = value;
  }


  @api
  get family() {
    return this.__family;
  }
  set family(value) {
    this.__family = value;
  }

  

  @api 
  get ismodepdv() {
     return this.__ismodepdv;
     }

  set ismodepdv(value){
     this.__ismodepdv = value;
  }
  
  
  @api 
  get isagence() {
     return this.__isagence;
     }

  set isagence(value){
     this.__isagence = value;
  }
   
  get isShowed() {
    return  this.paiement || this.displaybuttonaddprodcut == true || this.idsaporder == true;
  }

// H_M LastMile : Désactiver le bouton "Sélectionner erreur" dans le récapitulatif si le PreOrder SAP existe déjà dans le système SAP.
get isShowedError(){
    return (this.ismodepdv == true || this.agencelivraison == true) && (this.idsaporder == false);

  }

// H_M LastMile : Désactiver le bouton "Configurer" sur le récapitulatif si le PreOrder SAP existe déjà dans le système SAP.
get disabledButtonConfig() {
   return this.idsaporder === true && this.ismodepdv === false;
  }
  
  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    console.log('this.typeRecap',this.typerecap);
    console.log('this.userProfil',this.userprofile);
    console.log('typeParcours',this.typeparcour);
    console.log('isShowedError',this.isShowedError);
    console.log('ismodepdv',this.ismodepdv);
    console.log('isagence',this.isagence);
    console.log('orderstep',this.orderstep);
    console.log('displaybuttonaddprodcut',this.displaybuttonaddprodcut);
    console.log('idsaporder',this.idsaporder);
    console.log('isShowed',this.isShowed);
    console.log('disabledButtonConfig',this.disabledButtonConfig);
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.getMessages();
    
   
  }

  getMessages() {
    let __data = [];
    this.__data = [];
    let oldCart = JSON.parse(JSON.stringify(this.vlccart));
    console.log("getMessages")
    console.log("Contenu de l'ancien panier :", oldCart);
    console.log(oldCart);
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
                    console.log("ismodepdv: " + this.ismodepdv);
                    console.log("isagnece: " +  this.isagence);
                    
                    if (message.bundleId && message.bundleId === item.Id.value &&( this.ismodepdv == true ||  this.isagence!=true)){
                    try {
                      message.message = message.message.replace("Required attribute missing for", "Attribut requis manquant pour");
                    } catch (error) {

                    }
                    item.messages.push(message);
                    item.inwiB2C_Error = true;
                    this.__disableValidate = true;
                    console.log("inwiB2C_Error: " + item.inwiB2C_Error); 
                    console.log("disableValidate: " + this.__disableValidate ); 
                  }
                });
                console.log("item.vlocity_cmt__ServiceAccountId__r.Id", item.vlocity_cmt__ServiceAccountId__r.Id);
                console.log("item.vlocity_cmt__BillingAccountId__r.Id", item.vlocity_cmt__BillingAccountId__r.Id);
                console.log("this.billingaccount",this.billingaccount);
                console.log('item.Product2.vlocity_cmt__Type__c',item.Product2.vlocity_cmt__Type__c );
                if (item.Product2.vlocity_cmt__Type__c != "Accessoire" && item.Product2.vlocity_cmt__Type__c != "Accesoire Idar" &&( this.typeparcour!='migrationversidar') &&( this.typeparcour!='eshop') && (this.typeparcour!='televente') && (this.typeparcour !='RepriseD2D') && ( this.billingaccount==='BillingNotExist' || item.vlocity_cmt__BillingAccountId__r.Id === item.vlocity_cmt__ServiceAccountId__r.Id))  {
              console.log('item.Product2.vlocity_cmt__Type__c',item.Product2.vlocity_cmt__Type__c );
                  item.messages.push({
                  messageId: item.Id.value,
                  message: "Veuillez sélectionner un compte de facturation"
                })

            
                item.inwiB2C_Error = true;
                this.__disableValidate = true;
                console.log("disableValidate: " + this.__disableValidate ); 

              }
              if (this.agencelivraison==true && this.isagence==true)  {
                console.log('AgenceLivraison' );
                    item.messages.push({
                    messageId: item.Id.value,
                    message: "Veuillez sélectionner une Agence de Livraison"
                  })
  
              
                  item.inwiB2C_Error = true;
                  this.__disableValidate = true;
                }
              this.__data.push(item);

         // H-M lastmile: Ne pas afficher les erreurs du catalogue si le PreOrder SAP existe déjà dans le système SAP dans le cas de mode de livariosn a Domicile.
           if (this.idsaporder === true && this.ismodepdv ===false) {
                  this.__disableValidate = false;
                  console.log("idsaporder est vrai, __disableValidate est réglé sur false");
              }
              if (index + 1 == oldCart.records.length) this.updatedCart();
            });
        })
        .catch(error => {
          console.log("showVars_error:: " + error);
        });
    }
  }

  async updatedCart() {
    let array = [];
    if (this.__data) {
     
      for (let index = 0; index < this.__data.length; index++) {

      
        let item = this.__data[index];
        let promotions = [];
        // get promotions
      
        let inputpromotion = `{ "orderId":"` + item.OrderId.value + `" }`;

        const responsepromotion = await this.getPromotions(inputpromotion);
        if (!responsepromotion.error && responsepromotion.result && responsepromotion.result.promotions) {
          promotions = responsepromotion.result.promotions;
        }
        // end get promotions

        // get bill simulation
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
        // get bill simulation

        console.log("callInvoiceSimulation");
        console.log(response);
        let result = response.result.IPResult;
        let pourcentage = 0;
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
          console.log("------------- item databill---------");
          console.log(item.data_simulation);
          if (item.data_simulation.prix_forfait == 49) {
            item.data_simulation.prorata_period_amount = 0;
            item.data_simulation.fstinvoice_amount = 49;
          }
          console.log("------------- after item databill---------");
          console.log(item.data_simulation);
          this.dataBill.push(item.data_simulation);
          //
          pourcentage = parseFloat(parseFloat((result.prorata_period_amount * 100) / result.prix_forfait).toFixed(2));
        }

        array = [];
        item.index = 1;
        // set promotion
        console.log("promotions ------------>")
        console.log(promotions)
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
        // item.price_abonnement =
        //   item.ListPrice.value; B-5041 - B-5108
        item.has_error_messages = item.messages && item.messages.length > 0;
        item.price_first_bill =
          item.vlocity_cmt__RecurringCharge__c.value;
        array.push(item);
        // FMS & FMD
        if (item.InwiB2C_FMS__c.value > 0) {
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
        }

        if (item.InwiB2C_FMD__c && item.InwiB2C_FMD__c.value > 0) {
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
        }

        if (item.Product2.vlocity_cmt__Type__c != "Cameleon" ) {
          console.log("this.__frommigration "+this.__frommigration )
          if (  this.__frommigration !="DayOne"){
            if (  this.__frommigration !="FTTH"){
              if (  this.__frommigration !="Eshoprepaye"){

             

                this.__isPrintInvoice = false;
         
                array.push({
                  itemname: "Prorata premiere facture",
                  index: 4,
                  price: 0,
                  price_abonnement: 0,
                  price_first_bill:
                    result.status == "1" ? result.prix_forfait == 49 ? 0 : result.prorata_period_amount : "",
                });

              }
        }}}
        if (item.Product2.vlocity_cmt__Type__c == "Cameleon" || this.__frommigration =="DayOne" )  {
            this.__disableAddProduct = true;
            this.__isPrintInvoice = true;
          }
        
          if (this.__frommigration =="FTTH" )  {
            this.__disableAddProduct = true;
            this.__isPrintInvoice = true;
          }
          if (this.__frommigration =="Eshoprepaye" )  {
            this.__isPrintInvoice = true;
          }

        let item_index = 5;
        item.lineItems && item.lineItems.records &&
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
              item2.lineItems && item2.lineItems.records.map(item3 => {
                //console.log(item3.name, JSON.stringify(item3));
                if (
                  item3.vlocity_cmt__OneTimeCharge__c.value > 0 ||
                  item3.vlocity_cmt__RecurringCharge__c.value > 0
                ) {
                  if (promotions.length > 0) {
                    promotions.map(itempromotion => {
                      if (itempromotion.orderItemId__c === item3.Id.value) {
                        item3.promotion = item3.promotion ? item3.promotion + itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c + "\n" : itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c + "\n";
                      }
                    })
                  }
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

                  let is_option_prorata = result.status == "1" && result.prix_forfait != 49 && item3.Product2.InwiB2C_Prorat_e__c && item3.Product2.InwiB2C_Prorat_e__c == "Oui" ? 1 : 0;

                  item3.price_abonnement = recurring_price;

                  item3.price_first_bill = recurring_price + parseFloat(parseFloat((is_option_prorata * recurring_price * pourcentage) / 100).toFixed(2));

                  array.push(item3);
                }
              });
            }
          });
        console.log("Longueur actuelle des données :", this.__data.length);
        let sortedArray = this.sortarray(array, index + 1);
        this.__dataCart = this.__dataCart.concat(sortedArray);
        console.log("Index actuel + 1 :", index + 1);
        console.log(this.__data.length + " - " + (index + 1))
       
        if (this.__data.length == (index + 1)) {
          this.__loadingCart = false;
        }

      }
    }
  }

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

  async getPromotions(input) {
    console.log("call vip getPromotions")
    const params2 = {
      input,
      sClassName: 'inwib2c_promotion_functions',
      sMethodName: 'getAppliedPromotionsForCart',
      options: '{}',
    };
    return this._actionUtilClass
      .executeAction(params2, null, this, null, null)


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
      totalpricefature = parseFloat(item.price_first_bill)
        ? parseFloat(totalpricefature) + parseFloat(item.price_first_bill)
        : parseFloat(totalpricefature);
      totalprice = parseFloat(totalprice) + parseFloat(item.price);
      totalpriceabonnement = parseFloat(totalpriceabonnement) + parseFloat(item.price_abonnement);

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
    console.log('simulation:', simulation);

    // cycle first day
    let text = simulation.activation_date;

    text = text.substring(0, 10);
    text = text.substring(6) + "-" + text.substring(3, 5) + "-" + text.substring(0, 2);

    const Dateactiavte = text;
    let DateActvation = Dateactiavte.split("-").reverse().join("-").replace(/-/g, '/');
    console.log('DateActvation:', DateActvation);

    var date = new Date(text);
    date.setDate(date.getDate() + simulation.prorata_period);
    const dateFirstdaycycle = new Date(text);

    const item_billing_cycle = simulation.billing_cycle.toString().padStart(2, '0');
    console.log('item_billing_cycle:', item_billing_cycle);

    dateFirstdaycycle.setDate(dateFirstdaycycle.getDate() + parseInt(simulation.prorata_period, 10));
    console.log('dateFirstdaycycle: ' + dateFirstdaycycle);

    console.log('billing_cycle: ' + simulation.billing_cycle);


    const firstdaycycle =
        item_billing_cycle +
        "/" +
        ('0' + (dateFirstdaycycle.getMonth() + 1)).slice(-2) +
        "/" +
        dateFirstdaycycle.getFullYear();

    console.log('firstdaycycle: ' + firstdaycycle);

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
    
    const secondbill =
        item_billing_cycle +
        "/" +
        ('0' + (datedf.getMonth() + 1)).slice(-2) +
        "/" +
        datedf.getFullYear();

    console.log('secondbill: ' + secondbill);

    const periodfactureedf = secondbill;
    event.stopPropagation();

    this.selectedBill = {
        numligne: simulation.numligne,
        clientname: simulation.clientname,
        periodfactureedd: DateActvation,
        periodfactureedf: periodfactureedf,
        offer: item.Name,
        activationdate: DateActvation,
        firstdaycycle: item_billing_cycle,
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
      fields: "vlocity_cmt__BillingAccountId__c,vlocity_cmt__ServiceAccountId__c,Quantity,vlocity_cmt__RecurringTotal__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__OneTimeCharge__c,ListPrice,vlocity_cmt__ParentItemId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__PremisesId__r.Name,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__EffectiveQuantity__c,Product2.INWIB2C_visibilit_options__c,Product2.vlocity_cmt__SpecificationType__c,Product2.Name,Product2.vlocity_cmt__SellingEndDate__c,vlocity_cmt__Product2Id__r.Family,Product2.InwiB2C_Type_offre__c,Product2.vlocity_cmt__Type__c",
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
        this.__loading = false;
        console.log(response);
        this.__dataCart = [];
        this.vlccart = response.result && response.result.records ? { records: response.result.records } : [];
        console.log(this.vlccart);
        this.getMessages();
        // if (!response.error) {
        //   //console.log(JSON.stringify(response));

        //   this.vlccart = JSON.parse(JSON.stringify(response.result));
        //   this.getMessages();
        //   this.dispatchEvent(
        //     new ShowToastEvent({
        //       title: "Success",
        //       message: "Success",
        //       variant: "success",
        //     })
        //   );
        // } else {

        //   this.dispatchEvent(
        //     new ShowToastEvent({
        //       title: "Erreur",
        //       message: "Erreur lors de la mise à jour",
        //       variant: "error",
        //     })
        //   );
        // }
      })
      .catch(error => {
        window.console.log(error);
      });
  }
  
  selectItem(event) {
    console.log("Select Item");
    console.log(JSON.stringify(event.target.name));
    let selected = {};
    this.__data.map(item => {
      if (item.Id.value == event.target.name.Id.value) selected = item;
    });
    console.log("selected---");
    let items = {};
    items.records = [];
    items.records.push(selected);
    let myData = {
      currentItem: items,
      restart: false,

      
    };
    console.log('MyData',myData);
    if (this.orderstep === 'Recapitulatif' &&  this.typeparcour==='RepriseD2D'){
      let mydatad2d ={
        restart : false,
        }
        this.omniApplyCallResp(mydatad2d);
        this.omniNavigateTo("GetInfoToOrder");
  
     }
  
    else if (selected && selected.Product2 && selected.Product2.vlocity_cmt__Type__c === 'Accesoire Idar'){
      console.log('before0');
      this.omniNavigateTo("getCartItems2");
      this.omniApplyCallResp(myData);

    }
    else if (this.ismodepdv==false && this.typeparcour==='eshop'){
      let mydataeshop={
        configmode:true,
        currentItem: items,
      }
      console.log('before2'+this.typeparcour);
      this.omniApplyCallResp(mydataeshop);
      this.omniNavigateTo("GetConfigurationBO");
      //this.omniRaiseError('La navigation vers cette étape n\'est pas prise en charge', '');
  
      //this.omniNavigateTo(this.omniScriptHeaderDef.asIndex - 30);
          
    }
    else if (this.ismodepdv==true && this.typeparcour==='eshop'){
      let mydataeshop={
        configmode:true,
        currentItem: items


      }
      
      console.log('before5'+this.typeparcour);
      this.omniApplyCallResp(mydataeshop);

      //this.omniNavigateTo("getCartItems2");
      this.omniNavigateTo("GetInfoChefAgence");
        

    } else if(this.typeparcour==='televente' && this.orderstep === 'ComptedeFacturation') {
      this.omniNavigateTo("GetOrderStepOptionattribute");


     } else if (this.typeparcour==='televente' && this.orderstep === 'Choix  Livraison'){
      let mydatatelevente={
        configmode:true,
        addproduct:false,
        currentItem: items,
        restart : false,
      }
      this.omniApplyCallResp(mydatatelevente);
      this.omniNavigateTo("GetInfosFromOrder");
        
          
    
    }else if(this.typeparcour==='televente' && this.ismodepdv== false && this.orderstep ==="Attributs"){
      let mydatatelevente={
        configmode:true,
        currentItem: items,
        restart : false,
      }
      this.omniApplyCallResp(mydatatelevente);
      this.omniNavigateTo("SetFlags");
      
     }
     else if(this.orderstep === 'Recapitulatif') {
      let mydatatelevente ={
      configmode:true,
      restart : false,
      }
      this.omniApplyCallResp(mydatatelevente);
      this.omniNavigateTo("RestartConfigueRecap");

     }
    else{
    console.log("orderstep2" + this.orderstep);
    let step;
        if (this.orderstep === 'Choix Site') {
          step="Site";
        }else{
          step="getCartItems2"
        }
      this.omniApplyCallResp(myData);
      this.omniNavigateTo(step);
    }
    // let input = `{ "orderItemId":"` + selected.Id.value + `" }`;
    // console.log(input);
    // const params = {
    //   input,
    //   sClassName: `${this._ns}IntegrationProcedureService`,
    //   sMethodName: "inwib2c_inwib2c_get_product_info",
    //   options: "{}",
    // };

    // this._actionUtilClass
    //   .executeAction(params, null, this, null, null).then(response => {
    //     console.log(response);
    //     let myData = {
    //       currentProduct: response.result.IPResult.currentProduct,
    //       currentItem: items,
    //       restart: false,
    //     };

    //     console.log("recap: " + this.recap);

    //     this.omniApplyCallResp(myData);
    //     this.omniNavigateTo("Options");
    //   })
    //   .catch(error => {
    //     window.console.log(error);
    // });;


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
    this.__loading = true;
    let item = event.target.name;

    let apexParams = JSON.stringify(item.actions.deleteitem.remote.params);
    let cartId = item.actions.deleteitem.remote.params.cartId;
    let orderItemId = item.Id.value;
    console.log("apexarams");
    console.log(cartId);
    console.log(apexParams);

    //
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Suppression",
        message: "Suppression de " + item.Name,
        variant: "info",
      })
    );

    // Unlock Icc & Imei
    const inputUnlock = {
      "OrderId": cartId,
      "OrderItemId": orderItemId
    }
    const paramsUnlock = {
      input: JSON.stringify(inputUnlock),
      sClassName: `${this._ns}IntegrationProcedureService`,
      sMethodName: "inwib2c_inwib2c_delete_orderitem_resources",
      options: "{}",
    };



    const params = {
      input: apexParams,
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "deleteCartsItems",
      options: "{}",
    };
    console.log("button supp clicked");

    console.log(paramsUnlock);
    console.log(params);

    this._actionUtilClass
      .executeAction(paramsUnlock, null, this, null, null)
      .then(response => {
        console.log("log unlock");
        console.log(response);
        this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
            console.log("response deleteItem");
            console.log(response);
            this.__loading = false;
            let vlccart = { ...this.vlccart };
            let records = [...vlccart.records];
            console.log(JSON.stringify(records));
            let temp = records.filter(item =>
              item.Id.value != orderItemId
            );
            vlccart.records = temp;
            vlccart.totalSize = vlccart.totalSize -1;
            
            this.vlccart = { ...vlccart };
            this.__dataCart = [];
            console.log("vlc ----------------->");
            console.log(orderItemId);
            console.log(temp);
            console.log(this.vlccart);
            this.getMessages();
            //this.getCart(cartId);
          })
          .catch(error => {
            window.console.log(error);
          });

      })
      .catch(error => {
        console.log("showVars_error:: " + error);
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
    console.log("frommigration" + this.__frommigration);
    console.log("Le type de Parcours est" +this.typeparcour);

    if (this.__family != null) {
       if ( this.typeparcour!='eshop'&& this.typeparcour!='televente' && (this.__family.includes("idar duo") || this.__family.includes("Postpayé"))){
        this.__offerSegement = "postpayé"  
        let navigate = {
          restart:false,     
          addproduct: true,   
        };
        this.omniApplyCallResp(navigate);
        this.omniNavigateTo("ChooseFamily");
      }
      
      else if((this.typeparcour=='eshop'||this.typeparcour=='televente')&& (this.__family.includes("Postpayé") || this.__family.includes("Postpaye") || this.__family.includes("Prépayé") || this.__family.includes("Prepaye") || this.__family.includes("idar duo")||this.__family.includes("FTTH")||this.__family.includes("ADSL") )){
        console.log("Type de Parcours:" +this.typeparcour);
        console.log("family" + this.__family);
        let navigate = {
          restart:false,
          configmode:false,
          addproduct: true,

        };
        console.log("navigate" +navigate);
  
    
        this.omniApplyCallResp(navigate);
        this.omniNavigateTo("GetOrderSep");

      }
      
     else if (this.__frommigration ==="FTTH") {
        console.log("goadd" + this.__frommigration);
  
        let navigate = {
          restart:false,
          addproduct: true,
        };
        console.log("navigate" +navigate);
  
    
        this.omniApplyCallResp(navigate);
        //this.omniNavigateTo("SetOrderStepFamilyChoice");
        this.omniNavigateTo("InwiB2C_GetOffreFromOrders");
    
      
        
    }
    else if (this.__frommigration ==="DayOne") {
      console.log("goadd" + this.__frommigration);

      let navigate = {
        restart:false,
        addproduct: true,
      };
      console.log("navigate" +navigate);

  
      this.omniApplyCallResp(navigate);
      //this.omniNavigateTo("SetOrderStepFamilyChoice");
      this.omniNavigateTo("GetPriceBookEntry");
  
    
      
  }
      else if (this.__family.includes("FTTH")&& this.typeparcour!='eshop') {
         this.__offerSegement = "FTTH"; 
         
        }
     
      //else
      //  if(this.__family.includes("Mobile") || this.__family.includes("mobile")|| this.__family.includes("Home") || this.__family.includes("home"))
      //     this.__offerSegement ='prépayé';
    }
    else{
      
 


    
    let myData = {
      currentItem: null,
      restart: false,
      addproduct: true,

      offerSegement: this.__offerSegement,
    };

    this.omniApplyCallResp(myData);
    //this.omniNavigateTo("SetOrderStepFamilyChoice");
    this.omniNavigateTo("ChooseFamily");
  }

  }
  ficheclient(evt) {
    let myData = {
      updateaccount: true,
      

      offerSegement: this.__offerSegement,
    };
    this.omniApplyCallResp(myData2);

    this.omniNavigateTo("GoAccount");

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