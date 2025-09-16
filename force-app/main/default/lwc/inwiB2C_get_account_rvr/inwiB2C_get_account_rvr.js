import { LightningElement, api, track } from "lwc";

import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwiB2C_get_account_rvr.html";



export default class inwiB2C_get_account_rvr extends OmniscriptBaseMixin(LightningElement){
  _ns = getNamespaceDotNotation();

  @track value;
  @track valueReg;
  @track idrec;
  @track idrecReg;
  @track optionsArray= [];
  @track optionsArrayReg= [];
   show=false;
  @api profil;
  @api rvrdealer;
  @api regional;
  connectedCallback() {

    this.value=this.rvrdealer;
    this.valueReg=this.regional;
  }
handleChanged(event){

  
  this.value= event.target.value; 
  if (this.value=='') {
    this.show=false;
    
  } else {
    this.show=true;
    
  }

  this._actionUtil = new OmniscriptActionCommonUtil();
    console.log('value'+this.value);
  const params = {
   input: '{"search":"'+this.value+'"}',
   sClassName: `${this._ns}IntegrationProcedureService`,
   sMethodName: "inwib2c_inwiB2C_GeTAllUserRVR",
   options: '{}'
 };
 this._actionUtil
   .executeAction(params, null, this, null, null)
   .then(response => {
    console.log('response');
     console.log('response' + response.result.IPResult);
     console.log(JSON.stringify(response.result.IPResult));
     JSON.parse(JSON.stringify(response.result.IPResult));
     let res = response.result.IPResult.List;
     
 
     console.log('res');
     console.log(res);
      
     this.optionsArray=res ;
     
     console.log('thisoptions:' +res);

   })
   .catch(error => {
     console.log("error");
     window.console.log(error);
   });
  
}
//Regional
handleChangedRegional(event){

  
  this.valueReg= event.target.value; 
  if (this.valueReg=='') {
    this.show=false;
    
  } else {
    this.show=true;
    
  }

  this._actionUtil = new OmniscriptActionCommonUtil();
    console.log('value'+this.valueReg);
  const params = {
   input: '{"search":"'+this.valueReg+'"}',
   sClassName: `${this._ns}IntegrationProcedureService`,
   sMethodName: "inwib2c_inwiB2C_GeTAllUserRegional",
   options: '{}'
 };
 this._actionUtil
   .executeAction(params, null, this, null, null)
   .then(response => {
    console.log('response');
     console.log('response' + response.result.IPResult);
     console.log(JSON.stringify(response.result.IPResult));
     JSON.parse(JSON.stringify(response.result.IPResult));
     let res = response.result.IPResult.List;
     
 
     console.log('res');
     console.log(res);
      
     this.optionsArrayReg=res ;
     
     console.log('thisoptions:' +res);

   })
   .catch(error => {
     console.log("error");
     window.console.log(error);
   });
  
}
handleSelect(event) {
  this.show=false;
  this.value=event.target.dataset.name  ;
  this.idrec = event.target.dataset.iduser;
  console.log('return value');
  console.log(this.idrec);
console.log(this.value);


this.template.querySelectorAll('lightning-input').value= this.value;

let UserResult={"Iduser":this.idrec,"dataName":this.value};


this.omniUpdateDataJson(UserResult);
        this.omniSaveState(UserResult, true);
        this.optionsArray=[];


}
//select reg
handleSelectReg(event) {
  this.show=false;
  this.valueReg=event.target.dataset.name;
  this.idrecReg = event.target.dataset.iduser;
  console.log('return value');
  console.log(this.idrecReg);
console.log(this.valueReg);


this.template.querySelectorAll('lightning-input').value= this.valueReg;

let UserResult={"IduserReg":this.idrecReg,"dataNameReg":this.valueReg};


this.omniUpdateDataJson(UserResult);
        this.omniSaveState(UserResult, true);
        this.optionsArrayReg=[];


}

          }