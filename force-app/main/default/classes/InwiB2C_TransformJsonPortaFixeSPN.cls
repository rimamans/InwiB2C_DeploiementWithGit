/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-28-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_TransformJsonPortaFixeSPN implements vlocity_cmt.VlocityOpenInterface2 {

    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
        Boolean result = true;    
       try{
           
           if(methodName.equals('TransformJsonPortaFixe')){
            TransformJsonPortaFixe(input, output, options);                                                      
           }     
       } catch(Exception e){
                      
           result = false;
                   
       }     
       return result;            
  }
        public static void TransformJsonPortaFixe(Map<String, Object> deserialized,Map<String,Object> output, Map<String,Object> options){
            Map<String,Object> outputTMP = new Map<String,Object>();
            Map<String,Object> outputTMP2 = new Map<String,Object>();
            Map<String,Object> outputTMP3 = new Map<String,Object>();
            List<Map<String,Object>> listsupportingResource=new List<Map<String,Object>>();
            List<Map<String,Object>> listrelatedParty=new List<Map<String,Object>>();
            List<Map<String,Object>> listtmp=new List<Map<String,Object>>();
            List<Map<String,Object>> listtmp2=new List<Map<String,Object>>();
            List<Map<String,Object>> listtmp3=new List<Map<String,Object>>();
            List<Map<String, Object>> relatedparty = new List<Map<String, Object>>();
          
            
            String value=JSON.serialize(deserialized.get('serviceOrder'));
            Map<String, Object> deserialized2 = (Map<String, Object>)JSON.deserializeUntyped(value);
            List<Map<String, Object>> OrderItem = new List<Map<String, Object>>();
            for (Object instance : (List<Object>)deserialized2.get('orderItem'))
                   OrderItem.add((Map<String, Object>)instance);
            for (String key : OrderItem[0].keySet())
                    if(key=='serviceRefOrValue'){
                        system.debug(key);
                       String value1='{"serviceRefOrValue":'+JSON.serialize(OrderItem[0].get(key))+'}';
                       Map<String, Object> deserialized3 = (Map<String, Object>)JSON.deserializeUntyped(value1);
                       List<Map<String, Object>> serviceRefOrValue = new List<Map<String, Object>>();
                       for (Object instance : (List<Object>)deserialized3.get('serviceRefOrValue'))
                            serviceRefOrValue.add((Map<String, Object>)instance);
                        for (String key1 : serviceRefOrValue[0].keySet())
                            {  
                                if(key1=='supportingResource')
                                {
                                    String value2='{"serviceRefOrValue":'+JSON.serialize(serviceRefOrValue[0].get(key1))+'}';
                                    Map<String, Object> deserialized4 = (Map<String, Object>)JSON.deserializeUntyped(value2);
                                    List<Map<String, Object>> serviceRefOrValue1 = new List<Map<String, Object>>();
                                    for (Object instance : (List<Object>)deserialized4.get('serviceRefOrValue'))
                                        serviceRefOrValue1.add((Map<String, Object>)instance);
                                    for (String key2 : serviceRefOrValue1[0].keySet())
                                    {
                                         Map<String,Object> mapTmp = new Map<String,Object>();
                                         mapTmp.put('name',key2);
                                         mapTmp.put('value',serviceRefOrValue1[0].get(key2));
                                         listsupportingResource.add(mapTmp);
                                    }
                                                     
                                }
                                if(key1=='relatedparty')
                                {
                                    String value3='{"relatedparty":'+JSON.serialize(serviceRefOrValue[0].get(key1))+'}';
                                    Map<String, Object> deserialized5 = (Map<String, Object>)JSON.deserializeUntyped(value3);
                                    
                                    for (Object instance : (List<Object>)deserialized5.get('relatedparty'))
                                        relatedparty.add((Map<String, Object>)instance);
                                    
                                }
                                
                            }
                        outputTMP3.put('supportingResource',listsupportingResource);
                        outputTMP3.put('relatedParty',relatedParty);
                        listtmp3.add(outputTMP3);
                                outputTMP.put('serviceRefOrValue',listtmp3);
                    }
                    else
                    {	
                        outputTMP.put(key,OrderItem[0].get(key));
            
                    }
            listtmp.add(outputTMP);
            outputTMP2.put('orderItem',listtmp);
            output.put('serviceOrder',outputTMP2);
          
        
                }

    
}