/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwIB2C_UpdateStatutSubscription  implements vlocity_cmt.VlocityOpenInterface2 {


   global static boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
      Boolean result = true;
      try {
          if (methodName.equals('publishEvent')) {
              Id subscriptionId = (Id) input.get('subscriptionId');
         
              publishEvent(subscriptionId);
          }
      } catch (Exception e) {
          result = false;
      }
      return result;
  }

  global static void publishEvent(Id subscriptionId) {
       vlocity_cmt__Subscription__c SubObj;
       try {
           SubObj = [SELECT Id, vlocity_cmt__Status__c, inwiB2C_Statut__c,inwiB2C_LegacyStatus__c FROM vlocity_cmt__Subscription__c WHERE Id = :subscriptionId]; 
       } catch (Exception e) {
           System.debug('Error querying vlocity_cmt__Subscription__c: ' + e.getMessage());
           return; // Or perform other error handling as needed.
       }
       
       if (SubObj != null) {
           SubObj.vlocity_cmt__Status__c = 'Expired'; 
           SubObj.inwiB2C_Statut__c = 'InwiB2C_Expired'; 
           SubObj.inwiB2C_LegacyStatus__c = 'Expired'; 

           update SubObj; 

           InwiB2C_UpdateStatutSubscription__e eventObj = new InwiB2C_UpdateStatutSubscription__e(InwiB2C_SubscriptionId__c = SubObj.Id);
           Database.SaveResult sr = EventBus.publish(eventObj); 
           if (sr.isSuccess()) {
               System.debug('Successfully published event');
           } else {
               System.debug('Error while publishing event');
           }
       } else {
           System.debug('No vlocity_cmt__Subscription__c record found with Id: ' + subscriptionId);
       }
   }
}