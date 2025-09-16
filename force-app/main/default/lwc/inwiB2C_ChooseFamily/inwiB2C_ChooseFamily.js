import { LightningElement, api, track, wire } from 'lwc';
    import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
    import { NavigationMixin } from 'lightning/navigation';
    import template from './inwiB2C_ChooseFamily.html';

    export default class InwiB2C_ChooseFamily extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

        @api segmentmarche;
        @api totalorderssubscriptions;
        @api canal;
        @api userprofile;
        @api usprf;
        @api segmentoffer;
        @api profile;
        @api eligibility;
        @api offertype;
        @api impaye;
        @api hassuspfact;
        /**B-17831 ILA 10/07/24 Start */
        //@api offrecameleon;
        /**B-17831 ILA 10/07/24 End */
        @api offreadsl;
        @api offreftth;
        @api countallsubscriptions;
        @api maxdealeractivesubscriptions;
        @api maxcustomeractivesubscriptions;

        @track selectedLabel = '';
        
        labelstep=false;
        offrecameleon=true;
    

        getoptions() {

            if(this.userprofile == 'BackOffice Distributeur D2D'){
                return [ 
               { label: "FTTH", value: "FTTH" },
                { label: "ADSL", value: "ADSL" }, 
                /*chb B-19699 130/08/2024 BEGIN
                { label: "Idar Duo", value: "idar duo" },
                  chb B-19699 130/08/2024 END */
  
            ]
            }
            //CH-Y 13/05/2025 MGEN3677 Vente de forfaits Postpaid iDar via Wakil_V1.0 Begin
            else 
            if(this.userprofile == 'BackOffice Wakil'){
                return [ 
               { label: "Mobile Postpayé", value: "Postpaye" },
                { label: "Idar Duo", value: "idar duo" },
                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                /*chb B-19699 130/08/2024 BEGIN
                { label: "Idar Duo", value: "idar duo" },
                  chb B-19699 130/08/2024 END */
  
            ]
            }
            //CH-Y 13/05/2025 MGEN3677 Vente de forfaits Postpaid iDar via Wakil_V1.0 End

            //R-SL 02/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 begin
             else 
            if(this.userprofile == 'Wafacash'){
                return [ 
               { label: "Mobile Postpayé", value: "Postpaye" },
                { label: "Idar Duo", value: "idar duo" },
                { label: "Mobile prépayé", value: "Prepaye" },
                
  
            ]
            }
            //R-SL 02/09/2025 MGEN3688-B2C Vente Wafacash_v1.5 end
            else {
            //utilisateur qui a la permission set Cameleon
            if(this.offrecameleon == true){
            if( this.offreadsl  == true ){
            if( this.offreftth  == true ){
            if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                if ((this.segmentoffer =='' || this.segmentoffer ==null|| this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                    if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Idar Duo", value: "idar duo" },
                            { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "FTTH", value: "FTTH" },
                            { label: "ADSL", value: "ADSL" },
                            { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                            { label: "Autres articles", value: "Article non sérialisé" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.profile == 'profilphase3') {
                        return [
                            { label: "Accessoire", value: "Accessoire" },
                        ]
                    } 
                    else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'ADSL' && this.profile == 'profilphase3') {
                        return [
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                        ]
                    }
                    else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {

                        return [
                            { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                        ]
                    } // ANO 9337 10/05/2023 CHB
                    else if (this.segmentoffer == 'Postpayé' &&  this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                        return [
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "Autres articles", value: "Article non sérialisé" },

                        ]
                    }else if (this.segmentoffer == 'Prépayé'  && this.profile == 'profilphase3') {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                            /* MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                             Remplacer 30j par Flexi */
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    }
                    else if (this.segmentoffer =='' && this.profile == 'profilphase3') {
                        [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Idar Duo", value: "idar duo" },
                            { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "FTTH", value: "FTTH" },
                            { label: "ADSL", value: "ADSL" },
                            { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                            { label: "Autres articles", value: "Article non sérialisé" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    }
                    
                    else {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "FTTH", value: "FTTH" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                            
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    }
                } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                    return [
                        { label: "Mobile Postpayé", value: "Postpaye" },
                        { label: "Data Only Postpayé", value: "Home Postpaye" },
                        { label: "FTTH", value: "FTTH" },
                        { label: "ADSL", value: "ADSL" },
                        { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                        { label: "Terminal & Accessoire", value: "Accessoire" },
                        { label: "Autres articles", value: "Article non sérialisé" },
                        /* MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                        Remplacer 30j par Flexi*/
                        { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                    ]
                } else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                    return [
                        { label: "Mobile prépayé", value: "Prepaye" },
                        { label: "Home prépayé", value: "Home" },
                    ]
                }
            } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                    return [
                        { label: "Mobile Dealer", value: "Mobile Dealer" },
                        { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                    ]
                } 
                else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                    return [
                        { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                    ]
                }
            }
            }
            }
            if( this.offreadsl  == false ){
  // utilisateur qui n'a pas la permission set offreadsl
            if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                if ((this.segmentoffer ==null ||this.segmentoffer =='' || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                    if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Idar Duo", value: "idar duo" },
                            { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "FTTH", value: "FTTH" },

                            { label: "Autres articles", value: "Article non sérialisé" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.profile == 'profilphase3') {
                        return [
                            { label: "Accesoire", value: "Accesoire Idar" },
                        ]
                   }
                   
                     else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {

                        return [
                            { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                        ]
                    } else if (this.segmentoffer == 'Prépayé'  && this.profile == 'profilphase3') {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                            /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                             Remplacer 30j par Flexi*/
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    }//ANO 9337 10/05/2023 CHB
                     else if (this.segmentoffer == 'Postpayé' && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                        return [
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "Autres articles", value: "Article non sérialisé" },

                        ]
                    }
                    else if (this.segmentoffer =='' && this.profile == 'profilphase3') {
                        [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Idar Duo", value: "idar duo" },
                            { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "FTTH", value: "FTTH" },

                            { label: "Autres articles", value: "Article non sérialisé" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                             /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                             Remplacer 30j par Flexi*/
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    }
                    else {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                             /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                             Remplacer 30j par Flexi*/
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    }
                } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                    return [
                        { label: "Mobile Postpayé", value: "Postpaye" },
                        { label: "Data Only Postpayé", value: "Home Postpaye" },
                        { label: "Terminal & Accessoire", value: "Accessoire" },
                        { label: "Autres articles", value: "Article non sérialisé" },
                        /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                        Remplacer 30j par Flexi*/
                        { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                    ]
                } else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer ==''|| this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                    return [
                        { label: "Mobile prépayé", value: "Prepaye" },
                        { label: "Home prépayé", value: "Home" },
                    ]
                }
            } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer == 'Prépayé')) {
                    return [
                        { label: "Mobile Dealer", value: "Mobile Dealer" },
                        { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                    ]
                } 
                else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                    return [
                        { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                    ]
                }
            }
            else {
                return [
                    { label: "Mobile Postpayé", value: "Postpaye" },
                    { label: "Mobile prépayé", value: "Prepaye" },
                    { label: "Idar Duo", value: "idar duo" },
                    { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                    { label: "Home prépayé", value: "Home" },
                    { label: "Data Only Postpayé", value: "Home Postpaye" },

                    { label: "Autres articles", value: "Article non sérialisé" },
                    { label: "Terminal & Accessoire", value: "Accessoire" },
                    /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                     Remplacer 30j par Flexi*/
                    { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                ]
            }
            }
            if( this.offreftth  == false ){
// utilisateur qui n'a pas la permission set offreftth
                if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                    if ((this.segmentoffer =='' || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                        if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
    
                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                             /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                             Remplacer 30j par Flexi*/
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {
    
                            return [
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                                 Remplacer 30j par Flexi*/
                                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                            ]
                        } else if (this.segmentoffer == 'Prépayé'  && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                                /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                                 Remplacer 30j par Flexi*/
                                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                                ]
                        } // ANO 9337 10/05/2023 CHB
                        else if (this.segmentoffer == 'Postpayé' && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                            return [
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Autres articles", value: "Article non sérialisé" },
    
                            ]
                        }
                        else if (this.segmentoffer =='' && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
    
                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                 /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                                 Remplacer 30j par Flexi*/
                                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                            ]
                        }
                        else {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                                /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                                 Remplacer 30j par Flexi*/
                                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                            ]
                        }
                    } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                            /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                             Remplacer 30j par Flexi*/
                            { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                        ]
                    } else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                        ]
                    }
                } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                    if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile Dealer", value: "Mobile Dealer" },
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    } 
                    else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                        return [
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    }
                }
                else{
                    return [
                        { label: "Mobile Postpayé", value: "Postpaye" },
                        { label: "Mobile prépayé", value: "Prepaye" },
                        { label: "Idar Duo", value: "idar duo" },
                        { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                        { label: "Home prépayé", value: "Home" },
                        { label: "Data Only Postpayé", value: "Home Postpaye" },

                        { label: "Autres articles", value: "Article non sérialisé" },
                        { label: "Terminal & Accessoire", value: "Accessoire" },
                        /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                        Remplacer 30j par Flexi*/
                        { label: "Mobile postpayé forfait Flexi", value: "cameleon" },
                    ]
                }
            }
            if( this.offreadsl  == true && this.offreftth  == false){
                if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                    if ((this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                        if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                                 Remplacer 30j par Flexi*/
                                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },

                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'ADSL' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {
        
                            return [
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Prépayé'  && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }// ANO 9337 10/05/2023 CHB 
                         else if (this.segmentoffer == 'Postpayé'  && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                            return [
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Autres articles", value: "Article non sérialisé" },
    
                            ]
                        }
                        else if (this.segmentoffer =='' && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                /*MGEN3641SF_B2C_Libelle_Flexi 22/01/25 ILA
                                 Remplacer 30j par Flexi*/
                                { label: "Mobile postpayé forfait Flexi", value: "cameleon" },

                            ]
                        }
                        else {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }
                    } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "ADSL", value: "ADSL" },
                            { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                        ]
                    } else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer =='' || this.segmentoffer ==null|| this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                        ]
                    }
                } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                    if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile Dealer", value: "Mobile Dealer" },
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    } 
                    else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                        return [
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    }
                }
            }
        }
            if( this.offreadsl  == true ){
                if( this.offreftth  == false ){
                if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                    if ((this.segmentoffer ==''|| this.segmentoffer ==null || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                        if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'ADSL' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {
        
                            return [
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Prépayé'  && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }// ANO 9337 10/05/2023 CHB 
                        else if (this.segmentoffer == 'Postpayé'  && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                            return [
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Autres articles", value: "Article non sérialisé" },
    
                            ]
                        }

                        else if (this.segmentoffer =='' && this.profile == 'profilphase3') {
                            [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                            ]
                        }
                        else {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }
                    } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "ADSL", value: "ADSL" },
                            { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                        ]
                    } else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                        ]
                    }
                } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                    if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile Dealer", value: "Mobile Dealer" },
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    } 
                    else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                        return [
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    }
                }
            }}
            if( this.offreadsl  == true ){
                if( this.offreftth  == true ){
                if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                    if ((this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                        if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "FTTH", value: "FTTH" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        }
                        else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'ADSL' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {
        
                            return [
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Prépayé'  && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        } // ANO 9337 10/05/2023 CHB
                        else if (this.segmentoffer == 'Postpayé'  && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                            return [
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Autres articles", value: "Article non sérialisé" },
    
                            ]
                        }
                        else if (this.segmentoffer =='' && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "FTTH", value: "FTTH" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                            ]
                        }
                        else {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "ADSL", value: "ADSL" },
                                { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                                { label: "FTTH", value: "FTTH" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }
                    } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "ADSL", value: "ADSL" },
                            { label: "Déménagement ADSL", value: "Déménagement ADSL" },

                            { label: "FTTH", value: "FTTH" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                        ]
                    } else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                        ]
                    }
                } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                    if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile Dealer", value: "Mobile Dealer" },
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    } 
                    else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                        return [
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    }
                }
            } }
            if( this.offreftth  == true ){
                console.log("offreftth TNR");

                if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                    if ((this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                        if (this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' &&  this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "FTTH", value: "FTTH" },
        
                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {
        
                            return [
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            ]
                        } else if ((this.segmentoffer == 'Prépayé' &&  this.offertype == 'Mobile Prépayé') && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        } //ANO 9337 10/05/2023 CHB
                        else if (this.segmentoffer == 'Postpayé'  && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                            return [
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Autres articles", value: "Article non sérialisé" },
    
                            ]
                        }
                        else {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "FTTH", value: "FTTH" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }
                    } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "FTTH", value: "FTTH" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                        ]
                    }
                    
                    else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente'  && this.segmentoffer == 'FTTH') {
                        return [
                           
                            { label: "Accessoire", value: "Accesoire Idar" },
                           
                        ]
                    }
                    else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                        ]
                    }
                } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                    if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile Dealer", value: "Mobile Dealer" },
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    } 
                    else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                        return [
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    }
                }
            }


            else{
                console.log("Prépayé TNR pas de permission Set Camelean");
                if (this.segmentmarche != 'Super Dealer' && this.segmentmarche != 'Dealer' && this.totalorderssubscriptions < this.maxcustomeractivesubscriptions) {
                    if ((this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Postpayé') && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' ) {
                        if (this.segmentoffer ==null && this.eligibility == 'EligibilePhase4' && this.offertype != 'idar duo' && this.offertype != 'FTTH' && this.offertype == null && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },

                                { label: "Autres articles", value: "Article non sérialisé" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accesoire", value: "Accesoire Idar" },
                            ]
                        } else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'idar duo' && this.profile == 'profilphase3') {
                            return [
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                            ]
                        } 
                        else if (this.segmentoffer == 'Postpayé' && this.eligibility == 'EligibilePhase4' && this.offertype == 'Mobile Postpayé' && this.profile == 'profilphase3') {
                            return [
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                                { label: "Autres articles", value: "Article non sérialisé" },

                            ]
                        }
                        else if ((this.segmentoffer == 'Prépayé' && this.offertype == 'Mobile Prépayé') && this.profile == 'profilphase3') {
                            return [
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }
                      

                        
                        else {
                            return [
                                { label: "Mobile Postpayé", value: "Postpaye" },
                                { label: "Mobile prépayé", value: "Prepaye" },
                                { label: "Home prépayé", value: "Home" },
                                { label: "Idar Duo", value: "idar duo" },
                                { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                                { label: "Data Only Postpayé", value: "Home Postpaye" },
                              
                                { label: "Terminal & Accessoire", value: "Accessoire" },
                                { label: "Autres articles", value: "Article non sérialisé" },
                            ]
                        }
                    } else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.impaye == 0 && this.hassuspfact == 0 && this.segmentoffer == 'Postpayé') {
                        return [
                            { label: "Mobile Postpayé", value: "Postpaye" },
                            { label: "Data Only Postpayé", value: "Home Postpaye" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                        ]
                    } 
                    
                    else if (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && this.segmentoffer == 'Prépayé' && this.profile == 'profilphase3') {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                            { label: "Terminal & Accessoire", value: "Accessoire" },
                            { label: "Autres articles", value: "Article non sérialisé" },
                        ]
                    }
                    
                    else if (this.segmentoffer == 'FTTH' && this.eligibility == 'EligibilePhase4' && this.offertype == 'FTTH' && this.segmentoffer == 'FTTH' && this.profile == 'profilphase3') {
                        return [
                            { label: "Accesoire", value: "Accesoire Idar" },
                        ]
                    } 
                    else if ((this.canal == 'inwiB2C_Eshop' || this.canal == 'inwiB2C_Televente') && (this.segmentoffer =='' || this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile prépayé", value: "Prepaye" },
                            { label: "Home prépayé", value: "Home" },
                        ]
                    }
                } else if ((this.segmentmarche == 'Super Dealer' || this.segmentmarche == 'Dealer')) {
                    if (this.countallsubscriptions < this.maxdealeractivesubscriptions && this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente' && (this.segmentoffer ==''|| this.segmentoffer ==null || this.segmentoffer == 'Prépayé')) {
                        return [
                            { label: "Mobile Dealer", value: "Mobile Dealer" },
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    } 
                    else if (this.countallsubscriptions >= this.maxdealeractivesubscriptions && (this.canal != 'inwiB2C_Eshop' && this.canal != 'inwiB2C_Televente')) {
                        return [
                            { label: "Scratchcard Dealer", value: "Article non sérialisé" },
                        ]
                    }
                }
                else{
                    return [
                        { label: "Mobile Postpayé", value: "Postpaye" },
                        { label: "Mobile prépayé", value: "Prepaye" },
                        { label: "Idar Duo", value: "idar duo" },
                        { label: "Accessoires Idar Duo", value: "Accesoire Idar" },
                        { label: "Home prépayé", value: "Home" },
                        { label: "Data Only Postpayé", value: "Home Postpaye" },

                        { label: "Autres articles", value: "Article non sérialisé" },
                        { label: "Terminal & Accessoire", value: "Accessoire" },
                    ]
                }
            }
       
        }}


       
        handleChange(event) {
            let selectedOption = event.detail.value;
            this.value = event.detail.value;

             const labelOption = this.options.find(option => option.value === this.value);
            this.selectedLabel = labelOption ? labelOption.label : '';
        
          if( selectedOption!=null || selectedOption!=''){
            this.labelstep=true;
          }
          
       // let selectedLine = this.options.find(x => x.value === event.detail.value).label;
         console.log('Option selected with value: ' + this.selectedLabel);

       // console.log(JSON.stringify(selectedLine));

        let choice= {
        SelectedFamily: selectedOption,
        };

        this.omniUpdateDataJson(choice);
        this.omniSaveState(choice, true);
        }
        connectedCallback() {
            console.log("this.segmentoffer2"+this.segmentoffer)
            console.log("this.offertype"+this.offertype)
            console.log("this.profile"+this.profile)
            console.log("this.segmentoffer2"+this.segmentoffer)
            console.log("this.segmentoffer2"+this.segmentoffer)

            this.options = this.getoptions();
        }
        gotonextStep() {
            this.omniNextStep();
        }
    
    }