import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayOffersEligiblesFromSubscription.html';

export default class inwiB2C_DisplayOffersEligiblesFromSubscription extends OmniscriptBaseMixin(LightningElement) {

    
    
    
    __records;
    __offereligible ;
    __offercible;
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
            console.log('typePos:', row.TypePos);
            if(row.ProfilUser === "Inwi POS"){
                let account_link = `/PortailPDVPhase2/s/inwib2c-offre-ciblee/${row.offerId}/view`;
                return { ...row, account_link, index: index + 1 };
              
            }
            let account_link = `/lightning/r/InwiB2C_offre_ciblee__c/${row.offerId}/view`;
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
            label: "offre",
            fieldName: "account_link",
            type: "url",
            typeAttributes: {
              label: {
                fieldName: "Name",
              },
              target: "_blank",
            },
          },
        {fieldName: 'InwiB2C_Date_debut__c', label: 'Date de debut',type :"Date" , editable: false
        },
        {fieldName: 'InwiB2C_Date_fin__c', label: 'Date de fin',type :"Date" , editable: false
        }
         ];

         @api
         get offereligible() {
             return this.__offereligible;
         }
     
         set offereligible(value) {
             this.__offereligible = value ;  
             //console.log('__records1' + JSON.stringify(this.__records));   
             console.log('offer'+this.__offereligible ); 
         }
         

         @api
         get offercible() {
             return this.__offercible;
         }
     
         set offercible(value) {
             this.__offercible = value ;  
             console.log('offer'+this.__offercible ); 
         }
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