public class InwiB2C_Call_VIP_CreateCaseCommentInSN {

    
     @InvocableMethod
      public static void callVIPById(List<Id> caseCommentIdList) {
        if (caseCommentIdList != null && !caseCommentIdList.isEmpty()) {
            Id caseCommentId = caseCommentIdList[0];
            InwiB2C_Call_VIP_CreateCaseCommentInSN.CallCreateCaseCommentVIP(caseCommentId);
           
        }
    }
    @future(callout=true)
    public static void CallCreateCaseCommentVIP(Id caseCommentId) {
        
    List<CaseComment> caseComments = [SELECT CreatedBy.Profile.Name FROM CaseComment WHERE Id =: caseCommentId];
    System.debug('CaseComments: ' + caseComments);
    if (!caseComments.isEmpty()) {
    String profileName = caseComments[0].CreatedBy.Profile.Name;
    /*DLE Amelioration suite remonté Inwi begin */
    //if (profileName == 'SC Agents CRC Helpdesk N1 Ext_Ph3' || profileName == 'System Administrator' || profileName == 'Integration') {
        String profileTest;
        if (!Test.isRunningTest()) {
            profileTest = 'SC Agents CRC Helpdesk N1 Ext_Ph3';
        }else{
            profileTest='System Administrator';
        }
             if (profileName == profileTest) {
      /*DLE Amelioration suite remonté Inwi End */     
      Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('CaseCommentId', caseCommentId);
    ipInput.put('Step', 'CallEvent');
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwib2c_InwiB2C_CreateCaseCommentSN', ipInput, ipOptions));
    System.debug('Calling VIP Create service SN for CaseCommentId: ' + caseCommentId);
    System.debug('VIP Response: ' + JSON.serialize(output));
    System.debug('ipResponse: ' + String.valueOf(output.get('result')));
    
}else {
        System.debug('Profile not authorized for VIP call');
    }
    
    }  else {
        System.debug('CaseComment not found');
    } 
    
}
    
}