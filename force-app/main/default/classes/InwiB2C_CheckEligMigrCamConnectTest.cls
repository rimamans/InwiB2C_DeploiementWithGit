@isTest
public class InwiB2C_CheckEligMigrCamConnectTest {

   @testSetup
    static void setupTestData() {

     //create account and contact
     	Contact cnt = new Contact(LastName='Test',FirstName='Test',InwiB2C_CIN__c='CN29884',InwiB2C_Type_CIN__c ='CNI');
        Insert cnt;
        Account client = new Account(Name='Test',vlocity_cmt__PersonContactId__c=cnt.id);
        insert client;
           
        Contact cntDummy = new Contact(LastName='Test',FirstName='DUMMY',InwiB2C_CIN__c='CN29884',InwiB2C_Type_CIN__c ='CNI');
        Insert cntDummy;
        Account clientDummy = new Account(Name='DUMMY',vlocity_cmt__PersonContactId__c=cnt.id);
        insert clientDummy;
        
       vlocity_cmt__Subscription__c testSubscPrepaye =  new vlocity_cmt__Subscription__c (
        vlocity_cmt__SubscriptionNumber__c='0744245555',
        Inwib2c_Num_ro_de_la_ligne__c='212648113065',
        Name='TEST', 
        vlocity_cmt__AccountId__c = client.Id,
        InwiB2C_Id_profil__c='84001');
    
     Insert testSubscPrepaye;
        
     vlocity_cmt__Subscription__c testSubscPrepayeDummy =  new vlocity_cmt__Subscription__c (
        vlocity_cmt__SubscriptionNumber__c='212648113067',
        Inwib2c_Num_ro_de_la_ligne__c='212648113067',
        Name='TEST', 
        vlocity_cmt__AccountId__c = clientDummy.Id,
        InwiB2C_Id_profil__c='84001');
    
     Insert testSubscPrepayeDummy;
    
     vlocity_cmt__Subscription__c testSubscCampus=  new vlocity_cmt__Subscription__c (
        vlocity_cmt__SubscriptionNumber__c='0744245556',
        Inwib2c_Num_ro_de_la_ligne__c='212648113002',
        Name='TEST', 
        InwiB2C_Id_profil__c='20707');
    
     Insert testSubscCampus;
    
     List<InwiB2C_Demande_IdentificationClient__c> records = new List<InwiB2C_Demande_IdentificationClient__c> {
            new InwiB2C_Demande_IdentificationClient__c(
                InwiB2C_MDN__c = '212648113002',
                InwiB2C_Statut__c = 'InwiB2C_Finalisé',
                InwiB2C_Subscription__c = testSubscCampus.Id,
                InwiB2C_Piece_identite__c = 'CN29884',
                InwiB2C_Nom__c='Test Name',InwiB2C_Prenom__c='test'
            ),
                new InwiB2C_Demande_IdentificationClient__c(
                InwiB2C_MDN__c = '212648113003',
                InwiB2C_Statut__c = '',
                InwiB2C_Subscription__c = testSubscCampus.Id,
                InwiB2C_Piece_identite__c = 'CN29884',
                InwiB2C_Nom__c='Test Name',InwiB2C_Prenom__c='test'
            )
          
        };

        insert records;
    }
    @isTest
    static void testInvalidPhoneNumberFormat() {
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '21264811300');
        inputMap.put('mdn2', '21264811300');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }

    @isTest
    static void testMdn1NotFound() {
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '212648113009');
        inputMap.put('mdn2', '212648113002');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }
    
    @isTest
    static void testMdn2NotFound() {
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '212648113065');
        inputMap.put('mdn2', '212648113009');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }

    @isTest
    static void testMismatchedPieceDidentitee() {
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '212648113065');
        inputMap.put('mdn2', '212648113002');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }

    @isTest
    static void testMdn1NotElegible() {
       Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '212648113067');
        inputMap.put('mdn2', '212648113002');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }

     @isTest
    static void testMdn2NotElegible() {
       Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '212648113066');
        inputMap.put('mdn2', '212648113003');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }
    
    @isTest
    static void testValidEligibility() {
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('mdn1', '212648113065');
        inputMap.put('mdn2', '212648113002');

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        // Create an instance of class and invoke the method
        InwiB2C_CheckEligibilityMigrCamConnect CheckEligibilityMigrCamConnec = new InwiB2C_CheckEligibilityMigrCamConnect();
        boolean result = CheckEligibilityMigrCamConnec.invokeMethod('CheckEligibility', inputMap, outMap, options);
    }


}