global without sharing class inwiB2C_APISnowCallBack implements vlocity_cmt.VlocityOpenInterface{
  global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName == 'UpdateAttribute') {
                   outMap.put('result', UpdateAttribute(inputMap));
               }
     return true;
   }
      Map<String,Object> UpdateAttribute(Map<String,Object> inputMap) {
        List<Object> CSservices = (List<Object>)inputMap.get('services');
        String idOrechstrationItem=(String)inputMap.get('id');
        system.debug('json'+CSservices);
        List<Id> ids = new  List<Id>();
        String idTopAsset;
        //select all id asset from request
        for (Object attribute : CSservices){
          Map<String, Object> itemAttributeMap = (Map<String, Object>)attribute;
          if(!ids.contains((Id)itemAttributeMap.get('service_ins'))){
            ids.add((Id) itemAttributeMap.get('service_ins')); 
         // CHB ano B-9377 B-9308
         if (!itemAttributeMap.get('service_code').equals('INWIB2C_FOB2C_OFFERING_TERMINAL')) {
          idTopAsset = (String) itemAttributeMap.get('service_ins');
          System.debug('idTopAsset'+idTopAsset);} }
        } 
        system.debug('ids: '+ids);
        String resultjson ;
        String resultjsonOrderItem;
        String imeiValue;
        //Map Id with json
        List<Asset> assets=[select id,vlocity_cmt__OrderProductId__c,vlocity_cmt__OrderProductId__r.vlocity_cmt__JSONAttribute__c,vlocity_cmt__JSONAttribute__c from Asset where  id in :ids limit 5000] ;
        Map<Id,String> AssetReqsMap = new Map<Id,String>();
        Map<Id,String> orderItemReqsMap = new Map<Id,String>();
        Map<Id,String> orderItemJsonReqsMap = new Map<Id,String>();
       
        for (Asset  element : assets){
          AssetReqsMap.put(element.Id,element.vlocity_cmt__JSONAttribute__c);
          orderItemReqsMap.put(element.Id,element.vlocity_cmt__OrderProductId__c); 
          orderItemJsonReqsMap.put(element.vlocity_cmt__OrderProductId__c,element.vlocity_cmt__OrderProductId__r.vlocity_cmt__JSONAttribute__c); 
        }	
       
        List<vlocity_cmt__Subscription__c> subscriptionList =new List <vlocity_cmt__Subscription__c>();
        List<Asset> assetList =new List <Asset>();
        List<OrderItem> orderItemList =new List <OrderItem>();
        //Map json attribute and attribute Req
        for (Object attribute : CSservices){
          Map<String, Object> itemAttributeMap = (Map<String, Object>)attribute;
          List<Object> attributeRunTimeInfo = (List<Object>)itemAttributeMap.get('attributes');
          String Id =(String)itemAttributeMap.get('service_ins');

          
          String jsonattrib = (String) AssetReqsMap.get(Id);
          String orderitemId=(String)  orderItemReqsMap.get(Id);
          String jsonOrderItem=(String) orderItemJsonReqsMap.get(orderitemId);
         
          Map<String,String> attributeTest = new Map<String,String>();
          if (attributeRunTimeInfo != null){
            for (Object attribut : attributeRunTimeInfo){                                 
              Map<String, Object> iteminsert = new Map<String, Object>();
              Map<String, Object> itemAttribute = (Map<String, Object>)attribut;              
              iteminsert.put('attribute_code', itemAttribute.get('attribute_code'));
              iteminsert.put('attribute_value', itemAttribute.get('attribute_value'));
              String attribute_code = (String)iteminsert.get('attribute_code');
              String attribute_value = (String)iteminsert.get('attribute_value');                            
              attributeTest.put(attribute_code,attribute_value);
               //recuperer la valeur de l'imei  CHB ano B-9377 --B-9308
              if (itemAttribute.get('attribute_code').equals('INWIB2C_ATT_RT_IMEI')) {
                imeiValue = (String) itemAttribute.get('attribute_value');
                System.debug('imei'+imeiValue);
            }}
          }
          //call class INWIB2C_INWIJSONAttributeUtilities (Asset && OrderItem)
          resultjson = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(jsonattrib, attributeTest);
          resultjsonOrderItem = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(jsonOrderItem, attributeTest);
          
          system.debug('result'+resultjson);
         
          //List for update 
          assetList.add(new Asset(id = Id, vlocity_cmt__JSONAttribute__c = resultjson));
          orderItemList.add(new OrderItem(id = orderitemId, vlocity_cmt__JSONAttribute__c = resultjsonOrderItem));
        }// begin CHB ano B-9377
          //update le champ Imei au niveau de la soucription
          //recuperer l'id de la souscription
          
          List<Asset> assetTop = new List<Asset>();
          assetTop = [select id,vlocity_cmt__SubscriptionId__c 
                      from Asset
                      where Id=: idTopAsset and vlocity_cmt__ParentItemId__c=:null
                      ];
          id idSubscription;
          for(Asset assetListH:assetTop){
            idSubscription=assetListH.vlocity_cmt__SubscriptionId__c;
          }
         
          subscriptionList.add(new vlocity_cmt__Subscription__c (id = idSubscription, InwiB2C_MEI__c = imeiValue));
        //end  CHB ano B-9377
        //update Attribute from Inventory && Fulfilment
        List<vlocity_cmt__InventoryItem__c> InventoryItemList =new List <vlocity_cmt__InventoryItem__c>();
        List<vlocity_cmt__FulfilmentRequestLine__c > fulfilmentRequestLineList =new List <vlocity_cmt__FulfilmentRequestLine__c >();
        String resultjsonInventory;
        String resultjsonFulfilment;
        List<String> productCodeList = new List<String>{};  
        productCodeList.add('INWIB2C_RFS_MOBILE_OFFER');
        productCodeList.add('INWIB2C_RFS_TERMINAL');
        //select id inventory
        List<vlocity_cmt__InventoryItemDecompositionRelationship__c > inventoryDecomp=[select vlocity_cmt__SourceAssetId__c,
        vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode ,
        vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c 
        from vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE 
        vlocity_cmt__SourceAssetId__c  in :ids 
        AND  vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__ProductId__r.ProductCode in: productCodeList limit 5000] ;
          //Part of FulfilmentRequest
          //**select id of orchestration plan */

        List<vlocity_cmt__OrchestrationItem__c> orchestrationItemLIST=[select vlocity_cmt__OrchestrationPlanId__c  
        FROM vlocity_cmt__OrchestrationItem__c where Id=: idOrechstrationItem];
        String idOrechPlan;
        for(vlocity_cmt__OrchestrationItem__c orchestration :orchestrationItemLIST){
          idOrechPlan=orchestration.vlocity_cmt__OrchestrationPlanId__c;
        }
        system.debug('idOrechPlan: '+idOrechPlan);
        //**Select id of fulfilment Request */
        List<vlocity_cmt__FulfilmentRequest__c> fulfilmentReqLIST=[select id from vlocity_cmt__FulfilmentRequest__c 
         WHERE vlocity_cmt__orchestrationPlanId__c =:idOrechPlan];
        String idFulfimentReq;
        for(vlocity_cmt__FulfilmentRequest__c   FulfilmntReq :fulfilmentReqLIST){
          idFulfimentReq=FulfilmntReq.id;
        }
       
        system.debug('idFulfimentReq: '+idFulfimentReq);
        //**select fulfilmentRequstLine */
        List<vlocity_cmt__FulfilmentRequestLine__c> fulfilmentReqLineLIST=[select id,vlocity_cmt__Product2Id__r.ProductCode,vlocity_cmt__JSONAttribute__c from vlocity_cmt__FulfilmentRequestLine__c 
        WHERE vlocity_cmt__FulfilmentRequestID__c =:idFulfimentReq AND vlocity_cmt__Product2Id__r.ProductCode in: productCodeList] ;
        Map<Id,String> fulfilmentReqLineMap = new Map<Id,String>();
        Map<String,String> productCodeMap = new Map<String,String>();
        for (vlocity_cmt__FulfilmentRequestLine__c  element : fulfilmentReqLineLIST){
          fulfilmentReqLineMap.put(element.Id,element.vlocity_cmt__JSONAttribute__c);
          productCodeMap.put(element.vlocity_cmt__Product2Id__r.ProductCode,element.Id);
        /*  String productCode;
          if(element.vlocity_cmt__Product2Id__r.ProductCode=='INWIB2C_RFS_TERMINAL'){
            productCode='INWIB2C_FOB2C_OFFERING_TERMINAL';
            productCodeMap.put(element.id,productCode)
          }else{
            for (Object attribute : CSservices){
              Map<String, Object> itemAttributeMap = (Map<String, Object>)attribute;
              productCode=itemAttributeMap.get('service_code'); 
              if(itemAttributeMap.get('service_code')!='INWIB2C_RFS_TERMINAL'){
              productCodeMap.put(element.id,productCode)
              }
            }
            } 
          }*/    
        }	//Map id inventory Item
        system.debug('fulfilmentReqLineMap:'+fulfilmentReqLineMap);
         Map<Id,String> inventoryAssetReqsMap = new Map<Id,String>();
         Map<Id,String> inentoryReqsMap = new Map<Id,String>();
         for (vlocity_cmt__InventoryItemDecompositionRelationship__c  element : inventoryDecomp){
          inventoryAssetReqsMap.put(element.vlocity_cmt__SourceAssetId__c,element.vlocity_cmt__DestinationInventoryItemId__r.vlocity_cmt__JSONAttribute__c);
          inentoryReqsMap.put(element.vlocity_cmt__SourceAssetId__c,element.vlocity_cmt__DestinationInventoryItemId__c);     
         }	
         system.debug('inveAsset'+inventoryAssetReqsMap);
         system.debug('inentoryReqsMap'+inentoryReqsMap);
         for (Object attribute : CSservices){
          Map<String, Object> itemAttributeMap = (Map<String, Object>)attribute;
          List<Object> attributeRunTimeInfo = (List<Object>)itemAttributeMap.get('attributes');
          String Id =(String)itemAttributeMap.get('service_ins');
          String jsonattribInv = (String) inventoryAssetReqsMap.get(Id);
          String inentoryId=(String)inentoryReqsMap.get(Id);
          //traitement ProductCode for FulfilmentRequestLine
          String code;
          if(itemAttributeMap.get('service_code')=='INWIB2C_FOB2C_OFFERING_TERMINAL'){
            code='INWIB2C_RFS_TERMINAL';
          }else{
            code='INWIB2C_RFS_MOBILE_OFFER';
          }
          //select Id fulfilmentReq Line
          String prodCodeFulflmentLineId=(String)productCodeMap.get(code);
          system.debug('codeProductFulf'+prodCodeFulflmentLineId);
          //select json FulfilmntRequLine
          String jsonattribFulfilmntRquLine = (String) fulfilmentReqLineMap.get(prodCodeFulflmentLineId);
          system.debug('jsonattribFulfilmntRquLine'+jsonattribFulfilmntRquLine);
          Map<String,String> attributeTest = new Map<String,String>();
          if (attributeRunTimeInfo != null){
            for (Object attribut : attributeRunTimeInfo){                                 
              Map<String, Object> iteminsert = new Map<String, Object>();
              Map<String, Object> itemAttribute = (Map<String, Object>)attribut; 
              String AttributeCode;
              //Mapping Attribute (RT to DC)
              if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_IMEI') {
                AttributeCode='INWIB2C_ATT_DC_IMEI';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_ONTNAME') {
                AttributeCode='INWIB2C_ATT_DC_ONTNAME';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_ONTALIAS'){
                AttributeCode='INWIB2C_ATT_DC_ONTALIAS';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_ONTID'){
                AttributeCode='INWIB2C_ATT_DC_ONTID';
              }
              else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_CPEMAC'){
                AttributeCode='INWIB2C_ATT_DC_CPEMAC';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_FRAME'){
                AttributeCode='INWIB2C_ATT_DC_FRAME';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_PORT'){
                AttributeCode='INWIB2C_ATT_DC_PORT';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_SLOT'){
                AttributeCode='INWIB2C_ATT_DC_SLOT';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_OLTID'){
                AttributeCode='INWIB2C_ATT_DC_OLTID';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_MODELE'){
                AttributeCode='INWIB2C_ATT_DC_MODEL';
              }
              else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_NRAID'){
                AttributeCode='INWIB2C_ATT_DC_NRAID';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_PROVIDER'){
               //chb 21/03/2025 INWIB2C_ATT_DC_PROVIDER au lieu INWIB2C_ATT_DC_PROVIDERID B-27432
                AttributeCode='INWIB2C_ATT_DC_PROVIDER';
              }else if(itemAttribute.get('attribute_code')=='INWIB2C_ATT_RT_ONUID'){
                AttributeCode='INWIB2C_ATT_DC_ONUID';
                
                //Y_MH MGEN3759 Parcours FTTH Propre - Séparation CPE_ONU begin
              }  else if(itemAttribute.get('attribute_code')=='iNWIB2C_ATT_RT_EQUIPONU'){
                AttributeCode='INWIB2C_ATT_DC_EQUIPONU';}
                //Y_MH MGEN3759 Parcours FTTH Propre - Séparation CPE_ONU end
               
             // system.debug('Attributecode',AttributeCode);
              iteminsert.put('attribute_code',AttributeCode);
              iteminsert.put('attribute_value', itemAttribute.get('attribute_value'));
              String attribute_code = (String)iteminsert.get('attribute_code');
              String attribute_value = (String)iteminsert.get('attribute_value');                            
              attributeTest.put(AttributeCode,attribute_value);
            }
          }//Update Json For inventory Item
          resultjsonInventory = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(jsonattribInv, attributeTest);
          system.debug('result'+resultjsonInventory);
          //Update Json for FulfilmentReqLine
          resultjsonFulfilment = INWIB2C_INWIJSONAttributeUtilities.updateAttributesValueFromJSON(jsonattribFulfilmntRquLine, attributeTest);
          //update 
          InventoryItemList.add(new vlocity_cmt__InventoryItem__c (id = inentoryId, vlocity_cmt__JSONAttribute__c = resultjsonInventory));
          fulfilmentRequestLineList.add(new vlocity_cmt__FulfilmentRequestLine__c(id=prodCodeFulflmentLineId,vlocity_cmt__JSONAttribute__c=resultjsonFulfilment) );
          system.debug('fulfilmentRequestLineList'+fulfilmentRequestLineList);
      }
      Map<String, Object> result = new Map<String, Object>();
    if(!Test.isRunningTest() && assetList.size() > 0 && orderItemList.size() > 0 && InventoryItemList.size() > 0&& fulfilmentRequestLineList.size() > 0 && subscriptionList.size() > 0){
        update assetList;
        update orderItemList;
        update InventoryItemList;
        update fulfilmentRequestLineList;
        update subscriptionList;
   
      result.put('IsOK','1');
      result.put('statut','OK');
    }
    else{
      result.put('IsOK','0');
      result.put('statut','KO');
    }
    
       return result;
      }   
     

}