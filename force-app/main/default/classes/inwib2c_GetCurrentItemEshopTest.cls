@isTest
 
 public  class inwib2c_GetCurrentItemEshopTest {
    @isTest(SeeAllData=true)
     public static void inwib2c_GetCurrentItemEshopTest() {
        inwib2c_GetCurrentItemEshop cls = new inwib2c_GetCurrentItemEshop();
        String inputJson = '{"offreStart":"Forfait 4H + 44Go","bodyCart":{"totalSize":1,"messages":[],"records":[{"Name":"Forfait 1H + 11Go","Pricebook2Id":"01s4K000001FA2rQAG","Product2Id":"01t4K000001eYryQAE","ProductCode":"INWIB2C_OFFERING_49DH_INTERNET","Product2":{"attributes":{"type":"Product2","url":"/services/data/v58.0/sobjects/Product2/01t4K000001eYryQAE"},"InwiB2C_Type_offre__c":"GSM","Name":"Forfait 1H + 11Go","vlocity_cmt__SpecificationType__c":"Offer","vlocity_cmt__Type__c":"Postpaye","Id":"01t4K000001eYryQAE","vlocity_cmt__JSONAttribute__c":null},"name":"Forfait 1H + 11Go"}]}}';


        Map<String,Object> bodyjson =  (Map<String, Object>)JSON.deserializeUntyped(inputJson);
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        cls.invokeMethod('get_CurrentItem', bodyjson, outMap, options);
    
    
  
    }
}