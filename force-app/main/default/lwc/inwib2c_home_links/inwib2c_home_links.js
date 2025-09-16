import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from "lightning/navigation";

import { getNamespaceDotNotation } from "vlocity_cmt/omniscriptInternalUtils";
import { OmniscriptActionCommonUtil } from "vlocity_cmt/omniscriptActionUtils";

import template from "./inwib2c_home_links.html";

export default class Inwib2c_home_links extends OmniscriptBaseMixin(
    NavigationMixin(LightningElement)
) {
   
    eligibility;
    /**B-21535 ILA 28/10/24 Start */
    eligibilityCT;
    /**B-21535 ILA 28/10/24 End */

    /**B-22735 ILA 04/12/24 Start */
    eligibilityMasse;
    /**B-22735 ILA 04/12/24 End */

    /* MC-MGEN3601-FMD FTTH Complément R-SL begin 13/02/2025*/
    eligibilityRecyclage;
    /* MC-MGEN3601-FMD FTTH Complément R-SL end 13/02/2025*/
    __records;
    @api
    get records() {
        return this.__records;
        
      }

    set records(value) {
      this.__records = value;
    }
 

    handleOpen(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cTransfertSoldeEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Lettrage - Transfert Solde'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
        // this[NavigationMixin.GenerateUrl]({
        //     type: "standard__vlocityOmniscript",
        //     attributes: {
        //         url,
        //     },
        // }).then(generatedUrl => {
        //     window.open(generatedUrl);
        // });
    }

    handleOpenLink(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cinwiB2C_SMOMassifEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'SMO Massifs'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }


    handleOpenLinkretour(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cGestionDesRetoursEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Gestion de retours'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }

    handleOpenLinkDegroupage(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cDemande_DegroupageEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Demande de dégroupage'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }

    /**VULA ILA 09/11/25 Start */
    handleOpenLinkVula(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cSharingRequestEnglish',
                c__layout: 'lightning',
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Demande de partage'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }
    /**VULA ILA 09/11/25 End */


    /**VULA CH-Y 05/03/25 Start */
    handleOpenLinkAcquisitionVula(event) {
            event.stopPropagation();
    
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__component',
                attributes: {
                    componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
                },
                state: {
                    c__target: 'c:inwib2cTeleventeFTTHVulaEnglish',
                    c__layout: 'lightning',
                    c__tabIcon: 'custom:custom18',
                    c__tabLabel: 'Acquisition Ftth Vula Televente'
                }
            })
                .then(generatedUrl => {
                    window.open(generatedUrl);
                });
        }
    /**VULA CH-Y 05/03/25 End */

    handleOpenLinkUTMasse(event){
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cChangementTechnoMassifEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Changement de technologie'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }

    handleOpenLinkUTMasseAM(event){
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cchargementEnMasseEnglish',
                c__layout: 'lightning', // or 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'Chargement en masse'
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }



    //MC-MGEN3601-FMD FTTH Complément R-SL begin

    handleRecyclageFTTH(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2cInwiB2C_RecyclageCommandeFTTHEnglish',
                c__layout: 'lightning', // or can be 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'inwiB2C_RecyclageCommandeFTTH',
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }
//MC-MGEN3601-FMD FTTH Complément R-SL end 11/02/2025

    //CHB VULA FTTH COMPLEMENT 06/03/2025
    handleOpenLinkRechercheAdresseIntrouvable(event) {
        event.stopPropagation();

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__component',
            attributes: {
                componentName: 'vlocity_cmt__vlocityLWCOmniWrapper'
            },
            state: {
                c__target: 'c:inwib2csearchadresseIntrouvableEnglish',
                c__layout: 'lightning', // or can be 'newport'
                c__tabIcon: 'custom:custom18',
                c__tabLabel: 'searchadresseIntrouvable',
            }
        })
            .then(generatedUrl => {
                window.open(generatedUrl);
            });
    }
    //CHB VULA FTTH COMPLEMENT 06/03/2025


    _ns = getNamespaceDotNotation();
    _actionUtilClass;

    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();
        this.eligibility=this.__records[0].CheckProfilEligibility;
        /**B-21535 ILA 28/10/24 Start */
        this.eligibilityCT=this.__records[0].CheckProfilEligibilityCT;
        /**B-21535 ILA 28/10/24 End */

          /**B-22735 ILA 04/12/24 Start */
           this.eligibilityMasse=this.__records[0].CheckProfilEligibilityMasse;
          /**B-22735 ILA 04/12/24 End */
          
          /* MC-MGEN3601-FMD FTTH Complément R-SL begin 13/02/2025*/
          this.eligibilityRecyclage=this.__records[0].CheckProfilEligibilityRecyclage;
        /* MC-MGEN3601-FMD FTTH Complément R-SL end 13/02/2025*/
         
    }

    render() {
        console.log('records');
        console.log(this.eligibility);
        
        return template;
    }

}