public with sharing class inwB2C_RattrapageSynchClientFuture {

    @future(callout = true)
    Public static void synchClient(ID AccountId){

        Map <String, Object> outMap = new Map <String, Object> ();
        Map <String, Object> options = new Map <String, Object> ();
        Map <String, Object> inputMap = new Map <String, Object> ();

        inputMap.put('AccountId', AccountId);
        

        String procedureName = 'Inwi_InwiB2C_ReCreateCustomerLegacy';
                
        outMap = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, inputMap, options);

    }
}