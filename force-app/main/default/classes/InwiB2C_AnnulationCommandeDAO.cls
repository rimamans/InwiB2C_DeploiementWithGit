public with sharing class InwiB2C_AnnulationCommandeDAO {
    @AuraEnabled
    public static Boolean getOrderJustificatif(Id OrderId) {
        // Vérification que l'ID n'est pas nul pour éviter les erreurs
        if (OrderId == null) {
            throw new AuraHandledException('OrderId ne peut pas être nul.');
        }
        
        // Récupération de l'enregistrement
        Order order = [SELECT OrderStep__c FROM Order WHERE Id = :OrderId LIMIT 1];
        
        // Retourne true si OrderStep__c est 'Justificatif', sinon false
        return order.OrderStep__c == 'Justificatif';
    }
}


// public class InwiB2C_AnnulationCommandeDAO {
//     @AuraEnabled
//     public static Boolean getOrderJustificatif() {
//         Boolean orderState = true;
//         return orderState;

//         // Order order = [SELECT OrderStep__c FROM Order WHERE Id = :OrderId LIMIT 1]
//         // return order.OrderStep__c == 'Justificatif';
//     }
// }