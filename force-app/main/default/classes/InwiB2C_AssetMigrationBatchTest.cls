@IsTest
public class InwiB2C_AssetMigrationBatchTest {

        @isTest(SeeAllData=true)
     static void AssetMigrationBatchTest() {
        /* Begin JBE */
        Test.startTest();
        //DateTime myDateTime = DateTime.newInstance(2021, 10, 02, 0, 0, 00);
        string year = '2021';
        string month = '8';
        string day = '2';
        string hour = '00';
        string minute = '00';
        string second = '00';
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        
        Datetime myDate = Datetime.valueOf(stringDate);
        Id bacthId2 = Database.executeBatch( new InwiB2C_AssetMigrationBatch(myDate,1) , 200 );
        Test.stopTest();
    }
    
            @isTest(SeeAllData=true)
     static void AssetMigrationBatchTest2() {
        /* Begin JBE */
        Test.startTest();
        //DateTime myDateTime = DateTime.newInstance(2021, 10, 02, 0, 0, 00);
        string year = '2021';
        string month = '8';
        string day = '2';
        string hour = '00';
        string minute = '00';
        string second = '00';
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        
        Datetime myDate = Datetime.valueOf(stringDate);
        Id bacthId2 = Database.executeBatch( new InwiB2C_AssetMigrationBatch(myDate,2) , 200 );
        Test.stopTest();
    }
    
                @isTest(SeeAllData=true)
     static void AssetMigrationBatchTest3() {
        /* Begin JBE */
        Test.startTest();
        //DateTime myDateTime = DateTime.newInstance(2021, 10, 02, 0, 0, 00);
        string year = '2021';
        string month = '8';
        string day = '2';
        string hour = '00';
        string minute = '00';
        string second = '00';
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        
        Datetime myDate = Datetime.valueOf(stringDate);
        Id bacthId2 = Database.executeBatch( new InwiB2C_AssetMigrationBatch(myDate,3) , 200 );
        Test.stopTest();
    }
    
    
}