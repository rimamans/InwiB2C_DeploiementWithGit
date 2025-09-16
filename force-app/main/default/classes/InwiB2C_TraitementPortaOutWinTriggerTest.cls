@isTest
public class InwiB2C_TraitementPortaOutWinTriggerTest {
    
    @isTest
    public static void portaOutWinTest(){
        InwiB2C_Trace_API__c  trace = new InwiB2C_Trace_API__c (InwiB2C_API_Name__c='WS40');
        insert trace;
        InwiB2C_TraitementPortaOutWin__e eventPortaOutWin = new InwiB2C_TraitementPortaOutWin__e(InwiB2C_TraceId__c=trace.id); 
        Test.startTest();
        EventBus.publish(eventPortaOutWin);
        Test.stopTest();
    }

}