global class testFlow implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {
        System.debug('methodName '+methodName);
        System.debug('inputs '+inputs);
        if (methodName == 'toLabel')
        {
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', toLabel(arguments));
        }
      
        return true;
    }
    
    public String toLabel(List<Object> arguments){
        System.debug('arguments ' + arguments);
        String objet = String.valueOf(arguments[0]);
		String champ = String.valueOf(arguments[1]);
        String objetId = String.valueOf(arguments[2]);
        String output = '';
        Try {
		String query = 'Select toLabel('+champ+') From '+objet+' where Id=\''+objetId+'\'';
        List<SObject> records = Database.query(query);
        Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(records[0]));
            output= String.valueof(deserialized.get(champ));
        }catch(Exception e){
            System.debug('Exception Message toLabelClass: '+e.getMessage());
        }
        return output;
        
        
    }
    

}