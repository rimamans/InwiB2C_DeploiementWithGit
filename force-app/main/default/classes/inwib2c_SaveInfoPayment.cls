/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-27-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class inwib2c_SaveInfoPayment implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;
        Map<String, Object> operationResultInfo = new Map<String, Object>();
        try{
            if (methodName.equals('SaveInfoPayment')){
                operationResultInfo = SaveInfoPayment(inputMap, outMap, options);
            }
        } catch (Exception e){
            result = false;
            operationResultInfo = new Map<String, Object>{
                'errorCode' => 'ERROR',
                'isOK' => 0,
                'uuid' => 'error-uuid-Amine-Brm',
                'errorMessage' => 'Erreur Lors de La Mise a jour des Articles'
            };
        }
        outMap.put('CSSavePaymentResultInfo', operationResultInfo );
        return result;
    }
   
    public static Map<String, Object> SaveInfoPayment(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Map<String, Object> result = new Map<String, Object>();
        
        
     
            
        Map<String, Object> inputJsonMap = (Map<String, Object>) inputMap.get('bodyCart');
        Map<String, Object> CSOperationInfo = (Map<String, Object>) inputJsonMap.get('CSOperationInfo');

        String orderid= (String) inputJsonMap.get('cartId');
        String uuid = (String) CSOperationInfo.get('uuid');
        System.debug('PaiementObject'+inputJsonMap);
        System.debug('orderid'+orderid);
      
      try {   
                 Order  commande = [select id,InwiB2C_FMS_Total__c, InwiB2C_FMD_Total__c, InwiB2C_Code_de_transaction_FMS__c, InwiB2C_Mode_de_paiement_FMS__c, InwiB2C_CodeTransactionFMD__c, Mode_de_paiement_FMD__c, inwib2c_CodeDeTransaction__c, inwib2c_ModeDePaiement__c, InwiB2C_IdTransactionEVC__c from Order where Id =:orderid];

                 OrderItem  ItemProduct = [select id,InwiB2C_FMS__c, InwiB2C_FMS_Catalogue__c,inwib2c_ModeDePaiement_FMS__c, InwiB2C_TransactionCode_FMS__c,InwiB2C_FMD__c, InwiB2C_FMD_Catalogue__c, InwiB2C_TransactionCode_FMD__c,inwib2c_TransactionCode__c, inwib2c_ModeDePaiement__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__EffectiveOneTimeTotal__c from OrderItem where OrderId =:orderid AND vlocity_cmt__ParentItemId__c=null order by CreatedDate desc limit 1] ;
                
                 Double simAndTermTotalPrice = 0;

         List<Object> Payments = (List<Object>) inputJsonMap.get('Payments');
         List<Map<String, Object>> filteredPayement = new List<Map<String, Object>>();
         String modePayement='';



      for (Object Payment : Payments){
        Map<String, Object> paymentMap = (Map<String, Object>) payment;
        String type = (String) paymentMap.get('type');
        String refpayement = (String) paymentMap.get('refpayement');
        String priceStr = (String) paymentMap.get('price');
        Double price = Double.valueOf(priceStr);
        String paymentMethod = (String) paymentMap.get('mode');
        // M-DJ 27/08/25 papillon lot 2 begin
        String pspReference = (String) paymentMap.get('pspReference');
        // M-DJ 27/08/25 papillon lot 2 end
       
 
      // Vérification du mode de paiement et attribution de la valeur correspondante sur CRM
               if (paymentMethod=='CB') {
                    modePayement='inwiB2C_E-paiement';  
                    
                }else if (paymentMethod == 'EB') {
                    modepayement = 'inwiB2C_Fatourati';
               }else if(paymentMethod == 'ES' || paymentMethod=='CS') {
                   modePayement='inwiB2C_EnEspece'; 
                    // M-DJ 27/08/25 papillon lot 2 begin
                    } else if (paymentMethod == 'DL') {
                        modePayement='InwiB2C_Dealer';
                    }
                    // M-DJ 27/08/25 papillon lot 2 end


        System.debug('TypeAmineBouremma: ' + type);
        System.debug('Refpayement: ' + refpayement);
        System.debug('Price: ' + price);
        if (type == 'FMS') {
            //commande.InwiB2C_FMS_Total__c = price;
            commande.InwiB2C_Code_de_transaction_FMS__c = refpayement;
            commande.InwiB2C_Mode_de_paiement_FMS__c = modePayement;
            // M-DJ 27/08/25 papillon lot 2 begin
            commande.InwiB2C_IdTransactionEVC__c = pspReference;
            // M-DJ 27/08/25 papillon lot 2 end
            ItemProduct.InwiB2C_FMS__c = price;
            ItemProduct.InwiB2C_TransactionCode_FMS__c = refpayement;
            ItemProduct.inwib2c_ModeDePaiement_FMS__c = modePayement;
            update commande;
        } else if (type == 'FMD') {
            //commande.InwiB2C_FMD_Total__c = price;
            commande.InwiB2C_CodeTransactionFMD__c = refpayement;
            commande.Mode_de_paiement_FMD__c = modePayement;
            // M-DJ 27/08/25 papillon lot 2 begin
            commande.InwiB2C_IdTransactionEVC__c = pspReference;
            // M-DJ 27/08/25 papillon lot 2 end
            ItemProduct.InwiB2C_FMD__c = price;
            ItemProduct.InwiB2C_TransactionCode_FMD__c = refpayement;
            ItemProduct.inwib2c_ModeDePaiement__c = modePayement;
            update commande;
         } else if (type == 'TERM') {
            OrderItem  ItemTerminal = new OrderItem(); 
            if(!Test.isRunningTest()){
               System.debug('Is Not Running test');
              ItemTerminal = [select id,inwib2c_ModeDePaiement__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId =:orderid order by CreatedDate desc limit 1] ;
            }else {
              ItemTerminal = [select id,inwib2c_ModeDePaiement__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeTotal__c from OrderItem where OrderId =:orderid  order by CreatedDate desc limit 1] ;
              System.debug('Running test ');
                
            }
            commande.inwib2c_CodeDeTransaction__c = refpayement;
            commande.inwib2c_ModeDePaiement__c = modePayement;
            // M-DJ 27/08/25 papillon lot 2 begin
            commande.InwiB2C_IdTransactionEVC__c = pspReference;
            // M-DJ 27/08/25 papillon lot 2 end

            ItemProduct.inwib2c_TransactionCode__c = refpayement;
            ItemProduct.inwib2c_ModeDePaiement__c = modePayement;
            ItemTerminal.vlocity_cmt__OneTimeTotal__c=price;
            ItemTerminal.vlocity_cmt__OneTimeCharge__c=price;
            ItemTerminal.vlocity_cmt__OneTimeCalculatedPrice__c=price;
            // update ItemTerminal;
            // update commande;
            List<SObject> recordsToUpdate = new List<SObject> { ItemTerminal, commande };
            update recordsToUpdate;
            simAndTermTotalPrice += price;
          
       }
           else if (type == 'SIM') {
            
            OrderItem  ItemSIM = new OrderItem(); 
            if(!Test.isRunningTest()){
            ItemSIM = [select id,inwib2c_ModeDePaiement__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeCalculatedPrice__c from OrderItem where OrderId =:orderid AND Product2.Name=:'SIM' order by CreatedDate desc limit 1] ;
             }else {
                ItemSIM = [select id,inwib2c_ModeDePaiement__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeCalculatedPrice__c from OrderItem where OrderId =:orderid  order by CreatedDate desc limit 1] ;
             }    
             commande.inwib2c_CodeDeTransaction__c = refpayement;
             commande.inwib2c_ModeDePaiement__c = modePayement;
             // M-DJ 27/08/25 papillon lot 2 begin
             commande.InwiB2C_IdTransactionEVC__c = pspReference;
             // M-DJ 27/08/25 papillon lot 2 end
             ItemProduct.inwib2c_TransactionCode__c = refpayement;
             ItemProduct.inwib2c_ModeDePaiement__c = modePayement;
             ItemSIM.vlocity_cmt__OneTimeTotal__c=price;
             ItemSIM.vlocity_cmt__OneTimeCharge__c=price;
             ItemSIM.vlocity_cmt__OneTimeCalculatedPrice__c	=price;
            //  update ItemSIM;
            //  update commande;
            List<SObject> recordsToUpdate = new List<SObject> { ItemSIM, commande };
            update recordsToUpdate;
            simAndTermTotalPrice += price;
           

            
            
        }
      

        
      
       
     }
               ItemProduct.vlocity_cmt__OneTimeTotal__c=simAndTermTotalPrice;
               ItemProduct.vlocity_cmt__EffectiveOneTimeTotal__c=simAndTermTotalPrice;
               update ItemProduct;
            result.put('CSOperationResultInfo', new Map<String, Object>{
                  'errorCode' => '',
                  'errorMessage' => 'SUCCESS',
                  'isOK' => 1,
                  'uuid' => uuid
            });
      } catch (Exception e) {
              System.debug('Error message: ' + e.getMessage());
              System.debug('Stack trace: ' + e.getStackTraceString());
          
                                    result.put('CSOperationResultInfo', new Map<String, Object>{
                                        'errorCode' => 'ERROR',
                                        'errorMessage' => 'Erreur Lors de La Mise a jour des Informations de paiement',
                                        'isOK' => 0,
                                        'uuid' => uuid
                                    });
            
    }
    
     
    return result;
    }



}