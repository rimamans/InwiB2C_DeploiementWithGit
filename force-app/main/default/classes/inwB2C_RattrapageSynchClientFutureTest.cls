@IsTest
public with sharing class inwB2C_RattrapageSynchClientFutureTest {
    @IsTest
    public static  void inwB2C_RattrapageSynchClientFutureTest() {

        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;

        inwB2C_RattrapageSynchClientFuture.synchClient(testAccount.id);

    }
}