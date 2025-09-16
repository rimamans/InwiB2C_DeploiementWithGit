public with sharing class RetailStore {
    @AuraEnabled
    public static void createRetailStoreRecord(String AccountName,String BoutiqueName, String firstName, String lastName,String locationName) {
        Contact contact = new Contact() ;
        contact.FirstName = firstName;
        contact.LastName = lastName;
        insert contact;

	    Account account=new Account() ;
        account.Name = AccountName ;
        insert account ;

        Schema.Location newLocation = new Schema.Location(name = locationName ) ;
        //newLocation.name = locationName;
        insert newLocation;

        Schema.RetailStore store = new Schema.RetailStore();
        store.Name = BoutiqueName;
        insert store;
    }
}