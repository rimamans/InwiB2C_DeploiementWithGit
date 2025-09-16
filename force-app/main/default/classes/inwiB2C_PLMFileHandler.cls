global with sharing class inwiB2C_PLMFileHandler implements vlocity_cmt.VlocityOpenInterface {
    public Boolean InvokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName == 'ReadPLMFile') {
                output.put('List', ReadPLMFile(input));
            } else if (methodName == 'InsertPLMData') {
                output.put('List', InsertPLMData(input));
            } else if (methodName == 'getRecordsByDocumentId') {
                output.put('List', getRecordsByDocumentId(input));
            } else if (methodName == 'getDocStatusesForMultipleIds') {
                output.put('DocStatusMap', getDocStatusesForMultipleIds(input));
            }

        } catch (Exception e) {
            System.debug('PLMFileHandler:invokeMethod -> exception: ' + e);
            result = false;
        }
        return result;
    }

    private List<String> ReadPLMFile(Map<String,Object> input) {
        Id contentDocumentId = (Id) input.get('contentDocumentId');
        String fileName = (String) input.get('fileName');

        List<String> recordsList = new List<String>();
        if (contentDocumentId != null) {
            inwiB2C_TraitementMassifFichier_PLM__c fileRecord = new inwiB2C_TraitementMassifFichier_PLM__c(
                inwiB2C_Statut__c = 'inwiB2C_In_Progress',
                Nom_du_fichier__c = fileName,
                inwiB2C_DOCUMENT_ID__c = contentDocumentId
            );
            insert fileRecord;

            ContentVersion contentVersionObj = [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId LIMIT 1];
            String data = Blob.valueOf(contentVersionObj.VersionData.toString()).toString();            
            recordsList = data.split('\n');
        }

        return recordsList;
    }

    private Boolean InsertPLMData(Map<String,Object> input) {
        Id contentDocumentId = (Id) input.get('contentDocumentId');
        List<Object> rawData = (List<Object>) input.get('data'); 
    
        if (rawData == null || rawData.isEmpty()) {
            return false; 
        }
    
        List<String> recordsList = new List<String>();
        for (Object lineObj : rawData) {
            recordsList.add((String) lineObj);
        }
    
        if (recordsList.size() <= 1) {
            return false;
        }
    
        Map<String, List<String>> codeArticleToColumns = new Map<String, List<String>>();
    
        for (Integer i = 1; i < recordsList.size(); i++) {
            String line = recordsList[i].trim();
            if (line == '') continue; 
    
            List<String> columns = line.split(',', -1);
            // --SOB 07/04/2025 MGEN3675A -- start
            if (columns.size() < 6) {
                System.debug('Skipping malformed line: ' + line);
                continue;
            }
            // --SOB 07/04/2025 MGEN3675A -- end
    
            String codeArticle = columns[0].trim();
            codeArticleToColumns.put(codeArticle, columns);
        }
    
        Set<String> allCodeArticles = codeArticleToColumns.keySet();
    
        Map<String, InwiB2C_PriceListeMasse__c> existingRecordsMap = new Map<String, InwiB2C_PriceListeMasse__c>();
        for (InwiB2C_PriceListeMasse__c rec : [
            SELECT Id, inwiB2C_code_article__c, inwiB2C_start_date__c,
                   inwiB2C_end_date__c, inwiB2C_Price__c, inwiB2C_canal__c,
                   inwiB2C_DOCUMENT_ID__c, inwiB2C_Status__c, inwiB2C_Error__c
            FROM InwiB2C_PriceListeMasse__c
            WHERE inwiB2C_code_article__c IN :allCodeArticles
        ]) {
            existingRecordsMap.put(rec.inwiB2C_code_article__c, rec);
        }
    
        List<InwiB2C_PriceListeMasse__c> recordsToInsert = new List<InwiB2C_PriceListeMasse__c>();
        List<InwiB2C_PriceListeMasse__c> recordsToUpdate = new List<InwiB2C_PriceListeMasse__c>();
    
        Integer batchSize = 200;
    
        for (String codeArticle : codeArticleToColumns.keySet()) {
            List<String> columns = codeArticleToColumns.get(codeArticle);
    
            String startDateStr = columns[1].trim();
            String endDateStr   = columns[2].trim();
            String priceStr     = columns[3].trim();
            String canal        = columns[4].trim();
            // --SOB 07/04/2025 MGEN3675A -- start
            String gammeStr = columns[5].trim();
            Boolean gammeVal = (gammeStr == 'true');
            // --SOB 07/04/2025 MGEN3675A -- end
    
            Date startDateVal;
            Date endDateVal;
            Decimal priceVal;
    
            try {
                startDateVal = Date.valueOf(startDateStr);
            } catch (Exception e) {
                System.debug('Error parsing start date: ' + startDateStr);
                continue;
            }
    
            try {
                endDateVal = Date.valueOf(endDateStr);
            } catch (Exception e) {
                System.debug('Error parsing end date: ' + endDateStr);
                continue; 
            }
    
            try {
                priceVal = Decimal.valueOf(priceStr);
            } catch (Exception e) {
                System.debug('Error parsing price: ' + priceStr);
                continue;
            }
    
            if (existingRecordsMap.containsKey(codeArticle)) {
                InwiB2C_PriceListeMasse__c existingRecord = existingRecordsMap.get(codeArticle);
                existingRecord.inwiB2C_start_date__c  = startDateVal;
                existingRecord.inwiB2C_end_date__c    = endDateVal;
                existingRecord.inwiB2C_Price__c       = priceVal;
                existingRecord.inwiB2C_canal__c       = canal;
                existingRecord.inwiB2C_DOCUMENT_ID__c = contentDocumentId;
                existingRecord.inwiB2C_gamme__c = gammeVal;
                
                existingRecord.inwiB2C_Status__c = null;
                existingRecord.inwiB2C_Error__c = null;
    
                recordsToUpdate.add(existingRecord);
                if (recordsToUpdate.size() == batchSize) {
                    update recordsToUpdate;
                    recordsToUpdate.clear();
                }
            } 
            else {
                InwiB2C_PriceListeMasse__c newRecord = new InwiB2C_PriceListeMasse__c(
                    inwiB2C_code_article__c = codeArticle,
                    inwiB2C_start_date__c   = startDateVal,
                    inwiB2C_end_date__c     = endDateVal,
                    inwiB2C_Price__c        = priceVal,
                    inwiB2C_canal__c        = canal,
                    // --SOB 07/04/2025 MGEN3675A -- start
                    inwiB2C_gamme__c        = gammeVal,
                    // --SOB 07/04/2025 MGEN3675A -- end
                    inwiB2C_DOCUMENT_ID__c  = contentDocumentId,

                    inwiB2C_Status__c       = null,
                    inwiB2C_Error__c        = null
                );
                recordsToInsert.add(newRecord);
                if (recordsToInsert.size() == batchSize) {
                    insert recordsToInsert;
                    recordsToInsert.clear();
                }
            }
        }
    
        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
        if (!recordsToInsert.isEmpty()) {
            insert recordsToInsert;
        }
    
        List<inwiB2C_TraitementMassifFichier_PLM__c> fileRecords = [
            SELECT Id, inwiB2C_Statut__c 
            FROM inwiB2C_TraitementMassifFichier_PLM__c 
            WHERE inwiB2C_DOCUMENT_ID__c = :contentDocumentId
            LIMIT 1
        ];
        if (!fileRecords.isEmpty()) {
            inwiB2C_TraitementMassifFichier_PLM__c fileRecord = fileRecords[0];
            fileRecord.inwiB2C_Statut__c = 'inwiB2C_Done';
            update fileRecord;
        }
    
        return true;
    }
    
    
    

    private static List<Map<String, Object>> getRecordsByDocumentId(Map<String, Object> input) {
        Id documentId = (Id) input.get('documentId');
        
        List<InwiB2C_PriceListeMasse__c> allRecords = new List<InwiB2C_PriceListeMasse__c>();
        
        Integer batchSize = 200;
        Integer offsetSize = 0;
        Boolean done = false;
        
        while (!done) {
            // --SOB 07/04/2025 MGEN3675A -- start
            List<InwiB2C_PriceListeMasse__c> partialRecords = [
                SELECT Id, Name, inwiB2C_code_article__c, inwiB2C_start_date__c,
                       inwiB2C_end_date__c, inwiB2C_Price__c, inwiB2C_canal__c,
                       inwiB2C_DOCUMENT_ID__c, InwiB2C_Status__c, inwiB2C_Error__c, inwiB2C_gamme__c
                FROM InwiB2C_PriceListeMasse__c
                WHERE inwiB2C_DOCUMENT_ID__c = :documentId
                ORDER BY Name
                LIMIT :batchSize
                OFFSET :offsetSize
            ];
            // --SOB 07/04/2025 MGEN3675A -- end
            
            if (partialRecords.isEmpty()) {
                break;
            }
            allRecords.addAll(partialRecords);
            
            offsetSize += partialRecords.size();
            if (partialRecords.size() < batchSize) {
                done = true;
            }
        }
        
        if (allRecords.isEmpty()) {
            return new List<Map<String, Object>>();
        }
        
        Boolean hasAnyStatus = false;
        for (InwiB2C_PriceListeMasse__c rec : allRecords) {
            if (rec.InwiB2C_Status__c != null) {
                hasAnyStatus = true;
                break;
            }
        }
        
        String docLevelStatus = hasAnyStatus ? 'Traitement Complété' : 'En attente de traitement';
        
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        for (InwiB2C_PriceListeMasse__c rec : allRecords) {
            Map<String, Object> recMap = new Map<String, Object>{
                'Id'          => rec.Id,
                'Name'        => rec.Name,
                'CodeArticle' => rec.inwiB2C_code_article__c,
                'StartDate'   => rec.inwiB2C_start_date__c,
                'EndDate'     => rec.inwiB2C_end_date__c,
                'Price'       => rec.inwiB2C_Price__c,
                'Canal'       => rec.inwiB2C_canal__c,
                'DocumentId'  => rec.inwiB2C_DOCUMENT_ID__c,
                'Status'      => rec.InwiB2C_Status__c,
                'Message'     => rec.inwiB2C_Error__c,
                'statut'      => docLevelStatus,
                // --SOB 07/04/2025 MGEN3675A -- start
                'Gamme' => rec.inwiB2C_gamme__c
                // --SOB 07/04/2025 MGEN3675A -- end
            };
            result.add(recMap);
        }
        
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static Map<Id, String> getDocStatusesForMultipleIds(Map<String,Object> input) {
        List<Object> rawDocIds = (List<Object>) input.get('docIds');
        if (rawDocIds == null || rawDocIds.isEmpty()) {
            return new Map<Id, String>();
        }
    
        List<Id> docIds = new List<Id>();
        for (Object item : rawDocIds) {
            docIds.add((Id) item);
        }
    
        List<InwiB2C_PriceListeMasse__c> allRecords = [
            SELECT Id, InwiB2C_DOCUMENT_ID__c, InwiB2C_Status__c
            FROM InwiB2C_PriceListeMasse__c
            WHERE InwiB2C_DOCUMENT_ID__c IN :docIds
        ];
        
        Map<Id, List<String>> docIdToStatuses = new Map<Id, List<String>>();
        for (InwiB2C_PriceListeMasse__c rec : allRecords) {
            Id dId = rec.InwiB2C_DOCUMENT_ID__c;
            if (!docIdToStatuses.containsKey(dId)) {
                docIdToStatuses.put(dId, new List<String>());
            }
            docIdToStatuses.get(dId).add(rec.InwiB2C_Status__c);
        }
    
        Map<Id, String> resultMap = new Map<Id, String>();
        for (Id docId : docIds) {
            Boolean anyNonNull = false;
            if (docIdToStatuses.containsKey(docId)) {
                for (String st : docIdToStatuses.get(docId)) {
                    if (st != null) {
                        anyNonNull = true;
                        break;
                    }
                }
            }
            String label = anyNonNull ? 'Traitement terminé' : 'En attente de traitement';
            resultMap.put(docId, label);
        }
        return resultMap;
    }
    

    

}