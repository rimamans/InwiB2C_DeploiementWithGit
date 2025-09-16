import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class inwiB2C_GetAllCases extends OmniscriptBaseMixin(LightningElement) {

    _ns = getNamespaceDotNotation();
  @track value;
  @track idrec;
  @track optionsArray= [];


  handleChanged(event){
    this.value= event.target.value; 
    this._actionUtil = new OmniscriptActionCommonUtil();
      console.log('Value: '+this.value);
    const params = {
     input: '{"search":"'+this.value+'"}',
     sClassName: `${this._ns}IntegrationProcedureService`,
     sMethodName: "inwib2c_inwiB2C_GetAllCases",
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
  
  handleSelect(event) {
    
    this.value=event.target.dataset.number ;
    this.idrec = event.target.dataset.id;
    console.log('return value');
    console.log(this.idrec);
  console.log(this.value);
  
  
  this.template.querySelectorAll('lightning-input').value= this.value;
  
  let AgenceResult={"IdCase":this.idrec,"CaseNumber":this.value};
  
  this.omniUpdateDataJson(AgenceResult);
          this.omniSaveState(AgenceResult, true);
          this.optionsArray=[];
  
  
  }
}