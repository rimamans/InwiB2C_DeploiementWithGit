public class InwiB2C_CopyFirstCallDataBatch implements Database.Batchable<sobject>{
    
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, inwiB2C_Canal__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_Icc__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_Mdn__c, inwiB2C_OcsId__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_User__c, inwiB2C_uuid__c, inwiB2C_StatutDeTraitement__c FROM inwiB2C_ContractFirstCall__c WHERE inwiB2C_StatutDeTraitement__c = \'inwiB2C_Nouveau\' limit 2000');
    }

    public void execute (Database.BatchableContext BC, List<sobject> scope) {

        List<inwiB2C_CreateContractBulk__c> contractBulkTempList= new List<inwiB2C_CreateContractBulk__c>();

        for  (sObject scopeLine: scope) {

            inwiB2C_ContractFirstCall__c firstCallTemp = (inwiB2C_ContractFirstCall__c)scopeLine;

            inwiB2C_CreateContractBulk__c contractBulkTemp= new inwiB2C_CreateContractBulk__c();

            contractBulkTemp.inwiB2C_Canal__c = firstCallTemp.inwiB2C_Canal__c;
            contractBulkTemp.inwiB2C_CodeAgence__c = firstCallTemp.inwiB2C_CodeAgence__c;
            contractBulkTemp.inwiB2C_CodeArticle__c = firstCallTemp.inwiB2C_CodeArticle__c;
            contractBulkTemp.inwiB2C_CodeDistributeur__c = firstCallTemp.inwiB2C_CodeDistributeur__c;
            contractBulkTemp.inwiB2C_Icc__c = firstCallTemp.inwiB2C_Icc__c;
            contractBulkTemp.inwiB2C_Ki__c = firstCallTemp.inwiB2C_Ki__c;
            contractBulkTemp.inwiB2C_Mdn__c = firstCallTemp.inwiB2C_Mdn__c;
            contractBulkTemp.inwiB2C_OcsId__c = firstCallTemp.inwiB2C_OcsId__c;
            contractBulkTemp.inwiB2C_ProfileId__c = firstCallTemp.inwiB2C_ProfileId__c;
            contractBulkTemp.inwiB2C_Puk__c = firstCallTemp.inwiB2C_Puk__c;
            contractBulkTemp.inwiB2C_User__c = firstCallTemp.inwiB2C_User__c;
            contractBulkTemp.inwiB2C_uuid__c = firstCallTemp.inwiB2C_uuid__c;
            contractBulkTemp.inwiB2C_imsi__c = firstCallTemp.inwiB2C_imsi__c;
            contractBulkTemp.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Nouveau';

            contractBulkTempList.add(contractBulkTemp);
            firstCallTemp.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Termine';

        }

        insert(contractBulkTempList);
        update(scope);




    }

    public void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select a.id, a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] email = new String[]{'zakaria.mehdid@assa-associates.com'};
        mail.setToAddresses(email);
        mail.setReplyTo('zakaria.mehdid@assa-associates.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process '+a.Status);
        mail.setPlainTextBody('The Batch Apex job ('+ a.id +') processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


}