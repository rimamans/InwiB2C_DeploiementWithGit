@isTest
public class InwiB2C_UpdateRecordFromObjectTest {
   public static testMethod void testUpdateRecord() {
        Test.StartTest(); 
                     InwiB2C_Demande__c demandes = new InwiB2C_Demande__c();
                     demandes.Type_de_modification__c='Remboursement suite Refus Porta';
                     insert demandes;

      ApexPages.StandardController sc = new ApexPages.StandardController(demandes);
        InwiB2C_UpdateRecordFromObject testAccPlan = new InwiB2C_UpdateRecordFromObject(sc);
        
        PageReference pageRefPartner;
        pageRefPartner = new PageReference('/' + demandes.id +'/e'); 
        pageRefPartner.getParameters().put('nooverride', '1');
        pageRefPartner.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
        pageRefPartner.getParameters().put('id', demandes.id);
        Test.setCurrentPage(pageRefPartner);
        testAccPlan.getRedir();
        

        
        PageReference pageRefConsumer = Page.InwiB2C_UpdateRecordFromObject; 
        pageRefConsumer.getParameters().put('id', demandes.id);
        Test.setCurrentPage(pageRefConsumer);
        testAccPlan.getRedir();
        Test.StopTest();
    }
    
    
       
}