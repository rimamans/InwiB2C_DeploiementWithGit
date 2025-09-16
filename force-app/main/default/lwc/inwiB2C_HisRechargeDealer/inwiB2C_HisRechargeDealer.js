import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_HisRechargeDealer.html';

export default class inwiB2C_HisRechargeDealer extends OmniscriptBaseMixin(LightningElement) {

    stockeceddata = [];
    pickListvalues = [];
    pickListvalues2 = [];
    pickListvalues3 = [];

    _records;

    @api
    get records() {
        let t = JSON.parse(JSON.stringify(this._records));



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
                    "value": element.M_MONTANT_RECH,
                    "label": element.M_MONTANT_RECH
                }
                return v1;
            })





             //  this.pickListvalues2 = this.stockeceddata.map(element => {
             //      let v2 = {
             //         "value": element.Type,
             //        "label": element.Type
             //   }
             //   return v2;
             //})


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
        { fieldName: 'M_LINE_ID', label: 'MDN bénéficiaire ', hideDefaultActions: true},
        { fieldName: 'M_MONTANT_RECH', label: 'Prix', hideDefaultActions: true, type: 'currency', typeAttributes: { currencyCode: 'MAD' } },
        { fieldName: 'M_DATE', label: 'Date/heure de transaction', hideDefaultActions: true }
    
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
                row => regex.test(row.M_MONTANT_RECH)
            );
            this.records = (event.target.value == '' || event.target.value=='all') ? this.stockeceddata : this.records;
        
    }




    updateSearch2(event) {
        console.log('event.target.value :' + event.target.value)

        let regex = new RegExp(event.target.value, 'gi')
        this.records = this.stockeceddata.filter(
            row => regex.test(row.Type)
        );

        this.records = (event.target.value == '' || event.target.value=='all') ? this.stockeceddata : this.records;
    }

    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}