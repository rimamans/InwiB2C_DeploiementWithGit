global class inwiB2C_DegroupageBatchScheduler implements Schedulable {
  global void execute(SchedulableContext sc) {
      
      Integer batchSize;
      Integer iterationNbr;
      inwiB2C_Limit_Annulation_demande_deg__mdt limitMetadata = [
            SELECT inwiB2C_Value__c 
            FROM inwiB2C_Limit_Annulation_demande_deg__mdt 
            WHERE DeveloperName = 'Limite' 
            LIMIT 1
        ];
      inwiB2C_Limit_Annulation_demande_deg__mdt iterationNbrMetadata = [
            SELECT inwiB2C_Value__c 
            FROM inwiB2C_Limit_Annulation_demande_deg__mdt 
            WHERE DeveloperName = 'Iteration_Number' 
            LIMIT 1
        ];
        iterationNbr = Integer.ValueOf(iterationNbrMetadata.inwiB2C_Value__c);
        batchSize = Integer.ValueOf(limitMetadata.inwiB2C_Value__c/iterationNbr);
        inwiB2C_BatchAnnulationDemandeDeg batch = new inwiB2C_BatchAnnulationDemandeDeg(batchSize);
        Database.executeBatch(batch, batchSize); 
    }
}