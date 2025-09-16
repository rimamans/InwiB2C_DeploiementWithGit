import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import template from "./inwiB2C_PanierMigrationCameleon.html";

export default class InwiB2C_PanierMigrationCameleon extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    __forfait;
    @api
    get forfait(){
        return this.__forfait;
    }
    set forfait(value){
        this.__forfait=value;
    }

    __prixoffre;
    @api
    get prixoffre(){
        return this.__prixoffre;
    }
    set prixoffre(value){
        this.__prixoffre=value;
    }

    __prixmigration;
    @api
    get prixmigration(){
        return this.__prixmigration;
    }
    set prixmigration(value){
        this.__prixmigration=value;
    }

    get cart() {
        let data = [];
        data.push({
            index: 1,
            itemname: "Total " +this.__forfait,
            price: this.__prixmigration,
            price_first_bill: this.__prixoffre,
            price_abonnement: this.__prixoffre,
            styleColor: "background-color: #D9D9D9;",
            
          });
        data.push({
            index: 2,
            itemname: this.__forfait,
            price: 0,
            price_first_bill: this.__prixoffre,
            price_abonnement: this.__prixoffre,
            
          });
        data.push({
            index: 3,
            itemname: "Frais additionnels",
            price: this.__prixmigration,
            price_first_bill: 0,
            price_abonnement: 0,
            
          });
          data.push({
            index: 4,
            itemname: "Total global",
            price: this.__prixmigration,
            price_first_bill: this.__prixoffre,
            price_abonnement: this.__prixoffre,
            styleColor: "background-color: #A846A9; color: white;",
          });
          return data;
      
    
      }

      Next(){
        this.omniNextStep();
      }

    render(){
        return template;
    }
}