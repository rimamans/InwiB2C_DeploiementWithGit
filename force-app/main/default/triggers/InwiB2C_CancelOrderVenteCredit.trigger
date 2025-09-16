trigger InwiB2C_CancelOrderVenteCredit on inwiB2C_CancelOrdersBatchEvent__e (after insert) {

        String IP_UnlockArticle = 'Inwi_InwiB2C_UnLockArticle';
        String IP_UnlockMDN = 'Inwi_InwiB2_UnlockMdn';
        String icc;
        String imei;
        String CodeArticleSim;
        String CodeArticleTerminal;
        String mdn;
        List<Order> OrdersToCancel = new List<Order>();
        
       
        List<Id> OrdersIdList = new  List<Id>();
        
        for(inwiB2C_CancelOrdersBatchEvent__e currentOrder : Trigger.new){
    
            OrdersIdList.add(currentOrder.inwiB2C_OrderId__c);
    
        }
        
        
        List<OrderItem> OrderItemListTERM = [SELECT id,OrderId,Product2.ProductCode, vlocity_cmt__JSONAttribute__c,Order.inwib2c_TypeDeLaCommande__c FROM OrderItem WHERE OrderId in :OrdersIdList AND Product2.ProductCode = 'INWIB2C_OFFERING_TERMINAL' AND Order.inwib2c_TypeDeLaCommande__c ='inwiB2C_Acquisition'];
        List<Order> OrdersList = [SELECT id, inwib2c_TypeDeLaCommande__c, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwiB2C_Statut__c, inwib2c_MotifAnnulation__c FROM Order WHERE Id in :OrdersIdList];
        
        Map<Id,OrderItem> OrderItemListMap = new Map<Id,OrderItem>();
        Map<Id,Order> OrderListMap = new Map<Id,Order>();
        
        for (Order CurrentOrder: OrdersList ){
            OrderListMap.put(CurrentOrder.Id, CurrentOrder);
        }
    
        for (inwiB2C_CancelOrdersBatchEvent__e event : Trigger.New) {
        
            Order OrderItem= OrderListMap.get(event.inwiB2C_OrderId__c);
            
            OrderItem.inwiB2C_Statut__c = 'inwiB2C_Annulee';
            OrderItem.inwib2c_MotifAnnulation__c = 'inwib2c_CommandeExpiree';
            OrderItem.inwib2c_DetailMotif__c = 'Le délai de mise en attente de la commande a expiré';
            //OrderItem.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification';
            String vendor = OrderItem.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
            
            OrdersToCancel.add(orderItem);
            
              List<OrderItem> ordItemterminal = new List<OrderItem>();
            for (orderItem OItem: OrderItemListTERM )
            {
                if (OItem.OrderId == orderItem.id )
                {
                    ordItemterminal.add(OItem);
                }
            }                            
            if(ordItemterminal.size()>0){
                for(OrderItem ordLineItem : ordItemterminal)
                { if (ordLineItem.Product2.ProductCode == 'INWIB2C_OFFERING_TERMINAL' && ordLineItem.vlocity_cmt__JSONAttribute__c != null && ordLineItem.vlocity_cmt__JSONAttribute__c !='')
                    imei= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_IMEI');
                 CodeArticleTerminal= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_MODELE');
                 
                 Map<String, Object> HandsetItemsTerminal = new Map<String, Object>();
                 HandsetItemsTerminal.put('code', CodeArticleTerminal);
                 HandsetItemsTerminal.put('serialNumber', imei);
                 HandsetItemsTerminal.put('orderType', 'MOBILE');
                 HandsetItemsTerminal.put('vendor', vendor);
                 HandsetItemsTerminal.put('quantity', '1');
                 
                 Map <String, Object> ipInput = new Map <String, Object> ();
                 Map <String, Object> ipOutput = new Map <String, Object> ();
                 Map <String, Object> ipOptions = new Map <String, Object> ();
                 
                 /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
                 ipInput.put('username', 'Jawad');
                 ipInput.put('action', 'OS');
                 ipInput.put('mode', 'SALE');
                 ipInput.put('channel', 'SF');
                 ipInput.put('id', '12');
                 ipInput.put('orgID', 'INWI');
                 ipInput.put('marketSegment', 'B2C');
                 ipInput.put('offerType', 'MOBILE');
                 List<Map<String, Object>> NewListObj = new List<Map<String, Object>>();
                 NewListObj.add(HandsetItemsTerminal);
                 
                 ipInput.put('handset', NewListObj);
           
                 
                 //appel VIP à travers classe

                 Map <String, Object> Params = new Map <String, Object> ();
                 Params.put('Name',IP_UnlockArticle);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
                 inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
                 
                }
           
            }
        }
        if(!Test.isRunningTest()) {
            update OrdersToCancel;
        }


}