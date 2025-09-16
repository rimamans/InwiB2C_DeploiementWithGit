import { LightningElement, api, wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_Paiement_Print.html";

export default class inwiB2C_Paiement_Print extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    __invoices;
    data = [];
    __userprofile;
    __nom;
    __prenom;
    __cin;
    __quartier;
    __ville;
    __pays;
    __codepointdevente;
    __billingaccount;
    __modedepaiement;
    __totalamount;
    __codeagent;
    __fraistimbre;
    __numrecu;
    __numtransactioninvoices;
    __firstnameagent;
    __lastnameagent;



    @api
    get invoices() {
        return this.__invoices;
    }
    set invoices(value) {
        this.__invoices = value;
    }

    @api
    get userprofile() {
        return this.__userprofile;
    }
    set userprofile(value) {
        this.__userprofile = value;
    }

    @api
    get nom() {
        return this.__nom;
    }
    set nom(value) {
        this.__nom = value;
    }

    @api
    get prenom() {
        return this.__prenom;
    }
    set prenom(value) {
        this.__prenom = value;
    }

    @api
    get cin() {
        return this.__cin;
    }
    set cin(value) {
        this.__cin = value;
    }

    @api
    get quartier() {
        return this.__quartier;
    }
    set quartier(value) {
        this.__quartier = value;
    }

    @api
    get ville() {
        return this.__ville;
    }
    set ville(value) {
        this.__ville = value;
    }

    @api
    get pays() {
        return this.__pays;
    }
    set pays(value) {
        this.__pays = value;
    }

    @api
    get codepointdevente() {
        return this.__codepointdevente;
    }
    set codepointdevente(value) {
        this.__codepointdevente = value;
    }

    @api
    get billingaccount() {
        return this.__billingaccount;
    }
    set billingaccount(value) {
        this.__billingaccount = value;
    }

    @api
    get modedepaiement() {
        return this.__modedepaiemnt;
    }
    set modedepaiement(value) {
        this.__modedepaiement = value;
    }

    @api
    get totalamount() {
        return this.__totalamount;
    }
    set totalamount(value) {
        this.__totalamount = value;
    }

    @api
    get codeagent() {
        return this.__codeagent;
    }
    set codeagent(value) {
        this.__codeagent = value;
    }

    @api
    get fraistimbre() {
        return this.__fraistimbre;
    }
    set fraistimbre(value) {
        this.__fraistimbre = value;
    }

    @api
    get numtransactioninvoices() {
        return this.__numtransactioninvoices;
    }
    set numtransactioninvoices(value) {
        this.__numtransactioninvoices = value;
    }

    @api
    get numrecu() {
        return this.__numrecu;
    }
    set numrecu(value) {
        this.__numrecu = value;
    }
    @api
    get firstnameagent() {
        return this.__firstnameagent;
    }
    set firstnameagent(value) {
        this.__firstnameagent = value;
    }
    @api
    get lastnameagent() {
        return this.__lastnameagent;
    }
    set lastnameagent(value) {
        this.__lastnameagent = value;
    }
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.generateData();
    }

    generateData() {
        console.log("generateData");
        this.data = JSON.parse(JSON.stringify(this.__invoices));
        //console.log("data: " + this.data[0].Id);
    }

    handlePrint(event) {

        let inputList = [];
        inputList = this.data;
        console.log("priiiint" + JSON.stringify(inputList));
        event.stopPropagation();
        
        const input = { data: inputList , Prenom: this.__prenom, Nom: this.__nom, CIN: this.__cin, Quartier: this.__quartier, Ville: this.__ville, Pays: this.__pays, CodePointDeVente: this.__codepointdevente, BillingAccount: this.__billingaccount, ModeDePaiement: this.__modedepaiement, TotalAmount: Math.round(this.__totalamount* 100) / 100, CodeAgent: this.__codeagent, FraisTimbre: Math.round(this.__fraistimbre* 100) / 100, NumTransaction:this.__numtransactioninvoices, NumeroDeRecu: this.__numrecu,FirstNameAgent:this.__firstnameagent,LastNameAgent: this.__lastnameagent };
         console.log("inpuuut"+JSON.stringify(input));
        let url = this.__userprofile == "Inwi POS" ? "../apex/inwiB2C_Invoices_Doc_Page?input=" : "/apex/inwiB2C_Invoices_Doc_Page?input=";
        console.log(input);
        console.log('urlll:'+url + JSON.stringify(input));
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
                url: url + JSON.stringify(input),
            },
        }).then(generatedUrl => {
              window.open(generatedUrl);
        });

    }

    render() {
        return template;
    }
}