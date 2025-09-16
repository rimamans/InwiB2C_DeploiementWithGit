import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_HisTransfert_recu.html';

export default class inwiB2C_HisTransfert_recu extends OmniscriptBaseMixin(LightningElement) {


    _properties = [];

    type = 'Transfert de solde';
    __records;
    @api
    get records() {

        return this.__records;
    }
    set records(value) {
        this.__records = value;
        console.log('__records1' + JSON.stringify(this.__records));
    }


 

    get propreties() {
        try {
            console.log('__records' + JSON.stringify(this.__records));

            if (this.__records) {
                let history = JSON.parse(JSON.stringify(this.__records));
                console.log('history' + JSON.stringify(history));
                this._properties = history.map(migration => {
                    migration.properties['type']='transfert de solde';
                    return migration.properties;
                });
                console.log(JSON.stringify(this._properties));
                return this._properties;
            } else {
                return [];
            }
        } catch (error) {
            console.log('error: ' + error);
            return [];

        }
    }

    get isPropertiesEmpty() {

        if (this._properties && this._properties.length > 0) return true;
        else return false;
    }

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    @track columns = [

        //B-0875 RMA 07/05/2021 end
        {
            fieldName: 'M_DATE', label: 'Date/heure de transaction', sortable: true,
            hideDefaultActions: true, type: "date", typeAttributes: {
                year: "numeric",
                month: "2-digit",
                day: "2-digit"
            }, editable: false
        },
        {
            fieldName: 'MDN_SRC', label: 'Mdn d’origine', hideDefaultActions: true, type: "text", editable: false
        },
        {fieldName: 'M_MONTANT_CREDIT', label: 'Montant transféré', hideDefaultActions: true, initialWidth: 180,type: 'currency', typeAttributes: { currencyCode: 'DHs' }}

      //  { fieldName: 'M_MONTANT_CREDIT', label: 'Montant transféré en DHs', hideDefaultActions: true, type: "text", editable: false }
       
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









    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}