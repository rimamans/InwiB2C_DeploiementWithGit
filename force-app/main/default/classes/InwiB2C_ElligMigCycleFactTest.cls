@isTest
public class InwiB2C_ElligMigCycleFactTest {
    @isTest
    private static void elligibleMigCycle1(){
        Account a = new Account(Name='TestAccount',vlocity_cmt__Status__c='Nouveau');
        insert a;
        Order order1 = new Order(AccountId=a.Id,EffectiveDate=System.today(),Status='Draft');
        insert order1;
        String DRJson = '{"idcommmande":"'+order1.Id+'","cycleFac":"1"}';
        system.debug('DRJson: '+DRJson);
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        InwiB2C_ElligMigCycleFact.invokeMethod('Elligible',input,output,options);
    }
        static testMethod void elligibleMigCycle18(){
        Account a = new Account(Name='TestAccount',vlocity_cmt__Status__c='Nouveau');
        insert a;
        Order order1 = new Order(AccountId=a.Id,EffectiveDate=System.today(),Status='Draft');
        insert order1;
        String DRJson = '{"idcommmande":"'+order1.Id+'","cycleFac":"18"}';
        system.debug('DRJson: '+DRJson);
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        InwiB2C_ElligMigCycleFact.invokeMethod('Elligible',input,output,options);
    }

}