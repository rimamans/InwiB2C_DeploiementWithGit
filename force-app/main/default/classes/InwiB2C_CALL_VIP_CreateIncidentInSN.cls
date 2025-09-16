public with sharing class InwiB2C_CALL_VIP_CreateIncidentInSN {
    
      @InvocableMethod
      public static void callVIPById(List<Id> caseIdList) {
        if (caseIdList != null && !caseIdList.isEmpty()) {
            for ( Id caseId : caseIdList)
            {
                // Id caseId = caseIdList[0];
            Case caseRecord = [SELECT Status FROM Case WHERE Id = :caseId LIMIT 1];
            
            if (caseRecord != null && System.IsBatch() != true && System.isFuture() != true) {
                if (caseRecord.Status == 'InwiB2C_Escalade') {
                    InwiB2C_CALL_VIP_CreateIncidentInSN.execCallCreateVIP(caseId);
                } else {
                    InwiB2C_CALL_VIP_CreateIncidentInSN.execCallCloseVIP(caseId);
                }
            }
            }
        }
    }
  
    
    @future(callout=true)
    public static void execCallCreateVIP(Id caseId) {
       

    Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('CaseId', caseId);
    ipInput.put('Step', 'CallEvent');
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_CreateCaseSN', ipInput, ipOptions));
        
    System.debug('VIP Response: ' + JSON.serialize(output));
    System.debug('ipResponse: ' + String.valueOf(output.get('result')));
    System.debug('Calling VIP Create service SN for CaseId: ' + caseId);
      
    }
    @future(callout=true)
    public static void execCallCloseVIP(Id caseId){
    Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('CaseId', caseId);
    ipInput.put('Step', 'CallEvent');
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_InwiB2C_Close_incidentSN', ipInput, ipOptions));
        
       System.debug('Calling VIP Update service SN for CaseId: ' + caseId);

  }
    
}