import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_firstname extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {



    handleFilesChange(){
      //  var comboboxRetour = this.template.querySelector(`[data-customidrt="nomtext"]`);
      //  console.log("comboboxRetour: ");
        //console.log(comboboxRetour.value);

        try {
            var comboboxRetour = this.template.querySelector(`[data-customidrt="prenomtext"]`);
        console.log("comboboxRetour: ");
        console.log(comboboxRetour.value);
       // comboboxRetour.value= comboboxRetour.value.trim();
      //  comboboxRetour.value= comboboxRetour.value.replace(/ /g, "");

        let saveObj = {
           "prenomvalue" : comboboxRetour.value
         //  "cinvalue" : comboboxRetour.value.replace(/ /g, "")
        }
        console.log("saveObj");
        console.log(saveObj);

        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj,true);
        } catch (error) {

                    console.log(error);

        }
        
    }
}