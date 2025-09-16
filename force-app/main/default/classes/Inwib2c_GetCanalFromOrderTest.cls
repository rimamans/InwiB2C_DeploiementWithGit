/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Inwib2c_GetCanalFromOrderTest {
    
    // Méthode de test pour la méthode invokeMethod
    @isTest
    public static void testInvokeMethod() {
        
         //Création de données fictives pour un objet Account
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        
        insert testAccount;
        
        // Création de données fictives pour un objet Order
        Order testOrder = new Order(
            Name = 'Test Order',
            InwiB2C_Canal__c = 'Point de vente',
            Status = 'Draft',
            AccountId = testAccount.Id,
            EffectiveDate = Date.today()
        );
        insert testOrder;

        // Préparation des paramètres pour l'appel de la méthode
        Map<String, Object> inputMap = new Map<String, Object>{
            'orderId' => testOrder.Id
        };
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        // Appel de la méthode invokeMethod
        Inwib2c_GetCanalFromOrder instance = new Inwib2c_GetCanalFromOrder();
        Boolean result = instance.invokeMethod('getCanalToOrder', inputMap, outMap, options);

        // Vérification des résultats
        System.assertEquals(true, result, 'La méthode invokeMethod a échoué.');
        System.assertEquals('Point de vente', outMap.get('InwiB2C_Canal__c'), 'Le canal récupéré est incorrect.');
    }

    @isTest
    public static void testInvokeMethodWithError() {
        // Préparation des paramètres sans OrderId pour générer une erreur
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        // Appel de la méthode avec une entrée incorrecte
        Inwib2c_GetCanalFromOrder instance = new Inwib2c_GetCanalFromOrder();
        Boolean result = instance.invokeMethod('getCanalToOrder', inputMap, outMap, options);

        // Vérification que la méthode a bien échoué
        System.assertEquals(false, result, 'La méthode aurait dû échouer en raison de l\'absence d\'OrderId.');
    }
}