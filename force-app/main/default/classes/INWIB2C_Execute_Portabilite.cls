/*DLE INWIB2C-PHASE2 15.05.2021 Begin*/
//API insert action portabilité In/Out
@RestResource(urlMapping='/ExecutePortabilite')
global with sharing class INWIB2C_Execute_Portabilite {

     @HttpPost
    global static void ExecutePortabilite(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.addHeader('charset', 'UTF-8 Server');
        res.addHeader('Content-Type', 'application/json');
        string isOK='1';
        string errorCode='';
        string errorMessage='';
        string description='';
        string uuid;
        string portemdnin;
        string captureid;
		Map<String, Object> Mapreq = (Map<String,Object>)JSON.deserializeUntyped(req.requestBody.toString());
        Map<String, Object> Maplevel1 = (Map<String,Object>)Mapreq.get('CSPortabilityOrder');
        Map<String, Object> Maplevel11 = (Map<String,Object>)Mapreq.get('CSOperationInfo'); 
        List<Object> ListMdn = (List<Object>)Maplevel1.get('PortedNumber');
        //respense
       
        List<Map<string, Object>> listaMap = new List<Map<string, Object>>(); 
        Map<String, Object>  CSOperationResultInfo = new Map<String, Object> ();
        map<string , Object> CSPortabilityOrder = new Map<String, Object> ();
        map<string,Object> resplevel1 = new Map<String, Object> ();
        map<string,Object> resplevel2 = new Map<String, Object> ();
        //req
        String id = String.valueOf(Maplevel1.get('id'));
        String offerType = String.valueOf(Maplevel1.get('offerType'));
        String sourceOperator = String.valueOf(Maplevel1.get('sourceOperator'));
        String targetOperator = String.valueOf(Maplevel1.get('targetOperator'));
        String newRoute = String.valueOf(Maplevel1.get('newRoute'));
        String customerSegment = String.valueOf(Maplevel1.get('customerSegment'));
        String customerIdentityType = String.valueOf(Maplevel1.get('customerIdentityType'));
        String customerIdentityNumber = String.valueOf(Maplevel1.get('customerIdentityNumber'));
        String uuidin = String.valueOf(Maplevel11.get('uuid'));
        string action  = String.valueOf(Maplevel11.get('action'));
        string jsonstring;
        integer var;
        string idsubs;
        string num;
        
        /*TraceApi DLE 11/10/2021 Begin*/
        String statutAppel='OK';
        InwiB2C_Trace_API__c trace=new InwiB2C_Trace_API__c();
        trace.InwiB2C_API_Name__c='WS03';
        trace.InwiB2C_request_body__c=req.requestBody.toString();
        trace.InwiB2C_uuid__c=uuidin;
        trace.InwiB2C_Object_Number__c=id;
        /*TraceApi DLE 11/10/2021 End*/
  try
{
 /*DLE B-2155 20/09/2021 begin*/
 List<string> ListPhone= new List<string> ();

for(Object PortedMdn : ListMdn){
    Map<String, Object> MapMdn1 = (Map<String, Object>)PortedMdn;
    num =String.valueOf(MapMdn1.get('mdn')); 
    ListPhone.add(num);
}
/*ANO SAAD B-14397 10/06/2024 start*/
List<vlocity_cmt__Subscription__c> souscriptionsSelect = [
    SELECT ID, Inwib2c_Num_ro_de_la_ligne__c, inwiB2C_Statut__c
    FROM vlocity_cmt__Subscription__c
    WHERE Inwib2c_Num_ro_de_la_ligne__c IN :ListPhone AND (
        inwiB2C_Statut__c = 'InwiB2C_Nonidentificationdelaligne' OR
        inwiB2C_Statut__c = 'InwiB2C_Active' OR
        inwiB2C_Statut__c = 'InwiB2C_Blocked' OR
        inwiB2C_Statut__c = 'InwiB2C_EncoursDactivation' OR
        inwiB2C_Statut__c = 'InwiB2C_EncoursMigration' OR
        inwiB2C_Statut__c = 'InwiB2C_RestreinteRecouvrement' OR
        inwiB2C_Statut__c = 'InwiB2C_SuspCycleVie' OR
        inwiB2C_Statut__c = 'InwiB2C_Suspended' OR
        inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturation' OR
        inwiB2C_Statut__c = 'InwiB2C_SuspendueFacturationReseau' OR
        inwiB2C_Statut__c = 'InwiB2C_SuspendueFraude' OR
        inwiB2C_Statut__c = 'InwiB2C_SuspendueRecouvrement'
    )
    /*ANO SAAD B-14397 10/06/2024 end*/
];
        /*DLE B-2155 20/09/2021 end*/
    
List<INWIB2C_REQ_PORTA__c> listportability = new List<INWIB2C_REQ_PORTA__c>();
INWIB2C_REQ_PORTA__c objporta;
        /*DLE B-2155 20/09/2021 begin*/   
         //for (Object PortedMdn : ListMdn) {
         //Map<String, Object> MapMdn = (Map<String, Object>)PortedMdn;
         // portemdnin = String.valueOf(MapMdn.get('mdn'));
        //captureid = String.valueOf(MapMdn.get('subscriptioniD'));
         //List<vlocity_cmt__Subscription__c>  listsubscription = [select  Id  from vlocity_cmt__Subscription__c where Inwib2c_Num_ro_de_la_ligne__c =:portemdnin and inwiB2C_LegacyStatus__c <> 'EXPIRED' LIMIT 1];
         //for(vlocity_cmt__Subscription__c listsubscription1 : listsubscription)
          // { 
          //    idsubs=listsubscription1.Id;
            
           // }
           for (vlocity_cmt__Subscription__c  mdnsubsciption : souscriptionsSelect) {
              /*DLE B-2155 20/09/2021 end*/
         If (mdnsubsciption.Inwib2c_Num_ro_de_la_ligne__c.length() == 12 &&
         mdnsubsciption.Inwib2c_Num_ro_de_la_ligne__c.Substring(0, 3) == '212') {
                //insert demande porta
          objporta =new INWIB2C_REQ_PORTA__c(INWIB2C_ACTION_CODE__c =action
                                             ,INWIB2C_PORTED_MDN__c =mdnsubsciption.Inwib2c_Num_ro_de_la_ligne__c
                                             ,INWIB2C_TYPE_CLIENT__c =customerSegment
                                             ,INWIB2C_SOA_UID__c =uuidin
                                            ,INWIB2C_NEWROUTE__c =newRoute
                                            ,INWIB2C_STATUT__c ='NEW',
                                            INWIB2C_REL_COMMANDE__c =captureid,
                                            INWIB2C_SUBSCRIPTION__c =mdnsubsciption.Id,
                                            INWIB2C_LEGACYID__c=id,
                                            INWIB2C_OPR_SOURCE__c=sourceOperator,
                                            INWIB2C_OPR_CIBLE__c=targetOperator,   
                                         //H-M TTM MC_SF24-006_Portabilité_Fix Begin
                                            INWIB2C_OfferType__c = offerType 
                                       //H-M TTM MC_SF24-006_Portabilité_Fix End
                                             );
          listportability.add(objporta);
          
      }  else
          {
          isOK ='0';
          errorCode ='ERR_01';
         errorMessage ='Format du Numero à porter érroné!';
         /*TraceApi DLE 11/10/2021 Begin*/
       statutAppel='KO';
 /*TraceApi DLE 11/10/2021 End*/
           } 
     
     } 
    insert listportability;
        //resp
        CSOperationResultInfo.put ('isOK',isOK);
        CSOperationResultInfo.put ('errorCode',errorCode);
        CSOperationResultInfo.put ('errorMessage',errorMessage);
        CSOperationResultInfo.put ('uuid',uuidin);
        CSPortabilityOrder.put ('id',id);
        //resplevel1.put('CSPortabilityOrder',CSPortabilityOrder);
        resplevel2.put('CSPortabilityOrder', CSPortabilityOrder);
        resplevel2.put('CSOperationResultInfo',CSOperationResultInfo);
        
             jsonstring = JSON.serialize(resplevel2);
            
        }catch(DmlException e)
        {
    				System.debug('An unexpected error has occurred: ' + e.getMessage());
				}
        res.responseBody = blob.valueOf(jsonstring);
        res.statusCode = 200;
        /*TraceApi DLE 11/10/2021 Begin*/
    trace.InwiB2C_Response__c=res.responseBody.toString();
    trace.InwiB2C_Status__c=statutAppel;
        insert trace;
   /*TraceApi DLE 11/10/2021 end*/
        
                }
}
    
/*DLE INWIB2C-PHASE2 15.05.2021 End*/