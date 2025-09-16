public without sharing class INWIB2C_INWIJSONAttributeUtilities {

    public static String ATTRIBUTE_CODE_TO_VALUE        = 'attributeCodeToValue';
    public static String ATTRIBUTE_CODE_TO_DISPLAY_NAME = 'attributeCodeToDisplayName';
    public static final String ATTRIBUTE_UNIQUE_CODE    = 'attributeuniquecode__c';
    public static final String ATTRIBUTE_RUN_TIME_INFO  = 'attributeRunTimeInfo';

    /** @Method : getJSONAttribute
	 ** @params : quoteLineItemID
	 ** @return : JSONAttribute
	 ** @Description : Get Json Attribute from QuoteLineItem
	 **/
    /* 
     public static String getJSONAttribute(ID quoteLineItemID){
        String JSONAttr; 
        QuoteLineItem QuoteLi =  [Select ID ,vlocity_cmt__JSONAttribute__c from QuoteLineItem where ID =:quoteLineItemID];
        if(QuoteLi != null){
            JSONAttr = QuoteLi.vlocity_cmt__JSONAttribute__c;
        }
        return JSONAttr;
    }
    */
    
    /** @Method : getAttributeValuesFromJSON
	 ** @params : JSONAttribute
	 ** @return : Map<attributeuniquecode__c,AttributeValue>
	 ** @Description : Get Attribute values from JSONAttribute
	 **/
    public static Map<String,Object> getAttributeValuesFromJSON(String JSONAttr){
        List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest> actionRequestsList = new List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest>();
        Map<String, object> inputMap = new Map<String, object>(); 
        Map<String, object> outputMap = new Map<String, object>(); 
        Map<String, object> optionsMap = new Map<String, object>();
        inputMap.put('JSONString', JSONAttr);
        Vlocity_cmt.JSONAttributeSupport jsonSupport = new Vlocity_cmt.JSONAttributeSupport();
        jsonSupport.invokeMethod('getAttributeValuesFromJSON', inputMap, outputMap, optionsMap);
        Map<String,Object> modifiedJSON = (Map<String,Object>)outputMap.get(ATTRIBUTE_CODE_TO_VALUE);
        //System.debug('getAttributeValuesFromJSON >>> ' + JSON.serializePretty(modifiedJSON));
        return modifiedJSON;
    }
    
    /** @Method : getAttributeValueFromJSON
	 ** @params : JSONAttribute, AttributeUniqueCode
	 ** @return : AttributeValue
	 ** @Description : Get Attribute value from JSONAttribute by attribute code
	 **/
    public static String getAttributeValueFromJSON(String JSONAttr, String AttributeCode){
        Map<String,Object> attributeValuesList = getAttributeValuesFromJSON(JSONAttr);
        //System.debug('getAttributeValueFromJSON >>> ' + attributeValuesList.get(AttributeCode));
        return string.valueOf(attributeValuesList.get(AttributeCode));
    }
    
    /** @Method : getAttributeDisplayNamesFromJSON
	 ** @params : JSONAttribute
	 ** @return : Map<attributeuniquecode__c,AttributeDisplayName>
	 ** @Description : Get Attribute Displays Names from JSONAttribute
	 **/
    public static Map<String,Object> getAttributeDisplayNamesFromJSON(String JSONAttr){
        List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest> actionRequestsList = new List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest>();
        Map<String, object> inputMap = new Map<String, object>(); 
        Map<String, object> outputMap = new Map<String, object>(); 
        Map<String, object> optionsMap = new Map<String, object>();
        inputMap.put('JSONString', JSONAttr);
        Vlocity_cmt.JSONAttributeSupport jsonSupport = new Vlocity_cmt.JSONAttributeSupport();
        jsonSupport.invokeMethod('getAttributeValuesFromJSON', inputMap, outputMap, optionsMap);
        Map<String,Object> modifiedJSON = (Map<String,Object>)outputMap.get(ATTRIBUTE_CODE_TO_DISPLAY_NAME);
        //System.debug('getAttributeDisplayNamesFromJSON >>> ' + JSON.serializePretty(modifiedJSON));
		return modifiedJSON;
    }

    /** @Method : updateAttributeValueFromJSON
	 ** @params : JSONAttribute, attributeuniquecode__c, AttributeValue
	 ** @return : JSONAttribute
	 ** @Description : Get Attribute Display Names from JSONAttribute by attribute code
	 **/
    public static String updateAttributeValueFromJSON(String JSONAttr, String AttributeCode, String AttributeValue){
        List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest> actionRequestsList = new List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest>();
        actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest(AttributeCode, Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, AttributeValue));
    
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();
        Map<String, object> optionsMap = new Map<String, object>();
        
        inputMap.put('objectSO', null);
        inputMap.put('runTimeAttributesJSON', JSONAttr); // run time attribute value
        inputMap.put('originalAttributesJSON', JSONAttr); // design time (master) attribute
        inputMap.put('JSONAttributeActionRequestList', actionRequestsList); // attributes and values to update
 
        vlocity_cmt.JSONAttributeSupport jsonSupport = new vlocity_cmt.JSONAttributeSupport();
        jsonSupport.invokeMethod('applyAttributeActions', inputMap, outputMap, optionsMap);
        return (String)outputMap.get('modifiedJSON'); 
        
    }

    public static String updateAttributesValueFromJSON(String JSONAttr, Map<String,String> attributes){
        List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest> actionRequestsList = new List<Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest>();

        if (attributes.size()> 0) {
            for (String attributeCode : attributes.keySet()){
                system.debug('attributeCode: ' + attributeCode + ' value= ' + attributes.get(attributeCode));
                actionRequestsList.add(new Vlocity_cmt.JSONAttributeSupport.JSONAttributeActionRequest(attributeCode, Vlocity_cmt.JSONAttributeSupport.ActionType.ASSIGN, attributes.get(attributeCode)));
            }
            Map<String, object> inputMap = new Map<String, object>();
            Map<String, object> outputMap = new Map<String, object>();
            Map<String, object> optionsMap = new Map<String, object>();
            
            inputMap.put('objectSO', null);
            inputMap.put('runTimeAttributesJSON', JSONAttr); // run time attribute value
            inputMap.put('originalAttributesJSON', JSONAttr); // design time (master) attribute
            inputMap.put('JSONAttributeActionRequestList', actionRequestsList); // attributes and values to update
     
            vlocity_cmt.JSONAttributeSupport jsonSupport = new vlocity_cmt.JSONAttributeSupport();
            jsonSupport.invokeMethod('applyAttributeActions', inputMap, outputMap, optionsMap);
            return (String)outputMap.get('modifiedJSON'); 
        }
        return null;
        
    
       
        
    }

    /** @Method : getAttributeDisplayTextFromJSON
	 ** @params : JSONAttribute, AttributeUniqueCode
	 ** @return : AttributeDisplayText
	 ** @Description : Get Attribute Display Text from JSONAttribute by attribute code
	 **/
    public static String getAttributeDisplayTextFromJSON(String JSONAttr, String AttributeCode){
        Map<String,Object> attributeValuesList = getAttributeDisplayTextsFromJSON(JSONAttr);
        //System.debug('getAttributeValueFromJSON >>> ' + attributeValuesList.get(AttributeCode));
        return (String) attributeValuesList.get(AttributeCode);
    }
    
    /** @Method : getAttributeDisplayTextsFromJSON
	 ** @params : JSONAttribute
	 ** @return : Map<attributeuniquecode__c, DisplayText>
	 ** @Description : Get list Attributes Displays Text of pickList type from JSONAttribute
	 **/
    public static Map<String,Object> getAttributeDisplayTextsFromJSON(String JSONAttr){
        Map<String,Object> listAttributeDisplayText = new Map<String,Object>();
        if(JSONAttr != null){
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(JSONAttr);
            for(String k : m.keyset()){
                if(m.get(k) instanceof List<Object>){
                    for(Object node: (List<Object>) m.get(k)){
                        if(node instanceof Map<String, Object>){
                            Map<String, Object> nodeMap = (Map<String, Object>) node;
                            listAttributeDisplayText.put((String) nodeMap.get(ATTRIBUTE_UNIQUE_CODE), getQuoteLineItemAttributeValue(nodeMap));
                        }
                    }
                }
            }   
        }
        //System.debug('listAttributeDisplayText >>> ' + JSON.serializePretty(listAttributeDisplayText));
        return listAttributeDisplayText;
    }
    
    /** @Method : getQuoteLineItemAttributeValue
	 ** @params : Map<String, Object> Attribute Node
	 ** @return : DisplayText
	 ** @Description : Get Attribute Display Text of pickList type from Attribute Node
	 **/
     public static String getQuoteLineItemAttributeValue(Map<String, Object> nodeMap) {
        String displayText;
		Map<String, Object> attributeRunTimeInfoMap = (Map<String, Object>) nodeMap.get(ATTRIBUTE_RUN_TIME_INFO);
        if(attributeRunTimeInfoMap != null && attributeRunTimeInfoMap.get('dataType') != null){
                Map<String, Object> selectedItemMap = (Map<String, Object>) attributeRunTimeInfoMap.get('selectedItem');
                if(selectedItemMap != null && selectedItemMap.get('value') != null){
                    displayText = (String) selectedItemMap.get('displayText');
                }
            }
        return displayText;
    }
}