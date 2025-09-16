import { LightningElement, api, track, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { BaseState } from "vlocity_cmt/baseState";


import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import temp from "./inwiB2C_InvoiceDisplay.html";

export default class InwiB2C_InvoiceDisplay extends BaseState(NavigationMixin(LightningElement)) {
    //export default class Inwi_CardList extends storyNormalState {


    @api records = [];
    @api columns ;
    @api titleStyle;
    @api targetObject;
    @track draftValues = [];

    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;


    @track col3 = [
        {fieldName: 'CaseNumber', label: 'Case Number', sortable : true},
        {fieldName: 'Status', label: 'Status'},
        {fieldName: 'Inwib2c_R_capitulatif__c', label: 'Subject'},
        {label: 'Voir détails', type: "button", typeAttributes: { label: "Voir Details", name: "view_details", title: 'Click to View Details'}}
        ];
    
        renderedCallback() {

    
          /*  console.log('befor sorting this.records: ');
            console.log(this.records);
    
         //   this.records.sortBy("invoicePaymentDueDate", "status");
    
            console.log('after sorting this.records: ');
            console.log(this.records);
    */
        }
    
    render(){

        return temp;

    }
    
      
    
    get columns2(){

      //  console.log(this.columns);
      //  console.log(JSON.stringify(this.records));

        return JSON.parse(this.columns);

        //return this.col3;

    }

    handleRowAction(event){
        

        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'view_details':
                console.log ('button clicked');
                console.log(row.Id);
                this.navigateToRecordPage('Case',row.Id );
                break;
            case 'view_Invoice':
                    console.log ('button view_Invoice clicked');
                    console.log(row.Id);
                    this.getInvoice(row.Id );
                    break;
            default:
                console.log('nothing');
                break;
        }


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

    // Used to sort the 'Date' column
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

    sortData(fieldName, sortDirection) {
        try {
            let sortResult = [...this.records]; // Same as Object.assign([], this.data)
            let parser = (v) => v;
            let column = this.columns2.find(c=>c.fieldName===fieldName);
            if(column.type==='date' || column.type==='datetime') {
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

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }
    
    getInvoice(invoiceId) {

        const b64toBlob = (b64Data, contentType='', sliceSize=512) => {
            const byteCharacters = atob(b64Data);
            const byteArrays = [];
          
            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
              const slice = byteCharacters.slice(offset, offset + sliceSize);
          
              const byteNumbers = new Array(slice.length);
              for (let i = 0; i < slice.length; i++) {
                byteNumbers[i] = slice.charCodeAt(i);
              }
          
              const byteArray = new Uint8Array(byteNumbers);
              byteArrays.push(byteArray);
            }
          
            const blob = new Blob(byteArrays, {type: contentType});
            return blob;
        }

        const showFile = function (blob, invoiceId){

            

            //console.log('in Show');
            var link = document.createElement('a');
            
            link.href = 'data:application/octet-stream;base64,' + blob;
            link.download= invoiceId +".pdf";
            link.click();
            
          }


        const params = {
            input: '{"invoiceId": "' + invoiceId +'"}',
            sClassName: 'inwiB2C_InvoiceIntegration',
            sMethodName: 'getInvoice',
            options: '{}',
        };

        console.log('before call apex1');
    
        this._actionUtilClass
            .executeAction(params, null, this, null, null)
            .then(response => {
                //console.log(JSON.stringify(response));
                if (response.result.pdf) {
                    showFile(response.result.pdf, invoiceId);
                }else {
                    console.log('Erreur lors de la récupération de la facture PDF');
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Erreur',
                        message: 'Erreur lors de la récupération de la facture PDF',
                        variant: 'error'
                        }),
                    );
                }


            })
            .catch(error => {
                window.console.log(error);
            });
    }
    
    
    
     
    }