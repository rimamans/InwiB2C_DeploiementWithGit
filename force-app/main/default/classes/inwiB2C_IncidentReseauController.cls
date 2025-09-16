global with sharing class inwiB2C_IncidentReseauController {

    @AuraEnabled(cacheable=true)
    global static List<inwib2c_IncidentReseau__c> getIncidentReseau(String choix){
        try {

            Date today = Date.today();

            Date tenDaysAgo = today.addDays(-30);

            System.debug(today.format() + ' - ' + tenDaysAgo.format());

            if(choix =='InwiB2C_GSM'){

                return [SELECT Id, inwib2c_Titre__c, inwib2c_Etat__c, inwib2c_Severite__c, CreatedDate FROM inwib2c_IncidentReseau__c WHERE CreatedDate >= :tenDaysAgo AND InwiB2C_Type__c=:'InwiB2C_GSM' AND inwib2c_Etat__c != 'Résolu' ORDER BY CreatedDate DESC Limit 100];
            
            }
            if(choix =='InwiB2C_FTTH_ADSL'){

                return [SELECT Id, inwib2c_Titre__c, inwib2c_Etat__c, inwib2c_Severite__c, CreatedDate FROM inwib2c_IncidentReseau__c WHERE CreatedDate >= :tenDaysAgo AND InwiB2C_Type__c=:'InwiB2C_FTTH_ADSL' AND inwib2c_Etat__c != 'Résolu' ORDER BY CreatedDate DESC Limit 100];
            
            }
            if(choix =='All'){

                return [SELECT Id, inwib2c_Titre__c, inwib2c_Etat__c, inwib2c_Severite__c, CreatedDate FROM inwib2c_IncidentReseau__c WHERE CreatedDate >= :tenDaysAgo  AND inwib2c_Etat__c != 'Résolu' ORDER BY CreatedDate DESC Limit 100];
            
            }
            
            else {

                return [SELECT Id, inwib2c_Titre__c, inwib2c_Etat__c, inwib2c_Severite__c, CreatedDate FROM inwib2c_IncidentReseau__c WHERE CreatedDate >= :tenDaysAgo  AND inwib2c_Etat__c != 'Résolu' ORDER BY CreatedDate DESC Limit 100];
           
                }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}