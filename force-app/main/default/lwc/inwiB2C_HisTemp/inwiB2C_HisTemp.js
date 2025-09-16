import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_HisTemp.html';

export default class inwiB2C_HisTemp extends OmniscriptBaseMixin(LightningElement) {

    
    
    
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



    @track columns =[

          //B-0875 RMA 07/05/2021 end
          {fieldName: 'mdn_princpl', label: 'MDN', hideDefaultActions: true,type :"text" , editable: false
    },
    {fieldName: 'action', label: 'Type de la demande', hideDefaultActions: true,type :"text" , editable: false
    },
     {fieldName: 'origine', label: 'Canal', hideDefaultActions: true, type :"text" , editable: false
    },
    {fieldName: 'mdn_tmp', label: 'Numéro temporaire', hideDefaultActions: true,type :"text" , editable: false
},
        {fieldName: 'date_of_demand', label: 'Date de la demande ', 
        hideDefaultActions: true, type: "date", typeAttributes:{
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }, editable: false},
      
    
    
       
         
         ];

   











    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}