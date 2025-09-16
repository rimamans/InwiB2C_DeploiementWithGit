import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_CreateServiceInfoFromSuB.html';

export default class inwiB2C_CreateServiceInfoFromSuB extends OmniscriptBaseMixin(LightningElement) {

    
    
    
    __records;
    __offereligible ;
    __offercible;
    @api
    get records() {
        return this.__records;
    }

    set records(value) {
        
        this.__records = value ;  

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
            
        {fieldName: 'adress', label: 'Adresse du site',type :"text" , editable: false?initialWidth: 90
    },
        
            {fieldName: 'CreationDate', label: 'Date de création',type :"Date" ,initialWidth: 100, editable: false
            },
            {fieldName: 'AdresseModifie', label: 'Adresse modifiée par IAM',type :"boolean" , editable: false,initialWidth: 50
            },
            {fieldName: 'AdressePropIAM', label: 'Addresse IAM',type :"text" , editable: false,initialWidth: 90,

            },
        
         ];

       

     
     







    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}