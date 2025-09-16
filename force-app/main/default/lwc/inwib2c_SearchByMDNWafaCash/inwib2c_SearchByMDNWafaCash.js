import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';


import template from './inwib2c_SearchByMDNWafaCash.html';

export default class Inwib2c_SearchByMDNWafaCash  extends OmniscriptBaseMixin(NavigationMixin(LightningElement)){
        @api m;
            handleVisibilityNextButton(){
        
        console.log("this.m:"+this.m)
        try {
            let searchButton = this.template.querySelector(`[data-theid="searche"]`);
            let mdnvalue = this.template.querySelector(`[data-theid="MDN"]`).value;
            console.log("MDNValue", mdnvalue);
            
            if(mdnvalue!='' && mdnvalue.length==12)
            searchButton.style.display = "block"
            else
            searchButton.style.display = "none"
    

        } catch (error) {
            console.log('error: '+error)
        }

    }


   
    handleMDNChange(e){
        this.handleVisibilityNextButton()

        let saveObj = {
            "mdnvalue" : e.detail.value
         } 
         this.omniUpdateDataJson(saveObj);
         this.omniSaveState(saveObj,true);
    }

    handleSearch(e){
        this.omniNextStep();
    }

    render(){
        return template;
    }
}