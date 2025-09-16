global class INWIB2C_CreateContractBSCSFormatJSON implements vlocity_cmt.VlocityOpenInterface {
    global boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
        Boolean result = true;    
       try{
           
           if(methodName == 'TransformJson'){
              output.put('result',  TransformJson(input));
           }     
       } catch(Exception e){
                      
           result = false;
                   
       }     
       return true;            
  }    
  Map<String, Object> TransformJson(Map<String, Object> input){
        system.debug('call.TransformJson');  
       String typeactes='other';     
       String typecommandes='other';
       String orderId = '';
       for (String key : input.keySet())
            {       
                if(key=='typeacte'){
                    typeactes= (String) input.get(key);
                } 
                /* M-Dj 10/09/2024 recuperer type actes de gestion et l'order id  autrement si la type actes de gestion n'existe pas begin */
                else {
                    orderId = (String) input.get('id');
                    Order order = [select id, inwiB2C_TypeActeDeGestion__c from Order where id= :orderId];
                    typeactes = order.inwiB2C_TypeActeDeGestion__c;
                    System.debug('type ' + typeactes);
                }
                /* M-Dj 10/09/2024 recuperer type actes de gestion et l'order id  autrement si la type actes de gestion n'existe pas begin */
                if(key=='typecommande'){
                    typecommandes= (String) input.get(key);
                }
                if(key=='productOrderItem')     
                {   
                    Map<String, Object> POI = (Map<String, Object>) input.get(key);
                    Map<String, Object>  product = (Map<String, Object>) POI.get('product');
                    List<Object> realizingService = (List<Object>) product.get('serviceRef');
                    List<Id> ids = new  List<Id>();
                    for (Object instance : realizingService){
                        Map<String, Object>  test = (Map<String, Object>) instance;
                        ids.add((Id) test.get('id'));                        
                    }
                     //system.debug(ids);
                    List<vlocity_cmt__FulfilmentRequestLine__c> FulfReqs=[ SELECT id,vlocity_cmt__product2id__r.productcode,vlocity_cmt__action__c,vlocity_cmt__linenumber__c, vlocity_cmt__JSONAttribute__c FROM vlocity_cmt__FulfilmentRequestLine__c WHERE id in :ids limit 5000];                   
                    Map<Id,String> FulfReqsMap = new Map<Id,String>();
                    for (vlocity_cmt__FulfilmentRequestLine__c  element : FulfReqs){
                        FulfReqsMap.put(element.Id,element.vlocity_cmt__JSONAttribute__c); 
                                        
                    }   
                    // system.debug(FulfReqsMap);
                
                    List<Map<String, Object>> newrealizingService = new List<Map<String, Object>>();
                    for (Object instance : realizingService){
                        Map<String, Object>  test = (Map<String, Object>) instance;  
                     
                        String jsonattrib = (String) FulfReqsMap.get((String) test.get('id'));
                        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonattrib);
                        List<Object> INWIB2C_ACAT_MOBILE = (List<Object>) root.get('INWIB2C_ACAT_MOBILE');
                        List<Map<String, Object>> allparameter = new List<Map<String, Object>>();
                        boolean hasdiscount=false;
                        String discountType,amountTI,cycleCount,beginCycle , ART_MOD ;
                      
                        for (Object instance2 : INWIB2C_ACAT_MOBILE){
                            Map<String, Object>  instance_map = (Map<String, Object>) instance2;   
                             Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) instance_map.get('attributeRunTimeInfo');
                         
                            if( instance_map.get('Code')=='INWIB2C_REMISE_ABN_R'){
                                
                                if(!String.isBlank((String)attributeRunTimeInfo.get('value'))){
                                   amountTI = (String) attributeRunTimeInfo.get('value');
                                    
                                   hasdiscount=true;
                                   discountType=(String)'PROPORTIONAL';
 
                                }
                            }
                            if(instance_map.get('Code')=='INWIB2C_REMISE_ABN_A' ){
                               
                                 if(!String.isBlank((String)attributeRunTimeInfo.get('value'))){
                             
                                   amountTI = (String) attributeRunTimeInfo.get('value');
                                   hasdiscount=true;
                                   discountType=(String)'AMOUNT';
                    
                               }
                            }
                            if (instance_map.get('Code')=='INWIB2C_REMISE_ABN_REC'){
                                if(attributeRunTimeInfo.get('value')!=null){
                                    /*B-10273 ILA 08/09/2023 Start*/
                                   //cycleCount =  (String) attributeRunTimeInfo.get('value');
                                   
                                    String Cycletmp = (String) attributeRunTimeInfo.get('value');
                                    if(Cycletmp.indexOf('.0') != -1 )
                                        cycleCount = Cycletmp.substring(0,Cycletmp.indexOf('.0'));
                                    else 
                                        cycleCount =  (String) attributeRunTimeInfo.get('value');
                                   /*B-10273 ILA 08/09/2023 END*/
                            }
                                
                            }
                            if (instance_map.get('Code')=='InwiB2C_ATT_DC_beginCycle'){
                                if(attributeRunTimeInfo.get('value')!=null){
                                   beginCycle =  (String) attributeRunTimeInfo.get('value'); 
                                }
                                
                            }

                            // Y-MH Ajout de  attribut ART_MOD
                            if (instance_map.get('Code') == 'ART_MOD') {
                                if (attributeRunTimeInfo.get('value') != null) {
                                     ART_MOD = (String) attributeRunTimeInfo.get('value'); 
                                 }
                             }
                             // Y-MH END
                            
                     }
                     // Y-MH Ajout de  attribut ART_MOD
                        Set<String> attvalues = new Set<String>{'InwiB2C_ATT_DC_EQBACK','OVERWRITE_ABN_A','OVERWRITE_ABN_REC','OVERWRITE_ABN_A','YDSLSRCSTAT','DSLSRCSTAT','EQBACKDSL','PREQ12TTC','EQREFADSL','EQREFUND','EQBACK','PREQACQTTC','ENGAF','TYPLLGADSL','FORMCHADSL','ANFRF','EQBACKDSL','TYPVNTDSL','InwiB2C_ATT_DC_TYPVNT','TYPELINE','FORFTCH','InwiB2C_ATT_DC_TYPLIG','InwiB2C_ATT_DC_beginCycle','InwiB2C_ATT_DC_TYPHAND','InwiB2C_ATT_DC_FORPF','InwiB2C_ATT_DC_OFCOM','INWIB2C_ATT_SPRDT','InwiB2C_ATT_DC_Pass','INWIB2C_ATT_DC_MRC','InwiB2C_ATT_DC_ANNFR','InwiB2C_ATT_DC_ENGAG','InwiB2C_ATT_DC_TYPOP','InwiB2C_ATT_DC_FORCH','InwiB2C_ATT_DC_GAMOF','InwiB2C_ATT_DC_TYPLG','InwiB2C_ATT_DC_TYPHD','InwiB2C_ATT_DC_PLAFB2C','InwiB2C_ATT_DC_OPXGO','InwiB2C_ATT_DC_ACQ12','InwiB2C_ATT_DC_ACQEN','InwiB2C_ATT_DC_ACQMD','InwiB2C_ATT_DC_ACHAU','InwiB2C_ATT_DC_PASS','InwiB2C_ATT_DC_XGO2','InwiB2C_ATT_DC_TYPCAP','InwiB2C_ATT_DC_PLAFDATB2C', 'ART_MOD'};
                        // Y-MH END
                        for (Object instance2 : INWIB2C_ACAT_MOBILE){
                        
                            Map<String, Object>  instance_map = (Map<String, Object>) instance2;                             
                            Map<String, Object>  param_item = new Map<String, Object>();
                               system.debug((String)instance_map.get('attributeuniquecode__c'));
                               system.debug(attvalues.contains((String)instance_map.get('attributeuniquecode__c'))); 
                            if(attvalues.contains((String)instance_map.get('attributeuniquecode__c'))){
                                  Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) instance_map.get('attributeRunTimeInfo');
                                  //if(attributeRunTimeInfo.get('value')!=null && !String.isBlank((String)attributeRunTimeInfo.get('value'))){
                                    /*BTS ISIC 07/10/2023 ILA Start*/
                                    if(attributeRunTimeInfo.get('value') == 'ED')
                                    {
                                        param_item.put('value', 'etudiant');
                                        param_item.put('code', instance_map.get('Name'));
                                        allparameter.add(param_item); 
                                    }
                                /*B-14541 28/02/2024 ILA Start*/
                                else if(attributeRunTimeInfo.get('value') == '')
                                    continue;
                                /*B-14541 28/02/2024 ILA End*/
                                    else{
                                        param_item.put('value', attributeRunTimeInfo.get('value'));
                                        param_item.put('code', instance_map.get('Name'));
                                        allparameter.add(param_item); 
                                    }
                                    /*BTS ISIC 07/10/2023 ILA End*/
                                  
                                  
                                  //}
                            }
                          

                        
                                                                            
                        }
        
                        if(hasdiscount==true){
                            
                            Map<String, Object>  pricePlan_item = new Map<String, Object>();
                            Map<String, Object>  disc_item = new Map<String, Object>(); 
                            List<Map<String, Object>> discounts = new List<Map<String, Object>>();
                            List<Map<String, Object>> pricePlan = new List<Map<String, Object>>();
                            
                            if((beginCycle != '')&&(beginCycle!=null)){
                                disc_item.put('beginCycle',integer.valueof(beginCycle));
                            } 
                            disc_item.put('cycleCount',cycleCount);
                            disc_item.put('discountType',discountType);
                            discounts.add(disc_item); 
                            pricePlan_item.put('amountTI',amountTI);
                            pricePlan_item.put('discounts',discounts);
                            // B-28947 ILA 06/06/25 Start
                            // if (typecommandes== 'inwiB2C_Acquisition' || typeactes=='InwiB2C_MigrationPrePostpayé' || typeactes=='InwiB2C_Migration_Idar_vers_ADSL' || typeactes=='InwiB2C_Migration_Idar_vers_FTTH')
                            if (typecommandes== 'inwiB2C_Acquisition' || typeactes=='InwiB2C_MigrationPrePostpayé' || typeactes=='InwiB2C_Migration_Idar_vers_ADSL' || typeactes=='InwiB2C_Migration_Idar_vers_FTTH' || typeactes=='InwiB2C_Migration_ADSL_Vers_FTTH' || typeactes=='InwiB2C_Migration_ADSL_Vers_IDAR' || typeactes=='InwiB2C_Migration_FTTH_Vers_IDAR' || typeactes=='InwiB2C_Migration_FTTH_Vers_ADSL')
                            // B-28947 ILA 06/06/25 End
                            {
                                 pricePlan_item.put('pricetype','RECURENT_DSICOUNT');
                     
                            }else{
                                pricePlan_item.put('pricetype','RECURENT');
                            }
                            pricePlan.add(pricePlan_item);
                            test.put('pricePlan',pricePlan);
                            test.put('discountMode','DSICOUNT_SERVICE');
                      
                        }
                        /* B-19583 M-dj 10/09/2024 add paramter FLIBREMISE begin */
                        if (typeactes == 'InwiB2C_Offre_retention_ADSL' && (String)test.get('code') == 'ANDSL') {
                            Map<String,String> retensionADSLParam = new Map<String,String>();
                            orderItemAppliedPromotion__c orderItemPro = [ select id, promotionId__r.Name from orderItemAppliedPromotion__c where orderItemId__r.OrderId = :orderId];                            
                            String code = 'FLIBREMISE';
                            String value = (String) orderItemPro.promotionId__r.Name;
                            retensionADSLParam.put('code', code);
                            retensionADSLParam.put('value', value);
                            allparameter.add(retensionADSLParam); 
                        }

                        System.debug('allparameter ' + allparameter);
                        /* B-19583 M-dj 10/09/2024 add paramter FLIBREMISE end */

                        test.put('parameter', allparameter);
                        test.put('hasDiscount',hasdiscount);
                      
                        newrealizingService.add(test);
                  }  
                    product.put('serviceRef',newrealizingService);
                    POI.put('product', product);
                    
                    system.debug(POI.get('typecommande'));  
                    system.debug('valeur'+typeactes);  
                   
                
                }
                } 
         return input;
            }
    
 
    
            
}