@isTest
public class InwiB2C_CALL_VIP_CreateIncidentInSNTest {
  
    @isTest (SeeAllData=true)   
    static void testCallVIPById() {
        // Create a test Case record
        Case testCase = new Case(Status = 'Ouvert');
        insert testCase;
        
        List<Id> caseIdList = new List<Id>{testCase.Id};
        InwiB2C_CALL_VIP_CreateIncidentInSN.callVIPById(caseIdList);
        
        
        Case updatedCase = [SELECT Status FROM Case WHERE Id = :testCase.Id LIMIT 1];
    }
    
    @isTest
    static void testExecCallCreateVIP() {
        Case testCase = new Case(Status = 'Ouvert');
        insert testCase;

        InwiB2C_CALL_VIP_CreateIncidentInSN.execCallCreateVIP(testCase.Id);
        
    }
    
    @isTest
    static void testExecCallCloseVIP() {
        
        Case testCase = new Case(Status = 'InwiB2C_Resolu');
        insert testCase;
        
        InwiB2C_CALL_VIP_CreateIncidentInSN.execCallCloseVIP(testCase.Id);
        
       
    }
}