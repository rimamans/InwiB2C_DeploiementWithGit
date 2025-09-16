public with sharing class inwiB2C_OrderAttachmentRules {

public static  Map<String,Object> getOrderAttachmentList (String IdOrder,String choixBilling) {
    
    Order getOrderFields = [SELECT Id,inwib2c_TypeDeLaCommande__c,inwiB2C_TypeActeDeGestion__c,inwib2c_AvecPortabilite__c   ,inwiB2C_Canal__c,inwib2c_ModeDeLivraison__c,inwiB2C_TypeDeMigration__c,InwiB2C_Type_Offer__c   FROM Order where Id=:IdOrder ];
    //CHB 29/01/24 ano B-14062_Begin
    //List<OrderItem> getOrderItemFields = [Select OrderId,Product2.Family, Product2.ProductCode, vlocity_cmt__JSONAttribute__c ,vlocity_cmt__BillingAccountId__r.InwiB2C_Mode_de_paiement__c  from OrderItem where OrderId =: IdOrder and vlocity_cmt__ParentItemId__c =:''];
    //chb 28/02/2024 B-14513 Begin */
    //List<OrderItem> getOrderItemFields = [Select OrderId,Product2.Family, vlocity_cmt__Action__c  ,Order.inwiB2C_TypeDeMigration__c,Product2.ProductCode, vlocity_cmt__JSONAttribute__c ,vlocity_cmt__BillingAccountId__r.InwiB2C_Mode_de_paiement__c  from OrderItem where OrderId =: IdOrder and vlocity_cmt__ParentItemId__c =:''];
    List<OrderItem> getOrderItemFields = [Select OrderId,Product2.Family, vlocity_cmt__Action__c  ,Order.inwiB2C_TypeDeMigration__c,Product2.ProductCode, vlocity_cmt__JSONAttribute__c ,vlocity_cmt__BillingAccountId__r.InwiB2C_Mode_de_paiement__c,Product2.vlocity_cmt__Type__c  from OrderItem where OrderId =: IdOrder and vlocity_cmt__ParentItemId__c =:''];
    //chb 28/02/2024 B-14513 End */
    //CHB 29/01/24 ano B-14062__End
    String inwiB2C_TypedeLigne;
    String Family; 
    String ProductCode;
    String Mdp;  
     //chb 28/02/2024 B-14513  */
    String typeOffre;
      //CHB 29/01/24 ano B-14062__Begin
    Boolean typeLigneSourceFar_DG=false;
    Boolean typeLigneCibleGP=false;
      //CHB 29/01/24 ano B-14062__End
    /*CHB B-14868 19/03/2024 BEGIN */
    Boolean typeLigneCiblePP=false;  
    /*CHB B-14868 19/03/2024 END */
List<String> OrderList = new List<String>{};    
    for(OrderItem getOrderItem : getOrderItemFields){
        inwiB2C_TypedeLigne  = INWIB2CJSONAttributeUtilities.getAttributeValueFromJSON(getOrderItem.vlocity_cmt__JSONAttribute__c, 'INWIB2C_ATT_RT_TYPE_LIGNE');   
        Family=getOrderItem.Product2.Family;
        ProductCode =getOrderItem.Product2.ProductCode;
        mdp=getOrderItem.vlocity_cmt__BillingAccountId__r.InwiB2C_Mode_de_paiement__c;
        //chb 28/02/2024 B-14513 Begin */
        if(getOrderItem.vlocity_cmt__Action__c!='Disconnect'){
          typeOffre = getOrderItem.Product2.vlocity_cmt__Type__c;
        }
         //chb 28/02/2024 B-14513 End */
      //CHB 29/01/24 ano B-14062__Begin
        if(getOrderItem.Order.inwiB2C_TypeDeMigration__c=='Migration Postpayé Postpayé' || getOrderItem.Order.inwiB2C_TypeDeMigration__c=='InwiB2C_MigrationPrePostpayé'){
            if(getOrderItem.vlocity_cmt__Action__c=='Add' && inwiB2C_TypedeLigne=='GP'){
                typeLigneCibleGP=true;
                /*CHB B-14868 19/03/2024 BEGIN */
            }else if(getOrderItem.vlocity_cmt__Action__c=='Add' && inwiB2C_TypedeLigne=='PP'){
                typeLigneCiblePP=true;
            }
            //else if(getOrderItem.vlocity_cmt__Action__c=='Disconnect' && (inwiB2C_TypedeLigne=='AX' || inwiB2C_TypedeLigne=='PF' || inwiB2C_TypedeLigne=='AF'  || inwiB2C_TypedeLigne=='PC' || inwiB2C_TypedeLigne=='SN')){
             if(getOrderItem.vlocity_cmt__Action__c=='Disconnect' && (inwiB2C_TypedeLigne=='AX' || inwiB2C_TypedeLigne=='PF' || inwiB2C_TypedeLigne=='AF'  || inwiB2C_TypedeLigne=='PC' || inwiB2C_TypedeLigne=='SN' || inwiB2C_TypedeLigne=='PP')){
                    typeLigneSourceFar_DG=true;
            } 
           
            if(typeLigneCiblePP && typeLigneSourceFar_DG && getOrderItem.Order.inwiB2C_TypeDeMigration__c!='InwiB2C_MigrationPrePostpayé'){
                getOrderFields.inwiB2C_Canal__c='inwiB2C_CRC';
            } 
            /*CHB B-14868 19/03/2024 end */
            //CHB 07/02/24 ANO B-14190 begin
            if(typeLigneCibleGP && typeLigneSourceFar_DG){
                getOrderFields.inwiB2C_Canal__c='Point de vente';
            }
        }    //CHB 07/02/24 ANO B-14190 end
   if((!OrderList.contains(inwiB2C_TypedeLigne) && getOrderItem.Order.inwiB2C_TypeDeMigration__c!='Migration Postpayé Postpayé' )||(!OrderList.contains(inwiB2C_TypedeLigne) && getOrderItem.Order.inwiB2C_TypeDeMigration__c=='Migration Postpayé Postpayé' && getOrderItem.vlocity_cmt__Action__c!='Disconnect')){        
    //CHB 29/01/24 ano B-14062__End       
            OrderList.add(inwiB2C_TypedeLigne);
        
            System.debug('new list2'+OrderList); 
        }
           OrderList.add(Family);
           OrderList.add(ProductCode);
           OrderList.add(mdp);
    } 
System.debug('liste finale = '+OrderList);


       List <inwiB2C_DocumentRule__c> documentList= [SELECT ID, Name , inwiB2C_Document__r.inwB2C_DocumentId__c,inwiB2C_Document__r.Name,  inwiB2C_Mandatory__c,InwiB2C_Ordre__c FROM inwiB2C_DocumentRule__c 
                                                  WHERE ((inwiB2C_TypeCommande__c =:getOrderFields.inwib2c_TypeDeLaCommande__c or inwiB2C_TypeCommande__c =:'All')
                                                  and  (inwiB2C_TypeActeDeGestion__c=: getOrderFields.inwiB2C_TypeActeDeGestion__c or inwiB2C_TypeActeDeGestion__c=:'All')
                                                  and (inwiB2C_ProductFamily__c in :OrderList or inwiB2C_ProductFamily__c=:'All')
                                                  and (inwiB2C_TypedeLigne__c in :OrderList or inwiB2C_TypedeLigne__c=:'All') 
                                                  and (Mode_de_livraison__c =:getOrderFields.inwib2c_ModeDeLivraison__c or Mode_de_livraison__c =:'All')
                                                  and inwiB2C_Portabilit__c=: getOrderFields.inwib2c_AvecPortabilite__c
                                                  and (inwiB2C_MethodeDelPaiement__c in :OrderList or inwiB2C_MethodeDelPaiement__c=:'All')
                                                  and (Type_de_migration__c =:getOrderFields.inwiB2C_TypeDeMigration__c or Type_de_migration__c =:'All' )       
                                                  and (InwiB2C_synchBscs__c	=:choixBilling or InwiB2C_synchBscs__c=null )
                                                  and (inwiB2C_CodeProduit__c in :OrderList or inwiB2C_CodeProduit__c = null)
                                                  and (InwiB2C_Type_Offer__c =: typeOffre or InwiB2C_Type_Offer__c=null )
                                                  and (inwiB2C_Canal__c=:getOrderFields.inwiB2C_Canal__c or inwiB2C_Canal__c=:'All')) order by InwiB2C_Ordre__c asc ];
    System.debug(documentList);

    Map<String,Object> response = new Map<String,Object>();

    List<Object> DocumentListResponse = new List<Object>();

    for (inwiB2C_DocumentRule__c document: documentList){

        Map<String, Object> documentItem= new Map<String, Object>();
        documentItem.put('docTypeId', document.inwiB2C_Document__r.inwB2C_DocumentId__c);
        documentItem.put('docTypeLabel', document.inwiB2C_Document__r.Name);
        documentItem.put('mandatory', document.inwiB2C_Mandatory__c);

        DocumentListResponse.add(documentItem);

    }

    response.put('DocumentList', DocumentListResponse);

    System.debug(response.toString());

    return response;  
}
}