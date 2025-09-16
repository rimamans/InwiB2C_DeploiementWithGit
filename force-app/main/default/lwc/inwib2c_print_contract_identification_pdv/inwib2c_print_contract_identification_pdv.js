import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_print_contract_identification_pdv.html";


export default class Inwib2c_print_contract_identification_pdv extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    __data;
    __userdata;
    @api
    get userdata() {
        return this.__userdata;
    }
    set userdata(value) {
        this.__userdata = JSON.parse(JSON.stringify(value));
    }

    __link;
    @api
    get link() {
        return this.__link;
    }
    set link(value) {
        this.__link = value;
    }

    __isdealer;
    @api
    get isdealer() {
        return this.__isdealer;
    }
    set isdealer(value) {
        this.__isdealer = value;
    }

      __usernamedeanimateur;
    @api
    get usernamedeanimateur() {
        return this.__usernamedeanimateur;
    }
    set usernamedeanimateur(value) {
        this.__usernamedeanimateur= value;
    }




    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
    }

    generateData() { // addressDealer
        console.log(JSON.stringify(this.__userdata))

        const address = this.__isdealer ? this.__userdata.addressDealer : this.__userdata.address;
        const city = this.__isdealer ? this.__userdata.AddressesManagment.CityName : this.__userdata.dependentValues.CityName;
        this.__data = {
            TitulaireCompte: this.__isdealer ? this.__userdata.civility : this.__userdata.civility,
            NomTitulaire: this.__isdealer ? this.__userdata.NomDealer : this.__userdata.lastName,
            PrenomTitulaire: this.__isdealer ? this.__userdata.PrenomDealer : this.__userdata.firstName,
            NumIdentifiant: this.__isdealer ? this.__userdata.cinDealer : this.__userdata.theId,
            TypeIdent: this.__isdealer ? this.__userdata.typeCINDealer : this.__userdata.TypeCIN,
            getFullAddress: address + " " + city,
            Ville: city,
            CodePostal: this.__isdealer ? this.__userdata.CodePostal : this.__userdata.CodePostal,
            dateNaissance: this.__isdealer ? this.__userdata.born : this.__userdata.born,
            Email: this.__isdealer ? this.__userdata.mail : this.__userdata.mail,
            NumContact: this.__isdealer ? this.__userdata.telephone : this.__userdata.telephone,

           // H-M Ajouter dans le cadre de la MC-MGEN3767-contrat dealer phase 1 Begin 
            TypeContratDoc: this.__isdealer ? "Dealer" : "Prépayé",
            UserNameDeAnimateur : this.__usernamedeanimateur
           // H-M Ajouter dans le cadre de la MC-MGEN3767-contrat dealer phase 1 END 
        }
    }

    handlePrint() {
        console.log("handlePrint");
        console.log(JSON.stringify(this.__userdata));
        console.log(JSON.stringify(this.__data));
        console.log(this.__isdealer);
        console.log(this.__link);

        let url = this.__link + "&data=";
        console.log("url");
        console.log(JSON.stringify(this.__data));
        console.log(this.__isdealer);
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
                url: url + JSON.stringify(this.__data),
            },
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }

    render() {
        return template;
    }
}