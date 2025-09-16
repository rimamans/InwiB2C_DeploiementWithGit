/*ZME INWIB2C-PHASE2-Lot 1.2 29.07.2021 BEGIN*/
public with sharing class inwiB2C_CreateContractFirstCallParams {
    
    public class Operation {
        public string canal {get; set;}
        public string user {get; set;}
        public string uuid  {get; set;}
    }
    public operation Operation {get; set;}
    
    public class Ressource {
        public string businessUnit  {get; set;}
        public string pos {get; set;}
        public string mdn {get; set;}
        public string mdnDealer {get; set;}
        public string icc {get; set;}
        public string profileId {get; set;}
        public string imsi {get; set;}
        public string ki {get; set;}
        public string puk {get; set;}
        public string codeArticle {get; set;}
        public string ocsId {get; set;}
        public string correlationId {get; set;}
        //CHB - 14-06-2023 - ADD LigneActive & DateReelDemande
        //public Boolean LigneActive {get; set;}
        public Datetime DateReelDemande {get; set;}
        //Amine brm 21/03/2024 TTM ESIM
        public String typesim {get; set;}
        /*chb ttm d2d 28/05/2024 begin */
        public String businessreference {get; set;}
        /*chb ttm d2d 28/05/2024 end */
         /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
        public String accountid{get; set;}
         /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
    }
    public List<Ressource> ressources {get; set;}
    
    public static inwiB2C_CreateContractFirstCallParams parse(String json) {
        return (inwiB2C_CreateContractFirstCallParams) System.JSON.deserialize(json, inwiB2C_CreateContractFirstCallParams.class);
    }
}
/*ZME PHASE2 Lot1.2 27.07.2021 END*/