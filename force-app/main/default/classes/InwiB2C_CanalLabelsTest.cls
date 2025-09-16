/*B-0162 MANSRim 20/12/2021 Begin*/
@isTest
public class InwiB2C_CanalLabelsTest { 
@isTest(SeeAllData=true)
   	static void MethodTestPositive()
{
    Map<String,Object> outMap = new  Map<String,Object>();
    Map<String,Object> options = new  Map<String,Object>();
	Map<String,Object> inputMap = new  Map<String,Object>();
  
List<Map<String, Object>> liste = new List <Map<String, Object>>();
Map<String, Object> mape = new Map<String, Object>();
mape.put('Canal', 'inwiB2C_USSD');

liste.add(mape);
    Map<String, Object> listeAll=new Map<String, Object>();
    inputMap.put('List',liste);
    
    
    

    
   

    
    
    


    
    



   InwiB2C_CanalLabels cls = new InwiB2C_CanalLabels(); 

   boolean result = cls.invokeMethod('labelCanal',inputMap, outMap, options);
      //  System.debug('La valeur de outMap' + inputMap);
  //  System.debug('La valeur de outMap' + outMap);
    System.assertEquals(true, result);
   
    
    }
}
/*B-0162 MansRIM 01/01/2021 end*/