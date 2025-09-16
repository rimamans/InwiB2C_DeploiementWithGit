@isTest
private class inwib2c_PaiementConfirmationEshopTEST {
    
    @isTest
    static void testPaiementConfirmationFMS() {
        // Préparation des données de test pour le type de paiement FMS
        inwib2c_TraceDemandeEshop__c trace = new inwib2c_TraceDemandeEshop__c(
            Name = 'Test Trace FMS',
            inwib2c_Statut__c = 'InwiB2C_EnCours',
            inwib2c_Mode_de_paiement__c = 'En Espece',
            inwib2c_FMS_Total__c = 250,
            inwib2c_FMD_Total__c = 100,
            inwib2c_Prix_Terminal_Total__c = 19409,
            inwib2cReference_Paiement_FMS__c = '21546871427',
            inwib2cReference_Paiement_FMD__c = '24962589566',
            inwib2cReference_Paiement_Terminaux__c = '257981114'
        );
        insert trace;

      
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> bodyCart = new Map<String, Object>();
        bodyCart.put('cartId', trace.Id);

        List<Map<String, Object>> payments = new List<Map<String, Object>>();
        Map<String, Object> payment1 = new Map<String, Object>();
        payment1.put('type', 'FMS');
        payment1.put('refpayement', '12345689');
        payment1.put('price', '49');
        payments.add(payment1);

        bodyCart.put('Payments', payments);
        inputMap.put('bodyCart', bodyCart);

        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       // call methode 
        Boolean result = (new inwib2c_PaiementConfirmationEshopFront()).invokeMethod('PaiementConfirmation', inputMap, outMap, options);


        System.assert(result, 'Method execution should succeed.');
        System.assert(outMap.containsKey('traceId'), 'Output map should contain traceId.');

        inwib2c_TraceDemandeEshop__c updatedRecord = [
            SELECT inwib2c_FMS_Total__c, inwib2cReference_Paiement_FMS__c, inwib2cReference_Paiement_Terminaux__c, inwib2c_Mode_de_paiement__c
            FROM inwib2c_TraceDemandeEshop__c WHERE Id = :trace.Id
        ];
        System.assertEquals(49, updatedRecord.inwib2c_FMS_Total__c, 'Expected FMS total to match.');
        System.assertEquals('12345689', updatedRecord.inwib2cReference_Paiement_FMS__c, 'Expected FMS reference to match.');
        System.assertEquals('En Espece', updatedRecord.inwib2c_Mode_de_paiement__c, 'Expected payment mode to match.');
    }

    
    @isTest
    static void testPaiementConfirmationFMD() {
        // Préparation des données de test pour le type de paiement FMD
        inwib2c_TraceDemandeEshop__c trace = new inwib2c_TraceDemandeEshop__c(
            Name = 'Test Trace FMD',
            inwib2c_Statut__c = 'InwiB2C_EnCours',
            inwib2c_Mode_de_paiement__c = 'En Espece',
            inwib2c_FMS_Total__c = 250,
            inwib2c_FMD_Total__c = 100,
            inwib2c_Prix_Terminal_Total__c = 19409,
            inwib2cReference_Paiement_FMS__c = '21546871427',
            inwib2cReference_Paiement_FMD__c = '24962589566',
            inwib2cReference_Paiement_Terminaux__c = '257981114'
        );
        insert trace;

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> bodyCart = new Map<String, Object>();
        bodyCart.put('cartId', trace.Id);

        List<Map<String, Object>> payments = new List<Map<String, Object>>();
        Map<String, Object> paymentFMD = new Map<String, Object>();
        paymentFMD.put('type', 'FMD');
        paymentFMD.put('refpayement', '987654321');
        paymentFMD.put('price', '75');
        payments.add(paymentFMD);

        bodyCart.put('Payments', payments);
        inputMap.put('bodyCart', bodyCart);

        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        // call methode
        Boolean result = (new inwib2c_PaiementConfirmationEshopFront()).invokeMethod('PaiementConfirmation', inputMap, outMap, options);

       
        System.assert(result, 'Method execution should succeed.');
        System.assert(outMap.containsKey('traceId'), 'Output map should contain traceId.');

        inwib2c_TraceDemandeEshop__c updatedRecord = [
            SELECT inwib2c_FMD_Total__c, inwib2cReference_Paiement_FMD__c, inwib2cReference_Paiement_Terminaux__c, inwib2c_Mode_de_paiement__c
            FROM inwib2c_TraceDemandeEshop__c WHERE Id = :trace.Id
        ];
        System.assertEquals(75, updatedRecord.inwib2c_FMD_Total__c, 'Expected FMD total to match.');
        System.assertEquals('987654321', updatedRecord.inwib2cReference_Paiement_FMD__c, 'Expected FMD reference to match.');
        System.assertEquals('En Espece', updatedRecord.inwib2c_Mode_de_paiement__c, 'Expected payment mode to match.');
    }

