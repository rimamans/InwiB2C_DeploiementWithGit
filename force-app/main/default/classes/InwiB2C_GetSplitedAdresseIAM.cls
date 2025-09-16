global with sharing class InwiB2C_GetSplitedAdresseIAM implements vlocity_cmt.VlocityOpenInterface2{ 
    global static Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        

         Boolean result = true;    
        try{
            
            if(methodName.equals('GetSplitedAdresseIAM')){
                GetSplitedAdresseIAM(input, output,options);                                                      
            }     
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result; 
   }    
public static void GetSplitedAdresseIAM (Map<String, Object> AdressIamConcat,Map<String,Object> output, Map<String,Object> options){
Map<String, String> insertAdresse = new Map<String, String>();
List<String> listSplite = new List<String>();
for (String key : AdressIamConcat.keySet())
{
    if(key=='AdressIamConcat'){
                String addresse = JSON.serialize(AdressIamConcat.get(key));
                listSplite = addresse.split('\\|',-1);
            }
      }

Map<Integer,String> formatAddresse = new Map<Integer,String>{0 =>'PORTE',1=>'ETAGE', 2=>'ESC', 3=>'BAT', 4=>'NVOIE', 5=>'way_code', 6=>'district_code',7 =>'municipality_code',8=>'city_code'};
for (Integer key : formatAddresse.keySet())
{
if(listSplite[key].indexOf(';')== -1)
insertAdresse.put(formatAddresse.get(key),listSplite[key]);
else
insertAdresse.put(formatAddresse.get(key),listSplite[key].substring(0,listSplite[key].indexOf(';')));
                        
}
String way_code = insertAdresse.get('way_code');
String district_code = insertAdresse.get('district_code');
String municipality_code = insertAdresse.get('municipality_code');
String city_code = insertAdresse.get('city_code');
    output.put('way_code',insertAdresse.get('way_code'));
    output.put('district_code',insertAdresse.get('district_code'));
    output.put('municipality_code',insertAdresse.get('municipality_code'));  
    output.put('city_code',insertAdresse.get('city_code')); 
    output.put('floorNum',insertAdresse.get('ETAGE')); 
    
        
        }

}