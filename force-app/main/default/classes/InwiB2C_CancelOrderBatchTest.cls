@IsTest
public class InwiB2C_CancelOrderBatchTest {

    @TestSetup
    public static void setupData() {

        //List<Order> OrderList = TestUtility.prepare
        //insert OrderList;
    }
    
    public static testMethod void batchOrderTest() {
        /* Begin JBE */

        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        inwiB2CTimeOrderCancel__mdt newTimeOrder= new inwiB2CTimeOrderCancel__mdt(inwiB2C_TimeOutOrder__c =0);
        
        list<order>orderlist=new list<order>();
        for(integer i=0;i<200;i++){
        order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        orderlist.add(neworder);
        }
        insert orderlist;
        Test.startTest();

        
        
        InwiB2C_CancelOrderBatch cb = New InwiB2C_CancelOrderBatch();

        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,orderlist);
        
        InwiB2C_CancelOrderBatch obj = new InwiB2C_CancelOrderBatch();
        DataBase.executeBatch(obj, 10 );

  
        Test.stopTest();
    }
}