import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_DisplayRechargeDealer.html";

export default class inwiB2C_DisplayRechargeDealer extends OmniscriptBaseMixin(
  LightningElement
) {
  _records;
  search = 'all';
  stockeddata = [];

  @api
  get records() {
    console.log("<records");
    return this._records;
  }

  set records(value) {
    console.log("set records");
    let input = JSON.parse(JSON.stringify(value));
    this._records = JSON.parse(JSON.stringify(input?input.map((e,index)=>{
      e.index = index;
      return e;
    }):input));
    this.stockeddata = JSON.parse(JSON.stringify(this._records));
  }

  get picklistvalues() {
    console.log("<picklistvalues");
    let data = [];
    const filtereddata = [].concat(this._records);
    if (filtereddata.length > 0) {
      data = filtereddata.map(element => {
        let v1 = {
          value: element.M_MONTANT_RECH,
          label: element.M_MONTANT_RECH,
        };
        return v1;
      });

      let allElement = {
        value: "all",
        label: "Tout",
      };

      data.unshift(allElement);

      data = data.filter(
        (thing, index, self) =>
          index ===
          self.findIndex(
            t => t.value === thing.value && t.label === thing.label
          )
      );
    }

    return data;
  }

  filterStockeddata() {
    const _value = this.search;
    console.log("<stockeddata == ", _value);
    let data = JSON.parse(JSON.stringify(this._records));
    this.stockeddata = [];
    if (_value) {
      let filtreddata = [];
      filtreddata = data.filter(function(e) {
        return e.M_MONTANT_RECH == _value || _value == "all";
      });
      console.log("filtreddata --- > ", filtreddata.length);
      console.log(JSON.stringify(filtreddata));
      this.stockeddata =  JSON.parse(JSON.stringify(filtreddata));
    }else{

      console.log("data", data.length);
      //console.log(data);
      this.stockeddata =  data;
    }

    
  }

  // set search(value) {
  //   console.log("<search == ", value);
  //   if (this._records && this._records.length > 0) {
  //     if (value) {
  //       console.log("inside if");
  //       let data = [].concat(this._records);
  //       let filtereddata = [];
  //       filtereddata = data.filter(function(e) {
  //         return e.M_MONTANT_RECH == value || value == "all";
  //       });

  //       this.stocked_data = filtereddata;
  //     } else {
  //       this.stocked_data = [].concat(this._records);
  //     }
  //     console.log("data", this.stocked_data.length);
  //     console.log(this.stocked_data);
  //   }
  // }

  @track
  columns = [
    {
      fieldName: "M_LINE_ID",
      label: "MDN bénéficiaire ",
      hideDefaultActions: true,
    },
    {
      fieldName: "M_MONTANT_RECH",
      label: "Prix",
      hideDefaultActions: true,
      type: "currency",
      typeAttributes: { currencyCode: "MAD" },
    },
    {
      fieldName: "M_DATE",
      label: "Date/heure de transaction",
      hideDefaultActions: true,
    },
  ];

  @track targetObject;
  @track draftValues = [];

  updateSearch(event) {
    console.log("event.target.value :" + event.target.value);
    this.search = event.target.value;
    this.filterStockeddata();
  }

  render() {
    console.log("render");
    return template;
  }

  renderedCallback() {
    //console.log("renderedCallback = ", this.stockeddata.length);

    // if (!this.search && this._records && this._records.length > 0)
    //   this.search = "all";
  }
}