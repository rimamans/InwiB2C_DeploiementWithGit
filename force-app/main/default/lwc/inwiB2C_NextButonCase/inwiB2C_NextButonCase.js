import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from "lightning/alert";


export default class inwiB2C_NextButonCase extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
 
    
    __mandatory;
  
@api
   
    get mandatory(){
        return this.__mandatory;
    }



    set mandatory(value){
        this.__mandatory= value;
    }


    
  
    
     gotonextStep(){
        console.log("fz77");
        console.log("field"+this.mandatory);

        if (this.mandatory==false){
            console.log("zezzz");

            
       
            this.omniNextStep();
        }
        else if (this.mandatory==true){
        
              console.log("fz77");
              alert("Erreur: Champ Détail Obligatoire !");

              
            
        }
    }   
    gotopreviousStep(){
        this.omniPrevStep();
    }
    



}