/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class inwiB2C_Controller_ModificationMdnTest {

    @isTest
    public static void inwiB2C_Controller_ModificationMdnTest() {
 
        // Créer l'objet de données à utiliser pour le test
        Map<String, Object> dataMap = new Map<String, Object>();
        dataMap.put('TypeacteGestion', 'inwiB2C_ModificationDeNumero');
        dataMap.put('clientname', 'Aksel AkselTest');
        dataMap.put('offer', 'Forfait 30j 99dhs 5H+18Go+WA');
        dataMap.put('num_cf', 'SF0000001753');
        dataMap.put('gamme', 'Mobile postpayé forfait 30j');
        dataMap.put('activationdate', '22/02/2023');
        dataMap.put('address', 'Tizi ouzou');
        dataMap.put('pays', 'Maroc');
        dataMap.put('ville', 'ADAY');
        dataMap.put('region', 'Guelmim,Es-Semara');
        dataMap.put('numfacture', '23022232837');
        dataMap.put('numligne', '212648091704');
        dataMap.put('montantHT', 5.00);
        dataMap.put('montantTVA', 0.83);
        dataMap.put('timbre', 0.00);
        dataMap.put('totalttc', 5.00);
        dataMap.put('avancepaiement', 5.00);
    
        // Créer l'objet de données JSON à utiliser pour le test
        Map<String, Object> input = new Map<String, Object>();
        List<Object> dataList = new List<Object>();
        dataList.add(dataMap);
        input.put('data', dataList);
        String inputJson = JSON.serialize(input);
    
        // Appeler la page et initialiser l'instance de la classe inwiB2C_Controller_ModificationMdn
        PageReference pageRef = Page.inwiB2C_ModificationMdn; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('input', inputJson);
        inwiB2C_Controller_ModificationMdn controller = new inwiB2C_Controller_ModificationMdn();
    
        // Vérifier que la propriété data est correctement initialisée
        List<Map<String, Object>> expectedData = new List<Map<String, Object>>();
        expectedData.add(dataMap);
        System.assertEquals(expectedData, controller.data);
    }
}