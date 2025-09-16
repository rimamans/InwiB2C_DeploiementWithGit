public with sharing class InwiB2C_CallSynchroAccountVip{
    @future(callout = true)
    public static void callVIP(String input){
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(input);
        Map<String, Object> output = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwi_InwiB2C_synchoCustomer', data, null));
        System.debug('callVIP - Debug output if success');
        System.debug(json.serialize(output));

        String status = 'failed';

        if (output.get('IBOperation') != null){
            Map<String, Object> IBOperation = (Map<String, Object>)output.get('IBOperation');
            if ('1'.equals(IBOperation.get('isOK'))){
                status = 'sucess';
            }


        }


        Map<String, Object> log_input = new Map<String, Object>();
        log_input.put('input', input);
        log_input.put('output', String.valueOf(json.serialize(output)));
        log_input.put('status', status);
        log_input.put('type', 'FicheClient');
        log_input.put('endpoint', '/CRMPortalCustomer/CSCustomerRest/updateCustomer');

        Map<String, Object> output_log = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_SynchroLog', log_input, null));
    }

}