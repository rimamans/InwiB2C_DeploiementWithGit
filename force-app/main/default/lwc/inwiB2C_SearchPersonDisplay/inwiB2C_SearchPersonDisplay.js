import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_SearchPersonDisplay.html';

export default class InwiB2C_SearchPersonDisplay extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    //@api recordsString ;
    //@api records = [];
    _records;
    _name;

    @track columns =[


        {fieldName: 'MDN', label: 'MDN', hideDefaultActions: true},
        {fieldName: 'LastName', label: 'Prénom', hideDefaultActions: true},
        {fieldName: 'FirstName', label: 'Nom', hideDefaultActions: true},
        {label: 'Selectionner', type: "button", typeAttributes: { label: "Selectionner", name: "balanceDetails", title: 'Selectionner'}}
    ];


   
    @track targetObject;
    @track draftValues = [];

    @api
    get records (){
        return this._records
    }
    set records (value){
        if (value ){
            this._records = value;
        }
    }

    @api
    get name(){
        return this._name;
    }
    set name (value){

        console.log(value);
        if (name){
            this._name = value;
        }
    }



    handleBlur(evt) {
        this.omniUpdateDataJson(evt.target.value);
    }

    render() {

        //console.log(this.omniJsonData);
        return template;
    }

    get records2 (){

        //let saveState = this.omniGetSaveState();

        //console.log(this.recordsString);

        let records = JSON.parse(this.recordsString);


        //console.log('in records2');
        
       if (records){
            //console.log(records);
            if (Array.isArray(records)){
                records.forEach((r,i) =>{
                    r.Id = i;
                })
                //console.log(records);
                return records;
            }else {
                let A = [];
                records.Id = 0;
                A.push(records);
                return A;
            }
        }

    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        
        console.log(JSON.stringify(this.omniJsonData));

        console.log(JSON.stringify(this.omniJsonDef));
        
        console.log(JSON.stringify(row));

        console.log(JSON.stringify(this.omniGetSaveState()));

        this.omniUpdateDataJson(row);

        this.omniSaveState(row, true);

        console.log('AccountID' + row.AccountId);

        console.log('before next');

        this.navigateToRecordPage('Account', row.AccountId);

        this.omniNextStep();



        

        

        

        /*switch (action.name) {
            case 'show_details':
                alert('Showing Details: ' + JSON.stringify(row));
                break;
            case 'delete':
                const rows = this.data;
                const rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                this.data = rows;
                break;
            }*/
        
    }

    navigateToRecordPage(sObject, recordId) {
        console.log(recordId);
     
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }




}