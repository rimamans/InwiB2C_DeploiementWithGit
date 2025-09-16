public class inwiB2C_BatchDemandeDegIterable implements Iterable<Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>> {

    private Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedRecords;
    private List<String> keys;

    public inwiB2C_BatchDemandeDegIterable(Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedRecords) {
        this.groupedRecords = groupedRecords;
        this.keys = new List<String>(groupedRecords.keySet());
    }
    
    public Iterator<Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>> iterator() {
        return new inwiB2C_BatchDemandeDegIterator(groupedRecords, keys);
    }
}