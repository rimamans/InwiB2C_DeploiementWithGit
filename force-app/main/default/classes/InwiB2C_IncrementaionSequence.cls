global without sharing class InwiB2C_IncrementaionSequence implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
       
        if(methodName.equals('incrementation')){
          
          //return incrementation(inputMap,outMap,options);
         outMap.put('result', incrementation());
         }
        if(methodName.equals('insertsequence')){
		outMap.put('result', insertsequence());            
        }
      
            return false;
        
    }
    global String incrementation(){
        InwiB2C_Sequence_Order_Number__c sequenceDeg = [select id,InwiB2C_Sequence__c from InwiB2C_Sequence_Order_Number__c where name='Sequence Degroupage'];
        sequenceDeg.InwiB2C_Sequence__c = sequenceDeg.InwiB2C_Sequence__c +1;
        //update sequenceDeg;
       	return  String.valueOf(sequenceDeg.InwiB2C_Sequence__c);
    }
    
    global String insertsequence(){
        InwiB2C_Sequence_Order_Number__c sequenceDeg = [select id,InwiB2C_Sequence__c from InwiB2C_Sequence_Order_Number__c where name='Sequence Degroupage'];
        sequenceDeg.InwiB2C_Sequence__c = sequenceDeg.InwiB2C_Sequence__c +1;
        if(!Test.isRunningTest()){
        	update sequenceDeg;
        }
       	return  String.valueOf(sequenceDeg.InwiB2C_Sequence__c);
    }
}