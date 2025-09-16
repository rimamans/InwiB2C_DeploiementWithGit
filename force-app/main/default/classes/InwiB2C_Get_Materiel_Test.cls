@isTest
public class InwiB2C_Get_Materiel_Test {
@isTest (SeeAllData=true) 
    private static void testMateriel(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount = new Account();
        testAccount.Name = 'Agence CMS01';
        testAccount.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = 'CMS01',
                                                                                            InwiB2C_Agence__c = testAccount.Id,
                                                                                            InwiB2C_Modele__c = 'BOX 4G TOZED ZLT S10',
                                                                                            InwiB2C_Code_Article__c ='100001979',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
  @isTest (SeeAllData=true) 
     private static void testMateriel2(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount2 = new Account();
        testAccount2.Name = 'Agence CMS01';
        testAccount2.inwib2c_CodePartenaire__c='CMS01';
        
  
          InwiB2C_Gestion_mat_riel__c newGestionMateriel2 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = 'CMS01',
                                                                                            InwiB2C_Agence__c = testAccount2.Id,
                                                                                            InwiB2C_Modele__c = 'BOX 4G TOZED ZLT S10',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel2; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel2.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel2.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel2.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel2.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel2.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel2.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel2.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    
     @isTest (SeeAllData=true) 
     private static void testMateriel3(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount3 = new Account();
        testAccount3.Name = 'Agence CMS01';
        testAccount3.inwib2c_CodePartenaire__c='CMS01';
        
  
          InwiB2C_Gestion_mat_riel__c newGestionMateriel3 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = 'CMS01',
                                                                                            InwiB2C_Agence__c = testAccount3.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel3; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel3.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel3.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel3.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel3.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel3.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel3.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel3.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    
     @isTest (SeeAllData=true) 
     private static void testMateriel4(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount4 = new Account();
        testAccount4.Name = 'Agence CMS01';
        testAccount4.inwib2c_CodePartenaire__c='CMS01';
        
  
          InwiB2C_Gestion_mat_riel__c newGestionMateriel4 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = 'CMS01',
                                                                                            InwiB2C_Agence__c = testAccount4.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='453748392', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel4; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel4.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel4.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel4.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel4.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel4.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel4.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel4.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    @isTest (SeeAllData=true) 
     private static void testMateriel5(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount5 = new Account();
        testAccount5.Name = 'Agence CMS01';
        testAccount5.inwib2c_CodePartenaire__c='CMS01';
        
  
          InwiB2C_Gestion_mat_riel__c newGestionMateriel5 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = 'CMS01',
                                                                                            InwiB2C_Agence__c = testAccount5.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='13476945',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel5; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel5.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel5.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel5.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel5.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel5.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel5.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel5.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
     @isTest (SeeAllData=true) 
     private static void testMateriel6(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount6 = new Account();
        testAccount6.Name = 'Agence CMS01';
        testAccount6.inwib2c_CodePartenaire__c='CMS01';
        
  
          InwiB2C_Gestion_mat_riel__c newGestionMateriel6 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = 'CMS01',
                                                                                            InwiB2C_Agence__c = testAccount6.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel6; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel6.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel6.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel6.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel6.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel6.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel6.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel6.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    @isTest (SeeAllData=true) 
    private static void testMateriel7(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount7 = new Account();
        testAccount7.Name = 'Agence CMS01';
        testAccount7.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel7 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount7.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel7; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel7.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel7.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel7.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel7.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel7.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel7.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel7.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    
     @isTest (SeeAllData=true) 
    private static void testMateriel8(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount8 = new Account();
        testAccount8.Name = 'Agence CMS01';
        testAccount8.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel8 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount8.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel8; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel8.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel8.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel8.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel8.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel8.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel8.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel8.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    
     @isTest (SeeAllData=true) 
    private static void testMateriel9(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount9 = new Account();
        testAccount9.Name = 'Agence CMS01';
        testAccount9.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel9 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount9.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel9; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel9.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel9.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel9.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel9.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel9.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel9.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel9.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    @isTest (SeeAllData=true) 
    private static void testMateriel10(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount10 = new Account();
        testAccount10.Name = 'Agence CMS01';
        testAccount10.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel10 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount10.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel10; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel10.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel10.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel10.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel10.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel10.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel10.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel10.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
     @isTest (SeeAllData=true) 
    private static void testMateriel11(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount11 = new Account();
        testAccount11.Name = 'Agence CMS01';
        testAccount11.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel11 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount11.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel11; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel11.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel11.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel11.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel11.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel11.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel11.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel11.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
     @isTest (SeeAllData=true) 
    private static void testMateriel12(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount12 = new Account();
        testAccount12.Name = 'Agence CMS01';
        testAccount12.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel12 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount12.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='7356774',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel12; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel12.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel12.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel12.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel12.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel12.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel12.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel12.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
 @isTest (SeeAllData=true) 
    private static void testMateriel13(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount13 = new Account();
        testAccount13.Name = 'Agence CMS01';
        testAccount13.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel13 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount13.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel13; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel13.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel13.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel13.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel13.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel13.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel13.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel13.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
     @isTest (SeeAllData=true) 
    private static void testMateriel14(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount14 = new Account();
        testAccount14.Name = 'Agence CMS01';
        testAccount14.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel14 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '212123456789',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount14.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel14; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel14.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel14.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel14.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel14.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel14.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel14.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel14.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    @isTest (SeeAllData=true) 
    private static void testMateriel15(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount15 = new Account();
        testAccount15.Name = 'Agence CMS01';
        testAccount15.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel15 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount15.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel15; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel15.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel15.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel15.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel15.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel15.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel15.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel15.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
     @isTest (SeeAllData=true) 
    private static void testMateriel16(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount16 = new Account();
        testAccount16.Name = 'Agence CMS01';
        testAccount16.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel16 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount16.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='25547549',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel16; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel16.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel16.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel16.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel16.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel16.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel16.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel16.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    @isTest (SeeAllData=true) 
    private static void testMateriel17(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount17 = new Account();
        testAccount17.Name = 'Agence CMS01';
        testAccount17.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel17 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount17.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel17; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel17.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel17.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel17.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel17.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel17.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel17.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel17.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
    @isTest (SeeAllData=true) 
    private static void testMateriel18(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount18 = new Account();
        testAccount18.Name = 'Agence CMS01';
        testAccount18.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel18 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount18.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel18; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel18.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel18.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel18.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel18.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel18.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel18.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel18.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);   
    }
    @isTest (SeeAllData=true) 
    private static void testMateriel19(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount19 = new Account();
        testAccount19.Name = 'Agence CMS01';
        testAccount19.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel19 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount19.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='987645645',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel19; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel19.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel19.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel19.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel19.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel19.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel19.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel19.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
      @isTest (SeeAllData=true) 
    private static void testMateriel20(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount20 = new Account();
        testAccount20.Name = 'Agence CMS01';
        testAccount20.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel20 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount20.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='987645645',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel20; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel20.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel20.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel20.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel20.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel20.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel20.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel20.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
          @isTest (SeeAllData=true) 
    private static void testMateriel21(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount21 = new Account();
        testAccount21.Name = 'Agence CMS01';
        testAccount21.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel21 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount21.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='987645645',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel21; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel21.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel21.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel21.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel21.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel21.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel21.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel21.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
  @isTest (SeeAllData=true) 
    private static void testMateriel22(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount22 = new Account();
        testAccount22.Name = 'Agence CMS01';
        testAccount22.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel22 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount22.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel22; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel22.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel22.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel22.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel22.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel22.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel22.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel22.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
   @isTest (SeeAllData=true) 
    private static void testMateriel23(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount23 = new Account();
        testAccount23.Name = 'Agence CMS01';
        testAccount23.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel23 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount23.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel23; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel23.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel23.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel23.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel23.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel23.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel23.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel23.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }
     @isTest (SeeAllData=true) 
    private static void testMateriel24(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount24 = new Account();
        testAccount24.Name = 'Agence CMS01';
        testAccount24.inwib2c_CodePartenaire__c='CMS01';
        
  
         
           InwiB2C_Gestion_mat_riel__c newGestionMateriel24 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount24.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel24; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel24.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel24.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel24.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel24.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel24.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel24.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel24.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }    
    @isTest (SeeAllData=true) 
    private static void testMateriel25(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount25 = new Account();
        testAccount25.Name = 'Agence CMS01';
        testAccount25.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel25 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount25.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='77667766',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123456789123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel25; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel25.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel25.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel25.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel25.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel25.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel25.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel25.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }    

    @isTest (SeeAllData=true) 
    private static void testMateriel26(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount26 = new Account();
        testAccount26.Name = 'Agence CMS01';
        testAccount26.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel26 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount26.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123456789123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel26; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel26.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel26.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel26.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel26.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel26.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel26.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel26.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }    
    @isTest (SeeAllData=true) 
    private static void testMateriel27(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount27 = new Account();
        testAccount27.Name = 'Agence CMS01';
        testAccount27.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel27 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount27.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123456789123', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel27; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel27.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel27.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel27.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel27.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel27.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel27.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel27.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel28(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount28 = new Account();
        testAccount28.Name = 'Agence CMS01';
        testAccount28.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel28 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount28.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='123456789123', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel28; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel28.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel28.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel28.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel28.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel28.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel28.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel28.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }   
    
    @isTest (SeeAllData=true) 
    private static void testMateriel29(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount29 = new Account();
        testAccount29.Name = 'Agence CMS01';
        testAccount29.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel29 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount29.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='12345677',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel29; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel29.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel29.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel29.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel29.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel29.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel29.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel29.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }   
    @isTest (SeeAllData=true) 
    private static void testMateriel30(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount30 = new Account();
        testAccount30.Name = 'Agence CMS01';
        testAccount30.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel30 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount30.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel30; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel30.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel30.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel30.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel30.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel30.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel30.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel30.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    } 
    @isTest (SeeAllData=true) 
    private static void testMateriel31(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount31 = new Account();
        testAccount31.Name = 'Agence CMS01';
        testAccount31.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel31 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount31.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel31; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel31.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel31.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel31.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel31.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel31.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel31.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel31.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }   
    @isTest (SeeAllData=true) 
    private static void testMateriel32(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount32 = new Account();
        testAccount32.Name = 'Agence CMS01';
        testAccount32.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel32 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount32.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='123456878',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel32; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel32.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel32.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel32.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel32.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel32.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel32.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel32.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel33(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount33 = new Account();
        testAccount33.Name = 'Agence CMS01';
        testAccount33.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel33 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount33.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='123456878',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel33; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel33.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel33.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel33.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel33.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel33.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel33.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel33.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel34(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount34 = new Account();
        testAccount34.Name = 'Agence CMS01';
        testAccount34.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel34 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '21269999999',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount34.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel34; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel34.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel34.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel34.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel34.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel34.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel34.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel34.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }   
    @isTest (SeeAllData=true) 
    private static void testMateriel35(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount35 = new Account();
        testAccount35.Name = 'Agence CMS01';
        testAccount35.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel35 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount35.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='347684985335',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='21269999999', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel35; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel35.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel35.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel35.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel35.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel35.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel35.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel35.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }   
    @isTest (SeeAllData=true) 
    private static void testMateriel36(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount36 = new Account();
        testAccount36.Name = 'Agence CMS01';
        testAccount36.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel36 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount36.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='21269999999', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel36; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel36.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel36.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel36.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel36.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel36.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel36.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel36.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }   
    @isTest (SeeAllData=true) 
    private static void testMateriel37(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount37 = new Account();
        testAccount37.Name = 'Agence CMS01';
        testAccount37.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel37 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount37.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='21269999999', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel37; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel37.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel37.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel37.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel37.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel37.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel37.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel37.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel38(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount38 = new Account();
        testAccount38.Name = 'Agence CMS01';
        testAccount38.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel38 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount38.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='132325678',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='21269999999', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel38; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel38.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel38.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel38.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel38.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel38.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel38.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel38.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel39(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount39 = new Account();
        testAccount39.Name = 'Agence CMS01';
        testAccount39.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel39 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount39.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='132325678',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='21269999999', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel39; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel39.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel39.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel39.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel39.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel39.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel39.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel39.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel40(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount40 = new Account();
        testAccount40.Name = 'Agence CMS01';
        testAccount40.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel40 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount40.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='21269999999', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel40; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel40.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel40.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel40.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel40.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel40.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel40.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel40.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel41(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount41 = new Account();
        testAccount41.Name = 'Agence CMS01';
        testAccount41.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel41 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount41.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='234679',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel41; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel41.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel41.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel41.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel41.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel41.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel41.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel41.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel42(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount42 = new Account();
        testAccount42.Name = 'Agence CMS01';
        testAccount42.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel42 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount42.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='234679',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel42; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel42.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel42.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel42.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel42.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel42.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel42.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel42.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel43(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount43 = new Account();
        testAccount43.Name = 'Agence CMS01';
        testAccount43.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel43 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount43.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel43; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel43.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel43.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel43.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel43.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel43.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel43.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel43.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel44(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount44 = new Account();
        testAccount44.Name = 'Agence CMS01';
        testAccount44.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel44 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount44.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='12357',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel44; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel44.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel44.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel44.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel44.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel44.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel44.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel44.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  


    //Combinaisons 4a4

    @isTest (SeeAllData=true) 
    private static void testMateriel45(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount45 = new Account();
        testAccount45.Name = 'Agence CMS01';
        testAccount45.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel45 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount45.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='12357',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='34567890643', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel45; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel45.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel45.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel45.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel45.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel45.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel45.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel45.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel46(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount46 = new Account();
        testAccount46.Name = 'Agence CMS01';
        testAccount46.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel46 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount46.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='34567890643', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel46; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel46.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel46.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel46.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel46.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel46.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel46.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel46.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    
    @isTest (SeeAllData=true) 
    private static void testMateriel47(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount47 = new Account();
        testAccount47.Name = 'Agence CMS01';
        testAccount47.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel47 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount47.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='34567890643', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel47; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel47.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel47.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel47.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel47.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel47.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel47.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel47.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel48(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount48 = new Account();
        testAccount48.Name = 'Agence CMS01';
        testAccount48.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel48 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount48.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='4590873',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='34567890643', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel48; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel48.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel48.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel48.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel48.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel48.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel48.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel48.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel49(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount49 = new Account();
        testAccount49.Name = 'Agence CMS01';
        testAccount49.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel49 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount49.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='4590873',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='34567890643', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel49; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel49.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel49.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel49.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel49.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel49.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel49.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel49.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  


    @isTest (SeeAllData=true) 
    private static void testMateriel50(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount50 = new Account();
        testAccount50.Name = 'Agence CMS01';
        testAccount50.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel50 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount50.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='34567890643', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel50; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel50.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel50.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel50.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel50.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel50.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel50.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel50.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel51(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount51 = new Account();
        testAccount51.Name = 'Agence CMS01';
        testAccount51.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel51 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount51.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel51; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel51.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel51.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel51.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel51.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel51.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel51.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel51.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel52(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount52 = new Account();
        testAccount52.Name = 'Agence CMS01';
        testAccount52.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel52 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount52.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel52; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel52.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel52.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel52.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel52.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel52.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel52.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel52.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel53(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount53 = new Account();
        testAccount53.Name = 'Agence CMS01';
        testAccount53.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel53 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '123344567',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount53.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel53; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel53.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel53.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel53.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel53.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel53.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel53.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel53.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel54(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount54 = new Account();
        testAccount54.Name = 'Agence CMS01';
        testAccount54.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel54 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount54.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='4896878389974', 
                                                                                            InwiB2C_Consign__c = 'Tous',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel54; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel54.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel54.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel54.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel54.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel54.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel54.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel54.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  
    @isTest (SeeAllData=true) 
    private static void testMateriel55(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount55 = new Account();
        testAccount55.Name = 'Agence CMS01';
        testAccount55.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel55 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount55.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='4896878389974', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Tous');
                                                                                            
                                                                                     
        
         insert newGestionMateriel55; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel55.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel55.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel55.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel55.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel55.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel55.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel55.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel56(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount56 = new Account();
        testAccount56.Name = 'Agence CMS01';
        testAccount56.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel56 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount56.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='4896878389974', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = '',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel56; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel56.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel56.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel56.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel56.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel56.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel56.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel56.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  

    @isTest (SeeAllData=true) 
    private static void testMateriel57(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account testAccount57 = new Account();
        testAccount57.Name = 'Agence CMS01';
        testAccount57.inwib2c_CodePartenaire__c='CMS01';
        
  
         
        InwiB2C_Gestion_mat_riel__c newGestionMateriel57 = new InwiB2C_Gestion_mat_riel__c(inwib2c_num_ro_de_la_ligne__c = '',
                                                                                            InwiB2C_Code_Agence__c = '',
                                                                                            InwiB2C_Agence__c = testAccount57.Id,
                                                                                            InwiB2C_Modele__c = '',
                                                                                            InwiB2C_Code_Article__c ='1234',
                                                                                            InwiB2C_Num_ro_de_s_rie__c ='', 
                                                                                            InwiB2C_Consign__c = 'Oui',
                                                                                            InwiB2C_Code_Agence_Init__c = 'CMS01',
                                                                                            InwiB2C_Statut_de_retour__c='Check_visuel_OK');
                                                                                            
                                                                                     
        
         insert newGestionMateriel57; 
        
         
       
        
        inputMap.put('NumeroLigne',newGestionMateriel57.inwib2c_num_ro_de_la_ligne__c);
        inputMap.put('Agence',newGestionMateriel57.InwiB2C_Agence__c);
        inputMap.put('NumeroSerie',newGestionMateriel57.InwiB2C_Num_ro_de_s_rie__c);
        inputMap.put('Cons',newGestionMateriel57.InwiB2C_Consign__c);
        inputMap.put('StatRouteur',newGestionMateriel57.InwiB2C_Statut_de_retour__c);
        inputMap.put('AgenceVente',newGestionMateriel57.InwiB2C_Code_Agence_Init__c);
        inputMap.put('Codearticle',newGestionMateriel57.InwiB2C_Code_Article__c);
        inputMap.put('profil',false);
         
        new InwiB2C_Get_Materiel().invokeMethod('get_Materiel_retour',inputMap,outMap,options);
         
        
        
    }  




}