import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';


export default class InwiB2C_SiteVulaFTTHD2D  extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    _ns = getNamespaceDotNotation();
    __idsite;
    @api
    get idsite() {
      return this.__idsite;
    }
    set idsite(value) {
      this.__idsite = value;
    }
    __orderid;
    @api
    get orderid() {
      return this.__orderid;
    }
    set orderid(value) {
      this.__orderid = value;
    }
    __canal;
    @api
    get canal() {
      return this.__canal;
    }
    set canal(value) {
      this.__canal = value;
    }
    addressinstallation;
    @api
    get addressinstallation() {
      return this.__addressinstallation;
    }
    set addressinstallation(value) {
      this.__addressinstallation = value;
    }
    __plaque;
    @api
    get plaque() {
      return this.__plaque;
    }
    set plaque(value) {
      this.__plaque = value;
    }
    __operateur
    @api
    get operateur() {
      return this.__operateur;
    }
    set operateur(value) {
      this.__operateur = value;
    }
    __portability
    @api
    get portability() {
      return this.__portability;
    }
    set portability(value) {
      this.__portability = value;
    }
    get isInwi() {
      this.__operateur === "INWI"
    }
    __typeaccess
    @api
    get typeaccess() {
      return this.__typeaccess;
    }
    set typeaccess(value) {
      this.__typeaccess = value;
    }
    __statutligne
    @api
    get statutligne() {
      return this.__statutligne;
    }
    set statutligne(value) {
      this.__statutligne = value;
    }
    get DisplayD2D() {
      return this.canal === "D2D";
    }
    @api selectedOption;

    // portabiliteOptions = [
    //   { label: 'Oui', value: 'Oui' },
    //   { label: 'Non', value: 'Non' }
    // ];
  
    connectedCallback() {
      console.log("canal", this.__canal);
      console.log("DisplayD2D", this.DisplayD2D);
      console.log("statutLigne", this.__statutligne);
      console.log("typeaccess", this.__typeaccess);
      console.log("portability", this.__portability);
      console.log("plaque", this.__plaque);
      console.log("operateur", this.__operateur);
      console.log("isinwi", this.isInwi);
    }

    updateAttributesSF() {
      console.log("updateAttributesSF tiggered");
      this._actionUtilClass = new OmniscriptActionCommonUtil();
      let input = '{"OrderId": "' + this.orderid + '","idSite": "' + this.idsite + '"}';
      const params = {
        input: input,
        sClassName: `${this._ns}IntegrationProcedureService`, 
        sMethodName: 'Inwi_inwiB2C_UpdateAttD2DVula', 
        options: '{}'
      };
      console.log('before call updateAttributeSF', JSON.stringify(params));
      this._actionUtilClass
        .executeAction(params, null, this, null, null)
          .then(response => {
            console.log("response updateAttributes", response);
            if (response.result) {
              this.goToNextStep();
            }
          })
          .catch(error => {
            console.log("error", error);
          })
    }
  
    goToNextStep() {
      this.omniNextStep();
    }



}