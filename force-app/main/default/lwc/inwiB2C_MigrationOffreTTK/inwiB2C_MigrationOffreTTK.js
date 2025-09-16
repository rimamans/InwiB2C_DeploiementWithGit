import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_MigrationOffreTTK.html";
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';


export default class InwiB2C_MigrationOffreTTK extends OmniscriptBaseMixin(
    LightningElement
  ) {
    @track choixdisponible;
    @api balance;
    options=null;
    Changed=false;
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    getoptions() {
        if ((this.balance>0 && this.balance<5)) {
            return [
                { label: "Maintien Solde en Dh", value: "0" },
            ];
        }else if ((this.balance>=20 && this.balance<999999)){
            return [
                { label: "Promo Data *3", value: "3" },
                { label: "Promo Voix *1", value: "1" },
                { label: "Promo International *4", value: "4" },
           ];
        }else if((this.balance>=5 && this.balance<999999)){
           
           return [
            { label: "Promo Data *3", value: "3" },
            { label: "Promo Voix *1", value: "1"},
        ];
       }    

}


ChangeMenuEvent(event) {
    let choix = event.detail.value;
    this.Changed = true;


    this.omniUpdateDataJson(choix);
    this.omniSaveState(choix, true);
  }
  handleSave(event){
    this.omniNextStep();

  }
connectedCallback(){
    this.options = this.getoptions();
    this._actionUtilClass = new OmniscriptActionCommonUtil();
}

 render() {
 
    return template;
  }
}