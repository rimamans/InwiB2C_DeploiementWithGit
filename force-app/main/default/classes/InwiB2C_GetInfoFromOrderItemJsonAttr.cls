/**
 * @description       : Classe pour récupérer les informations des attributs JSON des OrderItem liés à un Order.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-21-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InwiB2C_GetInfoFromOrderItemJsonAttr {

   
    @InvocableMethod(label='Get code article from OrderItem')
    public static List<String> getInfoByOrderId(List<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            throw new IllegalArgumentException('OrderId list cannot be null or empty.');
        }

       
        List<String> allCodeArticles = new List<String>();

        for (Id orderId : orderIds) {
            allCodeArticles.addAll(getCodeArticleFromAttribute(orderId));
        }

        return allCodeArticles;
    }

    private static List<String> getCodeArticleFromAttribute(Id orderId) {
        List<OrderItem> orderItemList = [
            SELECT Id, Product2.ProductCode, Product2.Name, vlocity_cmt__JSONAttribute__c
            FROM OrderItem
            WHERE OrderId = :orderId AND Product2.Name = 'Terminal'
        ];

        List<String> codeArticles = new List<String>();

        for (OrderItem orderItem : orderItemList) {
            String productAttribute = 'INWIB2C_ATT_RT_MODELE';

         
            String codeArticle = INWIB2C_INWIJSONAttributeUtilities.getAttributeValueFromJSON(orderItem.vlocity_cmt__JSONAttribute__c,productAttribute);

            if (codeArticle != null) {
                codeArticles.add(codeArticle);
            }
        }

        return codeArticles;
    }
}