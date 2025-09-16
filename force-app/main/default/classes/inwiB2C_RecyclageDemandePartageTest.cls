@isTest
public class inwiB2C_RecyclageDemandePartageTest {
    @isTest
    static void testRecycleDemandePartageRejected() {
        
        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'REJ',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637',
            InwiB2C_Compteur_recyclage__c = 1
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'REJ',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
               // 'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_Compteur_recyclage__c' => 1
            }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       
        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);


    }

    @isTest
    static void testRecycleDemandePartageSuspended() {
         Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'SUS',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Code_Motif__c = '24',
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637'
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'SUS',
            	'CreatedDate' => '2024-12-01T10:00:00Z',
            	'InwiB2C_Code_Motif__c' => '24',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
               // 'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_Compteur_recyclage__c' => '0'
            }
        };
            
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();


        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);
    }

    @isTest
    static void testRecycleDemandePartageWithError() {
        
         Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'InwiB2C_EnErreur',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637'
        );
        insert testDemande;
         inwiB2C_demande_partage__c testSuspendedDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'SUS',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637'
        );
        insert testSuspendedDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'InwiB2C_EnErreur',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
             //   'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'IAM',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637'
            }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);
    }
    
    @isTest
    static void testRecycleDemandePartageAnnulSuspended3() {
        
        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'Annulee_3_Susp',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637',
            InwiB2C_Compteur_recyclage__c = 1
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'Annulee_3_Susp',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
               // 'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_Compteur_recyclage__c' => 1
            }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       
        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);


    }
    
    @isTest
    static void testRecycleDemandePartageAnnulDeg() {
        
        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'Annulee_Delai_Reg',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637',
            InwiB2C_Compteur_recyclage__c = 1
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'Annulee_Delai_Reg',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
               // 'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_Compteur_recyclage__c' => 1
            }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       
        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);


    }
    
    @isTest
    static void testRecycleDemandePartageRejectedDEF() {
        
        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'DEF',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637',
            InwiB2C_Code_Motif__c = '22',
            InwiB2C_Compteur_recyclage__c = 1
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'DEF',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
               // 'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_Code_Motif__c' => '22',
                'InwiB2C_Compteur_recyclage__c' => 1
            }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       
        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);


    }
    
       @isTest
    static void testRecycleDemandePartageMaxRecycle() {
        
        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'SUS',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637',
            InwiB2C_Compteur_recyclage__c = 10
        );
        insert testDemande;
        Map<String, Object> inputMap = new Map<String, Object>{
            'lwcDemande' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'SUS',
                'CreatedDate' => '2024-12-01T10:00:00Z',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
               // 'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_Compteur_recyclage__c' => '10'
            }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       
        Test.startTest();
        Boolean result = new inwiB2C_RecyclageDemandePartage().invokeMethod('RecycleDemandePartage', inputMap, outMap, options);
        Test.stopTest();
        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);


    }

    @isTest
    static void testInvokeMethodWithInvalidMethodName() {
      
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       
        inwiB2C_RecyclageDemandePartage handler = new inwiB2C_RecyclageDemandePartage();
        Boolean result = handler.invokeMethod('InvalidMethodName', inputMap, outMap, options);

        // Assert
        System.assert(result, false);
    }
    
    @isTest
    static void testConinueAfterApiCall(){
         
        //Map<String, Object> inputMap = new Map<String, Object>();

        Account testAccount = new Account(Name = 'Test Account' , inwiB2C_numero_de_designation__c = '0529111637');  
        insert testAccount;
        Order testOrder =new Order(
            vlocity_cmt__DefaultServiceAccountId__c = testAccount.Id,
            inwiB2C_Statut__c = 'inwiB2C_Activation',
            EffectiveDate = Date.today().addDays(-1),
            inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification',
            Status = 'Draft',
            AccountId = testAccount.Id
        );
        insert testOrder;
        InwiB2C_Commande_de_partage__c testCommandePartage = new InwiB2C_Commande_de_partage__c(InwiB2C_Order__c = testOrder.Id);
        insert testCommandePartage;
        inwiB2C_demande_partage__c testDemande= new inwiB2C_demande_partage__c(
            InwiB2C_Statut_demande__c = 'REJ',
            InwiB2C_Commande_de_partage__c = testCommandePartage.Id,
            InwiB2C_Sequence__c = 1,
            InwiB2C_Operateur_Infrastructure__c ='ORANGE',
            InwiB2C_NumeroDesignation__c ='0788990055',
            InwiB2C_Nationalid__c ='CIN1234',
            InwiB2C_nd_Attribut__c ='0529111637'
        );
        insert testDemande;
        
          Map<String, Object> inputMap = new Map<String, Object>{
            'lwcData' => new Map<String, Object>{
                'InwiB2C_Statut_demande__c' => 'REJ',
                'InwiB2C_Commande_de_partage__c' => testCommandePartage.Id,
                'Id' => testDemande.Id,
                //'InwiB2C_Sequence__c' => 1,
                'InwiB2C_Operateur_Infrastructure__c' =>'ORANGE',
                'InwiB2C_NumeroDesignation__c' =>'0788990055',
                'InwiB2C_Nationalid__c' =>'CIN1234',
                'InwiB2C_nd_Attribut__c' =>'0529111637',
                'InwiB2C_lineId__c' => 'w12345678'
            },
           'methodeName' => 'createNewSharingNumber',
           'newCommandePartage' => testCommandePartage.Id,
           'apiResult' => new Map<String, Object>{
                'statut' => 'OK'
          }
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        
        inwiB2C_RecyclageDemandePartage handler = new inwiB2C_RecyclageDemandePartage();
        Boolean result = handler.invokeMethod('continueAfterAPICall', inputMap, outMap, options);

        
        System.assert(result, true);
        System.assert(outMap.containsKey('result'), true);
        
    }
}