/*ILA INWIB2C-PHASE2 18.06.2021 BEGIN*/
@isTest
public class INWIB2C_TransformJsonOSSTest {
    static testMethod void TransformJsonOSS()
{
    String DRJson='{"relatedParty":[{"TYPE_LIGNE":"B2CPRE"}],"id":"a3625000000ESWVAA4","user":"djamel.lekhbassene@devph02.com","resourceRef":[{"OFFER_TYPE":"0","VPN_GROUP":"VPN","PARAMETER_OCS":"1","VMS_PROFILE":"9991122444","DESTINATION":"506","OCSID":"ocsid","LANG":"FR","KI":"KI","IMSI":"IMSI","OLD_MSISDN":"provorigin","MSISDN":"finalm","OLD_INPROFILE":"old-profil","INPROFILE":"4490"}],"serviceOrderItem":[{"serviceRefOrValue":{"characteristic":{"SERVICE_LEVEL_OUT":{"code":"SERVICE_LEVEL_OUT","value":"SR0"},"SERVICE_LEVEL_IN":{"code":"SERVICE_LEVEL_IN","value":"ALLOWED"}}},"action":"ADD","code":"VOICE"},{"action":"ADD","code":"USSD"},{"action":"ADD","code":"MMS"},{"action":"ADD","code":"CLIP"},{"action":"ADD","code":"CLIR"},{"action":"ADD","code":"CALL_TRANSFER_LEVEL"},{"serviceRefOrValue":{"characteristic":{"SMS_OUT":{"code":"SMS_OUT","value":"ALLOWED"},"SMS_IN":{"code":"SMS_IN","value":"ALLOWED"}}},"action":"ADD","code":"SMS"},{"action":"ADD","code":"CAMEL"},{"action":"ADD","code":"VOLTE"},{"action":"ADD","code":"CALLWAIT"},{"serviceRefOrValue":{"characteristic":{"IROAM_SERVICE_LEVEL":{"code":"IROAM_SERVICE_LEVEL","value":"Roaming Voix+SMS+Data"}}},"action":"ADD","code":"IROAM"},{"action":"ADD","code":"DATA"}],"uuid":"418fd216-fae7-8161-b260-37c36aac3a8d"}';
    //String DRJson='{"serviceOrderItem": [{"code": "CAMEL","action": "ADD"},{"code": "VOLTE","action": "NOP"}],"relatedParty": [{"TYPE_LIGNE": "B2CPRE"}],"resourceRef": {"ICCID": "892128510050200964","IMSI": "604050400053933","OLD_OCSID": "IN1","OCSID": "IN1","OLD_MSISDN": "INWIB2C_ATT_RT_MSISDN_PROVISIONAL"},"action": "MOD","reason": "ORDER_CUSTOMIZATION","id": "a3625000000ETCQAA4"}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    INWIB2C_TransformJsonOSS.invokeMethod('TransformOssJson',input,output,options);

}
        static testMethod void TransformJsonOSSSMO()
{
    String DRJson='{"resourceRef":{"OLD_MSISDN":"INWIB2C_ATT_RT_MSISDN_PROVISIONAL","OCSID":"IN1","OLD_OCSID":"IN1","IMSI":"604050400053933","ICCID":"892128510050200964"}}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    INWIB2C_TransformOSSSMO.invokeMethod('TransformOssJson',input,output,options);

}
           static testMethod void TransformJsonOSSSPN()
{
    String DRjson='{"serviceOrder":{"orderItem":[{"targetoperator":"INWI","type":"PORTABILITY","action":"create","serviceRefOrValue":[{"supportingResource":[{"PROVISIONAL_MSISDN":"212648060891","FINAL_MSISDN":"212767676767","CSOFFER_TYPE":"MOBILE"}],"relatedParty":[{"cSIndividualName":{"lastName":"KANTAS","firstName":"HIND"},"birthDate":"2000-04-07","cSPostalAddress":{"country_code":"MAR","region":"Region de l\'Oriental","city":"AGHBAL","line1":"Adresse","postalCode":"11"},"TYPE_LIGNE":"B2C","cSIdentification":{"code":"H98"},"id":"a6Y25000000D3PjEAK"}]}],"creationDate":"2021-05-26T17:35:39.000Z","captureID":"801250000027qiVAAQ","sourceoperator":"MAROCTELECOM","lifeCycleStatus":"APOR","Id":"a6Y25000000D3PjEAK"}]}}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRJson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    INWIB2C_TransformJSONSPN.invokeMethod('TransformOssJson',input,output,options);

}

/*ILA INWIB2C-PHASE2 18.06.2021 END*/
/*ILA INWIB2C-PHASE3 19.05.2022 START*/
               static testMethod void TransformJsonFraisMigration()
{
    String DRjson='{"payment":{"type":"FEES","fees":[{"serviceCode":"CCMFR","description":"Modification de forfait","credit":"true","parameter":[{"1":{"value":"82194","name":"Forfait Illimité inwi 11h+11Go"},"2":{"value":"86906","name":"Forfait 4H + 2Go"},"3":{"value":"OUI","name":"FMFPENALITE_B"}}]}],"order":{"devis":"true","reasoncode":"4","offerCode":{"code":"MOBO2"},"captureID":"a4k3M0000008jvtQAA","billingAccountID":"0013M00000zwUTTQA2"}}}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRjson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    InwiB2C_TransformJsonFraisMigration.invokeMethod('TransformJson',input,output,options);

}
/*ILA INWIB2C-PHASE3 19.05.2022 END*/
    
