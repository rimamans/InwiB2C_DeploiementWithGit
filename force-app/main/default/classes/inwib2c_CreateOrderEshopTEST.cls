@isTest
 
 public  class inwib2c_CreateOrderEshopTEST {
    @isTest(SeeAllData=true)
     public static void inwib2c_CreateOrderEshopTEST() {

        inwib2c_CreateOrderEshop cls = new inwib2c_CreateOrderEshop();
      
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        String JsonResponse ='{"errorCode":"","errorMessage":"Success","isOK":0,"orderId":""}';
        String bodyRequete = '{"CSOperationInfo":{"uuid":"1234","channel":"SF","user":"B2C"},"buyerId":"'+ testAccount.Id +'","customerId":"'+ testAccount.Id +'","delivery":{"codeliv":"deliverydomicile","type":"DOMICILE"},"idsaporder":"","orderType":"PDC","paymentMethod":"CB","paymentReference":"","products":[{"subProducts":[{"price":{"amount":10000,"type":"ONE_SHOT"},"attributes":[{"value":"000056877","code":"INWIB2C_ATT_RT_MODELE"},{"value":"HANDSET GSM APPLE IPHONE 8 64G GOLD","code":"INWIB2C_ATT_DC_MODELELABEL"}],"code":"TERMINAL","type":"Handset"},{"attributes":[{"value":"212648113694","code":"INWIB2C_ATT_RT_MSISDN"},{"value":"personnaliser le numéro","code":"INWIB2C_ATT_RT_CHOIX_NUMERO"},{"value":"Gold","code":"INWIB2C_ATT_RT_TYPE_NULERO"}],"price": {"aditionalPayments":[{"price":49,"type":"FMD","id":809}],"amount":"349","type":"ONE_SHOT"},"code":"INWIB2C_MOB02_OFFERING_MSISDN_STANDARD","type":"Number"}],"price":{"aditionalPayments":[{"price":199,"type":"FMD","id":"0"}],"amount":"199","type":"RECURRING"},"engagement":"0","idProfile":"86913","code":"INWIB2C_OFFERING_199DH_INTERNET"}],"promo":"SLD","siteId":"","submite":false,"waitpayment":false}';

        InwiB2C_Trace_API__c newtrace =new  InwiB2C_Trace_API__c(InwiB2C_API_Name__c='WS54',InwiB2C_Status__c='OK',InwiB2C_Response__c=JsonResponse,InwiB2C_request_body__c=bodyRequete,InwiB2C_uuid__c='6fa0c6b7-9895-6263-498b-242facac8a96');
        insert newtrace;
        inwib2c_TraceDemandeEshop__c newtraceeshop =new  inwib2c_TraceDemandeEshop__c(inwib2c_Statut__c='OK',inwib2c_Request_body__c=bodyRequete,inwib2c_Mode_de_paiement__c='E-paiement',IdTraceAPI__c=newtrace.Id);
        insert newtraceeshop;
     


        String input = '{"TraceId":"' + newtrace.Id + '","bodyJson":"{\\"orderType\\":\\"PDC\\",\\"promo\\":\\"SLD\\",\\"customerId\\":\\" ' + testAccount.Id + '\\",\\"buyerId\\":\\" '+ testAccount.Id +'\\",\\"paymentMethod\\":\\"CB\\",\\"paymentReference\\":\\"000000368242\\",\\"delivery\\":{\\"type\\":\\"DOMICILE\\",\\"codeliv\\":\\"deliverydomicel\\",\\"deliveryPrice\\":\\"490\\"},\\"products\\":[{\\"code\\":\\"INWIB2C_OFFERING_49DH_INTERNET\\",\\"idProfile\\":\\"89015\\",\\"engagement\\":\\"0\\",\\"price\\":{\\"type\\":\\"RECURRING\\",\\"amount\\":\\"149\\"},\\"aditionalPayments\\":[{\\"id\\":\\"0\\",\\"type\\":\\"FMD\\",\\"price\\":\\"100\\"},{\\"id\\":\\"0\\",\\"type\\":\\"FMD\\",\\"price\\":\\"200\\"}],\\"subProducts\\":[{\\"type\\":\\"Number\\",\\"code\\":\\"INWIB2C_MOB02_OFFERING_MSISDN_STANDARD\\",\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"349\\"},\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_RT_MSISDN\\",\\"value\\":\\"212663208407\\"}]},{\\"type\\":\\"Handset\\",\\"code\\":\\"TERMINAL\\",\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_RT_IMEI\\",\\"value\\":\\"868566656\\"}],\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"1352\\"}},{\\"type\\":\\"Option\\",\\"code\\":\\"INWIB2C_MOB02_OFFERING_OPT_Telco\\",\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_DC_EXISTXGO\\",\\"value\\":\\"Non\\"}],\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"0\\"}}]}]}' + '"}';


        Map<String,Object> bodyjson =  (Map<String, Object>)JSON.deserializeUntyped(input);

      
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
      
    
        boolean result = cls.invokeMethod('CreateOrderEshop', bodyjson, outMap, options);
  
    }

    //SecondTest
    @isTest(SeeAllData=true)
    public static void inwib2c_CreateOrderEshopTESTForProductTeminal() {
       inwib2c_CreateOrderEshop cls = new inwib2c_CreateOrderEshop();
  
       Account testAccount = new Account();
       testAccount.Name='Test Account';
       insert testAccount;
       String JsonResponse ='{"errorCode":"","errorMessage":"Success","isOK":0,"orderId":""}';
       String bodyRequete='{"CSOperationInfo": {"uuid": "b517c235-2a9f-4007-ac08-8aa9513c5f97","user": "galaxie","channel": "galaxie"},"buyerId": "'+ testAccount.Id +'","customerId": "'+ testAccount.Id +'","delivery": {"type": "DOMICILE","deliveryPrice": 0.0,"codeliv": "deliverydomicile"},"idsaporder":"","orderType": "PDC","paymentMethod": "ES","paymentReference": "","products": [{"type": "Handset","price": {"type": "ONE_SHOT","amount": 2100.0},"code": "TERMINAL","attributes": [{"value": "100001793","code": "INWIB2C_ATT_RT_MODELE"},{"value": "XIAOMI NOTE 10 4/128GB DK","code": "INWIB2C_ATT_DC_MODELELABEL"}]}],"promo": "","siteId": "","submite":false,"waitpayment":false}';

       InwiB2C_Trace_API__c newtrace =new  InwiB2C_Trace_API__c(InwiB2C_API_Name__c='WS54',InwiB2C_Status__c='OK',InwiB2C_Response__c=JsonResponse,InwiB2C_request_body__c=bodyRequete,InwiB2C_uuid__c='6fa0c6b7-9895-6263-498b-242facac8a96');
       insert newtrace;
       inwib2c_TraceDemandeEshop__c newtraceeshop =new  inwib2c_TraceDemandeEshop__c(inwib2c_Statut__c='OK',inwib2c_Request_body__c=bodyRequete,inwib2c_Mode_de_paiement__c='En Espece',IdTraceAPI__c=newtrace.Id);
        insert newtraceeshop;
    


       String input = '{"TraceId":"' + newtrace.Id + '","bodyJson":"{\\"orderType\\":\\"PDC\\",\\"promo\\":\\"SLD\\",\\"customerId\\":\\"'+ testAccount.Id +'\\",\\"buyerId\\":\\"'+ testAccount.Id +'\\",\\"paymentMethod\\":\\"CB\\",\\"paymentReference\\":\\"000000368242\\",\\"delivery\\":{\\"type\\":\\"DOMICILE\\",\\"codeliv\\":\\"deliverydomicel\\",\\"deliveryPrice\\":\\"490\\"},\\"products\\":[{\\"code\\":\\"INWIB2C_OFFERING_49DH_INTERNET\\",\\"idProfile\\":\\"89015\\",\\"engagement\\":\\"0\\",\\"price\\":{\\"type\\":\\"RECURRING\\",\\"amount\\":\\"149\\"},\\"aditionalPayments\\":[{\\"id\\":\\"0\\",\\"type\\":\\"FMS\\",\\"price\\":\\"100\\"},{\\"id\\":\\"0\\",\\"type\\":\\"FMD\\",\\"price\\":\\"200\\"}],\\"subProducts\\":[{\\"type\\":\\"Number\\",\\"code\\":\\"INWIB2C_MOB02_OFFERING_MSISDN_STANDARD\\",\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"349\\"},\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_RT_MSISDN\\",\\"value\\":\\"212663208407\\"}]},{\\"type\\":\\"Handset\\",\\"code\\":\\"TERMINAL\\",\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_RT_IMEI\\",\\"value\\":\\"868566656\\"}],\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"1352\\"}},{\\"type\\":\\"Option\\",\\"code\\":\\"INWIB2C_MOB02_OFFERING_OPT_Telco\\",\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_DC_EXISTXGO\\",\\"value\\":\\"Non\\"}],\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"0\\"}}]}]}' + '"}';


       Map<String,Object> bodyjson =  (Map<String, Object>)JSON.deserializeUntyped(input);

  
       Map<String, Object> options = new Map<String, Object>();
       Map<String, Object> outMap = new Map<String, Object>();

       
   
       boolean result = cls.invokeMethod('CreateOrderEshop', bodyjson, outMap, options);
   
  }
     
      @isTest(SeeAllData=true)
     public static void inwib2c_CreateOrderEshopTESTForAgence() {

        inwib2c_CreateOrderEshop cls = new inwib2c_CreateOrderEshop();
      
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        String JsonResponse ='{"errorCode":"","errorMessage":"Success","isOK":0,"orderId":""}';
        String bodyRequete = '{"CSOperationInfo":{"uuid":"1234","channel":"SF","user":"B2C"},"buyerId":"'+ testAccount.Id +'","customerId":"'+ testAccount.Id +'","delivery":{"agenceId":"CPD09","codeliv":"deliveryagence","type":"AGENCE"},"orderType":"PDC","paymentMethod":"CB","paymentReference":"","products":[{"subProducts":[{"price":{"amount":10000,"type":"ONE_SHOT"},"attributes":[{"value":"000056877","code":"INWIB2C_ATT_RT_MODELE"},{"value":"HANDSET GSM APPLE IPHONE 8 64G GOLD","code":"INWIB2C_ATT_DC_MODELELABEL"}],"code":"TERMINAL","type":"Handset"},{"attributes":[{"value":"212648113694","code":"INWIB2C_ATT_RT_MSISDN"},{"value":"personnaliser le numéro","code":"INWIB2C_ATT_RT_CHOIX_NUMERO"},{"value":"Gold","code":"INWIB2C_ATT_RT_TYPE_NULERO"}],"price":{"amount":"349","type":"ONE_SHOT"},"code":"INWIB2C_MOB02_OFFERING_MSISDN_STANDARD","type":"Number"}],"price":{"aditionalPayments":[{"price":199,"type":"FMS","id":"0"}],"amount":"199","type":"RECURRING"},"engagement":"0","idProfile":"86913","code":"INWIB2C_OFFERING_199DH_INTERNET"}],"promo":"SLD","siteId":"","submite":true,"waitpayment":false}';

        InwiB2C_Trace_API__c newtrace =new  InwiB2C_Trace_API__c(InwiB2C_API_Name__c='WS54',InwiB2C_Status__c='OK',InwiB2C_Response__c=JsonResponse,InwiB2C_request_body__c=bodyRequete,InwiB2C_uuid__c='6fa0c6b7-9895-6263-498b-242facac8a96');
        insert newtrace;
        inwib2c_TraceDemandeEshop__c newtraceeshop =new  inwib2c_TraceDemandeEshop__c(inwib2c_Statut__c='OK',inwib2c_Request_body__c=bodyRequete,inwib2c_Mode_de_paiement__c='E-paiement',IdTraceAPI__c=newtrace.Id);
        insert newtraceeshop;
     


        String input = '{"TraceId":"' + newtrace.Id + '","bodyJson":"{\\"orderType\\":\\"PDC\\",\\"promo\\":\\"SLD\\",\\"customerId\\":\\" ' + testAccount.Id + '\\",\\"buyerId\\":\\" '+ testAccount.Id +'\\",\\"paymentMethod\\":\\"CB\\",\\"paymentReference\\":\\"000000368242\\",\\"delivery\\":{\\"type\\":\\"DOMICILE\\",\\"codeliv\\":\\"deliverydomicel\\",\\"deliveryPrice\\":\\"490\\"},\\"products\\":[{\\"code\\":\\"INWIB2C_OFFERING_49DH_INTERNET\\",\\"idProfile\\":\\"89015\\",\\"engagement\\":\\"0\\",\\"price\\":{\\"type\\":\\"RECURRING\\",\\"amount\\":\\"149\\"},\\"aditionalPayments\\":[{\\"id\\":\\"0\\",\\"type\\":\\"FMS\\",\\"price\\":\\"100\\"},{\\"id\\":\\"0\\",\\"type\\":\\"FMD\\",\\"price\\":\\"200\\"}],\\"subProducts\\":[{\\"type\\":\\"Number\\",\\"code\\":\\"INWIB2C_MOB02_OFFERING_MSISDN_STANDARD\\",\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"349\\"},\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_RT_MSISDN\\",\\"value\\":\\"212663208407\\"}]},{\\"type\\":\\"Handset\\",\\"code\\":\\"TERMINAL\\",\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_RT_IMEI\\",\\"value\\":\\"868566656\\"}],\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"1352\\"}},{\\"type\\":\\"Option\\",\\"code\\":\\"INWIB2C_MOB02_OFFERING_OPT_Telco\\",\\"attributes\\":[{\\"code\\":\\"INWIB2C_ATT_DC_EXISTXGO\\",\\"value\\":\\"Non\\"}],\\"price\\":{\\"type\\":\\"ONE_SHOT\\",\\"amount\\":\\"0\\"}}]}]}' + '"}';


        Map<String,Object> bodyjson =  (Map<String, Object>)JSON.deserializeUntyped(input);

      
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
      
    
        boolean result = cls.invokeMethod('CreateOrderEshop', bodyjson, outMap, options);
  
    }
 
     
}