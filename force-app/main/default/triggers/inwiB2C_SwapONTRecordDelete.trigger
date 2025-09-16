trigger inwiB2C_SwapONTRecordDelete on inwiB2C_Swap_ONT_Record_Delete_Event__e (after insert) {

    List<InwiB2C_offre_ciblee__c> recordsToDelete = new List<InwiB2C_offre_ciblee__c>();
    List<ID> recordsIDToDelete = new List<ID>();

    // Iterate through the platform events
    for (inwiB2C_Swap_ONT_Record_Delete_Event__e event : Trigger.New) {
   
        recordsIDToDelete.add(event.inwiB2C_Record_Id__c);
    }
    recordsToDelete = [SELECT Id FROM InwiB2C_offre_ciblee__c WHERE Id IN :recordsIDToDelete];

    if (!recordsToDelete.isEmpty()) {
    try {
            delete recordsToDelete;
            System.debug('Records deleted successfully');
        } catch (Exception e) {
            System.debug('Error deleting record: ' + e.getMessage());
            throw new AuraHandledException('Failed to delete record: ' + e.getMessage());
        }
    }
}