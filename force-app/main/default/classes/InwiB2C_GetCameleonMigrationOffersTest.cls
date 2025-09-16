@IsTest
public class InwiB2C_GetCameleonMigrationOffersTest {
    @isTest(SeeAllData=false)
     static void getOfferTest(){
        INWIB2C_FRAIS_MGR_CML__c migOffre = new INWIB2C_FRAIS_MGR_CML__c(INWIB2C_OFFRE_DESTINATION__c='INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEWTSP',INWIB2C_OFFRE_SOURCE__c='INWIB2C_OFFERING_CAM_FORFAIT30J49RS',INWIB2C_PRIX_MIGRATION__c=50,InwiB2C_Profil_destination__c='86934');
        insert migOffre;
        Product2 prod = new Product2(Name = 'Product',ProductCode='INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEWTSP',vlocity_cmt__Type__c= 'Postpaye');
        insert prod;    
        Id pricebookId = Test.getStandardPricebookId();    
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        String DRJson='{"offreCode":"INWIB2C_OFFERING_CAM_FORFAIT30J49RS","userProfile":"Inwi POS"}';
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
    	Map<String,Object> output = new Map<String,Object>();
    	Map<String,Object> options = new Map<String,Object>();
        Test.startTest();
    	InwiB2C_GetCameleonMigrationOffers.invokeMethod('getOffres',input,output,options);
        Test.stopTest();
    }
    
    
     @isTest(SeeAllData=false)
     static void getOfferPayedinvoiceTest(){
        INWIB2C_FRAIS_MGR_CML__c migOffre = new INWIB2C_FRAIS_MGR_CML__c(INWIB2C_OFFRE_DESTINATION__c='INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEWTSP',INWIB2C_OFFRE_SOURCE__c='INWIB2C_OFFERING_CAM_FORFAIT30J49RS',INWIB2C_PRIX_MIGRATION__c=50,InwiB2C_Profil_destination__c='86934');
        insert migOffre;
        Product2 prod = new Product2(Name = 'Product',ProductCode='INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEWTSP',vlocity_cmt__Type__c= 'Postpaye');
        insert prod;    
        Id pricebookId = Test.getStandardPricebookId();    
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        String DRJson='{"offreCode":"INWIB2C_OFFERING_CAM_FORFAIT30J49RS","userProfile":"Admin", "nmbPayedInvoices":3,"hasPermissionSetFlexi":"true"}';
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
    	Map<String,Object> output = new Map<String,Object>();
    	Map<String,Object> options = new Map<String,Object>();
        Test.startTest();
    	InwiB2C_GetCameleonMigrationOffers.invokeMethod('getOffres',input,output,options);
        Test.stopTest();
    }
    
    
    @isTest(SeeAllData=false)
     static void getOfferMigrationWithFeesTest(){
        INWIB2C_FRAIS_MGR_CML__c migOffre = new INWIB2C_FRAIS_MGR_CML__c(INWIB2C_OFFRE_DESTINATION__c='INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEWTSP',INWIB2C_OFFRE_SOURCE__c='INWIB2C_OFFERING_CAM_FORFAIT30J49RS',INWIB2C_PRIX_MIGRATION__c=50,InwiB2C_Profil_destination__c='86934');
        insert migOffre;
        Product2 prod = new Product2(Name = 'Product',ProductCode='INWIB2C_OFFERING_CAM_FORFAIT30J99DHILLIMITEWTSP',vlocity_cmt__Type__c= 'Postpaye');
        insert prod;    
        Id pricebookId = Test.getStandardPricebookId();    
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        String DRJson='{"offreCode":"INWIB2C_OFFERING_CAM_FORFAIT30J49RS","userProfile":"Admin", "nmbPayedInvoices":1,"hasPermissionSetFlexi":"true"}';
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
    	Map<String,Object> output = new Map<String,Object>();
    	Map<String,Object> options = new Map<String,Object>();
        Test.startTest();
    	InwiB2C_GetCameleonMigrationOffers.invokeMethod('getOffres',input,output,options);
        Test.stopTest();
    }

}