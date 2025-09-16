/*B-0162 MANSRim 01/01/2021 Begin*/
@isTest
public class InwiB2C_BlacklistMotifTest { 
@isTest(SeeAllData=true)
   	static void MethodTestPositive()
{
    Map<String,Object> outMap = new  Map<String,Object>();
    Map<String,Object> options = new  Map<String,Object>();
	Map<String,Object> inputMap = new  Map<String,Object>();

List<Map<String, Object>> liste = new List <Map<String, Object>>();
Map<String, Object> mape = new Map<String, Object>();
mape.put('Motif', 'inwiB2C_Preserver');
//mape.put('Statut', 'InwiB2C_Escalade');

liste.add(mape);
    Map<String, Object> listeAll=new Map<String, Object>();
    ListeAll.put('List',liste);
    
    
    
    


    
inputMap.put('BlackList',listeAll );
   

    
    
    

    
    
 
    
    
    



   InwiB2C_BlackListMotif cls = new InwiB2C_BlackListMotif(); 

   boolean result = cls.invokeMethod('populateLabelsDR_Motif',inputMap, outMap, options);
      //  System.debug('La valeur de outMap' + inputMap);
  //  System.debug('La valeur de outMap' + outMap);
    System.assertEquals(true, result);
    
    
    }
}
/*B-0162 MansRIM 01/01/2021 end*/