    /*ILA INWIB2C-PHASE3 27.05.2022 START*/
               static testMethod void TransformJsonOSSPost()
{
    String DRjson='{"SP":{"code":"AppendantProduct","action":"ADD","subproductCode":[{"code":81020,"action":"ADD"},{"code":3100,"action":"ADD"},{"code":81017,"action":"ADD"},{"code":"X2","action":"ADD"}]},"action":"ADD","relatedParty":[{"TYPE_LIGNE":"B2CPOST"}],"id":"a363M000000BrXBQA0","user":"imane.2.lakrari@atos.net.b2c.dev3","resourceRef":[{"VMS_PROFILE":"9991122444","OFFER_TYPE":"0","DESTINATION":"506","PARAMETER_OCS":1,"INPROFILE":"86913","OLD_INPROFILE":"84001","MSISDN":"212704546993","OLD_OCSID":"1234","OLD_MSISDN":"212704546993","KI":"7171812AABD288AA17B6379149336EB6","IMSI":"604020090227053","ICCID":"892120270001227162"}],"serviceOrderItem":[{"code":"CALLWAIT","action":"ADD"},{"serviceRefOrValue":{"characteristic":{"CALL_TRANSFER_LEVEL":{"code":"CALL_TRANSFER_LEVEL"}}},"code":"CALL_TRANSFER","action":"ADD"},{"serviceRefOrValue":{"characteristic":{"SERVICE_LEVEL_OUT":{"value":"SR0","code":"SERVICE_LEVEL_OUT"},"SERVICE_LEVEL_IN":{"value":"ALLOWED","code":"SERVICE_LEVEL_IN"}}},"code":"VOICE","action":"ADD"},{"code":"MMS","action":"ADD"},{"serviceRefOrValue":{"characteristic":{"SMS_OUT":{"value":"ALLOWED","code":"SMS_OUT"},"SMS_IN":{"value":"ALLOWED","code":"SMS_IN"}}},"code":"SMS","action":"ADD"},{"code":"CAMEL","action":"ADD"},{"code":"VOLTE","action":"ADD"},{"code":"USSD","action":"ADD"},{"code":"CALLHOLD","action":"ADD"},{"code":"CLIR","action":"ADD"},{"code":"CLIP","action":"ADD"},{"serviceRefOrValue":{"characteristic":{"SERVICE_STATUS":{"code":"SERVICE_STATUS"}}},"code":"DATA","action":"ADD"},{"serviceRefOrValue":{"characteristic":{"IROAM_SERVICE_LEVEL":{"value":"VS","code":"IROAM_SERVICE_LEVEL"}}},"code":"IROAM","action":"ADD"}],"uuid":"6391850e-3751-40ca-764e-6411fabe9905"}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRjson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    INWIB2C_TransformJsonOSSPost.invokeMethod('TransformOssJson',input,output,options);

}
/*ILA INWIB2C-PHASE3 27.05.2022 END*/
        
