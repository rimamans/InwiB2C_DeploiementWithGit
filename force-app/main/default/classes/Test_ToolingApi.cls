public class Test_ToolingApi {
    public class PicklistValue {
        public String color;
        public Boolean isDefault;
        public String description;
        public Boolean isActive;
        public String label;
        public String urls;
        public String valueName;
    
        public PicklistValue(String color, Boolean isDefault, String description, Boolean isActive, String label, String urls, String valueName) {
            this.color = color;
            this.isDefault = isDefault;
            this.description = description;
            this.isActive = isActive;
            this.label = label;
            this.urls = urls;
            this.valueName = valueName;
        }
    }

    public static HttpResponse toolingAPI(String endpoint, String method, String body){

        HttpRequest req = new HttpRequest();

        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID

        req.setHeader('Content-Type', 'application/json');

        String SFdomainUrl=URL.getOrgDomainUrl().toExternalForm();

        req.setEndpoint(SFdomainURL+endpoint);

        req.setMethod(method);
        if (String.isNotBlank(body)) {
            req.setBody(body);
        }

        Http h = new Http();

        HttpResponse response = h.send(req);

        return response;

    
    }

    public static HttpResponse getFieldMetadata(String fieldId) {
        String endpoint = '/services/data/v58.0/tooling/sobjects/CustomField/' + fieldId;
        return toolingAPI(endpoint, 'GET', null);
    }

    public static List<PicklistValue> getPicklistValues(String fieldId) {
        	HttpResponse response = getFieldMetadata(fieldId);
            
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> metadata = (Map<String, Object>) responseData.get('Metadata');
            Map<String, Object> valueSet = (Map<String, Object>) metadata.get('valueSet');
            Map<String, Object> valueSetDefinition = (Map<String, Object>) valueSet.get('valueSetDefinition');
            List<Object> values = (List<Object>) valueSetDefinition.get('value');
        
            List<PicklistValue> picklistValues = new List<PicklistValue>();
            for (Object obj : values) {
                Map<String, Object> valueMap = (Map<String, Object>) obj;
                PicklistValue pv = new PicklistValue(
                    (String) valueMap.get('color'),
                    (Boolean) valueMap.get('default'),
                    (String) valueMap.get('description'),
                    (Boolean) valueMap.get('isActive'),
                    (String) valueMap.get('label'),
                    (String) valueMap.get('urls'),
                    (String) valueMap.get('valueName')
                );
                picklistValues.add(pv);
            }
        
            return picklistValues;
    }

    public static HttpResponse updatePicklistValue(String fieldId, List<PicklistValue> existingValues, PicklistValue newValue) {
        String endpoint = '/services/data/v58.0/tooling/sobjects/CustomField/' + fieldId;
        String valuesJson = '';

        for (PicklistValue value : existingValues) {
            valuesJson += '{'
                + '"color": ' + (value.color != null ? '"' + value.color + '"' : 'null') + ', '
                + '"default": ' + String.valueOf(value.isDefault) + ', '
                + '"description": ' + (value.description != null ? '"' + value.description + '"' : 'null') + ', '
                + '"isActive": ' + String.valueOf(value.isActive) + ', '
                + '"label": "' + value.label + '", '
                + '"urls": ' + (value.urls != null ? '"' + value.urls + '"' : 'null') + ', '
                + '"valueName": "' + value.valueName + '"},';
        }

        valuesJson = valuesJson.substring(0, valuesJson.length() - 1);

        String body = '{ "Metadata": { "valueSet": { "valueSetDefinition": { "sorted": false, "value": ['
                    + valuesJson
                    + '] } } } }';

        return toolingAPI(endpoint, 'PATCH', body);
    }
}