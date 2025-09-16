/**
 * @description       : cette classe implemente l'interface vlocity_cmt.VlocityOpenInterface2 pour pouvoir appeler la classe InwiB2C_SharingRequestManagement depuis les os et les IP
 * @author            : Imane Lakrari
 * @last modified on  : 24-12-2024
 * @last modified by  : Imane Lakrari
**/

global class InwiB2C_SharingRequestManagementVI implements vlocity_cmt.VlocityOpenInterface2 {
	global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
    Boolean result = true;    
    try{
      if(methodName.equals('cloneSharingRequest'))
        CallcloneSharingRequest(input, output, options);
      if(methodName.equals('searchForScopedRequest'))
        CallSearchForScopedRequest(input, output, options);
      if(methodName.equals('searchForUnscopedRequest'))
        CallSearchForUnscopedRequest(input, output, options);
      if(methodName.equals('getRequestStatus'))
        getRequestStatus(input, output, options);     
    }catch(Exception e){
      result = false;
    }     
    return result;            
  }
     
  public static void CallcloneSharingRequest(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
    String commandeId= InwiB2C_SharingRequestManagement.cloneSharingRequest(input);
    output.put('newCommandeDeg',commandeId);   
  }

  public static void CallSearchForScopedRequest(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
    List<Object> requestList= InwiB2C_SharingRequestManagement.searchForScopedRequest(input);
    output.put('requestList',requestList);
  }

  public static void CallSearchForUnscopedRequest(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
    List<Object> requestList= InwiB2C_SharingRequestManagement.searchForUnscopedRequest(input);
    output.put('requestList',requestList);
  }

  public static void getRequestStatus(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
    List <Map <String,String>> statutListe= InwiB2C_SharingRequestManagement.getRequestStatus(input);
    output.put('statutList',statutListe);
  }

}