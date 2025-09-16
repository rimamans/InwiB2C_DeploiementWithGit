global with sharing  class inwiB2C_FormatCodeSF implements vlocity_cmt.VlocityOpenInterface {
        
        
            global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
                    
                if (methodName == 'convertCode') {
                    outMap.put('result', convertCode(inputMap));
                }if (methodName == 'CheckRib') {
                    outMap.put('result', checkRib(inputMap));
                }if (methodName == 'CheckBlacklist') {
                    outMap.put('result', checkBlacklist(inputMap));
                }
                     
                return true;
                          
           }
        
        
           Map<String,Object> convertCode(Map<String,Object> inputMap) {
               String outputString;
               Integer randomNumber = Integer.valueof((Math.random() * 10000));
               String pinCode = String.valueOf(randomNumber);
               if(pinCode.length() == 2 ){
                   outputString = '00'+pinCode;
                }
               if(pinCode.length() == 3 ){
                   outputString = '0'+pinCode;
                }
               if(PinCode.length() == 1 ){
                   outputString = '000'+pinCode;
                }
               else{
                   outputString=pinCode;
                }
                inputMap.put('CodeSF',outputString);
                return inputMap;
        
        }
         Map<String,Object> checkRib(Map<String,Object> inputMap) {
             Decimal rib=Decimal.valueOf( (String)inputMap.get('RIB'));
             Decimal cleFinale;
             Decimal res=0;
             Decimal mod=97;
             Decimal firstResult;
             Decimal modResult;
             Decimal modFinal = 0;
             Decimal modResult2;
             //Calcul RIB modulo 97
             firstResult = rib / mod; 
             modResult = math.floor(firstResult);
             modResult2 = modResult * mod;
             modFinal = rib - modResult2; 
             cleFinale=mod-modFinal;
             String clefinal=String.valueOf(cleFinale); 
             String cle;
             if(clefinal.length() == 1 ){
                   cle = '0'+clefinal;
                }
               else{
                   cle=clefinal;
                }
             inputMap.put('CleFinale',cle);
             return inputMap;
         }
        Map<String,Object> checkBlacklist(Map<String,Object> inputMap) {
            String rib=(String)inputMap.get('RIB');
            Map<String, Object> ipInput = new Map<String, Object>();
            ipInput.put('rib', rib);
            Map<String, Object> ipOptions = new Map<String, Object>();
            Map <String, Object> output =  (Map <String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_Blacklist_RIB', ipInput, ipOptions));
            inputMap.put('Blacklist',output);
            return inputMap;
        }
        }