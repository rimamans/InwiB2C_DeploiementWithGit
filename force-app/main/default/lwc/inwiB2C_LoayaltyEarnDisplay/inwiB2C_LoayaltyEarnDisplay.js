import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_LoayaltyEarnDisplay.html';

export default class InwiB2C_LoayaltyEarnDisplay extends OmniscriptBaseMixin(LightningElement) {

    @api records;

    @track columns =[

        {fieldName: 'id', label: 'Id Transaction', hideDefaultActions: true , initialWidth: 200, editable: false},
        {fieldName: 'section', label: 'Section', hideDefaultActions: true , editable: false},
        {fieldName: 'quantity', label: 'Nombre de Points', hideDefaultActions: true,initialWidth: 100, type :"number" , editable: false, typeAttributes: {
            minimumFractionDigits: "2"
        }},
        {fieldName: 'startDateTime', label: 'Date début', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},
        {fieldName: 'endDateTime', label: 'Date fin', hideDefaultActions: true,initialWidth: 200, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false}
         ];

   /*        convertDate(ddMMyyyy_Date){

            let yyyyMMdd_Date = ddMMyyyy_Date.substring(6,10) 
                        +'-'+ ddMMyyyy_Date.substring(3,5)
                        +'-'+ ddMMyyyy_Date.substring(0,2);

           let day = ddMMyyyy_Date.substring(0,2);
            let month = ddMMyyyy_Date.substring(3,5);
            let year = ddMMyyyy_Date.substring(6,10);

            let yyyyMMdd_Date = year +'-'+ month+'-'+ day;
           console.log('day: ' + day);
            console.log('month: ' + month);
            console.log('year: ' + year);

            console.log('input  Date: ' + ddMMyyyy_Date);
            console.log('output Date: ' + yyyyMMdd_Date);

            return yyyyMMdd_Date;
         }*/

get loyaltyTransaction () {

       
    if (this.omniJsonData && this.omniJsonData.result && this.omniJsonData.result.loyaltyTransaction){
        return this.omniJsonData.result.loyaltyTransaction;
    }
        else return [];
    }



    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}