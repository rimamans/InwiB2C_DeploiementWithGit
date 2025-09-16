/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-05-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger InwiB2C_CancelOrdersTrigger on inwiB2C_CancelOrdersBatchEvent__e (after insert) {

        String IP_InwiB2C_UnLockRessourse = 'Inwi_InwiB2C_UnLockRessourse';
       // String IP_UnlockMDN = 'Inwi_InwiB2_UnlockMdn';
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
        
        
        List<OrderItem> OrderItemListSIM = [SELECT id,Order.InwiB2C_AvecRecuperation__c,Product2.Name,OrderId,Order.inwiB2C_TypeDeMigration__c,Product2.ProductCode, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId in :OrdersIdList AND Order.inwiB2C_TypeDeMigration__c !='InwiB2C_MigrationPrePostpayé' AND Product2.Name = 'SIM'];
        List<OrderItem> OrderItemListTERM = [SELECT id,Order.InwiB2C_AvecRecuperation__c,Product2.Name,OrderId,Product2.ProductCode, vlocity_cmt__JSONAttribute__c,Order.inwib2c_TypeDeLaCommande__c FROM OrderItem WHERE OrderId in :OrdersIdList AND Product2.Name = 'Terminal'];
        List<OrderItem> OrderItemListMDN = [SELECT id,Product2.Name,Order.InwiB2C_AvecRecuperation__c,OrderId,Order.inwiB2C_TypeDeMigration__c,Product2.ProductCode, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId in :OrdersIdList AND Order.inwiB2C_TypeDeMigration__c !='InwiB2C_MigrationPrePostpayé' AND Product2.Name  = 'Numéro Téléphone'];
        List<Order> OrdersList = [SELECT id, inwib2c_TypeDeLaCommande__c,Order.InwiB2C_AvecRecuperation__c, inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwiB2C_Statut__c, inwib2c_MotifAnnulation__c FROM Order WHERE Id in :OrdersIdList];
        
        Map<Id,OrderItem> OrderItemListMap = new Map<Id,OrderItem>();
        Map<Id,Order> OrderListMap = new Map<Id,Order>();
        
        for (Order CurrentOrder: OrdersList ){
            OrderListMap.put(CurrentOrder.Id, CurrentOrder);
        }
        Map <String, Object> Params = new Map <String, Object> ();
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
        List<Map<String, Object>> NewListObj = new List<Map<String, Object>>();

       
     
    


        for (inwiB2C_CancelOrdersBatchEvent__e event : Trigger.New) {
        
         Order OrderItem= OrderListMap.get(event.inwiB2C_OrderId__c);

         // H-M Update motif annulation  commande recycler d2d BEGIN 
         
         if (OrderItem.inwiB2C_Statut__c == 'inwiB2C_A_Recycler') {
            OrderItem.inwib2c_MotifAnnulation__c = 'inwiB2C_Timeout_Recyclage';
        } else{
           OrderItem.inwib2c_MotifAnnulation__c = 'inwib2c_CommandeExpiree';
         }
          // H-M Update motif annulation  commande recycler d2d END 

          OrderItem.inwiB2C_Statut__c = 'inwiB2C_Annulee';
        
            //OrderItem.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification';
            String vendor = OrderItem.inwib2c_Partenaire__r.inwib2c_CodePartenaire__c;
            
            OrdersToCancel.add(orderItem);

            
            //get attributs from order sim
            //List<OrderItem> ordItemsim = [ SELECT id,Product2.ProductCode, vlocity_cmt__JSONAttribute__c FROM OrderItem
            // WHERE OrderId =:orderItem.id and Product2.ProductCode = 'INWIB2C_OFFERING_SIM'];
            List<OrderItem> ordItemsim = new List<OrderItem>();
            for (orderItem OItem: OrderItemListSIM)
            {
                if (OItem.OrderId == orderItem.id )
                {
                    ordItemsim.add(OItem);
                }
            }
            
            if(ordItemsim.size()>0)
            {
                
                for(OrderItem ordLineItem : ordItemsim)
                { if (ordLineItem.Product2.Name == 'SIM' && ordLineItem.vlocity_cmt__JSONAttribute__c != null && ordLineItem.vlocity_cmt__JSONAttribute__c !='')
                    icc= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_ICCID');
                 CodeArticleSim= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_MODELE_CARTE_SIM');
                 system.debug('icc ------> '+icc);
                 
                 Map<String, Object> HandsetItemsSIM = new Map<String, Object>();
                 HandsetItemsSIM.put('code', CodeArticleSim);
                 HandsetItemsSIM.put('serialNumber', icc);
                 HandsetItemsSIM.put('orderType', 'MOBILE');
                 HandsetItemsSIM.put('vendor', vendor);
                 HandsetItemsSIM.put('quantity', '1');
                 
                 
                 /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
                 ipInput.put('username', 'Jawad');
                 ipInput.put('action', 'OS');
                 ipInput.put('mode', 'SALE');
                 ipInput.put('channel', 'SF');
                 ipInput.put('id', '12');
                 ipInput.put('orgID', 'INWI');
                 ipInput.put('marketSegment', 'B2C');
                 ipInput.put('offerType', 'MOBILE');
                 NewListObj.add(HandsetItemsSIM);
                 
                 ipInput.put('handset', NewListObj);
                 
                 Params.put('Name',IP_InwiB2C_UnLockRessourse);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
                 
    
                }
            }
            
            
                List<OrderItem> ordItemterminal = new List<OrderItem>();
            for (orderItem OItem: OrderItemListTERM )
            {
                if (OItem.OrderId == orderItem.id )
                {
                    ordItemterminal.add(OItem);
                }
            }                            
            if(ordItemterminal.size()>0)
            {
                for(OrderItem ordLineItem : ordItemterminal)
                { if (ordLineItem.Product2.Name == 'Terminal' && ordLineItem.vlocity_cmt__JSONAttribute__c != null && ordLineItem.vlocity_cmt__JSONAttribute__c !='')
                    imei= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_IMEI');
                 CodeArticleTerminal= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_MODELE');
                 
                 Map<String, Object> HandsetItemsTerminal = new Map<String, Object>();
                 HandsetItemsTerminal.put('code', CodeArticleTerminal);
                 HandsetItemsTerminal.put('serialNumber', imei);
                 HandsetItemsTerminal.put('orderType', 'MOBILE');
                 HandsetItemsTerminal.put('vendor', vendor);
                 HandsetItemsTerminal.put('quantity', '1');
                 
               
                 /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
                 ipInput.put('username', 'Jawad');
                 ipInput.put('action', 'OS');
                 ipInput.put('mode', 'SALE');
                 ipInput.put('channel', 'SF');
                 ipInput.put('id', '12');
                 ipInput.put('orgID', 'INWI');
                 ipInput.put('marketSegment', 'B2C');
                 ipInput.put('offerType', 'MOBILE');
                // List<Map<String, Object>> NewListObj = new List<Map<String, Object>>();
                 NewListObj.add(HandsetItemsTerminal);
                 
                 ipInput.put('handset', NewListObj);
                 Params.put('Name',IP_InwiB2C_UnLockRessourse);
                 Params.put('ipInput',ipInput);
                 Params.put('ipOptions',ipOptions);
              
                }
            }
            //get attributs from order MDN
            //List<OrderItem> ordItemMdn = [ SELECT id,Product2.ProductCode, vlocity_cmt__JSONAttribute__c FROM OrderItem
            // WHERE OrderId =:orderItem.id and Product2.ProductCode  = 'INWIB2C_OFFERING_MSISDN_STANDARD'];
            List<OrderItem> ordItemMdn = new List<OrderItem>();
            for (orderItem OItem: OrderItemListMDN )
            {
                if (OItem.OrderId == orderItem.id )
                {
                    ordItemMdn.add(OItem);
                }
            }   
            if(ordItemMdn.size()>0)
            {
                for(OrderItem ordLineItem : ordItemMdn)
                { if (ordLineItem.Product2.Name == 'Numéro Téléphone' && ordLineItem.vlocity_cmt__JSONAttribute__c != null && ordLineItem.vlocity_cmt__JSONAttribute__c !='')
                    if(!Test.isRunningTest()) {
                    mdn= INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(ordLineItem.vlocity_cmt__JSONAttribute__c,'INWIB2C_ATT_RT_MSISDN');
                    }

                    Map<String, Object> MDNjson = new Map<String, Object>();
                    MDNjson.put('mdn', mdn);
                    MDNjson.put('lockToken', orderItem.id);
                    MDNjson.put('avecRecuperation', orderItem.inwiB2C_AvecRecuperation__c);
                    
                    ipInput.put('MDN',MDNjson);
                    System.debug('ipInput mis à jour avec MDN : ' + ipInput);

                 
                    Params.put('Name',IP_InwiB2C_UnLockRessourse);
                    Params.put('ipInput',ipInput);
                    Params.put('ipOptions',ipOptions);
                    System.debug('Params mis à jour : ' + Params);

                
                }
            }
            system.debug('datas');

             system.debug(JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));


        }
        if(!Test.isRunningTest()) {
            update OrdersToCancel;
        }


}