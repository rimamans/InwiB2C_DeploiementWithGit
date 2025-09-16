global without sharing class InwiB2C_OfferPermissionSetFilter implements vlocity_cmt.VlocityOpenInterface{
    
    private static final Set<String> parcoursName = new Set<String>{'Acquisition', 'PrePost', 'PostPost'};
    private static Map<String, SObjectField> product2Fields;
    
    static {
        // Query all fields of the Product2 object
        product2Fields = Schema.SObjectType.Product2.fields.getMap();
    }
    
        global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        Boolean result = true;

        try{

            if (methodName.equals('constructPermissionSetsOfferFilter')){
                constructPermissionSetsOfferFilter(inputMap, outMap, options);

            } else result = false;


        } catch (Exception e){

            result = false;

        }

        return result;
    }

    public static void constructPermissionSetsOfferFilter(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> option) {
        
        String typeParcours = (String)inputMap.get('typeParcours');
        
        if (String.isBlank(typeParcours) || !parcoursName.contains(typeParcours)) {
            //return '';
            outMap.put('filterOfferPermissionSet','');
        }

        List<PermissionSetAssignment> permissionSetAssignments = [
            SELECT PermissionSet.Name
            FROM PermissionSetAssignment
            WHERE (PermissionSet.Name LIKE '%Hide%' OR PermissionSet.Name LIKE '%Show%') AND AssigneeId =: UserInfo.getUserId()
        ];

        System.debug('list Permis ' + permissionSetAssignments);
        if (permissionSetAssignments.isEmpty()) {
            //return '';
            outMap.put('filterOfferPermissionSet','');
        }

        String result =',';

        for (PermissionSetAssignment psa : permissionSetAssignments) {
            String psName = psa.PermissionSet.Name;

            // Remove the view name from the permission set name
            String psNameWithoutView = removeViewName(psName);

            // Verify field existence
            String fieldName = 'inwiB2C_' + psNameWithoutView + '__c';
            
            System.debug('fieldName ' + fieldName);
            
            if (product2Fields.containsKey(fieldName)) {
                boolean containsPossibleValues = containsAny(psName, parcoursName);
                System.debug('containsPossibleValues ' + containsPossibleValues);
                System.debug('psName.contains(typeParcours) ' + psName.toLowerCase().contains(typeParcours.toLowerCase()));
                
                if (!containsPossibleValues || (containsPossibleValues && psName.toLowerCase().contains(typeParcours.toLowerCase()))) {
                result +='Product2.' + fieldName + (psName.contains('Hide') ? ':false,' : ':,');
                 System.debug('concat string ' + 'Product2.' + fieldName + (psName.contains('Hide') ? ':false,' : ':,'));
            	}
            }
        }

        if (result.length() > 0) {
            result = result.substring(0, result.length() - 1);
        }
        
        System.debug('final filter ' + result.replaceAll('\\s', ''));
        outMap.put('filterOfferPermissionSet',result.replaceAll('\\s', ''));
        //return result.replaceAll('\\s', '');
    }

    private static Boolean containsAny(String input, Set<String> substrings) {
        for (String substring : substrings) {
            if (input.toLowerCase().contains(substring.toLowerCase())) {
                return true;
            }
        }
        return false;
    }
    
    private static String removeViewName(String psName) {
        for (String name : parcoursName) {
            psName = psName.replaceAll(name, ''); 
        }
        return psName;
    }
}