trigger inwiB2C_MigrPrePost on inwiB2C_MigrPrePost__e (after insert) {
    for (inwiB2C_MigrPrePost__e event: trigger.New) {
        if (event.inwiB2C_panierId__c != '' && event.inwiB2C_step__c.equals('createOrder')) {
            Map <String, Object> Params = new Map <String, Object> ();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outputMap = new Map<String,Object>();
            Map<String,Object> optionsMap = new Map<String,Object>();
            
            inputMap.put('panierId', event.inwiB2C_panierId__c);
            System.debug('Trigger - invoking createOrder method');
            
            Params.put('Name','Inwi_InwiB2C_createOrderMigPrePost');
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
        // B-29348 ajouter le orderitem volte begin
        if (event.inwiB2C_panierId__c != '' && event.inwiB2C_step__c.equals('addVolte')) {
            Map<String, Object> Params = new Map<String, Object>();
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> optionsMap = new Map<String, Object>();

            inputMap.put('panierId',event.inwiB2C_panierId__c);
                        
            Params.put('Name', 'inwib2c_inwiB2C_AddOptionInOrderMigrationPrePostDigital');
            Params.put('ipInput', inputMap);
            Params.put('ipOptions', optionsMap);
                        
            system.debug('Params' + (String) JSON.serialize(Params));
                        
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String) JSON.serialize(Params));
        }
        // B-29348 ajouter le orderitem volte begin
        if (event.inwiB2C_panierId__c != '' && event.inwiB2C_step__c.equals('updateAttributes')) {
            Map <String, Object> Params = new Map <String, Object> ();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outputMap = new Map<String,Object>();
            Map<String,Object> optionsMap = new Map<String,Object>();
            
            inputMap.put('panierId', event.inwiB2C_panierId__c);
            System.debug('Trigger - invoking updateAttributes method');
            
            Params.put('Name','Inwi_InwiB2C_UpdateAttPrePost');
            Params.put('ipInput',inputMap);
            Params.put('ipOptions',optionsMap);
            system.debug('Params'+(String)JSON.serialize(Params));
            inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        }
    }
}