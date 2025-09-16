import { LightningElement,api,track } from 'lwc';
import { BaseState } from 'vlocity_cmt/baseState';
import { NavigationMixin } from 'lightning/navigation';
//import myPNG_icon from '@salesforce/resourceUrl/lampSVg';
//import InwiB2C_icon1 from '@salesforce/resourceUrl/InwiB2C_icon1';

import template from "./inwiB2C_LinkCommunity.html"

export default class inwiB2C_LinkCommunity extends LightningElement {
    //lampPng = myPNG_icon;
    //customImage = InwiB2C_icon1 + '/ex1.jpg';  

    viewPower(event) {
        // Navigate to Account record page
        window.open("https://proactech-academy.net/", "_blank");


    }

    viewPower2(event) {
        // Navigate to Account record page
        window.open("https://sap-s4-pas.inwi.lan:44300/sap/bc/ui2/flp", "_blank");
    }

    //sob 6/11/2025 MGEN3729 start
    handleOpenLinkDisplayAddressIAM(event) {
        const url = '/PortailPDVPhase2/s/lwcos?c__target=c:InwiDisplayDemandeAdresseIAMEnglish&c__layout=lightning&c__tabIcon=custom:custom18';
        window.open(url, '_blank');
    }
    //sob 6/11/2025 MGEN3729 end

    //Y_MH MGEN3725-Controle eligibilité adresse 5G start
    handleOpenLinkEligibiliteidar5g(event) {
        const url = '/PortailPDVPhase2/s/lwcos?c__target=c:inwib2cCheckEligibilityHome5GEnglish&c__layout=lightning&c__tabIcon=custom:custom18&c__tabLabel=inwb2c_CheckEligibilityHome5G';
        window.open(url, '_blank');
    }
    //Y_MH MGEN3725-Controle eligibilité adresse 5G end

}