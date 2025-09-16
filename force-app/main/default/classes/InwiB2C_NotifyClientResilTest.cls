@isTest
public class InwiB2C_NotifyClientResilTest {
@isTest(SeeAllData=true)
        public static void InwiB2C_NotifyClientResilTest() {
            Date myDateToday = system.today();
            //List<vlocity_cmt__Subscription__c> subsc = [ SELECT Id,Inwib2c_Num_ro_de_la_ligne__c From vlocity_cmt__Subscription__c  limit 1];
            //system.debug('testid'+subsc[0].Id);
            vlocity_cmt__Subscription__c subsc = new vlocity_cmt__Subscription__c ();
            subsc.Inwib2c_Num_ro_de_la_ligne__c = '212647858612';
            subsc.vlocity_cmt__SubscriptionNumber__c = '02i8M000000BIbRQAW';
            subsc.inwib2c_vip__c = false;
            subsc.inwiB2C_OptionIdentification__c = false;
            subsc.inwiB2C_managedInSF__c = true;
            subsc.InwiB2C_A_r_silier__c = false;
            subsc.Blacklist__c = false;
            insert subsc;

            InwiB2C_Demande_de_resiliation__c lstRequest= new InwiB2C_Demande_de_resiliation__c();            
            lstRequest.InwiB2C_Statut_Resil__c ='En attente de résiliation';
            lstRequest.InwiB2C_Date_de_signature__c = myDateToday.adddays(-23);
            lstRequest.InwiB2C_Subscription__c = subsc.Id;   
            lstRequest.inwiB2C_num_Ligne__c   = subsc.Inwib2c_Num_ro_de_la_ligne__c; 
            lstRequest.x_NumberDaysResilNotif__c  = 7; 
            insert lstRequest;    
	
            
            Test.startTest();   
            InwiB2C_NotifyClientBeforeResiliation obj = new InwiB2C_NotifyClientBeforeResiliation();
            DataBase.executeBatch(obj);                
            Test.stopTest();
            //system.assertEquals('Warm', leads.Rating);
        
    }
}