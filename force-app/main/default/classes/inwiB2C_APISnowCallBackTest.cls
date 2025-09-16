@isTest
public class inwiB2C_APISnowCallBackTest {
  @isTest(SeeAllData=true)
   	static void inwiB2C_APISnowCallBackTest(){
	  inwiB2C_APISnowCallBack cls = new inwiB2C_APISnowCallBack();
    String firstinput='{ "id": "a360C00000069YSQAY", "status": "1", "uuid": "a6e40d9c-a371-448a-97af-dcf84c4beb4c", "errorCode": "", "errorMessage": "", "services": [ { "service_code": "INWIB2C_FOB2C_OFFERING_TERMINAL", "service_ins": "02i0C000001vejlQAA", "attributes": [ { "attribute_code": "INWIB2C_ATT_RT_IMEI", "attribute_value": "IMEI" }, { "attribute_code": "INWIB2C_ATT_RT_MODELE", "attribute_value": "ModeleTest" }, { "attribute_code": "INWIB2C_ATT_RT_ONTNAME", "attribute_value": "Nom ONT" }, { "attribute_code": "INWIB2C_ATT_RT_ONTALIAS", "attribute_value": "Alias ONT" }, { "attribute_code": "INWIB2C_ATT_RT_ONTID", "attribute_value": "ID ONT" }, { "attribute_code": "INWIB2C_ATT_RT_CPEMAC", "attribute_value": "Adresse MAC CPE" } ] }, { "service_code": "INWIB2C_OFFERING_FTTH50MG_349DH", "service_ins": "02i0C000001vejcQAA", "attributes": [ { "attribute_code": "INWIB2C_ATT_RT_FRAME", "attribute_value": "Numéro du Frame" }, { "attribute_code": "INWIB2C_ATT_RT_PORT", "attribute_value": "Numéro de Port" }, { "attribute_code": "INWIB2C_ATT_RT_SLOT", "attribute_value": "Numéro de Slot" }, { "attribute_code": "INWIB2C_ATT_RT_OLTID", "attribute_value": "OLTID" } ] } ] }';
    Map<String,Object> inputMap =  (Map<String, Object>)JSON.deserializeUntyped(firstinput);
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    //List<Object> data = new List<Object>();
   
    

    boolean result = cls.invokeMethod('UpdateAttribute', inputMap, outMap, options);
    
    
    }

}