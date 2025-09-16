public without sharing class RecordDeletionHelper implements Queueable {
    
    private Id recordId;

    // Constructor to initialize the recordId
    public RecordDeletionHelper(Id recordId) {
        this.recordId = recordId;
    }
    
     public void execute(QueueableContext context) {
        try {
            // Query the record in system context (no sharing rules)
            InwiB2C_offre_ciblee__c recordToDelete = [SELECT Id, OwnerId FROM InwiB2C_offre_ciblee__c WHERE Id = :recordId LIMIT 1];

            delete recordToDelete;

            System.debug('Record deleted successfully: ' + recordId);
        } catch (Exception e) {
            System.debug('Error deleting record: ' + e.getMessage());
            throw new AuraHandledException('Failed to delete record: ' + e.getMessage());
        }
    }
   /* public static void deleteRecord(Id recordId) {

        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		System.debug('Record ID: ' + recordId);

        InwiB2C_offre_ciblee__c targetRecord = [SELECT Id FROM InwiB2C_offre_ciblee__c WHERE Id = :recordId LIMIT 1];

        delete targetRecord;
    }*/


}