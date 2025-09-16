public without sharing class InwiB2C_VOCGetOrderMDN {
    @InvocableMethod
		public static List<String> getOrderItemAttributes(List<String> orderIds) {
            
        System.debug('list ' + orderIds);
        System.debug('Inputs size: ' + orderIds.size());

        List<String> results = new List<String>();
        Map<String, Integer> orderIndexMap = new Map<String, Integer>();
        
            
      if (orderIds.size() == 0) {
            results.add('');
            return results;
        }
            
        for (Integer i = 0; i < orderIds.size(); i++) {
            orderIndexMap.put(orderIds[i], i);
            results.add(''); 
        }


        if(SystemFacade.isBatch() == true || SystemFacade.isFuture() == true){ 
           /*   for(String orderId : orderIds ){
             results.add('');   
            }
            */
            System.debug('stop bulk ');
            return results;
        }     
            
        


        // Query OrderItem records
        List<OrderItem> orderItems = [
            SELECT vlocity_cmt__JSONAttribute__c , OrderId
            FROM OrderItem 
            WHERE OrderId IN :orderIds 
            AND  Product2.Name = 'Numéro Téléphone' // Product2.ProductCode LIKE '%OFFERING_MSISDN_STANDARD%'
        ];


        for (OrderItem orderItem : orderItems) {
            String jsonAttribute = orderItem.vlocity_cmt__JSONAttribute__c;
            if (jsonAttribute != null) {
                try {
                    // Parse JSON string
                    Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonAttribute);
                    if (jsonMap.containsKey('INWIB2C_ACAT_MOBILE')) {
                        List<Object> attributList = (List<Object>) jsonMap.get('INWIB2C_ACAT_MOBILE');
                        for (Object attributeObj : attributList) {
                            Map<String, Object> attributeMap = (Map<String, Object>) attributeObj;
                            if (attributeMap.get('attributeuniquecode__c') == 'INWIB2C_ATT_RT_MSISDN') {
                                Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) attributeMap.get('attributeRunTimeInfo');
                                System.debug('MDN'+attributeRunTimeInfo);
                                if (attributeRunTimeInfo != null && attributeRunTimeInfo.containsKey('value')) {
                                    Integer index = orderIndexMap.get(orderItem.OrderId);
                                	results.set(index, (String) attributeRunTimeInfo.get('value'));
                                	break; 
                                }
                                
                            }
                        }
                    }
                } catch (Exception e) {
					System.debug('Exception '+ e);
                }
            }
        }
        
        System.debug('Records size: ' + results.size());
        System.debug('Output: ' + results);
        return results;
      }  

}