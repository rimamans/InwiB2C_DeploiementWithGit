// Trigger for catching inwiB2C_APICreateSMO__e events.
trigger inwiB2C_CreateSMOTrigger on inwiB2C_API_Create_SMO__e (after insert) {


   for (inwiB2C_API_Create_SMO__e event : Trigger.New) {
     Map <String, Object> Params = new Map <String, Object> ();
       if (event.inwiB2C_OrderId__c != null && event.inwiB2C_step__c.equals('checkout')){
       
          String IP_CheckoutOrderAPI = 'inwib2c_CheckoutOrderAPI';
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            
            inputMap.put('Id',event.inwiB2C_OrderId__c);
            optionsMap.put('useQueueableApexRemoting',true);

            
            Params.put('Name',IP_CheckoutOrderAPI);
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));

            //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
             
           //outputMap = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_CheckoutOrderAPI', inputMap, optionsMap);
           
           /* inputMap.put('cartId',event.inwiB2C_OrderId__c);
            inputMap.put('ContextId',event.inwiB2C_OrderId__c);
            inputMap.put('methodName','checkout');*/
            /////////////////////
           // List<Order> ord=[SELECT id from Order where id =: event.inwiB2C_OrderId__c];
         //   ord[0].inwib2c_DetailMotif__c='input-->'+inputMap;
           // update ord[0];
            
            
            ///////////////////////
            //vlocity_cmt.CpqAppHandler submitOrderCartsItem = new vlocity_cmt.CpqAppHandler();
           // submitOrderCartsItem.invokeMethod('checkout', inputMap, outputMap, null);
            
           // ord[0].inwib2c_DetailMotif__c = ord[0].inwib2c_DetailMotif__c +' output -->'+outputMap;
            //update ord[0];
            
            
       }
       /*else if (event.inwiB2C_OrderId__c != null && event.inwiB2C_step__c.equals('applyAdjustment')){
       
     
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            Map<String, Object> adjustMap = new Map<String, Object> ();
            List<Object> adjustList = new List<Object> ();
            
            adjustMap.put('AdjustmentMethod','Absolute');
            adjustMap.put('AdjustmentType','Override');
            adjustMap.put('AdjustmentCode','');
            adjustMap.put('DetailType','OVERRIDE');
            adjustMap.put('Field','vlocity_cmt__OneTimeCharge__c');
            adjustMap.put('PricingVariableCode','OT_STD_PRC');
            adjustMap.put('AdjustmentValue',event.inwiB2C_Price__c);
            //adjustMap.put('AdjustmentValue','20');
            adjustList.add(adjustMap);
           
            inputMap.put('cartId',event.inwiB2C_OrderId__c);
            inputMap.put('id',event.inwiB2C_OLI__c);
            inputMap.put('adjustments',adjustList);
            inputMap.put('methodName','applyAdjustment');
            
            vlocity_cmt.CpqAppHandler applyAdjustmentItem = new vlocity_cmt.CpqAppHandler();
            applyAdjustmentItem.invokeMethod('applyAdjustment', inputMap, outputMap, null);
            
       }
        else if (event.inwiB2C_OrderId__c != null && event.inwiB2C_step__c.equals('lockArticle')){

            System.debug('event inwiB2C_APICreateOrder__e add product recieved .');

            String procedureName = 'inwi_InwiB2C_LockArticle';
            Map<String, Object> ipInput = new Map<String, Object> ();
            Map<String, Object> ipOutput = new Map<String, Object> ();
            Map<String, Object> ipOptions = new Map<String, Object> ();
            
            Map<String, Object> handsetMap = new Map<String, Object> ();
            List<Object> handset = new List<Object> ();

            handsetMap.put('code',event.inwiB2C_modelArticle__c);
            handsetMap.put('serialNumber',event.inwiB2C_serialNumber__c);
            handsetMap.put('type',event.inwiB2C_typeArticle__c);
            handsetMap.put('technology','GSM');
            handsetMap.put('offerType','FM');
            handsetMap.put('orderType','SMO');
            handsetMap.put('region','PGSM');
            handsetMap.put('quantity','1');
            
            handset.add(handsetMap);
            
            
            ipInput.put('handset', handset);
            ipInput.put('operation', 'RS');
            ipInput.put('username', 'Sara');
            

            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);

          

        }*/
     else  if (event.inwiB2C_MDN__c != null && event.inwiB2C_Source__c.equals('Deactivate')){
             String IP_CreatePortaOUT = 'inwib2c_InwiB2C_CreatePortaOut';
                    //Build the CSOperationInfo
             Map<String, Object> CSOperationInfo = new Map<String, Object>();
             CSOperationInfo.put('channel', 'FR');
             CSOperationInfo.put('user', 'jawad.bentaybi');
             CSOperationInfo.put('uuid', '73fc2b9c-1ed7-0c2d-b0b0-3a732cb1d712');
             Map<String, Object> ObjCSOperationInfo = new Map<String, Object>();
             ObjCSOperationInfo.put('CSOperationInfo', CSOperationInfo);
       
             //Build the CSCreateSMO
             Map<String, Object> CSCreateSMO = new Map<String, Object>();
             CSCreateSMO.put('mdn', event.inwiB2C_MDN__c);
             CSCreateSMO.put('actionType', 'PORTAOUT');
             CSCreateSMO.put('PortaOutId', event.inwiB2C_PortaId__c);
             CSCreateSMO.put('canal', 'inwiB2C_Televente');
             Map<String, Object> ObjCSCreateSMO = new Map<String, Object>();
             ObjCSCreateSMO.put('CSCreateSMO', CSCreateSMO);
       
             Map <String, Object> ipInput = new Map <String, Object> ();
             Map <String, Object> ipOutput = new Map <String, Object> ();
             Map <String, Object> ipOptions = new Map <String, Object> ();
             
             /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
             ipInput.put('CSOperationInfo', CSOperationInfo);
             ipInput.put('CSCreateSMO', CSCreateSMO);
       
             Params.put('Name',IP_CreatePortaOUT);
             Params.put('ipInput',ipInput);
             Params.put('ipOptions',ipOptions);
             system.debug('Params'+(String)JSON.serialize(Params));
             
             //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
             inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
             /* Call the IP via runIntegrationService, and save the output to ipOutput */
             //ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_CreatePortaOUT, ipInput, ipOptions);
     
     } /** CHB 08/08/2024 SJT MC_SF24-055_Suspension des lignes non identifieģes BEGIN */
      else  if (event.inwiB2C_MDN__c != null && event.inwiB2C_Source__c.equals('CreateSMORehab')){
      String IP_CreateSMO = 'inwib2c_InwiB2C_CreateSMO';
      Map<String, Object> CSOperationInfo = new Map<String, Object>();
      CSOperationInfo.put('channel', 'FR');
      CSOperationInfo.put('user', 'APIDigital');
      CSOperationInfo.put('uuid', '73fc2b9c-1ed7-0c2d-b0b0-3a732cb1d712');
      Map<String, Object> ObjCSOperationInfo = new Map<String, Object>();
      ObjCSOperationInfo.put('CSOperationInfo', CSOperationInfo);

      //Build the CSCreateSMO
      Map<String, Object> CSCreateSMO = new Map<String, Object>();
      CSCreateSMO.put('mdn', event.inwiB2C_MDN__c);
      CSCreateSMO.put('actionType', 'REHAB');
      CSCreateSMO.put('APIName', 'Identification Digital');
      CSCreateSMO.put('canal', 'inwiB2C_MyInwi');
      Map<String, Object> ObjCSCreateSMO = new Map<String, Object>();
      ObjCSCreateSMO.put('CSCreateSMO', CSCreateSMO);

      Map <String, Object> ipInput = new Map <String, Object> ();
      Map <String, Object> ipOutput = new Map <String, Object> ();
      Map <String, Object> ipOptions = new Map <String, Object> ();
      
      /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
      ipInput.put('CSOperationInfo', CSOperationInfo);
      ipInput.put('CSCreateSMO', CSCreateSMO);

      Params.put('Name',IP_CreateSMO);
      Params.put('ipInput',ipInput);
      Params.put('ipOptions',ipOptions);
      system.debug('Params'+(String)JSON.serialize(Params));
      
      //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
      inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
     }/** CHB 08/08/2024 SJT MC_SF24-055_Suspension des lignes non identifieģes END */
   }
}