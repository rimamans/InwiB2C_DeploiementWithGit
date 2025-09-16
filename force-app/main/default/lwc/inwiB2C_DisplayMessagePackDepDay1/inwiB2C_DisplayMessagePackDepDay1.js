import { LightningElement, api, track, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_DisplayMessagePackDepDay1.html';

export default class InwiB2C_DisplayMessagePackDepDay1 extends OmniscriptBaseMixin(LightningElement) {__records;

    account_link 
    subNumber 
    show = false;
    subBase = false;
    typePack
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

        this.show = this.__records.show

        console.log('test ', this.__records);
        if (this.__records.show) {
            this.subBase = this.__records.isSubBase;
            this.typePack = this.__records.isSubBase ? this.__records.offreOrderIdar : this.__records.typePack
            let subid = this.__records.isSubBase ? this.__records.subscription : this.__records.SouscriptionDeBase
            this.subNumber = this.__records.isSubBase ? this.__records.NumSouscription : this.__records.NumSouscriptionBase
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