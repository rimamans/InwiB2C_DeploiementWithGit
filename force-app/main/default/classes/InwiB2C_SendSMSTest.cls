@isTest
public class InwiB2C_SendSMSTest {
  @isTest
    public static void testSendSMS(){
        
        vlocity_cmt__Subscription__c subsc = new vlocity_cmt__Subscription__c ();
            subsc.Inwib2c_Num_ro_de_la_ligne__c = '212637908217';
            subsc.vlocity_cmt__SubscriptionNumber__c = '02i6M000000BIdKJUP';
            subsc.Name = 'test test';
            //subsc.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.Email = 'testtest@gmail.com';
            //subsc.InwiB2C_Partenaire__c = 'Agence CMS01';
            subsc.InwiB2C_Date_d_activation__c = Date.valueOf('2022-08-17');
            
            subsc.inwib2c_vip__c = false;
            subsc.inwiB2C_OptionIdentification__c = false;
            subsc.inwiB2C_managedInSF__c = true;
            subsc.InwiB2C_A_r_silier__c = false;
            subsc.Blacklist__c = false;
         insert subsc;
        
        //InwiB2C_Order_SuspIdar__c orderSubsc = new inwiB2C_OrderSubscription__c();
          //orderSubsc.InwiB2C_Subscription__c = '02i6M000000BIdKJUP';
          //orderSubsc.InwiB2C_Subscription__r.Inwib2c_Num_ro_de_la_ligne__c = '212637908217';
          //orderSubsc.InwiB2C_Subscription__r.Name = 'test test';
          //orderSubsc.InwiB2C_Subscription__r.vlocity_cmt__AccountId__r.vlocity_cmt__PersonContactId__r.Email = 'testtest@gmail.com';
          //orderSubsc.InwiB2C_Subscription__r.InwiB2C_Partenaire__r.Name = 'Agence CMS01';
          //orderSubsc.InwiB2C_Subscription__r.InwiB2C_Date_d_activation__c = Date.valueOf('2022-08-17');
          //orderSubsc.InwiB2C_Subscription__r.inwiB2C_Statut__c = 'InwiB2C_Suspended';
        //insert orderSubsc;        
        
        
        
        
        InwiB2C_Demande_de_resiliation__c demandeResil = new InwiB2C_Demande_de_resiliation__c();
        
          demandeResil.InwiB2C_Subscription__c = subsc.Id;
          demandeResil.InwiB2C_Date_de_signature__c=Date.valueOf('2023-08-17');
        
          demandeResil.InwiB2C_Type_Profil__c = 'idar duo';
          
          demandeResil.inwiB2C_expectedSuspendDate__c = Date.valueOf('2023-08-17');
       
        
        insert demandeResil;
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttp());
        
        Test.startTest();
        inwiB2C_SendSMS.SendSMS(demandeResil.Id);
        Test.stopTest();
    }
    
      public class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }
}