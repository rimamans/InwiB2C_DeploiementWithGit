public with sharing class InwiB2C_callHandleSaveTickets {

    @future(callout = true)
    public static void CallVIP(List<String> input){
        List<Case> ListCase = new  List<Case>();
        
     ListCase = [SELECT Id,CaseNumber,Status,vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c,vlocity_cmt__SubscriptionId__c,Inwib2c_Cat_gorie__c,InwiB2C_Detail__c,InwiB2C_TypeSpecialite__c,Inwib2c_la_file_d_attente__c FROM Case  WHERE ID in: input  ];

    Map<String, Object> inputvip = new Map<String, Object>();
    Map<String, Object> ipOutput = new Map<String, Object>();
    Map<String, Object> ipOptions = new Map<String, Object>();
    String procedureName = 'inwib2c_InwiB2C_NotifyBSCSCrtOrCloseCase';    
        for(Case caseObj : ListCase ){
            system.debug('caseObj'+caseObj.Id);
         inputvip.put('CaseId',caseObj.Id);
         inputvip.put('caseNumber',caseObj.CaseNumber);    
         inputvip.put('mdn',caseObj.vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c);
         inputvip.put('Status','CLOSED');
         inputvip.put('SubscriptionId',caseObj.vlocity_cmt__SubscriptionId__c);
         inputvip.put('categorie',caseObj.Inwib2c_Cat_gorie__c);
         inputvip.put('Detail',caseObj.InwiB2C_Detail__c);
         inputvip.put('TypeSpecialite',caseObj.InwiB2C_TypeSpecialite__c);
         inputvip.put('Queue',caseObj.Inwib2c_la_file_d_attente__c);
         ipOutput = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, inputvip, ipOptions);
            system.debug('ipOutput:'+ipOutput);
        }
    }
}