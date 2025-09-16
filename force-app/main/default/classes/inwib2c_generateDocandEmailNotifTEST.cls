@isTest
public class inwib2c_generateDocandEmailNotifTEST {
    @isTest
    public static void testGenerateDocandEmailNotif() {
        
        inwib2c_generateDocandEmailNotif cls = new inwib2c_generateDocandEmailNotif();
        
    
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> innerMap = new Map<String, Object>();
        List<Map<String, Object>> terminalList = new List<Map<String, Object>>();
        
        // Terminal fictif
        Map<String, Object> terminal1 = new Map<String, Object>{
            'Code_Article' => '100002569',
            'ModeleTerminal_new' => 'ONT FTTH HUAWEI HG8M8145X6-10G41 Wifi 6',
            'prixTerminal' => 100.0,
            'NumSerieTerminal' => '908786756438597',
            'TypeTerminal' => 'Terminal',
            'duree_engagement' => 'Sans engagement'
        };
        terminalList.add(terminal1);
        
       
        innerMap.put('Terminal', terminalList);
        inputMap.put('inputMap', innerMap);
        

        List<Object> listOptions = new List<Object>{ 'Terminal', 'Internet sur Mobile', 'APN 4G' };
        inputMap.put('options', listOptions);

        
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
        
        Test.startTest();
        Boolean result = cls.invokeMethod('generateDocandEmailNotif', inputMap, outMap, options);
        Test.stopTest();
        
        // Assertions pour vérifier le résultat
        System.assert(result, 'La méthode invokeMethod aurait dû réussir');
        System.assertEquals(100.0, outMap.get('equipmentPrice1'), 'Le prix du terminal est incorrect');
        System.assertEquals('100002569', outMap.get('codearticle1'), 'Le code article est incorrect');
        System.assertEquals('ONT FTTH HUAWEI HG8M8145X6-10G41 Wifi 6', outMap.get('equipmentLabel1'), 'Le modèle du terminal est incorrect');
        System.assertEquals('Sans engagement', outMap.get('equipmentEngagement1'), 'La durée d\'engagement est incorrecte');
        System.assertEquals('Terminal, Internet sur Mobile, APN 4G', outMap.get('Options'), 'Les options sont incorrectes');
        System.assertEquals(100.0, outMap.get('TerminauxTotalprice'), 'Le total des prix des terminaux est incorrect');
        System.assertEquals('OK', outMap.get('error'), 'Le message d\'erreur est incorrect');
        System.assertEquals('INVOKE-200', outMap.get('errorCode'), 'Le code d\'erreur est incorrect');
    }
}