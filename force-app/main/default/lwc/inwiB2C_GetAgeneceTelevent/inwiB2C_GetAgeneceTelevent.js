import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";



export default class InwiB2C_GetAgeneceTelevent extends OmniscriptBaseMixin(LightningElement) {


    _ns = getNamespaceDotNotation();
    @track value;
    
    @track idrec;
    
    @track optionsArray= [];
    
     show=false;
    @api name;
    //@api code;
  
    
    agenceInput; 

    renderedCallback() {
        // Associer la référence à l'élément après le rendu
        this.agenceInput = this.template.querySelector('lightning-input');
    }
  
  handleChanged(event){
  
    
    this.value= event.target.value; 
    if (this.value=='') {
      this.show=false;
      
    } else {
      this.show=true;
      
    }

    console.log('Value:', this.value);
    console.log('Show:', this.show);

    
   // Émettre un événement contenant la valeur du champ d'entrée
   const inputValueEvent = new CustomEvent('inputvaluechange', {
    detail: { inputValue: this.value },
    bubbles: true
});
  
     console.log('Before agenceselected event:', inputValueEvent);
     this.dispatchEvent(inputValueEvent);    
     console.log('After agenceselected event:', inputValueEvent);

    this._actionUtil = new OmniscriptActionCommonUtil();
      
    const params = {
     input: '{"search":"'+this.value+'"}',
     sClassName: `${this._ns}IntegrationProcedureService`,
     sMethodName: "inwib2c_Get_All_Agence",
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
    this.show=false;
    this.value=event.target.dataset.codeagence+', '+event.target.dataset.name  ;
    this.idrec = event.target.dataset.idacc;
    console.log('return value');
    console.log(this.idrec);
  console.log(this.value);
  
  
  this.template.querySelectorAll('lightning-input').value= this.value;
  
  let AgenceResult={"IdAgence":this.idrec,"dataAgence":this.value,"AgenceName":event.target.dataset.name,"CodeAgence":event.target.dataset.codeagence};

     // Mettre à jour les propriétés 'flage' et 'AgenceResult' dans omniUpdateDataJson
        this.omniUpdateDataJson({
       'flage': this.getFlage(),
        ...AgenceResult
        });
   
          this.omniSaveState(AgenceResult, true);
          this.optionsArray=[];
  
  
  }
  
  @api
  getFlage() {
      return this.value !== '' ? 'true' : 'false';
  }

  handlePrevious() {
    if (!this.isPreviousDisabled) {
        this.omniPrevStep();
    }
}

handleNext() {
  // Utiliser reportValidity pour la validation côté client
  if (this.name || this.agenceInput.reportValidity()) {
    this.errorMessage = ''; // Réinitialiser le message d'erreur
      this.omniNextStep();
  } else {
      this.errorMessage = 'Le champ de livraison agence est obligatoire. Veuillez le remplir.';
  }
}
  
  }