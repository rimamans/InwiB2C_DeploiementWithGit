/**
 * @author            : ILA
 * @last modified on  : 20-02-2024
 * @last modified by  : ILA
**/
global with sharing class InwiB2C_getDemandesDegroupage implements vlocity_cmt.VlocityOpenInterface2 {
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
         Boolean result = true;    
        try{
            if(methodName.equals('getDemandes')){
                getDemandes(input, output, options);                                                      
            }     
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result;            
   }
    public static void getDemandes(Map<String, Object> deserialized,Map<String,Object> output, Map<String,Object> options){
        //String jsonString='{"InwiB2C_Account__c":"","InwiB2C_Order__c":"","InwiB2C_dateOrdre__c":"","InwiB2C_StatutLigneIam__c":"","InwiB2C_LastName__c":"Lakrari","InwiB2C_NumeroDesignation__c":"14","InwiB2C_Statutdegroupage__c":"NOU","InwiB2C_DEGROUPAGE_NUM__c":"70000008"}';
       // Map<String, Object> deserialized = new Map<String,Object>();
        //deserialized = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        Map<String,Object> inputs=new Map<String,Object>();
        Map<String,Object> output1=new Map<String,Object>();
        for(String tmp : deserialized.keySet()){
            if(deserialized.get(tmp)!=''){
                inputs.put(tmp,deserialized.get(tmp));
            }        
        }
        Integer size =inputs.size();
        Integer i=0;
        /*B-14273 ILA 20/02/2024 Start*/
        //String req = 'Select Id,InwiB2C_DEGROUPAGE_NUM__c,toLabel(InwiB2C_Statutdegroupage__c),toLabel(InwiB2C_MotifAnnulation__c),toLabel(InwiB2C_typeCommande__c),toLabel(InwiB2C_typePrestation__c),toLabel(InwiB2C_StatutLigneIam__c),toLabel(InwiB2C_Technologie__c),InwiB2C_SEQ_NUM__c,InwiB2C_NumeroDesignation__c,InwiB2C_LastName__c,InwiB2C_FirstName__c,InwiB2C_Nationalid__c,InwiB2C_Motif__c ,InwiB2C_portabilite__c,InwiB2C_dateOrdre__c,InwiB2C_numeroContact__c from INWIB2C_DEMANDE_DEGROUPAGE__c where ';
        String req = 'Select Id,InwiB2C_ORDER_DEGROUPAGE_NUM__c,toLabel(InwiB2C_Statutdegroupage__c),toLabel(InwiB2C_MotifAnnulation__c),toLabel(InwiB2C_typeCommande__c),toLabel(InwiB2C_typePrestation__c),toLabel(InwiB2C_StatutLigneIam__c),toLabel(InwiB2C_Technologie__c),InwiB2C_SEQ_NUM__c,InwiB2C_NumeroDesignation__c,InwiB2C_LastName__c,InwiB2C_FirstName__c,InwiB2C_Nationalid__c,InwiB2C_Motif__c ,InwiB2C_portabilite__c,InwiB2C_dateOrdre__c,InwiB2C_numeroContact__c from INWIB2C_DEMANDE_DEGROUPAGE__c where ';
        /*B-14273 ILA 20/02/2024 End*/
        for(String input : inputs.keySet()){
            if(i==0){
             /*B-14273 ILA 20/02/2024 Start*/
                // if (input == 'InwiB2C_dateOrdre__c' || input =='InwiB2C_DEGROUPAGE_NUM__c' ){
                if (input == 'InwiB2C_dateOrdre__c'){
             /*B-14273 ILA 20/02/2024 End*/
                    req = req+input+'='+inputs.get(input);
                    i++;
                }
                else if(input == 'startDate'){
                    req = req+'InwiB2C_dateOrdre__c >'+inputs.get(input);
                    i++;
               }
               else if(input == 'endDate'){
                    req = req+'InwiB2C_dateOrdre__c <'+inputs.get(input);
                    i++;
               }
                /*B-13618 ILA 09/01/24 Start*/
               else if(input == 'InwiB2C_NumeroDesignation__c'){
                    req = req+'InwiB2C_NumeroDesignation__c =\''+inputs.get(input)+'\' Or InwiB2C_ndOperateur__c=\''+inputs.get(input)+'\'';
                    i++;
               }
                /*B-13618 ILA 09/01/24 End*/
                else{
                    req = req+input+'= \''+inputs.get(input)+'\'';
                    i++;
                }
        
            }
            else{
                /*B-14273 ILA 20/02/2024 Start*/
                //if(input == 'InwiB2C_dateOrdre__c' || input =='InwiB2C_DEGROUPAGE_NUM__c' )
                if(input == 'InwiB2C_dateOrdre__c' )
				/*B-14273 ILA 20/02/2024 End*/
                    req = req+' and '+input+'='+inputs.get(input);
                else if(input == 'startDate')
                    req = req+' and InwiB2C_dateOrdre__c >'+inputs.get(input);
                else if(input == 'endDate')
                    req = req+' and InwiB2C_dateOrdre__c <'+inputs.get(input);
                /*B-13618 ILA 09/01/24 Start*/ 
                else if(input == 'InwiB2C_NumeroDesignation__c')
                    req = req+' and InwiB2C_NumeroDesignation__c =\''+inputs.get(input) +'\' Or InwiB2C_ndOperateur__c=\''+inputs.get(input)+'\'';
                /*B-13618 ILA 09/01/24 End*/
                 else   
                    req = req+' and '+input+'= \''+inputs.get(input)+'\'';
            }     
        }
        req = req+' Order by CreatedDate DESC Limit 50';
        List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandes = DataBase.query(req);
        for (INWIB2C_DEMANDE_DEGROUPAGE__c iter: demandes)
    		output1.put(iter.id,iter);
        Map<String, Object> deserializedDem = new Map<String,Object>();
        
        List<Object> listDemande = new List<Object>();
        for (String cle : output1.keySet()){
            Map<String, Object> output2 = new Map<String,Object>();
             deserializedDem=(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(output1.get(cle)));
             for (String key : deserializedDem.keySet()){
                 if(key != 'attributes' && key != 'RecordTypeId' && key != 'CurrencyIsoCode')
                     output2.put(key,deserializedDem.get(key));    
               }
            listDemande.add(output2);
        }
         	
            output.put('demandes',listDemande);
            }
        }