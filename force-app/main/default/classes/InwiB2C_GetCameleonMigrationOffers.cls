global with sharing class InwiB2C_GetCameleonMigrationOffers implements vlocity_cmt.VlocityOpenInterface2  {
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
        Boolean result = true;    
       try{
           if(methodName.equals('getOffres')){
            getOffres(input, output, options);                                                      
           }     
       } catch(Exception e){
                      
           result = false;
                   
       }     
       return result;            
  }
  public static void getOffres(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
    //String jsonString ='{"offreCode":"INWIB2C_OFFERING_CAM_FORFAIT30J49RS","userProfile":"Inwi POaS"}';
    //Map<String, Object> input = new Map<String,Object>();
    //input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
    String request;
      
    //Meryem Yahya TTM: MGEN3632SF- Migrations Caméléon 
    Boolean hasPermissionSetFlexi = Boolean.valueOf(input.get('hasPermissionSetFlexi'));
    Integer nmbPayedInvoices = (Integer) input.get('nmbPayedInvoices');
     
    //if(input.get('userProfile')=='Inwi POS') 
    if(input.get('userProfile')=='Inwi POS' || nmbPayedInvoices >= 3)
        request = 'SELECT id,INWIB2C_OFFRE_DESTINATION__c,INWIB2C_PRIX_MIGRATION__c,InwiB2C_Profil_destination__c FROM INWIB2C_FRAIS_MGR_CML__c WHERE INWIB2C_OFFRE_SOURCE__c=\''+input.get('offreCode')+'\'';
    else
        request='SELECT id,INWIB2C_OFFRE_DESTINATION__c,INWIB2C_PRIX_MIGRATION__c,InwiB2C_Profil_destination__c FROM INWIB2C_FRAIS_MGR_CML__c WHERE INWIB2C_PRIX_MIGRATION__c ='+0+' and INWIB2C_OFFRE_SOURCE__c=\''+input.get('offreCode')+'\'';
    
    List<Object> listOffres = new List<object>();
    
    List<INWIB2C_FRAIS_MGR_CML__c> offres = DataBase.query(request);
      
    for(INWIB2C_FRAIS_MGR_CML__c iter : offres){
        Map<String,String> mapTmp = new Map<String,String>();
        Product2 produit = [Select id,Name,inwiB2C_Show_Flexi__c from Product2 where productCode =: iter.INWIB2C_OFFRE_DESTINATION__c limit 1];
        if((produit.inwiB2C_Show_Flexi__c == true && hasPermissionSetFlexi == true) || produit.inwiB2C_Show_Flexi__c == false ){
        PricebookEntry prix = [select id,UnitPrice from PricebookEntry where ProductCode =: iter.INWIB2C_OFFRE_DESTINATION__c limit 1];
        mapTmp.put('name',produit.Name);
        mapTmp.put('code',iter.INWIB2C_OFFRE_DESTINATION__c);
        mapTmp.put('prix',String.valueOf(prix.UnitPrice));
        mapTmp.put('prixMigration',String.valueOF(iter.INWIB2C_PRIX_MIGRATION__c));
        mapTmp.put('profil',iter.InwiB2C_Profil_destination__c);
        listOffres.add(mapTmp); 
       }
      //Meryem Yahya TTM: MGEN3632SF- Migrations Caméléon        
    }
    output.put('offres',listOffres);
}
}