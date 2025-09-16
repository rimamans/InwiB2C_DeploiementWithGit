@isTest 
public with sharing class inwiB2C_ExecAsyncLimitedAPIBatchTest {
    @isTest (SeeAllData=true) 
    public static void inwiB2C_ExecAsyncLimitedAPIBatchTest() {
        Test.startTest();
        List <InwiB2C_Trace_API__c> listTraceAPI = new List<InwiB2C_Trace_API__c>();
        // //Create new record 1: avec inv
        // InwiB2C_Trace_API__c testTraceAPI1 = new InwiB2C_Trace_API__c();
        // testTraceAPI1.InwiB2C_API_Name__c = 'WS01';
        // testTraceAPI1.InwiB2C_Status__c = 'inwiB2C_ExecuteLater';
        // testTraceAPI1.InwiB2C_MDN__c = '212612345678';
        // testTraceAPI1.InwiB2C_uuid__c='TESTASYNC';
        // listTraceAPI.add(testTraceAPI1);
        // //Create new record 1:sans inv
        // InwiB2C_Trace_API__c testTraceAPI2 = new InwiB2C_Trace_API__c();
        // testTraceAPI2.InwiB2C_API_Name__c = 'WS01';
        // testTraceAPI2.InwiB2C_Status__c = 'inwiB2C_ExecuteLaterAssetGeneration';
        // testTraceAPI2.InwiB2C_MDN__c = '212612345678';
        // testTraceAPI2.InwiB2C_uuid__c='TESTASYNC';
        // listTraceAPI.add(testTraceAPI2);

        // //Create new record 2 : mig pre/post
        // InwiB2C_Trace_API__c testTraceAPI3 = new InwiB2C_Trace_API__c();
        // testTraceAPI3.InwiB2C_API_Name__c = 'WS24';
        // testTraceAPI3.InwiB2C_Status__c = 'inwiB2C_ExecuteLater';
        // testTraceAPI3.InwiB2C_MDN__c = '212612345678';
        // testTraceAPI3.InwiB2C_uuid__c='TESTASYNC';
        // listTraceAPI.add(testTraceAPI3);

        // //Create new record 3:mig postpost avec inv
        // InwiB2C_Trace_API__c testTraceAPI4 = new InwiB2C_Trace_API__c();
        // testTraceAPI4.InwiB2C_API_Name__c = 'WS25';
        // testTraceAPI4.InwiB2C_Status__c = 'inwiB2C_ExecuteLater';
        // testTraceAPI4.InwiB2C_MDN__c = '212612345678';
        // testTraceAPI4.InwiB2C_uuid__c='TESTASYNC';
        // listTraceAPI.add(testTraceAPI4);

        // //Create new record 4:mig postpost sans inv
        // InwiB2C_Trace_API__c testTraceAPI5 = new InwiB2C_Trace_API__c();
        // testTraceAPI5.InwiB2C_API_Name__c = 'WS25';
        // testTraceAPI5.InwiB2C_Status__c = 'inwiB2C_ExecuteLaterAssetGeneration';
        // testTraceAPI5.InwiB2C_MDN__c = '212612345678';
        // testTraceAPI5.InwiB2C_uuid__c='TESTASYNC';
        // listTraceAPI.add(testTraceAPI5);

        //Create new record 5:confirmPayment
        InwiB2C_Trace_API__c testTraceAPI6 = new InwiB2C_Trace_API__c();
        testTraceAPI6.InwiB2C_API_Name__c = 'WS70';
        testTraceAPI6.InwiB2C_Status__c = 'inwiB2C_executeLater';
        testTraceAPI6.InwiB2C_uuid__c='TESTASYNC';
        listTraceAPI.add(testTraceAPI6);
        
        insert listTraceAPI;
        
        Id bacthId = Database.executeBatch(new inwiB2C_ExecAsyncLimitedAPIBatch() , 2000 );
        Test.stopTest();
    }
}