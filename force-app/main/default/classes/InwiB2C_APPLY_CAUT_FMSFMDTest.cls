@isTest
public  class InwiB2C_APPLY_CAUT_FMSFMDTest {
 @isTest(SeeAllData=false)
   	 static void testCallVIP()
{
 
    String firstinput='{  "Isterminal": null, "Id": "8023L000002w3KyQAI", "FNR": 490, "FMS": 10,  "FMD": 200, "VALUE_CAUTION": 0,  "errorCode": "INVOKE-200", "error": "OK"}' ;
        Map<String,Object> input =  (Map<String, Object>)JSON.deserializeUntyped(firstinput);
    Map<String,Object> options = new  Map<String,Object>();
	Map<String,Object> output= new  Map<String,Object>();
	InwiB2C_APPLY_CAUT_FMSFMD cls= new InwiB2C_APPLY_CAUT_FMSFMD();
	cls.invokeMethod('Calculs_Values',input,output,options);
    
}

}