/*ZME INWIB2C-PHASE2-Lot 1.2 12.04.2021 BEGIN*/
public with sharing class InwiB2C_CreateContractParams {
    public class Operation {
        public string canal {get; set;}
        public string businessUnit  {get; set;}
        public string pos {get; set;}
        public string user {get; set;}
        public string uuid  {get; set;}
    }
    public List<Operation> Operation {get; set;}

    public class InfosContract {
        public List<customer> customers {get; set;}
        public List<ressource> ressources {get; set;}
    }
    public List<infosContract> infosContracts {get; set;}

    public class Customer {
        public string idClient {get; set;}
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
        public string region {get; set;}
        public string city {get; set;}
        public string state {get; set;}
        public string street {get; set;}
        public string address {get; set;}
        public string complementAddress {get; set;}
        public string postcode {get; set;}
        public string businessSegment {get; set;}
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
    }

    public static InwiB2C_CreateContractParams parse(String json) {
        return (InwiB2C_CreateContractParams) System.JSON.deserialize(json, InwiB2C_CreateContractParams.class);
    }
}
/*ZME PHASE2 Lot1.2 12.04.2021 END*/