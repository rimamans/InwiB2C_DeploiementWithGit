/**
 * @description       : Classe pour mapper et compter les articles demandés.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class InwiB2C_MappingControllerRequestSAP implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {
        if (methodName == 'MappingCodeArticle') {
            MappingCodeArticle(inputs, output, options);
        }
        return true;
    }

    private void MappingCodeArticle(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        // Désérialiser l'entrée JSON correctement
        List<Map<String, Object>> articles = (List<Map<String, Object>>) input.get('articles');

        // Utiliser une map pour compter les occurrences de chaque articleCode
        Map<String, Integer> articleCounts = new Map<String, Integer>();
        for (Map<String, Object> article : articles) {
            String articleCode = (String) article.get('articleCode');
            if (articleCounts.containsKey(articleCode)) {
                articleCounts.put(articleCode, articleCounts.get(articleCode) + 1);
            } else {
                articleCounts.put(articleCode, 1);
            }
        }

        // Créer la liste des articles de sortie
        List<Map<String, Object>> outputArticles = new List<Map<String, Object>>();
        for (String articleCode : articleCounts.keySet()) {
            Map<String, Object> outputArticle = new Map<String, Object>();
            outputArticle.put('articleCode', articleCode);
            outputArticle.put('requestedQuantity', articleCounts.get(articleCode));
            outputArticles.add(outputArticle);
        }

        // Mettre la liste des articles dans la map de sortie
        output.put('articles', outputArticles);
    }
}