    /*ILA INWIB2C-PHASE4 04.01.2023 START*/
               static testMethod void TransformJsonOSSFTTH()
{
    String DRjson='{"data":{"characteristic":{"SERVICE_STATUS":"Autorisé","LOGIN":"GSM","PASSWORD":"12345","DEBIT":"12345"},"code":"DATA","action":"ADD"},"offerType":"FIXE","relatedParty":[{"TYPE_LIGNE":"B2C"}],"reasoncode":"ORDER","action":"ADD","id":"a360C00000067WrQAI","user":"imane.2.lakrari@inwib2c.dev4","resourceRef":[{"FIXE_OFFER_TYPE":"ADSL","VPN_GROUP":"6035390","OFFER_TYPE":"2","DESTINATION":"SF","ACTIVE_FIRST_B2C":"DEL","VMS_PROFILE":"9991122444","PARAMETER_OCS":1,"OCSID":"IN2","INPROFILE":"88986","SUB_ID":"1234","CAPTPL_ID":"1234","FRAME":"604050400082178","PORT":"12345","TYPE_PORT":"12","SLOT":"2","MSISDN":"212648096950"}],"serviceOrderItem":[{"serviceRefOrValue":{"characteristic":{"SERVICE_LEVEL_OUT":{"value":"SR0","code":"SERVICE_LEVEL_OUT"},"SERVICE_LEVEL_IN":{"value":"ALLOWED","code":"SERVICE_LEVEL_IN"}}},"code":"VOICE","action":"ADD"},{"serviceRefOrValue":{"characteristic":{"CALL_TRANSFER_LEVEL":{"code":"CALL_TRANSFER_LEVEL"}}},"code":"CALL_TRANSFER","action":"ADD"},{"code":"CALLWAIT","action":"ADD"}],"uuid":"203bafcd-474f-cfcd-94f7-84d60dbf14cc"}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRjson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    INWIB2C_TransformJsonOSSFTTH.invokeMethod('TransformOssJson',input,output,options);

}
/*ILA INWIB2C-PHASE4 04.01.2023 END*/
    
     /*ILA 06.09.2023 START*/
               static testMethod void TransformJsonOSSChangeOfferFixe()
{
    String DRjson='{"data":{"characteristic":{"SERVICE_STATUS":"Autorisé","PASSWORD":"YuCA86PcGrExvUxf","LOGIN":"LG03013451"},"code":"DATA","action":"NOP"},"relatedParty":[{"TYPE_LIGNE":"B2C"}],"action":"MOD","resourceRef":[{"VMS_PROFILE":"9991122444","OFFER_TYPE":"1","DESTINATION":"506","PROVIDER_ID":"FH","FIXE_OFFER_TYPE":"FO","OLD_INPROFILE":"88594","INPROFILE_CHANGE":"MOD","SLOT":"1","PORT":"1","FRAME":"1","OLT_ID":"10.87.52.218","TYPE_PORT":"FO","OLD_MSISDN":"212526002501","MSISDN":"212526002501","INPROFILE":"89508","ONU_ID":"10","MAC_ADDRESS":"20AB488E4A22"}],"offerType":"FIXE","id":"a363L000000brV9QAI"}';
    Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(DRjson);
    Map<String,Object> output = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    INWIB2C_TransformJsonChangeOffreFix.invokeMethod('TransformOssJson',input,output,options);

}
/*ILA 06.09.2023 END*/
}