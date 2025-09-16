@isTest
public class InwiB2C_SendSMSResilRequestTest {
    @isTest
    private static void testSendSMSResil(){

        //List<vlocity_cmt__Subscription__c> subsc = [ SELECT Id,Inwib2c_Num_ro_de_la_ligne__c From vlocity_cmt__Subscription__c  limit 1];
        
        vlocity_cmt__Subscription__c subsc = new vlocity_cmt__Subscription__c ();
            subsc.Inwib2c_Num_ro_de_la_ligne__c = '212647858612';
            subsc.vlocity_cmt__SubscriptionNumber__c = '02i6M000000BIdRQAW';
            subsc.inwib2c_vip__c = false;
            subsc.inwiB2C_OptionIdentification__c = false;
            subsc.inwiB2C_managedInSF__c = true;
            subsc.InwiB2C_A_r_silier__c = false;
            subsc.Blacklist__c = false;
            insert subsc;
        InwiB2C_Demande_de_resiliation__c lstRequest= new InwiB2C_Demande_de_resiliation__c();
        lstRequest.InwiB2C_Subscription__c = subsc.Id;
        lstRequest.inwiB2C_num_Ligne__c = subsc.Inwib2c_Num_ro_de_la_ligne__c;
        lstRequest.InwiB2C_Date_de_signature__c = Date.valueOf('2022-04-13');
        lstRequest.inwiB2C_Statut_d_approbation__c = 'Approuvée';
        lstRequest.inwiB2C_expectedSuspendDate__c  =Date.valueOf('2022-04-13'); 
        insert lstRequest;
       List<String> id = new List<String>();
       id.add(lstRequest.Id);
       Test.setMock(HttpCalloutMock.class, new INWIB2C_SMSCalloutMock()); 
       InwiB2C_SendSMSResilRequest.SendSMSResilRequest(id);
    }
}