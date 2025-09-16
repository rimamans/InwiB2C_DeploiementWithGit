public class inwib2c_Identifi_pdv_call48h {
   @future(callout = true)
    public static void callVIP(String input){
         Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(input);
        Map<String, Object> output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_Update_IdentificationPDV48h', data, null));
         Map<String, Object> log_input = new Map<String, Object>();
        log_input.put('input', input);
        log_input.put('output', String.valueOf(json.serialize(output)));
        String status = '0';
        if (output.get('reference') != null){
            status = '1';
        }
        log_input.put('status', status);
       log_input.put('type', 'UpdateIdentification');
      //  log_input.put('endpoint', '/inwi-api/communicationManagement/v1/communicationMessage');
        Map<String, Object> output_log = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_SynchroLog', log_input, null));

    }
}