import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_acquisition_promotions.html";

export default class Inwib2c_acquisition_promotions extends OmniscriptBaseMixin(
  NavigationMixin(LightningElement)
) {
  __currentItem;
  __promotions;
  loadindData = true;
  saving = false;
  __data = [];
  // Variables
  @api
  get currentitem() {
    return this.__currentItem;
  }
  set currentitem(value) {
    this.__currentItem = { ...value };
  }

  @api
  get promotions() {
    return this.__promotions;
  }
  set promotions(value) {
    this.__promotions = JSON.parse(JSON.stringify(value));
  }

  get noData() {
    return this.__data.length == 0;
  }

  _ns = getNamespaceDotNotation();
  _actionUtilClass;

  connectedCallback() {
    this._actionUtilClass = new OmniscriptActionCommonUtil();
    this.getPromotions();
  }

  // Get Promotion
  getPromotions() {
    let data = [];
    if (this.__promotions && this.__promotions.length > 0) {
      this.__promotions.map(item => {
        if (item.eligible) {
          item.checked = item.inclusionType === "included";
          item.disabled = item.inclusionType === "included";
        }
        data.push(item);
      })
      console.log(data)
      this.__data = [...data];
      this.getAppliedPromotions();
    }
  }


  getAppliedPromotions() {
    const id = this.__currentItem.records[0].Id.value;
    const params = {
      input: '{"orderItemId": "' + id + '" }',
      sClassName: 'inwib2c_promotion_functions',
      sMethodName: 'getAppliedPromotions',
      options: '{}',
    };

    this._actionUtilClass
      .executeAction(params, null, this, null, null)
      .then(response => {
        console.log("getAppliedPromotions");
        console.log(response);
        let data = [...this.__data];
        if (response && !response.error) {
          response.result && response.result.promotions && data.map(item => {
            if (item.eligible) {
              item.checked = item.inclusionType === "included" || response.result.promotions.indexOf(item.promotionId) !== -1;
            }
            return item;
          })
          this.__data = [...data];
          this.loadindData = false;

        }
      })
      .catch(error => {
        window.console.log(error);
      });

  }

  // getPromotions() {
  //   console.log(JSON.stringify(this.__promotions))
  //   if (this.__currentItem && this.__currentItem.records && this.__currentItem.records[0]) {
  //     const id = this.__currentItem.records[0].Id.value;
  //     const params = {
  //       input: '{"orderItemId": "' + id + '" }',
  //       sClassName: 'inwiB2C_OrderPromotionManagementOS',
  //       sMethodName: 'getOrderEligiblePromotions',
  //       options: '{}',
  //     };

  //     this._actionUtilClass
  //       .executeAction(params, null, this, null, null)
  //       .then(response => {
  //         console.log("response getOrderEligiblePromotions");
  //         console.log(response);
  //         if (response && !response.error) {
  //           let data = []
  //           response.result && response.result.promotions && response.result.promotions.map(item => {
  //             if (item.eligible) {
  //               item.checked = item.inclusionType === "included";
  //               item.disabled = item.inclusionType === "included";
  //             }

  //             data.push(item);

  //           })

  //           console.log(data)

  //           this.__data = [...data];
  //           if (data.length == 0) {
  //             this.loadindData = false;
  //           }
  //           else this.getAppliedPromotions();


  //         }
  //       })
  //       .catch(error => {
  //         window.console.log(error);
  //       });

  //   }
  // }


  selectItem(event) {
    let Id = event.target.name;
    console.log("selected = ", JSON.stringify(Id));
    let data = [...this.__data];
    data.map(item => {
      console.log(Id, item.promotionId)
      console.log(Id === item.promotionId)
      console.log(item.checked)
      if (Id == item.promotionId) {
        console.log("ok");
        item.checked = !item.checked;
      }
      return item
    });
    this.__data = data;
    console.log(data)
  }

  SaveAndNext(evt) {
    console.log("save")
    let data_promotions = this.__data.filter(item => {
      return item.checked;
    });

    if (data_promotions.length > 0) {
      this.saving = true;
      const id = this.__currentItem.records[0].Id.value;
      let listPromotionIds = [];
      let promotionIdList = [];
      data_promotions.map(item => {
        listPromotionIds.push({ promotionId: item.promotionId, orderItemId: id });
        promotionIdList.push(item.promotionId);
      })

      let data = { "data": listPromotionIds };

      console.log(data);
      // apply promotions
      const params2 = {
        input: '{"promotionIdList": ' + JSON.stringify(data) + ', "orderItemId":"' + id + '" }',
        sClassName: 'inwiB2C_OrderPromotionManagementOS',
        sMethodName: 'applyPromotions',
        options: '{}',
      };
      this._actionUtilClass
        .executeAction(params2, null, this, null, null)
        .then(response => {
          console.log("applyPromotions");
          console.log(response);
          //let dataAppliedPromotions = [...new Map(response.result.result.map((item, key) => [item[key], item])).values()];
          let dataAppliedPromotions = [];
          response.result.result.map(item => {
            const searchItem = dataAppliedPromotions.filter(item_ => item_.orderItemId == item.orderItemId && item_.promotionId == item.promotionId);
            if (searchItem.length == 0) dataAppliedPromotions.push(item);
          })
          console.log("dataAppliedPromotions");
          console.log(dataAppliedPromotions);
          let dataToApply = { "data": dataAppliedPromotions };

          const params = {
            input: '{"listPromotionIds": ' + JSON.stringify(dataToApply) + ', "orderItemId":"' + id + '" }',
            sClassName: 'inwib2c_promotion_functions',
            sMethodName: 'saveAppliedPromotions',
            options: '{}',
          };

          this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
              console.log("saveAppliedPromotions");
              console.log(response);
              this.saving = false;
              this.omniApplyCallResp({ data_promotions: dataAppliedPromotions });
              this.omniNextStep();
            })
            .catch(error => {
              this.saving = false;

              window.console.log(error);
            });

        })
        .catch(error => {
          this.saving = false;

          window.console.log(error);
        });



    } else {
      this.omniApplyCallResp({ data_promotions });
      this.omniNextStep();
    }


  }

  handleBack() {
    this.omniNavigateTo("Options");
  }

  render() {
    return template;
  }
}