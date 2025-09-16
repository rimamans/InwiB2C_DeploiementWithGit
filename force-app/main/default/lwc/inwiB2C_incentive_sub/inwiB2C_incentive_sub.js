import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_incentive_sub.html';

export default class inwiB2C_incentive_sub extends OmniscriptBaseMixin(LightningElement) {

    
    
    
    __records;
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        this.__records = value ;  
        console.log('__records1' + JSON.stringify(this.__records));   
    }
    
  

    get isPropertiesEmpty(){

        if (this._properties && this._properties.length > 0) return true;
        else return false;
    }

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    @track columns =[

          //B-0875 RMA 07/05/2021 end
        
        {fieldName: 'Name', label: 'Incentive', hideDefaultActions: true,type :"text" , editable: false
        },
         {fieldName: 'MDN', label: 'MDN', hideDefaultActions: true,type :"text" , editable: false
         },
    
         {fieldName: 'Statut', label: 'Statut', hideDefaultActions: true, type :"text" , editable: false
         },
         {fieldName: 'Montant', label: 'Montant', hideDefaultActions: true,type :"currency", typeAttributes: { currencyCode: 'DHs' } , editable: false
         },
         {fieldName: 'DateEffet', label: 'Date d’effet', sortable: true,
        hideDefaultActions: true, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},
         {fieldName: 'Semaine', label: 'La semaine ', hideDefaultActions: true, type :"text" , editable: false}
         
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