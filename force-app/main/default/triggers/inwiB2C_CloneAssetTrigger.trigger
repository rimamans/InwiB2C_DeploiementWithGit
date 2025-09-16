trigger inwiB2C_CloneAssetTrigger on inwiB2C_CloneAssetEvent__e (after insert) {
    for (inwiB2C_CloneAssetEvent__e event : Trigger.New) {
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();
        
        ipInput.put('inwiB2C_Canal__c', event.inwiB2C_Canal__c);
        ipInput.put('inwiB2C_ContractId__c', event.inwiB2C_ContractId__c);
        ipInput.put('inwiB2C_businessreference__c', event.inwiB2C_businessreference__c);
        ipInput.put('inwiB2C_CustomerId__c', event.inwiB2C_CustomerId__c);
        ipInput.put('inwiB2C_assetId__c', event.inwiB2C_assetId__c);
        ipInput.put('inwiB2C_Icc__c', event.inwiB2C_Icc__c);
        ipInput.put('inwiB2C_imsi__c', event.inwiB2C_imsi__c);
        ipInput.put('inwiB2C_ki__c', event.inwiB2C_ki__c);
        ipInput.put('inwiB2C_Mdn__c', event.inwiB2C_Mdn__c);
        ipInput.put('inwiB2C_ProfileId__c', event.inwiB2C_ProfileId__c);
        ipInput.put('inwiB2C_puk__c', event.inwiB2C_puk__c);
        ipInput.put('inwiB2C_CodeArticle__c', event.inwiB2C_CodeArticle__c);
        ipInput.put('inwiB2C_MdnOCSID__c', event.inwiB2C_MdnOCSID__c);
        ipInput.put('inwiB2C_SimOCSID__c', event.inwiB2C_SimOCSID__c);
        ipInput.put('inwiB2C_IdCreateContractBulk__c', event.inwiB2C_IdCreateContractBulk__c);
         //chb 20/03/2025 ano B-27310 begin
        ipInput.put('inwiB2C_Volte__c', event.inwiB2C_Volte__c);
         //chb 20/03/2025 ano B-27310 END
         //amine Bourema 28/03/2024
        ipInput.put('inwib2c_TypeCarteSIM__c', event.inwib2c_TypeCarteSIM__c);
   
        String inputSerialized = JSON.serialize(ipInput);
        if(!Test.isRunningTest()) {
            InwiB2C_CreateClonedAsset.CloneAsset(inputSerialized);
        }
    }
}