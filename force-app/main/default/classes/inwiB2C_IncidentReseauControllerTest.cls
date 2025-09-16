@isTest
 public with sharing class inwiB2C_IncidentReseauControllerTest {
 
     
  @isTest(SeeAllData=true)
    static void testOneIncident (){
    
        inwib2c_IncidentReseau__c newIncident = new inwib2c_IncidentReseau__c();

        newIncident.inwib2c_Titre__c = 'Nouvel  Reseau';
        newIncident.inwib2c_Etat__c = 'En cours';
        newIncident.inwib2c_Severite__c = 'Critique';
        newIncident.InwiB2C_Type__c = 'InwiB2C_GSM';
        insert newIncident;
        
        inwib2c_IncidentReseau__c newIncident2 = new inwib2c_IncidentReseau__c();

        newIncident2.inwib2c_Titre__c = 'Nouvel inc Reseau';
        newIncident2.inwib2c_Etat__c = 'En cours';
        newIncident2.inwib2c_Severite__c = 'Critique';
        newIncident2.InwiB2C_Type__c = 'InwiB2C_FTTH_ADSL';
        insert newIncident2;
String choix='InwiB2C_FTTH_ADSL';

        List<inwib2c_IncidentReseau__c> returnedIncident = inwiB2C_IncidentReseauController.getIncidentReseau(choix);

  choix='InwiB2C_GSM';

        List<inwib2c_IncidentReseau__c> returnedIncident3 = inwiB2C_IncidentReseauController.getIncidentReseau(choix);




choix=null;
               
          List<inwib2c_IncidentReseau__c> returnedIncident2 = inwiB2C_IncidentReseauController.getIncidentReseau(choix);
  



        
        
        
      }   
    }