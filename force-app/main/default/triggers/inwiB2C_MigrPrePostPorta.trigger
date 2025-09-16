trigger inwiB2C_MigrPrePostPorta on inwiB2C_MigrPrePostPorta__e (after insert) {
    for (inwiB2C_MigrPrePostPorta__e event: trigger.New) {
        if (event.inwiB2C_panierId__c != '' && event.inwiB2C_step__c.equals('cloneOrder')) {
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            inputMap.put('panierId', event.inwiB2C_panierId__c);
            System.debug('Trigger - invoking cloneOrder method');
            (new inwiB2C_handleMigPrePostPorta()).invokeMethod('cloneOrder',inputMap,outputMap, optionsMap);
        }
        if (event.inwiB2C_panierId__c != '' && event.inwiB2C_step__c.equals('updateAttributes')) {
            Map<String, Object> inputMap = new Map<String, Object> ();
            Map<String, Object> outputMap = new Map<String, Object> ();
            Map<String, Object> optionsMap = new Map<String, Object> ();
            inputMap.put('panierId', event.inwiB2C_panierId__c);
            System.debug('Trigger - invoking updateAttributes method');
            (new inwiB2C_handleMigPrePostPorta()).invokeMethod('updateAttributes',inputMap,outputMap, optionsMap);
        }
    }
}