global with sharing class InwiB2C_GetMappingSFSN implements vlocity_cmt.VlocityOpenInterface {
   
      global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {
         if (methodName == 'SearchMapping')
        {
            SearchMapping(inputs, output, options);
        }

        return true;
    }
    private void SearchMapping(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
            String caseCategory = (String) input.get('caseCategory');
            String caseDetail = (String) input.get('caseDetail');
            Boolean caseQualificationAUDA = (Boolean) input.get('caseQualificationAUDA');
            String caseTypeOffre = (String) input.get('caseTypeOffre');
            String caseTypeSpecialit = (String) input.get('caseTypeSpecialit');
        	String caseTypeOffer;
            String caseDetailIn;
            caseDetailIn =   String.escapeSingleQuotes(caseDetail);
           system.debug(caseDetailIn); 
           IF (caseQualificationAUDA == true && caseTypeOffre == 'FTTH') 
            {
              caseTypeOffre = 'FTTH';
              caseTypeOffer = 'AUDA';
            } else
            IF(caseTypeOffre == 'FTTH')
               {
               caseTypeOffre = 'FTTH';
               caseTypeOffer = 'FTTH';    
               } else
           IF(caseTypeOffre == 'ADSL') 
               {
               caseTypeOffre='ADSL';
               caseTypeOffer = 'ADSL';
               }
             // Construct the WHERE clause 
            String whereClause = ' WHERE  ';
            if (String.isNotBlank(caseCategory)) {
                whereClause += ' InwiB2C_CategorieSF__c = \'' + caseCategory + '\'';
            }
            if (String.isNotBlank(caseDetailIn)) {
                whereClause += ' AND InwiB2C_DetailSF__c = \'' + caseDetailIn + '\'';
            }
            if (String.isNotBlank(caseTypeOffre)) {
                whereClause += ' AND InwiB2C_Type_de_offreSF__c = \'' + caseTypeOffre + '\'';
            }
            if (String.isNotBlank(caseTypeSpecialit)) {
                whereClause += ' AND InwiB2C_Type_de_specialiteSF__c = \'' + caseTypeSpecialit + '\'';
            }
           
           String query = 'SELECT Id, InwiB2C_Sous_categorieSN__c , ' +
                        'InwiB2C_DetailSN__c  '+
                          'FROM InwiB2C_Typologie_Mapping_SF_SN__c ' + whereClause + ' LIMIT 1 ' ;

            System.debug(query);
             List<InwiB2C_Typologie_Mapping_SF_SN__c> mappingItems = Database.query(query); 
            List<Map<String, Object>> transformedResults = new List<Map<String, Object>>();
            System.debug(' mappingItems ' + mappingItems);
        
            for(InwiB2C_Typologie_Mapping_SF_SN__c item : mappingItems) {
                Map<String, Object> resultInfo = new Map<String, Object>();
                resultInfo.put('DetailSN', item.InwiB2C_DetailSN__c);
                resultInfo.put('SousCategorieSN', item.InwiB2C_Sous_categorieSN__c);
                resultInfo.put('CategorieSN',caseTypeOffer);
                
               
                
                
            transformedResults.add(resultInfo);
            }

            output.put('result', transformedResults);
      
   }
}