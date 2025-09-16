@isTest 

public class InwiB2C_ClearFieldValue_TEST {

    @isTest
    static void TestClearFieldValue() {

        Account acc1 = new Account(Name='old Account'); insert acc1;
    
        Contract cont2 = new Contract(AccountId=acc1.Id,InwiB2C_Email__c='mailtest@tes.b2c',InwiB2C_N_Ligne__c='212611111111'); insert cont2;

        Map<String,Object> outMap= new  Map<String,Object>();
        Map<String,Object> inputMap= new  Map<String,Object>();
        Map<String,Object> options= new  Map<String,Object>();
    
        List<String> listfields = new List<String>();
        listfields.add('InwiB2C_Email__c');
        listfields.add('InwiB2C_N_Ligne__c');
        
        inputMap.put('fieldsList',listfields);
        inputMap.put('theid',cont2.Id);
        /*
                String sid = cont2.Id;

                List<sObject> beforesobjList = Database.query('SELECT Id,InwiB2C_Email__c,InwiB2C_N_Ligne__c FROM Contract WHERE Id=:sid');
                System.debug('beforesobjList: '+beforesobjList);
*/
        (new InwiB2C_ClearFieldValue()).invokeMethod('resetValue',inputMap,outMap,options);
        /*
                        System.debug('before res');

        
        List<sObject> sobjList = Database.query('SELECT Id,InwiB2C_Email__c,InwiB2C_N_Ligne__c FROM Contract WHERE Id=:sid');
                System.debug('sobjList: '+sobjList);
*/
    }


}