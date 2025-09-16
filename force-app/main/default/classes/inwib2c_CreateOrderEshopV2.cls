global without sharing  class inwib2c_CreateOrderEshopV2  {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName == 'CreateOrderEshopV2') {
                   outMap.put('result', CreateOrderEshopV2(inputMap));
               }
     return true;
   }
    // public  inwib2c_CreateOrderEshop() {

    // }
    //public   static String CreateOrderEshopV2(String traceId){

    Map<String,Object> CreateOrderEshopV2(Map<String,Object> inputMap) {
    System.debug('Amine brm');
        // InwiB2C_Trace_API__c traceObj = [select id, InwiB2C_Object_Number__c, InwiB2C_request_body__c from InwiB2C_Trace_API__c where id = :traceId];
        // Map <String, Object> inputJsonMap = (Map <String, Object>) JSON.deserializeUntyped(inputMap);
        
        String traceId=(String) inputMap.get('TraceId'); 
        String bodyJson = (String) inputMap.get('bodyJson');
        Map<String, Object> inputJsonMap = (Map<String, Object>) JSON.deserializeUntyped(bodyJson);
        
    //     Map<String,Object> input = (Map<String,Object>) inputMap.get('bodyJson');
    //     String bodyJson = (String) inputMap.get('bodyJson');
    //    Map<String, Object> inputJsonMap = (Map<String, Object>) JSON.deserializeUntyped(bodyJson);

        //Map <String, Object> input = (Map <String, Object>) JSON.deserializeUntyped(inputJsonMap);
        String customerId=(String)inputJsonMap.get('customerId');
        String buyerId=(String)inputJsonMap.get('buyerId');
        String paymentMethod=(String)inputJsonMap.get('paymentMethod');
        String paymentReference=(String)inputJsonMap.get('paymentReference');



        // InwiB2C_Trace_API__c traceObj = [select id, InwiB2C_Object_Number__c, InwiB2C_request_body__c from InwiB2C_Trace_API__c where id = :traceId];
        // Map <String, Object> inputJsonMap = (Map <String, Object>) JSON.deserializeUntyped(traceObj.InwiB2C_request_body__c);
       
        // String customerId=(String)inputJsonMap.get('customerId');
        // String buyerId=(String)inputJsonMap.get('buyerId');
        // String paymentMethod=(String)inputJsonMap.get('paymentMethod');
        // String paymentReference=(String)inputJsonMap.get('paymentReference');


        String type='';
        String codeliv='';
        String deliveryPrice='';
        String typelivraison='';
        String agenceId='';
        String canal='inwiB2C_Eshop';
        String modepayement ='';
        String offerType='';
        String typedeProduit='';
        String codedeProduit='';

        if (paymentMethod=='BC') {
            modepayement='inwiB2C_E-paiement';  
            
        }else {
            if (paymentMethod=='CB') {
                modepayement='inwiB2C_TPE';
            } else {
                modepayement='inwiB2C_EnEspece'; 
                
            }
            
        }

        List<Map<String, Object>> deliveryList = new List<Map<String, Object>>();
        Map<String, Object> delivery = (Map<String, Object>) inputJsonMap.get('delivery');
        deliveryList.add(delivery);
        for (Map<String, Object> deliveryItem : deliveryList) {
                type = (String) deliveryItem.get('type');
                codeliv = (String) deliveryItem.get('codeliv');
                agenceId = (String) deliveryItem.get('agenceId');
                deliveryPrice = (String) deliveryItem.get('deliveryPrice');
            
            
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
        
        List<String> productCodes = new List<String>();

        //Map <String, Object> inputJsonMap = (Map <String, Object>) JSON.deserializeUntyped(inputMap);
        //List<Object> products = (List<Object>) bodyJson.get('products');
        List<Object> products = (List<Object>) inputJsonMap.get('products');
        List<Map<String, Object>> codeProduit = new List<Map<String, Object>>();
        Map <String, Object> product = (Map <String, Object>) products[0];
        codeProduit.add(product);
        string codeOffre='';
        String  profil='';
        String engagement='';

       

        // for (Map<String, Object> CodeItem : codeProduit) {
        //     codeOffre = (String) CodeItem.get('code');
        //     profil = (String) CodeItem.get('idProfile');
        //     engagement = (String) CodeItem.get('engagement');  
        // }
        for (Map<String, Object> CodeItem : codeProduit) {
            String tempCodeOffre = (String) CodeItem.get('code');
            profil = (String) CodeItem.get('idProfile');
            engagement = (String) CodeItem.get('engagement');
            
            if (tempCodeOffre.equals('TERMINAL')) {
                codeOffre = 'INWIB2C_OFFERING_TERMINAL';
            } else {
                codeOffre = tempCodeOffre;
            }
        }
        

        System.debug('codeOffre' +codeOffre);
        System.debug('profil' +profil);
        System.debug('engagement' +engagement);
        productCodes.add(codeOffre);

        if (codeOffre =='INWIB2C_OFFERING_49DH_INTERNET' || codeOffre =='INWIB2C_OFFERING_199DH_INTERNET'|| codeOffre =='INWIB2C_OFFERING_99DH_APL' || codeOffre =='INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre =='INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre =='INWIB2C_OFFERING_149DH_APL' || codeOffre =='INWIB2C_OFFERING_99DH_ILLIMITE_RS'|| codeOffre =='INWIB2C_OFFERING_149DH_INTERNET'|| codeOffre =='INWIB2C_OFFERING_49DH_ILLINWI_APL'|| codeOffre =='INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite'|| codeOffre =='INWIB2C_OFFERING_499DH_TOUT'|| codeOffre =='INWIB2C_OFFERING_199DH_APL' || codeOffre =='INWIB2C_OFFERING_249DH_TOUT'|| codeOffre =='INWIB2C_OFFERING_99DH_ILLINWI_APL' ) {

            offerType='Mobile Postpayé';
        }else {
            if (codeOffre =='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TERMINAL' ) {
                offerType='Mobile Prépayé';
            } else {
                if(codeOffre =='INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre =='INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre =='INWIB2C_OFFERING_FORMULE3_349DH') {
                    offerType='Home Postpayé';
                }
                
                
            }
            
        }
        
        System.debug('type de l offre' +offerType);

        if (codeOffre =='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' || codeOffre =='INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL') {
            productCodes.add('INWIB2C_OFFERING_OPT_ROAMING');
        }
// Variables to store the prices
   Decimal fmsPrice=0;
   Decimal fmdPrice;
   Decimal terminalPrice=0;
if (codeOffre!='INWIB2C_OFFERING_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL') {
    List<Object> additionalPayments = (List<Object>) product.get('aditionalPayments');

// Extract the prices
for (Object paymentObj : additionalPayments) {
    Map<String, Object> payment = (Map<String, Object>) paymentObj;
    String paymentType = (String) payment.get('type');
    String paymentPrice = (String) payment.get('price');

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

        Account acc = [select Id,ParentId from account where inwiB2C_TypePartenaire__c =:'inwiB2C_Agence' AND inwib2c_CodePartenaire__c = :'CMS23'];
        inwib2c_OrderTemplateEshop__mdt Obj = [select OrderId__c, CodeProduct__c from inwib2c_OrderTemplateEshop__mdt where  CodeProduct__c= :codeOffre];
        System.debug('metadata' +Obj);
        //Get the Original order 
        List<Order> OrderOriginal= [SELECT Pricebook2Id, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, AccountId, status, EffectiveDate,inwib2c_ModeDeLivraison__c, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,InwiB2C_Offre__c,vlocity_cmt__DefaultBillingAccountId__c,inwib2c_CodeDeTransaction__c from order where id = :Obj.OrderId__c limit 1];
                
       
       //boucler sur les sous produit:
       if (codeOffre!='INWIB2C_OFFERING_TERMINAL'){
        List<Object> subProducts = (List<Object>) product.get('subProducts');


        for (Object subProductObj : subProducts){
            Map <String, Object> subProduct = (Map <String, Object>) subProductObj;

            List<string> codeattribute = new List<String>();
           

            String productCode = (String) subProduct.get('code');
            String productType = (String) subProduct.get('type');
           // productCodes.add(productCode);

            

            Map<String, Object> subProductPrice = (Map<String, Object>) subProduct.get('price');
            String subProductPriceType = (String) subProductPrice.get('type');
            String subProductPriceAmount = (String) subProductPrice.get('amount');
    
            // if (productCode.equals('INWIB2C_MOB02_OFFERING_TERMINAL')) {
            //     terminalPrice = Decimal.valueOf(subProductPriceAmount);
            // }

            // Modify productCode if it meets the conditions
    if (productCode == 'TERMINAL') {
        // if (codeOffre == 'INWIB2C_OFFERING_49DH_INTERNET' || 
        //     codeOffre == 'INWIB2C_OFFERING_199DH_INTERNET' || 
        //     codeOffre == 'INWIB2C_OFFERING_99DH_APL' || 
        //     codeOffre == 'INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || 
        //     codeOffre == 'INWIB2C_OFFERING_49DH_ILLIMITE_RS' || 
        //     codeOffre == 'INWIB2C_OFFERING_149DH_APL' || 
        //     codeOffre == 'INWIB2C_OFFERING_99DH_ILLIMITE_RS' || 
        //     codeOffre == 'INWIB2C_OFFERING_149DH_INTERNET' || 
        //     codeOffre == 'INWIB2C_OFFERING_49DH_ILLINWI_APL' || 
        //     codeOffre == 'INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || 
        //     codeOffre == 'INWIB2C_OFFERING_499DH_TOUT' || 
        //     codeOffre == 'INWIB2C_OFFERING_199DH_APL' || 
        //     codeOffre == 'INWIB2C_OFFERING_249DH_TOUT' || 
        //     codeOffre == 'INWIB2C_OFFERING_99DH_ILLINWI_APL'
        // )
     
        if (codeOffre == 'INWIB2C_OFFERING_49DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_199DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_99DH_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_1H25GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_APL' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLIMITE_RS' || codeOffre == 'INWIB2C_OFFERING_149DH_INTERNET' || codeOffre == 'INWIB2C_OFFERING_49DH_ILLINWI_APL' || codeOffre == 'INWIB2C_OFFERING_FORFAIT_5H18GoWhatsAppIllimite' || codeOffre == 'INWIB2C_OFFERING_499DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_199DH_APL' || codeOffre == 'INWIB2C_OFFERING_249DH_TOUT' || codeOffre == 'INWIB2C_OFFERING_99DH_ILLINWI_APL') {
            productCode = 'INWIB2C_MOB02_OFFERING_TERMINAL';
            codedeProduit = 'INWIB2C_MOB02_OFFERING_TERMINAL';
        }
        
        
        else if (codeOffre == 'INWIB2C_OFFERING_FORMULE1_199DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE2_249DH' || codeOffre == 'INWIB2C_OFFERING_FORMULE3_349DH') {
            productCode = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
            codedeProduit = 'INWIB2C_OPB2C_OFFERING_TERMINAL';
        } else if (codeOffre == 'INWIB2C_OFFERING_TICTAC_AVEC_TERMINAL' ||codeOffre =='INWIB2C_OFFERING_TERMINAL') {
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
                 }
                

         
        }
    }
   

    if (codeOffre=='INWIB2C_OFFERING_TERMINAL'){
        //List<Object> subProducts = (List<Object>) product.get('subProducts');
        Map<String, Object> subProductPrice = (Map<String, Object>) product.get('price');
            String subProductPriceType = (String) subProductPrice.get('type');
            String subProductPriceAmount = (String) subProductPrice.get('amount');
            terminalPrice = Decimal.valueOf(subProductPriceAmount);
    }

    system.debug('la listes des codes:' +productCodes);
    system.debug('le Prix de terminal:' +terminalPrice); 
    System.debug('le Code produit est' +codedeProduit);

     //Clone order from the  OrderBase
     Order newOrder =  OrderOriginal[0].clone(false, true, false, true);

     newOrder.EffectiveDate = date.today();
     newOrder.AccountId = customerId;
     newOrder.InwiB2C_Type_Offer__c = offerType;
     newOrder.inwib2c_Partenaire__c = acc.Id;
     newOrder.inwib2c_Distributeur__c = acc.ParentId;
     newOrder.inwib2c_ModeDePaiement__c = modepayement;
     if (fmsPrice>0) {
         newOrder.InwiB2C_Mode_de_paiement_FMS__c = modepayement; 
         
     }
     if (fmdPrice>0) {
         newOrder.Mode_de_paiement_FMD__c = modepayement; 
         
     }
     newOrder.inwiB2C_Canal__c= canal;
     newOrder.inwib2c_ModeDeLivraison__c = typelivraison;
     //newOrder.inwib2c_CodeDeTransaction__c = paymentReference;
     newOrder.inwib2c_AgenceDeLivraison__c =agenceId;
     newOrder.InwiB2C_code_de_transaction_Eshop__c=paymentReference;
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
     

     if (codeOffre!='INWIB2C_OFFERING_TERMINAL'){
         newOrder.vlocity_cmt__DefaultBillingAccountId__c = buyerId;
     }
   

     insert newOrder;

     System.debug('NewOrderId' +newOrder.Id);

    
     InwiB2C_Trace_API__c traceObj = [select id, InwiB2C_Object_Number__c, InwiB2C_request_body__c,InwiB2C_Response__c  from InwiB2C_Trace_API__c where id = :traceId];
       // Modify the field value
         traceObj.InwiB2C_Object_Number__c = newOrder.Id;

           // Update the record in the database
           update traceObj;
       
        

        List<String> productItemId = new List<String>();
        //clonerOrderItem

        List<OrderItem> NewOrderItems= new List<OrderItem>(); 
        List<OrderItem> OrderItemsWhereParentNotNull =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :Obj.OrderId__c AND vlocity_cmt__ParentItemId__c !=null  limit 20];
        for (OrderItem orderItem : OrderItemsWhereParentNotNull) {
            productItemId.add(orderItem.Product2Id);
        }

        system.debug('Id des Product2: ' +  productItemId);
        List<OrderItem> OrderItemsFromOrderBase =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :Obj.OrderId__c  limit 20];
            
        Map<String,String> ProductCodeByItemIdMap= new Map<String,String>();
        for (OrderItem Item :OrderItemsFromOrderBase){

            ProductCodeByItemIdMap.put(item.id, item.Product2Id);

        }

        for (OrderItem Item :OrderItemsFromOrderBase)
        {
            OrderItem newOrderItem; // = new OrderItem();
            String parentProductId = ProductCodeByItemIdMap.get(Item.vlocity_cmt__ParentItemId__c);
            system.debug('Id de Produit Parent: ' +  parentProductId);
            system.debug('Id de Produit Parent2: ' +  item.Product2Id);
            vlocity_cmt__ProductChildItem__c childItemDef = new vlocity_cmt__ProductChildItem__c();
            if (parentProductId != null){
                 childItemDef = [select vlocity_cmt__MinQuantity__c from vlocity_cmt__ProductChildItem__c where vlocity_cmt__ParentProductId__c = :parentProductId and vlocity_cmt__ChildProductId__c  = :Item.Product2Id limit 1];
            }
        
            //vlocity_cmt__ProductChildItem__c childItemDef = [SELECT vlocity_cmt__MinQuantity__c FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c = :parentProductId AND vlocity_cmt__ChildProductId__c IN:productItemId LIMIT 1];

            if (Item.vlocity_cmt__ParentItemId__c == null ||  (parentProductId != null && childItemDef.vlocity_cmt__MinQuantity__c == 1) || productCodes.contains(Item.Product2.ProductCode)){
                newOrderItem = Item.clone(false, true, false, true);
                newOrderItem.OrderId = newOrder.Id;
                newOrderItem.vlocity_cmt__AssetReferenceId__c = null;
                newOrderItem.vlocity_cmt__ServiceAccountId__c = customerId;
                if (codeOffre!='INWIB2C_OFFERING_TERMINAL'){
                    newOrderItem.vlocity_cmt__BillingAccountId__c = buyerId;
                }
                //newOrderItem.vlocity_cmt__OneTimeCharge__c = terminalPrice;
                NewOrderItems.add(newOrderItem);
                system.debug('ORDER ITEM : ' + newOrder.Id);
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
            NewOrderItem.vlocity_cmt__RootItemId__c = OrderItemParentId;
            UpdatedOrderItems.add(newOrderItem);
        }
        update UpdatedOrderItems;


    OrderItem ParentItem = [select id, Product2.ProductCode, Product2.Name,InwiB2C_FMS__c, InwiB2C_FMD__c, inwib2c_TransactionCode__c,  vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId = :newOrder.Id AND vlocity_cmt__ParentItemId__c =null];


             ParentItem.InwiB2C_FMS__c=fmsPrice;
             ParentItem.InwiB2C_FMD__c=fmdPrice;
             if (paymentReference!=null && fmsPrice>0 ) {
                ParentItem.inwiB2C_TransactionCode_FMS__c=paymentReference;
                
            }
            // if (paymentReference!=null && fmdPrice>0) {
            //     ParentItem.InwiB2C_TransactionCode_FMD__c=paymentReference;
                
            // }
            
            // if (paymentReference!=null && (codeOffre=='INWIB2C_OFFERING_TERMINAL' || codedeProduit == 'INWIB2C_OFFERING_TERMINAL'|| codedeProduit == 'INWIB2C_MOB02_OFFERING_TERMINAL'|| codedeProduit == 'INWIB2C_OPB2C_OFFERING_TERMINAL')) {
            //     ParentItem.inwib2c_TransactionCode__c=paymentReference;
                
            // }

             if (typedeProduit=='Handset') {

             ParentItem.vlocity_cmt__OneTimeTotal__c = terminalPrice;
             ParentItem.vlocity_cmt__EffectiveOneTimeTotal__c = terminalPrice;
             }
             //ParentItem.inwib2c_TransactionCode__c=paymentReference;
             update ParentItem;


              if (typedeProduit=='Handset' || codeOffre=='INWIB2C_OFFERING_TERMINAL') {
            
               OrderItem TerminalItem = [select id, Product2.ProductCode, Product2.Name,InwiB2C_FMS__c, InwiB2C_FMD__c, inwib2c_TransactionCode__c,  vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId = :newOrder.Id AND Product2.Name='Terminal' ];
            //   TerminalItem.inwib2c_TransactionCode__c=paymentReference;
               TerminalItem.vlocity_cmt__OneTimeCharge__c = terminalPrice;
               TerminalItem.vlocity_cmt__OneTimeTotal__c = terminalPrice;
               TerminalItem.vlocity_cmt__OneTimeCalculatedPrice__c = terminalPrice;

               update TerminalItem;
            }

              if (codeOffre!='INWIB2C_OFFERING_TERMINAL'&& codeOffre!='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' && codeOffre!='INWIB2C_OFFERING_TICTAC_SANS_TERMINAL') {
               OrderItem OptionsItem = [select id, Product2.ProductCode, Product2.Name,InwiB2C_FMS__c, InwiB2C_FMD__c, inwib2c_TransactionCode__c,  vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId = :newOrder.Id AND Product2.Name='Options' ];
         
               OptionsItem.vlocity_cmt__OneTimeTotal__c = terminalPrice;
               update OptionsItem;
            
                 }
               inwiB2C_eShopUpdateAttributes.updateAttributes(traceId);


         Map<String, Object> result = new Map<String, Object>();

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
        update traceObj;
       
        return result;
    
    }


}