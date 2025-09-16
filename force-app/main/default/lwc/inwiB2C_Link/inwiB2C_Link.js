import { LightningElement,api,track } from 'lwc';
import { BaseState } from 'vlocity_cmt/baseState';
import { NavigationMixin } from 'lightning/navigation';
//import myPNG_icon from '@salesforce/resourceUrl/lampSVg';
//import InwiB2C_icon1 from '@salesforce/resourceUrl/InwiB2C_icon1';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";
import template from "./inwiB2C_Link.html"

export default class inwiB2C_Link extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
    //lampPng = myPNG_icon;
    //customImage = InwiB2C_icon1 + '/ex1.jpg';  

    viewPower(event) {
        // Navigate to Account record page
        window.open("https://gab.extranet.inwi.ma/forms/frmservlet?config=powercard", "_blank");

    }
    //chb 12/06/2024 ticket B-16817 begin*/ 
    handleOpenLinkEligibiliteADSL(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cEligibiliteAdslEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Eligibilite Adsl'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }
    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
    }
    render() {
        console.log('records');
      
        
        return template;
    }
    //chb 12/06/2024 ticket B-16817 end*/ 

    //sob 6/11/2025 MGEN3729 start
    handleOpenLinkDisplayAddressIAM(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:InwiDisplayDemandeAdresseIAMEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Affichage des Demandes Address IAM'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }
    //sob 6/11/2025 MGEN3729 end

    //sob 6/18/2025 MGEN3729 start
    handleOpenLinkRechercheAddress(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2csearchadresseIntrouvableEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Recherche Addresse Introuvable'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }
    //sob 6/18/2025 MGEN3729 end
}