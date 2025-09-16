public class InwiB2C_VOCCloseTheLoop {
 @InvocableMethod
    public static Void CallVIP(List<String> inputs) {
        
        String jsonString = inputs[0];
        
        System.debug('test1'+ inputs);
        System.debug('test'+ jsonString);
        
        Map<String, Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        

        String procedureName = 'inwib2c_CloseTheLoopVoc';
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();

        ipInput.put('request', inputMap );
  
        ipOutput = (Map <String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions); 
        
        System.debug('output'+ ipOutput);
        

    }
}