@IsTest
public class Inwib2c_CreateMassInventoryItemsTest {

    @TestSetup
    public static void setupData() {

        //List<Order> OrderList = TestUtility.prepare
        //insert OrderList;
    }
    
    public static testMethod void batchOrderTest() {
        /* Begin JBE */
        Test.startTest();

        InwiB2C_MigratedAssets__c MATest=new InwiB2C_MigratedAssets__c();
        MATest.InwiB2C_Statut__c='New';
        insert MATest;
        Id bacthId2 = Database.executeBatch( new Inwib2c_CreateMassInventoryItems() , 10 );


        Test.stopTest();
    }
}