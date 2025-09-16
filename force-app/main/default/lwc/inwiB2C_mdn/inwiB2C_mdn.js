import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class InwiB2C_mdn extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {



    handleFilesChange(){
      //  var comboboxRetour = this.template.querySelector(`[data-customidrt="mdntext"]`);
      //  console.log("comboboxRetour: ");
       // console.log(comboboxRetour.value);


       try {
        var comboboxRetour = this.template.querySelector(`[data-customidrt="mdntext"]`);
    console.log("comboboxRetour: ");
    console.log(comboboxRetour.value);
   // comboboxRetour.value= comboboxRetour.value.trim();
  //  comboboxRetour.value= comboboxRetour.value.replace(/ /g, "");

    let saveObj = {
       "mdnvalue" : comboboxRetour.value
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