@isTest
public class InwiB2C_ResiliateRequestBatchTest {
@isTest(SeeAllData=true)
        public static void InwiB2C_ResiliateRequestBatchTest() {
            //List<vlocity_cmt__Subscription__c> subsc = [ SELECT Id From vlocity_cmt__Subscription__c  limit 1];
            //system.debug('testid'+subsc[0].Id);
            vlocity_cmt__Subscription__c subsc = new vlocity_cmt__Subscription__c ();
            subsc.Inwib2c_Num_ro_de_la_ligne__c = '212647858612';
            subsc.vlocity_cmt__SubscriptionNumber__c = '02i8M000000BIcZQAW';
            subsc.inwib2c_vip__c = false;
            subsc.inwiB2C_OptionIdentification__c = false;
            subsc.inwiB2C_managedInSF__c = true;
            subsc.InwiB2C_A_r_silier__c = false;
            subsc.Blacklist__c = false;
            insert subsc;
            InwiB2C_Demande_de_resiliation__c lstRequest= new InwiB2C_Demande_de_resiliation__c();            
            lstRequest.InwiB2C_Statut_Resil__c ='En attente de résiliation';
            lstRequest.InwiB2C_Date_de_signature__c = Date.valueOf('2022-04-13');
            lstRequest.inwiB2C_expectedDisconnectDate__c=Date.valueOf('2022-04-13');
            lstRequest.InwiB2C_Subscription__c = subsc.Id;            
            insert lstRequest;
            vlocity_cmt__Subscription__c subsc2 = new vlocity_cmt__Subscription__c ();
            subsc2.Inwib2c_Num_ro_de_la_ligne__c = '212647858600';
            subsc2.vlocity_cmt__SubscriptionNumber__c = '02i8M000000BIcZQAQ';
            subsc2.inwib2c_vip__c = false;
            subsc2.inwiB2C_OptionIdentification__c = false;
            subsc2.inwiB2C_managedInSF__c = true;
            subsc2.InwiB2C_A_r_silier__c = false;
            subsc2.Blacklist__c = false;
            insert subsc2;
            InwiB2C_Demande_de_resiliation__c lstRequest2= new InwiB2C_Demande_de_resiliation__c();            
            lstRequest2.InwiB2C_Statut_Resil__c ='En attente de suspension';
            lstRequest2.InwiB2C_Date_de_signature__c = Date.valueOf('2022-04-13');
            lstRequest2.inwiB2C_expectedSuspendDate__c=Date.valueOf('2022-04-13');
            lstRequest2.InwiB2C_Subscription__c = subsc2.Id; 
            insert lstRequest2;

			


            Test.startTest();   
            InwiB2C_ResiliateRequestBatch obj = new InwiB2C_ResiliateRequestBatch();
                    Id bacthId = Database.executeBatch(new InwiB2C_ResiliateRequestBatch() , 2000 );

            DataBase.executeBatch(obj);                
            Test.stopTest();
            //system.assertEquals('Warm', leads.Rating);
        
    }
}