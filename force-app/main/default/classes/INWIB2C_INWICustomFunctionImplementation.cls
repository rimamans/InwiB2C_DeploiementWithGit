global class INWIB2C_INWICustomFunctionImplementation implements vlocity_cmt.VlocityOpenInterface{
    global static final String ARGUMENTS = 'arguments';
   
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        if (methodName == 'AttributeDisplayText'){
            List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
            output.put('result', attributeDisplayText(arguments));
        }else if (methodName == 'AttributeValue'){
            List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
            output.put('result', attributeValue(arguments));
        }else if (methodName == 'getAllAttributeValue'){
            List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
            output.put('result', getAllAttributeValue(arguments));
        }
        
      
        else if(methodName == 'SPLITNodes'){
            List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
            output.put('result', splitNodes((Map<String, Object>)arguments.get(0)));
        }
        else if(methodName == 'CONCATLISTS'){
            List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
            output.put('result', arguments);
        }
        else if(methodName == 'REPLACE'){
            List<Object> arguments = (List<Object>)inputs.get(ARGUMENTS);
            output.put('result', REPLACE((String)arguments.get(0),(String)arguments.get(1),(String)arguments.get(2)));
        }

        return true;
    }

    public static String REPLACE(String chaine,String target,String replacement){
        return chaine.replaceAll(target,replacement);
    }
    public static String attributeDisplayText(List<Object> arguments){
        String result;
        if(arguments.size() > 0){
            String jsonAttribute = (String) arguments[0];
            String codeAttribute = (String) arguments[1];
            if(jsonAttribute != null && codeAttribute != null){
                result = INWIB2C_INWIJSONAttributeUtilities.getAttributeDisplayTextFromJSON(jsonAttribute, codeAttribute);
            }
        }
        return result;
    }
    
    public static String attributeValue(List<Object> arguments){
        String result;
        if(arguments.size() > 0){
            String jsonAttribute = (String) arguments[0];
            String codeAttribute = (String) arguments[1];
            if(jsonAttribute != null && codeAttribute != null){
                result = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(jsonAttribute, codeAttribute);
            }
        }
        return result;
    }
    
    public static Map<String,Object> getAllAttributeValue(List<Object> arguments){
        Map<String,Object> result;
        if(arguments.size() > 0){
            String jsonAttribute = (String) arguments[0];
            if(jsonAttribute != null){
                result = INWIB2C_INWIJSONAttributeUtilities.getAttributeValuesFromJSON(jsonAttribute);
            }
        }
        return result;
    }
  
    
public static List<Object> splitNodes(map<String,Object> arg ){

    List<Object> result = new List<Object>();
 
    if(arg != null){
        List<Object> listNodes = (List<Object>) arg.get('CSProduct');
        for(Object node : listNodes){
            if(node instanceof Map<String, Object> ){
                Map<String, Object>  mapResult=new map<String,Object>();
                if(((Map<String, Object>)node).containsKey('CSProduct')){
                    Map<String, Object>  tempNode= (Map<String, Object>) node;
                    mapResult.put('CSProduct',tempNode.get('CSProduct'));
                    System.debug('CSProduct'+mapResult);
                    result.add(mapResult);
                  }
               
            }
        }
   }
   
    
 return result;
}

   
}