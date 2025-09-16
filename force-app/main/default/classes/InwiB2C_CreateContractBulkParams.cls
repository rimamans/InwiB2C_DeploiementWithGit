public with sharing class InwiB2C_CreateContractBulkParams {
    public class Operation {
        public string uuid  {get; set;}
       
    }
    public Operation operation {get; set;} 
    
    public class InfosContract {
        public Customer customers {get; set;}
        public Ressource ressources {get; set;}
    }
    public List<infosContract> infosContracts {get; set;}
    
    public class Customer {
        public string canal {get; set;}
        public string businessUnit  {get; set;}
        public string pos {get; set;}
        public string user {get; set;}
        public string firstName {get; set;}
        public string lastName {get; set;}
        public string gender {get; set;}
        public string birthDate {get; set;}
        public string typePi {get; set;}
        public string pi {get; set;}
        public boolean ocerised {get; set;}
        public string segmentLevel1 {get; set;}
        public string segmentLevel2 {get; set;}
        public string countryCode {get; set;}
        public string city {get; set;}
        public string state {get; set;}
        public string street {get; set;}
        public string address {get; set;}
        public string complementAddress {get; set;}
        public string postcode {get; set;}
        public string businessSegment {get; set;}
        /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
        public String accountid {get; set;}
        /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final end*/
       
       //R-SL 12/06/2025 MGEN3727 Besoin Identification MDM_TRE_V1.1 (l'ajout de champ inwib2c_animateur) start
         public string animateur {get; set;}      
        //R-SL 12/06/2025 end
                
        
        
    }
    
    public class Ressource {
        public string mdn {get; set;}
        public string mdnDealer {get; set;}
        public string icc {get; set;}
        public string profileId {get; set;}
        public string imsi {get; set;}
        public string ki {get; set;}
        public string puk {get; set;}
        public string codeArticle {get; set;}
        public string ocsId {get; set;}
        //JBEN - 17122021 - ADD CorrelationId
        public string correlationId {get; set;}
        //CHB - 14-06-2023 - ADD LigneActive & DateReelDemande
        //public Boolean LigneActive {get; set;}
        public Datetime DateReelDemande {get; set;}
        //Amine brm 21/03/2024 TTM ESIM
          public String typesim {get; set;}
          /*chb ttm d2d 28/05/2024 begin */
          public String businessreference {get; set;}
          /*chb ttm d2d 28/05/2024 end */
    }
    
    public static InwiB2C_CreateContractBulkParams parse(String json) {
        return (InwiB2C_CreateContractBulkParams) System.JSON.deserialize(json, InwiB2C_CreateContractBulkParams.class);
    }
}