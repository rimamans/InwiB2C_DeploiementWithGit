/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
global without sharing  class inwib2c_CreateOrderEshop implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName == 'CreateOrderEshop') {
            outMap.put('result', CreateOrderEshop(inputMap));
        }
        return true;
    }
    
    //CallapplyAdjustment
    public void constructInputParams(String orderId, String itemId, Decimal terminalPrice) {
        Map<String, Object> inputParams = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        
        
        List<Map<String, Object>> adjustments = new List<Map<String, Object>>();
        Map<String, Object> adjustment = new Map<String, Object>();
        adjustment.put('AdjustmentMethod', 'Absolute');
        adjustment.put('AdjustmentType', 'Override');
        adjustment.put('AdjustmentValue', terminalPrice);
        adjustment.put('DetailType', 'OVERRIDE');
        adjustment.put('Field', 'vlocity_cmt__OneTimeCharge__c');
        adjustment.put('PricingVariableCode', 'OT_STD_PRC');
        
        adjustments.add(adjustment);
        
        inputParams.put('adjustments', adjustments);
        inputParams.put('cartId', orderId);
        inputParams.put('id', itemId);
        inputParams.put('methodName', 'applyAdjustment');
        System.debug('Constructed inputParams: ' + inputParams);
        vlocity_cmt.CpqAppHandler applyAdjustmentItem = new vlocity_cmt.CpqAppHandler();
        try {
            applyAdjustmentItem.invokeMethod('applyAdjustment', inputParams, outputMap, null);
            System.debug('After Call applyAdjustment: ');
            System.debug('Output Map after applying adjustment: ' + outputMap);
        } catch (Exception e) {
            // Handle the exception here
            System.debug('Error while applying adjustment: ' + e.getMessage());
        }
    }
    
    Map<String,Object> CreateOrderEshop(Map<String,Object> inputMap) {
        
        System.debug('Amine brm');
        
        String traceId=(String) inputMap.get('TraceId');
        
        System.debug('TraceId' +traceId);
        InwiB2C_Trace_API__c traceObj = [select id,CreatedDate, InwiB2C_Object_Number__c, InwiB2C_request_body__c from InwiB2C_Trace_API__c where id = :traceId];
        inwib2c_TraceDemandeEshop__c traceEshop = [select id,Inwib2c_Id_Panier__c,IdTraceAPI__c, inwib2c_Avec_ou_sans_engagement__c, inwib2c_Date_Finalisation_Commande__c, inwib2c_Flag_Porta__c, inwib2c_FMD_Total__c, inwib2c_FMS_Total__c, inwib2c_MDN__c, inwib2c_Mode_de_livraison__c, inwib2c_Mode_de_paiement__c, inwib2c_Montant_de_la_commande__c, inwib2c_Num_ro_de_la_demande__c, inwib2c_Offre_choisi__c, inwib2c_OrderId__c, inwib2c_Prix_Terminal_Total__c, inwib2c_Statut__c, inwib2c_Statut_paiement__c, inwib2c_Terminal_choisi__c,inwib2cReference_Paiement_FMS__c,inwib2cReference_Paiement_FMD__c,inwib2cReference_Paiement_Terminaux__c  from inwib2c_TraceDemandeEshop__c where IdTraceAPI__c = :traceId];
        Map <String, Object> inputJsonMap = (Map <String, Object>) JSON.deserializeUntyped(traceObj.InwiB2C_request_body__c);
        String customerId=(String)inputJsonMap.get('customerId');
        String buyerId=(String)inputJsonMap.get('buyerId');
        String idsaporder= (String)inputJsonMap.get('idsaporder');
        String paymentMethod=(String)inputJsonMap.get('paymentMethod');
        String paymentReference=(String)inputJsonMap.get('paymentReference');
        String siteId=(String)inputJsonMap.get('siteId');
        String promo=(String)inputJsonMap.get('promo');
        Boolean submite=Boolean.valueOf(inputJsonMap.get('submite'));
        Boolean waitpayment=Boolean.valueOf(inputJsonMap.get('waitpayment'));
        
        //case-insensitive
        // String submiteUpper = submite.toUpperCase();
        // String waitpaymentUpper = waitpayment.toUpperCase();
        
        
        
        String type='';
        String codeliv='';
        DOUBLE deliveryPrice;
        String typelivraison='';
        String agenceId;
        String canal='inwiB2C_Eshop';
        String statut='inwiB2C_EnCours';
        String modepayement ='';
        String offerType='';
        String typedeProduit='';
        String codedeProduit='';
        String statutSubmitOk='inwiB2C_Activation';
        String statutEshopSubmitOk='Inwib2c_Commande_livrée';
        String familyProduct='';
        String flagSuiviFTTHADSL='';
        //String siteId='';
        
        if (paymentMethod=='CB') {
            modepayement='inwiB2C_E-paiement';
            
        } /*else {
            if (paymentMethod=='CB') {
                modepayement='inwiB2C_TPE';
            }*/
            else if (paymentMethod == 'EB') {
                modepayement = 'inwiB2C_Fatourati';
            }else {
                modepayement='inwiB2C_EnEspece';
                
            }
            
        // }
        
        List<Map<String, Object>> deliveryList = new List<Map<String, Object>>();
        Map<String, Object> delivery = (Map<String, Object>) inputJsonMap.get('delivery');
        deliveryList.add(delivery);
        for (Map<String, Object> deliveryItem : deliveryList) {
            type = (String) deliveryItem.get('type');
            codeliv = (String) deliveryItem.get('codeliv');
            agenceId = (String) deliveryItem.get('agenceId');
            // deliveryPrice = (DOUBLE) deliveryItem.get('deliveryPrice');
            deliveryPrice = Double.valueOf(deliveryItem.get('deliveryPrice'));
            
            
        }
        
        if (type=='DOMICILE') {
            typelivraison='inwiB2C_Domicile';
            
            
        }else {
            typelivraison='inwiB2C_Agence';
        }
        
        System.debug('TraceId' +traceId);
        System.debug('customerId' +customerId);
        System.debug('buyerId' +buyerId);
        System.debug('paymentMethod' +paymentMethod);
        System.debug('paymentReference' +paymentReference);
        System.debug('Type' +type);
        System.debug('codeliv' +codeliv);
        System.debug('deliveryPrice' +deliveryPrice);
        System.debug('Type DE LIvraison' +typelivraison);
        System.debug('Promo' +promo);
        
        List<String> productCodes = new List<String>();
        //List<String> productCodesForUpdateCodeOffrePrepayVaccay = new List<String>();
        
        List<Object> products = (List<Object>) inputJsonMap.get('products');
        List<Map<String, Object>> codeProduit = new List<Map<String, Object>>();
        Map <String, Object> product = (Map <String, Object>) products[0];
        codeProduit.add(product);
        string codeOffre='';
        String  profil='';
        String engagement='';
        // Variables to store the prices
        Decimal fmsPrice=0;
        Decimal fmdPrice;
        Decimal terminalPrice=0;
        String subProductPriceType;
        //String subProductPriceAmount;
        Double subProductPriceAmount;
        // Declare a variable to store the total amountof terminaux
        Decimal totalProductAmount=0;
        // Initialize the variable to store the retrieved value
        String modelValue;
        //Initialize variable for stock the recalculated price
        Decimal recalculAmount=0;
        //initialise date
        Date creationdate= null;
        List<Decimal> productAmountsList = new List<Decimal>();
        
        
        // for (Map<String, Object> CodeItem : codeProduit) {
            //     String tempCodeOffre = (String) CodeItem.get('code');
            //     profil = (String) CodeItem.get('idProfile');
            //     engagement = (String) CodeItem.get('engagement');
            
            //     if (tempCodeOffre.equals('TERMINAL')) {
                //         codeOffre = 'INWIB2C_OFFERING_TERMINAL';
            //     } else {
                //         codeOffre = tempCodeOffre;
            //     }
        // }
        
        for (Map<String, Object> CodeItem : codeProduit) {
            String tempCodeOffre = (String) CodeItem.get('code');
            System.debug('tempCodeOffre' +tempCodeOffre);
            profil = (String) CodeItem.get('idProfile');
            engagement = (String) CodeItem.get('engagement');
            
            if (tempCodeOffre.equals('TERMINAL')) {
                codeOffre = 'INWIB2C_OFFERING_TERMINAL';
            } else if (tempCodeOffre.equals('INWIB2C_OFFERING_TICTAC')) {
                codeOffre = 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL';
            } else if (tempCodeOffre.equals('INWIB2C_OFFERING_VACANCIER100')) {
                codeOffre = 'INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL';
            } else if (tempCodeOffre.equals('INWIB2C_OFFERING_VACANCIER15')) {
                codeOffre = 'INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL';
            } else if (tempCodeOffre.equals('INWIB2C_OFFERING_VACANCIER30')) {
                codeOffre = 'INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL';
            } else {
                codeOffre = tempCodeOffre;
            }
        }
        
        
        
        System.debug('codeOffre' +codeOffre);
        System.debug('profil' +profil);
        System.debug('engagement' +engagement);
        
        //Mise a jour pour les offres prepay et vaccay pour ajouter sans ou avec terminal
        
        //boucler sur les sous produit:
        if (codeOffre!='INWIB2C_OFFERING_TERMINAL' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast'&& codeOffre!='InwiB2C_TELEPHONE_FIXE'){
            List<Object> subProducts = (List<Object>) product.get('subProducts');
            
            if (subProducts != null) {
                for (Object subProductObj : subProducts){
                    Map <String, Object> subProduct = (Map <String, Object>) subProductObj;
                    
                    
                    List<string> codeattribute = new List<String>();
                    
                    
                    String productCode = (String) subProduct.get('code');
                    String productType = (String) subProduct.get('type');
                    // productCodes.add(productCode);
                    //productCodesForUpdateCodeOffrePrepayVaccay.add('productCode');
                    //    if (codeOffre == 'INWIB2C_OFFERING_TICTAC' && productCode == 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL';
                    // } else if (codeOffre == 'INWIB2C_OFFERING_TICTAC' && productCode != 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL';
                    // } else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER100' && productCode == 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_VACANCIER100_AVEC_TERMINAL7';
                    // } else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER100' && productCode != 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL';
                    // } else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER15 ' && productCode == 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL15';
                    // } else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER200' && productCode != 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL';
                    // }else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER30  ' && productCode == 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL30';
                    // } else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER30 ' && productCode != 'TERMINAL') {
                        //     codeOffre = 'INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL';
                    // }
                    
                    
                    if (productType.equals('Handset')) {
                        //Evolution recalcule des prix
                        Map<String,String> attributeinput = new Map<String,String>();
                        List<Object> attributes = (List<Object>) subProduct.get('attributes');
                        if (attributes != null){
                            
                            
                            for (Object attributeObj : attributes) {
                                
                                Map <String, Object> attribute = (Map <String, Object>) attributeObj;
                                if ( (String)attribute.get('value')!=null && ((String)attribute.get('value') ).length()>0)
                                {
                                    attributeinput.put((String)attribute.get('code'), (String)attribute.get('value'));
                                }
                                System.debug('LaListe attributs a changer leur prix est' +attributeinput);
                                
                            }
                            // Check if the key exists in the map
                            if (attributeinput.containsKey('INWIB2C_ATT_RT_MODELE')) {
                                // Retrieve the value associated with the key 'INWIB2C_ATT_RT_MODELE'
                                modelValue = attributeinput.get('INWIB2C_ATT_RT_MODELE');
                                System.debug('modelValue' +modelValue);
                                Datetime dateCreationeshopOrder=traceObj.CreatedDate;
                                System.debug('dateCreationeshopOrder'+dateCreationeshopOrder);
                                String dateCreatedOrder = dateCreationeshopOrder.format('yyyy-MM-dd');
                                System.debug('dateCreatedOrder'+dateCreatedOrder);
                                Integer year = Integer.valueOf(dateCreatedOrder.substring(0, 4));
                                Integer month = Integer.valueOf(dateCreatedOrder.substring(5, 7));
                                Integer day = Integer.valueOf(dateCreatedOrder.substring(8, 10));
                                creationdate = Date.newInstance(year, month, day);
                                inwiB2C_ModelePricelist__c terminalprix = [select id,inwiB2C_Modele__r.inwiB2C_Code_Article__c,inwiB2C_Canal__c,inwiB2C_Profil_IN__c, inwiB2CPrice__c from inwiB2C_ModelePricelist__c where inwiB2C_Canal__c ='inwiB2C_Eshop' and inwiB2C_CodeArticle__c =:modelValue and inwiB2C_Start_Date__c <= : creationdate and (inwiB2C_End_Date__c >= TODAY or inwiB2C_End_Date__c =null) limit 1 ];
                                System.debug('terminalprix' +terminalprix.inwiB2CPrice__c);
                                recalculAmount=terminalprix.inwiB2CPrice__c;
                                
                            }
                            
                            
                            
                        }
                        // fin Evolution recalcule des prix
                        Map<String, Object> subProductPrice = (Map<String, Object>) subProduct.get('price');
                        subProductPriceType = (String) subProductPrice.get('type');
                        //subProductPriceAmount = (String) subProductPrice.get('amount');
                        subProductPriceAmount = (Double) subProductPrice.get('amount');
                    }
                    // if (productCode.equals('INWIB2C_MOB02_OFFERING_TERMINAL')) {
                        //     terminalPrice = Decimal.valueOf(subProductPriceAmount);
                    // }
                    
                    
                    // Modify productCode if it meets the conditions
                    if (productCode == 'TERMINAL') {
                        
                        if (codeOffre == 'INWIB2C_OFFERING_49DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_199DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_99DH_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_APL' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLINWI_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_499DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_199DH_APL' || codeOffre == 'INWIB2C_OFFERING_249DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLINWI_APL'|| codeOffre == 'INWIB2C_OFFERING_FORFAIT149DH_APL'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI299DH'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI349DH' || codeOffre == 'INWIB2C_OFFERING_FORFAIT119DH_APL'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI499DH'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI649DH') {
                            productCode = 'INWIB2C_MOB02_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_MOB02_OFFERING_TERMINAL';
                        }
                        
                        
                        else if (codeOffre == 'INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE3_349DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE1_5G' || codeOffre == 'INWIB2C_OFFERING_FORMULE3_5G' || codeOffre == 'INWIB2C_OFFERING_FORMULE2_5G') {
                            productCode = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
                        }
                                            //Begin ACYL 30/05/2025 Ajustement ADSL 
                        else if (codeOffre=='INWIB2C_OFFERING_ADSL20MG_199DH'||codeOffre=='INWIB2C_OFFERING_ADSL_ESSENTIEL_149DH') {
                                                //END ACYL 30/05/2025 Ajustement ADSL 
                            productCode ='INWIB2C_DEG01_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_DEG01_OFFERING_TERMINAL';
                            familyProduct='ADSL';
                            flagSuiviFTTHADSL='ADSL_1';
                            
                        }
                        else if (codeOffre=='INWIB2C_OFFERING_FTTH50MG_349DH'||codeOffre=='INWIB2C_OFFERING_FTTH200MG_649DH'||codeOffre=='INWIB2C_OFFERING_FTTH20MG_249DH'||codeOffre=='INWIB2C_OFFERING_FTTH100MG_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'||codeOffre=='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'||codeOffre=='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH500MG3MOIS_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH500MG_749DH'|| codeOffre=='INWIB2C_OFFERING_FTTH1Gb_949DH' ) {
                            productCode ='INWIB2C_FOB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_FOB2C_OFFERING_TERMINAL';
                            familyProduct='FTTH';
                            flagSuiviFTTHADSL='FTTH_1';
                            
                            
                        }
                        // else if (codeOffre == 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' ||codeOffre =='INWIB2C_OFFERING_TERMINAL') {
                            //    productCode = 'INWIB2C_OFFERING_TERMINAL';
                            //    codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                        // }
                        else if ((codeOffre == 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' && promo!='SLD')||codeOffre =='INWIB2C_OFFERING_TERMINAL') {
                            codeOffre = 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL';
                            productCode = 'INWIB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                        }
                        else if (codeOffre == 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' && promo=='SLD') {
                            
                            codeOffre = 'INWIB2C_OFFERING_ACQUISITION_TERMINAUX';
                            productCode = 'INWIB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                            
                        }
                        else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL') {
                            codeOffre = 'INWIB2C_OFFERING_VACANCIER100_AVEC_TERMINAL7';
                            productCode = 'INWIB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                        }
                        else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL') {
                            codeOffre = 'INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL15';
                            productCode = 'INWIB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                        }
                        else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL') {
                            codeOffre = 'INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL30';
                            productCode = 'INWIB2C_OFFERING_TERMINAL';
                            codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                        }
                    }
                    System.debug('productCode'+productCode);
                    // Add the modified productCode to the productCodes list
                    productCodes.add(productCode);
                    system.debug('le type de sousProduit est:' +productType);
                    
                    if (productType.equals('Handset')) {
                        terminalPrice = Decimal.valueOf(subProductPriceAmount);
                        typedeProduit = 'Handset';
                        totalProductAmount = terminalPrice;
                    }
                    
                    
                    
                }
                // if (productCodesForUpdateCodeOffrePrepayVaccay.contains('TERMINAL')) {
                    
                // }
            }
        }
        //Mettre a jour l'offre dans table traceDemandeEshop
        traceEshop.inwib2c_Offre_choisi__c=codeOffre;
        update traceEshop;
        //fin
        
        if (codeOffre=='INWIB2C_OFFERING_TERMINAL'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast'||codeOffre=='InwiB2C_TELEPHONE_FIXE' ){
            //List<Object> subProducts = (List<Object>) product.get('subProducts');
            Map<String, Object> subProductPrice = (Map<String, Object>) product.get('price');
            subProductPriceType = (String) subProductPrice.get('type');
            subProductPriceAmount = (DOUBLE) subProductPrice.get('amount');
            terminalPrice = Decimal.valueOf(subProductPriceAmount);
        }
        productCodes.add(codeOffre);
        System.debug('codeOffreApresMaj' +codeOffre);
        system.debug('la listes des codes:' +productCodes);
        system.debug('le Prix de terminal:' +terminalPrice);
        System.debug('le Code produit est' +codedeProduit);
        
        
        
        // if (codeOffre =='INWIB2C_OFFERING_49DH_INTERNET' || codeOffre =='INWIB2C_OFFERING_199DH_INTERNET'|| codeOffre =='INWIB2C_OFFERING_99DH_APL' || codeOffre =='INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre =='INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre =='INWIB2C_OFFERING_149DH_APL' || codeOffre =='INWIB2C_OFFERING_99DH_ILLIMITE_RS'|| codeOffre =='INWIB2C_OFFERING_149DH_INTERNET'|| codeOffre =='INWIB2C_OFFERING_49DH_ILLINWI_APL'|| codeOffre =='INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite'|| codeOffre =='INWIB2C_OFFERING_499DH_TOUT'|| codeOffre =='INWIB2C_OFFERING_199DH_APL' || codeOffre =='INWIB2C_OFFERING_249DH_TOUT'|| codeOffre =='INWIB2C_OFFERING_99DH_ILLINWI_APL'|| codeOffre == 'INWIB2C_OFFERING_FORFAIT149DH_APL'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI299DH'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI349DH' ) {
            
            //     offerType='Mobile Postpayé';
        // }else {
            //     if (codeOffre =='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TERMINAL' ) {
                //         offerType='Mobile Prépayé';
            //     } else {
                //         // if(codeOffre =='INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre =='INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre =='INWIB2C_OFFERING_FORMULE3_349DH') {
                    //         //     offerType='Home Postpayé';
                //         // }
                //         offerType='Home Postpayé';
                
            //     }
            
        // }
        Product2 typeoffre =[select id , vlocity_cmt__Type__c,ProductCode,  vlocity_cmt__SpecificationType__c from product2 where vlocity_cmt__SpecificationType__c ='Offer' AND ProductCode =:codeOffre AND IsActive=true limit 1] ;
        // if (codeOffre == 'INWIB2C_OFFERING_TERMINAL'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast'||codeOffre=='InwiB2C_TELEPHONE_FIXE') {
            //     offerType = '';
        // } else if (codeOffre == 'INWIB2C_OFFERING_49DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_199DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_99DH_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_APL' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLINWI_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_499DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_199DH_APL' || codeOffre == 'INWIB2C_OFFERING_249DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLINWI_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT149DH_APL' || codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI299DH' || codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI349DH' || codeOffre == 'INWIB2C_OFFERING_FORFAIT119DH_APL'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI499DH'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI649DH') {
            //     offerType = 'Mobile Postpayé';
        // } else if (codeOffre == 'INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL' || codeOffre == 'INWIB2C_OFFERING_VACANCIER100_AVEC_TERMINAL7' || codeOffre == 'INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL' || codeOffre == 'INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL15' || codeOffre == 'INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL' || codeOffre == 'INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL30') {
            //     offerType = 'Home Prépayé';
        // }else {
            
            //     if (codeOffre == 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || codeOffre == 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' || codeOffre=='INWIB2C_OFFERING_ACQUISITION_TERMINAUX') {
                //         offerType = 'Mobile Prépayé';
            //     } else {
                //         offerType = 'Home Postpayé';
            //     }
        // }
        
        offerType=typeoffre.vlocity_cmt__Type__c;
        System.debug('type de l offre' +offerType);
        
        // if (codeOffre =='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL'|| codeOffre=='INWIB2C_OFFERING_ACQUISITION_TERMINAUX' ||codeOffre=='INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL'|| codeOffre=='INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL'|| codeOffre=='INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL'|| codeOffre=='INWIB2C_OFFERING_VACANCIER100_AVEC_TERMINAL7'|| codeOffre=='INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL15'|| codeOffre=='INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL30') {
            //     productCodes.add('INWIB2C_OFFERING_OPT_ROAMING');
        // }
        
        if (codeOffre!='INWIB2C_OFFERING_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_ACQUISITION_TERMINAUX'&& codeOffre!='INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER100_AVEC_TERMINAL7'&& codeOffre!='INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL15'&& codeOffre!='INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL30'&& codeOffre!='INWIB2C_OFFERING_FTTH50MG_349DH'&& codeOffre!='INWIB2C_OFFERING_FTTH200MG_649DH'&& codeOffre!='INWIB2C_OFFERING_FTTH20MG_249DH'&&codeOffre!='INWIB2C_OFFERING_FTTH100MG_449DH'&&codeOffre!='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'&&codeOffre!='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'&&codeOffre!='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' && codeOffre!='InwiB2C_TELEPHONE_FIXE') {
            //List<Object> additionalPayments = (List<Object>) product.get('aditionalPayments');
            Map<String, Object> price = (Map<String, Object>) product.get('price');
            List<Object> additionalPayments = (List<Object>) price.get('aditionalPayments');
            // Extract the prices
            for (Object paymentObj : additionalPayments) {
                Map<String, Object> payment = (Map<String, Object>) paymentObj;
                String paymentType = (String) payment.get('type');
                DOUBLE paymentPrice = (DOUBLE) payment.get('price');
                
                if (paymentType.equals('FMS')) {
                    fmsPrice = Decimal.valueOf(paymentPrice);
                } else if (paymentType.equals('FMD')) {
                    fmdPrice = Decimal.valueOf(paymentPrice);
                }
            }
            
        }
        
        
        
        // Display the prices
        System.debug('FMS (First Monthly Discount) has a price of $' + fmsPrice + '.');
        System.debug('FMD (Second Monthly Discount) has a price of $' + fmdPrice + '.');
        List<Account> accagenceList ;
        //Account acc = [select Id,ParentId from account where inwiB2C_TypePartenaire__c =:'inwiB2C_Agence' AND inwib2c_CodePartenaire__c = :'CMS23'];
        Account acc = [select Id,ParentId,RecordType.Name from account where inwib2c_CodePartenaire__c =:'CMS23' AND RecordType.DeveloperName = :'inwib2c_Partenaire'AND ParentId !=null limit 1];
        if(agenceId!=null && agenceId!='undefined'){
            accagenceList = [select Id,ParentId from account where inwiB2C_TypePartenaire__c =:'inwiB2C_Agence' AND inwib2c_CodePartenaire__c = :agenceId AND RecordType.DeveloperName = :'inwib2c_Partenaire'AND ParentId !=null AND inwib2c_POS__c =:'inwib2c_OS' limit 1];
        }
        inwib2c_OrderTemplateEshop__mdt Obj = [select OrderId__c, CodeProduct__c from inwib2c_OrderTemplateEshop__mdt where  CodeProduct__c= :codeOffre];
        System.debug('metadata' +Obj);
        //Get the Original order
        List<Order> OrderOriginal= [SELECT Pricebook2Id, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, AccountId, status, EffectiveDate,inwib2c_ModeDeLivraison__c, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,InwiB2C_Offre__c,vlocity_cmt__DefaultBillingAccountId__c,inwib2c_CodeDeTransaction__c from order where id = :Obj.OrderId__c limit 1];
        
        
        //    //boucler sur les sous produit:
        //    if (codeOffre!='INWIB2C_OFFERING_TERMINAL'){
            //     List<Object> subProducts = (List<Object>) product.get('subProducts');
            
            
            //     for (Object subProductObj : subProducts){
                //         Map <String, Object> subProduct = (Map <String, Object>) subProductObj;
                
                //         List<string> codeattribute = new List<String>();
                
                
                //         String productCode = (String) subProduct.get('code');
                //         String productType = (String) subProduct.get('type');
                //        // productCodes.add(productCode);
                
                
                
                //         Map<String, Object> subProductPrice = (Map<String, Object>) subProduct.get('price');
                //         String subProductPriceType = (String) subProductPrice.get('type');
                //         String subProductPriceAmount = (String) subProductPrice.get('amount');
                
                //         // if (productCode.equals('INWIB2C_MOB02_OFFERING_TERMINAL')) {
                    //         //     terminalPrice = Decimal.valueOf(subProductPriceAmount);
                //         // }
                
                //         // Modify productCode if it meets the conditions
                // if (productCode == 'TERMINAL') {
                    
                    //     if (codeOffre == 'INWIB2C_OFFERING_49DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_199DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_99DH_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_APL' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLINWI_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_499DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_199DH_APL' || codeOffre == 'INWIB2C_OFFERING_249DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLINWI_APL') {
                        //         productCode = 'INWIB2C_MOB02_OFFERING_TERMINAL';
                        //         codedeProduit = 'INWIB2C_MOB02_OFFERING_TERMINAL';
                    //     }
                    
                    
                    //     else if (codeOffre == 'INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE3_349DH') {
                        //         productCode = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
                        //         codedeProduit = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
                    //     } else if (codeOffre == 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' ||codeOffre =='INWIB2C_OFFERING_TERMINAL') {
                        //         productCode = 'INWIB2C_OFFERING_TERMINAL';
                        //         codedeProduit = 'INWIB2C_OFFERING_TERMINAL';
                    //     }
                // }
                //    System.debug('productCode'+productCode);
                // // Add the modified productCode to the productCodes list
                // productCodes.add(productCode);
                //         system.debug('le type de sousProduit est:' +productType);
                
                //         if (productType.equals('Handset')) {
                    //                 terminalPrice = Decimal.valueOf(subProductPriceAmount);
                    //                 typedeProduit = 'Handset';
                //              }
                
                
                
            //     }
        // }
        
        
        // if (codeOffre=='INWIB2C_OFFERING_TERMINAL'){
            //     //List<Object> subProducts = (List<Object>) product.get('subProducts');
            //     Map<String, Object> subProductPrice = (Map<String, Object>) product.get('price');
            //         String subProductPriceType = (String) subProductPrice.get('type');
            //         String subProductPriceAmount = (String) subProductPrice.get('amount');
            //         terminalPrice = Decimal.valueOf(subProductPriceAmount);
        // }
        
        // system.debug('la listes des codes:' +productCodes);
        // system.debug('le Prix de terminal:' +terminalPrice);
        // System.debug('le Code produit est' +codedeProduit);
        
        //Clone order from the  OrderBase
        Order newOrder =  OrderOriginal[0].clone(false, true, false, true);
        
        newOrder.EffectiveDate = date.today();
        newOrder.AccountId = customerId;
        newOrder.InwiB2C_Type_Offer__c = offerType;
        newOrder.inwib2c_Partenaire__c = acc.Id;
        newOrder.inwib2c_Distributeur__c = acc.ParentId;
        
        
        if (submite) {
            System.debug('submit' + submite);
            System.debug('status eshop ' + statutEshopSubmitOk);
            newOrder.inwiB2C_Statut__c = statutSubmitOk;
            newOrder.Inwib2c_statut_Eshop__c = statutEshopSubmitOk;
        }else {
            newOrder.inwiB2C_Statut__c = statut;
        }
        
        
        newOrder.inwib2c_ModeDePaiement__c = modepayement;
        newOrder.InwiB2C_Id_Panier_Eshop__c=traceEshop.Inwib2c_Id_Panier__c;
        if (fmsPrice>0) {
            newOrder.InwiB2C_Mode_de_paiement_FMS__c = modepayement;
            
        }
        if (fmdPrice>0) {
            newOrder.Mode_de_paiement_FMD__c = modepayement;
            
        }
        newOrder.inwiB2C_Canal__c= canal;
        newOrder.inwib2c_ModeDeLivraison__c = typelivraison;
        //newOrder.inwib2c_CodeDeTransaction__c = paymentReference;
        if(agenceId!=null && agenceId!='undefined' && agenceId!=''){
            if (!accagenceList.isEmpty()){
                Account accagence = accagenceList[0];
                newOrder.inwib2c_AgenceDeLivraison__c = accagence.Id;
                
                newOrder.inwib2c_AgenceDeLivraison__c =accagence.Id;
            }
        }
        newOrder.InwiB2C_code_de_transaction_Eshop__c=paymentReference;
        if (siteId!=null && siteId!='undefined' &&siteId!='') {
            newOrder.vlocity_cmt__DefaultServiceAccountId__c =siteId;
            
            
        }
        //  if (paymentReference!=null && fmsPrice>0 ) {
            //      newOrder.InwiB2C_Code_de_transaction_FMS__c=paymentReference;
            
        //  }
        //  if (paymentReference!=null && fmdPrice>0) {
            //      newOrder.InwiB2C_CodeTransactionFMD__c=paymentReference;
            
        //  }
        
        //  if (paymentReference!=null && (codeOffre=='INWIB2C_OFFERING_TERMINAL' || codedeProduit == 'INWIB2C_OFFERING_TERMINAL'||codedeProduit == 'INWIB2C_MOB02_OFFERING_TERMINAL'|| codedeProduit == 'INWIB2C_OPB2C_OFFERING_TERMINAL')) {
            //      newOrder.inwib2c_CodeDeTransaction__c=paymentReference;
            
        //  }
        // if (typedeProduit=='Handset' || codeOffre=='INWIB2C_OFFERING_TERMINAL') {
            //     //newOrder.vlocity_cmt__EffectiveOrderTotal__c = terminalPrice;
        //  }
        
        
        if (buyerId!=null && buyerId!='undefined' &&buyerId!=''){
            newOrder.vlocity_cmt__DefaultBillingAccountId__c = buyerId;
        }
        if (idsaporder!= null && idsaporder!='undefined' && idsaporder!=''){
            newOrder.InwiB2C_PreOrderSapId__c = idsaporder;
            
        }
        //Amine brm Statut Lastmile a l'initialisation de la commande
        // M-Dj 1/11/24 eviter d'ecrasser le status eshop pour un submit a Oui begin
        if (typelivraison=='inwiB2C_Domicile' && !submite){
            // M-Dj 1/11/24 eviter d'ecrasser le status eshop pour un submit a Oui end
            newOrder.Inwib2c_statut_Eshop__c = 'Inwib2c_En_cours_de_confirmation';
        }
        if (waitpayment) {
            if (traceEshop.inwib2cReference_Paiement_FMS__c != null && !traceEshop.inwib2cReference_Paiement_FMS__c.equals('')) {
                newOrder.InwiB2C_Code_de_transaction_FMS__c=traceEshop.inwib2cReference_Paiement_FMS__c;
            }
            
            if (traceEshop.inwib2cReference_Paiement_FMD__c != null && !traceEshop.inwib2cReference_Paiement_FMD__c.equals('')) {
                newOrder.InwiB2C_CodeTransactionFMD__c=traceEshop.inwib2cReference_Paiement_FMD__c;
                
            }
            
            if (traceEshop.inwib2cReference_Paiement_Terminaux__c != null && !traceEshop.inwib2cReference_Paiement_Terminaux__c.equals('')) {
                newOrder.inwib2c_CodeDeTransaction__c=traceEshop.inwib2cReference_Paiement_Terminaux__c;
                
            }
        }
        
        
        insert newOrder;
        
        System.debug('NewOrderId' +newOrder.Id);
        
        //InwiB2C_Trace_API__c traceObj = [select id, InwiB2C_Object_Number__c, InwiB2C_request_body__c,InwiB2C_Response__c  from InwiB2C_Trace_API__c where id = :traceId];
        // Modify the field value
        //traceObj.InwiB2C_Object_Number__c = newOrder.Id;
        
        // Update the record in the database
        //update traceObj;
        
        
        
        List<String> productItemId = new List<String>();
        //clonerOrderItem
        
        List<OrderItem> NewOrderItems= new List<OrderItem>();
        List<OrderItem> OrderItemsWhereParentNotNull =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId,Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :Obj.OrderId__c AND vlocity_cmt__ParentItemId__c !=null  limit 20];
        for (OrderItem orderItem : OrderItemsWhereParentNotNull) {
            productItemId.add(orderItem.Product2Id);
        }
        
        system.debug('Id des Product2: ' +  productItemId);
        List<OrderItem> OrderItemsFromOrderBase =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId, Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :Obj.OrderId__c  limit 20];
        Map<String,String> ProductCodeByItemIdMap= new Map<String,String>();
        for (OrderItem Item :OrderItemsFromOrderBase){
            
            ProductCodeByItemIdMap.put(item.id, item.Product2Id);
            
        }
        if (codeOffre!='INWIB2C_OFFERING_TERMINAL' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' && codeOffre!='InwiB2C_TELEPHONE_FIXE') {
            
            for (OrderItem Item :OrderItemsFromOrderBase)
            {
                OrderItem newOrderItem; // = new OrderItem();
                String parentProductId = ProductCodeByItemIdMap.get(Item.vlocity_cmt__ParentItemId__c);
                system.debug('Id de Produit Parent: ' +  parentProductId);
                system.debug('Id de Produit Parent2: ' +  item.Product2Id);
                vlocity_cmt__ProductChildItem__c childItemDef = new vlocity_cmt__ProductChildItem__c();
                if (parentProductId != null){
                    childItemDef = [select vlocity_cmt__MinQuantity__c,vlocity_cmt__Quantity__c from vlocity_cmt__ProductChildItem__c where vlocity_cmt__ParentProductId__c = :parentProductId and vlocity_cmt__ChildProductId__c  = :Item.Product2Id limit 1];
                }
                
                //vlocity_cmt__ProductChildItem__c childItemDef = [SELECT vlocity_cmt__MinQuantity__c FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c = :parentProductId AND vlocity_cmt__ChildProductId__c IN:productItemId LIMIT 1];
                
                if (Item.vlocity_cmt__ParentItemId__c == null ||  (parentProductId != null && childItemDef.vlocity_cmt__Quantity__c == 1) || productCodes.contains(Item.Product2.ProductCode)){
                    newOrderItem = Item.clone(false, true, false, true);
                    newOrderItem.OrderId = newOrder.Id;
                    //newOrderItem.vlocity_cmt__AssetReferenceId__c = null;
                    if (siteId==null||siteId=='') {
                        newOrderItem.vlocity_cmt__ServiceAccountId__c = customerId;
                        
                    }
                    if (buyerId!=null && buyerId!='undefined' &&buyerId!=''){
                        newOrderItem.vlocity_cmt__BillingAccountId__c = buyerId;
                    }
                    if (siteId!=null && siteId!='undefined' &&siteId!='') {
                        newOrderItem.vlocity_cmt__ServiceAccountId__c =siteId;
                        
                    }
                    if (waitpayment) {
                        if (traceEshop.inwib2cReference_Paiement_FMS__c != null && !traceEshop.inwib2cReference_Paiement_FMS__c.equals('')) {
                            newOrderItem.InwiB2C_TransactionCode_FMS__c=traceEshop.inwib2cReference_Paiement_FMS__c;
                        }
                        
                        if (traceEshop.inwib2cReference_Paiement_FMD__c != null && !traceEshop.inwib2cReference_Paiement_FMD__c.equals('')) {
                            newOrderItem.InwiB2C_TransactionCode_FMD__c=traceEshop.inwib2cReference_Paiement_FMD__c;
                            
                        }
                        
                        if (traceEshop.inwib2cReference_Paiement_Terminaux__c != null && !traceEshop.inwib2cReference_Paiement_Terminaux__c.equals('')) {
                            newOrderItem.inwib2c_TransactionCode__c=traceEshop.inwib2cReference_Paiement_Terminaux__c;
                            
                        }
                    }
                    //newOrderItem.vlocity_cmt__OneTimeCharge__c = terminalPrice;
                    NewOrderItems.add(newOrderItem);
                    system.debug('ORDER ITEM : ' + newOrder.Id);
                }
                
                
            }
        }
        
        if (codeOffre=='INWIB2C_OFFERING_TERMINAL'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' ||codeOffre=='InwiB2C_TELEPHONE_FIXE') {
            // Declare a counter variable
            Integer lineNumberCounter = 1;
            //List<Map<String, Object>> productsForTerminalQuantity = (List<Map<String, Object>>) inputJsonMap.get('products');
            List<Object> productsForTerminalQuantity = (List<Object>) inputJsonMap.get('products');
            
            //for (Map<String, Object> productterminal : productsForTerminalQuantity)
            
            for (Object productterminal : productsForTerminalQuantity)
            {
                Map<String, Object> productMap = (Map<String, Object>) productterminal;
                Integer productQuantity = 1; // Default to 1 if 'quantity' is not present
                if (productMap.containsKey('quantity')) {
                    productQuantity = ((Decimal) productMap.get('quantity')).intValue(); // Extract and convert to Integer
                }
                System.debug('la quantite' +productQuantity);
                //Decimal productAmount = (Decimal) ((Map<String, Object>) productMap.get('price')).get('amount'); // Extract the amount value
                
                Map<String, Object> priceMap = (Map<String, Object>) productMap.get('price');
                Double amountAsString = (Double) priceMap.get('amount'); // Get the 'amount' as string from the price map
                Decimal productAmount = Decimal.valueOf(amountAsString); // Convert the string to Decimal
                System.debug('le Prix avec quantite' +productAmount);
                // operations based on the quantity
                for (Integer i = 0; i < productQuantity; i++) {
                    // Clone the item and assign values
                    for (OrderItem Item :OrderItemsFromOrderBase){
                        OrderItem newOrderItem = Item.clone(false, true, false, true);
                        newOrderItem.OrderId = newOrder.Id;
                        //newOrderItem.vlocity_cmt__AssetReferenceId__c = null;
                        newOrderItem.vlocity_cmt__ServiceAccountId__c = customerId;
                        
                        // Format the lineNumberCounter to have leading zeros
                        String formattedLineNumber = String.valueOf(lineNumberCounter).leftPad(4, '0');
                        //String formattedLineNumber = String.format('%04d', lineNumberCounter);
                        // Set the LineNumber field
                        newOrderItem.vlocity_cmt__LineNumber__c = formattedLineNumber;
                        
                        if (waitpayment) {
                            // if (traceEshop.inwib2cReference_Paiement_FMS__c != null && !traceEshop.inwib2cReference_Paiement_FMS__c.equals('')) {
                                //     newOrderItem.InwiB2C_Code_de_transaction_FMS__c=traceEshop.inwib2cReference_Paiement_FMS__c;
                            //   }
                            
                            //  if (traceEshop.inwib2cReference_Paiement_FMD__c != null && !traceEshop.inwib2cReference_Paiement_FMD__c.equals('')) {
                                //     newOrderItem.InwiB2C_CodeTransactionFMD__c=traceEshop.inwib2cReference_Paiement_FMD__c;
                                
                            //  }
                            
                            if (traceEshop.inwib2cReference_Paiement_Terminaux__c != null && !traceEshop.inwib2cReference_Paiement_Terminaux__c.equals('')) {
                                newOrderItem.inwib2c_TransactionCode__c=traceEshop.inwib2cReference_Paiement_Terminaux__c;
                                
                            }
                        }
                        NewOrderItems.add(newOrderItem);
                        system.debug('ORDER ITEM : ' + newOrder.Id);
                        // Increment the counter
                        lineNumberCounter++;
                    }
                }
            }
        }
        
        Insert NewOrderItems;
        
        
        Map<String, Id> MapOrderItemsLevels = new Map<String, Id>();
        String OrderItemParentId;
        
        for (OrderItem NewOrderItem : NewOrderItems)
        {
            MapOrderItemsLevels.put(NewOrderItem.vlocity_cmt__LineNumber__c,NewOrderItem.Id );
            
        }
        
        OrderItemParentId = MapOrderItemsLevels.get('0001');
        System.debug('orderItemParentId' +OrderItemParentId);
        System.debug('MapOrderItemsLevels' +MapOrderItemsLevels);
        List<OrderItem> UpdatedOrderItems = new List<OrderItem>();
        for (OrderItem NewOrderItem : NewOrderItems)
        {
            // 1 ere niveau rien a faire
            if(NewOrderItem.vlocity_cmt__LineNumber__c.length()!= 4)
            {
                // 2eme niveau
                if (NewOrderItem.vlocity_cmt__LineNumber__c.length()== 9)
                {
                    NewOrderItem.vlocity_cmt__ParentItemId__c = MapOrderItemsLevels.get(NewOrderItem.vlocity_cmt__LineNumber__c.substring(0,4));
                }
                
                // 3eme niveau
                if (NewOrderItem.vlocity_cmt__LineNumber__c.length()== 14)
                {
                    NewOrderItem.vlocity_cmt__ParentItemId__c = MapOrderItemsLevels.get(NewOrderItem.vlocity_cmt__LineNumber__c.substring(0,9));
                }
            }
            if (codeOffre!='INWIB2C_OFFERING_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' && codeOffre!='InwiB2C_TELEPHONE_FIXE'){
                NewOrderItem.vlocity_cmt__RootItemId__c = OrderItemParentId;
            }
            if (codeOffre=='INWIB2C_OFFERING_TERMINAL'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' ||codeOffre=='InwiB2C_TELEPHONE_FIXE'){
                NewOrderItem.vlocity_cmt__RootItemId__c = NewOrderItem.Id;
            }
            UpdatedOrderItems.add(newOrderItem);
        }
        update UpdatedOrderItems;
        
        traceObj.InwiB2C_Object_Number__c = newOrder.Id;
        update traceObj;
        
        
        System.debug('typedeProduit: ' + typedeProduit);
        if (codeOffre!='INWIB2C_OFFERING_TERMINAL' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' && codeOffre!='InwiB2C_TELEPHONE_FIXE') {
            OrderItem parentItems = [select id, Product2.ProductCode, Product2.Name,InwiB2C_FMS__c, InwiB2C_FMD__c, inwib2c_TransactionCode__c,  vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId = :newOrder.Id AND vlocity_cmt__ParentItemId__c =null];
            //if (codeOffre!='INWIB2C_OFFERING_TERMINAL') {
                
                //for (OrderItem parentItem : parentItems) {
                    if (fmsPrice>0) {
                        parentItems.InwiB2C_FMS__c=fmsPrice;
                    }
                    if (fmdPrice>0) {
                        parentItems.InwiB2C_FMD__c=fmdPrice;
                    }
                    
                    
                    update parentItems;
                    //  if (paymentReference!=null && fmsPrice>0 ) {
                        //     parentItems.inwiB2C_TransactionCode_FMS__c=paymentReference;
                        
                    // }
                    // if (paymentReference!=null && fmdPrice>0) {
                        //     ParentItem.InwiB2C_TransactionCode_FMD__c=paymentReference;
                        
                    // }
                    
                    // if (paymentReference!=null && (codeOffre=='INWIB2C_OFFERING_TERMINAL' || codedeProduit == 'INWIB2C_OFFERING_TERMINAL'|| codedeProduit == 'INWIB2C_MOB02_OFFERING_TERMINAL'|| codedeProduit == 'INWIB2C_OPB2C_OFFERING_TERMINAL')) {
                        //     ParentItem.inwib2c_TransactionCode__c=paymentReference;
                        
                    // }
                    //Begin ACYL 30/05/2025 Ajustement ADSL 

                    if (typedeProduit=='Handset'&&codeOffre!='INWIB2C_OFFERING_ADSL20MG_199DH'&&codeOffre!='INWIB2C_OFFERING_ADSL_ESSENTIEL_149DH'&& codeOffre!='INWIB2C_OFFERING_FTTH50MG_349DH'&& codeOffre!='INWIB2C_OFFERING_FTTH200MG_649DH'&& codeOffre!='INWIB2C_OFFERING_FTTH20MG_249DH'&&codeOffre!='INWIB2C_OFFERING_FTTH100MG_449DH'&&codeOffre!='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'&&codeOffre!='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'&&codeOffre!='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH'&&codeOffre!='INWIB2C_OFFERING_FTTH500MG3MOIS_449DH' &&codeOffre!='INWIB2C_OFFERING_FTTH500MG_749DH' &&codeOffre!='INWIB2C_OFFERING_FTTH1Gb_949DH' &&codeOffre!='INWIB2C_OFFERING_FORMULE1_199DH'&&codeOffre!='INWIB2C_OFFERING_FORMULE2_249DH'&&codeOffre!='INWIB2C_OFFERING_FORMULE3_349DH' &&codeOffre!='INWIB2C_OFFERING_FORMULE1_5G' &&codeOffre!='INWIB2C_OFFERING_FORMULE2_5G' &&codeOffre!='INWIB2C_OFFERING_FORMULE3_5G'  && codeOffre!='InwiB2C_TELEPHONE_FIXE') {
                        OrderItem TerminalItem = [select id, Product2.ProductCode, Product2.Name,InwiB2C_FMS__c, InwiB2C_FMD__c, inwib2c_TransactionCode__c,  vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId = :newOrder.Id AND Product2.Name='Terminal' ];
                    //End ACYL 30/05/2025 Ajustement ADSL 

                        
                        // parentItems.vlocity_cmt__OneTimeTotal__c = terminalPrice;
                        // parentItems.vlocity_cmt__EffectiveOneTimeTotal__c = terminalPrice;
                        // TerminalItem.vlocity_cmt__OneTimeCharge__c = terminalPrice;
                        // TerminalItem.vlocity_cmt__OneTimeTotal__c = terminalPrice;
                        // TerminalItem.vlocity_cmt__OneTimeCalculatedPrice__c = terminalPrice;
                        
                        // List<inwi_UpdatePriceEshop__e> PriceUpdate_event = new List<inwi_UpdatePriceEshop__e>();
                        // inwi_UpdatePriceEshop__e eventToCreate = new inwi_UpdatePriceEshop__e();
                        // eventToCreate.cartId__c = newOrder.Id;
                        // eventToCreate.ItemId__c = TerminalItem.Id;
                        // eventToCreate.Price__c = terminalPrice;
                        // PriceUpdate_event.add(eventToCreate);
                        // List <Database.SaveResult> sresult = EventBus.publish(PriceUpdate_event);
                        // Call the constructInputParams method to construct input parameters
                        constructInputParams(newOrder.Id, TerminalItem.Id, recalculAmount);
                        
                        //update TerminalItem;
                    }
                //}
                //ParentItem.inwib2c_TransactionCode__c=paymentReference;
                //update parentItems;
                
            }
            
            
            if (codeOffre == 'INWIB2C_OFFERING_TERMINAL'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' ||codeOffre=='InwiB2C_TELEPHONE_FIXE') {
                System.debug('Amine brm');
                
                List<OrderItem> TerminalItemqntite = [SELECT id, Product2.ProductCode, Product2.Name, InwiB2C_FMS__c, InwiB2C_FMD__c,inwib2c_TransactionCode__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c FROM OrderItem WHERE OrderId = :newOrder.Id];
                Map<Id,inwib2c_CallAdjustementForquantity__c> adjustementMap = new Map<Id,inwib2c_CallAdjustementForquantity__c>();
                List<Object> productsForTerminalQuantity = (List<Object>) inputJsonMap.get('products');
                
                Integer terminalIndex = 0; // Index to identify which terminal item to update
                
                for (Object productObjectterminal : productsForTerminalQuantity) {
                    Map<String, Object> productMapterminal = (Map<String, Object>) productObjectterminal;
                    Map<String, Object> productPrice = (Map<String, Object>) productMapterminal.get('price');
                    //EvolutionRecalculePrix terminaux automatiquement
                    // List<Object> attributes = (List<Object>) productMapterminal.get('attributes');
                    // Map<String, String> attributeInput = new Map<String, String>();
                    // for (Object attributeObj : attributes) {
                        //     Map<String, Object> attribute = (Map<String, Object>) attributeObj;
                        //     String attributeCode = (String) attribute.get('code');
                        //     String attributeValue = (String) attribute.get('value');
                        
                        
                        //        attributeInput.put(attributeCode, attributeValue);
                        //        System.debug('LaListe attributs a changer leurs prix 2 est' +attributeInput);
                    // }
                    // // Check if the key exists in the map
                    // if (attributeInput.containsKey('INWIB2C_ATT_RT_MODELE')) {
                        //     // Retrieve the value associated with the key 'INWIB2C_ATT_RT_MODELE'
                        //        modelValue = attributeinput.get('INWIB2C_ATT_RT_MODELE');
                        //        System.debug('modelValue' +modelValue);
                        //        inwiB2C_ModelePricelist__c terminalprix2 = [select id,inwiB2C_Modele__r.inwiB2C_Code_Article__c,inwiB2C_Canal__c,inwiB2C_Profil_IN__c, inwiB2CPrice__c from inwiB2C_ModelePricelist__c where inwiB2C_Canal__c ='InwiB2C_Eshop'and inwiB2C_Profil_IN__c='ALL' and inwiB2C_CodeArticle__c =:modelValue ];
                        //        System.debug('terminalprix2' +terminalprix2.inwiB2CPrice__c);
                        //        recalculAmount=terminalprix2.inwiB2CPrice__c;
                        
                    //    }
                    //FinEvolutionrecalculprice
                    Integer productQuantityOfTerminal = 1; // Default to 1 if 'quantity' is not present
                    if (productMapterminal.containsKey('quantity')) {
                        productQuantityOfTerminal = ((Decimal) productMapterminal.get('quantity')).intValue();
                    }
                    
                    Double amountAsString = (Double) productPrice.get('amount');
                    Decimal productAmount = Decimal.valueOf(amountAsString);
                    System.debug('productAmount'+productAmount);
                    Decimal PrixTotalTerminaux = productAmount * productQuantityOfTerminal;
                    // Add the current product amount to the total
                    productAmountsList.add(PrixTotalTerminaux); // Store the productAmount in the list
                    
                    //totalProductAmount += productAmount;
                    
                    for (Integer i = 0; i < productQuantityOfTerminal; i++) {
                        if (terminalIndex < TerminalItemqntite.size()) {
                            OrderItem terminalparent = TerminalItemqntite[terminalIndex];
                            // terminalparent.vlocity_cmt__OneTimeCharge__c = productAmount;
                            // terminalparent.vlocity_cmt__OneTimeTotal__c = productAmount;
                            // terminalparent.vlocity_cmt__OneTimeCalculatedPrice__c = productAmount;
                            
                            //      List<inwi_UpdatePriceEshop__e> PriceUpdate_event = new List<inwi_UpdatePriceEshop__e>();
                            //      inwi_UpdatePriceEshop__e eventToCreate = new inwi_UpdatePriceEshop__e();
                            //     eventToCreate.cartId__c = newOrder.Id;
                            //    eventToCreate.ItemId__c = terminalparent.Id;
                            //    eventToCreate.Price__c = productAmount;
                            //    PriceUpdate_event.add(eventToCreate);
                            //    List <Database.SaveResult> sresult = EventBus.publish(PriceUpdate_event);
                            //    System.debug('Resultat de appel adjustement qntt'+sresult );
                            //constructInputParams(newOrder.Id, terminalparent.Id, productAmount);
                            inwib2c_CallAdjustementForquantity__c  c = new inwib2c_CallAdjustementForquantity__c();
                            c.inwib2c_Done__c='false';
                            c.inwib2c_OrderId__c=newOrder.Id;
                            c.inwib2c_OrderItemId__c=terminalparent.Id;
                            c.inwib2c_PriceTerminal__c=productAmount;
                            c.inwib2c_TraceId__c=traceId;
                            insert c;
                            terminalIndex++; // Move to the next terminal item
                            System.debug('productQuantityOfTerminal'+productQuantityOfTerminal );
                            System.debug('TerminalItemqntite'+TerminalItemqntite );
                            System.debug('terminalIndex'+terminalIndex );
                        }
                    }
                }
                // Calculate the sum by iterating through the list
                for (Decimal amount : productAmountsList) {
                    totalProductAmount += amount;
                }
                System.debug('totalPrixTerminaux'+totalProductAmount);
                
                //update TerminalItemqntite;
            }
            
            //Mettre a jour dans la table traceDemandeEshop Les FMS?FMD?PrixTerminaux
            inwib2c_TraceDemandeEshop__c  traceDemandeEshop =  [select id,inwib2c_Avec_ou_sans_engagement__c, CreatedDate, IdTraceAPI__c, inwib2c_AccountId__c, inwib2c_OrderId__c, inwib2c_Num_ro_de_la_demande__c, inwib2c_Montant_de_la_commande__c, inwib2c_Mode_de_paiement__c, inwib2c_Mode_de_livraison__c, inwib2c_MDN__c, inwib2c_Request_body__c, inwib2c_Statut__c, inwib2c_Statut_paiement__c,inwib2c_Date_Finalisation_Commande__c,inwib2c_FMD_Total__c,inwib2c_FMS_Total__c,	inwib2c_Prix_Terminal_Total__c from inwib2c_TraceDemandeEshop__c where IdTraceAPI__c =:traceId];
            /* M-Dj 28/11/2024 eviter d'ecraser les prix ajuster deja avec la class inwib2c_PaiementConfirmationEshopFront begin */
            //if (waitpayment) {
                if (fmsPrice>0) {
                    traceDemandeEshop.inwib2c_FMS_Total__c=fmsPrice;
                }
                if (fmdPrice>0) {
                    traceDemandeEshop.inwib2c_FMD_Total__c=fmdPrice;
                }
                if (totalProductAmount>0) {
                    traceDemandeEshop.inwib2c_Prix_Terminal_Total__c=totalProductAmount;
                }
                update traceDemandeEshop;
            //}
            /* M-Dj 28/11/2024 eviter d'ecraser les prix ajuster deja avec la class inwib2c_PaiementConfirmationEshopFront end */
            
            //   if (codeOffre!='INWIB2C_OFFERING_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' && codeOffre!='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER100_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER15_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER30_SANS_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_VACANCIER100_AVEC_TERMINAL7'&& codeOffre!='INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL15'&& codeOffre!='INWIB2C_OFFERING_VACANCIER_AVEC_TERMINAL30'&&codeOffre!='INWIB2C_OFFERING_ADSL20MG_199DH'&& codeOffre!='INWIB2C_OFFERING_FTTH50MG_349DH'&& codeOffre!='INWIB2C_OFFERING_FTTH200MG_649DH'&& codeOffre!='INWIB2C_OFFERING_FTTH20MG_249DH'&&codeOffre!='INWIB2C_OFFERING_FTTH100MG_449DH'&&codeOffre!='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'&&codeOffre!='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'&&codeOffre!='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH') {
                //    OrderItem OptionsItem = [select id, Product2.ProductCode, Product2.Name,InwiB2C_FMS__c, InwiB2C_FMD__c, inwib2c_TransactionCode__c,  vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId = :newOrder.Id AND Product2.Name='Options' ];
                
                //    OptionsItem.vlocity_cmt__OneTimeTotal__c = terminalPrice;
                //    update OptionsItem;
                
            //      }
            if(!Test.isRunningTest()){
                System.debug('AmineDebug');
                inwiB2C_eShopUpdateAttributes.updateAttributes(traceId);
            }
            
            if (codeOffre == 'INWIB2C_OFFERING_TERMINAL'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast'||codeOffre=='InwiB2C_TELEPHONE_FIXE') {
                List<inwib2c_UpdatePriceEshop__e> PriceUpdate_event = new List<inwib2c_UpdatePriceEshop__e>();
                inwib2c_UpdatePriceEshop__e eventToCreate = new inwib2c_UpdatePriceEshop__e();
                eventToCreate.inwib2c_cartId__c = newOrder.Id;
                eventToCreate.inwib2c_traceId__c = traceId;
                
                //eventToCreate.ItemId__c = terminalparent.Id;
                //eventToCreate.Price__c = productAmount;
                PriceUpdate_event.add(eventToCreate);
                System.debug('PriceUpdate_event'+PriceUpdate_event);
                List <Database.SaveResult> sresult = EventBus.publish(PriceUpdate_event);
                System.debug('Resultat de appel adjustement qntt'+sresult );
                
            }
            
            //  List<inwib2c_CallAdjustementForquantity__c> CalladjustementList = [
            //     SELECT Id, OrderId__c, OrderItemId__c, PriceTerminal__c, Done__c
            //     FROM inwib2c_CallAdjustementForquantity__c
            //     WHERE OrderId__c = :newOrder.Id AND Done__c = 'false'
            
            // ];
            
            //System.debug('CalladjustementList: ' + CalladjustementList);
            
            Map<String, Object> result = new Map<String, Object>();
            if (codeOffre!='INWIB2C_OFFERING_TERMINAL' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' && codeOffre!='InwiB2C_TELEPHONE_FIXE') {
                
                result.put('CSExecuteCarteEshopResultInfo', new Map<String, Object>{
                    'errorCode'     => '',
                    'errorMessage'  => 'SUCCESS',
                    'isOK'          => 1,
                    'OrderId'       => newOrder.Id,
                    'uuid'          => ''
                });
                System.debug('Result: ' + result);
                String resultJson = JSON.serialize(result);
                traceObj.InwiB2C_Response__c = resultJson;
                traceObj.InwiB2C_Status__c='OK';
                update traceObj;
                traceDemandeEshop.inwib2c_OrderId__c= newOrder.Id;
                traceDemandeEshop.inwib2c_Statut__c= 'InwiB2C_Terminer';
                Date todayDate = System.today();
                System.debug('Today'+todayDate);
                DateTime currentDateTime = System.now();
                traceDemandeEshop.inwib2c_Date_Finalisation_Commande__c=currentDateTime;
                update traceDemandeEshop;
                //Begin ACYL 30/05/2025 Ajustement ADSL 

                if(codeOffre=='INWIB2C_OFFERING_ADSL20MG_199DH'||codeOffre=='INWIB2C_OFFERING_ADSL_ESSENTIEL_149DH'||codeOffre=='INWIB2C_OFFERING_FTTH50MG_349DH'||codeOffre=='INWIB2C_OFFERING_FTTH200MG_649DH'||codeOffre=='INWIB2C_OFFERING_FTTH20MG_249DH'||codeOffre=='INWIB2C_OFFERING_FTTH100MG_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'||codeOffre=='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'||codeOffre=='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH500MG3MOIS_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH500MG_749DH' ||codeOffre=='INWIB2C_OFFERING_FTTH1Gb_949DH' ){
                //END ACYL 30/05/2025 Ajustement ADSL 

                                    //     if (waitpaymentUpper !='O') {
                        //     InwiB2C_Suivi_commande_fixe__c SuiviCommandeADSLFTTH =new  InwiB2C_Suivi_commande_fixe__c (InwiB2C_Id_Evenement__c=flagSuiviFTTHADSL,InwiB2C_Order__c=neworder.Id,InwiB2C_Type_offre__c=familyProduct,inwib2c_PanierId__c=traceEshop.Id);
                        //       insert SuiviCommandeADSLFTTH;
                        
                    //   }else {
                        //     InwiB2C_Suivi_commande_fixe__c UpdateSuiviCommandeADSLFTTH = [select id,InwiB2C_Id_Evenement__c,InwiB2C_Order__c,inwib2c_PanierId__c,InwiB2C_Type_offre__c from InwiB2C_Suivi_commande_fixe__c where inwib2c_PanierId__c =: traceEshop.Id];
                        //     UpdateSuiviCommandeADSLFTTH.InwiB2C_Order__c=newOrder.Id;
                        
                        //     update UpdateSuiviCommandeADSLFTTH;
                        
                    //   }
                    
                    if (idsaporder == null || idsaporder == 'undefined' || idsaporder == '') {
                        Map<String, Object> inputParams = new Map<String, Object>();
                        inputParams.put('orderId', neworder.Id);
                        inputParams.put('externalOrderId', traceEshop.Id);
                        inputParams.put('step', 'EVENT_1');
                        //inputParams.put('Sous step', '');
                        
                        
                        Map<String, Object> outputParams = new Map<String, Object>();
                        Map<String, Object> options = new Map<String, Object>();
                        
                        
                        InwiB2C_ManageSuiviCommEvent.createEvent(inputParams, outputParams, options);
                        
                    }
                }
                // H-M suivi de commande LastMile, cas à domicile
                if (idsaporder != null && idsaporder != 'undefined' && idsaporder !='') {
                    Map<String, Object> inputParams = new Map<String, Object>();
                    inputParams.put('orderId', neworder.Id);
                    inputParams.put('externalOrderId', traceEshop.Id);
                    // T-A modifications des events déclenchés (MC-MGEN3432C-LAST-Mile)
                    if (offerType == 'FTTH') {
                        inputParams.put('parentStep', 'EVENT_4');
                        inputParams.put('step', 'SUB_EVENT_4A');
                    } else if (offerType == 'ADSL') {
                        inputParams.put('parentStep', 'EVENT_5');
                        inputParams.put('step', 'SUB_EVENT_5A');
                    }
                    Map<String, Object> outputParams = new Map<String, Object>();
                    Map<String, Object> options = new Map<String, Object>();
                    // Création de l'événement
                    InwiB2C_ManageSuiviCommEvent.createEvent(inputParams, outputParams, options);
                }
                
                //automatic Order submission
                
                if (submite) {
                    //Create Contract
                    String procedureName = 'inwib2c_InwiB2C_CreateContract';
                    Map <String, Object> ipInputContract = new Map <String, Object> ();
                    Map <String, Object> ipOutputContract = new Map <String, Object> ();
                    Map <String, Object> ipOptionsContract = new Map <String, Object> ();
                    ipInputContract.put('OrderId', newOrder.Id);
                    ipInputContract.put('idClient', customerId);
                    /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                    ipInputContract.put('Family',codeOffre);
                    ipInputContract.put('CanalIdentification', 'inwiB2C_Eshop');
                    /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                    System.debug('InputVIP' +ipInputContract);
                    ipOutputContract = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_CreateContract', ipInputContract, ipOptionsContract);
                    System.debug('OutputVIP' +ipOutputContract);
                    System.debug(JSON.serialize(ipOutputContract));
                    
                    
                    // M-Dj 24/12/24 mettre a jour le contract a conforme pour les acq esim begin
                    String contractId = (String) ipOutputContract.get('idContract');
                    Contract contract = [ select InwiB2C_statut_contrat__c from Contract where Id = :contractId ];
                    contract.InwiB2C_statut_contrat__c = 'Dossier conforme';
                    update contract;
                    // M-Dj 24/12/24 mettre a jour le contract a conforme pour les acq esim end
                    
                    //CheckOut
                    Map<String, Object> inputParams = new Map<String, Object>();
                    Map<String, Object> outputMap = new Map<String, Object>();
                    Map<String, Object> optionsMap = new Map<String, Object>();
                    inputParams.put('ContextId', newOrder.Id);
                    inputParams.put('cartId', newOrder.Id);
                    //inputParams.put('methodName', 'checkout');
                    optionsMap.put('useQueueableApexRemoting',true);
                    System.debug('CheckOut: ' + inputParams);
                    vlocity_cmt.CpqAppHandler submitautomatique = new vlocity_cmt.CpqAppHandler();
                    try {
                        submitautomatique.invokeMethod('checkout',inputParams, outputMap, optionsMap);
                        System.debug('Output Map after Submit: ' + outputMap);
                    } catch (Exception e) {
                        // Handle the exception here
                        System.debug('Error while applying CheckOut: ' + e.getMessage());
                        
                    }
                    
                    
                }
            }
            return result;
            
            
            
            
        }
        
        
    }