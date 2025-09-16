@IsTest
public class InwiB2C_RattrapageUSSDDraftOrderTest {

    @IsTest(seeAllData=true)
    public static void batchTest() {
        Test.startTest();
        
        Id bacthId = Database.executeBatch(new InwiB2C_RattrapageUSSDDraftOrder() , 100 );
        Test.stopTest();
    }
}