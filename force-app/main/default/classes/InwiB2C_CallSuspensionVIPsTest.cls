@isTest
public class InwiB2C_CallSuspensionVIPsTest {

    @isTest(SeeAllData=true)
        public static void InwiB2C_CallSuspensionVIPsTest() {
       
        Test.startTest(); 
              //Insert Subscription
        vlocity_cmt__Subscription__c Sub = new vlocity_cmt__Subscription__c(); 
        Sub.inwiB2C_Statut__c = 'InwiB2C_Active';
        Sub.vlocity_cmt__SubscriptionNumber__c = '02i7M000000BIaRQAW';
        Sub.inwib2c_vip__c = false;
        Sub.inwiB2C_OptionIdentification__c = false;
        Sub.inwiB2C_managedInSF__c = true;
        Sub.InwiB2C_A_r_silier__c = false;
        Sub.Blacklist__c = false;
        insert Sub;
            system.debug('Sub'+Sub.Id);
        // Insert Action
        InwiB2C_Demande_de_resiliation__c lstRequest= new InwiB2C_Demande_de_resiliation__c();            
            lstRequest.InwiB2C_Statut_Resil__c ='En attente de suspension';
            lstRequest.InwiB2C_Date_de_signature__c = Date.valueOf('2022-04-13');
            lstRequest.InwiB2C_Subscription__c = Sub.Id;            
            insert lstRequest;
             List<InwiB2C_Demande_de_resiliation__c> ListRequestToInsert = new  List<InwiB2C_Demande_de_resiliation__c>();
            ListRequestToInsert.add(lstRequest);
           
            List<String> Ids = new List <String>();   
            for(InwiB2C_Demande_de_resiliation__c Req: ListRequestToInsert){
                Ids.Add(Req.Id);
            }
          
            InwiB2C_CallSuspensionVIPs.CallVIP(lstRequest.Id,Sub.Id);
            Test.stopTest();
    }
}