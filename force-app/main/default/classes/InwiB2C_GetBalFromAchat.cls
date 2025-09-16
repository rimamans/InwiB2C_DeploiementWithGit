global with sharing  class InwiB2C_GetBalFromAchat implements vlocity_cmt.VlocityOpenInterface {


    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            
        if (methodName == 'getBal') {
            outMap.put('result', getBal(inputMap));
        }
             
        return true;
                  
   }


   Map<String,Object> getBal(Map<String,Object> inputMap) {
            system.debug('input'+inputMap);

      
      
          Map<String,Object> bucket = (Map<String,Object>) inputMap;
                system.debug('inputlist'+bucket);
            List <Map<String, Object>> buckets =  (List <Map<String, Object>>) bucket.get('List');
                system.debug('inputlistg'+buckets);

            // Récupération du contenu 
         //   List <Map<String, Object>> propreties =  (List <Map<String, Object>>) bucket.get('properties');
            // parcours de la liste des prorpretie en input
            for (Map<String, Object> Itembal: buckets) {
                //récupération de la valeur du champ M_BAL_DEBITEE
                String data = (String) Itembal.get ('M_BAL_DEBITEE');
                
                
                     List<Map <String, Object>> finalList = new List <Map <String, Object>>();
System.debug(data);
while (data.length()>0) {
    Integer index = data.indexOf(';');
    String item = data.SubString(0,index);
    Integer index2 = item.indexOf(':');
    String Name = item.SubString(0,index2);
    String Value = item.SubString(index2+1,item.length());
    data = data.SubString(index + 1, data.length());
    Map <String, Object> obj = new Map <String, Object> ();
    obj.put('name', Name);
    obj.put('value', Value);
    finalList.add(obj);
}
                itembal.put('listbal',finalList);
            }

            return inputMap;

}

}