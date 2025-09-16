global class inwiB2C_FTTHPassLogGeneration implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
                    
                if (methodName == 'GenerateLogMdp') {
                    outMap.put('result', GenerateLogMdp(inputMap));
                }
      return true;
  }
     /*   try{
            if(methodName.equals('GenerateLogMdp')){

                return GenerateLogMdp(inputMap,outMap,options);
               } else {
                return false;
               }    
            } catch (Exception e){
            return false;
            }
       }*/
      


       Map<String,Object> GenerateLogMdp(Map<String,Object> inputMap) {
        String ordernumber = (String) inputMap.get('ordernbr');


        Map<String, Object> result = new Map<String, Object>();
       // Map<String, Object> resultmdp = new Map<String, Object>();
        String login = 'LG' + string.valueof(ordernumber);
        // String random = string.valueof(Crypto.generateAesKey(128));
        // String mdp = random.substring(0,16);
        // Integer random = Integer.valueof((Math.random() * 1000));
        // String mdp = random.substring(0,16);
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String mdp = '';
        while (mdp.length() < 16) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
        mdp += chars.substring(idx, idx+1);
        }
        result.put('LOGIN', login);
        result.put('PASSWORD', mdp);
        return result;
       }   
}