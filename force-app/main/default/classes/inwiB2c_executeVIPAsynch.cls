public with sharing class inwiB2c_executeVIPAsynch {
    @future(callout = true)
    public static void inwiB2c_executeVIPAsynch(String paramsSerialized) {
        
        Map<String, Object> Params = ( Map<String, Object>)JSON.deserializeUntyped(paramsSerialized);
        String vipName = (String) Params.get('Name');
        Map<String, Object> ipInput = (Map<String, Object>) Params.get('ipInput');
        Map<String, Object> ipOptions = (Map<String, Object>) Params.get('ipOptions');
        
        Map <String, Object> ipOutput = new Map <String, Object> ();
        if(!Test.isRunningTest()) ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(vipName, ipInput, ipOptions);
        else ipOutput.put('status',1);  
        system.debug('ipOutput'+ipOutput);
    }
}