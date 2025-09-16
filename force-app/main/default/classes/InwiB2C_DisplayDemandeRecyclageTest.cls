@isTest
public class InwiB2C_DisplayDemandeRecyclageTest {
		@isTest
   	    static void testGetOrderDRs(){
             Account testAccount = new Account();
            testAccount.Name='Test Account';
            insert testAccount;
            order testCommande = new Order ( inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        insert testCommande;
            InwiB2C_Demande_de_recyclage_FTTH__c demande =new InwiB2C_Demande_de_recyclage_FTTH__c();
            demande.InwiB2C_ND__c = '123';
            demande.InwiB2C_work_order_Id__c='198';
        insert demande;
            Test.startTest();
        List<InwiB2C_Demande_de_recyclage_FTTH__c> result = InwiB2C_DisplayDemandeRecyclage.getOrderDRs(testCommande.Id);
        Test.stopTest();
    }
}