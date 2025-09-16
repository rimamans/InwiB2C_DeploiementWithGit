import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class InwiB2C_DisplayCartErrors extends OmniscriptBaseMixin(
  LightningElement
) {
  __vlccart;
  isModalOpen = false;
  __displayErrors = false;
  __recap = false;
  __typerecap = "ACQ";
  __orderid;
  __data = [];
  __dataErrors  = [];
  __disableValidate = false;
  __loadingCart = true;
  __orderstep;
  __displaybuttonaddprodcut="";
  __promotions = []; // meryem ano B-17228

  @api
  get orderstep() {
    return this.__orderstep;
  }
  set orderstep(value) {
    this.__orderstep = value;
  }


  @api
  get orderid() {
    return this.__orderid;
  }
  set orderid(value) {
    this.__orderid = value;
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
  __paiement =false;
  @api
  get paiement() {
    return this.__paiement;
  }
  set paiement(value) {
    this.__paiement = value;
  }
  
  @api 
  get displaybuttonaddprodcut() {
     return this.__displaybuttonaddprodcut;
     }

  set displaybuttonaddprodcut(value){
     this.__displaybuttonaddprodcut = value;
  }

  get isLivraison() {
    return this.typerecap === "LIVR" || this.paiement==true || this.displaybuttonaddprodcut == true || this.idsaporder == true;
  }


  __modpdv = false;

  @api
  get modpdv() {
      return this.__modpdv;
  }
  set modpdv(value) {
      this.__modpdv = value;
      
  }
  __typeparcour="";

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
  __ismodepdv = true;
  __isagence = false; 
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

  __idsaporder = false;

 @api 
get idsaporder() {
    return this.__idsaporder;
}

set idsaporder(value) {
   console.log('>>> Valeur reçue dans idsaporder :', value);
    this.__idsaporder = value === true || value === 'true';
}


 
  get isShowedError(){
    return this.ismodepdv == true || this.isagence == false || this.agencelivraison==true;

  }

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    console.log('agencelivraison' +this.agencelivraison);
    console.log('idsaporder' +this.idsaporder);
    console.log('isLivraison' +this.isLivraison);
  
    // meryem ano B-17228
    let inputpromotion = `{ "orderId":"` + this.__orderid + `" }`;
    let promotions = []
    this.getPromotions(inputpromotion).then(responsepromotion => {
      console.log('responsepromotion', JSON.stringify(responsepromotion));

      if (!responsepromotion.error && responsepromotion.result && responsepromotion.result.promotions) {
        promotions = responsepromotion.result.promotions;
      }

      this.__promotions = promotions;
      console.log('promotions' + this.__promotions);

    })
    .catch(error => {
      console.log("errorpromotion",error);
    })
    .finally(() => {
      this.getMessages();
    });
    // meryem ano B-17228
    //this.getMessages();
    
  }

  getMessages() {
    let cart = [];

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
          console.log("log cons");
          console.log('test0');
          if (oldCart.records && oldCart.records.length > 0) {
            this.__data = oldCart.records.map(item => {
              console.log(item);
              item.inwiB2C_Error = false;
              // meryem ano B-17228
              // set promotion
              console.log("promotions ------------>")
              console.log(this.__promotions)
              item.promotion = ""
              if (this.__promotions.length > 0) {
                this.__promotions.map(itempromotion => {
                  console.log('itempromotion.orderItemId__c', itempromotion.orderItemId__c)
                  console.log('item.Id.value', item.Id.value)
                  if (itempromotion.orderItemId__c === item.Id.value || itempromotion.orderItemId__r.vlocity_cmt__ParentItemId__c === item.Id.value) {
                    item.promotion = item.promotion ? item.promotion + itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c + "\n" : itempromotion.promotionId__r.inwiB2C_Libelle_promotion__c + "\n";
                  }
                })
              }
              // meryem ano B-17228
              response &&
                response.result &&
                response.result.messages.map(message => {
                  console.log(message);
                  console.log((message.bundleId, item.Id.value));
                  console.log('test');
                  console.log("After Display message : ", message.message); 
                  if (message.bundleId && message.bundleId === item.Id.value && ((this.__ismodepdv ?? true) || (this.isagence!=true ))) {
                    //debut Ano12621 Amine brm
                    console.log("Before  Display message: ", message.message);
                    try {
                      message.message = message.message.replace("Required attribute missing for", "Attribut requis manquant pour");
                    
                    } catch (error) {

                    }
                     //fin Ano12621 Amine brm
                    item.messages.push(message);
                    item.inwiB2C_Error = true;
                    this.__disableValidate = true;
                    item.has_error_messages = item.messages && item.messages.length > 0;
                    console.log("inwiB2C_Error: " + item.inwiB2C_Error);

                  
                  }
                  // else{
                  //   item.inwiB2C_Error = false;
                  //   this.__disableValidate = false;
                  //   //this.__loadingCart = false;
                  //   console.log("Amine brm" );

                  // }
                });
              return item;
            });
            console.log("size = ", this.__data.length);
            this.__loadingCart = false;
          }
        })
        .catch(error => {
          console.log("showVars_error:: " + error);
        });
        
    }

  }

  get updatedCart() {
    let cart = [];
    let oldCart = JSON.parse(JSON.stringify(this.vlccart));

    if (oldCart.records && oldCart.records.length > 0) {
      cart = oldCart.records.map(item => {
        console.log(item);
        

        return item;
      });
    }
    console.log("size = ", cart.length);
    return cart;

    //console.log('omniJsonData' + JSON.stringify(this.omniJsonData));
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
        if (response.error) {
          //console.log(JSON.stringify(response));

          this.vlccart = JSON.parse(JSON.stringify(response.result));

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
    let selected = {};
    this.__data.map(item => {
      if (item.Id.value == event.target.name.Id.value) selected = item;
    });
    let items = {};
    items.records = [];
    items.records.push(selected);
    let myData = {
      currentItem: items,
      restart: false,
    }
    let reponse = {
      selectedItem: items,
    };

    /* this.omniUpdateDataJson(reponse);
        this.omniSaveState(reponse,true);
        this.omniNextStep();*/

  

    console.log("recap: " + this.recap);

     if (this.ismodepdv==false && this.typeparcour==='eshop'){
      let mydataeshop={
        configmode:true,
        currentItem: items,
      }
     
      this.omniApplyCallResp(mydataeshop);
      this.omniNavigateTo("GetConfigurationBO");
          
    } else if (this.ismodepdv==true && this.typeparcour==='eshop'){
      let mydataeshop={
        configmode:true,
        currentItem: items


      }
      this.omniApplyCallResp(mydataeshop);
      this.omniNavigateTo("GetInfoChefAgence");
        

    }else if (this.typeparcour==='televente' && this.orderstep === 'Choix  Livraison'){
      let mydatatelevente={
        configmode:true,
        addproduct:false,
        currentItem: items,
        restart : false,
      }
      this.omniApplyCallResp(mydatatelevente);
      this.omniNavigateTo("GetInfosFromOrder");
          
    }else if(this.typeparcour==='televente' && this.orderstep === 'Attributs'){
      let mydatatelevente={
        configmode:true,
        currentItem: items,
        restart : false,
      }
      this.omniApplyCallResp(mydatatelevente);
      this.omniNavigateTo("RestartConfigueRecap");
          
    } else if(this.typeparcour==='televente' && this.ismodepdv==false ){
      let mydatatelevente={
        configmode:true,
        currentItem: items,
      }
      this.omniApplyCallResp(mydatatelevente);
      this.omniNavigateTo("SetFlags");
      
     } else {

     
      this.omniApplyCallResp(myData);
      /*if (this.recap){
              this.omniNavigateTo("Attributes");
          }else{
              this.omniNextStep();
          }*/
          
  
      this.omniNavigateTo("Attributs");

    }

   
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
    //console.log('validateDisabled :' +  this.hasErrors + ' ' + this.vlccart.records.length);

    if (this.vlccart && this.vlccart.records) {
      return this.hasErrors || this.vlccart.records.length == 0;
    } else return true;
  }

  deleteItem(event) {
    console.log("Delete Item");
    console.log(JSON.stringify(event.target.name));

    let item = event.target.name;
    let orderItemId = item.Id.value;

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


    console.log("button supp clicked");

    console.log(params);

    // this.dispatchEvent(
    //     new ShowToastEvent({
    //     title: 'Info',
    //     message: 'Suppression de ' + row.Product + ' en cours',
    //     variant: 'Info'
    //     }),
    // );

    this.dispatchEvent(
      new ShowToastEvent({
        title: "Suppression",
        message: "Suppression de " + item.Name,
        variant: "info",
      })
    );

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
        console.log(response);
        this.getCart(cartId);
      })
    })
      .catch(error => {
        window.console.log(error);
      });
  }
 //Amine Brm Anomalie 12621
  openModal(event) {
    this.isModalOpen = true;
    var selected = event.target.name;
    this.__dataErrors = selected.messages;
    console.log(selected);
  }
  closeModal() {
    this.isModalOpen = false;
  }
 
 //Amine Brm  fin Anomalie 12621

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

   if(this.typeparcour && this.typeparcour === 'televente'){
    let navigate = {
      restart:false,
      configmode:false,
      addproduct: true,

    };

    this.omniApplyCallResp(navigate);
    this.omniNavigateTo("CaluclateMobileRecords");

   } else if(this.typeparcour === 'eshop'){
    let navigate = {
      configmode:false,
      addproduct: true,

    };
    console.log("navigate" +navigate);


    this.omniApplyCallResp(navigate);
    this.omniNavigateTo("GetOrderSep");

   } else{

    let myData = {
      currentItem: null,
      restart: false,
    };

    this.omniApplyCallResp(myData);
    this.omniNavigateTo("CaluclateMobileRecords");
  }
}

  SaveAndNext(evt) {
    let myData = {
      currentItem: null,
      restart: false,
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

  // meryem ano B-17228
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
  // meryem ano B-17228
}