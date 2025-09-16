/*ILA INWIB2C-PHASE2 12.05.2021 BEGIN*/
@isTest
public class INWIB2C_DeactivateSubscriptionTest {

    
    @testSetup
    static void dataSetup() {
        Account client = new Account(Name='acc');
        insert client;
        vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c = '212658498300',vlocity_cmt__SubscriptionNumber__c='999',
                                                                             Inwib2c_Offre__c = 'Pack Box Huawei B310S 4G + 20 Go',inwiB2C_LegacyStatus__c='ACTIVE');
        //ligne.Inwib2c_Offre__c == 'Offre TicTac Sim+Terminal';
        vlocity_cmt__Subscription__c ligne2 = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c = '888',vlocity_cmt__SubscriptionNumber__c='999',
                                                                             Inwib2c_Offre__c ='offre postpayé',inwiB2C_LegacyStatus__c='ACTIVE');
        Database.insert(ligne,false);
        Database.insert(ligne2,false);
        Asset asset=new Asset(Name='asset',AccountId=client.Id,vlocity_cmt__SubscriptionId__c=ligne.Id);
        insert asset;
        Asset asset11=new Asset(Name='asset11',AccountId=client.Id,vlocity_cmt__ParentItemId__c=asset.Id);
        Asset asset2=new Asset(Name='asset2',AccountId=client.Id,vlocity_cmt__SubscriptionId__c=ligne2.Id);
        insert asset2;
        Asset asset21=new Asset(Name='asset21',AccountId=client.Id,vlocity_cmt__ParentItemId__c=asset.Id);
        insert asset11;
        insert asset21;
         

    }
    static testMethod void testPut() {
        dataSetup();
       // INWIB2C_DeactivateSubscription.isPrepayed=true;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody =Blob.valueof('{"CSDeactivateSub": {"mdn": "212658498300"},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}');
        req.requestURI = '/services/apexrest/Subscription/DeactivateSubscription/';
        req.httpMethod = 'Put';
        RestContext.request =req; 
        RestContext.response= res;
        INWIB2C_DeactivateSubscription.deactivateSubscription();
    }
    static testMethod void testPut1() {
        dataSetup();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
       req.requestBody =Blob.valueof('{"CSDeactivateSub": {"mdn": "888"},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}');
        req.requestURI = '/services/apexrest/Subscription/DeactivateSubscription/';
        req.httpMethod = 'Put';
        RestContext.request =req; 
        RestContext.response= res;
        INWIB2C_DeactivateSubscription.deactivateSubscription();
    }
    static testMethod void testPut2() {
        dataSetup();
        //INWIB2C_DeactivateSubscription.isPrepayed=true;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody =Blob.valueof('{"CSDeactivateSub": {"mdn": "123"},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}');
        req.requestURI = '/services/apexrest/Subscription/DeactivateSubscription/';
        req.httpMethod = 'Put';
        RestContext.request =req; 
        RestContext.response= res;
        INWIB2C_DeactivateSubscription.deactivateSubscription();
    }
     static testMethod void testPut4() {
        dataSetup();
        //INWIB2C_DeactivateSubscription.isPrepayed=true;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody =Blob.valueof('{"CSDeactivateSub": {"md": ""},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}');
        req.requestURI = '/services/apexrest/Subscription/DeactivateSubscription/';
        req.httpMethod = 'Put';
        RestContext.request =req; 
        RestContext.response= res;
        INWIB2C_DeactivateSubscription.deactivateSubscription();
    }
    static testMethod void testPut3() {
        dataSetup();
        //INWIB2C_DeactivateSubscription.isPrepayed=true;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody =Blob.valueof('{"CSDeactivateSub":},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}');
        req.requestURI = '/services/apexrest/Subscription/DeactivateSubscription/';
        req.httpMethod = 'Put';
        RestContext.request =req; 
        RestContext.response= res;
        INWIB2C_DeactivateSubscription.deactivateSubscription();
    }static testMethod void testPut5() {
        dataSetup();
       // INWIB2C_DeactivateSubscription.isPrepayed=true;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody =Blob.valueof('{"CSDeactivateSub": {"mdn": "212658498300","action":"SUSF"},"CSOperationInfo": {"user" : "imane","channel" : "Legacy","uuid": "123"}}');
        req.requestURI = '/services/apexrest/Subscription/DeactivateSubscription/';
        req.httpMethod = 'Put';
        RestContext.request =req; 
        RestContext.response= res;
        INWIB2C_DeactivateSubscription.deactivateSubscription();
    }
    
}
/*ILA INWIB2C-PHASE2 12.05.2021 END*/