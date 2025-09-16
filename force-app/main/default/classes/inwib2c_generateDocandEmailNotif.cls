global with sharing class inwib2c_generateDocandEmailNotif implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        try{

            if (methodName.equals('generateDocandEmailNotif')){
                generateDocandEmailNotif(inputMap, outMap, options);

                

            } 

        } catch (Exception e){

            result = false;

        }

        return result;
    }
    
    public static void generateDocandEmailNotif(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Map<String, Object> innerMap = (Map<String, Object>) inputMap.get('inputMap');
        //Map<String, Object> Optionsmap = (Map<String, Object>) inputMap.get('options');

        List<Map<String, Object>> terminalList = (List<Map<String, Object>>) innerMap.get('Terminal');
        //List<Object> listOptions = (List<Object>) innerMap.get('Options');   
        List<Object> listOptions = (List<Object>) inputMap.get('options');       
    
         String optionsString = '';
        String output = '';
        Decimal totalEquipmentPrice = 0;
        System.debug('Ammine BRM'+inputMap);
        
        if (terminalList != null) {
            System.debug('Terminal List: ' + terminalList); 
            for (Integer i = 0; i < terminalList.size(); i++) {
          
                Map<String, Object> terminal = terminalList[i];
                Decimal equipmentPrice = (Decimal) terminal.get('prixTerminal');
                if (equipmentPrice != null) {
                    totalEquipmentPrice += equipmentPrice;
                }
                if (terminal.containsKey('Code_Article') && terminal.get('Code_Article') != null){ 
                outMap.put('codearticle' + (i + 1), terminal.get('Code_Article'));
                outMap.put('equipmentLabel' + (i + 1), terminal.get('ModeleTerminal_new'));
                outMap.put('equipmentPrice' + (i + 1), terminal.get('prixTerminal'));
                outMap.put('equipmentSerialNumber' + (i + 1), terminal.get('NumSerieTerminal'));
                outMap.put('equipmentType' + (i + 1), terminal.get('TypeTerminal'));
                outMap.put('equipmentDisposition' + (i + 1), terminal.get('ModeleTerminal_new'));
                outMap.put('equipmentEngagement' + (i + 1), terminal.get('duree_engagement'));
                }
                // if (i < terminalList.size() - 1) {
                //     output += ', ';
                // }
            }
        } else {
            System.debug('Terminal List is null or empty');
        }

        if (listOptions != null) {
            List<String> stringOptions = new List<String>();
            for(Object option : listOptions) {
                stringOptions.add(String.valueOf(option));
            }
            optionsString = String.join(stringOptions, ', ');
        }

         outMap.put('Options', optionsString);
         outMap.put('TerminauxTotalprice', totalEquipmentPrice);


        
        //outMap.put('Result', output);
        outMap.put('errorCode', 'INVOKE-200');
        outMap.put('error', 'OK');
    }
    
}