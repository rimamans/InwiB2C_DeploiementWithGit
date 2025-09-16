/*B-0162 MANSRim 11/01/2021 Begin*/
@isTest
public class InwiB2C_Test_create_Case {
    @isTest(SeeAllData=true)
static void MethodTestPositive()
{
    Map<String,Object> outMap = new  Map<String,Object>();
    Map<String,Object> outMapCommunity = new  Map<String,Object>();

    Map<String,Object> options = new  Map<String,Object>();
    Map<String,Object> optionsCommunity = new  Map<String,Object>();

    Map<String,Object> inputMap = new  Map<String,Object>();
    Map<String,Object> inputMapCommunity = new  Map<String,Object>();

    Contact cnt = new Contact(LastName='Test',FirstName='Test',InwiB2C_CIN__c='1234',InwiB2C_Type_CIN__c ='CNI');
	Insert cnt;

	Account client = new Account(Name = 'name123',vlocity_cmt__PersonContactId__c=cnt.id);
	insert client;

	Account acctPartner = new Account(Name='Test Agence', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId());
	insert acctPartner;
    
    //vlocity_cmt__Subscription__c subs = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c = '212747160482');
  	vlocity_cmt__Subscription__c subs=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='212611223374', Inwib2c_Num_ro_de_la_ligne__c='212611223374',Name='TEST4', inwiB2C_LegacyStatus__c='ACTIVE',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active', inwiB2C_managedInSF__c = true);
     Insert subs;
    string TypeRecCom ='Inwib2c_HelpDesk';
    String TypesCom ='Inwib2c_HelpDesk' ;
    String CategorieCom = 'Inwib2c_Assistance/service _HelpDesk' ;
    String TypeSpecialiteCom = 'All' ;
    String DetailCom ='Coupure de fibre' ;
    String DescriptifCom ='deskkkc' ;
    String RecapitulatifCom = 'recapbnnnnn jnj' ;
    String SubscriptionIdCom = subs.Id ;
    String ContIdCom = cnt.Id ;
    String AccIdCom = acctPartner.Id ;
    
    string TypeRec ='Inwib2c_HelpDesk';
    String Types ='Inwib2c_HelpDesk' ;
    String Categorie = 'Inwib2c_Assistance/service _HelpDesk' ;
    String TypeSpecialite = 'All' ;
    String Detail ='Coupure de fibre' ;
    String Descriptif ='desc' ;
    String Recapitulatif = 'recap' ;
    String Source = 'Appel_entrant'  ;
    String SubscriptionId = subs.Id ;
    String ContId = cnt.Id ;
    String AccId = client.Id;
    String qualification = 'InwiB2C_Qualification__c';
    Boolean quada = false;
    //String  BillingAccId ='0012z000002av4iAAA' ;
    
    
    
    
    
          /*Id profileId=userinfo.getProfileId();
          Id sysAdminProfileId=[Select Id,Name from Profile where Name='Inwi POS'].Id;
         if(profileId != sysAdminProfileId){}*/
    options.put( 'TypeRec',TypeRec );   
    options.put( 'Type',Types );
    options.put( 'Categorie',Categorie );
    options.put( 'TypeSpecialite',TypeSpecialite );
    options.put( 'Detail',Detail );
    options.put( 'Descriptif',Descriptif );
    options.put( 'Recapitulatif',Recapitulatif );
    options.put( 'Source',Source);
    options.put( 'SubscriptionId',SubscriptionId );
    options.put( 'ContId',ContId );
    options.put( 'AccId',AccId );
    options.put( 'Qualification','true' );  
    options.put( 'BillingAccId',acctPartner.Id);
        
    Id p = [select id from profile where name='Inwi POS'].id;
    Account ac = new Account(name ='Test') ;
    insert ac; 
    Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
    insert con;  
    User user = new User(alias = 'test123', email='test123@noemail.com',

                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',

                localesidkey='en_US', profileid = p, country='United States',IsActive =true,

                ContactId = con.Id,

                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
    insert user;
    system.runAs(user) {
    optionsCommunity.put( 'TypeRec',TypeRecCom );   
    optionsCommunity.put( 'Type',TypesCom );
    optionsCommunity.put( 'Categorie',CategorieCom );
    optionsCommunity.put( 'TypeSpecialite',TypeSpecialiteCom );
    optionsCommunity.put( 'Detail',DetailCom );
    optionsCommunity.put( 'Descriptif',DescriptifCom);
    optionsCommunity.put( 'Recapitulatif',RecapitulatifCom );
    optionsCommunity.put( 'Source','Visite client au PDV');
    optionsCommunity.put( 'SubscriptionId',SubscriptionIdCom );
    optionsCommunity.put( 'ContId',ContIdCom );
    optionsCommunity.put( 'AccId',AccIdCom);
    optionsCommunity.put('Qualification','true'); 
    optionsCommunity.put( 'BillingAccId',acctPartner.Id);
    InwiB2C_CreateCase clsC = new InwiB2C_CreateCase(); 
	boolean result2 = clsC.invokeMethod('creationCase',inputMapCommunity, outMapCommunity, optionsCommunity);
     }

    
               
   InwiB2C_CreateCase cls = new InwiB2C_CreateCase();
   boolean result = cls.invokeMethod('creationCase',inputMap, outMap, options); 


   
  
   
  

    
    
    
    
    
    
  
    
    
    
    
           
}

}
/*B-0162 MANSRim 11/01/2021 End*/