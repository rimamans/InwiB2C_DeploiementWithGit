import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_Achat_Pass.html';

export default class inwiB2C_Achat_Pass extends OmniscriptBaseMixin(LightningElement) {

    stockeceddata = [];
    pickListvalues = [];
    pickListvalues2 = [];
    pickListvalues3 = [];
    ballist=[];
    _records;
    

 
    @api
    get records() {
        let t = JSON.parse(JSON.stringify(this._records));
     //   let bal = JSON.parse(JSON.stringify(this._listbal));
       // console.log('ballist'+listbal);




        console.log('this.stockeceddata :')
        console.log(this.stockeceddata)
        let temp = []

        for (var key in t) {
            temp.push(t[key]);
        }



        if (this._records.length != 0 && this.stockeceddata.length == 0) {
            this.stockeceddata = temp;
            this.pickListvalues = this.stockeceddata.map(element => {
                let v1 = {
                    "value": element.M_AMOUNT_CON,
                    "label": element.M_AMOUNT_CON
                }
                return v1;
            })





            this.pickListvalues2 = this.stockeceddata.map(element => {
                let v2 = {
                    "value": element.Canal_Achat,
                    "label": element.Canal_Achat
                }
                return v2;
            })


            let allElement = {
                "value": 'all',
                "label": 'Tout'
            }


            this.pickListvalues.unshift(allElement)
            this.pickListvalues2.unshift(allElement)


            this.pickListvalues = this.pickListvalues.filter((thing, index, self) =>
                index === self.findIndex((t) => (
                    t.value === thing.value && t.label === thing.label
                ))
            )


            this.pickListvalues2 = this.pickListvalues2.filter((thing, index, self) =>
                index === self.findIndex((t) => (
                    t.value === thing.value && t.label === thing.label
                ))
            )


        }





        if (temp.length != 0)

            return temp;
        console.log('t :')
        console.log(t)



    }






    set records(value) {
        this._records = { ...value };
    }
    @track columns = [

        { fieldName: 'M_AMOUNT_CON', label: 'Prix', hideDefaultActions: true, initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: 'MAD' } },
        { fieldName: 'M_START_DATE', label: 'Date/heure de transaction', hideDefaultActions: true, initialWidth: 120 },
        { fieldName: 'M_VOLUM_DATA', label: 'Volume Data', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_DUREE_PASS', label: 'Validité du PASS', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_SERVICE_NAME', label: 'Libellé ', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: "M_SERVICE_NAME", label: "Service", hideDefaultActions: true },
        {
          label: "Balances",
          type: "button",
          initialWidth: 120,
          typeAttributes: {
            label: "Balances",
            name: "balanceDetails",
            title: "Cliquer ici pour le détail des balances",
          },
        }
    ];




    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
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

    sortData(fieldName, sortDirection) {
        try {
            let sortResult = [...this.records]; // Same as Object.assign([], this.data)
            let parser = (v) => v;
            let column = this.columns2.find(c => c.fieldName === fieldName);
            if (column.type === 'date' || column.type === 'datetime') {
                parser = (v) => (v && new Date(v));
            }
            let sortMult = sortDirection === 'asc' ? 1 : -1;
            this.records = sortResult.sort((a, b) => {
                let a1 = parser(a[fieldName]), b1 = parser(b[fieldName]);
                let r1 = a1 < b1, r2 = a1 === b1;
                return r2 ? 0 : r1 ? -sortMult : sortMult;
            });
        } catch (error) {
            console.log(error);
        }

    }






    @track targetObject;
    @track draftValues = [];


    updateSearch(event) {
        console.log('event.target.value :' + event.target.value)

    
            let regex = new RegExp(event.target.value, 'gi')
            this.records = this.stockeceddata.filter(
                row => regex.test(row.M_AMOUNT_CON)
            );
            this.records = (event.target.value == '' || event.target.value=='all') ? this.stockeceddata : this.records;
        
    }




    updateSearch2(event) {
        console.log('event.target.value :' + event.target.value)

        let regex = new RegExp(event.target.value, 'gi')
        this.records = this.stockeceddata.filter(
            row => regex.test(row.Canal_Achat)
        );

        this.records = (event.target.value == '' || event.target.value=='all') ? this.stockeceddata : this.records;
    }
    @track openBalanceDetail = false;
    openmodal(event) {
      this.openBalanceDetail = true;
      const row=event.detail.row;
      console.log("row"+row);

      this.ballist=row.listbal;
      console.log("this.ballist"+this.ballist);

    }
    closeModal() {
      this.openBalanceDetail = false;
    }
  
      displayRecapBalance() {
        const actionName = 'balance';  

        this.openmodalRecap();
      }
      handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
    
        this.listBalData = row.M_LISTEBAL;
    
        this.openmodal();
      }

      @track listbal = [];
      @track
      listBalColumns = [
        {
          fieldName: "name",
          label: "Nom de la balance",
          hideDefaultActions: true,
        },
        //B-0776 DLE 09/02/2021 BEGIN
        // {fieldName: 'balAmount', label: 'Montant', hideDefaultActions: true, type: 'currency', typeAttributes: { currencyCode: 'MAD' }},
        { fieldName: "value", label: "Montant", hideDefaultActions: true },
        //B-0776 DLE 09/02/2021 END
      ];
    
    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}