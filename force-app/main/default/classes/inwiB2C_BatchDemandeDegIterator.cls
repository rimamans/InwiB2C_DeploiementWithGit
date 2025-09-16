public class inwiB2C_BatchDemandeDegIterator implements Iterator<inwiB2C_BatchDemandeDegIterator.GroupWrapper> {

    private Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedRecords;
    private List<String> keys;
    private Integer currentIndex = 0;
    
    public inwiB2C_BatchDemandeDegIterator(Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> groupedRecords, List<String> keys) {
        this.groupedRecords = groupedRecords;
        this.keys = keys;
    }
    
    public Boolean hasNext() {
        return currentIndex < keys.size();
    }
    
    public inwiB2C_BatchDemandeDegIterator.GroupWrapper next() {
        String key = keys[currentIndex];
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> value = groupedRecords.get(key);
        currentIndex++;
        
        Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>> nextValue = new Map<String, List<INWIB2C_DEMANDE_DEGROUPAGE__c>>();
		nextValue.put(key, value);

       if(hasNext()) {
           return new GroupWrapper(key, value);
       } else {
           throw new NoSuchElementException('Iterator has no more elements.');
       }
   } 
    
     public class GroupWrapper  {
        public String key;
        public List<INWIB2C_DEMANDE_DEGROUPAGE__c> records;

        public GroupWrapper(String key, List<INWIB2C_DEMANDE_DEGROUPAGE__c> records) {
            this.key = key;
            this.records = records;
        }
    }
}