    @isTest
    static void testPaiementConfirmationTerminal() {
        // Préparation des données de test pour un paiement par Terminal
        inwib2c_TraceDemandeEshop__c trace = new inwib2c_TraceDemandeEshop__c(
            Name = 'Test Trace Terminal',
            inwib2c_Statut__c = 'InwiB2C_EnCours',
            inwib2c_Mode_de_paiement__c = 'En Espece',
            inwib2c_FMS_Total__c = 250,
            inwib2c_FMD_Total__c = 100,
            inwib2c_Prix_Terminal_Total__c = 19409,
            inwib2cReference_Paiement_FMS__c = '21546871427',
            inwib2cReference_Paiement_FMD__c = '24962589566',
            inwib2cReference_Paiement_Terminaux__c = '257981114'
        );
        insert trace;

        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> bodyCart = new Map<String, Object>();
        bodyCart.put('cartId', trace.Id);

        List<Map<String, Object>> payments = new List<Map<String, Object>>();
        Map<String, Object> paymentTerminal = new Map<String, Object>();
        paymentTerminal.put('type', 'Terminal');
        paymentTerminal.put('refpayement', '257981114');
        paymentTerminal.put('price', '19409');
        payments.add(paymentTerminal);

        bodyCart.put('Payments', payments);
        inputMap.put('bodyCart', bodyCart);

        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

       // call methode
        Boolean result = (new inwib2c_PaiementConfirmationEshopFront()).invokeMethod('PaiementConfirmation', inputMap, outMap, options);

    
        System.assert(result, 'Method execution should succeed.');
        System.assert(outMap.containsKey('traceId'), 'Output map should contain traceId.');

        inwib2c_TraceDemandeEshop__c updatedRecord = [
            SELECT inwib2c_FMS_Total__c,inwib2c_Prix_Terminal_Total__c,inwib2cReference_Paiement_FMS__c, inwib2cReference_Paiement_Terminaux__c, inwib2c_Mode_de_paiement__c
            FROM inwib2c_TraceDemandeEshop__c WHERE Id = :trace.Id
        ];
        System.assertEquals(19409, updatedRecord.inwib2c_Prix_Terminal_Total__c, 'Expected terminal price to match.');
        System.assertEquals('257981114', updatedRecord.inwib2cReference_Paiement_Terminaux__c, 'Expected terminal reference to match.');
        System.assertEquals('En Espece', updatedRecord.inwib2c_Mode_de_paiement__c, 'Expected payment mode to match.');
    }
    
    @isTest
     static void testPaiementConfirmationSIM() {
    // Préparation des données de test pour un paiement par SIM
    inwib2c_TraceDemandeEshop__c trace = new inwib2c_TraceDemandeEshop__c(
        Name = 'Test Trace SIM',
        inwib2c_Statut__c = 'InwiB2C_EnCours',
        inwib2c_Mode_de_paiement__c = 'SIM',
        inwib2c_FMS_Total__c = 250,
        inwib2c_FMD_Total__c = 100,
        inwib2c_Prix_Terminal_Total__c = 19409,
        inwib2cReference_Paiement_FMS__c = '21546871427',
        inwib2cReference_Paiement_FMD__c = '24962589566',
        inwib2cReference_Paiement_Terminaux__c = '257981114'
    );
    insert trace;

    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> bodyCart = new Map<String, Object>();
    bodyCart.put('cartId', trace.Id);

    List<Map<String, Object>> payments = new List<Map<String, Object>>();
    Map<String, Object> paymentSIM = new Map<String, Object>();
    paymentSIM.put('type', 'SIM');
    paymentSIM.put('refpayement', '987654321'); 
    paymentSIM.put('price', '150'); 
    payments.add(paymentSIM);

    bodyCart.put('Payments', payments);
    inputMap.put('bodyCart', bodyCart);

    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();

    // Call methode
    Boolean result = (new inwib2c_PaiementConfirmationEshopFront()).invokeMethod('PaiementConfirmation', inputMap, outMap, options);

    System.assert(result, 'Method execution should succeed.');
    System.assert(outMap.containsKey('traceId'), 'Output map should contain traceId.');

    inwib2c_TraceDemandeEshop__c updatedRecord = [
        SELECT inwib2c_FMS_Total__c, inwib2c_Prix_Terminal_Total__c, inwib2cReference_Paiement_FMS__c, 
               inwib2cReference_Paiement_Terminaux__c, inwib2c_Mode_de_paiement__c
        FROM inwib2c_TraceDemandeEshop__c WHERE Id = :trace.Id
    ];

    System.assertEquals('SIM', updatedRecord.inwib2c_Mode_de_paiement__c, 'Expected payment mode to be SIM.');
    System.assertEquals(250, updatedRecord.inwib2c_FMS_Total__c, 'Expected FMS total to match.');
    System.assertEquals(19409, updatedRecord.inwib2c_Prix_Terminal_Total__c, 'Expected terminal total to match.');
    System.assertEquals('987654321', updatedRecord.inwib2cReference_Paiement_Terminaux__c, 'Expected terminal reference to match.');
}

}