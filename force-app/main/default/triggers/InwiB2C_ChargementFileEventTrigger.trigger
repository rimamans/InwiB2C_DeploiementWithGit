trigger InwiB2C_ChargementFileEventTrigger on InwiB2C_ChargementFileEvent__e (after insert) {
    for (InwiB2C_ChargementFileEvent__e event : Trigger.New) {
      //chb 09/01/2025 begin */ 
       // if (event.InwiB2C_CIN__c != null) {  
      //chb 09/01/2025 end*/ 
            // Initialisation des Maps pour l'appel d'un service d'intégration
            Map <String, Object> Params = new Map <String, Object> ();
            Map <String, Object> inputMap = new Map <String, Object> ();
            Map <String, Object> optionsMap = new Map <String, Object> ();

            inputMap.put('CIN', event.InwiB2C_CIN__c); 
            inputMap.put('ParentId', event.ParentId__c);   
            inputMap.put('TypeCIN', event.InwiB2C_Type_CIN_c__c);  
            inputMap.put('SegmentDealer', event.InwiB2C_Segment_Dealer__c); 
            inputMap.put('TypeHandler', event.InwiB2C_Typehandler__c); 
            inputMap.put('Region', event.InwiB2C_Region__c);  
            inputMap.put('Address', event.InwiB2C_Address__c);  
            inputMap.put('Ville', event.inwiB2C_Ville__c);  
            inputMap.put('Quartier', event.InwiB2C_Quartier__c);  
            inputMap.put('Latitude', event.InwiB2C_Geolocalisation_Latitude__c);  
            inputMap.put('Longitude', event.InwiB2C_Geolocalisation_Longitude__c);  
            inputMap.put('Email', event.inwib2c_AdresseMail__c);  
            inputMap.put('DealerCode', event.InwiB2C_Code_Dealer__c); 
            inputMap.put('PartnerContact1', event.PartenaireNumContact1__c);  
            inputMap.put('PartnerContact2', event.Partenaire_Num_Contact2__c);  
            inputMap.put('FirstName', event.FirstName__c);
            inputMap.put('LastName', event.LastName__c); 
            inputMap.put('Vendeur', event.InwiB2C_Vendeur__c);  
            inputMap.put('Canal', event.InwiB2C_Canal__c);  
            inputMap.put('Sous-Région', event.InwiB2C_SousRegion__c);
            inputMap.put('FlagRuralouUrbain', event.InwiB2C_Flag_Rural_Urbain__c);
            //chb 09/01/2025 begin */ 
            inputMap.put('IdRecord', event.inwiB2C_idRecord__c); 
            //chb 09/01/2025 end*/ 
            system.debug('test input: '+JSON.serialize(inputMap));
            Params.put('Name', 'inwib2c_inwib2c_ProcessFileUpload');
            Params.put('ipInput', inputMap);    
            Params.put('ipOptions', optionsMap); 
            
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
       // }
    }
}