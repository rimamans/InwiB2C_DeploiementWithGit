import { LightningElement, api, wire } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import template from './inwiB2C_searchpersonswaponthv3.html';
export default class InwiB2C_searchpersonswaponthv3 extends LightningElement {

    
      
    @api m;

    handleVisibilityNextButton() {
        console.log("this.m:", this.m);
        try {
            let searchButton = this.template.querySelector(`[data-theid="searche"]`);

            // Vérifier uniquement le champ MDN
            let mdnvalue = this.template.querySelector(`[data-theid="MDN"]`).value;
            let isMDNValid = mdnvalue && mdnvalue.length === 12; // Validation: longueur exacte de 12 caractères

            // Gérer l'affichage du bouton de recherche
            if (isMDNValid) {
                searchButton.style.display = "block";
            } else {
                searchButton.style.display = "none";
            }

            // Mettre à jour l'état
            let saveObj = {
                "IsExecuteDataraptor3": isMDNValid,
                "mdnvalue": mdnvalue
            };
            this.omniUpdateDataJson(saveObj);
            this.omniSaveState(saveObj, true);
        } catch (error) {
            console.log('error:', error);
        }
    }

    handleMDNChange(e) {
        this.handleVisibilityNextButton();

        let saveObj = {
            "mdnvalue": e.detail.value
        };
        this.omniUpdateDataJson(saveObj);
        this.omniSaveState(saveObj, true);
    }

    handleSearch(e) {
        this.omniNextStep();
    }

    render() {
        return template;
    }
}