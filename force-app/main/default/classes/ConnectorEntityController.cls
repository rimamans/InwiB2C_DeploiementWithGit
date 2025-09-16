global with sharing class ConnectorEntityController {

    public ConnectorEntityController() { } 
    
    @RemoteAction
    global static Task createTask(Task task,String field, String value) {
        
        try{        
            List<Contact> contacts = Database.query('Select id,AccountId,Birthdate,Email,FirstName,LastName,Phone from Contact where ' + field + ' = \'' + value + '\'');
            System.debug('contacts found : ' + contacts);
            if ( contacts.size() == 1 ){
                task.WhoId = contacts.get(0).Id;
            } 
            } catch(Exception e){
            System.debug('Error in finding contact ' + e);     
         }

        try{           
            Database.SaveResult sr =  Database.insert(task);
                System.debug('save result : ' + sr);   
            	return task;
            } catch(Exception e){
            System.debug('Error in insert ' + e);
        
         }
        return null;
    }

    @RemoteAction
    global static Case createCase(Case obj,String field, String value) {
        
        try{        
            List<Contact> contacts = Database.query('Select id,AccountId,Birthdate,Email,FirstName,LastName,Phone from Contact where ' + field + ' = \'' + value + '\'');
            System.debug('contacts found : ' + contacts);
            if ( contacts.size() == 1 ){
                obj.ContactId = contacts.get(0).Id;
            } 
            } catch(Exception e){
            System.debug('Error in finding contact ' + e);     
         }

        try{           
            Database.SaveResult sr =  Database.insert(obj);
                System.debug('save result : ' + sr);   
            	return obj;
            } catch(Exception e){
            System.debug('Error in insert ' + e);
        
         }
        return null;
    }

    @RemoteAction
    global static String ERCOmniUtilsPath {
        get {
           return GetResourceURL('softphoneerc','omniUtils');
        }
    }

    @RemoteAction
    global static String ERCiwsscriptomniPath {
        get {
           return GetResourceURL(null,'iwsscript_omni');
        }
    }

     @RemoteAction
    global static String ERCsyncUtilsPath {
        get {
           return GetResourceURL(null,'syncUtils');
        }
    }


    public static String GetResourceURL(String namespace,String resourceName){

        List<StaticResource> resourceList= namespace != null ? 
        [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName AND NamespacePrefix = :namespace] : 
        [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName] ;
            if(resourceList.size() == 1){
                String nm = resourceList[0].NamespacePrefix;
               return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (nm != null && nm != '' ? nm + '__' : '') + resourceName; 
            }
            return ''; 
        
        }
    
    // LDA 20201221 Start : Call Apex Class to create Vlocity Interaction
    // LDA 20201223 : change method signature
    @RemoteAction
    global static String createVlocityInteraction(Id AccountId, String ctiIteractionNumber, String ctiMDN, String ctiSource, String ctiEmailSource, String ctiFacebookId, String ctiTwitterId) {

        Map<String , Object> ctiInput = new Map<String , Object>();
        ctiInput.put('ctiIteractionNumber', ctiIteractionNumber);

        Map<String , Object> data = new Map<String , Object>();

        data.put('ctiSource',ctiSource);
        data.put('ctiEmailSource',ctiEmailSource);
        data.put('ctiFacebookId',ctiFacebookId);
        data.put('ctiTwitterId',ctiTwitterId);
        data.put('ctiMDN',ctiMDN);
        ctiInput.put('data', data);

        System.debug(JSON.serialize(ctiInput));
        
        return inwiB2C_CustomerInteractionMgt.createCustomerInteraction(AccountId, ctiInput);
    }

     // LDA 20201221 Start

//Debut 22/12/2020: Get AccountId from MDN 
    @RemoteAction
    global static String GetAccountId(String MDN) {
        try {
            
            List<vlocity_cmt__Subscription__c> Accounts = Database.query('SELECT vlocity_cmt__AccountId__c, Inwib2c_Num_ro_de_la_ligne__c  FROM vlocity_cmt__Subscription__c  WHERE Inwib2c_Num_ro_de_la_ligne__c = \'' + MDN + '\'');
            System.debug('AccountId found : ' + Accounts);
            if (Accounts.size() == 1) {
                return Accounts[0].vlocity_cmt__AccountId__c;
            } else {
                return null;
            }
        } catch (Exception e) {
            System.debug('Error in execution of query select AccountId');
            return null;
        }
    }
//Fin 22/12/2020: Get AccountId from MDN  

}