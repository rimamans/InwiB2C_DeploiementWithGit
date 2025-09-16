public class InwiB2C_UpdateRecordFromObject {
        public InwiB2C_UpdateRecordFromObject(ApexPages.StandardController controller) {
            this.controller = controller;
        }
        public PageReference getRedir() {
            PageReference newPage;
            
            InwiB2C_Demande__c Record = [Select id From InwiB2C_Demande__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
         //   INWIB2C_HIST_ACTION_LINE__c RecordAction = [Select id From INWIB2C_HIST_ACTION_LINE__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
            string IdRecord=Record.Id;
          //  string IdRecordAction=RecordAction.Id;

                newPage = Page.InwiB2C_UpdateRecordFromObject;
                if (IdRecord !=null ){
                if ( newPage != null) {
                    newPage.getParameters().put('id', Record.id);

            }}
            
        
            return newPage.setRedirect(true);
        }
        private final ApexPages.StandardController controller;  
    }