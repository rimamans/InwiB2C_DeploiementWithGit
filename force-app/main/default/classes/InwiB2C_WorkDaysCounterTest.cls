@IsTest
public class InwiB2C_WorkDaysCounterTest {

    @IsTest
    static void testInvokeMethodForCountTotalDaysForWorkingDays() {
        InwiB2C_Holidays__c holiday = new InwiB2C_Holidays__c(inwib2c_date__c = Date.today().addDays(-3));
        insert holiday;

        Date inputDate = Date.today().addDays(-7);

        Test.startTest();
        Integer workingDaysCount = InwiB2C_WorkDaysCounter.countTotalDaysForWorkingDays(inputDate);
        Test.stopTest();
    }
}