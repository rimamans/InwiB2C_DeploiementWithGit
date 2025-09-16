public with sharing class inwib2c_TransformeStructureForDocument {
   
    public String inwib2c_TransformeStructureForDocument(String jsonInput) {
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
        List<Map<String, Object>> terminalList = (List<Map<String, Object>>) jsonData.get('Terminal');
        String output = '';
        
        if (terminalList != null && !terminalList.isEmpty()) {
            for (Integer i = 0; i < terminalList.size(); i++) {
                Map<String, Object> terminal = terminalList[i];
                output += 'codearticle' + (i + 1) + '=' + terminal.get('Code_Article') + ', ';
                output += 'Modele' + (i + 1) + '=' + terminal.get('ModeleTerminal_new') + ', ';
                output += 'prix' + (i + 1) + '=' + terminal.get('prixTerminal');
                
                if (i < terminalList.size() - 1) {
                    output += ', ';
                }
            }
        }
        
        return output;
    }
}