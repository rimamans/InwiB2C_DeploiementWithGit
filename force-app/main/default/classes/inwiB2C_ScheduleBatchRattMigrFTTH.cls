global class inwiB2C_ScheduleBatchRattMigrFTTH implements Schedulable {
    public void execute(SchedulableContext sc) {
        inwiB2C_BatchRattrapageMigrationFTTH batch = new inwiB2C_BatchRattrapageMigrationFTTH();
        Database.executeBatch(batch, 100);
    }
}