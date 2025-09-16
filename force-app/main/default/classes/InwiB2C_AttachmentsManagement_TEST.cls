@isTest 

public class InwiB2C_AttachmentsManagement_TEST {

    @isTest
    static void testAttachmentsManagement() {

        Account acc1 = new Account(Name='old Account'); insert acc1;

        Contract cont1 = new Contract(AccountId=acc1.Id); insert cont1;
    
        Contract cont2 = new Contract(AccountId=acc1.Id); insert cont2;
        
        InwiB2C_AttachmentsManagement.attachmentsAssignment(Id.valueOf(cont1.Id),Id.valueOf(cont2.Id),'CONTRACT','CONTRACT');



}

}