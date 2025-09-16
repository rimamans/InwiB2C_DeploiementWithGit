public class InwiB2C_VIP_ModifCoordBancaire {
@InvocableMethod
    
  public static void callVIP(List<Id> accountIdList){
    for (Id  accountId : accountIdList) {
      InwiB2C_VIP_ModifCoordBancaire.execCallVIP(accountId);
         InwiB2C_VIP_ModifCoordBancaire.execCallVIPIMX(accountId);
         InwiB2C_VIP_ModifCoordBancaire.execCallVIPBSCS(accountId);
    } 
  }
     @future(callout=true)
  public static void execCallVIP(Id accountId){

    System.debug('in execCallVIP');

    Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('Id', accountId);
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_BillingAccountSyncInPS', ipInput, ipOptions));
      System.debug('response PS '+ output);
  }
     @future(callout=true)
  public static void execCallVIPIMX(Id accountId){
    Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('Id', accountId);
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwi_InwiB2C_IMXUpdateBillingAccountInfo', ipInput, ipOptions));
  }
     @future(callout=true)
  public static void execCallVIPBSCS(Id accountId){
    Map<String, Object> ipInput = new Map<String, Object>();
    ipInput.put('Id', accountId);
    Map<String, Object> ipOptions = new Map<String, Object>();
    Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('Inwi_InwiB2C_BSCSUpdateBillingAccountInfo', ipInput, ipOptions));
  }
}