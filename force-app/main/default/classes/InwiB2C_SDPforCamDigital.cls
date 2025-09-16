global without sharing class InwiB2C_SDPforCamDigital {
    public Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        if (methodName.equals('callSDP')) {
            callSDP(input, output, options);
        }
        return true;
    } 
    public static void callSDP(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        
        String demandeId = (String) input.get('demandeId');
        String IPName = 'inwib2c_handleSDPSubscriptionMigrationCam';

        Map < String, Object > outputSDP = new Map < String, Object >();
        Map < String, Object > inputSDP = new Map < String, Object >();
        Map < String, Object > optionsSDP = new Map < String, Object >();
        inputSDP.put('demandeId', demandeId);

        outputSDP = (Map < String, Object > ) vlocity_cmt.IntegrationProcedureService.runIntegrationService(IPName, inputSDP, optionsSDP);
        System.debug(outputSDP);
    }
}