import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayMessagePackDepannage.html';

export default class InwiB2C_DisplayMessagePackDepannage extends OmniscriptBaseMixin(LightningElement) {
  
  
    account_link 
    subNumber 
    typePack
    isBase = false
    Ellig = false
    __records;
    __profile;


   @api
   get profile() {
       
       return this.__profile;
   }

   set profile(value) {
       
       this.__profile = {...value};
        
     }
 

    @api
    get records() {
        
        return this.__records;
    }

    set records(value) {
        
        this.__records = {...value};
         
      }

      

    connectedCallback(){
        console.log('record ', this.__records )
        let t = JSON.parse(JSON.stringify(this.__records));
        console.log("t", t)
        let temp = Object.values(this.__records)
        console.log('tmp ', temp)
        console.log('profile' , this.__profile)

        this.Ellig = this.__records.Ellig

        console.log('test ', this.__records);
        if (this.__records.Ellig) {
            this.isBase = this.__records.Base;     
            let subid = this.__records.Base ? this.__records.SubscriptionId : this.__records.SubsBase
            this.typePack = this.__records.offre;
            this.subNumber = this.__records.Base ? this.__records.NumLigne : this.__records.NumBase
            if (this.__profile.ProfilUser === "Inwi POS") {
                this.account_link = `/PortailPDVPhase2/s/subscription/${subid}/view`;
            }else
            this.account_link = `/lightning/r/vlocity_cmt__Subscription__c/${subid}/view`;
              }
    }

    render() {

        //console.log(this.omniJsonData);
        return template;
    }


}