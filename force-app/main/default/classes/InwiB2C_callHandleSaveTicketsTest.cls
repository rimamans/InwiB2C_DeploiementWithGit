@isTest
public class InwiB2C_callHandleSaveTicketsTest{
    @isTest(SeeAllData = true)
    public static void InwiB2C_callHandleSaveTicketsTest(){
         case TestCase =new case(Type='Inwib2c_Reclamation' ,Description='A' ,Subject='B', origin='Appel_entrant',status ='Ouvert'
                                ,InwiB2C_TypeSpecialite__c='InwiB2C_Roaming',Inwib2c_Cat_gorie__c='Inwib2c_Portabilite');
        insert TestCase;

        List<String> input = new List<String>();
        input.add(TestCase.Id);

        InwiB2C_callHandleSaveTickets.callVIP(input);

    }

}