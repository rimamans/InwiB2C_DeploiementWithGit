import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

export default class Inwib2c_GetCodeArticle extends OmniscriptBaseMixin(LightningElement) {



    _ns = getNamespaceDotNotation();
  
    @track article;
   
    @track idart;
   
    @track Array= [];
     show =false;
    @api profil;
    handleChange(event){
      
      this.article= event.target.value; 
      if (this.article=='') {
        this.show=false;
        
      } else {
        this.show=true;
        
      }
      
      this._actionUtil = new OmniscriptActionCommonUtil();
        
      const params = {
       input: '{"search":"'+this.article+'"}',
       sClassName: `${this._ns}IntegrationProcedureService`,
       sMethodName: "inwib2c_GetCodesArticle",
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
          
         this.Array=res ;
         
         console.log('thisArray:' +res);
    
       })
       .catch(error => {
         console.log("error");
         window.console.log(error);
       });
      
    }
    
    handleSelect2(event) {
      this.show=false;
      this.article=event.target.dataset.codearticle;
      this.idart = event.target.dataset.idart;
      console.log('return value');
      console.log(this.idart);
    console.log(this.article);
    
    
    this.template.querySelectorAll('lightning-input').value= this.article;
    
    let ArticleCode={"Id":this.idart,"CodeArticle":event.target.dataset.codearticle,"Offre":event.target.dataset.offre};
    
    
    this.omniUpdateDataJson(ArticleCode);
            this.omniSaveState(ArticleCode, true);
            this.Array=[];
    
    
    }
}