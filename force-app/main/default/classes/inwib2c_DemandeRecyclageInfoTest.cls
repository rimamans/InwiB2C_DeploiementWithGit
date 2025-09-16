@isTest
public class inwib2c_DemandeRecyclageInfoTest {
	 @isTest
    static void testGetDemandeById() {
        Account client = new Account(Name = 'Test Client');
        insert client;
        
        Order commande = new Order(AccountId = client.Id, Status = 'Draft', EffectiveDate = Date.today());
        insert commande;
        
        InwiB2C_Demande_de_recyclage_FTTH__c demande = new InwiB2C_Demande_de_recyclage_FTTH__c(
            InwiB2C_client__c = client.Id,
            InwiB2C_commande__c = commande.Id,
            InwiB2C_work_order_Id__c = '198',
            InwiB2C_Workordertask_Id__c = '1258',
            InwiB2C_Compteur_de_rep_chage__c = 1,
            InwiB2C_Motif_d_chec_de_raccordement__c = 'Hors plaque',
            InwiB2C_ND__c = '212658958121',
            InwiB2C_Statut__c = 'A recycler'
        );
        insert demande;

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('demandeId', demande.Id);

        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();

        Test.startTest();
 			Boolean result = inwib2c_DemandeRecyclageInfo.invokeMethod(
            'getDemandeById', 
            inputMap, 
            outputMap, 
            optionsMap
        );        
        Test.stopTest();
    }
    
}