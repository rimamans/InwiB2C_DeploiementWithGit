// Trigger for catching inwiB2C_APICreateOrder__e events.
trigger inwiB2C_CreateContratTrigger on inwiB2C_APICreateOrder__e (after insert) {
    // Iterate through each notification.
    System.debug('event inwiB2C_APICreateOrder__e recieved .');
    for (inwiB2C_APICreateOrder__e event : Trigger.New) {
        if (event.inwiB2C_step__c != null && event.inwiB2C_step__c.equals('getCartProduct')){  
            inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
            logCreateContract.id = event.inwiB2C_IdLog__c; 
            try {
        String procedureName = 'inwib2c_inwiB2C_getCartProduct';
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();
        
        /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
        ipInput.put('inwiB2C_Mdn__c', event.inwiB2C_Mdn__c);
        ipInput.put('inwiB2C_BusinessUnit__c', event.inwiB2C_BusinessUnit__c);
        ipInput.put('inwiB2C_itemId__c', event.inwiB2C_itemId__c);
        ipInput.put('inwiB2C_Icc__c', event.inwiB2C_Icc__c);
        ipInput.put('inwiB2C_imsi__c', event.inwiB2C_imsi__c);
        ipInput.put('inwiB2C_puk__c', event.inwiB2C_puk__c);
        ipInput.put('inwiB2C_ki__c', event.inwiB2C_ki__c);
        ipInput.put('inwiB2C_MdnOCSID__c', event.inwiB2C_MdnOCSID__c);
        ipInput.put('inwiB2C_SimOCSID__c', event.inwiB2C_SimOCSID__c);
        ipInput.put('inwiB2C_ProfileId__c', event.inwiB2C_ProfileId__c);
        ipInput.put('inwiB2C_CodeArticle__c', event.inwiB2C_CodeArticle__c);
        ipInput.put('inwiB2C_orderId__c', event.inwiB2C_orderId__c);
        ipInput.put('inwiB2C_IdLog__c', event.inwiB2C_IdLog__c);
        
        /* Call the IP via runIntegrationService, and save the output to ipOutput */
        ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
        
        System.debug('IP Output getCartProduct: ' + ipOutput);

        String error = (String) ipOutput.get('error');
        System.debug('error: ' + error);
        If ((error != 'OK') && (error != '') && (error != null)) {
            logCreateContract.inwiB2C_Erreur__c = error;
            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
            Update logCreateContract;            
        }
    } 
        catch (Exception e) {
            logCreateContract.inwiB2C_Erreur__c = 'errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString());
            logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
            Update logCreateContract;
        } 
    }
    else if (event.inwiB2C_step__c != null && event.inwiB2C_step__c.equals('addProduct')){
        inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
        logCreateContract.id = event.inwiB2C_IdLog__c; 
        try {
            String procedureName = 'inwib2c_inwib2c_addProductToCart';
            Map<String, Object> ipInput = new Map<String, Object> ();
            Map<String, Object> ipOutput = new Map<String, Object> ();
            Map<String, Object> ipOptions = new Map<String, Object> ();
            
            ipInput.put('inwiB2C_Mdn__c', event.inwiB2C_Mdn__c);
            ipInput.put('inwiB2C_BusinessUnit__c', event.inwiB2C_BusinessUnit__c);
            ipInput.put('inwiB2C_itemId__c', event.inwiB2C_itemId__c);
            ipInput.put('inwiB2C_Icc__c', event.inwiB2C_Icc__c);
            ipInput.put('inwiB2C_imsi__c', event.inwiB2C_imsi__c);
            ipInput.put('inwiB2C_puk__c', event.inwiB2C_puk__c);
            ipInput.put('inwiB2C_ki__c', event.inwiB2C_ki__c);
            ipInput.put('inwiB2C_MdnOCSID__c', event.inwiB2C_MdnOCSID__c);
            ipInput.put('inwiB2C_SimOCSID__c', event.inwiB2C_SimOCSID__c);
            ipInput.put('inwiB2C_ProfileId__c', event.inwiB2C_ProfileId__c);
            ipInput.put('inwiB2C_CodeArticle__c', event.inwiB2C_CodeArticle__c);
            ipInput.put('inwiB2C_orderId__c', event.inwiB2C_orderId__c);
            ipInput.put('inwiB2C_IdLog__c', event.inwiB2C_IdLog__c);
            
            /* Call the IP via runIntegrationService, and save the output to ipOutput */
            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            
            System.debug('IP Output addProduct: ' + ipOutput);

            String error = (String) ipOutput.get('error');
            System.debug('error: ' + error);
            If ((error != 'OK') && (error != '') && (error != null)) {
                logCreateContract.inwiB2C_Erreur__c = error;
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;            
            }
        } 
            catch (Exception e) {
                logCreateContract.inwiB2C_Erreur__c = 'errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString());
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;    
            } 
        }
        else if (event.inwiB2C_step__c != null && event.inwiB2C_step__c.equals('updateAttributes')){
            inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
            logCreateContract.id = event.inwiB2C_IdLog__c; 
try {
            System.debug('event inwiB2C_APICreateOrder__e updateCartAttributes recieved.');
            
            String procedureName = 'inwib2c_inwib2c_updateCartAttributes';
            Map<String, Object> ipInput = new Map<String, Object> ();
            Map<String, Object> ipOutput = new Map<String, Object> ();
            Map<String, Object> ipOptions = new Map<String, Object> ();
            
            ipInput.put('inwiB2C_Mdn__c', event.inwiB2C_Mdn__c);
            ipInput.put('inwiB2C_BusinessUnit__c', event.inwiB2C_BusinessUnit__c);
            ipInput.put('inwiB2C_itemId__c', event.inwiB2C_itemId__c);
            ipInput.put('inwiB2C_Icc__c', event.inwiB2C_Icc__c);
            ipInput.put('inwiB2C_imsi__c', event.inwiB2C_imsi__c);
            ipInput.put('inwiB2C_puk__c', event.inwiB2C_puk__c);
            ipInput.put('inwiB2C_ki__c', event.inwiB2C_ki__c);
            ipInput.put('inwiB2C_MdnOCSID__c', event.inwiB2C_MdnOCSID__c);
            ipInput.put('inwiB2C_SimOCSID__c', event.inwiB2C_SimOCSID__c);
            ipInput.put('inwiB2C_ProfileId__c', event.inwiB2C_ProfileId__c);
            ipInput.put('inwiB2C_CodeArticle__c', event.inwiB2C_CodeArticle__c);
            ipInput.put('inwiB2C_orderId__c', event.inwiB2C_orderId__c);
            ipInput.put('inwiB2C_IdLog__c', event.inwiB2C_IdLog__c);
            
            /* Call the IP via runIntegrationService, and save the output to ipOutput */
            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            
            System.debug('IP Output addProduct: ' + ipOutput);

            String error = (String) ipOutput.get('error');
            System.debug('error: ' + error);
            If ((error != 'OK') && (error != '') && (error != null)) {
                logCreateContract.inwiB2C_Erreur__c = error;
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;            
            }
}
            catch (Exception e) {
                logCreateContract.inwiB2C_Erreur__c = 'errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString());
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;    
            }
            }
            else if (event.inwiB2C_step__c != null && event.inwiB2C_step__c.equals('checkout')){
                inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
                logCreateContract.id = event.inwiB2C_IdLog__c; 
                try {
            System.debug('event inwiB2C_APICreateOrder__e checkout recieved.');
            
            String procedureName = 'inwib2c_inwib2c_checkoutAPI';
            Map<String, Object> ipInput = new Map<String, Object> ();
            Map<String, Object> ipOutput = new Map<String, Object> ();
            Map<String, Object> ipOptions = new Map<String, Object> ();

            ipInput.put('inwiB2C_orderId__c', event.inwiB2C_orderId__c);
            
            /* Call the IP via runIntegrationService, and save the output to ipOutput */
            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            System.debug('IP Output checkout: ' + ipOutput);

            String error = (String) ipOutput.get('error');
            System.debug('error: ' + error);
            If ((error != 'OK') && (error != '') && (error != null)) {
                logCreateContract.inwiB2C_Erreur__c = error;
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;            
            }
            else {
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Termine';
                update logCreateContract;               
            }

                }
            catch (Exception e) {
                logCreateContract.inwiB2C_Erreur__c = 'errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString());
                logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                Update logCreateContract;    
            }
            }
             else if (event.inwiB2C_step__c != null && event.inwiB2C_step__c.equals('sendSMS')) {
                 
            System.debug('event inwiB2C_SendPassWordSMS updateAsset recieved.');
/*            String procedureName = 'inwib2c_inwiB2C_SendPassWordSMS';
            Map<String, Object> ipInput = new Map<String, Object> ();
            Map<String, Object> ipOutput = new Map<String, Object> ();
            Map<String, Object> ipOptions = new Map<String, Object> ();
/*
            {
                "content": "'+message+'",
                "sender": {
                  "phoneNumber": "'+sender+'"
                },
                "receiver": [
                  {
                    "phoneNumber": "'+receiver+'"
                  }
                ]   
              }
              */
              /*
            ipInput.put('phoneNumber', event.inwiB2C_Mdn__c);
            ipInput.add('receiver', event.inwiB2C_BusinessUnit__c);
            ipInput.put('phoneNumber', event.inwiB2C_Mdn__c);
            ipInput.add('sender', event.inwiB2C_BusinessUnit__c);
            ipInput.add('content', event.);

            /* Call the IP via runIntegrationService, and save the output to ipOutput */
           /* ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            */
        //    System.debug('IP Output SendPassWordSMS: ' + ipOutput);
           }
           else {
            inwiB2C_CreateContractLogs__c logCreateContract = new inwiB2C_CreateContractLogs__c();
            logCreateContract.id = event.inwiB2C_IdLog__c;
               try {                
            vlocity_cmt.CpqAppHandler createOrder = new vlocity_cmt.CpqAppHandler();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outputMap = new Map<String,Object>();
            inputMap.put('filters', 'Account.vlocity_cmt__Status__c:New_Active_Existant_Nouveau_Ancien_Prospect_Inactif_Actif_Bloqué_Clôturé');
            inputMap.put('objectType', 'Order');
            List<Map<String,Object>> inputFields = new List<Map<String,Object>>();
            Map<String,Object> inputField = new Map<String,Object>();
            inputField.put ('inwiB2C_Statut__c', 'inwiB2C_EnCours');
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put ('inwib2c_Canal__c', event.inwiB2C_Canal__c);
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put ('inwib2c_TypeDeLaCommande__c', 'inwiB2C_Acquisition');
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put ('inwib2c_Distributeur__c', event.inwiB2C_BusinessUnit__c);
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put ('inwib2c_Partenaire__c', event.inwiB2C_POS__c);
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            Id pricelistId = [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'B2C_LP_PRE' LIMIT 1].Id;
            inputField.put ('vlocity_cmt__PriceListId__c', pricelistId);
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put ('AccountId', event.inwiB2C_CustomerId__c);
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put ('status', 'Draft');
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put('effectivedate', Date.today());
            inputFields.add(inputField);
            inputField = new Map<String,Object>();
            inputField.put('ContractId', event.inwiB2C_ContratId__c);
            inputFields.add(inputField);
            inputMap.put('inputFields', inputFields);
            System.debug(LoggingLevel.ERROR, 'inputMap : ' + json.serialize(inputMap));
            createOrder.invokeMethod('createCart', inputMap, outputMap, null);
            System.debug(LoggingLevel.ERROR, 'outputMap : ' + json.serialize(outputMap));
            //Get Order Id
            //LDA
            /*List<Map<String,Object>> outRecords = (List<Map<String,Object>>) outputMap.get('records');
            Map<String,Object>  outRecord =  outRecords[0];
            String cartId = (String) outRecord.get('Id');*/
            //LDA END
            JSONParser parser = 
                JSON.createParser(json.serialize(outputMap, true));
            id orderId;
            while (parser.nextToken() != Null) {
                if (parser.getCurrentName() == 'fields') {
                    system.debug('parser.getCurrentName(): '+parser.getCurrentName());
                    parser.nextToken();
                    system.debug('parser.nextToken(): '+parser.nextToken());
                    while (parser.nextToken() != Null) {
                        if (parser.getCurrentName() == 'id') {
                            orderId = Id.valueOf(parser.getText());
                            system.debug('orderId: '+orderId);
                            break;
                        }
                        parser.nextToken();
                    }
                    break;
                } 
            }

            System.debug('orderId beforce Call:' + orderId);
                    inwiB2C_APICreateOrder__e eventCreateOrder = new inwiB2C_APICreateOrder__e();
                    eventCreateOrder.inwiB2C_BusinessUnit__c = event.inwiB2C_BusinessUnit__c;
                    eventCreateOrder.inwiB2C_Mdn__c = event.inwiB2C_Mdn__c;
                    eventCreateOrder.inwiB2C_Icc__c = event.inwiB2C_Icc__c;
                    eventCreateOrder.inwiB2C_imsi__c =  event.inwiB2C_imsi__c;
                    eventCreateOrder.inwiB2C_ki__c = event.inwiB2C_ki__c;
                    eventCreateOrder.inwiB2C_puk__c = event.inwiB2C_puk__c;
                    eventCreateOrder.inwiB2C_ProfileId__c = event.inwiB2C_ProfileId__c;
                    eventCreateOrder.inwiB2C_MdnOCSID__c = event.inwiB2C_MdnOCSID__c;
                    eventCreateOrder.inwiB2C_orderId__c = orderId;
                    eventCreateOrder.inwiB2C_CodeArticle__c = event.inwiB2C_CodeArticle__c;
                    eventCreateOrder.inwiB2C_IdLog__c = event.inwiB2C_IdLog__c;
                    eventCreateOrder.inwiB2C_step__c = 'getCartProduct';
                    System.debug('Before publishing the event inwiB2C_APICreateOrder__e.');

                    // Call method to publish events
                    Database.SaveResult sresult = EventBus.publish(eventCreateOrder);
                    
                    if (sresult.isSuccess()) {
                        System.debug('Successfully published event.');
                    } else {
                        for (Database.Error err : sresult.getErrors()) {
                            System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                        }
                    }
                    Order order = new Order();
                    order.id = orderId;
                    order.inwiB2C_Dealer__c = event.inwiB2C_DealerId__c;
                    update order;
                    logCreateContract.inwiB2C_IdOrder__c = orderId; 
                    Update logCreateContract;
                }
                    catch (Exception e) {
                        logCreateContract.inwiB2C_Erreur__c = 'errorMessage": "' +String.valueOf(e)+ ': ' +String.valueOf(e.getStackTraceString());
                        logCreateContract.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                        Update logCreateContract;
                    }
        }
    }
}