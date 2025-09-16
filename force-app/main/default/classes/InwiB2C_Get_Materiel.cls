/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
    global with sharing class InwiB2C_Get_Materiel implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

            Boolean result = true;

            try{

                if (methodName.equals('get_Materiel_retour')){
                    get_Materiel_retour(inputMap, outMap, options);

                    // your implementation, use outMap to send response back to OmniScript

                } 

            } catch (Exception e){

                result = false;

            }

            return result;
        }


        public static void get_Materiel_retour(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

            String NumeroLigne = (String) inputMap.get('NumeroLigne');
            String Agence = (String) inputMap.get('Agence');
            String NumeroSerie=(String) inputMap.get('NumeroSerie'); 
            String Cons=(String) inputMap.get('Cons');
            String StatRouteur=(String) inputMap.get('StatRouteur');
            String consign='';
            String Status='';
            String AgenceVente= (String) inputMap.get('AgenceVente');
            String Codearticle= (String) inputMap.get('Codearticle');
            Boolean profil= (Boolean) inputMap.get('profil');
            String query2;
             if(profil == true) { 
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Agence__c=:Agence';
           }
        //    else  {
        //     query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
        //    }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie == null || NumeroSerie == '') && (Codearticle  == null || Codearticle  == '')&& (AgenceVente == null || AgenceVente == '') && (StatRouteur  == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroSerie != null && NumeroSerie != '')&&(NumeroLigne == null ||  NumeroLigne == '') && (Codearticle  == null ||  Codearticle  == '')&& (AgenceVente == null || AgenceVente == '')&& (StatRouteur == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(AgenceVente != null && AgenceVente != '')&&(NumeroLigne  == null ||  NumeroLigne  == '') && (NumeroSerie == null ||  NumeroSerie == '') && (Codearticle  == null ||  Codearticle  == '')&& ( StatRouteur  == 'Tous')&& ( Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Agence_Init__c=: AgenceVente ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(Codearticle != null && Codearticle != '')&&(AgenceVente == null ||  AgenceVente == '')&&(NumeroLigne  == null ||  NumeroLigne  == '' )&& (NumeroSerie == null ||  NumeroSerie == '')&& ( StatRouteur  == 'Tous')&& (  Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Article__c=: Codearticle ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&( StatRouteur!= null && StatRouteur != ''&& StatRouteur != 'Tous')&& (NumeroSerie == null ||  NumeroSerie == '')&& (NumeroLigne == null ||  NumeroLigne == '')&& (Codearticle == null ||  Codearticle == '')&& (AgenceVente == null ||  AgenceVente == '')&& ( Cons == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Statut_de_retour__c=: StatRouteur ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&( Cons != null && Cons != '' && Cons != 'Tous')&& (NumeroSerie == null || NumeroSerie == '')&& (NumeroLigne == null || NumeroLigne == '')&& (Codearticle == null || Codearticle == '')&& (AgenceVente == null || AgenceVente == '')&&( StatRouteur == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Consign__c=: Cons ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }

           else if((profil == false)&&(  StatRouteur == 'Tous')&&(Cons == 'Tous')  && (NumeroSerie == null ||NumeroSerie == '')&& (NumeroLigne == null ||  NumeroLigne == '') && (Codearticle  == null ||  Codearticle  == '')&& (AgenceVente == null || AgenceVente == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c Limit 100 ';//OR InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie OR InwiB2C_Code_Article__c=: Codearticle OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
          
           //Combinaison 2a2:
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(NumeroSerie != null && NumeroSerie != '')&&(Codearticle == null || Codearticle == '')&&( StatRouteur == 'Tous')&&(  Cons == 'Tous')&&(AgenceVente == null || AgenceVente == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie';
           }
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(AgenceVente != null &&  AgenceVente != '')&& (NumeroSerie  == null || NumeroSerie  == '')&&(Codearticle == null || Codearticle == '')&&( StatRouteur == 'Tous')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=: AgenceVente';
           }
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(Codearticle != null && Codearticle != '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroSerie  == null || NumeroSerie  == '')&&( StatRouteur == 'Tous')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Article__c=: Codearticle';
           }
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Codearticle == null || Codearticle == '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroSerie  == null || NumeroSerie  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(Codearticle == null || Codearticle == '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroSerie  == null || NumeroSerie  == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Consign__c=: Cons';
           }

           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(AgenceVente != null &&  AgenceVente != '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(Codearticle == null || Codearticle == '')&&( StatRouteur == 'Tous')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=: AgenceVente';
           }
           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(Codearticle != null && Codearticle != '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&( StatRouteur == 'Tous')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle';
           }
           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Codearticle == null || Codearticle == '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(Codearticle == null || Codearticle == '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where  InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((Codearticle != null && Codearticle != '')&&(AgenceVente != null &&  AgenceVente != '')&&(NumeroSerie == null || NumeroSerie == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&( StatRouteur == 'Tous')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Code_Agence_Init__c=: AgenceVente';
           }
           else if((profil == false)&&((Codearticle != null && Codearticle != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(NumeroSerie == null || NumeroSerie == '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&&((Codearticle != null && Codearticle != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(NumeroSerie == null || NumeroSerie == '')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where  InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((AgenceVente != null &&  AgenceVente != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(NumeroSerie == null || NumeroSerie == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(  Cons == 'Tous')&&(Codearticle == null || Codearticle == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Agence_Init__c=: AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&&((AgenceVente != null &&  AgenceVente != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(NumeroSerie == null || NumeroSerie == '')&&(Codearticle == null || Codearticle == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where  InwiB2C_Code_Agence_Init__c=: AgenceVente AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&& (Cons != null && Cons != ''  && Cons != 'Tous')&&(NumeroSerie == null || NumeroSerie == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(AgenceVente == null || AgenceVente == '')&&(Codearticle == null || Codearticle == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=: Cons ';
           }

           //Combinaison 3a3:

          else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '') && (Codearticle  != null && Codearticle  != '')&& (AgenceVente == null || AgenceVente == '') && (StatRouteur  == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '') && (AgenceVente != null && AgenceVente != '') && (Codearticle  == null ||Codearticle  == '') && (StatRouteur  == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (AgenceVente == null || AgenceVente == '') && (Codearticle  == null ||Codearticle  == '')  && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Statut_de_retour__c=:StatRouteur';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '') && (Cons  != null && Cons  != '' && Cons  != 'Tous')&& (AgenceVente == null || AgenceVente == '') && (Codearticle  == null ||Codearticle  == '')  && ( StatRouteur  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '') && (AgenceVente != null && AgenceVente != '') && (Codearticle  != null &&Codearticle  != '') && (NumeroSerie == null && NumeroSerie == '')&& (StatRouteur  == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne  AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           } 
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(AgenceVente != null || AgenceVente != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Codearticle == null || Codearticle == '')&& (NumeroSerie  == null || NumeroSerie  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&& ((NumeroLigne  != null && NumeroLigne  != '')&&(AgenceVente != null &&  AgenceVente != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(NumeroSerie == null || NumeroSerie == '')&&(Codearticle == null || Codearticle == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=: AgenceVente AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(Codearticle != null  &&  Codearticle != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(AgenceVente == null || AgenceVente == '')&& (NumeroSerie  == null || NumeroSerie  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&& ((NumeroLigne  != null && NumeroLigne  != '')&&(Codearticle != null  &&  Codearticle != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(AgenceVente == null ||  AgenceVente == '')&&(NumeroSerie == null || NumeroSerie == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((NumeroLigne != null && NumeroLigne != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(AgenceVente == null || AgenceVente == '')&& (NumeroSerie  == null || NumeroSerie  == '')&&(Codearticle == null || Codearticle == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&(NumeroSerie != null && NumeroSerie != '') && (AgenceVente != null && AgenceVente != '') && (Codearticle  != null &&Codearticle  != '') && (NumeroLigne == null && NumeroLigne == '')&& (StatRouteur  == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie  AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           } 
           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(AgenceVente != null && AgenceVente != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Codearticle == null || Codearticle == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&& ((NumeroSerie  != null && NumeroSerie  != '')&&(AgenceVente != null &&  AgenceVente != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(NumeroLigne == null || NumeroLigne == '')&&(Codearticle == null || Codearticle == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=: AgenceVente AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(Codearticle != null  &&  Codearticle != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&& ((NumeroSerie  != null && NumeroSerie  != '')&&(Codearticle != null  &&  Codearticle != '')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(AgenceVente == null ||  AgenceVente == '')&&(NumeroLigne == null || NumeroLigne == '')&&( StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((NumeroSerie != null && NumeroSerie != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Cons != null && Cons != ''  && Cons != 'Tous')&&(AgenceVente == null || AgenceVente == '')&& (NumeroLigne  == null || NumeroLigne  == '')&&(Codearticle == null || Codearticle == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((AgenceVente != null && AgenceVente != '')&&(Codearticle != null  &&  Codearticle != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&& (NumeroLigne  == null || NumeroLigne  == '')&&(NumeroSerie == null || NumeroSerie == '')&&(  Cons == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';
           }
           else if((profil == false)&&((AgenceVente != null && AgenceVente != '')&&(Codearticle != null  &&  Codearticle != '')&&(Cons != null && Cons != ''&& Cons != 'Tous')&& (NumeroLigne  == null || NumeroLigne  == '')&&(NumeroSerie == null || NumeroSerie == '')&&(StatRouteur == 'Tous'))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((AgenceVente != null && AgenceVente != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Cons != null && Cons != ''&& Cons != 'Tous')&& (NumeroLigne  == null || NumeroLigne  == '')&&(NumeroSerie == null || NumeroSerie == '')&&(Codearticle  == null ||  Codearticle  == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=: Cons';
           }
           else if((profil == false)&&((Codearticle != null  &&  Codearticle != '')&&(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous')&&(Cons != null && Cons != ''&& Cons != 'Tous')&& (NumeroLigne  == null || NumeroLigne  == '')&&(NumeroSerie == null || NumeroSerie == '')&&(AgenceVente == null || AgenceVente == ''))) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=: Cons';
           }


           //Combinaison 4a4:

            else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '') && (AgenceVente != null && AgenceVente != '') && (Codearticle  != null && Codearticle  != '') && (StatRouteur  == 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
            else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (AgenceVente != null &&  AgenceVente != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous') && (Codearticle  == null ||Codearticle  == '')  && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (AgenceVente != null &&  AgenceVente != '')  && (Cons  != null && Cons  != '' && Cons  != 'Tous')&& (Codearticle  == null || Codearticle  == '')  && ( StatRouteur  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }

           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous') && (AgenceVente == null ||  AgenceVente == '')  && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (Codearticle  != null && Codearticle  != '') && (Cons  != null && Cons  != '' && Cons  != 'Tous')&& (AgenceVente == null ||  AgenceVente == '') && ( StatRouteur  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') && (AgenceVente == null ||  AgenceVente == '') && (Codearticle  == null ||Codearticle  == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (AgenceVente != null &&  AgenceVente != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous') &&  (NumeroSerie == null ||  NumeroSerie == '')  && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=:AgenceVente  AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (AgenceVente != null &&  AgenceVente != '')&& (Codearticle  != null && Codearticle  != '')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') &&  (NumeroSerie == null ||  NumeroSerie == '')  && (StatRouteur  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=:AgenceVente  AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (AgenceVente != null &&  AgenceVente != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') &&  (NumeroSerie == null ||  NumeroSerie == '')  && (Codearticle  == null ||  Codearticle  == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=:AgenceVente  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') &&  (NumeroSerie == null ||  NumeroSerie == '') && (AgenceVente == null &&  AgenceVente == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }

           else if((profil == false)&& (NumeroSerie != null && NumeroSerie != '')&&(AgenceVente != null && AgenceVente != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous') &&  (NumeroLigne == null ||  NumeroLigne == '')&& (Cons  == 'Tous') ) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur ';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&& (NumeroSerie != null && NumeroSerie != '')&&(AgenceVente != null && AgenceVente != '')&& (Codearticle  != null && Codearticle  != '') && (Cons  != null && Cons  != '' && Cons  != 'Tous')  &&  (NumeroLigne == null ||  NumeroLigne == '')&& (StatRouteur  == 'Tous') ) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle   AND InwiB2C_Consign__c=:Cons ';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }

           else if((profil == false)&&(NumeroSerie != null && NumeroSerie != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') &&  (NumeroLigne == null ||  NumeroLigne == '') && (AgenceVente == null &&  AgenceVente == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where  InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(AgenceVente != null && AgenceVente != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') &&  (NumeroLigne == null ||  NumeroLigne == '') && (NumeroSerie == null ||  NumeroSerie == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }

           
           //Combinaisons 5a5:
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (AgenceVente != null && AgenceVente != '') && (Codearticle  != null && Codearticle  != '')  && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous') && (Cons  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Statut_de_retour__c=:StatRouteur';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (AgenceVente != null && AgenceVente != '') && (Codearticle  != null && Codearticle  != '') && (Cons  != null && Cons  != '' && Cons  != 'Tous') && (StatRouteur  == 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&&(AgenceVente != null && AgenceVente != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') && (NumeroSerie == null ||  NumeroSerie == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroSerie != null && NumeroSerie != '')&&(AgenceVente != null && AgenceVente != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') && (NumeroLigne == null ||  NumeroLigne == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroSerie != null && NumeroSerie != '')&&(NumeroLigne != null && NumeroLigne != '')&& (Codearticle  != null && Codearticle  != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous') && (AgenceVente == null && AgenceVente == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (AgenceVente != null && AgenceVente != '')  && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous')&& (Codearticle  == null && Codearticle  == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
           else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (Codearticle  != null && Codearticle  != '')  && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous')&& (AgenceVente == null && AgenceVente == '')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle  AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }

           //Combinaison de tous les champs:

            else if((profil == false)&&(NumeroLigne != null && NumeroLigne != '')&& (NumeroSerie != null && NumeroSerie != '')&& (Codearticle  != null && Codearticle  != '') &&(AgenceVente != null && AgenceVente != '') && (StatRouteur  != null && StatRouteur  != '' && StatRouteur  != 'Tous')&& (Cons  != null && Cons  != '' && Cons  != 'Tous')) {
            query2 = 'SELECT Id,inwib2c_num_ro_de_la_ligne__c,InwiB2C_Code_Agence__c,InwiB2C_Agence__c,InwiB2C_Modele__c,InwiB2C_Code_Article__c,InwiB2C_Num_ro_de_s_rie__c,InwiB2C_Consign__c,InwiB2C_Code_Agence_Init__c,InwiB2C_Statut_de_retour__c  FROM InwiB2C_Gestion_mat_riel__c where inwib2c_num_ro_de_la_ligne__c=: NumeroLigne AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie AND InwiB2C_Code_Article__c=: Codearticle AND InwiB2C_Code_Agence_Init__c=:AgenceVente AND InwiB2C_Statut_de_retour__c=:StatRouteur AND InwiB2C_Consign__c=:Cons';// OR InwiB2C_Statut_de_retour__c=: StatRouteur OR InwiB2C_Consign__c=: Cons ';
           }
        
           //System.debug(AgenceVente); 
           //System.debug(NumeroLigne); 
            System.debug(query2); 

           
            if(profil == true) { 
            if(NumeroLigne != null && NumeroLigne != '') {
       
             query2 =+ query2 + ' AND inwib2c_num_ro_de_la_ligne__c=: NumeroLigne';        
            }
            if(Cons != null && Cons != '' && Cons != 'Tous') {
         
             query2 =+ query2 + ' AND InwiB2C_Consign__c=: Cons';

             }

            if(StatRouteur != null && StatRouteur != ''&& StatRouteur != 'Tous') {
              query2 =+ query2 + ' AND InwiB2C_Statut_de_retour__c=: StatRouteur';

              
            }
            if(NumeroSerie != null && NumeroSerie != '') {
           
             query2 =+ query2 + ' AND InwiB2C_Num_ro_de_s_rie__c=: NumeroSerie';

            }
            if(Codearticle != null && Codearticle != '') {
       
                query2 =+ query2 + ' AND InwiB2C_Code_Article__c=: Codearticle';        
               }    
               
            } 
             List<InwiB2C_Gestion_mat_riel__c>  materielinfo2= Database.query(query2);

          
                outMap.put('materielinfo2',materielinfo2);
        }
        
    }