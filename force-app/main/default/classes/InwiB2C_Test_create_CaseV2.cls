@isTest
public class InwiB2C_Test_create_CaseV2 {
    @isTest(SeeAllData=true)
static void MethodTestPositive()
{
    
    Map<String,Object> outMap = new  Map<String,Object>();
    Map<String,Object> outMapCommunity = new  Map<String,Object>();

    Map<String,Object> options = new  Map<String,Object>();
    Map<String,Object> optionsCommunity = new  Map<String,Object>();

    Map<String,Object> inputMap = new  Map<String,Object>();
    Map<String,Object> inputMapCommunity = new  Map<String,Object>();

    
        String TypeRecCom ='Inwib2c_Reclamation';
        String TypesCom ='Inwib2c_Reclamation';
        String CategorieCom ='Inwib2c_Reseau_Reclamation';
        String TypeSpecialiteCom ='InwiB2C_Roaming';
        String DetailCom ='Réception' ;
        String DescriptifCom ='deskkkc' ;
        String RecapitulatifCom ='recapbnnnnn jnj';
        String SubscriptionIdCom ='a4k3L0000003pqkQAA';
        String ContIdCom ='0033L00000a2QaNQAU';
        String AccIdCom ='0013L00000eY493QAC';
        String  BillingAccIdCom ='0012z000002cxWAAAY'; 
        String OffreType ='FTTH';
    
    
    
    
    
    
   
        String TypeRec ='Inwib2c_Reclamation';
        String Types ='Inwib2c_Reclamation' ;
        String Categorie ='Inwib2c_Reseau_Reclamation' ;
        String TypeSpecialite = 'InwiB2C_Roaming' ;
        String Detail ='Réception';
        String Descriptif ='desc';
        String Recapitulatif ='recap';
        String Source ='Appel_entrant';
        String SubscriptionId ='a4k3L0000003esaQAA';
        String ContId ='0033L00000VBGvXQAX';
        String AccId ='0013L00000WrOEAQA3';
        String  BillingAccId ='0012z000002av4iAAA';
       
        Id profileId=userinfo.getProfileId();



          Id sysAdminProfileId=[Select Id,Name from Profile where Name='Inwi POS'].Id;
         if(profileId != sysAdminProfileId){


            inputMap.put('TypeRec',TypeRec);   
            inputMap.put('Type',Types);
            inputMap.put('Categorie',Categorie);
            inputMap.put('TypeSpecialite',TypeSpecialite);
            inputMap.put('Detail',Detail);
            inputMap.put('Descriptif',Descriptif);
            inputMap.put('Recapitulatif',Recapitulatif);
            inputMap.put('Source',Source);
            inputMap.put('SubscriptionId',SubscriptionId);
            inputMap.put('ContId',ContId);
            inputMap.put('AccId',AccId);
            inputMap.put('BillingAccId',BillingAccId);
            inputMap.put('OffreType',OffreType);
               
     }
  

    
   
        
       Profile p = [select id from profile where name='Inwi POS' limit 1];
       ID pname = p.Id;
        Account acc = [SELECT id, name FROM Account WHERE name = 'Inwi' limit 1];
    String Acco=acc.id;
       
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

        Contact con = new Contact(LastName ='testCon',AccountId = Acco);
        insert con;  
                  
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = pname, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
       
        insert user;
        system.runAs(user) {
        
 
        
        
        
        
        
            inputMapCommunity.put('TypeRec',TypeRecCom );   
            inputMapCommunity.put('Type',TypesCom );
            inputMapCommunity.put('Categorie',CategorieCom );
            inputMapCommunity.put('TypeSpecialite',TypeSpecialiteCom );
            inputMapCommunity.put('Detail',DetailCom );
            inputMapCommunity.put('Descriptif',DescriptifCom);
            inputMapCommunity.put('Recapitulatif',RecapitulatifCom );
            inputMapCommunity.put('Source','Visite client au PDV');
            inputMapCommunity.put('SubscriptionId',SubscriptionIdCom );
            inputMapCommunity.put('ContId',ContIdCom );
            inputMapCommunity.put('AccId',AccIdCom);
            inputMapCommunity.put('BillingAccId',BillingAccIdCom );
            inputMapCommunity.put('OffreType',OffreType);
    InwiB2C_CreateCaseForTest clsC = new InwiB2C_CreateCaseForTest(); 

        boolean result2 = clsC.invokeMethod('creationCase',inputMapCommunity, outMapCommunity, optionsCommunity);
   //System.assertEquals(true,result2);
     }

    
               
   InwiB2C_CreateCase cls = new InwiB2C_CreateCase();
    
   boolean result = cls.invokeMethod('creationCase',inputMap, outMap, options); 
      
  

    
    
    
    
    
    
  
    
    
    
    
           
}

}
/*B-0162 MANSRim 11/01/2021 End*/