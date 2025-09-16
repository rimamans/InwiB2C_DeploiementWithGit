/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-03-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class InwiB2C_DocInfoTransformerTest {
    @isTest
    public static void TesttransformDocumentInfo() {
        
        InwiB2C_DocInfoTransformer cls = new InwiB2C_DocInfoTransformer();
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> innerMap = new Map<String, Object>();
        
        // ==== test Terminal ====
        List<Map<String, Object>> terminalList = new List<Map<String, Object>>();
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
        
        // ==== TEST Options  ====
        List<Map<String, Object>> listOptions = new List<Map<String, Object>>();
        listOptions.add(new Map<String, Object>{ 'ProductCodeOption' => 'OPT001', 'LabelOption' => 'Internet sur Mobile' });
        listOptions.add(new Map<String, Object>{ 'ProductCodeOption' => 'OPT002', 'LabelOption' => 'APN 4G' });
        innerMap.put('Options', listOptions);
        
        inputMap.put('inputMap', innerMap);
        
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
        Test.startTest();
        Boolean result = cls.invokeMethod('transformDocumentInfo', inputMap, outMap, options);
        Test.stopTest();
        
       
        System.assert(result, 'La méthode invoke a réussir');
        
        //  Terminal
        Map<String, Object> terminalOutput = (Map<String, Object>) outMap.get('Terminal');
        System.assertEquals(100.0, terminalOutput.get('equipmentPrice1'), 'Le prix du terminal est incorrect');
        System.assertEquals('100002569', terminalOutput.get('codearticle1'), 'Le code article est incorrect');
        System.assertEquals('ONT FTTH HUAWEI HG8M8145X6-10G41 Wifi 6', terminalOutput.get('equipmentLabel1'), 'Le modèle du terminal est incorrect');
        System.assertEquals('Sans engagement', terminalOutput.get('equipmentEngagement1'), 'La durée d\'engagement est incorrecte');
        System.assertEquals(100.0, terminalOutput.get('TerminauxTotalprice'), 'Le total des prix des terminaux est incorrect');
        
        // Options
        Map<String, Object> optionsOutput = (Map<String, Object>) outMap.get('Options');
        System.assertEquals('OPT001', optionsOutput.get('optionCode1'));
        System.assertEquals('Internet sur Mobile', optionsOutput.get('optionLabel1'));
        System.assertEquals('OPT002', optionsOutput.get('optionCode2'));
        System.assertEquals('APN 4G', optionsOutput.get('optionLabel2'));
        

        System.assertEquals('OK', outMap.get('error'), 'Le message d\'erreur est incorrect');
        System.assertEquals('INVOKE-200', outMap.get('errorCode'), 'Le code d\'erreur est incorrect');
    }
}