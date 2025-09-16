@isTest
public with sharing class InwiB2C_ManageConfPromotionLWCTest{
    @isTest
    public static void InwiB2C_ManageConfPromotionLWCTest(){
        test.startTest();

        // Promotion
        String strDt = '25/1/2022';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateDebut = Date.parse(strDt);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime dt = DateTime.newInstance(dateDebut.year(), dateDebut.month(), dateDebut.day(), 0, 0, 0);

        String strDF = '25/1/2024';
        //convert String to Date(output:2018-01-25 00:00:00)
        Date dateFin = Date.parse(strDF);
        //convert date to DateTime.Can be used in soql but not in dynamic soql(output:2018-01-25 05:00:00)
        DateTime df = DateTime.newInstance(dateFin.year(), dateFin.month(), dateFin.day(), 0, 0, 0);

        InwiB2C_Promotion__c promo = new InwiB2C_Promotion__c(inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_code_promotion__c = 'code', InwiB2C_date_Debut__c = dt, inwiB2C_date_fin__c = df, Name = 'promotion name', inwiB2C_Libelle_promotion__c = 'Promo test');
        insert promo;

        // Scope Determinant
        inwiB2C_scop_determinant__c scope1 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'included');
        insert scope1;

        inwiB2C_scop_determinant__c scope2 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'Cochable');
        insert scope2;

        inwiB2C_scop_determinant__c scope3 = new inwiB2C_scop_determinant__c(inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_Canal__c = 'Point de vente', InwiB2C_type_acte_de_gestion__c = 'inwiB2C_Acquisition', InwiB2C_Type_d_inclution__c = 'Cochable');
        insert scope3;

        // Determinant
        inwiB2C_determinant__c determinant1 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_field__c = 'Name');
        insert determinant1;

        inwiB2C_determinant__c determinant2 = new inwiB2C_determinant__c(inwiB2C_value__c = 'inwiB2C_EnCours', inwiB2C_scope__c = 'inwiB2C_Order', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_field__c = 'inwiB2C_Statut__c');
        insert determinant2;

        inwiB2C_determinant__c determinant3 = new inwiB2C_determinant__c(inwiB2C_scope__c = 'inwiB2C_Assets', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_Code_Produit__c = 'offer1');
        insert determinant3;

        inwiB2C_determinant__c determinant4 = new inwiB2C_determinant__c(inwiB2C_code_attribute__c = 'INWIB2C_ATT_RT_ENGAGEMENT', inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_value__c = 'cin', inwiB2C_scope__c = 'inwiB2C_Order_item', inwiB2C_scope_determinant__c = scope1.Id, inwiB2C_Valeur_attribut__c = '0Month');
        insert determinant4;

        inwiB2C_determinant__c determinant5 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope2.Id, inwiB2C_field__c = 'Name');
        insert determinant5;

        inwiB2C_determinant__c determinant6 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromo', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope2.Id, inwiB2C_field__c = 'Name');
        insert determinant6;

        inwiB2C_determinant__c determinant7 = new inwiB2C_determinant__c(inwiB2C_value__c = 'TestPromotion', inwiB2C_scope__c = 'inwiB2C_Infos_client', inwiB2C_scope_determinant__c = scope3.Id, inwiB2C_field__c = 'Name');
        insert determinant7;

        // Applied Product
        inwiB2C_Applied_Product__c appliedProduct = new inwiB2C_Applied_Product__c(inwiB2C_Code_Produit__c = 'INWIB2C_LAPTOP', inwiB2C_Libelle_du_produit__c = 'libelle', inwiB2C_Promotion_discount__c = promo.Id);
        insert appliedProduct;

        // Promotion result
        inwiB2C_promotion_result__c promotionResult1 = new inwiB2C_promotion_result__c(inwiB2C_valeur_attribut__c = '50', inwiB2C_Result_type__c = 'inwiB2C_Action', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_code_attribute__c = 'INWIB2C_ATT_RT_REMISE_POURCENT');
        insert promotionResult1;

        inwiB2C_promotion_result__c promotionResult2 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'FMS');
        insert promotionResult2;

        inwiB2C_promotion_result__c promotionResult3 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'FMD');
        insert promotionResult3;

        inwiB2C_promotion_result__c promotionResult4 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'One time');
        insert promotionResult4;

        inwiB2C_promotion_result__c promotionResult5 = new inwiB2C_promotion_result__c(inwiB2C_percent__c = 20, inwiB2C_Result_type__c = 'inwiB2C_Discount', inwiB2C_Promotion_discount__c = promo.Id, inwiB2C_type_de_prix__c = 'recurring price');
        insert promotionResult5;

        InwiB2C_ManageConfPromotionLWC.get_scop_determinant((String) promo.Id);
        InwiB2C_ManageConfPromotionLWC.get_promotion_result((String) promo.Id);
        InwiB2C_ManageConfPromotionLWC.get_applied_product((String) promo.Id);
        InwiB2C_ManageConfPromotionLWC.get_determinant((String) scope1.Id);

        test.stopTest();
    }

}