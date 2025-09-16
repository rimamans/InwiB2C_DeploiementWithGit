public without sharing class inwiB2C_eShopUpdateAttributes {
   
    public static String updateAttributes(String traceId){

        InwiB2C_Trace_API__c traceObj = [select id, InwiB2C_Object_Number__c, InwiB2C_request_body__c from InwiB2C_Trace_API__c where id = :traceId];
        inwib2c_TraceDemandeEshop__c  traceDemandeEshop =  [select id,inwib2c_Avec_ou_sans_engagement__c, CreatedDate, IdTraceAPI__c, inwib2c_OrderId__c, inwib2c_MDN__c, inwib2c_Statut__c,inwib2c_Flag_Porta__c from inwib2c_TraceDemandeEshop__c where IdTraceAPI__c =:traceId];

        Map<String, OrderItem> orderItemByPropductCodeMap = new Map<String, OrderItem>();

        // Define the simCardMap
        Map<String, String> simCardMap = new Map<String, String>{
          '600001090' => '600001090|S.A ESIM MRE 2023',
          '000027122' => '000027122|CARTE SIM GSM 128k JAVA Offre',
          '600001060' => '600001060|S.A SIM vacanciers 30 j',
          '600000962' => '600000962|S.A SIM 4G VI PREPAID_21',
          '000020889' => '000020889|S.A SIM GSM OFFRE PRP 1 B2C-2010',
          '000056166' => '000056166|S.A SIM 4G VI PREPAID',
          '000053410' => '000053410|S.A SIM 4G PRP V/D B2C KOULCHI',
          '600000922' => '600000922|SA SIM NOPIN 4G',
          '000051749' => '000051749|Carte 4G',
          '600001101' => '600001101|S.A ESIM BOUTIQUE',
          '000056165' => '000056165|S.A SIM 4G BOUTIQUES PREPAID',
          '600000874' => '600000874|S.A SIM 4G VI GUERILLA MARRAKECH',
          '100002196' => '100002196|SAV ESIM',
          '600001062' => '600001062|S.A SIM vacanciers 14 j',
          '600001061' => '600001061|S.A SIM vacanciers 7 j',
          '600000981' => '600000981|S.A SIM 4G VI PREPAID PLAN ETE 2020',
          '300001141' => '300001141|E-SIM 4G DIGITALE',
          '000057208' => '000057208|STAND ALONE SIM 4G PREPAID OFFERTE A LA FACTURATION',
          '000059036' => '000059036|S.A SIM 4G B2B 2020',
          '000025935' => '000025935|STAND ALONE SIM GSM OFFRE PACM',
          '000019847' => '000019847|CARTE SIM GSM 128k JAVA Offre GSM 1',
          '600000733' => '600000733|S.A SIM 4G BOUTIQUES PREPAID'
         };

        if (traceObj != null){
            String orderId = traceObj.InwiB2C_Object_Number__c;
            System.debug('OrderIdForUpdateAttribute'+orderId);

            List<OrderItem> orderItemList = [select id, Product2.ProductCode, vlocity_cmt__JSONAttribute__c from orderitem where OrderId = :orderId  ];
            System.debug('orderItemList'+orderItemList);
            for (OrderItem orderItem: orderItemList){

                orderItemByPropductCodeMap.put(orderItem.Product2.ProductCode, orderItem);


            }

            Map <String, Object> inputJsonMap = (Map <String, Object>) JSON.deserializeUntyped(traceObj.InwiB2C_request_body__c);

            List<Object> products = (List<Object>) inputJsonMap.get('products');
            List<Map<String, Object>> codeProduit = new List<Map<String, Object>>();
            Map <String, Object> product = (Map <String, Object>) products[0];
            codeProduit.add(product);
            string codeOffre='';
            String  profil='';
            String engagement='Sans engagement';
            String dureeengagement='';
            String offerType='';
            String flagPortabilite='NON';
            String attributesCodes='';
            String attributesValues='';
    
            for (Map<String, Object> CodeItem : codeProduit) {
                String tempCodeOffre = (String) CodeItem.get('code');
                profil = (String) CodeItem.get('idProfile');
                dureeengagement = (String) CodeItem.get('engagement');
                System.debug('engagementAvant' +dureeengagement);
                if (dureeengagement != null &&  dureeengagement !='' &&  dureeengagement !='undefined') {
                if (dureeengagement.equals('12')) {
                  engagement = '12 Mois';
              } else if (dureeengagement.equals('24')) {
                  engagement = '24 Mois';
              } else if (dureeengagement.equals('36')) {
                  engagement = '36 Mois';
              } else {
                  engagement = 'Sans engagement';
              }
              System.debug('engagementAPres' +engagement);
              // traceDemandeEshop.inwib2c_Avec_ou_sans_engagement__c=engagement;
              // update traceDemandeEshop;
              

            }

                if (tempCodeOffre.equals('TERMINAL')) {
                    codeOffre = 'INWIB2C_OFFERING_TERMINAL';
                } else {
                    codeOffre = tempCodeOffre;
                }
            }

                       
                if (codeOffre =='INWIB2C_OFFERING_49DH_INTERNET' || codeOffre =='INWIB2C_OFFERING_199DH_INTERNET' || codeOffre =='INWIB2C_OFFERING_99DH_APL' || codeOffre =='INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre =='INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre =='INWIB2C_OFFERING_149DH_APL' || codeOffre =='INWIB2C_OFFERING_99DH_ILLIMITE_RS' || codeOffre =='INWIB2C_OFFERING_149DH_INTERNET' || codeOffre =='INWIB2C_OFFERING_49DH_ILLINWI_APL' || codeOffre =='INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || codeOffre =='INWIB2C_OFFERING_499DH_TOUT' || codeOffre =='INWIB2C_OFFERING_199DH_APL' || codeOffre =='INWIB2C_OFFERING_249DH_TOUT' || codeOffre =='INWIB2C_OFFERING_99DH_ILLINWI_APL' ||codeOffre =='INWIB2C_OFFERING_FORFAIT149DH_APL' || codeOffre =='INWIB2C_OFFERING_ILLIMITEINWI299DH' || codeOffre =='INWIB2C_OFFERING_ILLIMITEINWI349DH' || codeOffre =='INWIB2C_OFFERING_FORFAIT119DH_APL'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI499DH'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI649DH') {

                  offerType='Mobile Postpayé';
                }else {
                    //R-SL MGEN3758 l'ajout des offres esim marhaba begin
                  if (codeOffre =='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TERMINAL' || codeOffre =='INWIB2C_OFFERING_ESIM_BUNDLE1' || codeOffre =='INWIB2C_OFFERING_ESIM_BUNDLE2' || codeOffre =='INWIB2C_OFFERING_ESIM_BUNDLE3' || codeOffre =='INWIB2C_OFFERING_ESIM_BUNDLE4' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE1' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE2' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE3' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE4') {
                      ////R-SL MGEN3758 end
                      offerType='Mobile Prépayé';
                  } else {            //Begin ACYL 30/05/2025 Ajustement ADSL 
                      if(codeOffre =='INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre =='INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre =='INWIB2C_OFFERING_FORMULE3_349DH' || codeOffre=='INWIB2C_OFFERING_ADSL20MG_199DH'|| codeOffre=='INWIB2C_OFFERING_ADSL_ESSENTIEL_149DH'||codeOffre=='INWIB2C_OFFERING_FTTH50MG_349DH'||codeOffre=='INWIB2C_OFFERING_FTTH200MG_649DH'||codeOffre=='INWIB2C_OFFERING_FTTH20MG_249DH'||codeOffre=='INWIB2C_OFFERING_FTTH100MG_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH'||codeOffre=='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'||codeOffre=='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH500MG3MOIS_449DH'||codeOffre=='INWIB2C_OFFERING_FTTH500MG_749DH' ||codeOffre=='INWIB2C_OFFERING_FTTH1Gb_949DH') {
                          offerType='Home Postpayé';
                      }
              
              
                  }
          
                }
                System.debug('codeOffreForUpdate' +codeOffre);
            if (codeOffre!='INWIB2C_OFFERING_TERMINAL' && codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'&& codeOffre!='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast'){
             
               List<Object> subProducts = (List<Object>) product.get('subProducts');
               System.debug('le type offre pour MaJ' +offerType);
               System.debug('La liste des subProducts'+subProducts);
              //if (subProducts != null) {
                if (subProducts == null) {
                    subProducts = new List<Object>(); // Create a new list if subProducts is null
                    System.debug('aminelistesousproduit'+subProducts);
                  }
                if (offerType=='Mobile Postpayé' ||offerType=='Home Postpayé') {
                  
                  System.debug('attributEngagement');
                   // Créer un nouvel objet de produit avec l'attribut INWIB2C_ATT_RT_ENGAGEMENT
                  Map<String, Object> engagementProduct = new Map<String, Object>{
                   'code' => codeOffre,
                   // 'price' => new Map<String, Object>{
                   //     'type' => 'ONE_SHOT',
                   //     'amount' => '349'
                   // },
                   'attributes' => new List<Map<String, Object>>{
                     new Map<String, Object>{
                     'code' => 'INWIB2C_ATT_RT_ENGAGEMENT',
                     'value' => engagement
                     }
                   }
                   
                  };
                  System.debug('attributEngagement2'+engagementProduct);
                  // Ajouter le nouvel objet de produit à la liste subProducts
                  subProducts.add(engagementProduct);
                  System.debug('subProductsattributEngagement2'+subProducts);
                }
                for (Object subProductObj : subProducts){
                   Map <String, Object> subProduct = (Map <String, Object>) subProductObj;

                   Map<String,String> attributeinput = new Map<String,String>();

                   String productCode = (String) subProduct.get('code');
                   System.debug('productcodeAmine Brm'+productCode);
                    if (productCode == 'TERMINAL' && (codeOffre == 'INWIB2C_OFFERING_49DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_199DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_99DH_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_APL' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLINWI_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_499DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_199DH_APL' || codeOffre == 'INWIB2C_OFFERING_249DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLINWI_APL' ||codeOffre == 'INWIB2C_OFFERING_FORFAIT149DH_APL' || codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI299DH' || codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI349DH' || codeOffre == 'INWIB2C_OFFERING_FORFAIT119DH_APL'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI499DH'|| codeOffre == 'INWIB2C_OFFERING_ILLIMITEINWI649DH')) {
                    productCode = 'INWIB2C_MOB02_OFFERING_TERMINAL';
                   } else if (productCode == 'TERMINAL' && (codeOffre == 'INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE3_349DH')) {
                    productCode = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
                       //R-SL MGEN3758 l'ajout des offres esim marhaba begin
                   } else if (productCode == 'TERMINAL' && (codeOffre == 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' ||codeOffre =='INWIB2C_OFFERING_TERMINAL'|| codeOffre =='INWIB2C_OFFERING_TICTAC' || codeOffre =='INWIB2C_OFFERING_VACANCIER100' || codeOffre =='INWIB2C_OFFERING_VACANCIER15'|| codeOffre =='INWIB2C_OFFERING_VACANCIER30'  || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE1' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE2' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE3' || codeOffre =='INWIB2C_OFFERING_ESIM_TERMINAL_BUNDLE4')) {
                       //R-SL MGEN3758 l'ajout des offres esim marhaba end 
                       productCode = 'INWIB2C_OFFERING_TERMINAL';
                    //Begin ACYL 30/05/2025 Ajustement ADSL 
                    }else if(productCode == 'TERMINAL' && (codeOffre =='INWIB2C_OFFERING_ADSL20MG_199DH' ||codeOffre =='INWIB2C_OFFERING_ADSL_ESSENTIEL_149DH' )){ 
                      productCode ='INWIB2C_DEG01_OFFERING_TERMINAL';
                     }else if(productCode == 'TERMINAL' && codeOffre =='INWIB2C_OFFERING_FTTH100MG_449DH' || codeOffre =='INWIB2C_OFFERING_FTTH200MG_649DH'|| codeOffre =='INWIB2C_OFFERING_FTTH20MG_249DH'|| codeOffre =='INWIB2C_OFFERING_FTTH50MG_349DH'|| codeOffre =='INWIB2C_OFFERING_FTTHBAHIA'|| codeOffre =='INWIB2C_OFFERING_FTTH200MG3MOIS_449DH' || codeOffre =='INWIB2C_OFFERING_FTTH50MG3MOIS_249DH'|| codeOffre =='INWIB2C_OFFERING_FTTH100MG3MOIS_349DH' || codeOffre =='INWIB2C_OFFERING_FTTH500MG3MOIS_449DH' || codeOffre =='INWIB2C_OFFERING_FTTH500MG_749DH' || codeOffre =='INWIB2C_OFFERING_FTTH1Gb_949DH'){ 
                      productCode ='INWIB2C_FOB2C_OFFERING_TERMINAL';
                     }

                      orderItem currectOrderItem = orderItemByPropductCodeMap.get(productCode);
                           System.debug('le currentOrderItemest'+currectOrderItem);
                      if  (currectOrderItem != null ){

                        System.debug('subProductsCasEnvoyé'+subProducts);
                       List<Object> attributes = (List<Object>) subProduct.get('attributes');

                        if (attributes != null){
                        

                            for (Object attributeObj : attributes) {

                              Map <String, Object> attribute = (Map <String, Object>) attributeObj;
                                if ( (String)attribute.get('value')!=null && ((String)attribute.get('value') ).length()>0)
                               {
                                String code = (String)attribute.get('code');
                                String value = (String)attribute.get('value');
                                System.debug('value ' + value);
                                System.debug('code ' + code);
        
                                // Check if the code is 'INWIB2C_ATT_RT_MODELE_CARTE_SIM' and replace value with display text
                                if (code == 'INWIB2C_ATT_RT_MODELE_CARTE_SIM' && simCardMap.containsKey(value)) {
                                    System.debug('valueSim ' + simCardMap.containsKey(value));
                                    value = simCardMap.get(value);
                                }
                                attributeinput.put(code, value);
                                //attributeinput.put((String)attribute.get('code'), (String)attribute.get('value')); 
                                if ((String)attribute.get('code')=='INWIB2C_ATT_RT_MSISDN') {
                                  traceDemandeEshop.inwib2c_MDN__c= (String)attribute.get('value');
                                  update traceDemandeEshop;
                                } 
                                if ((String)attribute.get('code')=='INWIB2C_ATT_RT_CHOIX_NUMERO' && (String)attribute.get('value')=='porter un numéro') {
                                  flagPortabilite='OUI';
                                  traceDemandeEshop.inwib2c_Flag_Porta__c= flagPortabilite;
                                  update traceDemandeEshop;
                                } 
                                if ((String)attribute.get('code')=='INWIB2C_ATT_RT_ENGAGEMENT') {
                                  
                                  traceDemandeEshop.inwib2c_Avec_ou_sans_engagement__c=(String)attribute.get('value');
                                  update traceDemandeEshop;
                                } 
                               }
                             System.debug('LaListe attributs est' +attributeinput);
    
                            }
    
                              String result = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currectOrderItem.vlocity_cmt__JSONAttribute__c, attributeinput);
    
                              currectOrderItem.vlocity_cmt__JSONAttribute__c = result;

                       }

                    

                   }
                }
               //}   
            }else if (codeOffre=='INWIB2C_OFFERING_TERMINAL' ||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_DisqueDur'||codeOffre=='INWIB2C_OFFERING_ACCESSOIRES_ChromeCast' ||codeOffre=='InwiB2C_TELEPHONE_FIXE'){
                // Map<String,String> attributeinput = new Map<String,String>();
                // String productCode ='INWIB2C_OFFERING_TERMINAL';
                // orderItem currectOrderItem = orderItemByPropductCodeMap.get(productCode);
                 
                // if  (currectOrderItem != null ){

                //     List<Object> attributes = (List<Object>) product.get('attributes');

                //      if (attributes != null){
                //         // Ajouter l'attribut INWIB2C_ATT_RT_ENGAGEMENT avec la valeur engagement
                //          attributeinput.put('INWIB2C_ATT_RT_ENGAGEMENT', engagement);

                //          for (Object attributeObj : attributes) {

                //            Map <String, Object> attribute = (Map <String, Object>) attributeObj;
                //              if ( (String)attribute.get('value')!=null && ((String)attribute.get('value') ).length()>0)
                //             {
                //              attributeinput.put((String)attribute.get('code'), (String)attribute.get('value'));  
                //             }
    
 
                //          }
 
                //            String result = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currectOrderItem.vlocity_cmt__JSONAttribute__c, attributeinput);
 
                //            currectOrderItem.vlocity_cmt__JSONAttribute__c = result;

                //     }

                 

                // }
               
                      Integer attributeIndex = 0;

                      // Loop through each product
                    for (Object productObject : products) {
                          Map<String, Object> productMap = (Map<String, Object>) productObject;
                          List<Object> productAttributesList = (List<Object>) productMap.get('attributes');
                          Integer productQuantity = 1; // Default to 1 if 'quantity' is not present
                          if (productMap.containsKey('quantity')) {
                              productQuantity = ((Decimal) productMap.get('quantity')).intValue();
                          }
                          System.debug('productQuantity' +productQuantity);

                          if (productAttributesList != null && productQuantity != null && productQuantity > 0) {
                              // Loop through each attribute for the current product's quantity
                              for (Integer i = 0; i < productQuantity; i++) {
                                System.debug('orderItemListsize'+orderItemList.size());
                                  if (attributeIndex < orderItemList.size()) {
                                    System.debug('AmineEnima97');
                                      OrderItem currentItem = orderItemList[attributeIndex];

                                      List<Object> attributes = (List<Object>) productMap.get('attributes');
                                      Map<String, String> attributeInput = new Map<String, String>();

                                      for (Object attributeObj : attributes) {
                                          Map<String, Object> attribute = (Map<String, Object>) attributeObj;
                                          String attributeCode = (String) attribute.get('code');
                                          String attributeValue = (String) attribute.get('value');

                                          // Populate the attribute input map for this attribute
                                             attributeInput.put(attributeCode, attributeValue);
                                             System.debug('LaListe attributs est' +attributeInput);
                                      }

                                    // Apply the attributes to the current item
                                      if (!attributeInput.isEmpty()) {
                                          String result = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(currentItem.vlocity_cmt__JSONAttribute__c, attributeInput);
                                          currentItem.vlocity_cmt__JSONAttribute__c = result;  // Optionally update the JSON attribute field
                                          System.debug('Le resultat pour la listeUpdateAttribut' +result);
                                        }

                                      attributeIndex++; // Move to the next attribute
                                  }
                              }
                          }
                    }



            
            
            
            }
        update orderItemList;

        // M-DJ 27/11/24 si msisdn non rensignier sur numero on le recupere sur produit sim et on maj begin
        OrderItem orderItemNumero = new OrderItem();
        OrderItem orderItemSim;
        for (OrderItem OI: orderItemList) {
          if (OI.Product2.ProductCode.contains('OFFERING_MSISDN_STANDARD')) {
            orderItemNumero = OI;
          }
          if (OI.Product2.ProductCode.contains('OFFERING_SIM')) {
            orderItemSim = OI;
          }
        }
        System.debug('OINumero '+ orderItemNumero);
        System.debug('OINumero '+ orderItemSim);

        if (orderItemSim != null) {
          String msisdnCurrent =  INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(orderItemNumero.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MSISDN');
          System.debug('current msisdn '+  msisdnCurrent);

          if (msisdnCurrent == '' || msisdnCurrent == null) {
            Map<String,String> msisdnAtt = new Map<String,String>();
            String msisdnprov = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(orderItemSim.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MSISDN_PROVISIONAL');
            if (msisdnprov != '' || msisdnprov != null) {
              System.debug('msisdn provisionel '+  msisdnprov);
              msisdnAtt.put('INWIB2C_ATT_RT_MSISDN', msisdnprov);
              if (msisdnprov != '' || msisdnprov != null) {
                System.debug('msisdnprov '+ msisdnprov);
                String res = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(orderItemNumero.vlocity_cmt__JSONAttribute__c, msisdnAtt);
                orderItemNumero.vlocity_cmt__JSONAttribute__c = res;
              }
            }
          }
          update orderItemNumero;
        }
        // M-DJ 27/11/24 si msisdn non rensignier sur numero on le recupere sur produit sim et on maj begin

        }
        return '0';

    }
}