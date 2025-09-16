import { LightningElement, api, track,wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import template from './inwiB2C_NavigateToRecord.html';

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class inwiB2C_NavigateToRecord  extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) 
{ 
   /*@api
    get accountid() {
        return this.__accountid;
    }
    set accountid(value) {
        this.__accountid = value;
    }  
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }

    Terminer() {
        console.log('in Terminer');
        // Generate a URL to a User record page
        let url ="/PortailPDVPhase2/s/account/"+ this.accountid;
        console.log('url',url);
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
                url: url,
            },
        },true)//then(generatedUrl => {
            //window.open(generatedUrl);
       // });
    
    }*/
    @api accountid;

    navigateToRecord() {

        let url = "/PortailPDVPhase2/s/account/" + this.accountid;
        console.log('url: ',url);
        this[NavigationMixin.Navigate]({
          type: "standard__webPage",
          attributes: {
            url: url
          }
        });
      }
    
  



}