import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from 'lightning/navigation';
import template from "./inwiB2C_InfosWorkOrder.html";
export default class InwiB2C_InfosWorkOrder extends OmniscriptBaseMixin(LightningElement) 
{
    _records;
    wodata = [];
    todata = [];
    todata1 = [];
    stocks = [];
    // displayOngletworkorder;
    @track dataStocks=[];
    @api
    get records() {
      console.log("<records");
      console.log('Recordss',this._records);
      return this._records;
    }

    set records(value) {
        console.log("set records");
        let input = JSON.parse(JSON.stringify(value));
        this._records = JSON.parse(JSON.stringify(input?input.map((e,index)=>{
          e.index = index;
          return e;
        }):input));
        
    this.wodata = JSON.parse(JSON.stringify(this._records));
    console.log('stocked',this.wodata);
    // this.displayOngletworkorder = this.wodata[0].typeOffre;
    // const isdisplay = this.displayOngletworkorder === "FTTH" ? true : false;

    //     console.log('TYPEOFFER',this.displayOngletworkorder);
    
    this.todata = JSON.parse(JSON.stringify(this.wodata?this.wodata.map((e,index)=>{
        e.index = index;
        this.todata1 = e.wot.map((i,index) => {
            i.index = index;
            this.stocks.push(i);
            return i;
        });

        return e;
      }):this.wodata));
      console.log('taskorders',this.stocks);
      this.dataStocks=this.stocks;
      console.log('dataStocks',this.dataStocks);
    // var array = [];
    // for(var key in this.wodata){
    // array.push(this.wodata[key]);
    // array = array.slice(1,2);
    // }

    // console.log('arraylimit',array);
    // this.wodata = JSON.parse(JSON.stringify(array)); 
    // console.log('arraylimit',array);
    }

    

    

      get picklistvalues() {
        console.log("<picklistvalues");
        let data = [];
        const filtereddata = [].concat(this._records);
        if (filtereddata.length > 0) {
          data = filtereddata.map(element=> {
            let v1 = {
              value: element.number,
              label: element.number
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

      @track
      workordercolumns = [
      {
        fieldName: "number",
        label: "Numero WO",
        hideDefaultActions: true
      },
      {
        fieldName: "state",
        label: "Etat",
        hideDefaultActions: true
      },
      {
        fieldName: "openedAt",
        label: "Ouvert le",
        hideDefaultActions: true
      },
      {
        fieldName: "assignementGroup",
        label: "Groupe affectation",
        hideDefaultActions: true
      },
      {
        fieldName: "qualificationGroup",
        label: "Groupe qualification",
        hideDefaultActions: true
      },
      {
        fieldName: "",
        label: "Callback WO CRM statut",
        hideDefaultActions: true
      },
      {
        fieldName: "validBilling",
        label: "Facturation validée",
        hideDefaultActions: true
      },
      {
        fieldName: "shortDescription",
        label: "Breve description",
        hideDefaultActions: true
      },
      {
        fieldName: "",
        label: "Description",
        hideDefaultActions: true
      },
      {
        fieldName: "",
        label: "Note de travail",
        hideDefaultActions: true
      }
    ];

    @track
    taskordercolumns = [
    {
      fieldName: "number",
      label: "Numero TO",
      hideDefaultActions: true
    },
    {
      fieldName: "nraPlaque",
      label: "NRA/Plaque",
      hideDefaultActions: true
    },
    {
      fieldName: "assignementGroup",
      label: "Groupe affectation",
      hideDefaultActions: true
    },
    {
      fieldName: "orderId",
      label: "code transaction",
      hideDefaultActions: true
    },
    {
      fieldName: "createdOn",
      label: "Créé le",
      hideDefaultActions: true
    },
    {
      fieldName: "planificationStatus",
      label: "Statut de la panification",
      hideDefaultActions: true
    },
    {
      fieldName: "vmBlockingReason",
      label: "Motif de blocage",
      hideDefaultActions: true
    },
    {
      fieldName: "shortDescription",
      label: "Brève description",
      hideDefaultActions: true
    },
    {
      fieldName: "",
      label: "Modèle",
      hideDefaultActions: true
    },
    {
      fieldName: "state",
      label: "Etat",
      hideDefaultActions: true
    },
    {
        fieldName: "createdBy",
        label: "Créé par",
        hideDefaultActions: true
      }
  ];

    connectedCallback() {
        console.log("records2",this._records);
        // console.log("records3",records);
        console.log('taskorders1',this.stocks);
    } 

    render() {
        console.log("records",this._records);
        return template;
    }
}