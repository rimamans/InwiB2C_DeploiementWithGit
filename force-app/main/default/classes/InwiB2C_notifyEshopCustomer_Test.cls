@isTest
public class InwiB2C_notifyEshopCustomer_Test {
    @isTest (SeeAllData=true) 
    public static void InwiB2C_notifyEshopCustomer_Test() {
        Test.startTest(); 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        inputMap.put('mdn','213790945115');
        inputMap.put('email','bouremmaamine09@gmail.com');
        Account testAccount = new Account();
        testAccount.Name='Test Account brm';
        insert testAccount;
        // order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_Conforme',inwiB2C_Canal__c='InwiB2C_Ehop-Agence',inwib2c_StatutDeLivraison__c='inwiB2C_EnAttenteAffectation',Inwib2c_statut_Eshop__c='Inwib2c_Commande_a_livrer', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        inputMap.put('orderid',neworder.Id);
        new InwiB2C_notifyEshopCustomer().invokeMethod('notifyEshopCustomer',inputMap,outMap,options);
        Test.stopTest();
    
        

    }
}