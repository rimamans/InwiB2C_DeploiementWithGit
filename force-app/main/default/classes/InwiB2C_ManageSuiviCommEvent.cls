/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class InwiB2C_ManageSuiviCommEvent implements vlocity_cmt.VlocityOpenInterface2{
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
         Boolean result = true;    
        try{
            if(methodName.equals('createEvent'))
                createEvent(input, output, options);      
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result;            
   }
    @InvocableMethod
    public static void createEventFromFlow(List<String> inputs){
        for(String input : inputs ){
        List<String> splitList = input.split(',');
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> optionsMap = new Map<String,Object>();
        inputMap.put('parentStep',splitList[1]);
        inputMap.put('step',splitList[0]);
        inputMap.put('orderId',splitList[2]);
        createEvent(inputMap,outputMap,optionsMap);
            
        }
        
    }
    public static void createEvent(Map<String, Object> input,Map<String,Object> output, Map<String,Object> options){
        String orderId='';
        String externalOrderId=null;
        String step='';
        String parentStep='';
        String subId=null;
        /* ACYL 28/01/2025 Start */
        Date Daterestitution;
        Boolean isrestitution = (Boolean) input.get('isrestitution');
        if (isrestitution == null) {
        isrestitution = false;}
        /* ACYL 28/01/2025 end */

        if(!input.containsKey('orderId') || !input.containsKey('step'))
            output.put('Error','OrderId ou step manquant');
        else{
            
            //get inputs
            orderId=input.get('orderId').toString();
            step=input.get('step').toString();
            if(input.containsKey('externalOrderId') && input.get('externalOrderId') != '')
               externalOrderId=input.get('externalOrderId').toString();
            if(input.containsKey('parentStep'))
               parentStep=input.get('parentStep').toString();
            
            //get order
            Order commande = [select id,inwiB2C_Animateur_D2D__c,inwiB2C_Animateur_D2D__r.Email,inwiB2C_Canal__c,CreatedBy.Email,vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c,vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_Adresse_Facture_IAM__c from Order where Id=:orderId ];
            String cdcEmail='';
            String crcEmail='';
            if(commande.inwiB2C_Canal__c=='Point de vente')
                cdcEmail=commande.CreatedBy.Email;
            else
                crcEmail=commande.CreatedBy.Email;
            
            //get sub 
             List<inwiB2C_OrderSubscription__c> sub =[select id ,inwiB2C_Order__r.inwiB2C_TypeActeDeGestion__c, inwiB2C_Order__r.vlocity_cmt__SubmittedToOmDate__c , inwiB2C_Subscription__c from inwiB2C_OrderSubscription__c where inwiB2C_Order__c =:orderId order by createdDate Desc LIMIT 1];
             if(!sub.isEmpty()){
                subId=sub[0].inwiB2C_Subscription__c;
            }
            /* ACYL 28/01/2025 Start */
            if (!sub.isEmpty() && sub[0].inwiB2C_Order__r != null && sub[0].inwiB2C_Order__r.vlocity_cmt__SubmittedToOmDate__c != null && isrestitution != true ) {
            Daterestitution = sub[0].inwiB2C_Order__r.vlocity_cmt__SubmittedToOmDate__c.date().addDays(120);
            }
            /* ACYL 28/01/2025 end */

            //get typeOffer and statut ligne and nd
            String nd='';
            String typeOffer ='ADSL_B2C';
            Boolean isExistingNd=false;
            OrderItem orderItem=[select id,vlocity_cmt__JSONAttribute__c,vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c,Order.inwiB2C_TypeActeDeGestion__c,Order.inwiB2C_TypeDeMigration__c from OrderItem where orderId=:orderId and vlocity_cmt__ParentItemId__c=null];
            if(orderItem.vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c =='FTTH') {
                typeOffer='FTTH_B2C';
                OrderItem numTel = [select id,vlocity_cmt__JSONAttribute__c from OrderItem where vlocity_cmt__ParentItemId__c =:orderItem.Id and vlocity_cmt__Product2Id__r.ProductCode ='INWIB2C_FOB2C_OFFERING_MSISDN_STANDARD'];
                if(INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_CHOIX_NUMERO')=='personaliser')
             		nd=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MSISDN');
                else
                    nd=INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(numTel.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_MSISDN_PORTED');
             } else if (orderItem.Order.inwiB2C_TypeActeDeGestion__c =='inwiB2C_ChangementDeNumeroPortaDegital'||orderItem.Order.inwiB2C_TypeDeMigration__c  =='InwiB2C_MigrationPrePostpayéPorta'||orderItem.Order.inwiB2C_TypeDeMigration__c =='InwiB2C_MigrationPreCameleonPorta') {
                typeOffer='MOBILE_PORTA';
            }else {
                nd=commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_numero_de_designation__c;
                String statutLigneIam = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(orderItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_DSLSRCSTAT');
                if(statutLigneIam=='LA') {
                    isExistingNd=true;
                } else {
                    isExistingNd=false;  
                }
            }
            
            
            //get rendezVous
            date dateInstalattion=null;
            String slot='';
            List<inwiB2C_Rendez_Vous__c> rendezVous=[select id,inwiB2C_Date_RDV__c,inwiB2C_Slot_RDV__c from  inwiB2C_Rendez_Vous__c where inwiB2C_Order__c=:orderId limit 1];
            if(!rendezVous.isEmpty()){
                dateInstalattion=rendezVous[0].inwiB2C_Date_RDV__c;
                if(rendezVous[0].inwiB2C_Slot_RDV__c=='Matin (09h à 14h)')
                    slot='AM';
                else
                    slot='PM';
            } 
            
            //get panierId
            if(externalOrderId != null){
               List<inwib2c_TraceDemandeEshop__c> demandesEshop=[select id from inwib2c_TraceDemandeEshop__c where inwib2c_OrderId__c=:orderId limit 1];
                if(!demandesEshop.isEmpty())
                    externalOrderId=demandesEshop[0].Id;
            }
                
            
            //create Event
            InwiB2C_Suivi_commande_fixe__c evenement = new InwiB2C_Suivi_commande_fixe__c(
                InwiB2C_orderId__c=orderId,
                InwiB2C_orderExternalId__c=externalOrderId,
                InwiB2C_topINS__c=subId,
                InwiB2C_nd__c=nd,
                InwiB2C_offerCode__c=typeOffer,
                InwiB2C_cdcEmail__c=cdcEmail,
                InwiB2C_crcEmail__c=crcEmail,
                InwiB2C_d2dEmail__c=commande.inwiB2C_Animateur_D2D__r.Email,
                InwiB2C_D2DSeller__c=commande.inwiB2C_Animateur_D2D__c,
                InwiB2C_customerAddressL1__c=commande.vlocity_cmt__DefaultServiceAccountId__r.inwiB2C_Adresse_Facture_IAM__c,
                InwiB2C_isExistingND__c=isExistingNd,
                InwiB2C_installationDate__c=dateInstalattion,
                InwiB2C_timeSlot__c=slot,
                InwiB2C_step__c=step,
                InwiB2C_parent_step__c=parentStep,
                /* ACYL 28/01/2025 Start */               InwiB2C_returnDeadline__c =Daterestitution
                /* ACYL 28/01/2025 end */

                
            );
            insert evenement;
            output.put('SuiviCommandeEventId',evenement.Id);
            
        }
        
    }

}