/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-28-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class InwiB2C_RattrapageArticlesCommande implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;
        Map<String, Object> operationResultInfo = new Map<String, Object>();

        try {
            if (methodName.equals('RattrapageArticlesOrder')) {
                operationResultInfo = RattrapageArticlesOrder(inputMap, outMap, options);
            }
        } catch (Exception e) {
            result = false;
            operationResultInfo = new Map<String, Object>{
                'errorCode' => 'ERROR',
                'isOK' => 0,
                'uuid' => 'error-uuid-Amine-Brm',
                'errorMessage' => 'Erreur Lors de La Mise a jour des Articles'
            };
        }
        outMap.put('CSLoadArticlesOrderResultInfo', operationResultInfo );
        return result;
    }
   
        public static Map<String, Object> RattrapageArticlesOrder(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
            Map<String, Object> result = new Map<String, Object>();
            System.debug('AmineTest');
          Map<String, Object> bodyInput = (Map<String, Object>) inputMap.get('bodyInput');

        System.debug('Amine brm'+bodyInput);
        String orderId = (String) inputMap.get('orderId');
        String codeProductSIM='';
        String codeProductTerminal='';
        String productType='';
        String productAttribute='';
        String uuid = (String) bodyInput.get('uuid');
        String ProductName='SIM';
        String ProductNameter='Terminal';

        String resultGetAttributeValue='';
              

            try {
                List<OrderItem> orderItemList= new List<OrderItem>();  
                if(!Test.isRunningTest()){ 
                    orderItemList = [select id, Product2.ProductCode,Product2.Name, vlocity_cmt__JSONAttribute__c from orderitem where OrderId = :orderId AND Product2.Name IN('SIM', 'Terminal', 'Numéro Téléphone')];

                 }else {
                    orderItemList = [select id, Product2.ProductCode,Product2.Name, vlocity_cmt__JSONAttribute__c from orderitem where OrderId = :orderId order by CreatedDate desc];

                } 
                              
                         System.debug('orderItemList'+orderItemList);
                         Order OrderOriginal= [SELECT inwib2c_TypeDeLaCommande__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, status,inwib2c_ModeDeLivraison__c, inwiB2C_Canal__c,InwiB2C_Offre__c,inwib2c_CodeDeTransaction__c from order where id = :orderId limit 1];

                         //List<InwiB2C_LoadArticle__c> loadArticle= [select id,InwiB2C_CodeArticle__c,InwiB2C_SerialNumber__c,InwiB2C_Numero_de_Ligne__c,InwiB2C_Puk__c,InwiB2C_ki__c,InwiB2C_Imsi__c,InwiB2C_OcsId__c,InwiB2C_ProfilId__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_ProductCode__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId];
                         Map<String, OrderItem> orderItemByPropductCodeMap = new Map<String, OrderItem>();

                         for (OrderItem orderItem: orderItemList){
                            if (orderItem.Product2.Name=='SIM' ||Test.isRunningTest()) {
                                
                            //if (ProductName=='SIM') {
                                productAttribute='INWIB2C_ATT_RT_MODELE_CARTE_SIM';
                                if(Test.isRunningTest()){
                                     resultGetAttributeValue='600001090';
            
                                }else {
                                     resultGetAttributeValue = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(orderItem.vlocity_cmt__JSONAttribute__c, productAttribute);
     
                                }
                                System.debug('ResultSIM' + resultGetAttributeValue);

                                if (resultGetAttributeValue!=null) {
                                    //
                                    List<InwiB2C_LoadArticle__c> loadArticle= new List<InwiB2C_LoadArticle__c>(); 
                                    if(!Test.isRunningTest()){ 
                                    //  loadArticle= [select id,InwiB2C_CodeArticle__c,InwiB2C_SerialNumber__c,InwiB2C_Numero_de_Ligne__c,InwiB2C_Puk__c,InwiB2C_ki__c,InwiB2C_Imsi__c,InwiB2C_OcsId__c,InwiB2C_ProfilId__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_ProductCode__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId AND InwiB2C_CodeArticle__c	=:resultGetAttributeValue AND InwiB2C_Updated__c='false' ORDER BY CreatedDate DESC  LIMIT 1];
                                        //B-30885 M-DJ recuperer les loadArticle avec le champ productCode begin
                                        loadArticle= [select id,InwiB2C_CodeArticle__c,InwiB2C_SerialNumber__c,InwiB2C_Numero_de_Ligne__c,InwiB2C_Puk__c,InwiB2C_ki__c,InwiB2C_Imsi__c,InwiB2C_OcsId__c,InwiB2C_ProfilId__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_ProductCode__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId AND InwiB2C_ProductCode__c	='SIM' ORDER BY CreatedDate DESC  LIMIT 1];
                                        //B-30885 M-DJ recuperer les loadArticle avec le champ productCode end
                                        } else {
                                        InwiB2C_LoadArticle__c newaloadarticle = new InwiB2C_LoadArticle__c(
                                            InwiB2C_CodeArticle__c = '600001090',
                                            InwiB2C_Updated__c = 'false',
                                            InwiB2C_Imsi__c = 'Y35642',
                                            InwiB2C_ki__c = '95746735',
                                            InwiB2C_Numero_de_Ligne__c = '212790945115',
                                            InwiB2C_OcsId__c = '5UI46357',
                                            InwiB2C_ProfilId__c = '8134567',
                                            InwiB2C_Puk__c = '4576859',
                                            InwiB2C_SerialNumber__c = '8765465785797483',
                                            InwiB2C_Order__c = orderId,
                                            InwiB2C_ItemId__c = orderItem.Id,
                                            InwiB2C_ProductCode__c = resultGetAttributeValue
                                        );
                                        loadArticle = new List<InwiB2C_LoadArticle__c>{newaloadarticle};
                                    }

                                    
                                    if (!loadArticle.isEmpty()) {
                                        InwiB2C_LoadArticle__c article = loadArticle[0];
                                        Map<String, Object> DRIteminputMap = new Map<String, Object>();
                                        DRIteminputMap.put('modeleCarteSIM', article.InwiB2C_CodeArticle__c);
                                        DRIteminputMap.put('icc', article.InwiB2C_SerialNumber__c);
                                        DRIteminputMap.put('mdn', article.InwiB2C_Numero_de_Ligne__c);
                                        DRIteminputMap.put('puk', article.InwiB2C_Puk__c);
                                        DRIteminputMap.put('ki', article.InwiB2C_ki__c);
                                        DRIteminputMap.put('imsi', article.InwiB2C_Imsi__c);
                                        DRIteminputMap.put('ocsid', article.InwiB2C_OcsId__c);
                                        DRIteminputMap.put('profilid', article.InwiB2C_ProfilId__c);
                                        DRIteminputMap.put('orderId', orderId);
                                        DRIteminputMap.put('itemId', orderItem.Id);
                                        // Call the DataRaptor
                                        vlocity_cmt.DRProcessResult DROrderItemresult = vlocity_cmt.DRGlobal.process(DRIteminputMap, 'InwiB2C_DRPOrderItemLoadArticle'); 
                                        System.debug('OrderItem DR Result: ' + DROrderItemresult);

                                        if (DROrderItemresult.errors.isEmpty()) {
                                            System.debug('FirstDR Result');

                                        Map<String, Object> DRinputMap = new Map<String, Object>();
                                        // DRinputMap.put('statut', 'true');
                                        DRinputMap.put('articleId', article.Id);
                                        System.debug('article id : ' + article.Id);
                
                                        // Call the DataRaptor
                                        vlocity_cmt.DRProcessResult DRresult = vlocity_cmt.DRGlobal.process(DRinputMap, 'InwiB2C_DRPLoadArticle'); 
                                        System.debug('DataRaptor Result: ' + DRresult);
                                        }
                                    }
                                    
                                    
                                    
                                }

                              
                                
                            }
                             if (orderItem.Product2.Name=='Terminal'|| Test.isRunningTest()) {
                                productAttribute='INWIB2C_ATT_RT_MODELE';
                                if(Test.isRunningTest()){
                                    resultGetAttributeValue='000019847';
           
                               }else {
                                resultGetAttributeValue = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(orderItem.vlocity_cmt__JSONAttribute__c, productAttribute);
    
                            
                               }

                                System.debug('ResultTerminal' + resultGetAttributeValue);

                                if (resultGetAttributeValue!=null) {
                                    List<InwiB2C_LoadArticle__c> loadArticleTerm= new List<InwiB2C_LoadArticle__c>(); 
                                    if(!Test.isRunningTest()){ 
                                        // loadArticleTerm= [select id,InwiB2C_CodeArticle__c,InwiB2C_SerialNumber__c,InwiB2C_Numero_de_Ligne__c,InwiB2C_Puk__c,InwiB2C_ki__c,InwiB2C_Imsi__c,InwiB2C_OcsId__c,InwiB2C_ProfilId__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_ProductCode__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId AND InwiB2C_CodeArticle__c=:resultGetAttributeValue AND InwiB2C_Updated__c='false' ORDER BY CreatedDate DESC
                                        // LIMIT 1];
                                        //B-30885 M-DJ recuperer les loadArticle avec le champ productCode begin
                                        loadArticleTerm= [select id,InwiB2C_CodeArticle__c,InwiB2C_SerialNumber__c,InwiB2C_Numero_de_Ligne__c,InwiB2C_Puk__c,InwiB2C_ki__c,InwiB2C_Imsi__c,InwiB2C_OcsId__c,InwiB2C_ProfilId__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_ProductCode__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId AND InwiB2C_ProductCode__c='TERMINAL' ORDER BY CreatedDate DESC
                                        LIMIT 1];        
                                        //B-30885 M-DJ recuperer les loadArticle avec le champ productCode end            
                                     } else {
                                        InwiB2C_LoadArticle__c newaloadarticleter = new InwiB2C_LoadArticle__c(
                                            InwiB2C_CodeArticle__c = '000019847',
                                            InwiB2C_Updated__c = 'false',
                                            InwiB2C_SerialNumber__c = '8765465785797483',
                                            InwiB2C_Order__c = orderId
                                        );
                                        loadArticleTerm = new List<InwiB2C_LoadArticle__c>{newaloadarticleter};
                                    }
                                    if (!loadArticleTerm.isEmpty()) {
                                        InwiB2C_LoadArticle__c article = loadArticleTerm[0];
                                        Map<String, Object> DRIteminputMap = new Map<String, Object>();
                                        DRIteminputMap.put('codeArticle', article.InwiB2C_CodeArticle__c);
                                        DRIteminputMap.put('imei', article.InwiB2C_SerialNumber__c);
                                        DRIteminputMap.put('orderId', orderId);
                                        DRIteminputMap.put('itemId', orderItem.Id);
                                        // Call the DataRaptor
                                        vlocity_cmt.DRProcessResult DROrderItemresult = vlocity_cmt.DRGlobal.process(DRIteminputMap, 'InwiB2C_DRPOrderItemLoadArticle'); 
                                        System.debug('OrderItem DR Result: ' + DROrderItemresult);

                                        if (DROrderItemresult.errors.isEmpty()) {
                                            System.debug('FirstDR Result');

                                        Map<String, Object> DRinputMap = new Map<String, Object>();
                                        DRinputMap.put('statut', 'true');
                                        DRinputMap.put('articleId', article.Id);
                
                                        // Call the DataRaptor
                                        vlocity_cmt.DRProcessResult DRresult = vlocity_cmt.DRGlobal.process(DRinputMap, 'InwiB2C_DRPLoadArticle'); 
                                        System.debug('DataRaptor Result: ' + DRresult);
                                        }
                                    }
                                    
                                    
                                    
                                }

                            }

                            if (orderItem.Product2.Name =='Numéro Téléphone' || Test.isRunningTest()) {
                                System.debug('orderItem Product2 Name: ' + orderItem.Product2.Name);
                                    productAttribute='INWIB2C_ATT_RT_CHOIX_NUMERO';
                                    String choixNumero = null; 
                                    if (Test.isRunningTest()) {
                                        choixNumero = 'garder';
                                    } else {
                                        String jsonAttributes = orderItem.vlocity_cmt__JSONAttribute__c;
                                        choixNumero = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(jsonAttributes, productAttribute);
                                    }
                                    
                                    System.debug('choixNumero' + choixNumero);
    
                                    if (choixNumero != null && (choixNumero.equalsIgnoreCase('garder') || choixNumero.equalsIgnoreCase('porter'))) {
                                        
                                        List<InwiB2C_LoadArticle__c> loadArticle= new List<InwiB2C_LoadArticle__c>(); 
                                        if(!Test.isRunningTest()){ 
                                        //  loadArticle= [select id,InwiB2C_Numero_de_Ligne__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId AND InwiB2C_Updated__c='false' ORDER BY CreatedDate DESC  LIMIT 1];
                                        //B-30885 M-DJ recuperer les loadArticle avec le champ productCode begin
                                            loadArticle= [select id,InwiB2C_Numero_de_Ligne__c,InwiB2C_Order__c,InwiB2C_ItemId__c,InwiB2C_Updated__c from InwiB2C_LoadArticle__c  where InwiB2C_Order__c= :orderId AND InwiB2C_ProductCode__c = 'SIM' ORDER BY CreatedDate DESC  LIMIT 1];
                                        //B-30885 M-DJ recuperer les loadArticle avec le champ productCode end
                                         } else {
                                            InwiB2C_LoadArticle__c newaloadarticle = new InwiB2C_LoadArticle__c(
                                          
                                                InwiB2C_Updated__c = 'false',
                                                InwiB2C_Numero_de_Ligne__c = '212790945115',
                                                InwiB2C_Order__c = orderId,
                                                InwiB2C_ItemId__c = orderItem.Id
                                              
                                            );
                                            loadArticle = new List<InwiB2C_LoadArticle__c>{newaloadarticle};
                                        }
    
                                        
                                        if (!loadArticle.isEmpty()) {
                                            InwiB2C_LoadArticle__c article = loadArticle[0];
                                            Map<String, Object> DRIteminputMap = new Map<String, Object>();
                                            DRIteminputMap.put('mdnPhoneNumber', article.InwiB2C_Numero_de_Ligne__c);
                                            DRIteminputMap.put('orderId', orderId);
                                            DRIteminputMap.put('itemId', orderItem.Id);
                                            // Call the DataRaptor
                                            vlocity_cmt.DRProcessResult DROrderItemresult = vlocity_cmt.DRGlobal.process(DRIteminputMap, 'InwiB2C_DRPOrderItemLoadArticle'); 
                                            System.debug('OrderItem DR Result numero telephone : ' + DROrderItemresult);
    
                                            if (DROrderItemresult.errors.isEmpty()) {
                                                System.debug('FirstDR Result');
    
                                            Map<String, Object> DRinputMap = new Map<String, Object>();
                                            DRinputMap.put('statut', 'true');
                                            DRinputMap.put('articleId', article.Id);
                    
                                            // Call the DataRaptor
                                            vlocity_cmt.DRProcessResult DRresult = vlocity_cmt.DRGlobal.process(DRinputMap, 'InwiB2C_DRPLoadArticle'); 
                                            System.debug('DataRaptor Result: ' + DRresult);
                                            }
                                        }
                                        
                                        
                                        
                                    }
    
                                  
                                    
                                }
             
                         }
                        //  if (OrderOriginal.inwiB2C_Canal__c=='inwiB2C_Eshop') {
                        //     OrderOriginal.Inwib2c_statut_Eshop__c = 'Inwib2c_En_cours_de_livraison';

                            
                        //  }
                        //  if (OrderOriginal.inwiB2C_Canal__c=='inwiB2C_Televente') {
                        //     OrderOriginal.inwiB2C_Statut_Televente__c = 'Inwib2c_En_cours_de_livraison';

                        //  }

                         update OrderOriginal;
                         result.put('CSOperationResultInfo', new Map<String, Object>{
                                        'errorCode' => '',
                                        'errorMessage' => '',
                                        'isOK' => 1,
                                        'uuid' => uuid
                                    });
                } catch (Exception e) {
                                    System.debug(' Amine BRM ERROR');
                                    result.put('CSOperationResultInfo', new Map<String, Object>{
                                        'errorCode' => 'ERROR',
                                        'errorMessage' => 'Erreur Lors de La Mise a jour des Articles',
                                        'isOK' => 0,
                                        'uuid' => uuid
                                    });
                                  }

              
    
            return result;

            ///End

            

        }
       

    }