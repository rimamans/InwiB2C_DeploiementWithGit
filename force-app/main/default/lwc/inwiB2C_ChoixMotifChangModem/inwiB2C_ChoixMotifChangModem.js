import { LightningElement, api, track,wire } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_ChoixMotifChangModem.html";
import { NavigationMixin } from "lightning/navigation";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
export default class inwiB2C_ChoixMotifChangModem   extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
)  {
    _ns = getNamespaceDotNotation();
    _actionUtilClass;
    
    //showmsg=false;
    //input
  /*  @api ancienmac;
    @api ancienarticle;
    @api ancienmodele;
    @track nouveaunummac; 
    @track nouveaumodele;*/
    message;
    //found=false;
    get options() {
        return [
          
          { label: `Panne hors garantie`,value: "PanneHorsGarantie", },  
          { label: "Panne sous garantie", value: "PanneSousGarantie" },
        ];
      }
      connectedCallback(){
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        }
    handleChange(event) {
        
        this.optionMotif = event.detail.value;
        this.omniUpdateDataJson({ "optionMotif": this.optionMotif });
        if(this.optionMotif=="PanneHorsGarantie"){
           this.showmsg=true;
           this.showMessage('Message', 'Veuillez informer le client que des frais de mise à disposition de routeur seront exigibles avant la finalisation de cette commande.', 'success');
        }else{
           this.showmsg=false;
        }
    }
   /* handleChangeInput(event) {
       
        this[event.target.name] = event.target.value;
        console.log('nouveaunummac',this.nouveaunummac);
        }
        handleSearch() {
            console.log(this.nouveaunummac);
            if (this.nouveaunummac !== "") {
                let input =
                    `{"nouveaunummac": "` + this.nouveaunummac + `" }`;
    
                const params = {
                    input,
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: "inwib2c_",
                    options: "{}",
                };
    
                this._actionUtilClass
                    .executeAction(params, null, this, null, null)
                    .then(response => {
                        console.log(response);
                        if (!response.error) {
                           
                            if (response.result.IPResult && response.result.IPResult.AccountList) {
                                this.found=true;
                            } else {
                             
                            }
                        }else{
                            this.showMessage('Erreur', 'Non Eligible', 'error');
                           
                        }
                    })
                    .catch(error => {
                        window.console.log(error);
                    });
            }
        }*/
        showMessage(t, m, type) {
            const toastEvt = new ShowToastEvent({
                title: t,
                message: m,
                variant: type
            });
            this.dispatchEvent(toastEvt);
        };
        next() {
            this.omniNextStep();
            }
            gotopreviousStep() {
                this.omniPrevStep();
            
              }
}