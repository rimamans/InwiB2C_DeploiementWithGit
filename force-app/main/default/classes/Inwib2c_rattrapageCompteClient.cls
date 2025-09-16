public class Inwib2c_rattrapageCompteClient  {

     
                    

    //List<Inwib2c_rattrapageCompteClient__c> rattrapageListe =new List <Inwib2c_rattrapageCompteClient__c>();
    @future(callout=true)
    public static void execCallVIP(){ 

        String procedureName ='Inwi_InwiB2C_ReCreateCustomerLegacy';
		List<Inwib2c_rattrapageCompteClient__c> liste = new List<Inwib2c_rattrapageCompteClient__c>([SELECT Id,AccountId__c FROM Inwib2c_rattrapageCompteClient__c]);
        //List<Inwib2c_rattrapageCompteClient__c> liste = new List<Inwib2c_rattrapageCompteClient__c>([SELECT Id,AccountId__c FROM Inwib2c_rattrapageCompteClient__c WHERE inwiB2C_Status__c='Nouveau']);
        Map<String, Object> vipInput = new Map<String, Object> ();
        Map<String, Object> vipOutput = new Map<String, Object> ();
        Map<String, Object> vipOptions = new Map<String, Object> ();
        system.debug('liste: '+liste);
       
         List<Inwib2c_rattrapageCompteClient__c> clientList =new List <Inwib2c_rattrapageCompteClient__c>();
        for(Inwib2c_rattrapageCompteClient__c data:liste){
            System.debug('in execCallVIP');
            vipInput.put('AccountId', data.AccountId__c);

            vipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, vipInput, vipOptions);
             system.debug('output: '+vipOutput);
            //Decimal vipStatus = (Decimal) vipOutput.get('status');
            //System.debug('vipStatus: '+vipStatus);
            //if(vipStatus==1){
            //data.inwiB2C_Status__c='Terminer';
            //clientList.add(data);
           	//}else{
            //data.inwiB2C_Status__c='Erreur';
            //clientList.add(data);}
            clientList.add(data);
        }
        system.debug('clientList: '+clientList);
        update clientList;
    }
}