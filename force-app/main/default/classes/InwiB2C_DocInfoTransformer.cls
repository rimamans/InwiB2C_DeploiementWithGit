/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-03-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

   /**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-03-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_DocInfoTransformer implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        try{

            if (methodName.equals('transformDocumentInfo')){
                transformDocumentInfo(inputMap, outMap, options);

                

            } 

        } catch (Exception e){

            result = false;

        }

        return result;
    }
    
    public static void transformDocumentInfo(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Map<String, Object> innerMap = (Map<String, Object>) inputMap.get('inputMap');

            // ==== TERMINAUX ====
          Object terminalObj = innerMap.get('Terminal');
         List<Map<String, Object>> terminalList = new List<Map<String, Object>>();

         if (terminalObj != null) {
          if (terminalObj instanceof List<Object>) {
          terminalList = (List<Map<String, Object>>) terminalObj;
         }    else {
          System.debug('Terminal is not a List ' + terminalObj);
         }
      }

        Map<String, Object> terminalOutput = new Map<String, Object>();
        Decimal totalEquipmentPrice = 0;

       if (!terminalList.isEmpty()) {
         for (Integer i = 0; i < terminalList.size(); i++) {
           Map<String, Object> terminal = terminalList[i];
           Decimal equipmentPrice = (Decimal) terminal.get('prixTerminal');
            if (equipmentPrice != null) {
             totalEquipmentPrice += equipmentPrice;
           }
            terminalOutput.put('equipmentNumber' + (i + 1), i + 1);
            terminalOutput.put('codearticle' + (i + 1), terminal.get('Code_Article'));
            terminalOutput.put('equipmentLabel' + (i + 1), terminal.get('ModeleTerminal_new'));
            terminalOutput.put('equipmentPrice' + (i + 1), terminal.get('prixTerminal'));
            terminalOutput.put('equipmentSerialNumber' + (i + 1), terminal.get('NumSerieTerminal'));
            terminalOutput.put('equipmentType' + (i + 1), terminal.get('TypeTerminal'));
            terminalOutput.put('equipmentDisposition' + (i + 1), terminal.get('TypeMiseDispo'));
            terminalOutput.put('equipmentEngagement' + (i + 1), terminal.get('duree_engagement'));
          }
         }
          terminalOutput.put('TerminauxTotalprice', totalEquipmentPrice);

          outMap.put('Terminal', terminalOutput);


        // ==== OPTIONS ====
           Object optionsObj = innerMap.get('Options');
           List<Map<String, Object>> listOptions = new List<Map<String, Object>>();

         if (optionsObj != null) {
           if (optionsObj instanceof List<Object>) {
           listOptions = (List<Map<String, Object>>) optionsObj;
            } else {
           System.debug('Options is not a List ' + optionsObj);
           }
          }

           Map<String, Object> optionsOutput = new Map<String, Object>();

             if (!listOptions.isEmpty()) {
             for (Integer j = 0; j < listOptions.size(); j++) {
                Map<String, Object> option = listOptions[j];
                 if (option.containsKey('ProductCodeOption') && option.get('ProductCodeOption') != null) {
                  optionsOutput.put('optionNumber' + (j + 1), j + 1);
                  optionsOutput.put('optionCode' + (j + 1), option.get('ProductCodeOption'));
                  optionsOutput.put('optionLabel' + (j + 1), option.get('LabelOption'));
             }
           }
         }
             outMap.put('Options', optionsOutput);


       
        outMap.put('errorCode', 'INVOKE-200');
        outMap.put('error', 'OK');
    }
    

}