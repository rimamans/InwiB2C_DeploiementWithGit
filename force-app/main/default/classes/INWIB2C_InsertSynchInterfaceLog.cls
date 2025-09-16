//DLE 05/10/2020 begin
public class INWIB2C_InsertSynchInterfaceLog {

  public static void execute(String requestbody , String responseBody, string endpoint) {

        try{
        JSONParser parser = JSON.createParser(requestbody);
        string uuid;
        string mdn;
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && 
                (parser.getText() == 'uuid' || parser.getText() == 'mdn')) {         
                if(parser.getText().contains('uuid')){
                  parser.nextToken();
                  uuid = parser.getText();
                } 
                else {
                  parser.nextToken();
                  mdn = parser.getText();
                }   
                
            }
            if(uuid != null && mdn != null) break;
        }
        system.debug('#######UUID' + uuid);
        system.debug('#######MDN' + mdn);
        if(uuid != null || mdn != null){
          INWIB2C_Interface_Log__c log = new INWIB2C_Interface_Log__c(INWIB2C_Mdn__c = mdn,Name = uuid , INWIB2C_Request__c = requestbody , INWIB2C_Response__c  = responseBody  , INWIB2C_Endpoint__c = endpoint , INWIB2C_Method__c = endpoint.SubstringAfterLast('/'));
          insert log;
      }
      }catch (exception e){
        system.debug('########## Error When Parsing Response ' + e.getMessage() + 'Line NUmber ' + e.getLineNumber());
      }
  }
}
//DLE 05/10/2020 end