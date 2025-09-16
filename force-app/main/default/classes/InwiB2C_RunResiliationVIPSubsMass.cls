global class InwiB2C_RunResiliationVIPSubsMass {

@future(callout=true)
Public static void RunResiliationVIPSubsMass(String inputMap)
{ 
    System.debug('inside myMethod...'); //do your callout logic here... System.debug('exiting myMethod...');
    String IP_UpdatesSubscription = 'inwib2c_InwiB2C_SubsMassResiliationRecouvrement';
    Map <String, Object> ipOutput = new Map <String, Object> ();
    Map <String, Object> ipOptions = new Map <String, Object> ();
    Map <String, Object> ipInput = (Map <String, Object>)JSON.deserializeUntyped(inputMap);
    /* Call the IP via runIntegrationService, and save the output to ipOutput */
    ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IP_UpdatesSubscription , ipInput, ipOptions);
    system.debug('OUTPUT FOR RESILIATION RECOUVREMENT : '+ ipOutput);
}
}