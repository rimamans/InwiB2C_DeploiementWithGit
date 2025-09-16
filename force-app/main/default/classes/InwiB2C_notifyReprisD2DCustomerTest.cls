@isTest
public class InwiB2C_notifyReprisD2DCustomerTest {
 @isTest (SeeAllData=true) 
    public static void InwiB2C_notifyEshopCustomer_Test() {
        Test.startTest(); 
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        inputMap.put('mdn','213790945115');
        inputMap.put('email','mohammed.hamitouche@assa-associates.com');
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        // order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_Conforme',inwiB2C_Canal__c='inwiB2C_D2D',InwB2C_Statut_livraison_D2D__c='Inwib2c_CommandeEnVerification', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        inputMap.put('orderid',neworder.Id);
        new InwiB2C_notifyReprisD2DCustomer().invokeMethod('notifyD2DCustomer',inputMap,outMap,options);
        Test.stopTest();
    
        

    }
}