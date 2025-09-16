@isTest
private class SystemFacadeTest {
    
    @isTest
    static void testIsFuture() {
        System.assertEquals(System.isFuture(), SystemFacade.isFuture());
        
        SystemFacade.isFuture = true;
        Test.startTest();
        System.assertEquals(true, SystemFacade.isFuture());
        Test.stopTest();
    }
    
    @isTest
    static void testIsBatch() {

        System.assertEquals(System.isBatch(), SystemFacade.isBatch());
        
        SystemFacade.isBatch = true;
        Test.startTest();
        System.assertEquals(true, SystemFacade.isBatch());
        Test.stopTest();
    }
}