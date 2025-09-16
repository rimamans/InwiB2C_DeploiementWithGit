public with sharing class inwiB2C_HandleMigrPrePost {
    public Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        if (methodName.equals('createOrder')) {
            createOrder((String) inputMap.get('panierId'));
        }
        return true;
    }
    public void createOrder(String panierId) {
        inwib2c_TraceDemandeEshop__c panier = [ select inwib2c_Request_body__c, inwib2c_Statut__c, inwib2c_OrderId__c,  id from inwib2c_TraceDemandeEshop__c where Id = :panierId ];
        List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(panier.inwib2c_Request_body__c);
        Map<String,Object> jsonMap = (Map<String,Object>) jsonList[0];
        Map<String,Object> smo = (Map<String,Object>)jsonMap.get('CSCreateSMO');
        String mdn = (String)smo.get('mdn');
        vlocity_cmt__Subscription__c subs = [ select id, vlocity_cmt__BillingAccountId__c, vlocity_cmt__AccountId__c from vlocity_cmt__Subscription__c where Inwib2c_Num_ro_de_la_ligne__c = :mdn ];
        String customerId = subs.vlocity_cmt__AccountId__c;
        String buyerId = subs.vlocity_cmt__BillingAccountId__c;
        String offre = (String)smo.get('codeOffre');
        Product2 product = [ select Id, ProductCode, vlocity_cmt__Type__c from Product2 where Name = :offre ];
        String codeOffre = product.ProductCode;
        inwib2c_OrderTemplateEshop__mdt Obj = [select OrderId__c, CodeProduct__c from inwib2c_OrderTemplateEshop__mdt where  CodeProduct__c= :codeOffre];
        Order OrderOriginal= [select Pricebook2Id, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, AccountId, status, EffectiveDate,inwib2c_ModeDeLivraison__c, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,InwiB2C_Offre__c,vlocity_cmt__DefaultBillingAccountId__c,inwib2c_CodeDeTransaction__c from order where id = :Obj.OrderId__c limit 1];
        Order newOrder =  OrderOriginal.clone(false, true, false, true);
        newOrder.EffectiveDate = date.today();
        newOrder.AccountId = customerId;
        newOrder.vlocity_cmt__DefaultBillingAccountId__c = buyerId;
        newOrder.InwiB2C_Type_Offer__c = product.vlocity_cmt__Type__c;
        newOrder.inwiB2C_Canal__c='InwiB2C_MyInwi';
        newOrder.inwib2c_TypeDeLaCommande__c='inwiB2C_Migration';
        newOrder.inwiB2C_TypeDeMigration__c='InwiB2C_MigrationPrePostpayé';
        newOrder.inwiB2C_Statut__c='inwiB2C_Activation';

        insert newOrder;

        panier.inwib2c_Statut__c='InwiB2C_Terminer';
        panier.inwib2c_OrderId__c = newOrder.Id;

        update panier;
        
        Map<String, Object> inputParams = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        PricebookEntry prodItem = [ select Id, Name from PricebookEntry where Product2Id = :product.Id ];
        Map<String,Object> item = new Map<String,Object>();
        item.put('itemId',prodItem.Id);
        List<Object> items = new List<Object>();
        items.add(item);
        
        inputParams.put('items', items);
        inputParams.put('cartId', newOrder.Id);
        inputParams.put('noResponseNeeded', true);
                        
        vlocity_cmt.CpqAppHandler app = new vlocity_cmt.CpqAppHandler();
        app.invokeMethod('postCartsItems', inputParams, outputMap, optionsMap);
        System.debug('OrderId '+ newOrder.Id);

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        input.put('OrderId', newOrder.Id);
        input.put('SubcriptionId', subs.Id);
        output = (Map < String, Object > ) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_OrderItem', input, options);

    }
}