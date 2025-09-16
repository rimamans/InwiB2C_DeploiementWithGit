global class InwiB2C_APPLY_CAUT_FMSFMD implements vlocity_cmt.VlocityOpenInterface{
  global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
   
    Boolean result = true;

    try{

      if (methodName.equals('Calculs_Values')){
        Calculs_Values(inputMap, outMap);
      }

    } catch (Exception e){

      result = false;

    }

    return result;
  }

  private void Calculs_Values(Map<String, object> input, Map<String, object> output){

    String status = '';
 
    Map<String, Object> inputt = (Map<String, Object>)JSON.deserializeUntyped(json.serialize(input));
    System.debug(inputt);
 
    String Isterminal = (String) inputt.get('Isterminal'); 
 
    String Id = (String) inputt.get('IdM');
  System.debug('ID ' +  Id);
    Decimal ValueFNR = (Decimal) inputt.get('FNR');
    System.debug(ValueFNR);
    Decimal FMS = (Decimal) inputt.get('FMS');
    System.debug(FMS);
    Decimal FMD = (Decimal) inputt.get('FMD');
    System.debug(FMD);
    Decimal VALUE_CAUTION = (Decimal) inputt.get('VALUE_CAUTION');
    System.debug(VALUE_CAUTION); 

         
    Map<String,String> fnr=new Map<String,String>();
    //CHB 04/03/2024 ano B-14377 begin */
      OrderItem orderItem = [Select id, InwiB2C_FMS__c, InwiB2C_FMD__c,InwiB2C_FNR__c,InwiB2C_FMS_Catalogue__c,InwiB2C_FMD_Catalogue__c
                       from OrderItem
                       where Id = :Id
                       limit 1];
 //CHB 04/03/2024 ano B-14377 end */
      orderItem.InwiB2C_FMS__c = FMS;
      //CHB 04/03/2024 ano B-14377 BEGIN */
      orderItem.InwiB2C_FMS_Catalogue__c=FMS;
      //CHB 04/03/2024 ano B-14377 end */
        if (Isterminal == 'TRUE'){
                  orderItem.InwiB2C_FMD__c = FMD;
                  //CHB 04/03/2024 ano B-14377 BEGIN */
                  orderItem.InwiB2C_FMD_Catalogue__c=FMD;
                  //CHB 04/03/2024 ano B-14377 end */
                  //fnr.put('fnr',String.valueOf(ValueFNR));
            	  //output.put('data1', fnr);
                  // System.debug(fnr);
        }
      update orderItem;
    
 
  }

}