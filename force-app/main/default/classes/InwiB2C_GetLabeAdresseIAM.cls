global with sharing class InwiB2C_GetLabeAdresseIAM implements vlocity_cmt.VlocityOpenInterface2{ 
    global static Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        

         Boolean result = true;    
        try{
            
            if(methodName.equals('GetLabelAdresseIAM')){
                GetLabelAdresseIAM(input, output,options);                                                      
            }     
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result; 
   }    
public static void GetLabelAdresseIAM (Map<String, Object> AdressIamConcat,Map<String,Object> output, Map<String,Object> options){
Map<String, String> insertAdresse = new Map<String, String>();
List<String> listSplite = new List<String>();
for (String key : AdressIamConcat.keySet())
{
    if(key=='AdressIamConcat'){
                String addresse = JSON.serialize(AdressIamConcat.get(key));
                listSplite = addresse.split('\\|', -1);
            }
      }


Map<Integer,String> formatAddresse = new Map<Integer,String>{0 =>'PORTE',1=>'ETAGE', 2=>'ESC', 3=>'BAT', 4=>'NVOIE', 5=>'way_label', 6=>'district_label',7 =>'municipality_label',8=>'city_label'};
for (Integer key : formatAddresse.keySet())
{
if(listSplite[key].indexOf(';')== -1){

insertAdresse.put(formatAddresse.get(key),listSplite[key]);

}else{
insertAdresse.put(formatAddresse.get(key), listSplite[key].substring(listSplite[key].indexOf(';') + 1));
}                        
}


System.debug('insertAdress : ' + insertAdresse);

String way_label = insertAdresse.get('way_label');
String district_label = insertAdresse.get('district_label');
String municipality_label = insertAdresse.get('municipality_label');
String city_label = insertAdresse.get('city_label');
String streetNum = insertAdresse.get('NVOIE');
if (city_label.endsWith('"')) {
            city_label = city_label.substring(0, city_label.length() - 1); // Retirer le dernier caractère
        }
System.debug('citylabel : ' + city_label);
    output.put('way_label',insertAdresse.get('way_label'));
    output.put('district_label',insertAdresse.get('district_label'));
    output.put('municipality_label',insertAdresse.get('municipality_label'));  
    output.put('city_label',city_label); 
    output.put('streetNum',streetNum);  
    System.debug('citylabel : ' + city_label);

        
        }

}