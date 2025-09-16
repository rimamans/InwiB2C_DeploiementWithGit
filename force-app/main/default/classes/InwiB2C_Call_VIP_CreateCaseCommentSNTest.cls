@isTest
public class InwiB2C_Call_VIP_CreateCaseCommentSNTest {

    @isTest (SeeAllData=true)   
    static void testCallVIPById() {
        // Create a test Case record (Parent record)
        Case testCase = new Case(Status = 'Ouvert');
        insert testCase;
        
        // Create a test CaseComment record
        CaseComment testCaseComment = new CaseComment(
        ParentId = testCase.Id, 
        CommentBody = 'Test Comment'
       );
       insert testCaseComment;
        
       
        List<Id> caseCommentIdList = new List<Id>{testCaseComment.Id};
        InwiB2C_Call_VIP_CreateCaseCommentInSN.callVIPById(caseCommentIdList);
        
        CaseComment updatedCaseComment = [SELECT Id FROM CaseComment WHERE Id = :testCaseComment.Id LIMIT 1];
     
    }
    
    @isTest
    static void testCallCreateCaseCommentVIP() {
        Case testCase = new Case(Status = 'Ouvert');
        insert testCase;
        
        CaseComment testCaseComment = new CaseComment( 
        ParentId = testCase.Id, 
        CommentBody = 'Test Comment'
        );
        insert testCaseComment;
        
        
        InwiB2C_Call_VIP_CreateCaseCommentInSN.CallCreateCaseCommentVIP(testCaseComment.Id);
        

    }
    
}