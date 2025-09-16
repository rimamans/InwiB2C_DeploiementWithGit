import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplaySubscriptionsEligiblesFromAccount.html';

export default class inwiB2C_DisplaySubscriptionsEligiblesFromAccount extends OmniscriptBaseMixin(LightningElement) {

    
    
    
    __records;

    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.loading = false;
        console.log("value =", JSON.stringify(value));
        this.__records =
          value &&
          value.map((row, index) => {
            console.log('ProfilUser :', row.ProfilUser );
            if(row.ProfilUser === "Inwi POS"){
                let account_link = `/PortailPDVPhase2/s/subscription/${row.Id}/view`;
                return { ...row, account_link, index: index + 1 };
              
            }
            let account_link = `/lightning/r/vlocity_cmt__Subscription__c/${row.Id}/view`;
            return { ...row, account_link, index: index + 1 };

           
          });
        console.log("__records1" + JSON.stringify(this.__records));
      }


    get isPropertiesEmpty(){

        if (this._properties && this._properties.length > 0) return true;
        else return false;
    }

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    @track columns =[
        {
            label: "Souscriptions éligibles",
            fieldName: "account_link",
            type: "url",
            typeAttributes: {
              label: {
                fieldName: "Inwib2c_Num_ro_de_la_ligne__c",
              },
              target: "_blank",
            },
          },
         ];

         sortBy(field, reverse, primer) {
            const key = primer
                ? function(x) {
                      return primer(x[field]);
                  }
                : function(x) {
                      return x[field];
                  };
    
            return function(a, b) {
                a = key(a);
                b = key(b);
                return reverse * ((a > b) - (b > a));
            };
        }
    
        onHandleSort(event) {
            console.log('start onHandleSort : ');
    try {
    
        const { fieldName: sortedBy, sortDirection } = event.detail;
    
        console.log('-this.sortData(sortedBy, sortDirection);');
        this.sortData(sortedBy, sortDirection);
    
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
        console.log('end onHandleSort : ');
    
    } catch (error) {
        console.log(error);
    
    }
    
        }
        handleRowAction(event) {
            const action = event.detail.action;
            const row = event.detail.row;
            
            this.usageData = row.usages;
    
            this.openmodal();
            
        }
        sortData(fieldName, sortDirection) {
            try {
                let sortResult = [...this.records]; // Same as Object.assign([], this.data)
                let parser = (v) => v;
                let column = this.columns2.find(c=>c.fieldName===fieldName);
                if(column.type==='date' || column.type==='date') {
                    parser = (v) => (v && new Date(v));
                }
                let sortMult = sortDirection === 'asc'? 1: -1;
                this.records = sortResult.sort((a,b) => {
                    let a1 = parser(a[fieldName]), b1 = parser(b[fieldName]);
                    let r1 = a1 < b1, r2 = a1 === b1;
                    return r2? 0: r1? -sortMult: sortMult;
                });     
            } catch (error) {
                console.log(error);
                    }
    
        }   








    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}