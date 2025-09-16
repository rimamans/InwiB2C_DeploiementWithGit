@IsTest
public class inwiB2C_DemandePartageDateHandlerTest {
    
    @IsTest
    static void testCalculateRecyclageDates() {
       
        List<InwiB2C_Holidays__c> holidays = new List<InwiB2C_Holidays__c>{
            new InwiB2C_Holidays__c(inwib2c_date__c = Date.today().addDays(3)),
            new InwiB2C_Holidays__c(inwib2c_date__c = Date.today().addDays(7))
        };
        insert holidays;


        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();


        Test.startTest();
        Boolean result = new inwiB2C_DemandePartageDateHandler().invokeMethod(
            'calculateRecyclageDates',
            inputMap,
            outMap,
            options
        );
        Test.stopTest();


        System.assert(result, true);

        Map<String, Object> results = (Map<String, Object>) outMap.get('result');
        
        System.assert(results.containsKey('minDateRecyclage'), true);
        System.assert(results.containsKey('maxDateRecyclage'), true);
        System.assert(results.containsKey('holidays'), true);

        System.assert(((Set<Date>) results.get('holidays')).size() == 2, true);
    }

    @IsTest
    static void testExceptionHandling() {

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = new inwiB2C_DemandePartageDateHandler().invokeMethod(
            'invalidMethodName',
            inputMap,
            outMap,
            options
        );
        Test.stopTest();

        System.assert(result, false);
    }

}