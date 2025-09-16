/**
 * @description       : Classe pour créer un cas de portabilité fixe
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-19-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class InwiB2C_CreateCasePortaFixe implements vlocity_cmt.VlocityOpenInterface2 {
    
    // Méthode globale invoquée via l'interface VlocityOpenInterface2
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName.equalsIgnoreCase('createCasePortaFixe')) {
                createCasePortaFixe(inputMap, outMap, options); // Appel de la méthode principale
            } else {
                result = false;
                System.debug('Unknown methodName: ' + methodName);
            }
        } catch (Exception e) {
            result = false;
            System.debug('Error in invokeMethod: ' + e.getMessage());
        }
        return result;
    }

    // Méthode pour créer un cas de portabilité fixe
    public static void createCasePortaFixe(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            // Validation de l'entrée
            String orderId = (String) inputMap.get('orderId');
            if (orderId == null) {
                throw new IllegalArgumentException('OrderId cannot be null.');
            }

        // Récupération de l'ordre
         List<Order> ordList = [
         SELECT Id, Account.vlocity_cmt__PersonContactId__c, AccountId
         FROM Order
         WHERE Id = :orderId
         LIMIT 1
     ];
           Order ord = ordList.isEmpty() ? null : ordList[0];

        // Récupération de inwiB2C_OrderSubscription__c
     List<inwiB2C_OrderSubscription__c> ordSubList = [
     SELECT Id, inwiB2C_Subscription__c
     FROM inwiB2C_OrderSubscription__c
     WHERE inwiB2C_Order__c = :orderId
     LIMIT 1
   ];
     inwiB2C_OrderSubscription__c ordSub = ordSubList.isEmpty() ? null : ordSubList[0];

      // Récupération des métadonnées
     List<InwiB2C_GestionDeCasePortaFixe__mdt> metaDataList = [
      SELECT Id, InwiB2C_Categorie__c, InwB2C_Statut__c, InwiB2C_Detail__c, 
           Inwib2c_la_file_d_attente__c, InwiB2C_Type__c, InwiB2C_Type_de_specialite__c, 
           InwiB2C_Description__c, InwiB2C_Subject__c
      FROM InwiB2C_GestionDeCasePortaFixe__mdt
    LIMIT 1
   ];
       InwiB2C_GestionDeCasePortaFixe__mdt metaData = metaDataList.isEmpty() ? null : metaDataList[0];

            // Création du cas
            Case newCase = new Case(
                AccountId = ord.AccountId,
                ContactId = ord.Account.vlocity_cmt__PersonContactId__c,
                vlocity_cmt__SubscriptionId__c = ordSub.inwiB2C_Subscription__c,
                Status = metaData.InwB2C_Statut__c,                
                Inwib2c_Cat_gorie__c = metaData.InwiB2C_Categorie__c,
                InwiB2C_Detail__c = metaData.InwiB2C_Detail__c,
                Type = metaData.InwiB2C_Type__c,
                InwiB2C_TypeSpecialite__c = metaData.InwiB2C_Type_de_specialite__c,
                Inwib2c_la_file_d_attente__c = metaData.Inwib2c_la_file_d_attente__c,
                Subject  = metaData.InwiB2C_Subject__c,
                Description =metaData.InwiB2C_Description__c
                
            );
            
            // Insertion du cas
            insert newCase;
            outMap.put('caseId', newCase.Id);
            System.debug('Case created successfully: ' + newCase.Id);

        } catch (Exception e) {
            System.debug('Error in createCasePortaFixe: ' + e.getMessage());
        }
    }
}