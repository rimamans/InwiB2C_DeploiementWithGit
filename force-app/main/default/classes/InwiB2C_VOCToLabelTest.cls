@IsTest
public class InwiB2C_VOCToLabelTest {

      
    @TestSetup
    static void setupTestData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Case casetest = new Case(Status = 'Ouvert');
        insert casetest;
        
        
        
        List<Case> insertCases = new List<Case>();
        for(integer i = 0 ; i<103 ; i++){
            insertCases.add(new Case(Status = 'Ouvert'));
        }
        insert insertCases;
    }

    
    @IsTest
    static void testToLabelBulkInput() {
        
        List<Case> inputCases = [SELECT Id FROM Case LIMIT 102];
        List<String> inputs = new List<String>();
            for(Case inputCase : inputCases){
                inputs.add('Case,Status,' + inputCase.Id);
            }

        Test.startTest();
        List<String> results = InwiB2C_VOCToLabel.ToLabel(inputs);
        Test.stopTest();

        System.assertEquals('Ouvert', results[0]);
    }
    
    @IsTest
    static void testToLabelWithValidInput() {
        List<String> inputs = new List<String> {
            'Case,Status,' + [SELECT Id FROM Case LIMIT 1][0].Id
        };

        Test.startTest();
        List<String> results = InwiB2C_VOCToLabel.ToLabel(inputs);
        Test.stopTest();

        System.assertEquals('Ouvert', results[0]);
    }

    @IsTest
    static void testToLabelWithInvalidInputFormat() {

        List<String> inputs = new List<String> {
            'Case,Status,'
        };


        Test.startTest();
        List<String> results = InwiB2C_VOCToLabel.ToLabel(inputs);
        Test.stopTest();


        //System.assertEquals(1, results.size());
        System.assertEquals('Case,Status,', results[0]);
    }

    @IsTest
    static void testToLabelWithNonExistingRecord() {

        List<String> inputs = new List<String> {
            'Account,test,001NonExistentID'
        };

        Test.startTest();
        List<String> results = InwiB2C_VOCToLabel.ToLabel(inputs);
        Test.stopTest();


        System.assertEquals(1, results.size());
        System.assertEquals('champ', results[0]);
    }

    @IsTest
    static void testToLabelWithExceptionHandling() {

        List<String> inputs = new List<String> {
            'InvalidObject,Name,001NonExistentID' 
        };

        Test.startTest();
        List<String> results = InwiB2C_VOCToLabel.ToLabel(inputs);
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('champ', results[0]);
    }
}