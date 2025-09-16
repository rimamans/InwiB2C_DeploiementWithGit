/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class InwiB2C_MappingControllerRequestSAP_Test {

    @isTest
    static void testMappingCodeArticle() {
        // Préparer les données d'entrée
        Map<String, Object> inputs = new Map<String, Object>();
        List<Map<String, Object>> articles = new List<Map<String, Object>>();
        
        Map<String, Object> article1 = new Map<String, Object>{'articleCode' => '100002323'};
        Map<String, Object> article2 = new Map<String, Object>{'articleCode' => '600000962'};
        Map<String, Object> article3 = new Map<String, Object>{'articleCode' => '600000962'};
        
        articles.add(article1);
        articles.add(article2);
        articles.add(article3);
        
        inputs.put('articles', articles);

        // Préparer les structures de sortie
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        // Appeler la méthode à tester
        InwiB2C_MappingControllerRequestSAP controller = new InwiB2C_MappingControllerRequestSAP();
        Boolean result = controller.invokeMethod('MappingCodeArticle', inputs, output, options);

        // Vérifier que la méthode a retourné true (succès)
        System.assertEquals(true, result, 'invokeMethod should return true');

        // Vérifier la structure de la sortie
        System.assertNotEquals(null, output.get('articles'), 'Output articles should not be null');
        
        List<Map<String, Object>> outputArticles = (List<Map<String, Object>>) output.get('articles');
        System.assertEquals(2, outputArticles.size(), 'Expected two articles in the output');

        // Vérifier les valeurs des articles dans la sortie
        for (Map<String, Object> outputArticle : outputArticles) {
            String articleCode = (String) outputArticle.get('articleCode');
            Integer requestedQuantity = (Integer) outputArticle.get('requestedQuantity');

            System.assertNotEquals(null, articleCode, 'Article code should not be null');
            System.assertNotEquals(null, requestedQuantity, 'Requested quantity should not be null');
        }
    }
}