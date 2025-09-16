@isTest
public class InwiB2C_VOCConditionVerificationTest {
    
    @TestSetup
    static void setupTestData(){

    // Insert Event Condition Records
      List<InwiB2C_VOC_Event_Condition__c> testRecords = new List<InwiB2C_VOC_Event_Condition__c>{

        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 1,
            InwiB2C_Event__c= 'Order',
            InwiB2C_Field_Name__c= 'inwiB2C_Statut__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 2 ) OR (3 AND 4))',
            InwiB2C_Object_Name__c= 'Order',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'inwiB2C_Activee',
            InwiB2C_Type__c= 'Event'
        ),

        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 2,
            InwiB2C_Event__c= 'Order',
            InwiB2C_Field_Name__c= 'inwiB2C_TypeDeMigration__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 2 ) OR (3 AND 4))',
            InwiB2C_Object_Name__c= 'Order',
            InwiB2C_Operator__c= '!=',
            InwiB2C_Search_Conditon__c= 'Migration Postpayé Postpayé',
            InwiB2C_Type__c= 'Event'
        ),
                 
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 3,
            InwiB2C_Event__c= 'Order',
            InwiB2C_Field_Name__c= 'inwiB2C_Statut__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 2 ) OR (3 AND 4))',
            InwiB2C_Object_Name__c= 'Order',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'inwiB2C_Activation',
            InwiB2C_Type__c= 'Event'
        ),
              
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 4,
            InwiB2C_Event__c= 'Order',
            InwiB2C_Field_Name__c= 'inwiB2C_TypeDeMigration__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 2 ) OR (3 AND 4))',
            InwiB2C_Object_Name__c= 'Order',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'Migration Postpayé Postpayé',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 1,
            InwiB2C_Event__c= 'INWIB2C_HIST_ACTION_LINE__c',
            InwiB2C_Field_Name__c= 'inwiB2C_STATUT__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '1',
            InwiB2C_Object_Name__c= 'INWIB2C_HIST_ACTION_LINE__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'OK',
            InwiB2C_Type__c= 'Event'
        ),
                    
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 1,
            InwiB2C_Event__c= 'Case',
            InwiB2C_Field_Name__c= 'Status',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 OR 2 ) AND (3 OR 4))',
            InwiB2C_Object_Name__c= 'Case',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'InwiB2C_Escalade',
            InwiB2C_Type__c= 'Event'
        ),
                  
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 2,
            InwiB2C_Event__c= 'Case',
            InwiB2C_Field_Name__c= 'Status',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 OR 2 ) AND (3 OR 4))',
            InwiB2C_Object_Name__c= 'Case',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'InwiB2C_Resolu',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 3,
            InwiB2C_Event__c= 'Case',
            InwiB2C_Field_Name__c= 'Type',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 OR 2 ) AND (3 OR 4))',
            InwiB2C_Object_Name__c= 'Case',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'Inwib2c_Reclamation',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 4,
            InwiB2C_Event__c= 'Case',
            InwiB2C_Field_Name__c= 'Type',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 OR 2 ) AND (3 OR 4))',
            InwiB2C_Object_Name__c= 'Case',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'Inwib2c_Information',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 1,
            InwiB2C_Event__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Field_Name__c= 'InwiB2C_Statut_Resil__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 4) OR (5 AND 1) OR (2 AND 3))',
            InwiB2C_Object_Name__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'Clôturée',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 2,
            InwiB2C_Event__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Field_Name__c= 'InwiB2C_Statut_Resil__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 4) OR (5 AND 1) OR (2 AND 3))',
            InwiB2C_Object_Name__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'En cours',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 3,
            InwiB2C_Event__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Field_Name__c= 'InwiB2C_Statut_R_tention__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 4) OR (5 AND 1) OR (2 AND 3))',
            InwiB2C_Object_Name__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'Non Retenu',
            InwiB2C_Type__c= 'Event'
        ),
                  
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 4,
            InwiB2C_Event__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Field_Name__c= 'InwiB2C_Statut_R_tention__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 4) OR (5 AND 1) OR (2 AND 3))',
            InwiB2C_Object_Name__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'Retenu',
            InwiB2C_Type__c= 'Event'
        ),
                   
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 5,
            InwiB2C_Event__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Field_Name__c= 'InwiB2C_Statut_R_tention__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '((1 AND 4) OR (5 AND 1) OR (2 AND 3))',
            InwiB2C_Object_Name__c= 'InwiB2C_Demande_de_resiliation__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= null,
            InwiB2C_Type__c= 'Event'
        ),
                    
        new InwiB2C_VOC_Event_Condition__c(
            InwiB2C_Condition_Number__c= 1,
            InwiB2C_Event__c= 'InwiB2C_Demande_IdentificationClient__c',
            InwiB2C_Field_Name__c= 'InwiB2C_Statut__c',
            InwiB2C_Field_To_Select__c= null,
            InwiB2C_Logic__c= '1',
            InwiB2C_Object_Name__c= 'InwiB2C_Demande_IdentificationClient__c',
            InwiB2C_Operator__c= '=',
            InwiB2C_Search_Conditon__c= 'InwiB2C_Finalisé',
            InwiB2C_Type__c= 'Event'
        )
      };

      insert testRecords;

      // Insert Test Data

      //Account
      Account testAccount = new Account(Name = 'Test Account' 
                                         // , Inwib2c_VIP__c = false , InwiB2C_StopEnvoiEnquete__c = false , vlocity_cmt__PrimaryContactId__c = testContact.Id
                                         );
      insert testAccount;

      //Order
        List<Order> mockOrders = new List<Order>();

        for (Integer i=0 ; i < 201; i++){
            Order mockOrder = new Order(
                inwiB2C_Statut__c = 'inwiB2C_Activee',
                EffectiveDate = Date.today().addDays(-1),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                Status = 'Draft',
                AccountId = testAccount.Id
            );
            mockOrders.add(mockOrder);
       }
        insert mockOrders;

        Order orderTest = new Order(
                inwiB2C_Statut__c = 'inwiB2C_Activation',
                EffectiveDate = Date.today().addDays(-1),
                inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
                Status = 'Draft',
                AccountId = testAccount.Id
            );

       insert orderTest;

        //Action
        List<INWIB2C_HIST_ACTION_LINE__c> testActions = new List<INWIB2C_HIST_ACTION_LINE__c>{
            new INWIB2C_HIST_ACTION_LINE__c(inwiB2C_STATUT__c = 'OK'),
            new INWIB2C_HIST_ACTION_LINE__c(inwiB2C_STATUT__c = 'KO')
        };
        insert testActions;

        //Demande d'identification Client
        List<InwiB2C_Demande_IdentificationClient__c> demandesIdentTest = new List<InwiB2C_Demande_IdentificationClient__c>{
            new InwiB2C_Demande_IdentificationClient__c(
                InwiB2C_Nom__c='Test Name',
                InwiB2C_Prenom__c='test', 
                InwiB2C_Statut__c='InwiB2C_Finalisé'),

            new InwiB2C_Demande_IdentificationClient__c(
                InwiB2C_Nom__c='Test Name1',
                InwiB2C_Prenom__c='test1', 
                InwiB2C_Statut__c='InwiB2C_Encours')
        };
        insert demandesIdentTest;  

        //Demande de resiliation
        vlocity_cmt__Subscription__c testSubsc=  new vlocity_cmt__Subscription__c (
                vlocity_cmt__SubscriptionNumber__c='0744245555',
                Inwib2c_Num_ro_de_la_ligne__c='0197765933',
                Name='TESTKAB'
            );
            Insert testSubsc;

        List<InwiB2C_Demande_de_resiliation__c> demandesResiliation = new List<InwiB2C_Demande_de_resiliation__c>{
            new InwiB2C_Demande_de_resiliation__c(
                InwiB2C_Subscription__c = testSubsc.Id, 
                inwiB2C_num_Ligne__c = testSubsc.Inwib2c_Num_ro_de_la_ligne__c , 
                InwiB2C_Statut_Resil__c= 'Clôturée'),

            new InwiB2C_Demande_de_resiliation__c(
                InwiB2C_Subscription__c = testSubsc.Id, 
                inwiB2C_num_Ligne__c = testSubsc.Inwib2c_Num_ro_de_la_ligne__c , 
                InwiB2C_Statut_Resil__c= 'En cours')
        };
            
        Insert demandesResiliation;


        //Case
        List<Case> testCases = new List<Case>{
                new case(
                    Type='Inwib2c_Reclamation',
                    Description='A',
                    Subject='B',
                    origin='C',
                    status ='InwiB2C_Resolu',
                    InwiB2C_TypeSpecialite__c='InwiB2C_Roaming',
                    Inwib2c_Cat_gorie__c='Inwib2c_Reseau_Reclamation'),


                new case(
                    Type='Inwib2c_Reclamation',
                    Description='A',
                    Subject='B',
                    origin='C',
                    status ='Ouvert',
                    InwiB2C_TypeSpecialite__c='InwiB2C_Roaming',
                    Inwib2c_Cat_gorie__c='Inwib2c_Reseau_Reclamation')
        };
        
        insert testCases;

    }

    
    @isTest
    static void BulkVerificationTest() {

        List<Order> recordsList = [Select id from Order];
        Integer listSize = recordsList.size();
        List<String> listInput = new List<String>();

        for( Order record : recordsList ){
            String input = 'Order,'+ record.Id ;
            listInput.add(input);
        }
               
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
       // System.assertEquals(true, result[0]);
        System.assertEquals(listSize, result.size());

    }
   
    
    @isTest
    static void OrderConditionTest() {
        Order recordOrderEligbleTest = [SELECT id FROM Order WHERE
                                         inwiB2C_Statut__c = 'inwiB2C_Activee' 
                                         AND inwiB2C_TypeDeMigration__c != 'Migration Postpayé Postpayé'
                                         LIMIT 1];
        Order recordOrderNonEligbleTest = [SELECT id FROM Order WHERE
                                         inwiB2C_Statut__c = 'inwiB2C_Activation' 
                                         AND inwiB2C_TypeDeMigration__c != 'Migration Postpayé Postpayé'
                                         LIMIT 1];
      


        List<String> listInput = new List<String>{
            'Order,'+ recordOrderEligbleTest.Id ,
            'Order,'+ recordOrderNonEligbleTest.Id
        };
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(true, result[0]);
        System.assertEquals(false, result[1]);
    }

    
    @isTest
    static void DemandeResiliationConditionTest() {

        InwiB2C_Demande_de_resiliation__c recordEligbleTest = [SELECT id FROM InwiB2C_Demande_de_resiliation__c WHERE
                                         InwiB2C_Statut_Resil__c = 'Clôturée' 
                                         LIMIT 1];

        InwiB2C_Demande_de_resiliation__c recordNonEligbleTest = [SELECT id FROM InwiB2C_Demande_de_resiliation__c WHERE
                                         InwiB2C_Statut_Resil__c != 'Clôturée' 
                                         LIMIT 1];
      

        List<String> listInput = new List<String>{
            'InwiB2C_Demande_de_resiliation__c,'+ recordEligbleTest.Id ,
            'InwiB2C_Demande_de_resiliation__c,'+ recordNonEligbleTest.Id
        };
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(true, result[0]);
        System.assertEquals(false, result[1]);

    }

    @isTest
    static void DemandeIdentificationConditionTest() {

    InwiB2C_Demande_IdentificationClient__c recordEligbleTest = [SELECT id FROM InwiB2C_Demande_IdentificationClient__c WHERE
                                         inwiB2C_Statut__c = 'InwiB2C_Finalisé'
                                         LIMIT 1];

    InwiB2C_Demande_IdentificationClient__c recordNonEligbleTest = [SELECT id FROM InwiB2C_Demande_IdentificationClient__c WHERE
                                         inwiB2C_Statut__c = 'InwiB2C_Encours'
                                         LIMIT 1];
      

        List<String> listInput = new List<String>{
            'InwiB2C_Demande_IdentificationClient__c,'+ recordEligbleTest.Id ,
            'InwiB2C_Demande_IdentificationClient__c,'+ recordNonEligbleTest.Id
        };
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(true, result[0]);
        System.assertEquals(false, result[1]);

    }

    @isTest
    static void CaseConditionTest() {

    Case recordCaseEligbleTest = [SELECT id FROM Case WHERE
                                         Status = 'InwiB2C_Resolu' 
                                         AND Type = 'Inwib2c_Reclamation'
                                         LIMIT 1];

    Case recordCaseNonEligbleTest = [SELECT id FROM Case WHERE
                                         Status = 'Ouvert' 
                                         AND Type = 'Inwib2c_Reclamation'
                                         LIMIT 1];

      
        List<String> listInput = new List<String>{
            'Case,'+ recordCaseEligbleTest.Id ,
            'Case,'+ recordCaseNonEligbleTest.Id
        };
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(true, result[0]);
        System.assertEquals(false, result[1]);

    }

    @isTest
    static void ActionConditionTest() {

    INWIB2C_HIST_ACTION_LINE__c recordCaseEligbleTest = [SELECT id FROM INWIB2C_HIST_ACTION_LINE__c WHERE
                                         inwiB2C_STATUT__c = 'OK' 
                                         LIMIT 1];

    INWIB2C_HIST_ACTION_LINE__c recordCaseNonEligbleTest = [SELECT id FROM INWIB2C_HIST_ACTION_LINE__c WHERE
                                         inwiB2C_STATUT__c != 'OK' 
                                         LIMIT 1];

      
        List<String> listInput = new List<String>{
            'INWIB2C_HIST_ACTION_LINE__c,'+ recordCaseEligbleTest.Id ,
            'INWIB2C_HIST_ACTION_LINE__c,'+ recordCaseNonEligbleTest.Id
        };
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(true, result[0]);
        System.assertEquals(false, result[1]);

    }


    @isTest
    static void EmptyInputTest(){

         List<String> listInput = new List<String>();
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(false, result[0]);

    }

    @isTest
    static void InvalidEventTest(){

        List<String> listInput = new List<String>();
            
        for (Integer i=0 ; i < 20 ; i++){
        	listInput.add('test,' + i);
        }
        
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        // Assert 
        System.debug(result);
        System.assertEquals(false, result[0]);
        System.assertEquals(20, result.size());

    }


     @isTest
    static void CallFromFuturTest(){

        SystemFacade.isFuture = true;

         List<String> listInput = new List<String>();
            
        for (Integer i=0 ; i < 20 ; i++){
        	listInput.add('test,' + i);
        }
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        
        // Assert 
        System.debug(result);
        System.assertEquals(false, result[0]);
        System.assertEquals(20, result.size());

    }
    
     @isTest
    static void CallFromBatchTest(){


        SystemFacade.isBatch = true;

         List<String> listInput = new List<String>();
            
        for (Integer i=0 ; i < 20 ; i++){
        	listInput.add('test,' + i);
        }
      
        Test.startTest();
        List<Boolean> result = InwiB2C_VOCConditionVerification.generateEventQuery(listInput);
        Test.stopTest();

        
        // Assert 
        System.debug(result);
        System.assertEquals(false, result[0]);
        System.assertEquals(20, result.size());

    }

}