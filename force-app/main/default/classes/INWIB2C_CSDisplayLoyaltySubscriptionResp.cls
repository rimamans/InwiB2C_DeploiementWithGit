global with sharing class INWIB2C_CSDisplayLoyaltySubscriptionResp {
	@AuraEnabled
    public CSOperationResultInfo CSOperationResultInfo;
    @AuraEnabled
    public list<CSDisplayLoyaltySubscriptionInteraction> CSDisplayLoyaltySubscriptionInteraction;
    
    public class CSDisplayLoyaltySubscriptionInteraction{ 
        @AuraEnabled
        public String id;
        @AuraEnabled
        public CSLoyaltyAcount CSLoyaltyAcount;
        @AuraEnabled
        public String actionStatus;
        @AuraEnabled
        public String errorCode;
        @AuraEnabled
        public String errorDesc;
        
        public CSDisplayLoyaltySubscriptionInteraction(String id, CSLoyaltyAcount CSLoyaltyAcount, String actionStatus, String errorCode, String errorDesc){
            this.id= id;
            this.CSLoyaltyAcount = CSLoyaltyAcount;
            this.actionStatus = actionStatus;
            this.errorCode = errorCode;
            this.errorDesc = errorDesc;
        }
    }
    
    public class CSLoyaltyAcount{
        @AuraEnabled
        public String availablePoints;
        @AuraEnabled
        public String totalPoints;
        @AuraEnabled
        public String blockedPoints;
       /* @AuraEnabled
        public String provisionalPoints;
        @AuraEnabled
        public String consumedPoints;
        @AuraEnabled
        public String status;*/
        @AuraEnabled
        public CSCustomer CSCustomer;
        public CSLoyaltyAcount(String availablePoints, String totalPoints, String blockedPoints, /*String provisionalPoints, String consumedPoints, String status, */CSCustomer CSCustomer){
            this.availablePoints = availablePoints; 
            this.totalPoints = totalPoints; 
            this.blockedPoints = blockedPoints; 
            /*this.provisionalPoints = provisionalPoints; 
            this.consumedPoints = consumedPoints; 
            this.status = status; */
            this.CSCustomer = CSCustomer;
        }
    }
    
    public class CSCustomer{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public list<CSOrder> CSOrder;
        @AuraEnabled
        public Datetime lastUpdateDate;
        @AuraEnabled
        public String creator;
        @AuraEnabled
        public String lastUpdater;
        public CSCustomer(String id, list<CSOrder> CSOrder, Datetime lastUpdateDate, String creator, String lastUpdater){
            this.id=id;
            this.CSOrder = CSOrder;
            this.lastUpdateDate = lastUpdateDate;
            this.creator = creator;
            this.lastUpdater = lastUpdater;
        }
    }
    
    public class CSOrder{
        @AuraEnabled
        public String captureID;
        @AuraEnabled
        public CSOffer CSOffer;
        public CSOrder(String captureID, CSOffer CSOffer){
            this.captureID = captureID;
            this.CSOffer = CSOffer;
        }
        
    }
    
    public class CSOffer{
        @AuraEnabled
    	public String code;
        @AuraEnabled
        public String mainNetworkOffer;
        @AuraEnabled
        public list<CsProduct> CsProduct;
        @AuraEnabled
        public Datetime creationDate;
        public CSOffer(String code, String mainNetworkOffer, list<CsProduct> CsProduct, Datetime creationDate){
            this.code = code;
            this.mainNetworkOffer = mainNetworkOffer;
            this.CsProduct = CsProduct;
            this.creationDate = creationDate;
        }
    }
	
    public class CsProduct{
        @AuraEnabled
        public List<CSMobileDirectoryNumber> CSMobileDirectoryNumber;
        public CsProduct(List<CSMobileDirectoryNumber> CSMobileDirectoryNumber){
            this.CSMobileDirectoryNumber = CSMobileDirectoryNumber;
        }
    }
    
    public class CSMobileDirectoryNumber{
        @AuraEnabled
        public String mdn;
        public CSMobileDirectoryNumber(String mdn){
            this.mdn = mdn;
        }
    }
    public class CSOperationResultInfo{
        @AuraEnabled
        public String isOK;
        @AuraEnabled
        public String errorCode;
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String uuid;
        public CSOperationResultInfo(String isOK, String errorCode, String errorMessage, String uuid){
            this.isOK = isOK;
            this.errorCode = errorCode;
            this.errorMessage = errorMessage;
            this.uuid = uuid;
        }
    }
    
    
}