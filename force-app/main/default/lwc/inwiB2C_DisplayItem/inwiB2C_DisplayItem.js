import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class InwiB2C_DisplayItem extends OmniscriptBaseMixin(
  LightningElement
) {
  __items;
  gridExpandedRows = [];

  /*columns = [
        { type: 'text',label: 'Produit', fieldName: 'inwiB2C_Product',initialWidth: 350 },
        {fieldName: 'inwiB2C_UnitPrice', label: 'Prix unitaire', hideDefaultActions: true, initialWidth: 150,type: 'currency', typeAttributes: { currencyCode: 'MAD' }},
        {fieldName: 'inwiB2C_ReccurentPrice', label: 'Prix récurrent', hideDefaultActions: true, initialWidth: 150,type: 'currency', typeAttributes: { currencyCode: 'MAD' }},
        { type: 'text',label: 'Statut', fieldName: 'actionLabel',initialWidth: 100 },
        { type: 'action', typeAttributes: { rowActions: this.getRowActions } }
        ];*/

  columns = [
    {
      type: "text",
      label: "Produit",
      fieldName: "inwiB2C_Product",
      initialWidth: 500,
    },
    {
      type: "text",
      label: "Statut",
      fieldName: "actionLabel",
      initialWidth: 100,
    },
    { type: "action", typeAttributes: { rowActions: this.getRowActions } },
  ];

  __item;

  @api
  set items(value) {
    //console.log('---  ' +JSON.stringify(value));
    this.__items = value;
  }
  get items() {
    return this.__items;
  }

  @api
  set item(value) {
    //console.log('---  ' +JSON.stringify(value));
    this.__item = value;
    this.__items.records = [];
    this.__items.records.push(value);
  }
  get item() {
    return this.__item;
  }

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
  }
  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;
    console.log(JSON.stringify(row) + " " + JSON.stringify(action));
    switch (action.name) {
      case "delete":
        console.log("button supp clicked");
        console.log(row.Product);
        console.log(row);
        let apexParams = JSON.stringify(row.actions.deleteitem.remote.params);
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

        // this.dispatchEvent(
        //     new ShowToastEvent({
        //     title: 'Info',
        //     message: 'Suppression de ' + row.Product + ' en cours',
        //     variant: 'Info'
        //     }),
        // );

        this._actionUtilClass
          .executeAction(params, null, this, null, null)
          .then(response => {
            console.log(response);
            this.getCart(row.actions.deleteitem.remote.params.cartId);
          })
          .catch(error => {
            window.console.log(error);
          });
        break;
      case "add":
        console.log("button ADD clicked");
        console.log(row.inwiB2C_Product);
        console.log(row);
        //console.log(JSON.stringify(this.getParentItem(row.inwiB2C_Id)));

        let partentRecord = JSON.parse(
          JSON.stringify(this.getParentItem(row.inwiB2C_Id))
        );

        console.log("partentRecord" + JSON.stringify(partentRecord));

        delete partentRecord.lineItems;
        console.log(
          "partentRecord after delete" + JSON.stringify(partentRecord)
        );
        /* delete partentRecord.childProducts;
                    delete partentRecord._children;
                    delete partentRecord.inwiB2C_Product;
                    delete partentRecord.inwiB2C_UnitPrice;
                    delete partentRecord.inwiB2C_ReccurentPrice;
                    delete partentRecord.inwiB2C_Id;*/

        let addParams = JSON.parse(
          JSON.stringify(row.actions.addtocart.remote.params)
        );

        addParams.items[0].parentRecord = {};
        addParams.items[0].parentRecord.records = [];
        addParams.items[0].parentRecord.records.push(partentRecord);

        let apexParams2 = JSON.stringify(addParams);

        console.log("apexParams2");
        console.log(apexParams2);
        const params2 = {
          input: apexParams2,
          sClassName: "vlocity_cmt.CpqAppHandler",
          sMethodName: "postCartsItems",
          options: "{}",
        };
        console.log("button supp clicked");

        console.log(params2);

        // this.dispatchEvent(
        //     new ShowToastEvent({
        //     title: 'Info',
        //     message: 'Suppression de ' + row.Product + ' en cours',
        //     variant: 'Info'
        //     }),
        // );

        this._actionUtilClass
          .executeAction(params2, null, this, null, null)
          .then(response => {
            console.log(response);
            this.getCart(row.actions.addtocart.remote.params.cartId);
          })
          .catch(error => {
            window.console.log(error);
          });
        break;
      default:
        console.log("nothing");
        break;
    }
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

          this.__items = JSON.parse(JSON.stringify(response.result));

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

  get item() {
    //console.log(JSON.stringify(this.__items));

    let tempItem = JSON.parse(JSON.stringify(this.__items.records[0]));

    // Code to Filter out options

    /*
        if (tempItem.childProducts){

            let tempChildProducts = tempItem.childProducts.records.filter(prod => {

                let foundLineItem = tempItem.lineItems.records.find(line => {
                    console.log (line.productId  +' ' + prod.productId)
                    return (line.productId  == prod.productId);
                })

                

                if (foundLineItem) {
                    console.log(prod.Name + '  prod.maxQuantity ' + prod.maxQuantity + ' foundLineItem.Quantity.value ' + foundLineItem.Quantity.value); 

                    if (prod.maxQuantity >= foundLineItem.Quantity.value) return false;
                    else return true;
                }
                else return true;

            });

            tempItem.childProducts.records = tempChildProducts;

        }
        */

    // Code to not allow Options

    if (tempItem.childProducts && tempItem.childProducts.records) {
      let tempChildProducts = tempItem.childProducts.records.map(prod => {
        let foundLineItem = tempItem.lineItems.records.find(line => {
          //console.log (line.productId  +' ' + prod.productId)
          return line.productId == prod.productId;
        });

        if (foundLineItem) {
          //console.log(prod.Name + '  prod.maxQuantity ' + prod.maxQuantity + ' foundLineItem.Quantity.value ' + foundLineItem.Quantity.value);

          foundLineItem.availableToAdd = false;
          return foundLineItem;
        } else {
          prod.availableToAdd = true;
          return prod;
        }
      });

      //console.log(tempChildProducts);

      tempItem.childProducts.records = tempChildProducts;
    }

    return tempItem;
  }

  /*
    get itemOptions(){

        let __itemOptions = [];

        let tempItem = JSON.parse(JSON.stringify(this.__items.records[0]));

        if (tempItem.childProducts && tempItem.childProducts.records){

            tempItem.childProducts.records.forEach(childProduct => {

                let product = JSON.parse(JSON.stringify(childProduct));

                product.selected = false;
                __itemOptions.push(product);

            });



        }

        if (tempItem.lineItems && tempItem.lineItems.records){

            tempItem.lineItems.records.forEach(childProduct => {

                let product = JSON.parse(JSON.stringify(childProduct));

                product.selected = true;
                __itemOptions.push(product);

            });



        }
        console.log('itemoptions');
        console.log(JSON.stringify(__itemOptions));

        return __itemOptions;
    }
    get struct(){
        let __itemOptions = [];

        let tempItem = JSON.parse(JSON.stringify(this.__items.records[0]));
        if (tempItem.lineItems && tempItem.lineItems.records){

            tempItem.lineItems.records.forEach(childProduct => {

                let product = JSON.parse(JSON.stringify(childProduct));
                let item = { Product : product.name,
                            UnitPrice: product.UnitPrice.value,
                            ReccurentPrice:product.vlocity_cmt__RecurringPrice__c,
                            actions:product.actions,
                            };

                    let __childrenitem=[];
                    if(product.hasChildren){
                        
                        product.lineItems.records.forEach(child2 =>{
                            __childrenitem.push( { Product : child2.name,
                                UnitPrice: child2.UnitPrice.value,
                                ReccurentPrice:child2.vlocity_cmt__RecurringPrice__c,
                                actions:child2.actions,
                               });
                        });
                        item._children=__childrenitem;
                    }
            
                __itemOptions.push(item);

            });
            console.log('final structure');
            console.log(JSON.stringify(__itemOptions));
        }
            return __itemOptions;
    }
    */

  get treeTableStructure() {
    const handleNode = item => {
      //console.log(item.name + item.itemType);
      /*let localItem = { Product : item.name,
                UnitPrice: item.UnitPrice.value,
                ReccurentPrice:item.vlocity_cmt__RecurringPrice__c,
                action:item.action,
                actions:item.actions,
                minQuantity: item.minQuantity,
                maxQuantity: item.maxQuantity,
                itemType: item.itemType,
                Id: item.Id.value
                };*/
      console.log(item);
      item.inwiB2C_Product = item.name;
      item.inwiB2C_UnitPrice = item.UnitPrice.value;
      item.inwiB2C_ReccurentPrice = item.vlocity_cmt__RecurringPrice__c;
      item.inwiB2C_Id = item.Id.value;
      this.gridExpandedRows.push(item.Id.value);
      console.log(item.action);
      if (item.action) {
        if (item.action == "Disconnect") {
          if (item.itemType == "lineItem") {
            //localItem.actionLabel='Supprimé';
            item.actionLabel = "Supprimé";
          } else {
            //localItem.actionLabel='Disponible';
            item.actionLabel = "Disponible";
          }
        } else if (item.action == "Existing") {
          //localItem.actionLabel='Existant';
          if (
            item.minQuantity == 0 &&
            item.Product2.vlocity_cmt__SpecificationType__c !== "Offer"
          ) {
            item.actionLabel = "Existant";
          } else {
            item.actionLabel = "Obligatoire";
          }
        } else if (item.action == "Add") {
          //localItem.actionLabel='';
          item.actionLabel = "Ajouté";
        }
      } else {
        //localItem.actionLabel='Disponible';
        item.actionLabel = "Disponible";
      }

      console.log(item.actionLabel);

      let selectedOptions = [];
      let unSelectedOptions = [];
      let filteredUnSelectedOptions = [];

      if (item.lineItems && item.lineItems.records) {
        //item.__childrenitem = tempItem.lineItems.records;
        selectedOptions = item.lineItems.records.map(child => {
          //return child;
          //   if (
          //     !child.Product2.vlocity_cmt__SellingEndDate__c ||
          //     (child.Product2.vlocity_cmt__SellingEndDate__c &&
          //       new Date() <=
          //         new Date(child.Product2.vlocity_cmt__SellingEndDate__c))
          //   ) {
          //     return handleNode(child);
          //   }
          return handleNode(child);
        });
      }

      if (item.childProducts && item.childProducts.records) {
        item.childProducts.records.map(child => {
          if (
            !child.Product2.vlocity_cmt__SellingEndDate__c ||
            child.Product2.vlocity_cmt__SellingEndDate__c === null ||
            (child.Product2.vlocity_cmt__SellingEndDate__c &&
              new Date() <=
                new Date(child.Product2.vlocity_cmt__SellingEndDate__c))
          ) {
            unSelectedOptions.push(handleNode(child));
          }
        });
        console.log(unSelectedOptions);
      }

      filteredUnSelectedOptions = unSelectedOptions.filter(option => {
        //return (!option.action || option.action != 'Disconnect');
        //return true;
        if (!option.action || option.action != "Disconnect") {
          return true;
        } else {
          const foundSelectedOption = selectedOptions.find(selected => {
            return (
              option.productId === selected.productId &&
              selected.action == "Add"
            );
          });
          if (foundSelectedOption) {
            return false;
          } else return true;
        }
      });

      //console.log(unSelectedOptions.length + ' ' +selectedOptions.length)

      if (filteredUnSelectedOptions.length > 0 || selectedOptions.length > 0) {
        //localItem._children = selectedOptions.concat(unSelectedOptions);
        item._children = selectedOptions.concat(filteredUnSelectedOptions);

        item._children.sort(function(a, b) {
          return a.displaySequence - b.displaySequence;
        });
      }

      //return localItem;
      return item;
    };

    let tempItem = JSON.parse(JSON.stringify(this.__items.records[0]));

    this.gridExpandedRows = [];

    let tree = [];
    tree.push(handleNode(tempItem));

    // New
    let att = [];
    let newItems = [];
    tree[0].lineItems.records.map(item_line => {
      if (item_line.Name == "Options Telco") {
        item_line._children.map(item2_line => {
          att.push({
            productId: item2_line.productId,
            actionLabel: item2_line.actionLabel,
          });
        });

        item_line._children.map(item3_line => {
          if (item3_line.actionLabel !== "Disponible") {
            newItems.push(item3_line);
          } else {
            if (this.checkIfExist(att, item3_line.productId)) {
              newItems.push(item3_line);
            }
          }
        });
        item_line._children = newItems;
      }
    });

    // end new
    console.log("newItems:");
    console.log(newItems);
    console.log("tree: *****************");
    console.log(tree);
    return tree;
  }

  checkIfExist(att, productId) {
    console.log("checkIfExist", att, productId);
    let toAdd = true;
    att.map(item => {
      console.log(
        "item checkIfExist",
        item,
        item.productId == productId,
        item.actionLabel == "Existant"
      );
      if (item.productId == productId && (item.actionLabel == "Existant" || item.actionLabel =="Ajouté")) {
        toAdd = false;
      }
    });
    return toAdd;
  }

  getParentItem(childItemId) {
    const findParent = (item, id) => {
      console.log(item.inwiB2C_Product);
      let foundChid = false;
      let tempItem = null;

      if (item._children) {
        item._children.forEach(child => {
          if (child.inwiB2C_Id == id) {
            foundChid = true;
            console.log("found: " + item.inwiB2C_Product);
            tempItem = item;
          } else {
            if (tempItem) {
            } else {
              tempItem = findParent(child, id);
            }
          }
        });
      }
      if (tempItem) return tempItem;
      else return null;
    };

    let foundItem = findParent(this.treeTableStructure[0], childItemId);

    console.log(foundItem);

    return foundItem;
  }

  getRowActions(row, doneCallback) {
    console.log(row.action);
    console.log(row.itemType);

    const actions = [];

    if (row.action) {
      if (row.action == "Disconnect") {
        if (row.itemType == "lineItem") {
        } else {
          actions.push({
            label: "Ajouter",
            iconName: "utility:add",
            name: "add",
          });
        }
      } else if (
        row.action == "Existing" &&
        row.minQuantity == 0 &&
        row.Product2.vlocity_cmt__SpecificationType__c !== "Offer"
      ) {
        actions.push({
          label: "Supprimer",
          iconName: "utility:delete",
          name: "delete",
        });
      } else if (row.action == "Add") {
        actions.push({
          label: "Supprimer",
          iconName: "utility:delete",
          name: "delete",
        });
      }
    } else {
      actions.push({
        label: "Ajouter",
        iconName: "utility:add",
        name: "add",
      });
    }

    // simulate a trip to the server
    setTimeout(() => {
      doneCallback(actions);
    }, 200);
  }

  handleOptionSelection(event) {
    console.log("handleOption selection executed");

    // get Selected Item
    var selectedLine = event.target.name;

    const orderId = this.item.OrderId.value;
    const itemId = this.item.Id.value;

    //console.log(JSON.stringify(selectedLine));

    let apexParams = JSON.parse(
      JSON.stringify(selectedLine.actions.addtocart.remote.params)
    );

    let tempItems = JSON.parse(JSON.stringify(this.items));

    delete tempItems.totalSize;
    delete tempItems.messages;
    delete tempItems.actions;

    delete tempItems.records[0].totalSize;
    delete tempItems.records[0].messages;
    delete tempItems.records[0].actions;
    delete tempItems.records[0].lineItems;
    delete tempItems.records[0].childProducts;

    apexParams.items[0].parentRecord = {};
    apexParams.items[0].parentRecord = tempItems;

    //console.log(apexParams);

    const params = {
      input: JSON.stringify(apexParams),
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "postCartsItems",
      options: "{}",
    };

    console.log("before call postCartsItems");

    console.log(params);

    this.dispatchEvent(
      new ShowToastEvent({
        title: "Info",
        message: "Ajout de " + selectedLine.name + " en cours",
        variant: "Info",
      })
    );

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);

        this.getCartItem(orderId, itemId);
        /*if (response.result.pdf) {
                    console.log(JSON.stringify(response));
                }else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la mise à jour',
                        variant: 'error'
                        }),
                    );
                }*/
      })
      .catch(error => {
        window.console.log(error);
      });
  }

  handleOptionDeSelection(event) {
    console.log("handleOption de-selection executed");

    // get Selected Item
    var selectedLine = event.target.name;

    const orderId = this.item.OrderId.value;
    const itemId = this.item.Id.value;

    console.log(JSON.stringify(selectedLine));

    let apexParams = JSON.parse(
      JSON.stringify(selectedLine.actions.deleteitem.remote.params)
    );

    /*let tempItems = JSON.parse(JSON.stringify(this.items));

        delete tempItems.totalSize;
        delete tempItems.messages;
        delete tempItems.actions;

        delete tempItems.records[0].totalSize;
        delete tempItems.records[0].messages;
        delete tempItems.records[0].actions;
        delete tempItems.records[0].lineItems;
        delete tempItems.records[0].childProducts;
        


        apexParams.items[0].parentRecord = {};
        apexParams.items[0].parentRecord = tempItems;*/

    console.log(apexParams);

    const params = {
      input: JSON.stringify(apexParams),
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "deleteCartsItems",
      options: "{}",
    };

    console.log("before call deleteCartsItems");

    console.log(params);

    this.dispatchEvent(
      new ShowToastEvent({
        title: "Info",
        message: "Suppression de " + selectedLine.name + " en cours",
        variant: "Info",
      })
    );

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);

        this.getCartItem(orderId, itemId);
        /*if (response.result.pdf) {
                    console.log(JSON.stringify(response));
                }else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la mise à jour',
                        variant: 'error'
                        }),
                    );
                }*/
      })
      .catch(error => {
        window.console.log(error);
      });
  }

  getCartItem(cartId, itemId) {
    const inputParams = {
      cartId: cartId,
      id: itemId,
      price: true,
      validate: true,
      includeAttachment: false,
      pagesize: 20,
      hierarchy: -1,
      methodName: "getCartsItemsById",
    };

    const params = {
      input: JSON.stringify(inputParams),
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "getCartsItemsById",
      options: "{}",
    };

    console.log("before call getCartsItemsById");

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (response.result) {
          //console.log(JSON.stringify(response));

          console.log("handle get Cart");

          this.__items = JSON.parse(JSON.stringify(response.result));

          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "Success",
              variant: "success",
            })
          );
        } else {
          console.log("Erreur lors de la récupération de la facture PDF");
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

  getCartLineItemPrices(cartId, itemId) {
    const inputParams = {
      cartId: cartId,
      price: false,
      methodName: "getCartLineItemPrices",
    };

    const params = {
      input: JSON.stringify(inputParams),
      sClassName: "vlocity_cmt.CpqAppHandler",
      sMethodName: "getCartLineItemPrices",
      options: "{}",
    };

    console.log("before call getCartLineItemPrices");

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log(response);
        if (response.result) {
          //console.log(JSON.stringify(response));

          this.getCartItem(orderId, itemId);
        } else {
          console.log("Erreur lors de la récupération de la facture PDF");
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

  SaveAndNext(event) {
    /*let selectedPersonContact = {
            "personIdAccount" : selectedcontact.AccountId,
            "personIdContact" : selectedcontact.IdContact,
            "personLastName" : selectedcontact.LastName,
            "personFirstName" : selectedcontact.FirstName, 
            "navigateTo360": "Yes"
        }*/

    let oldItems = JSON.parse(JSON.stringify(this.__items));

    let reponse = {
      records: oldItems.records,
      display: true,
    };

    this.omniUpdateDataJson(reponse);
    this.omniSaveState(reponse, true);
    this.omniNextStep();
  }

  SaveAndQuit(event) {
    let oldItems = JSON.parse(JSON.stringify(this.__items));
    let reponse = {
      records: oldItems.records,
      display: false,
    };

    this.omniUpdateDataJson(reponse);
    this.omniSaveState(reponse, true);

    this.omniNextStep();
  }
}