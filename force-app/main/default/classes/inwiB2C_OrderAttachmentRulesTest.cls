@isTest
public class inwiB2C_OrderAttachmentRulesTest {
@isTest(SeeAllData=true)
    static void OrderAttachmentRulesTest(){
       Test.startTest();
       List <inwiB2C_DocumentRule__c> documentList= [SELECT ID, Name , inwiB2C_Document__r.inwB2C_DocumentId__c,inwiB2C_Document__r.Name,  inwiB2C_Mandatory__c FROM inwiB2C_DocumentRule__c 
                                                  WHERE ((inwiB2C_TypeCommande__c =:'inwiB2C_Acquisition' or inwiB2C_TypeCommande__c =:'All')
                                                  and  (inwiB2C_TypeActeDeGestion__c=:''  or inwiB2C_TypeActeDeGestion__c=:'All')
                                                  and (inwiB2C_ProductFamily__c =:'Mobile' or inwiB2C_ProductFamily__c=:'All')
                                                  and (inwiB2C_TypedeLigne__c =:'GP' or inwiB2C_TypedeLigne__c=:'All') 
                                                  and ( Mode_de_livraison__c =:'All')
                                                  and inwiB2C_Portabilit__c=: False
                                                  and (inwiB2C_MethodeDelPaiement__c=: 'Prélèvement automatique (RIB)' or	 inwiB2C_MethodeDelPaiement__c=:'All')
                                                  and ( inwiB2C_CodeProduit__c = null)
                                                  and (inwiB2C_Canal__c=:'Point de vente' or inwiB2C_Canal__c=:'All')) order by inwiB2C_Document__r.Name desc ];
        Test.stopTest();
        
        
    }
}