/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-14-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InwiB2C_TransformJsonByLibelle implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;

        try {
            if ('TransformJson'.equals(methodName)) {
                Object jsonInput = inputMap.get('jsonInput');
                if (jsonInput == null || !(jsonInput instanceof Map<String, Object>)) {
                    throw new IllegalArgumentException('L\'entrée JSON doit être de type Map<String, Object> et ne peut pas être nulle.');
                }

                  // Filtrage des libellés valides
                  Map<String, Object> filteredResult = filterValidLibelles((Map<String, Object>) jsonInput);

                  // Sérialisation du résultat filtré
                  String serializedResult = JSON.serializePretty(filteredResult);
                  
                  // Stockage du résultat dans outMap
                  outMap.put('result', serializedResult);
            }
        } catch (IllegalArgumentException e) {
            result = false;
            outMap.put('error', 'Argument invalide: ' + e.getMessage());
        } catch (Exception e) {
            result = false;
            outMap.put('error', 'Erreur inattendue: ' + e.getMessage());
        }

        return result;
    }

    public static Map<String, Object> filterValidLibelles(Map<String, Object> jsonInput) {
        List<Object> results = (List<Object>) jsonInput.get('results');
        List<Object> filtered = new List<Object>();

        for (Object obj : results) {
            Map<String, Object> item = (Map<String, Object>) obj;

            if (item.containsKey('libelle') && !String.isEmpty((String)item.get('libelle'))) {
                filtered.add(item);
            }
        }

        Map<String, Object> output = new Map<String, Object>();
        output.put('results', filtered);
        output.put('search', jsonInput.get('search'));

        return output;
    }
}