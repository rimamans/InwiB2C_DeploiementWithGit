/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class InwiB2C_GetListDocument implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        Boolean result = true;
        Map<String, Object> operationResultInfo = new Map<String, Object>();

        try {
            if (methodName.equals('GetListDocument')) {
                GetListDocument(inputMap, outMap, options);
            }
            if (methodName.equals('ProcessJsonData')) {
                processJsonData(inputMap, outMap);
            }
        } catch (Exception e) {
            result = false;
        }
        return result;
    }
   
    public static void GetListDocument(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Map<String, Object> result = new Map<String, Object>();
              
        Map<String, Object> bodyInput = (Map<String, Object>) inputMap.get('bodyInput');
        Map<String, Object> documentData = (Map<String, Object>) inputMap.get('documentData');
        Map<String, Object> CSGetlistdocs = (Map<String, Object>) bodyInput.get('CSGetlistdocs');
        Map<String, Object> CSOperationInfo = (Map<String, Object>) bodyInput.get('CSOperationInfo');

        String orderId = (String) CSGetlistdocs.get('orderid');
        String canal = (String) CSGetlistdocs.get('canal');
        String offerType = (String) inputMap.get('offerType');     

        String codeProductSIM = '';
        String codeProductTerminal = '';
        String productType = '';
        String typeOffer = '';
        String uuid = (String) CSOperationInfo.get('uuid');
              
        System.debug('Orderid' + orderId);
        System.debug('offerType' + offerType);
        
        // Query to get the documents based on Name
        List<inwiB2C_Document__c> documents = [
            SELECT Id, inwB2C_DocumentId__c, Name 
            FROM inwiB2C_Document__c 
            WHERE Name IN ('Contrat', 'Simulation de facture', 'Bon de livraison', 'Mandat de portabilité', 'Bon de livraison et de garantie', 'Mandat spécial de dégroupage/portabilité FTTH')
        ];
        
        Map<String, String> documentMap = new Map<String, String>();

        for (inwiB2C_Document__c doc : documents) {
            documentMap.put(doc.Name, doc.inwB2C_DocumentId__c);
        }
        
        List<OrderItem> orderItemParent = [
            SELECT id, Product2.ProductCode, Product2.vlocity_cmt__Type__c 
            FROM OrderItem 
            WHERE OrderId = :orderId AND vlocity_cmt__ParentItemId__c = null
        ];

        // M_Dj 11/09/2025 MGEN3799_Mandat de partage FTTH VULA -Impact last mile begin
        Order order = [ SELECT InwiB2C_IsVula__c FROM Order WHERE Id = :orderId ];
        System.debug('order : ' + order);
        Boolean isVula = order.InwiB2C_IsVula__c; 
        System.debug('isVula' + isVula);
        // M_Dj 11/09/2025 MGEN3799_Mandat de partage FTTH VULA -Impact last mile end
        
        System.debug('OrderItem Parent ' + orderItemParent);
        
        if (!orderItemParent.isEmpty()) {
            Boolean containsSpecifiedTypes = false;
            List<String> productTypes = new List<String>();
            
            for (OrderItem orderItem : orderItemParent) {
                productTypes.add(orderItem.Product2.vlocity_cmt__Type__c);
                
                // Check if the current item's type is one of the specified types
                if (orderItem.Product2.vlocity_cmt__Type__c == 'Postpaye' || orderItem.Product2.vlocity_cmt__Type__c == 'idar duo' || 
                    orderItem.Product2.vlocity_cmt__Type__c == 'FTTH' || orderItem.Product2.vlocity_cmt__Type__c == 'ADSL' || 
                    orderItem.Product2.vlocity_cmt__Type__c == 'Prepaye' || orderItem.Product2.vlocity_cmt__Type__c == 'Home' || 
                    orderItem.Product2.vlocity_cmt__Type__c == 'Mobile Dealer' || orderItem.Product2.vlocity_cmt__Type__c =='Cameleon') {
                    containsSpecifiedTypes = true;
                }
                // A-T MGEN3432CSF_Last-Mile (séparer la valeur "FIXE" )
                if (orderItem.Product2.vlocity_cmt__Type__c == 'ADSL') {
                    typeOffer = 'FIXE_ADSL';
                } 
                // M_Dj 11/09/2025 MGEN3799_Mandat de partage FTTH VULA -Impact last mile begin
                else if (orderItem.Product2.vlocity_cmt__Type__c == 'FTTH' && isVula) {
                    typeOffer = 'FTTH VULA';
                }
                // M_Dj 11/09/2025 MGEN3799_Mandat de partage FTTH VULA -Impact last mile end
                else if (orderItem.Product2.vlocity_cmt__Type__c == 'FTTH') {
                    typeOffer = 'FIXE_FTTH';
                } 
                else if (orderItem.Product2.vlocity_cmt__Type__c == 'Accessoire') {
                    typeOffer = 'ACCESSOIR';
                } else {
                    typeOffer = 'MOBILE';
                }
            }
            
            System.debug('productTypes Brm' + productTypes);
            List<Map<String, Object>> docsLists = new List<Map<String, Object>>();

            // Handle test scenario
            if (Test.isRunningTest()) {
                containsSpecifiedTypes = true;
                System.debug('Test Running');
            }

            if (containsSpecifiedTypes) {
                if (documentData.containsKey('contract')) {
                    Map<String, Object> contractDoc = new Map<String, Object>();
                    contractDoc.put('docid', documentMap.get('Contrat'));
                    contractDoc.put('docname', 'CONTRAT');
                    List<Map<String, Object>> contractDataList = transformJsonToKeyValue((List<Object>)documentData.get('contract'));
                    contractDoc.put('data', contractDataList);
                    docsLists.add(contractDoc);
                }

                // MandatPortabilité
                if (documentData.containsKey('mondatPortabilite')) {
                    Map<String, Object> mandatPortabilityDoc = new Map<String, Object>();
                    mandatPortabilityDoc.put('docid', documentMap.get('Mandat de portabilité'));
                    mandatPortabilityDoc.put('docname', offerType == 'ADSL' ? 'MANDAT_PORTABILITE_DEGROUPAGE (ADSL)' : 'MANDAT_PORTABILITE_DEGROUPAGE (GSM)');
                    List<Map<String, Object>> mandatDePortabilityDataList = transformJsonToKeyValue((List<Object>)documentData.get('mondatPortabilite'));
                    mandatPortabilityDoc.put('data', mandatDePortabilityDataList);
                    docsLists.add(mandatPortabilityDoc);
                }

                // M_Dj 11/09/2025 MGEN3799_Mandat de partage FTTH VULA -Impact last mile begin
                if (documentData.containsKey('MondatDegroupageFTTH')) {
                    Map<String, Object> mandatDegroupageFTTHDoc = new Map<String, Object>();
                    mandatDegroupageFTTHDoc.put('docid', documentMap.get('Mandat spécial de dégroupage/portabilité FTTH'));
                    mandatDegroupageFTTHDoc.put('docname', 'MANDAT_SPECIAL_DE_DEGROUPAGE/PORTABILITE_FTTH');
                    List<Map<String, Object>> mandatDeDegroupageFTTHDataList = transformJsonToKeyValue((List<Object>)documentData.get('MondatDegroupageFTTH'));
                    mandatDegroupageFTTHDoc.put('data', mandatDeDegroupageFTTHDataList);
                    docsLists.add(mandatDegroupageFTTHDoc);
                }
                // M_Dj 11/09/2025 MGEN3799_Mandat de partage FTTH VULA -Impact last mile end
            }  

            if (!containsSpecifiedTypes) {
                if (documentData.containsKey('BonDeLivraison')) {
                    Map<String, Object> bonLivraisonDoc = new Map<String, Object>();
                    bonLivraisonDoc.put('docid', documentMap.get('Bon de livraison'));
                    bonLivraisonDoc.put('docname', 'Bon de Livraison');
                    List<Map<String, Object>> bondeLivraisonDataList = transformJsonToKeyValue((List<Object>)documentData.get('BonDeLivraison'));
                    bonLivraisonDoc.put('data', bondeLivraisonDataList);
                    docsLists.add(bonLivraisonDoc);
                }
            }

            // Prepare results
            Map<String, Object> csGetlistdocsResults = new Map<String, Object>{
                'DocsLists' => docsLists,
                'typeoffre' => typeOffer
            };

            // Check if DocsLists is empty
            if (docsLists.isEmpty()) {
                // Return error information
                Map<String, Object> csOperationResultInfo = new Map<String, Object>{
                    'isOK' => '0',
                    'errorCode' => '001',
                    'errorMessage' => 'Error',
                    'uuid' => uuid
                };
                result.put('CSOperationResultInfo', csOperationResultInfo);
            } else {
                result.put('CSGetlistdocsResults', csGetlistdocsResults);
                // Success operation information
                Map<String, Object> csOperationResultInfo = new Map<String, Object>{
                    'isOK' => '1',
                    'errorCode' => '',
                    'errorMessage' => 'SUCCESS',
                    'uuid' => uuid
                };
                result.put('CSOperationResultInfo', csOperationResultInfo);
            }

        } else {
            // Handle the case where no order items are found
            Map<String, Object> csOperationResultInfo = new Map<String, Object>{
                'isOK' => '0',
                'errorCode' => '002',
                'errorMessage' => 'No order items found',
                'uuid' => uuid
            };
            result.put('CSOperationResultInfo', csOperationResultInfo);
        }
        
        // Put the result into outMap
        outMap.putAll(result);
    }

    private static List<Map<String, Object>> transformJsonToKeyValue(List<Object> jsonData) {
        List<Map<String, Object>> transformedData = new List<Map<String, Object>>();
        for (Object item : jsonData) {
            if (item instanceof Map<String, Object>) {
                Map<String, Object> dataMap = (Map<String, Object>) item;
                for (String key : dataMap.keySet()) {
                    Map<String, Object> fieldMap = new Map<String, Object>();
                    fieldMap.put('fieldname', key);
                    fieldMap.put('fieldvalue', String.valueOf(dataMap.get(key)));
                    transformedData.add(fieldMap);
                }
            }
        }
        return transformedData;
    }

    // SBO / KKA 20241212 - Ajout de la méthode processJsonData pour traiter les données JSON et les transformer en données clés-valeurs
    // SBO / KKA 20241212 - START
    public static void processJsonData(Map<String, Object> inputMap, Map<String, Object> outMap) {
        try {
            if (inputMap.containsKey('jsonData')) {
                Map<String, Object> jsonData = (Map<String, Object>) inputMap.get('jsonData');
    
                System.debug('Input jsonData: ' + jsonData);
    
                List<Map<String, Object>> docsLists = new List<Map<String, Object>>();
    
                // for (String key : jsonData.keySet()) {
                //     Object value = jsonData.get(key);
    
                //     if (value instanceof List<Object>) {
                //         List<Object> jsonDataList = (List<Object>) value;
                //         List<Map<String, Object>> transformedList = transformJsonToKeyValue(jsonDataList);
                //         docsLists.addAll(transformedList);
                //     } else {
                //         Map<String, Object> singleValueMap = new Map<String, Object>();
                //         singleValueMap.put('fieldname', key);
                //         singleValueMap.put('fieldvalue', String.valueOf(value));
                //         docsLists.add(singleValueMap);
                //     }
                // }
            List<inwiB2C_Document__c> documents = [ SELECT Id, inwB2C_DocumentId__c, Name FROM inwiB2C_Document__c WHERE Name = 'Contrat'];
           String contractDocId = documents.isEmpty() ? null : documents[0].inwB2C_DocumentId__c;


            Map<String, Object> contractDoc = new Map<String, Object>();
            contractDoc.put('docid', contractDocId);
            contractDoc.put('docname', 'CONTRAT');

 
             List<Map<String, Object>> contractDataList = new List<Map<String, Object>>();

             for (String key : jsonData.keySet()) {
                   Object value = jsonData.get(key);
                   Map<String, Object> fieldMap = new Map<String, Object>();
                      fieldMap.put('fieldname', key);

                  if (value instanceof List<Object>) {
                  fieldMap.put('fieldvalue', transformJsonToKeyValue((List<Object>) value));
                } else {
                  fieldMap.put('fieldvalue', String.valueOf(value));
                 }

              contractDataList.add(fieldMap);
                }

             contractDoc.put('data', contractDataList);
             docsLists.add(contractDoc);
    
                System.debug('Transformed DocsLists: ' + docsLists);
    
                Map<String, Object> result = new Map<String, Object>();
                Map<String, Object> bodyInput = (Map<String, Object>) inputMap.get('bodyInput');
                Map<String, Object> CSGetlistdocs = (Map<String, Object>) bodyInput.get('CSGetlistdocs');
                Map<String, Object> CSOperationInfo = (Map<String, Object>) bodyInput.get('CSOperationInfo');
    
                String contractId = (String) CSGetlistdocs.get('contractid');
                String canal = (String) CSGetlistdocs.get('canal');
                String offerType = (String) inputMap.get('offerType');     
    
                String uuid = (String) CSOperationInfo.get('uuid');
    
                List<Contract> contracts = [SELECT Id FROM Contract WHERE Id = :contractId LIMIT 1];
                if (contracts.isEmpty()) {
                    Map<String, Object> csOperationResultInfo = new Map<String, Object>{
                        'isOK' => '0',
                        'errorCode' => 'CONTRACT_NOT_FOUND',
                        'errorMessage' => 'ContractID introuvable',
                        'uuid' => uuid
                    };
                    result.put('CSOperationResultInfo', csOperationResultInfo);
                } else {
                    if (docsLists.isEmpty()) {
                        Map<String, Object> csOperationResultInfo = new Map<String, Object>{
                            'isOK' => '0',
                            'errorCode' => '001',
                            'errorMessage' => 'Error',
                            'uuid' => uuid
                        };
                        result.put('CSOperationResultInfo', csOperationResultInfo);
                    } else {
                        Map<String, Object> csGetlistdocsResults = new Map<String, Object>{
                            'DocsLists' => docsLists
                        };
                        result.put('CSGetlistdocsResults', csGetlistdocsResults);
    
                        Map<String, Object> csOperationResultInfo = new Map<String, Object>{
                            'isOK' => '1',
                            'errorCode' => '',
                            'errorMessage' => 'SUCCESS',
                            'uuid' => uuid
                        };
                        result.put('CSOperationResultInfo', csOperationResultInfo);
                    }
                }
    
                outMap.putAll(result);
            } else {
                outMap.put('Error', 'No jsonData key found in inputMap');
            }
        } catch (Exception e) {
            System.debug('Error in processJsonData: ' + e.getMessage());
            outMap.put('Error', e.getMessage());
        }
    }
    
    
    
    // SBO / KKA 20241212 - END


}