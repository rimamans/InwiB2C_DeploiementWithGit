@isTest
public  class InwiB2C_Calcule_FMD_Test {
 @isTest(SeeAllData=true)
   	 static void testCallVIP()
{
    
/* String firstinput='{ "CSOrderScor":  {"targetOperator": "mTelecom","seniority": 0,"AdditionelCretera": [{"Value": "","Code": ""}],"typeClient": "GP","isPorrtability": "NON","isExistOrder": true,"isBlackListed": "False","handSetType": "Term","engagementDuration": null,"Isterminal": "TRUE","terminalId": "8023L000002uy2CQAQ","offre": "INWIB2C_OFFERING_ADSL20MG_199DH","Id": "8023L000002uy23QAA"} }';*/
  String firstinput='{ "CSOrderScor":  {"targetOperator": "mTelecom","seniority": 0,"AdditionelCretera": [{"Value": "","Code": ""}],"typeClient": "GP","isPorrtability": "NON","isExistOrder": true,"isBlackListed": "False","handSetType": "Term","engagementDuration": null,"Isterminal": "TRUE","terminalId": "8023L000002NPopQAG","offre": "INWIB2C_OFFERING_FTTH20MG_249DH","Id": "8023L000002NPogQAG"} }';
    Map<String,Object> input =  (Map<String, Object>)JSON.deserializeUntyped(firstinput);Map<String,Object> options = new  Map<String,Object>();
	Map<String,Object> output= new  Map<String,Object>();
	InwiB2C_Calcule_FMD cls= new InwiB2C_Calcule_FMD();
	cls.invokeMethod('Calculs_Values',input,output,options);
   
}

}