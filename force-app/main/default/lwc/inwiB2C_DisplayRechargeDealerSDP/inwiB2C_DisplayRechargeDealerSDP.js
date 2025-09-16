import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_DisplayRechargeDealerSDP.html";

export default class inwiB2C_DisplayRechargeDealerSDP extends OmniscriptBaseMixin(
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
    
    if(this.stockeddata!=null){
      let data = JSON.parse(JSON.stringify(this._records));
      this.stockeddata = [];
    
      
      this.stockeddata = data.filter(function(e) {
        return e.M_TYPE_RECHARGE == 'Self-recharge' ||  e.M_TYPE_RECHARGE == 'Transfert' ||  e.M_TYPE_RECHARGE == 'Recharge' ;
      });
     /* for (let i = 0; i < this.stockeddata.length; i++) {
  
        // Récupérez la valeur actuelle de l'attribut "M_DATE"
        let currentMDate = this.stockeddata[i].M_DATE;
        
        // Convertissez la chaîne en une date JavaScript
        let date = new Date(currentMDate.slice(0, 4), currentMDate.slice(4, 6) - 1, currentMDate.slice(6, 8), currentMDate.slice(8, 10), currentMDate.slice(10, 12), currentMDate.slice(12, 14));
        
        // Formatez la date dans le format YYYY-MM-dd HH:MM:SS
        let formattedDate = date.getFullYear() + "-" + ('0' + (date.getMonth() + 1)).slice(-2) + "-" + ('0' + date.getDate()).slice(-2) + " " + ('0' + date.getHours()).slice(-2) + ":" + ('0' + date.getMinutes()).slice(-2) + ":" + ('0' + date.getSeconds()).slice(-2);
        
        // Mettez à jour la valeur de l'attribut "M_DATE"
        this.stockeddata[i].M_DATE = formattedDate;
      }*/
    
    }
     
     
 
    console.log('this.stockeddata',this.stockeddata);
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
      }
      
      );

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

  connectedCallback(){
  
  }

  filterStockeddata() {
    const _value = this.search;
    console.log("<stockeddata == ", _value);
    let data = JSON.parse(JSON.stringify(this._records));
    //let data=this.stockeddata;
    let data1=[];
    data1 = data.filter(function(e) {
      return e.M_TYPE_RECHARGE == 'Self-recharge' ||  e.M_TYPE_RECHARGE == 'Transfert' ||  e.M_TYPE_RECHARGE == 'Recharge';

    });

    this.stockeddata = [];
    if (_value) {
      let filtreddata = [];
      filtreddata = data1.filter(function(e) {
        return  e.M_MONTANT_RECH == _value || _value == "all";
      });
      console.log("filtreddata --- > ", filtreddata.length);
      console.log(JSON.stringify(filtreddata));
      this.stockeddata =  JSON.parse(JSON.stringify(filtreddata));
    // let dataDate=[];
    //  dataDate=this.stockeddata;
     /*  for (var i = 0; i < data.length; i++) {
         // Extraire les parties de la chaîne de caractères
         var year = dataDate[i].M_DATE.substring(0, 4);
         var month = dataDate[i].M_DATE.substring(4, 6);
         var day = dataDate[i].M_DATE.substring(6, 8);
         var hours = dataDate[i].M_DATE.substring(8, 10);
         var minutes = dataDate[i].M_DATE.substring(10, 12);
         var seconds = dataDate[i].M_DATE.substring(12, 14);
    
         // Créer une nouvelle date avec le format souhaité
         var newDate = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
    
         // Mettre à jour la valeur de l'attribut M_DATE
         dataDate[i].M_DATE = newDate;
       
       }
       this.stockeddata=[];
       this.stockeddata=dataDate;*/
       for (let i = 0; i < this.stockeddata.length; i++) {
  
        // Récupérez la valeur actuelle de l'attribut "M_DATE"
        let currentMDate = this.stockeddata[i].M_DATE;
        
        // Convertissez la chaîne en une date JavaScript
        let date = new Date(currentMDate.slice(0, 4), currentMDate.slice(4, 6) - 1, currentMDate.slice(6, 8), currentMDate.slice(8, 10), currentMDate.slice(10, 12), currentMDate.slice(12, 14));
        
        // Formatez la date dans le format YYYY-MM-dd HH:MM:SS
        let formattedDate = date.getFullYear() + "-" + ('0' + (date.getMonth() + 1)).slice(-2) + "-" + ('0' + date.getDate()).slice(-2) + " " + ('0' + date.getHours()).slice(-2) + ":" + ('0' + date.getMinutes()).slice(-2) + ":" + ('0' + date.getSeconds()).slice(-2);
        
        // Mettez à jour la valeur de l'attribut "M_DATE"
        this.stockeddata[i].M_DATE = formattedDate;
      }
      
    
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
      fieldName: "M_BENEF_NUM",
      label: "MDN bénéficiaire",
      hideDefaultActions: true,
    },
    {
      fieldName: "M_TYPE_RECHARGE",
      label: "Type recharge",
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