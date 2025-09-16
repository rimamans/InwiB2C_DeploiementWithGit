trigger inwiB2C_CreateMigration2G4GEventTrigger on InwiB2C_Migration2G4GEvt__e (after insert) {
     String IP_Deactivate4GSubscription = 'inwib2c_InwiB2C_Deactivate4GSubscription';
     String IP_Change2G3GSubscription = 'inwib2c_InwiB2C_ChangeSubscription2GMigration';
     /*CHB 17/04/2024 begin*/
     String IP_SynchroniseAsset4G = 'inwib2c_InwiB2C_SynchroniseAsset4G';
     String IP_CheckOutAssetSynch4g = 'inwib2c_InwiB2C_CheckOutAssetSynch4g';
     /*CHB 17/04/2024 end*/
     List<InwiB2C_Migration2G4G__c> MigrationList = [Select Id, InwiB2C_ICC__c, InwiB2C_imsi__c, InwiB2C_ki__c, InwiB2C_codeArticle__c, InwiB2C_mdn2G__c, inwiB2C_mdn4G__c, InwiB2C_OrderChange2G__c, InwiB2C_OrderResiliation4G__c, InwiB2C_ocsId__c, InwiB2C_puk__c,inwiB2C_reason__c from InwiB2C_Migration2G4G__c];

   for (InwiB2C_Migration2G4GEvt__e event : Trigger.New) {
      

   if (event.inwiB2C_mdn4G__c != null && event.inwiB2C_Step__c == 'Creation' ){

       
            Map<String, Object> CSOperationInfo = new Map<String, Object>();
             CSOperationInfo.put('channel', 'FR');
             CSOperationInfo.put('user', 'jawad.bentaybi');
             CSOperationInfo.put('uuid', '73fc2b9c-1ed7-0c2d-b0b0-3a732cb1d712');
             Map<String, Object> ObjCSOperationInfo = new Map<String, Object>();
             ObjCSOperationInfo.put('CSOperationInfo', CSOperationInfo);
       
             //Build the CSCreateSMO
             Map<String, Object> CSCreateSMO = new Map<String, Object>();
             CSCreateSMO.put('mdn', event.inwiB2C_mdn4G__c);
             CSCreateSMO.put('MigrationId', event.inwiB2C_Migrationid__c);
             CSCreateSMO.put('canal', 'inwiB2C_MyInwi');
             Map<String, Object> ObjCSCreateSMO = new Map<String, Object>();
             ObjCSCreateSMO.put('CSCreateSMO', CSCreateSMO);
       
             Map <String, Object> ipInput = new Map <String, Object> ();
             Map <String, Object> ipOutput = new Map <String, Object> ();
             Map <String, Object> ipOptions = new Map <String, Object> ();
             
             /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
             ipInput.put('CSOperationInfo', CSOperationInfo);
             ipInput.put('CSCreateSMO', CSCreateSMO);
       
     
             
             /* Call the IP via runIntegrationService, and save the output to ipOutput */
             ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_Deactivate4GSubscription, ipInput, ipOptions);
     
     }     
     /* Call the IP for SOA notification */
     else    if (event.inwiB2C_Step__c == 'Changement2G' ){

       
            Map<String, Object> CSOperationInfo = new Map<String, Object>();
             CSOperationInfo.put('channel', 'FR');
             CSOperationInfo.put('user', 'jawad.bentaybi');
             CSOperationInfo.put('uuid', '73fc2b9c-1ed7-0c2d-b0b0-3a732cb1d712');
             Map<String, Object> ObjCSOperationInfo = new Map<String, Object>();
             ObjCSOperationInfo.put('CSOperationInfo', CSOperationInfo);
             
             Map<String, Object> CSCreateSMO = new Map<String, Object>();
       
             for (InwiB2C_Migration2G4G__c item : MigrationList){
                 if (item.Id == event.inwiB2C_Migrationid__c){
                     //Build the CSCreateSMO
                     CSCreateSMO.put('mdn4G', item.inwiB2C_mdn4G__c);
                     CSCreateSMO.put('mdn', item.InwiB2C_mdn2G__c);
                     CSCreateSMO.put('MigrationId', event.inwiB2C_Migrationid__c);
                     CSCreateSMO.put('puk', item.InwiB2C_puk__c);
                     CSCreateSMO.put('imsi', item.InwiB2C_imsi__c);
                     CSCreateSMO.put('icc', item.InwiB2C_ICC__c);
                     CSCreateSMO.put('codeArticle', item.InwiB2C_codeArticle__c);
                     CSCreateSMO.put('ki', item.InwiB2C_ki__c);
                     CSCreateSMO.put('ocsId', item.InwiB2C_ocsId__c);
                     CSCreateSMO.put('canal', 'inwiB2C_MyInwi'); 
                     //CHB 05/10/2023 SAV SIM AVEC REHAB
                     CSCreateSMO.put('reason', item.inwiB2C_reason__c); 
                     Map<String, Object> ObjCSCreateSMO = new Map<String, Object>();
                     ObjCSCreateSMO.put('CSCreateSMO', CSCreateSMO);
                 
                 }
             }

       
             Map <String, Object> ipInput = new Map <String, Object> ();
             Map <String, Object> ipOutput = new Map <String, Object> ();
             Map <String, Object> ipOptions = new Map <String, Object> ();
             
             /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
             ipInput.put('CSOperationInfo', CSOperationInfo);
             ipInput.put('CSCreateSMO', CSCreateSMO);
       
     
             
             /* Call the IP via runIntegrationService, and save the output to ipOutput */
             ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_Change2G3GSubscription, ipInput, ipOptions);
     
     }  
      /*CHB 17/04/2024 add for inventoryitem begin*/
   else if(event.inwiB2C_Step__c == 'GenerateAsset4G'){
       
              Map <String, Object> ipInput = new Map <String, Object> ();
              Map <String, Object> ipOutput = new Map <String, Object> ();
              Map <String, Object> ipOptions = new Map <String, Object> ();
              
              ipInput.put('mdn4G', event.inwiB2C_mdn4G__c);
              ipInput.put('MigrationId', event.inwiB2C_Migrationid__c);
              /* Call the IP via runIntegrationService, and save the output to ipOutput */
              ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_SynchroniseAsset4G, ipInput, ipOptions);
              
   }else if(event.inwiB2C_Step__c == 'CheckOutAssetSynch4g'){
              Map <String, Object> ipInput = new Map <String, Object> ();
              Map <String, Object> ipOutput = new Map <String, Object> ();
              Map <String, Object> ipOptions = new Map <String, Object> ();
              Map <String, Object> Params = new Map <String, Object> ();
              ipInput.put('mdn4G', event.inwiB2C_mdn4G__c);
              ipInput.put('MigrationId', event.inwiB2C_Migrationid__c);
              ipInput.put('Id', event.inwiB2C_OrderId__c);
              /* Call the IP via runIntegrationService, and save the output to ipOutput */
              Params.put('Name',IP_CheckOutAssetSynch4g);
              Params.put('ipInput',ipInput);
              Params.put('ipOptions',ipOptions);
              system.debug('Params'+(String)JSON.serialize(Params));
  
              //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
              inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
            }


   }  /*CHB 17/04/2024 add for inventoryitem end*/}