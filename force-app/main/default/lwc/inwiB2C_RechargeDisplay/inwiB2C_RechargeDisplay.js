import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_RechargeDisplay.html';

export default class InwiB2C_RechargeDisplay extends OmniscriptBaseMixin(LightningElement) {


    stockeceddata = [];

    pickListvalues = [];
    pickListvalues2 = [];

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
                    "value": element.M_AMOUNT_CON,
                    "label": element.M_AMOUNT_CON
                }
                

               //       if(found)
                       return v1;


            })

            this.pickListvalues2 = this.stockeceddata.map(element => {
                let v2 = {
                    "value": element.M_TYPE,
                    "label": element.M_TYPE
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
            //   console.log('this.pickListvalues :')
            // console.log(this.pickListvalues)
            return temp;
        console.log('t :')
        console.log(t)


    }
    set records(value) {
        this._records = { ...value };
    }

    /*
            if(this.records.length != 0)
            pickListvalues = this._records.map(element => {
                let temp= [];
                temp.push({
                    'value':element.M_TYP,
                    'label':element.M_TYP
    
                });
                return temp;
            })
            
            if(this.stockeceddata.length != 0)
                pickListvalues = records.map(element => {
                    let temp= [];
                    temp.push({
                        'value':element.M_TYP,
                        'label':element.M_TYP
        
                    });
                    return temp;
                })
        
                this.stockeceddata = [...this.__records];
            }
            */




    @track columns = [

        { fieldName: 'M_AMOUNT_CON', label: 'Montant', hideDefaultActions: true, initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: '' } },
        { fieldName: 'M_CANAL', label: 'Canal', hideDefaultActions: true, initialWidth: 80 },
        { fieldName: 'M_TYPE', label: 'Type', hideDefaultActions: true, initialWidth: 220, type: 'text'},
        { fieldName: 'M_BAL_AFTER', label: 'Balance après Recharge', hideDefaultActions: true, initialWidth: 180, type: 'text'},
        { fieldName: 'M_BAL_TYPE', label: 'Compteur', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_VALIDITE_DATE', label: 'Date de Validité', hideDefaultActions: true, initialWidth: 140, type: "date" },
        { fieldName: 'M_BENEF_NUM', label: 'Numéro Béneficiaire', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_ORIGINE_NUM', label: 'Numéro d\'Origine', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_TRANSACTION_ID', label: 'Identifian Transaction', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_START_DATE', label: 'date de transaction', hideDefaultActions: true, initialWidth: 100, type: "date" },
        { fieldName: 'M_BAL_BEFORE', label: 'Balance avant Recharge', hideDefaultActions: true, initialWidth: 180, type: 'text' },
        { fieldName: 'M_SC_NUMBER', label: 'Numéro Scratch Card', hideDefaultActions: true, initialWidth: 180 },
        { fieldName: 'M_CODE_PROMO_ID', label: 'Code promo', hideDefaultActions: true, initialWidth: 180 }

    ];


    @track targetObject;
    @track draftValues = [];


    updateSearch(event) {
        console.log('event.target.value :' + event.target.value)

        let regex = new RegExp(event.target.value, 'gi')

        console.log('regex :' + regex)

        this.records = this.stockeceddata.filter(
            row => regex.test(row.M_AMOUNT_CON)
        );

        console.log('event.target.value == "" :')
        console.log(event.target.value == '')

        console.log('this.stockeceddata :')
        console.log(this.stockeceddata)

        //this.records = event.target.value == '' ? this.stockeceddata : this.records;
        this.records = (event.target.value == '' || event.target.value=='all') ? this.stockeceddata : this.records;
    }



    updateSearch2(event) {
        console.log('event.target.value :' + event.target.value)

        let regex = new RegExp(event.target.value, 'gi')

        console.log('regex :' + regex)

        this.records = this.stockeceddata.filter(
            row => regex.test(row.M_TYPE)
        );

        console.log('event.target.value == "" :')
        console.log(event.target.value == '')

        console.log('this.stockeceddata :')
        console.log(this.stockeceddata)

        //this.records = event.target.value == '' ? this.stockeceddata : this.records;
        this.records = (event.target.value == '' || event.target.value=='all') ? this.stockeceddata : this.records;
    }
    render() {

        console.log('this.records :');
        console.log(this.records);
        return template;
    }
}