@isTest
public class InwiB2C_DemandeRecyclageFTTHManageTest {
    
    @isTest
    static void testInvokeMethodSearchDemandeRecyclage() {
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        Order testCommande = new Order(
            inwiB2C_Statut__c = 'inwiB2C_EnCours', 
            EffectiveDate = Date.today().addDays(-1), 
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', 
            Status = 'Draft', 
            AccountId = testAccount.Id,
            InwiB2C_Type_Offer__c = 'FTTH'
        );
        insert testCommande;
        
        InwiB2C_Demande_de_recyclage_FTTH__c demande1 = new InwiB2C_Demande_de_recyclage_FTTH__c();
        demande1.InwiB2C_Statut__c = 'A recycler';
        demande1.InwiB2C_Motif_d_chec_de_raccordement__c = 'Hors plaque'; 
        demande1.InwiB2C_commande__c = testCommande.Id;
        demande1.InwiB2C_client__c = testAccount.Id;
        insert demande1;

        InwiB2C_Demande_de_recyclage_FTTH__c demande2 = new InwiB2C_Demande_de_recyclage_FTTH__c();
        demande2.InwiB2C_Statut__c = 'recyclée';
        demande2.InwiB2C_Motif_d_chec_de_raccordement__c = 'Hors plaque';
        demande2.InwiB2C_commande__c = testCommande.Id;
        demande2.InwiB2C_client__c = testAccount.Id;
        insert demande2;

        Test.startTest(); 
        
        Map<String, Object> inputMap = new Map<String, Object>(); 
        inputMap.put('InwiB2C_Statut__c', 'A recycler');  
        Map<String, Object> outputMap = new Map<String, Object>(); 
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        Boolean result = InwiB2C_DemandeRecyclageFTTHManagement.invokeMethod(
            'searchDemandeRecyclage', 
            inputMap, 
            outputMap, 
            optionsMap
        );
        Test.stopTest();  
    }
}