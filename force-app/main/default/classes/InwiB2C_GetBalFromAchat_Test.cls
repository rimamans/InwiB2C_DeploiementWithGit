@isTest
public class InwiB2C_GetBalFromAchat_Test {
    
 @isTest(SeeAllData=true)
    static void MethodTestPositive()
{
    
     Map<String,Object> outMap = new  Map<String,Object>();
     Map<String,Object> options = new  Map<String,Object>();
     Map<String,Object> inputMap = new  Map<String,Object>();

     List<Map<String, Object>> Liste = new List <Map<String, Object>>();
    Map<String, Object> M_LISTEBAL = new Map<String, Object>();


 
    M_LISTEBAL.put('M_BAL_DEBITEE', '3000:0.01;3001:0.01;');
        M_LISTEBAL.put('M_START_DATE', '2021-09-21 11:11:15');

        M_LISTEBAL.put('M_SERVICE_NAME', 'Pass RS illimité');
      M_LISTEBAL.put('M_AMOUNT_CON', '30');

  
Liste.add(M_LISTEBAL);
    
                     List<Map <String, Object>> finalList = new List <Map <String, Object>>();

      inputMap.put('List',Liste); 
  
    
    
    
    
    
    
    
    InwiB2C_GetBalFromAchat cls = new InwiB2C_GetBalFromAchat(); 

   boolean result = cls.invokeMethod('getBal',inputMap, outMap, options);
     
    System.assertEquals(true, result);
    
}
}