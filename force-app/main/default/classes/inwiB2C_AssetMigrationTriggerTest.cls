@IsTest
public class inwiB2C_AssetMigrationTriggerTest {

    @TestSetup
    public static void setupData() {

    }
    
    public static testMethod void AssetMigrationTriggerTest() {
        /* Begin JBE */
        Test.startTest();
         Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        
        Product2 prod = new Product2(Name = 'Product Num 1', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM'
                                    );
        insert prod;
        
        Product2 prod2 = new Product2(Name = 'Product Num 2', 
                                     Family = 'Hardware',
                                     ProductCode='INWIB2C_OFFERING_SIM'
                                    );
        insert prod2;
        
        Product2 prod3 = new Product2(Name = 'Product Num 3', 
                                      Family = 'Hardware',
                                      ProductCode='INWIB2C_OFFERING_SIM'
                                     );
        insert prod3;
        
        
        /* Creation of Assets */
        Asset AssetItem1 = new Asset(AccountId = testAccount.id,Product2Id = prod.id, Quantity= 30, Price=300, PurchaseDate = Date.today(),Status = 'Purchased',Description='ASSET1',Name='Asset1', inwiB2C_Legacy_Id__c = 'INS1234567890' );
        insert AssetItem1;
        system.debug('ASSET 1 JO : '+ AssetItem1.AssetLevel + '   ' + AssetItem1.vlocity_cmt__ProductGroupKey__c );
		Asset AssetItem2 = new Asset(ParentId =AssetItem1.id, AccountId = testAccount.id,Product2Id = prod2.id, Quantity= 30, Price=300, PurchaseDate = Date.today(),Status = 'Purchased',Description='ASSET2',Name='Asset2', inwiB2C_Legacy_Id__c = 'INS1234567891');
        insert AssetItem2;
        system.debug('ASSET 2 JO : '+ AssetItem2.AssetLevel + '   ' + AssetItem2.vlocity_cmt__ProductGroupKey__c );
        Asset AssetItem3 = new Asset(ParentId =AssetItem2.id,AccountId = testAccount.id,Product2Id = prod3.id, Quantity= 30, Price=300, PurchaseDate = Date.today(),Status = 'Purchased',Description='ASSET2',Name='Asset3', inwiB2C_Legacy_Id__c = 'INS1234567892');
        insert AssetItem3;
        system.debug('ASSET 3 JO : '+ AssetItem3.AssetLevel + '   ' + AssetItem3.vlocity_cmt__ProductGroupKey__c );
        
        Test.stopTest();
    }
}