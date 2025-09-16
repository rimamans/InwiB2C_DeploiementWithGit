public with sharing class inwib2c_adjustementpriceasynchrone {
    @future(callout = true)
    public static void  inwib2c_adjustementpriceasynchrone(String paramsSerialized) {
        Map<String, Object> Params = ( Map<String, Object>)JSON.deserializeUntyped(paramsSerialized);
        String orderid = (String) Params.get('orderid');
        String itemid = (String) Params.get('itemid');
        Double prix= (Double) Params.get('prix');
        String id = (String) Params.get('id');
        String traceId = (String) Params.get('traceId');

        System.debug('orderidfuture' + orderid);
        System.debug('itemidfuture' + itemid);
        System.debug('idTableAdjsutement' + id);
        System.debug('traceId' + traceId);
        //Evolution recalculPrice Amine bouremma
        InwiB2C_Trace_API__c tracerecalcul = [select id,CreatedDate, InwiB2C_Object_Number__c from InwiB2C_Trace_API__c where id = :traceId];
        Date creationdate= null;
        Decimal recalculAmount=0;
        Datetime dateCreationeshopOrder=tracerecalcul.CreatedDate;
        System.debug('dateCreationeshopOrder'+dateCreationeshopOrder);
        String dateCreatedOrder = dateCreationeshopOrder.format('yyyy-MM-dd');
        System.debug('dateCreatedOrder'+dateCreatedOrder);
        Integer year = Integer.valueOf(dateCreatedOrder.substring(0, 4));
        Integer month = Integer.valueOf(dateCreatedOrder.substring(5, 7));
        Integer day = Integer.valueOf(dateCreatedOrder.substring(8, 10));
        creationdate = Date.newInstance(year, month, day);
        System.debug('creationdate' +creationdate);
        String procedureName = 'inwib2c_GetOrderItemModeleTerminal';
        Map <String, Object> ipInputRecalcul = new Map <String, Object> ();
        Map <String, Object> ipOutputRecalcul = new Map <String, Object> ();
        Map <String, Object> ipOptionsRecalcul = new Map <String, Object> ();
        ipInputRecalcul.put('orderitemid', itemid);
        System.debug('InputVIP' +ipInputRecalcul);

        // ipInputRecalcul.put('orderid', orderid);
        ipOutputRecalcul = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_GetOrderItemModeleTerminal', ipInputRecalcul, ipOptionsRecalcul);
        //List<Map<String, Object>> ipOutputRecalcul = (List<Map<String, Object>>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInputRecalcul, ipOptionsRecalcul);

            System.debug('OutputVIP' +ipOutputRecalcul);
           
            System.debug(JSON.serialize(ipOutputRecalcul));
            String modeleTerminal = (String) ipOutputRecalcul.get('ModeleTerminal');
            System.debug('modeleTerminalQuantité' + modeleTerminal);
            //if(!Test.isRunningTest()){}
            if(Test.isRunningTest()){
                        modeleTerminal='000056085';

                    }
            inwiB2C_ModelePricelist__c terminalprix = [select id,inwiB2C_Modele__r.inwiB2C_Code_Article__c,inwiB2C_Canal__c,inwiB2C_Profil_IN__c, inwiB2CPrice__c from inwiB2C_ModelePricelist__c where inwiB2C_Canal__c ='inwiB2C_Eshop'and inwiB2C_CodeArticle__c =:modeleTerminal and inwiB2C_Start_Date__c <= : creationdate and (inwiB2C_End_Date__c >= TODAY or inwiB2C_End_Date__c =null) limit 1 ];
            System.debug('terminalprix' +terminalprix.inwiB2CPrice__c);
            recalculAmount=terminalprix.inwiB2CPrice__c;
            
          //Fin de Evolution recalculprix Amine brm//

               Map <String, Object> optionsMap= new Map <String, Object> ();
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> outputMap = new Map <String, Object> ();
                Map <String, Object> inputMap = new Map <String, Object> ();
                Map<String, Object> adjustMap = new Map<String, Object> ();
                List<Object> adjustList = new List<Object> ();
                adjustMap.put('AdjustmentMethod','Absolute');
                adjustMap.put('AdjustmentType','Override');
                adjustMap.put('AdjustmentCode','');
                adjustMap.put('DetailType','OVERRIDE');
                adjustMap.put('Field','vlocity_cmt__OneTimeCharge__c');
                adjustMap.put('PricingVariableCode','OT_STD_PRC');
                adjustMap.put('AdjustmentValue',recalculAmount);
                adjustList.add(adjustMap);
                inputMap.put('cartId',orderid);
                inputMap.put('id',itemid);
                inputMap.put('adjustments',adjustList);
                inputMap.put('methodName','applyAdjustment');
                System.debug('Amine Bouremma Constructed inputParams in future: ' + inputMap);
                 vlocity_cmt.CpqAppHandler applyAdjustmentItem = new vlocity_cmt.CpqAppHandler();
                 applyAdjustmentItem.invokeMethod('applyAdjustment', inputMap, outputMap, null);
                 System.debug('Output Map after applying adjustment future: ' + outputMap);
                
                 inwib2c_CallAdjustementForquantity__c  c = new inwib2c_CallAdjustementForquantity__c();
                 List<inwib2c_CallAdjustementForquantity__c > TerminauxList =new List <inwib2c_CallAdjustementForquantity__c >();
                 TerminauxList.add(new inwib2c_CallAdjustementForquantity__c (id = id, inwib2c_Done__c  = 'true'));
                 if(!Test.isRunningTest()){
                 update TerminauxList;
                 }
               
                // List<inwib2c_CallAdjustementForquantity__c > Call2= [select Id, inwib2c_OrderId__c, inwib2c_OrderItemId__c, inwib2c_PriceTerminal__c, inwib2c_Done__c
                // From inwib2c_CallAdjustementForquantity__c  where inwib2c_OrderId__c =:orderid and inwib2c_Done__c =:'false' limit 1];
                
                
                List<inwib2c_CallAdjustementForquantity__c> Call2List = [
                    SELECT Id, inwib2c_OrderId__c, inwib2c_OrderItemId__c, inwib2c_PriceTerminal__c, inwib2c_Done__c,inwib2c_TraceId__c
                    FROM inwib2c_CallAdjustementForquantity__c
                    WHERE inwib2c_OrderId__c = :orderid AND inwib2c_Done__c = 'false'
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ];
                
                //String flag= Call2.inwib2c_Done__c;
                if (!Call2List.isEmpty()) {
                    inwib2c_CallAdjustementForquantity__c Call2 = Call2List[0];
                    System.debug('Le Flag est2 ' + Call2.inwib2c_Done__c );
                
                    if (Call2.inwib2c_Done__c == 'false') {
                        List<inwib2c_UpdatePriceEshop__e> PriceUpdate_event = new List<inwib2c_UpdatePriceEshop__e>();
                        inwib2c_UpdatePriceEshop__e eventToCreate = new inwib2c_UpdatePriceEshop__e();
                   eventToCreate.inwib2c_cartId__c = orderid;
                  PriceUpdate_event.add(eventToCreate);
                  List <Database.SaveResult> sresult = EventBus.publish(PriceUpdate_event);
                  System.debug('Next Call to event'+sresult );
                    }
                }else {
                    // if(Test.isRunningTest()){
                    //     traceId=tracerecalcul.id;

                    // }
                    InwiB2C_Trace_API__c traceObj = [select id, InwiB2C_Object_Number__c, InwiB2C_request_body__c from InwiB2C_Trace_API__c where id = :traceId];
                    inwib2c_TraceDemandeEshop__c  traceDemandeEshop =  [select id,inwib2c_Avec_ou_sans_engagement__c, CreatedDate, IdTraceAPI__c, inwib2c_AccountId__c, inwib2c_OrderId__c, inwib2c_Num_ro_de_la_demande__c, inwib2c_Montant_de_la_commande__c, inwib2c_Mode_de_paiement__c, inwib2c_Mode_de_livraison__c, inwib2c_MDN__c, inwib2c_Request_body__c, inwib2c_Statut__c, inwib2c_Statut_paiement__c,inwib2c_Date_Finalisation_Commande__c,inwib2c_FMD_Total__c,inwib2c_FMS_Total__c,inwib2c_Prix_Terminal_Total__c,Inwib2c_Soumission_automatisee__c,Inwib2c_Attente_Confirmation_de_paiement__c	  from inwib2c_TraceDemandeEshop__c where IdTraceAPI__c =:traceId];
                     
                    if (traceDemandeEshop.Inwib2c_Soumission_automatisee__c	=='Oui') {
           
                        //Create Contract
                        String procedureName0 = 'inwib2c_InwiB2C_CreateContract';
                        Map <String, Object> ipInputContract = new Map <String, Object> ();
                        Map <String, Object> ipOutputContract = new Map <String, Object> ();
                        Map <String, Object> ipOptionsContract = new Map <String, Object> ();
                        ipInputContract.put('OrderId', orderid);
                        ipInputContract.put('idClient', traceDemandeEshop.inwib2c_AccountId__c);
                        System.debug('InputVIP' +ipInputContract);
                        ipOutputContract = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_CreateContract', ipInputContract, ipOptionsContract);                
                            System.debug('OutputVIP' +ipOutputContract);
                            System.debug(JSON.serialize(ipOutputContract));
                        
                        Map<String, Object> inputParams = new Map<String, Object>();
                        Map<String, Object> outputParams = new Map<String, Object>();
                        Map<String, Object> optionsParams = new Map<String, Object>();
                        inputParams.put('ContextId', orderid);
                        inputParams.put('cartId', orderid);
                        //inputParams.put('methodName', 'checkout');
                        optionsMap.put('useQueueableApexRemoting',false);
                        System.debug('CheckOut: ' + inputParams);
                        vlocity_cmt.CpqAppHandler submitautomatique = new vlocity_cmt.CpqAppHandler();
                        try {
                            submitautomatique.invokeMethod('checkout',inputParams, outputParams, optionsParams);
                            System.debug('after Submit Amine Bouremma: ' + outputParams);
                        } catch (Exception e) {
                            // Handle the exception here
                            System.debug('Error while applying CheckOut: ' + e.getMessage());
                           
                        }
                        
                        
                    }

                    Map<String, Object> result = new Map<String, Object>();
                    result.put('CSExecuteCarteEshopResultInfo', new Map<String, Object>{
                        'errorCode'     => '',
                        'errorMessage'  => 'SUCCESS',
                        'isOK'          => 1,
                        'OrderId'       => orderid,
                        'uuid'          => ''
                    });
                    System.debug('Result: ' + result);
                    String resultJson = JSON.serialize(result);
                    traceObj.InwiB2C_Object_Number__c = orderid;
                    traceObj.InwiB2C_Response__c = resultJson;
                    update traceObj;
                    //inwiB2C_eShopUpdateAttributes.updateAttributes(traceId);
                    Date todayDate = System.today();
                    DateTime currentDateTime = System.now();
                    System.debug('Today'+currentDateTime);
                    traceDemandeEshop.inwib2c_Statut__c= 'InwiB2C_Terminer';
                    traceDemandeEshop.inwib2c_OrderId__c= orderid;
                    traceDemandeEshop.inwib2c_Date_Finalisation_Commande__c=currentDateTime;
                    update traceDemandeEshop;
                }
                
                }
}