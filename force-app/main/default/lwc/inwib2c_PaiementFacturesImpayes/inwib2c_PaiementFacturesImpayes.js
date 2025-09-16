import { api, LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_PaiementFacturesImpayes.html";

export default class Inwib2c_PaiementFacturesImpayes extends  OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {


    __data = [];
    __userprofile;
    //__orderId;
    __invoices;
    __totalamount;
    __fraistimbre;
    __invoicedate;
    __invoicepaymentduedate;
    __invoiceamount;
    __modedepaiement;
    __lastname;
    __firstname;
    __codeagent;
    __billingaccountnumber;
    __codetransaction;
    __fullname;
    __codepdv;
    __today;
    __paiement="TPE"
    
   @api 
   get userprofile() 
   {
    return this.__userprofile;
   }

    set userprofile(value) {
    this.__userprofile = value;
    }
  
    

    
    @api
    get invoices() {
        return this.__invoices;
    }
    set invoices(value) {
        this.__invoices = value;
    }

    @api
    get totalamount() {
        return this.__totalamount;
    }
    set totalamount(value) {
        this.__totalamount = value;
    }

    
    @api
    get fraistimbre() {
        return this.__fraistimbre;
    }
    set fraistimbre(value) {
        this.__fraistimbre = value;
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
        return this.__modedepaiement
        ;
    }
    set modedepaiement(value) {
        this.__modedepaiement= value;
    }

 @api
    get invoicedate() {
        return this.__invoicedate;
    }
    set invoicedate(value) {
        this.__invoicedate = value;
    }

    @api
    get invoicepaymentduedate() {
        return this.__invoicepaymentduedate;
    }
    set invoicepaymentduedate(value) {
        this.__invoicepaymentduedate = value;
    }

    @api
    get invoiceamount() {
        return this.__invoiceamount;
    }
    set invoiceamount(value) {
        this.__invoiceamount = value;
    }

    @api
    get firstname(){
        return this.__firstname;
    }
    set firstname(value){
        this.__firstname = value;


    }
    @api
    get lastname(){
        return this.__lastname;
    }
    set lastname(value){
        this.__lastname = value;


    }
   @api 
    get codeagent(){
        return this.__codeagent;
    }
    set codeagent(value){
        this.__codeagent = value;


    }

    @api
     get billingaccountnumber(){
        return this.__billingaccountnumber
     }
     set billingaccountnumber(value){
        this.__billingaccountnumber = value;


    }
    @api
    get codetransaction(){
        return this.__codetransaction
    }
    set codetransaction(value){
        this.__codetransaction = value;


    }
    @api
    get fullname(){
        return this.__fullname
    }
    set fullname(value){
        this.__fullname = value;
    }
    @api
    get codepdv(){
        return this.__codepdv
    }
    set codepdv(value){
        this.__codepdv = value;
    }
    @api
    get today(){
        return this.__today
    }
    set today(value){
        this.__today = value;
    }
  


    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        
        this._actionUtilClass = new OmniscriptActionCommonUtil();
       
        console.log('modedepaiement:', this.modedepaiement);

        
    }

 

   


    handlePrint(event) {
    let inputList = [];
    // if (this.__modedepaiement==="CS") {
    //      this.__paiement ="En Espèce"
        
    // }
  

        const item_Invoice = {
            CodeAgent:this.codeagent,
            FullName:this.fullname,
            CodePdv:this.codepdv,
            CreatedDate :this.today,
            Nom:this.lastname,
            Prenom:this.firstname,
            TotalAmount: this.invoiceamount,
            FraisTimbre: Math.round(this.__fraistimbre* 100) / 100,
            Id:this.invoices,
            NumeroDeRecu:this.codetransaction,
            BillingAccount:this.billingaccountnumber,
            //ModeDePaiement:"TPE",  //this.__paiement, 
            ModeDePaiement:this.modedepaiement === "CS" ? 'En espèce' : 'TPE', 
            InvoiceDate : this.invoicedate,
            invoicePaymentDueDate :this.invoicepaymentduedate,
            invoiceAmount : this.invoiceamount,  
        }


        


        if (inputList) {
            inputList.push(item_Invoice);
        }
      
        console.log('inputlist:'+JSON.stringify(inputList));

    //})
    event.stopPropagation();

    const input = { data: inputList };
  console.log('inputtttt:', input);
    // eslint-disable-next-line eqeqeq
    let url = this.__userprofile == "Inwi POS" ? "../apex/inwiB2C_RecuPaiementMigrationPostPaye?input=" : "/apex/inwiB2C_RecuPaiementMigrationPostPaye?input=";
    
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