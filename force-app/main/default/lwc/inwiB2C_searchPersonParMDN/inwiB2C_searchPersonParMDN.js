import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_searchPersonParMDN.html';

export default class InwiB2C_searchPersonParMDN extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    
    // @api m;

    // handleVisibilityNextButton() {
    //     console.log("this.m:", this.m);
    //     try {
    //         let searchButton = this.template.querySelector(`[data-theid="searche"]`);

    //         // Vérifier uniquement le champ MDN
    //         let mdnvalue = this.template.querySelector(`[data-theid="MDN"]`).value;
    //         let isMDNValid = mdnvalue && mdnvalue.length === 12; // Validation: longueur exacte de 12 caractères

    //         // Gérer l'affichage du bouton de recherche
    //         if (isMDNValid) {
    //             searchButton.style.display = "block";
    //         } else {
    //             searchButton.style.display = "none";
    //         }

    //         // Mettre à jour l'état
    //         let saveObj = {
    //             "IsExecuteDataraptor3": isMDNValid,
    //             "mdnvalue": mdnvalue
    //         };
    //         this.omniUpdateDataJson(saveObj);
    //         this.omniSaveState(saveObj, true);
    //     } catch (error) {
    //         console.log('error:', error);
    //     }
    // }

    // handleMDNChange(e) {
    //     this.handleVisibilityNextButton();

    //     let saveObj = {
    //         "mdnvalue": e.detail.value
    //     };
    //     this.omniUpdateDataJson(saveObj);
    //     this.omniSaveState(saveObj, true);
    // }

    // handleSearch(e) {
    //     this.omniNextStep();
    // }

    // render() {
    //     return template;
    // }

    
    @api n;
    @api p;
    @api c;
    @api m;

    handleVisibilityNextButton(){
        console.log("this.n:"+this.n)
        console.log("this.p:"+this.p)
        console.log("this.c:"+this.c)
        console.log("this.m:"+this.m)
        try {
            let searchButton = this.template.querySelector(`[data-theid="searche"]`);

            let nomvalue = this.template.querySelector(`[data-theid="Nom"]`).value;
            let prenomvalue = this.template.querySelector(`[data-theid="Prenom"]`).value;
            let cinvalue = this.template.querySelector(`[data-theid="CIN"]`).value;
            let mdnvalue = this.template.querySelector(`[data-theid="MDN"]`).value;


            let case1 =  nomvalue.length>2 && prenomvalue.length>2 && nomvalue!='' && prenomvalue!='' && cinvalue=='' && mdnvalue=='';
            let case2 = nomvalue=='' && prenomvalue=='' && cinvalue!='' && mdnvalue=='';
            let case3 = nomvalue=='' && prenomvalue=='' && cinvalue=='' && mdnvalue!='' && mdnvalue.length==12;

            console.log("MDNValue", mdnvalue);
            console.log("CINValue",cinvalue);
            console.log("NomValue",nomvalue);
    
    
            if(case1 || case2 || case3)
            searchButton.style.display = "block"
            else
            searchButton.style.display = "none"
    
            let saveObj = {
                "IsExecuteDataraptor1" : case1,
                "IsExecuteDataraptor2" : case2,
                "IsExecuteDataraptor3" : case3
             } 
             console.log("IsExecuteDataraptor", saveObj);
             this.omniUpdateDataJson(saveObj);
             this.omniSaveState(saveObj,true);
    

        } catch (error) {
            console.log('error: '+error)
        }

    }


    handleNomChange(e){
        this.handleVisibilityNextButton()
        let saveObj = {
            "nomvalue" : e.detail.value
         } 
         this.omniUpdateDataJson(saveObj);
         this.omniSaveState(saveObj,true);
    }

    handlePrenomChange(e){
        this.handleVisibilityNextButton()

        let saveObj = {
            "prenomvalue" : e.detail.value
         } 
         this.omniUpdateDataJson(saveObj);
         this.omniSaveState(saveObj,true);
    }

    handleCINChange(e){
        this.handleVisibilityNextButton()

        try {
            let CINinput = this.template.querySelector(`[data-theid="CIN"]`);

            CINinput.value=CINinput.value.replace(/ /g, "");
            let saveObj = {
                "cinvalue" : CINinput.value
             } 
             this.omniUpdateDataJson(saveObj);
             this.omniSaveState(saveObj,true);
    
        } catch (error) {
            console.log('error: '+error)

        }
    }

    handleMDNChange(e){
        this.handleVisibilityNextButton()

        let saveObj = {
            "mdnvalue" : e.detail.value
         } 
         this.omniUpdateDataJson(saveObj);
         this.omniSaveState(saveObj,true);
    }

    handleSearch(e){
        this.omniNextStep();
    }

    render(){
        return template;
    }
}