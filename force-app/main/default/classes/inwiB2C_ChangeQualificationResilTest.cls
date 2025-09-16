@isTest(SeeAllData=true)
public class inwiB2C_ChangeQualificationResilTest {
@isTest(SeeAllData = true)
    //public static void inwiB2C_ChangeQualificationResilTest(){
        static void inwiB2C_ChangeQualificationResilTest()
	{
		
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
        test.startTest();
		
			ApexPages.StandardController  sc = new ApexPages.StandardController(lstRequest);
			inwiB2C_ChangeQualificationResil  testResilPlan = new inwiB2C_ChangeQualificationResil(sc);
			testResilPlan.submit();
      testResilPlan.close();
			
		test.stopTest();
    }
 /*    static void close()
	{
            List<InwiB2C_Demande_de_resiliation__c> resil = new List<InwiB2C_Demande_de_resiliation__c>();
    
        test.startTest();
		
			ApexPages.StandardController sc = new ApexPages.StandardController(new InwiB2C_Demande_de_resiliation__c(name ='Test Account'));
			inwiB2C_ChangeQualificationResil  testAccPlan = new inwiB2C_ChangeQualificationResil(sc);
			testAccPlan.close();
			
		test.stopTest();
    }*/
    
}