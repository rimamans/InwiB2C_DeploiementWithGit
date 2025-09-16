public with sharing class InwiB2C_ScheduCCBulkRattrapageAssetBatch implements Schedulable {
    public void execute(SchedulableContext sc) {
        InwiB2C_CCBulkRattrapageAssetBatch b = new InwiB2C_CCBulkRattrapageAssetBatch(); 
        database.executebatch(b,100);
    }
}