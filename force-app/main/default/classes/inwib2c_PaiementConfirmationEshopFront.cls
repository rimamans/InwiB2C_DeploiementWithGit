global without sharing class inwib2c_PaiementConfirmationEshopFront implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;
        try{
            if (methodName.equals('PaiementConfirmation')){
                PaiementConfirmation(inputMap, outMap, options);
            }
        } catch (Exception e){
            result = false;
        }
        return result;
    }
   
    public static void PaiementConfirmation(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Map<String, Object> inputJsonMap = (Map<String, Object>) inputMap.get('bodyCart');
        String PanierId= (String) inputJsonMap.get('cartId');
        System.debug('PaiementObject'+inputJsonMap);
        System.debug('PanierId'+PanierId);
        inwib2c_TraceDemandeEshop__c  traceDemandeEshop =  [select id,IdTraceAPI__c,INWIb2c_Type_de_Commande__c,inwib2c_FMS_Total__c,inwib2c_FMD_Total__c,inwib2c_Prix_Terminal_Total__c,inwib2cReference_Paiement_FMS__c,inwib2cReference_Paiement_FMD__c,inwib2cReference_Paiement_Terminaux__c from inwib2c_TraceDemandeEshop__c where Id =:PanierId];
        System.debug('AmineBouremma: ' +traceDemandeEshop);

         List<Object> Payments = (List<Object>) inputJsonMap.get('Payments');
         List<Map<String, Object>> filteredPayement = new List<Map<String, Object>>();
         String modePayement='';

      for (Object Payment : Payments){
        Map<String, Object> paymentMap = (Map<String, Object>) payment;
        String type = (String) paymentMap.get('type');
        String refpayement = (String) paymentMap.get('refpayement');
        // M-Dj 20/11/24 recuperer le price comme double pas string begin
        // Double price = (Double) paymentMap.get('price');
        String priceStr = (String) paymentMap.get('price');
        Double price = Double.valueOf(priceStr);
        // M-Dj 20/11/24 recuperer le price comme double pas string end
        String payementmode = (String) paymentMap.get('mode');
        // if (payementmode=='EB') {
        //     modePayement='Fatourati';
            
        // }else if (payementmode=='CB') {
        //     modePayement='E-paiement';

            
        // }else {
        //     modePayement='En Espece';
            
        // }
        System.debug('TypeAmineBouremma: ' + type);
        System.debug('Refpayement: ' + refpayement);
        System.debug('Price: ' + price);
        if (type == 'FMS') {
            traceDemandeEshop.inwib2c_FMS_Total__c = price;
            traceDemandeEshop.inwib2cReference_Paiement_FMS__c = refpayement;
        } else if (type == 'FMD') {
            traceDemandeEshop.inwib2c_FMD_Total__c = price;
            traceDemandeEshop.inwib2cReference_Paiement_FMD__c = refpayement;
        } else if (type == 'TERM') {
            traceDemandeEshop.inwib2c_Prix_Terminal_Total__c = price;
            traceDemandeEshop.inwib2cReference_Paiement_Terminaux__c = refpayement;
        } else if (type == 'SIM') {
            System.debug('Amine Bouremma stocker transaction dans table eshop meme champs reference terminaux ' );
            traceDemandeEshop.inwib2cReference_Paiement_Terminaux__c = refpayement;
        }
        // if (payementmode!=null && payementmode!='undefined'&& payementmode!='') {
            
        //     traceDemandeEshop.inwib2c_Mode_de_paiement__c=modePayement;
            
        // }
        System.debug('panier' + traceDemandeEshop);
         update traceDemandeEshop;
        //Store the extracted values 
        // Map<String, Object> extractedValues = new Map<String, Object>();
        // extractedValues.put('type', type);
        // extractedValues.put('refpayement', refpayement);
        // extractedValues.put('price', price);

        // //Add the map to the list
        // filteredPayement.add(extractedValues);
       
    }
    // System.debug('traceId: ' + traceDemandeEshop.IdTraceAPI__c);
    // System.debug('filteredPayements: ' + JSON.serialize(filteredPayement));
    
     // Add the traceId and filteredPayements to the output map
     Map<String, Object> result = new Map<String, Object>();
     //result.put('traceId', traceDemandeEshop.IdTraceAPI__c);
     //result.put('filteredPayements', filteredPayement);
     outMap.put('traceId', traceDemandeEshop.IdTraceAPI__c);
    }
}