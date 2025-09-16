global with sharing class inwiB2C_AsynchUpdateResiliation implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;
        if (methodName.equals('UpdateSaveDesk')){
            UpdateSaveDesk(inputMap, outMap, options);  
        }else if(methodName.equals('CancelRequest')){
            CancelRequest(inputMap, outMap, options);
        }
        return result;
    }

     
     public static void UpdateSaveDesk(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Id SubscriptionId = (String) inputMap.get('SubscriptionId');
        Id idrequesttoresil = (String) inputMap.get('idrequesttoresil');
        /*chb 24/06/2024 ano B-17416 Begin */
        Boolean createDR= (Boolean)inputMap.get('createDR');
         /*chb 24/06/2024 ano B-17416 End */
        List<vlocity_cmt__Subscription__c > SubsList =new List <vlocity_cmt__Subscription__c >();
        List<InwiB2C_Demande_de_resiliation__c > ResilList =new List <InwiB2C_Demande_de_resiliation__c >();
        List<Group> groupAppelSortant =[select id from Group where DeveloperName ='InwiB2C_Appels_sortant_retention'] ;
        List<InwiB2C_Demande_de_resiliation__c> requestList = [select id,CreatedById,inwiB2C_Canal__c,InwiB2C_Date_de_signature__c from InwiB2C_Demande_de_resiliation__c where id =:idrequesttoresil];
        Id idOwner;
     
        if(requestList[0].inwiB2C_Canal__c=='CRC'){
            idOwner=requestList[0].CreatedById;
        }else{
            idOwner=groupAppelSortant[0].id; 
            }
        
        system.debug('SubscriptionId'+SubscriptionId);
        system.debug('idrequesttoresil'+idrequesttoresil);
       
        SubsList.add(new vlocity_cmt__Subscription__c (id = SubscriptionId, InwiB2C_A_r_silier__c  = true));
         /*chb 24/06/2024 ano B-17416 Begin */
         if(createDR==true){
            ResilList.add(new InwiB2C_Demande_de_resiliation__c (id = idrequesttoresil, InwiB2C_Statut_R_tention__c  = 'Contact CRC',OwnerId=idOwner));
         }else if(createDR!=true && requestList[0].InwiB2C_Date_de_signature__c==null){
            ResilList.add(new InwiB2C_Demande_de_resiliation__c (id = idrequesttoresil, InwiB2C_Statut_R_tention__c  = 'Contact CRC',OwnerId=idOwner,InwiB2C_Date_de_signature__c=Date.today()));
         }
        /*chb 24/06/2024 ano B-17416 end */
        //ano 10967 chb 13/09/2023
        system.debug('listSub'+SubsList);
        system.debug('ResilList'+ResilList);
         if(!Test.isRunningTest()){
        update SubsList;
        update ResilList;
         }
    }
    public static void CancelRequest(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        String IP_CancelResilRequest = 'Inwib2c_InwiB2C_CancelResilRequest';
        map<String,Object> Params = new Map<String,Object>();
        map<String,Object> ipInput = new Map<String,Object>();
        map<String,Object> ipOptions = new Map<String,Object>();
        
        ipInput.put('idrequesttocancel',(String)inputMap.get('idrequesttocancel'));
        ipInput.put('subscriptionid',(String)inputMap.get('subscriptionid'));
        ipInput.put('motifcancel',(String)inputMap.get('motifcancel'));
  
        Params.put('Name',IP_CancelResilRequest);
        Params.put('ipInput',ipInput);
        Params.put('ipOptions',ipOptions);
        system.debug('Params'+(String)JSON.serialize(Params));
        
        //Appler une classe générique pour exécuter la VIP en asynchrone en lui passant les paramétres (Nom/input/options) 
        inwiB2c_executeVIPAsynch.inwiB2c_executeVIPAsynch((String)JSON.serialize(Params));
        inputMap.put('Status','Success');
        List<vlocity_cmt__Subscription__c > SubsList =new List <vlocity_cmt__Subscription__c >();
        SubsList.add(new vlocity_cmt__Subscription__c (id = (String)inputMap.get('subscriptionid'), InwiB2C_A_r_silier__c  = false));
        system.debug('listSubCancel'+SubsList);
         if(!Test.isRunningTest()){
             update SubsList;
         }
    }
}