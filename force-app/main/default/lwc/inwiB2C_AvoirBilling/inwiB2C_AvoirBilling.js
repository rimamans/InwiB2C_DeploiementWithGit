import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_AvoirBilling.html';

export default class inwiB2C_AvoirBilling extends OmniscriptBaseMixin(LightningElement) {


    stockeceddata = [];

    pickListvalues = [];
    pickListvalues2 = [];
   
    pickListValues3 = [{
        index:'1',
        option: 'Inférieur à'
    },
    {
        index:'2',
        option: 'Égal à'
    },
    {
        index:'3',
        option: 'Supérieur à'
    }
                    
];

    _records;
    @track date;
    @track status_value = "all";
    @api
    get records() {
        
        
        let t = JSON.parse(JSON.stringify(this._records));

        let temp = []

        for (var key in t) {
            temp.push(t[key]);
        }

        if (this._records.length != 0 && this.stockeceddata.length == 0) {
            this.stockeceddata = temp;

            this.pickListvalues = this.stockeceddata.map(element => {

                let v1 = {
                    "value": element.dateCreation,
                    "label": element.dateCreation
                }

                       return v1;


            })

            this.pickListvalues2 = this.stockeceddata.map(element => {
                let v2 = {
                    "value": element.amount,
                    "label": element.amount
                }
                return v2;
            })
            this.pickListValues3 = this.pickListValues3.map(element => {
            
              let v3 = {
                "value": element.option,
                "label": element.option
            }
            return v3;

            })

            let allElement = {
                "value": 'all',
                "label": 'Tout'
            }

            this.pickListvalues.unshift(allElement)
            this.pickListvalues2.unshift(allElement)
            this.pickListValues3.unshift(allElement)

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

        {fieldName: 'dateCreation', label: 'Date de l’avoir', hideDefaultActions: true, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},

        {fieldName: 'amount', label: 'Montant de l’avoir', hideDefaultActions: true , editable: false},
        {fieldName: 'facture', label: 'Facture associée à l’avoir', hideDefaultActions: true , editable: false}
    ];


    @track targetObject;
    @track draftValues = [];

    dateCreation='';

    amount = 0;

    //This one is just to get the amount inputed

    handleAmountChange(event) {
        this.amount = event.target.value;
    }

    amount_stat = '';

    //Here we get one of the options: tout, sup, inf, egal

    handleChangeState(event){
        this.amount_stat = event.target.value;
        return this.amount_stat
    }

    updateSearch(event) {

        //We add the timeZone at the end because the datePicker returns only the date YYYY-MM-DD and we cant compare it to the record data without that

        this.dateCreation= event.target.value+'Z';
        
        this.records = event.target.value == ''  ? this.stockeceddata : this.records;
    }
    
    max_amount = 1;
    min_amount = 0;
    obj = {}

    handleFilter(){

        //Check if the Dates is within the list of dates, if not we notifie the user by a popup

        try{
            const dates = this.stockeceddata.map(elem => elem.dateCreation);
            if(dates.includes(this.dateCreation.toString()) == false){
                if(this.dateCreation == '' || this.dateCreation == null){
                    this.records = this.stockeceddata
                    throw this.obj
                }
                else{
                    alert('Date not found')
                    this.records = this.stockeceddata
                    return this.records
                }
            }
            else{
                this.records = this.stockeceddata.filter(
                    row => {
                        return row.dateCreation == this.dateCreation
                    }
            )
           }
        }catch(err){
            if (err !== this.obj) throw err;
        }
       
        //We get the max and min of the list so we can filter over the range of the values

        this.max_amount = Math.max(...this.stockeceddata.map(elem => elem.amount))
        this.min_amount = Math.min(...this.stockeceddata.map(elem => elem.amount))
        
        // console.log('min: ', this.min_amount);
        // console.log('max: ', this.max_amount)
        

        if(this.amount == 0 || this.amount == null ){
            return this.stockeceddata
        }
        console.log(this.amount)
        let va = this.amount;

        if(this.amount_stat == 'Égal à'){
            if(this.amount >= this.min_amount && this.amount <= this.max_amount){
                    if(this.stockeceddata.map(elem => elem.amount).includes(parseInt(va)) == false){
                        alert("Couldn't find the amount")
                        this.records = this.stockeceddata
                        return this.records
                    }
                    else{
                            this.records = this.records.filter(
                                row => {
                                    return row.amount == this.amount
                                }
                            )
                    }
            }     
            else{
                this.records = this.stockeceddata
                return this.records
            }
        }
        else if(this.amount_stat == 'Supérieur à'){
            if(this.amount>this.max_amount){
                alert("You re over the range")
                this.records = this.stockeceddata
                return this.records
            }else{
                this.records = this.records.filter(
                    row => {
                        return row.amount >= this.amount
                    }
                )
            }   
        }
        else if(this.amount_stat == 'Inférieur à'){
            if(this.amount<this.min_amount){
                alert("You re over the range")
                this.records = this.stockeceddata
                return this.records
            }
            else{
                this.records = this.records.filter(
                    row => {
                        return row.amount <= this.amount
                    }
                )
            }       
        }
        else{
            this.records = this.stockeceddata
            return this.records
        }
    }
    
    render() {
        return template;
    }
}