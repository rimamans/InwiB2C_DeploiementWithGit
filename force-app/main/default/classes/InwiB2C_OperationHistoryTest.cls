@isTest
public class InwiB2C_OperationHistoryTest {
    @isTest (SeeAllData=true)
    static void InwiB2C_OperationHistoryTest(){
        Test.startTest(); 

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        //inputMap.put('ActionOperation','102030405060');
        inputMap.put('ActionOperation','Fidelisation');
        inputMap.put('Mdn','102030405060');
        inputMap.put('ShowIMEI','1');
        inputMap.put('transactionId','102030405060');
        inputMap.put('SousProduitIN','0001702');
        inputMap.put('BillingAccount','SF11225');
        inputMap.put('StatutOperation','OK');
        inputMap.put('Canal','Point de vente');
        inputMap.put('SubActionOperation','Initialisation');
        inputMap.put('produit','Samsung CAN 2024');
        inputMap.put('category','PYHSIQUE');
        inputMap.put('Description','Samsung CAN 2024');
        new InwiB2C_OperationHistory().invokeMethod('AddOperationHistory',inputMap,outMap,options);
        Test.stopTest();






    }
}