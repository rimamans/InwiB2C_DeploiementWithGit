/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 29-05-2024
 * @last modified by  : CHB
 * @Last Update       : Add campus Template
 **/
public class InwiB2C_CreateContractBulkBatchV2 implements Database.Batchable<sobject> {
    // ESY - 26/04/2024 - Handle Canal Values Correctly to prevent the error INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST
    private Set<String> canalValues;
    
    public InwiB2C_CreateContractBulkBatchV2() {
        initCanalValues();
    }
    
    private void initCanalValues(){
        canalValues = new Set<String>();
        for (Schema.PicklistEntry ple : vlocity_cmt__Subscription__c.InwiB2C_Canal__c.getDescribe().getPicklistValues()) {
            canalValues.add(ple.getValue());
        }
    }
    
    private String refactorCanal(String canal){
        // Refactor Canal input to be a valid form
        if (canalValues.contains(canal)) return canal;
        if (canal.equals('USSD-D')) return 'inwiB2C_USSD';
        if (!canal.startsWith('inwiB2C_')){
            if (canalValues.contains('inwiB2C_' + canal)) return 'inwiB2C_' + canal;
            if (canalValues.contains('inwiB2C_' + canal.toLowerCase().capitalize())) return 'inwiB2C_' + canal.toLowerCase().capitalize();
        }
        return 'inwiB2C_USSD';
    }
    private Boolean isValidCanal(String canal){
        // Check if refactored canal is a valid subscription canal picklist value
        return canalValues.contains(refactorCanal(canal));
    }
    // END ESY
    
    public Database.querylocator start(Database.BatchableContext BC){
        //JBEN - CHECK IF THERE IS STILL A JOB RUNNING
        
        Id thisJobId = bc.getJobId();
        AsyncApexJob[] jobs = [select id from AsyncApexJob where status='Processing' AND ApexClass.Name = 'InwiB2C_CreateContractBulkBatchV2' and id != :thisJobId];
        
        if(!jobs.IsEmpty() && !Test.isRunningTest()){
            // RETURN 0 RECORDS SINCE A JOB IS STILL RUNNING
            return Database.getQueryLocator('SELECT Id, inwiB2C_Address__c, inwiB2C_BirthDate__c, inwiB2C_BusinessSegment__c, inwiB2C_Canal__c, inwiB2C_City__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_ComplementAddress__c, inwiB2C_CountryCode__c, inwiB2C_FirstName__c, inwiB2C_Gender__c, inwiB2C_Icc__c, inwiB2C_IdAccount__c, inwiB2C_IdAccount__r.InwiB2C_Address__c, inwiB2C_IdContract__c, inwiB2C_IdOrder__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_LastName__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_Ocerised__c, inwiB2C_OcsId__c, inwiB2C_PieceIdentite__c, inwiB2C_PostCode__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_Request__c, inwiB2C_SegmentLevel1__c , inwib2c_Volte__c , inwiB2C_SegmentLevel2__c, inwiB2C_State__c, inwiB2C_Street__c, inwiB2C_TypePieceIdentite__c, inwiB2C_User__c, inwiB2C_uuid__c,CreatedDate,inwiB2C_PS_BO_ID__c,inwiB2C_RbtBoId__c, inwiB2C_StatutDeTraitement__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c = \'inwiB2C_Error\' order by CreatedDate asc LIMIT 1 ');
        }
        else{
            if(!Test.isRunningTest()) {
                // JBEN - Limit records retrieved based on the metadata value
                String limitRecordsRetreived;
                limitRecordsRetreived = [Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from InwiB2C_CreateContractBulkLimit__mdt where label = 'ContractBulkLimit' limit 1].InwiB2C_LimitBulkBatch__c;
                
                //Djamel Optimisation begin
                //String query = 'SELECT Id, inwiB2C_Address__c, inwiB2C_BirthDate__c, inwiB2C_BusinessSegment__c, inwiB2C_Canal__c, inwiB2C_City__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_ComplementAddress__c, inwiB2C_CountryCode__c, inwiB2C_FirstName__c, inwiB2C_Gender__c, inwiB2C_Icc__c, inwiB2C_IdAccount__c, inwiB2C_IdAccount__r.InwiB2C_Address__c, inwiB2C_IdContract__c, inwiB2C_IdOrder__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_LastName__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_Ocerised__c, inwiB2C_OcsId__c, inwiB2C_PieceIdentite__c, inwiB2C_PostCode__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_Request__c, inwiB2C_SegmentLevel1__c, inwiB2C_SegmentLevel2__c, inwiB2C_State__c, inwiB2C_Street__c, inwiB2C_TypePieceIdentite__c, inwiB2C_User__c, inwiB2C_uuid__c, InwiB2C_CorrelationId__c,CreatedDate,inwiB2C_PS_BO_ID__c,inwiB2C_RbtBoId__c, inwiB2C_StatutDeTraitement__c,InwiB2C_DateReelDemande__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c = \'inwiB2C_Nouveau\' order by CreatedDate asc LIMIT '+ limitRecordsRetreived;
                //DLE 27/04/2024 begin
                //String query = 'SELECT Id, inwiB2C_Address__c, inwiB2C_BirthDate__c, inwiB2C_BusinessSegment__c, inwiB2C_Canal__c, inwiB2C_City__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_ComplementAddress__c, inwiB2C_CountryCode__c, inwiB2C_FirstName__c, inwiB2C_Gender__c, inwiB2C_Icc__c, inwiB2C_IdAccount__c, inwiB2C_IdAccount__r.InwiB2C_Address__c, inwiB2C_IdContract__c, inwiB2C_IdOrder__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_LastName__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_Ocerised__c, inwiB2C_OcsId__c, inwiB2C_PieceIdentite__c, inwiB2C_PostCode__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_Request__c, inwiB2C_SegmentLevel1__c, inwiB2C_SegmentLevel2__c, inwiB2C_State__c, inwiB2C_Street__c, inwiB2C_TypePieceIdentite__c, inwiB2C_User__c, inwiB2C_uuid__c, InwiB2C_CorrelationId__c,CreatedDate,inwiB2C_PS_BO_ID__c,inwiB2C_RbtBoId__c, inwiB2C_StatutDeTraitement__c,InwiB2C_DateReelDemande__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c = \'inwiB2C_Nouveau\'  LIMIT '+ limitRecordsRetreived;
                String query = 'SELECT Id, inwiB2C_Address__c, inwiB2C_BirthDate__c, inwiB2C_BusinessSegment__c, inwiB2C_Canal__c, inwiB2C_City__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_ComplementAddress__c, inwiB2C_CountryCode__c, inwiB2C_FirstName__c, inwiB2C_Gender__c, inwiB2C_Icc__c, inwiB2C_IdAccount__c, inwiB2C_IdAccount__r.InwiB2C_Address__c, inwiB2C_IdContract__c, inwiB2C_IdOrder__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_LastName__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_Ocerised__c, inwiB2C_OcsId__c, inwiB2C_PieceIdentite__c, inwiB2C_PostCode__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_Request__c, inwiB2C_SegmentLevel1__c, inwib2c_Volte__c , inwiB2C_SegmentLevel2__c, inwiB2C_State__c, inwiB2C_Street__c, inwiB2C_TypePieceIdentite__c, inwiB2C_User__c, inwiB2C_uuid__c, InwiB2C_CorrelationId__c,CreatedDate,inwiB2C_PS_BO_ID__c,inwiB2C_RbtBoId__c, inwiB2C_StatutDeTraitement__c,InwiB2C_DateReelDemande__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c = \'inwiB2C_Nouveau\' and  inwiB2C_Canal__c = \'inwiB2C_CRC\'  LIMIT '+ limitRecordsRetreived;
                //DLE 27/04/2024 end
                //Djamel Optimisation end
                return Database.getQueryLocator(query);
                
            }
            else {
                return Database.getQueryLocator('SELECT Id, inwiB2C_Address__c,InwiB2C_CorrelationId__c, inwiB2C_BirthDate__c, inwiB2C_BusinessSegment__c, inwiB2C_Canal__c, inwiB2C_City__c, inwiB2C_CodeAgence__c, inwiB2C_CodeArticle__c, inwiB2C_CodeDistributeur__c, inwiB2C_ComplementAddress__c, inwiB2C_CountryCode__c, inwiB2C_FirstName__c, inwiB2C_Gender__c, inwiB2C_Icc__c, inwiB2C_IdAccount__c, inwiB2C_IdAccount__r.InwiB2C_Address__c, inwiB2C_IdContract__c, inwiB2C_IdOrder__c, inwiB2C_imsi__c, inwiB2C_Ki__c, inwiB2C_LastName__c, inwiB2C_MdnDealer__c, inwiB2C_Mdn__c, inwiB2C_Ocerised__c, inwiB2C_OcsId__c, inwiB2C_PieceIdentite__c, inwiB2C_PostCode__c, inwiB2C_ProfileId__c, inwiB2C_Puk__c, inwiB2C_Request__c, inwiB2C_SegmentLevel1__c, inwib2c_Volte__c , inwiB2C_SegmentLevel2__c, inwiB2C_State__c, inwiB2C_Street__c, inwiB2C_TypePieceIdentite__c, inwiB2C_User__c, inwiB2C_uuid__c,CreatedDate,inwiB2C_PS_BO_ID__c,inwiB2C_RbtBoId__c, inwiB2C_StatutDeTraitement__c,InwiB2C_DateReelDemande__c FROM inwiB2C_CreateContractBulk__c WHERE inwiB2C_StatutDeTraitement__c = \'InwiB2C_New_ve\' order by CreatedDate desc LIMIT 2 ');
            }
        }
    }
    
    public void execute (Database.BatchableContext BC, List<sobject> scope) {
        // JAWAD - Create Lists of Objects - Account Contact and Address
        //System.debug('1-Limits.getHeapSize() : '+Limits.getHeapSize());
        Integer limitRecordsRetreived = Integer.valueOf([Select MasterLabel, InwiB2C_LimitBulkBatch__c, Label from InwiB2C_CreateContractBulkLimit__mdt where label = 'ContractBulkLimit' limit 1].InwiB2C_LimitBulkBatch__c);
        List<InwiB2C_Address__c> ListAddress = new List<InwiB2C_Address__c>();
        List<InwiB2C_Address__c> ListAddressContract = new List<InwiB2C_Address__c>();
        List<InwiB2C_Address__c> ListExistingAddressContract = new List<InwiB2C_Address__c>();
        List<Account> ListAccounts = new List<Account>();
        List<Account> ListBillingAccounts = new List<Account>();
        List<Contact> ListContacts = new List<Contact>();
        List<Contract> ListContracts = new List<Contract>();
        List<InwiB2C_MDNOffreEtudiant__c> ListMDNOffreEtudiant = new List<InwiB2C_MDNOffreEtudiant__c>();
        // LDA - 20211211 - Adding direct creation of Subscriptions- START
        List<vlocity_cmt__Subscription__c> ListSubscriptions = new List<vlocity_cmt__Subscription__c>();
        List<InwiB2C_Subscription_contract__c> ListSubscriptionContracts = new List<InwiB2C_Subscription_contract__c>();
        //JBEN - 12012022 - Comment Order part
        List<inwiB2C_OrderSubscription__c> ListOrderSubscriptions = new List<inwiB2C_OrderSubscription__c>();
        //JBEN - 12012022 - Comment Order part
        
        // LDA - 20211211 - Adding direct creation of Subscriptions- END
        // JBE - 20211220 - Adding direct creation of Assets- START
        List<Asset> ListAssets = new List<Asset>();
        // JBE - 20211220 - Adding direct creation of Assets- END
        
        
        //CHB 13/12/2023 ANO 13142
        String consumerRecordType = [select id from RecordType where Name ='Consumer' and SobjectType ='Account'].Id;
        String billingRecordType= [select id from RecordType where Name ='Billing' and SobjectType ='Account'].Id;
        //String consumerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        //JBEN - 11042022 - ADD THE BILLING ACCOUNT RECORD TYPE
        //String billingRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        
        //System.debug('0.1-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        // ZME - BEGIN - Get Order & OrderItems
        //JBEN - 12012022 - Comment Order part
        List<Order> listOrders = new List<Order>();
        List<OrderItem> listOrderItems = new List<OrderItem>();
        id orderIdTemplateDealer = [Select MasterLabel, OrderId__c, Label from InwiB2C_IdOrderToClone__mdt where label = 'OrderIdDealer' limit 1].OrderId__c;
        id orderIdTemplate = [Select MasterLabel, OrderId__c, Label from InwiB2C_IdOrderToClone__mdt where label = 'OrderId' limit 1].OrderId__c;
        //JBEN - 12012022 - Comment Order part
        //System.debug('0.2-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        //JBEN - 12012022 - Comment Order part
        List<Order> genericOrderDealer= [SELECT Pricebook2Id, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, accountid, status, EffectiveDate, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,ContractId,InwiB2C_Offre__c from order where id = :OrderIdTemplateDealer limit 1];
        List<Order> genericOrder= [SELECT Pricebook2Id, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, accountid, status, EffectiveDate, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,ContractId,InwiB2C_Offre__c from order where id = :OrderIdTemplate limit 1];
        //JBEN - 12012022 - Comment Order part
        
        //System.debug('0.3-Limits.getHeapSize() : '+Limits.getHeapSize());
        //JBEN - 12012022 - Comment Order part
        //List<OrderItem> genericOrderItemsDealer = [select InwiB2C_MDN__c, vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c, OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :OrderIdTemplateDealer limit 20];
        //List<OrderItem> genericOrderItems = [select InwiB2C_MDN__c, vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c, OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :OrderIdTemplate limit 20];
        //List<OrderItem> genericOrderItems = [select InwiB2C_MDN__c, vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c, OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :OrderIdTemplate limit 20];
        // ZME -17122021-  END - Get Order & OrderItems
        //JBEN - 12012022 - Comment Order part
        
        //JBEN - START - Get Generic Asset to Clone
        //Get the ids of the Asset templates
        id assetIdTemplateDealer = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'AssetDealer' limit 1].InwiB2C_AssetId__c;
        id assetIdTemplate = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAsset' limit 1].InwiB2C_AssetId__c;
        //CHB 16/02/2024 CampusConnecté
        id assetIdTemplateCampus = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'TicTacAssetCampus' limit 1].InwiB2C_AssetId__c;
        
        //Y-MH 06-12-2025 begin asset Volte*
        id assetIdTemplateVolte = [Select MasterLabel, InwiB2C_AssetId__c, Label from InwiB2C_IdAssetToClone__mdt where label = 'AssetIdTicTacVolte' limit 1].InwiB2C_AssetId__c;
        //Y-MH end asset Volte*
        //get the list of the assets having as the rootitemid the template id
        List<Asset> genericAssetsDealer= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c,Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplateDealer order by vlocity_cmt__SequenceNumber__c asc];
        List<Asset> genericAssetsTicTac= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplate order by vlocity_cmt__SequenceNumber__c asc];
        //CHB 16/02/2024 campus connecté
        List<Asset> genericAssetsTicTacCampus= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplateCampus order by vlocity_cmt__SequenceNumber__c asc];
        Map<string, List<Asset>> mapAssetByTempId = new Map<string, List<Asset>>();
        Map<String, String> mapAssetParentByTempId = new Map<String, String>();
        // JBEN - END - Get Generic Asset to Clone
        
        //Y-MH begin 06-12-2025 get generic asset volte to clone
        List<Asset> genericAssetsTicTacVolte= [SELECT ProductCode, Name, Quantity, Id, vlocity_cmt__Action__c,vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PriceListId__c, vlocity_cmt__PricebookEntryId__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c, vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c, Price, vlocity_cmt__LineNumber__c, ParentId, vlocity_cmt__ParentItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where vlocity_cmt__RootItemId__c = :assetIdTemplateVolte order by vlocity_cmt__SequenceNumber__c asc];
        //Y-MH end get generic asset volte to clone
        
        // LDA - START : get existing Orders for MDN
        //System.debug('0.4-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        List<String> mdnList = new List<String>();
        List<String> mdnDealerList = new List<String>();
        
        List<String> CreateContractListWithBOID = new List<String>();
        List<String> CreateContractListWithAccountId = new List<String>();
        List<String> CreateContractListWithRBTBOID = new List<String>();
        Map<String, String> mapContactByBulkId = new Map<String, String>();
        Map<String, String> mapAccountByBulkId = new Map<String, String>();
        Map<String, String> mapBillingAccountByBulkId = new Map<String, String>();
        Map<String, String> mapBillingBOIdByBulkId = new Map<String, String>();
        Map<String, String> mapContactByBOPSId = new Map<String, String>();
        Map<String, Account> mapAccountByBOPSId = new Map<String, Account>();
        Map<String, Account> mapAccountByAccountId = new Map<String, Account>();
        //JBEN - RBTBOID MODIF 08042022
        Map<String, String> mapContactByRbtBOPSId = new Map<String, String>();
        Map<String, String> mapAccountByRbtBOPSId = new Map<String, String>();
        
        //System.debug('0.5-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        // Build MDN List for Order Item Querry
        
        for (inwiB2C_CreateContractBulk__c objScope: (List<inwiB2C_CreateContractBulk__c>) scope) {
            //inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
            mdnList.add(objScope.inwiB2C_Mdn__c);
            //JBEN - BEGIN - VERIFY MDN DEALER IS NOT NULL BEFORE INSERTING
            if (objScope.inwiB2C_MdnDealer__c != null && objScope.inwiB2C_MdnDealer__c != '')
            {
                mdnDealerList.add(objScope.inwiB2C_MdnDealer__c);
            }
            
            if (objScope.inwiB2C_PS_BO_ID__c!= null && objScope.inwiB2C_PS_BO_ID__c != '')
            {
                CreateContractListWithBOID.add(objScope.inwiB2C_PS_BO_ID__c);
            }
            
            //JBEN - 11042022 - GET ACCOUNT IDS IF THEYRE ALREADY CREATED
            if (objScope.inwiB2C_IdAccount__c != null )
            {
                CreateContractListWithAccountId.add(objScope.inwiB2C_IdAccount__c);
            }
            
            if (objScope.inwiB2C_RbtBoId__c != null && objScope.inwiB2C_RbtBoId__c != '')
            {
                CreateContractListWithRBTBOID.add(objScope.inwiB2C_RbtBoId__c);
            }
            
            //JBEN - END 15122021 - VERIFY MDN DEALER IS NOT NULL BEFORE INSERTING
        }
        
        
        
        //System.debug('1-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        // Get List of OrderItems for the MDN List
        
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*List<orderitem> orderItemForMDN = [
           SELECT Order.id, Order.OrderNumber,inwiB2C_Mdn__c
           FROM OrderItem
           WHERE inwiB2C_Mdn__c in  :mdnList and order.inwiB2C_Statut__c not in ('inwiB2C_Annulee', 'inwiB2C_Activee')
           AND order.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition' LIMIT 1
       ];*/
        
        // Get List of Account Ids for the Mdn Dealer List
        
        /*List<vlocity_cmt__Subscription__c> accountsForMdnDealer = [
           SELECT vlocity_cmt__AccountId__c, Inwib2c_Num_ro_de_la_ligne__c
           FROM vlocity_cmt__Subscription__c 
           WHERE Inwib2c_Num_ro_de_la_ligne__c in :mdnDealerList
       ];*/
        // ZME - END - 03.12.2021 - Optimization
        
        // Build the Map of MDNs
        Map <String, String> mdnMap = new Map <String, String>();
        
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*for(OrderItem orderItemLine : orderItemForMDN){
            if (! mdnMap.containsKey(orderItemLine.inwiB2C_Mdn__c)){
                mdnMap.put(orderItemLine.inwiB2C_Mdn__c, orderItemLine.Order.OrderNumber);
            }
        }*/
        for(OrderItem orderItemLine : [SELECT Order.id, Order.OrderNumber,inwiB2C_Mdn__c
           FROM OrderItem
           WHERE inwiB2C_Mdn__c in  :mdnList and order.inwiB2C_Statut__c not in ('inwiB2C_Annulee', 'inwiB2C_Activee')
           AND order.inwib2c_TypeDeLaCommande__c = 'inwiB2C_Acquisition' LIMIT 1]) {
            if (! mdnMap.containsKey(orderItemLine.inwiB2C_Mdn__c)){
                mdnMap.put(orderItemLine.inwiB2C_Mdn__c, orderItemLine.Order.OrderNumber);
            }
        }
        
        System.debug('2-Limits.getHeapSize() : '+Limits.getHeapSize());
        // ZME - END - 03.12.2021 - Optimization
        
        
        // Build the Map of Mdns Dealer and Account
        Map <String, String> mdnDealerMap = new Map <String, String>();
        
        // ZME - END - 03.12.2021 - Optimization
        /*for(vlocity_cmt__Subscription__c accountLine : accountsForMdnDealer){
            if (! mdnDealerMap.containsKey(accountLine.Inwib2c_Num_ro_de_la_ligne__c)){
                mdnDealerMap.put(accountLine.Inwib2c_Num_ro_de_la_ligne__c, accountLine.vlocity_cmt__AccountId__c);
            }
        }*/
        for(vlocity_cmt__Subscription__c accountLine : [SELECT vlocity_cmt__AccountId__c, Inwib2c_Num_ro_de_la_ligne__c
           FROM vlocity_cmt__Subscription__c 
           WHERE Inwib2c_Num_ro_de_la_ligne__c in :mdnDealerList]){
            if (! mdnDealerMap.containsKey(accountLine.Inwib2c_Num_ro_de_la_ligne__c)){
                mdnDealerMap.put(accountLine.Inwib2c_Num_ro_de_la_ligne__c, accountLine.vlocity_cmt__AccountId__c);
            }
        }
        // ZME - END - 03.12.2021 - Optimization
        // LDA - END : get existing Orders for MDN
        
        // JAWAD - Start: Get Existing non Expired subscriptions
        
        // Get List of Non expired subscripitons for mdn List
        
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*List<vlocity_cmt__Subscription__c> nonExpiredsubsList = [
           SELECT id, Inwib2c_Num_ro_de_la_ligne__c
           FROM vlocity_cmt__Subscription__c
           WHERE Inwib2c_Num_ro_de_la_ligne__c in :mdnList AND inwiB2C_LegacyStatus__c != 'EXPIRED' AND inwiB2C_Statut__c !='InwiB2C_Expired' LIMIT 1
       ];*/
        // ZME - END - 03.12.2021 - Optimization
        // Build the Map of MDNs
        Map <String, String> subsMap = new Map <String, String>();
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*for(vlocity_cmt__Subscription__c subscripitonLine : nonExpiredsubsList){
            if (! subsMap.containsKey(subscripitonLine.Inwib2c_Num_ro_de_la_ligne__c)){
                subsMap.put(subscripitonLine.Inwib2c_Num_ro_de_la_ligne__c, subscripitonLine.id);
            }
        }*/
        for(vlocity_cmt__Subscription__c subscripitonLine : [SELECT id, Inwib2c_Num_ro_de_la_ligne__c
           FROM vlocity_cmt__Subscription__c
           WHERE Inwib2c_Num_ro_de_la_ligne__c in :mdnList AND inwiB2C_LegacyStatus__c not in ('EXPERED','EXPIRED','EXPiRED','FRAUDE','Non identifié','Résilié cycle de vie','Résiliée cycle de vie','Supprimé du HLRE','Susp. Non identifié','résilié non identifié') AND inwiB2C_Statut__c !='InwiB2C_Expired']){
            if (! subsMap.containsKey(subscripitonLine.Inwib2c_Num_ro_de_la_ligne__c)){
                subsMap.put(subscripitonLine.Inwib2c_Num_ro_de_la_ligne__c, subscripitonLine.id);
            }
        }
        
        System.debug('subsMap: ' +JSON.serialize(subsMap));
        
        //System.debug('3-Limits.getHeapSize() : '+Limits.getHeapSize());
        // ZME - END - 03.12.2021 - Optimization
        
        // JAWAD - END: Get Existing non Expired subscriptions
        
        //LDA: Build Town and Quartier Maps
        
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*Map<String,String> villeMap = new Map<String,String>();
        List<inwiB2C_Ville__c> villeList = [SELECT id, Name from inwiB2C_Ville__c];
        
        for (inwiB2C_Ville__c ville: villeList ){
            villeMap.put(ville.Name, ville.id);
        }
        
        Map<String,String> quartierMap = new Map<String,String>();
        List<inwiB2C_Quartier__c> quartierList = [SELECT id, Name from inwiB2C_Quartier__c];
        
        for (inwiB2C_Quartier__c quartier: quartierList ){
            quartierMap.put(quartier.Name, quartier.id);
        }
        
        Map<String,String> paysMap = new Map<String,String>();
        List<InwiB2C_Pays__c> paysList = [SELECT id, InwiB2C_code_pays__c from InwiB2C_Pays__c];
        
        for (InwiB2C_Pays__c pays: paysList ){
            paysMap.put(pays.InwiB2C_code_pays__c, pays.id);
        }
        
        Map<String,String> regionMap = new Map<String,String>();
        List<InwiB2C_Region__c> regionList = [select id, name  from InwiB2C_Region__c];
        
        for (InwiB2C_Region__c region: regionList ){
            regionMap.put(region.name, region.id);
        }*/
        
        Map<String,String> villeMap = new Map<String,String>();
        for (inwiB2C_Ville__c ville: [SELECT id, Name from inwiB2C_Ville__c]){
            villeMap.put(ville.Name, ville.id);
        }
        
        Map<String,String> quartierMap = new Map<String,String>();
        for (inwiB2C_Quartier__c quartier: [SELECT id, Name from inwiB2C_Quartier__c]){
            quartierMap.put(quartier.Name, quartier.id);
        }
        
        Map<String,String> paysMap = new Map<String,String>();
        for (InwiB2C_Pays__c pays: [SELECT id, InwiB2C_code_pays__c from InwiB2C_Pays__c]){
            paysMap.put(pays.InwiB2C_code_pays__c, pays.id);
        }
        
        Map<String,String> regionMap = new Map<String,String>();
        for (InwiB2C_Region__c region: [SELECT id, name from InwiB2C_Region__c]){
            regionMap.put(region.name, region.id);
        }
        // ZME - END - 03.12.2021 - Optimization
        
        // JAWAD - Build the map for list accounts with BO ID
        /*List<Account> AccountListwithBoID = [SELECT id,inwiB2C_PS_BO_ID__c FROM ACCOUNT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithBOID LIMIT :limitRecordsRetreived];
        List<Account> AccountListwithAccountId = [SELECT id,inwiB2C_PS_BO_ID__c FROM ACCOUNT WHERE Id in :CreateContractListWithAccountId LIMIT :limitRecordsRetreived];
        List<Contact> ContactListwithBoID = [SELECT id,inwiB2C_PS_BO_ID__c FROM CONTACT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithBOID LIMIT :limitRecordsRetreived];
         */
        List<Account> AccountListwithBoID = [SELECT id,inwiB2C_PS_BO_ID__c, InwiB2C_Address__r.InwiB2C_Complement_d_adresse_2__c , InwiB2C_Address__r.InwiB2C_Adresse__c , InwiB2C_Address__r.InwiB2C_Region__c , InwiB2C_Address__r.InwiB2C_Code_Postale__c, InwiB2C_Address__r.Name, InwiB2C_Address__r.inwiB2C_PS_BO_ID__c, InwiB2C_Address__r.InwiB2C_Pays__c, InwiB2C_Address__r.inwiB2C_Ville__c, InwiB2C_Address__r.InwiB2C_Quartier__c FROM ACCOUNT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithBOID ];
        List<Account> AccountListwithAccountId = [SELECT id,inwiB2C_PS_BO_ID__c,  InwiB2C_Address__c, InwiB2C_Address__r.InwiB2C_Complement_d_adresse_2__c , InwiB2C_Address__r.InwiB2C_Adresse__c , InwiB2C_Address__r.InwiB2C_Region__c , InwiB2C_Address__r.InwiB2C_Code_Postale__c, InwiB2C_Address__r.Name, InwiB2C_Address__r.inwiB2C_PS_BO_ID__c, InwiB2C_Address__r.InwiB2C_Pays__c, InwiB2C_Address__r.inwiB2C_Ville__c, InwiB2C_Address__r.InwiB2C_Quartier__c  FROM ACCOUNT WHERE Id in :CreateContractListWithAccountId];
        List<Contact> ContactListwithBoID = [SELECT id,inwiB2C_PS_BO_ID__c FROM CONTACT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithBOID];
        
        // JAWAD - Build the map for list billing accounts with RBT BO ID
        //List<Account> AccountListwithRbtBoID = [SELECT id,inwiB2C_PS_BO_ID__c FROM ACCOUNT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithRBTBOID LIMIT :limitRecordsRetreived];
        List<Account> AccountListwithRbtBoID = [SELECT id,inwiB2C_PS_BO_ID__c FROM ACCOUNT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithRBTBOID];
        //List<Contact> ContactListwithRbtBoID = [SELECT id,inwiB2C_PS_BO_ID__c FROM CONTACT WHERE inwiB2C_PS_BO_ID__c in :CreateContractListWithRBTBOID];
        
        for (Account accObj: AccountListwithBoID)
        {
            mapAccountByBOPSId.put(accObj.inwiB2C_PS_BO_ID__c, accObj);
        }
        
        for (Contact contactObj: ContactListwithBoID)
        {
            mapContactByBOPSId.put(contactObj.inwiB2C_PS_BO_ID__c, contactObj.Id);
        }
        
        //JBEN - 08042022 - Add RBT BO ID - BEGIN
        for (Account accObj: AccountListwithRbtBoID)
        {
            mapAccountByRbtBOPSId.put(accObj.inwiB2C_PS_BO_ID__c, accObj.Id);
        }
        
        //LDA - 20221007 - Add existing account address - start
        for (Account accObj: AccountListwithAccountId)
        {
            mapAccountByAccountId.put(accObj.id, accObj);
        }
        
        
        /*
        for (Contact contactObj: ContactListwithRbtBoID)
        {
            mapContactByRbtBOPSId.put(contactObj.inwiB2C_PS_BO_ID__c, contactObj.Id);
        }
         */
        //JBEN - 08042022 - Add RBT BO ID - END
        
        // JAWAD - Build the map for list partenaires
        List<String> AccountListCodeDist = new List<String>();
        
        for (sObject objScope: scope) {
            inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
            AccountListCodeDist.add(newObjScope.inwiB2C_CodeDistributeur__c);
            
            // JAWAD - 02032022 - CREATE MAP WITH CREATECONTRACTBULK ID TO GET ACCOUNT AND CONTACT ID
            if (newObjScope.inwiB2C_PS_BO_ID__c != '' && newObjScope.inwiB2C_PS_BO_ID__c != null)
            {
                mapAccountByBulkId.put(newObjScope.id, mapAccountByBOPSId.get(newObjScope.inwiB2C_PS_BO_ID__c).Id );
                mapContactByBulkId.put(newObjScope.id, mapContactByBOPSId.get(newObjScope.inwiB2C_PS_BO_ID__c) );
            }
            
            
            
            // JBEN - 08042022 - CREATE MAP WITH CREATECONTRACTBULK ID TO GET BILLING ACCOUNT
            if (newObjScope.inwiB2C_RbtBoId__c != '' && newObjScope.inwiB2C_RbtBoId__c != null)
            {
                mapBillingBOIdByBulkId.put(newObjScope.id, newObjScope.inwiB2C_RbtBoId__c );
            }
        }
        
        
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*List<Account> partenaires = [
           SELECT id, inwib2c_CodePartenaire__c
           FROM Account
           WHERE inwib2c_CodePartenaire__c in :AccountListCodeDist and inwiB2C_TypePartenaire__c = 'inwiB2C_Distributeur'
       ];*/
        // ZME - END - 03.12.2021 - Optimization
        
        Map <String, String> codeDisMap = new Map <String, String>();
        
        // ZME - BEGIN - 03.12.2021 - Optimization
        /*for(Account accountLine : partenaires){
            if (! codeDisMap.containsKey(accountLine.inwib2c_CodePartenaire__c)){
                codeDisMap.put(accountLine.inwib2c_CodePartenaire__c, accountLine.id);
            }
        }*/
        for(Account accountLine : [SELECT id, inwib2c_CodePartenaire__c
           FROM Account
           WHERE inwib2c_CodePartenaire__c in :AccountListCodeDist and inwiB2C_TypePartenaire__c in ('inwiB2C_MRE', 'inwiB2C_VS' , 'inwiB2C_Distributeur')]){
            if (! codeDisMap.containsKey(accountLine.inwib2c_CodePartenaire__c)){
                codeDisMap.put(accountLine.inwib2c_CodePartenaire__c, accountLine.id);
            }
        }
        //System.debug('4-Limits.getHeapSize() : '+Limits.getHeapSize());
        // ZME - END - 03.12.2021 - Optimization
        
        //LDA - get profile name Map
        
        List<String> profileIdList = new List<String>();
        
        for (sObject objScope: scope) {
            inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
            profileIdList.add(newObjScope.inwiB2C_ProfileId__c);
        }
        
        Map <String, String> profileIdMap = new Map <String, String>();
        
        for(vlocity_cmt__PicklistValue__c profilePickListValue : [SELECT Name ,vlocity_cmt__TextValue__c
       FROM vlocity_cmt__PicklistValue__c 
       WHERE vlocity_cmt__PicklistId__r.vlocity_cmt__Code__c='INWIB2C_PLK_FORFAIT_LABELv1' and vlocity_cmt__TextValue__c  in :profileIdList]){
            if (! profileIdMap.containsKey(profilePickListValue.vlocity_cmt__TextValue__c)){
                profileIdMap.put(profilePickListValue.vlocity_cmt__TextValue__c, profilePickListValue.Name);
            }
        }
        
        
        //List<inwiB2C_CreateContractBulk__c> createContractBulk = new List<inwiB2C_CreateContractBulk__c>();
        for (sObject objScope: scope) {
            inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
            if (mdnMap.containsKey(newObjScope.inwiB2C_Mdn__c)) {
                newObjScope.inwiB2C_Erreur__c = 'Le numéro '+newObjScope.inwiB2C_Mdn__c+' est en cours d\'activation sur la commande : '+ mdnMap.get(newObjScope.inwiB2C_Mdn__c);
                newObjScope.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                //createContractBulk.add(newObjScope);
            } else if(newObjScope.inwiB2C_Canal__c == null || newObjScope.inwiB2C_Canal__c == ''){
                newObjScope.inwiB2C_Erreur__c = 'Le canal ne doit pas être vide';
                newObjScope.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                
            }
            // ESY - 26/04/2024 - Handle Canal Values Correctly to prevent the error INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST
            // Uncomment later
            // else if(!isValidCanal(newObjScope.inwiB2C_Canal__c)){
                //     newObjScope.inwiB2C_Erreur__c = 'Le canal n\'est pas valide';
                //     newObjScope.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
            // }
            // END ESY
            else {
                if (subsMap.containsKey(newObjScope.inwiB2C_Mdn__c)) {
                    newObjScope.inwiB2C_Erreur__c = 'Le numéro '+newObjScope.inwiB2C_Mdn__c+' existe dans une souscription active : '+ subsMap.get(newObjScope.inwiB2C_Mdn__c);
                    newObjScope.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Erreur';
                    //createContractBulk.add(newObjScope);
                }
                else {
                    //Create and Insert new Address object in the AddressList
                    String ville = newObjScope.inwiB2C_City__c == null ? 'DUMMY': newObjScope.inwiB2C_City__c;
                    String quartier = newObjScope.inwiB2C_State__c == null ? 'DUMMY': newObjScope.inwiB2C_State__c;
                    String pays = newObjScope.inwiB2C_CountryCode__c  == null ? 'MAR': newObjScope.inwiB2C_CountryCode__c;
                    String region = pays == 'MAR' ? regionMap.get('DUMMY') : null;
                    
                    if (newObjScope.inwiB2C_IdAccount__c != null && mapAccountByAccountId.containsKey(newObjScope.inwiB2C_IdAccount__c) && mapAccountByAccountId.get(newObjScope.inwiB2C_IdAccount__c).InwiB2C_Address__c != null){
                        Account existingAccount = mapAccountByAccountId.get(newObjScope.inwiB2C_IdAccount__c);
                        InwiB2C_Address__c newAddressObj = new InwiB2C_Address__c(
                            InwiB2C_Complement_d_adresse_2__c = existingAccount.InwiB2C_Address__r.InwiB2C_Complement_d_adresse_2__c,
                        InwiB2C_Adresse__c = existingAccount.InwiB2C_Address__r.InwiB2C_Adresse__c,
                        InwiB2C_Region__c = existingAccount.InwiB2C_Address__r.InwiB2C_Region__c,
                        InwiB2C_Code_Postale__c = existingAccount.InwiB2C_Address__r.InwiB2C_Code_Postale__c,
                        Name = existingAccount.InwiB2C_Address__r.Name,
                        inwiB2C_PS_BO_ID__c = newObjScope.Id,
                        InwiB2C_Pays__c = existingAccount.InwiB2C_Address__r.InwiB2C_Pays__c,
                        inwiB2C_Ville__c = existingAccount.InwiB2C_Address__r.inwiB2C_Ville__c,
                        InwiB2C_Quartier__c = existingAccount.InwiB2C_Address__r.InwiB2C_Quartier__c
                            );
                        ListExistingAddressContract.add(newAddressObj);
                    }else if (newObjScope.inwiB2C_PS_BO_ID__c != null && newObjScope.inwiB2C_PS_BO_ID__c != '' && mapAccountByBOPSId.containsKey(newObjScope.inwiB2C_PS_BO_ID__c) && mapAccountByBOPSId.get(newObjScope.inwiB2C_PS_BO_ID__c).InwiB2C_Address__c != null){
                        Account existingAccount = mapAccountByBOPSId.get(newObjScope.inwiB2C_PS_BO_ID__c);
                        InwiB2C_Address__c newAddressObj = new InwiB2C_Address__c(
                            InwiB2C_Complement_d_adresse_2__c = existingAccount.InwiB2C_Address__r.InwiB2C_Complement_d_adresse_2__c,
                        InwiB2C_Adresse__c = existingAccount.InwiB2C_Address__r.InwiB2C_Adresse__c,
                        InwiB2C_Region__c = existingAccount.InwiB2C_Address__r.InwiB2C_Region__c,
                        InwiB2C_Code_Postale__c = existingAccount.InwiB2C_Address__r.InwiB2C_Code_Postale__c,
                        Name = existingAccount.InwiB2C_Address__r.Name,
                        inwiB2C_PS_BO_ID__c = newObjScope.Id,
                        InwiB2C_Pays__c = existingAccount.InwiB2C_Address__r.InwiB2C_Pays__c,
                        inwiB2C_Ville__c = existingAccount.InwiB2C_Address__r.inwiB2C_Ville__c,
                        InwiB2C_Quartier__c = existingAccount.InwiB2C_Address__r.InwiB2C_Quartier__c
                            );
                        ListExistingAddressContract.add(newAddressObj);
                    }  else {
                        InwiB2C_Address__c newAddressObj = new InwiB2C_Address__c(
                            InwiB2C_Complement_d_adresse_2__c = newObjScope.inwiB2C_ComplementAddress__c,
                        InwiB2C_Adresse__c = newObjScope.inwiB2C_Address__c,
                        InwiB2C_Region__c = region,
                        InwiB2C_Code_Postale__c = newObjScope.inwiB2C_PostCode__c,
                        Name = newObjScope.inwiB2C_Address__c == null ?'DUMMY':newObjScope.inwiB2C_Address__c,
                        inwiB2C_PS_BO_ID__c = newObjScope.Id,
                        InwiB2C_Pays__c = paysMap.get(pays),
                        inwiB2C_Ville__c = villeMap.get(ville),
                        InwiB2C_Quartier__c = quartierMap.get(quartier)
                            );
                        ListAddress.add(newAddressObj);
                        
                    }
                    
                    //ListAddressContract.add(newAddressObj.clone(false, true, false, true));
                    
                    //Create and Insert Contact object in the ContactList
                    Date birthdate;
                    if (newObjScope.inwiB2C_BirthDate__c == null) {
                        
                        birthdate = date.newInstance(1900, 01, 01);
                    }else {
                        birthdate = newObjScope.inwiB2C_BirthDate__c;
                    }
                    /*else {
                        birthdate = newObjScope.inwiB2C_BirthDate__c.format();
                        birthdate = birthdate.replace('/', '-');
                    }*/
                    
                    String typeIdentity = newObjScope.inwiB2C_TypePieceIdentite__c;
                    if (typeIdentity == 'NID')
                    {
                        typeIdentity = 'CIN';
                    }
                    
                    String salutation;
                    if (newObjScope.inwiB2C_Gender__c == 'M') {
                        salutation = 'Monsieur';
                    }
                    else if (newObjScope.inwiB2C_Gender__c == 'F') {
                        salutation = 'Madame';
                    }
                    else{
                        salutation = 'Monsieur';
                    }
                    //JBEN - 25022022 - CHECK IF CONTACT IS ALREADY CREATED
                    //JBEN - 11042022 - ADD ANOTHER CHECK ON ACCOUNTID
                    if (newObjScope.inwiB2C_PS_BO_ID__c == null && newObjScope.inwiB2C_IdAccount__c == null){
                        Contact newContactObj = new Contact(
                            //MailingAddress = newAddressObj.Id,
                        //Inwib2c_Mail__c = newObjScope.inwiB2C_Mdn__c+'@dummy.xx',
                        Email = newObjScope.inwiB2C_Mdn__c+'@dummy.xx',
                        InwiB2C_Num_ro_de_contact__c = newObjScope.inwiB2C_Mdn__c,
                        Salutation = salutation,
                        Phone= '',
                        HomePhone = newObjScope.inwiB2C_Mdn__c,
                        CurrencyIsoCode = 'MAD',
                        InwiB2C_Secteur_d_activit__c = 'Dummy',
                        birthdate =  birthdate ,
                        LastName = newObjScope.inwiB2C_Mdn__c,
                        Inwib2c_Langue_Pr_f_r_e__c = 'Français',
                        FirstName = 'Dummy',
                        InwiB2C_Profession__c = 'Dummy',
                        InwiB2C_Situation_familiale__c = 'Dummy',
                        InwiB2C_Anciennet__c = 'Dummy',
                        InwiB2C_CIN__c = 'XX1111111111',
                        InwiB2C_Type_CIN__c = typeIdentity,
                        InwiB2C_Moyen_de_contact_principal__c = 'SMS',
                        inwiB2C_PS_BO_ID__c = newObjScope.Id,
                        //JBEN - 1712201 - ADD CORRELAITONID
                        InwiB2C_CorrelationId__c = newObjScope.InwiB2C_CorrelationId__c
                            );
                        ListContacts.add(newContactObj);
                    }
                    
                    //Create and Insert new Address object in the AddressList
                    //BillingStreet
                    string billingstreet ;
                    if (newObjScope.inwiB2C_Address__c == null || newObjScope.inwiB2C_Address__c == '')
                    {
                        billingstreet = 'Dummy';
                    }
                    else {
                        billingstreet = newObjScope.inwiB2C_Address__c;
                    }
                    //BillingStreet
                    string billingcity;
                    if (newObjScope.inwiB2C_City__c == null || newObjScope.inwiB2C_City__c == '')
                    {
                        billingcity = 'Dummy';
                    }
                    else {
                        billingcity = newObjScope.inwiB2C_City__c;
                    }
                    
                    //ZIPCODE
                    string zipCode ;
                    if (newObjScope.inwiB2C_PostCode__c == null || newObjScope.inwiB2C_PostCode__c == '')
                    {
                        zipCode = '00000';
                    }
                    else {
                        zipCode =  newObjScope.inwiB2C_PostCode__c;
                    }
                    //JBEN - 20211220 - Correct the value of the segment marche
                    string segmentMarche;
                    if (newObjScope.inwiB2C_SegmentLevel1__c == 'D')
                    {
                        segmentMarche = 'Dealer';
                    }
                    else
                        if (newObjScope.inwiB2C_SegmentLevel1__c == 'SD')
                    {
                        segmentMarche = 'Super Dealer';
                    }
                    else
                    {
                        segmentMarche = 'Particulier';
                    }
                    
                    // Contract Bulk Creation date
                    Date CreationDateContract = date.newinstance(newObjScope.CreatedDate.year(), newObjScope.CreatedDate.month(), newObjScope.CreatedDate.day());
                    //CHECK IF ACCOUNT IS ALREADY CREATED
                    if (newObjScope.inwiB2C_PS_BO_ID__c == null && newObjScope.inwiB2C_IdAccount__c == null){
                        Account newAccountObj = new Account(
                            Name = 'Dummy ' + newObjScope.inwiB2C_Mdn__c,
                        BillingStreet = billingstreet,
                        BillingCity = billingcity,
                        BillingCountry = pays,
                        BillingState = 'DUMMY',
                        BillingPostalCode = zipCode,
                        inwiB2C_LegacyAcctCreationDate__c = date.today(),
                        Inwib2c_Client_Depuis__c = date.today(),
                        inwib2c_AdresseMail__c = newObjScope.inwiB2C_Mdn__c+'@dummy.xx',
                        vlocity_cmt__BillingEmailAddress__c = newObjScope.inwiB2C_Mdn__c+'@dummy.xx',
                        CurrencyIsoCode = 'MAD',
                        Inwib2c_Segment_march__c = segmentMarche,
                        Inwib2c_Segment_valeur__c = newObjScope.inwiB2C_SegmentLevel2__c,
                        inwiB2C_managedInSF__c = true,
                        vlocity_cmt__Status__c = 'Existant',
                        recordtypeId = consumerRecordType,
                        inwiB2C_PS_BO_ID__c = newObjScope.Id,
                        //JBEN - 1712201 - ADD CORRELAITONID
                        InwiB2C_CorrelationId__c = newObjScope.InwiB2C_CorrelationId__c
                            );
                        ListAccounts.add(newAccountObj);
                    }
                    
                    //JBEN - 11042022 - CREATE BILLING ACCOUNT
                    system.debug('biillingacc');
                    Account newAccountObj = new Account(
                        Name = 'Dummy ' + newObjScope.inwiB2C_Mdn__c,
                    BillingStreet = billingstreet,
                    BillingCity = billingcity,
                    BillingCountry = pays,
                    BillingState = 'DUMMY',
                    BillingPostalCode = zipCode,
                    inwiB2C_LegacyAcctCreationDate__c = date.today(),
                    Inwib2c_Client_Depuis__c = date.today(),
                    inwib2c_AdresseMail__c = newObjScope.inwiB2C_Mdn__c+'@dummy.xx',
                    vlocity_cmt__BillingEmailAddress__c = newObjScope.inwiB2C_Mdn__c+'@dummy.xx',
                    CurrencyIsoCode = 'MAD',
                    Inwib2c_Segment_march__c = segmentMarche,
                    Inwib2c_Segment_valeur__c = newObjScope.inwiB2C_SegmentLevel2__c,
                    inwiB2C_managedInSF__c = true,
                    vlocity_cmt__Status__c = 'Existant',
                    recordtypeId = billingRecordType,
                    inwiB2C_PS_BO_ID__c = newObjScope.Id,
                    //inwiB2C_PS_BO_ID__c = newObjScope.inwiB2C_RbtBoId__c == null? newObjScope.Id: newObjScope.inwiB2C_RbtBoId__c,
                    //JBEN - 1712201 - ADD CORRELAITONID
                    parentId = newObjScope.inwiB2C_IdAccount__c != null ? newObjScope.inwiB2C_IdAccount__c: newObjScope.inwiB2C_PS_BO_ID__c != null?mapAccountByBulkId.get(newObjScope.Id) : null,
                    InwiB2C_CorrelationId__c = newObjScope.InwiB2C_CorrelationId__c
                        );
                    ListBillingAccounts.add(newAccountObj);
                    
                    
                    Contract newContractObj = new Contract();
                    newContractObj.InwiB2c_Nom__c = newObjScope.inwiB2C_FirstName__c;
                    newContractObj.InwiB2c_Prenom__c = newObjScope.inwiB2C_LastName__c;
                    newContractObj.InwiB2C_MDN_Dealer__c = newObjScope.inwiB2C_MdnDealer__c;
                    string sexe;
                    if (newObjScope.inwiB2C_Gender__c == 'M') {
                        sexe = 'Homme';
                    }
                    else if (newObjScope.inwiB2C_Gender__c == 'F') {
                        sexe = 'Femme';
                    }
                    else {
                        sexe = 'Inconnu';
                    }
                    newContractObj.InwiB2C_Sexe__c = sexe;
                    newContractObj.InwiB2C_Date_de_naissance__c = birthdate;
                    /* CHB ano B-14749 26/03/2024 begin */
                    //newContractObj.InwiB2C_statut_contrat__c = 'Initialise';
                    newContractObj.InwiB2C_statut_contrat__c =newObjScope.inwiB2C_IdAccount__c!=null && newObjScope.inwiB2C_Canal__c=='inwiB2C_CRC'?'Dossier conforme':'Initialise';
                    /* CHB ano B-14749 26/03/2024 end */
                    newContractObj.inwiB2C_Profession__c = 'Dummy';
                    newContractObj.InwiB2C_Date_CRM__c = datetime.now();
                    //JBEN - 20220120 - Update Susbscription Date
                    newContractObj.InwiB2C_Date_de_souscription__c = CreationDateContract;
                    newContractObj.InwiB2C_Type_CIN__c = typeIdentity;
                    newContractObj.InwiB2C_Num_CIN__c = newObjScope.inwiB2C_PieceIdentite__c == null? null : newObjScope.inwiB2C_PieceIdentite__c.length() > 20  ? newObjScope.inwiB2C_PieceIdentite__c.substring(0,20) : newObjScope.inwiB2C_PieceIdentite__c;
                    // JBE - BEGIN - specifify InwiB2C_Distributeur__c while creating the contract - B-3272
                    newContractObj.InwiB2C_Distributeur__c = codeDisMap.get(newObjScope.inwiB2C_CodeDistributeur__c);
                    // JBE - END - specifify InwiB2C_Distributeur__c while creating the contract - B-3272
                    newContractObj.inwiB2C_LegacyId__c = newObjScope.Id;
                    // JBE - BEGIN - Correct InwiB2C_Segmentation__c while creating the contract - B-9131
                    newContractObj.InwiB2C_Segmentation__c = segmentMarche;
                    // JBE - END - Correct InwiB2C_Segmentation__c while creating the contract - B-9131
                    /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                    newContractObj.inwib2c_Identification__c =true;
                    newContractObj.inwib2c_Qualification__c = true;
                    newContractObj.Canal_d_identification__c = 'Inwi';
                    /*chb 12/09/2024 sujet MGEN3561SF_Gestion identité lignes Prépayé client final begin*/
                    
                    newContractObj.accountId = newObjScope.inwiB2C_IdAccount__c != null ? newObjScope.inwiB2C_IdAccount__c: newObjScope.inwiB2C_PS_BO_ID__c != null?mapAccountByBulkId.get(newObjScope.Id) : null;
                    ListContracts.add(newContractObj);
                    
                    //JBEN - 12012022 - Comment Order part
                    // ZME - BEGIN - Create Order & OrderItems
                    /*Order newOrder ; //= new Order();
                    //OrderItem newOrderItem = new OrderItem();
                    if (newObjScope.inwiB2C_SegmentLevel1__c == 'D' || newObjScope.inwiB2C_SegmentLevel1__c == 'SD') {
                        newOrder = GenericOrderDealer[0].clone(false, true, false, true);
                        for (OrderItem item : genericOrderItemsDealer)
                        {
                            //newOrderItem = new OrderItem();
                            OrderItem newOrderItem = item.clone(false, true, false, true);
                            newOrderItem.InwiB2C_MDN__c = newObjScope.Id;
                            newOrderItem.vlocity_cmt__AssetReferenceId__c = null;
                            listOrderItems.add(newOrderItem);
                        }
                    }
                    
                    else {
                        newOrder = GenericOrder[0].clone(false, true, false, true);
                        
                        for (OrderItem item : genericOrderItems)
                        {
                            // newOrderItem = new OrderItem();
                            OrderItem newOrderItem = item.clone(false, true, false, true);
                            newOrderItem.InwiB2C_MDN__c = newObjScope.Id;
                            newOrderItem.vlocity_cmt__AssetReferenceId__c = null;
                            listOrderItems.add(newOrderItem);
                        }
                    }
                    newOrder.inwiB2C_Statut__c = 'inwiB2C_EnCours';
                    newOrder.EffectiveDate = date.today();
                    
                    newOrder.inwiB2C_Canal__c = newObjScope.inwiB2C_Canal__c == 'USSD-D' ? 'inwiB2C_USSD': 'inwiB2C_'+newObjScope.inwiB2C_Canal__c;
                    //newOrder.inwiB2C_Canal__c = newObjScope.inwiB2C_Canal__c == 'USSD-D' ? 'inwiB2C_USSD': 'inwiB2C_USSD';
                    System.debug('CANAL = ' +newObjScope.inwiB2C_Canal__c + '  ' + newOrder.inwiB2C_Canal__c);
                    newOrder.inwiB2C_Dealer__c = mdnDealerMap.get(newObjScope.inwiB2C_MdnDealer__c);
                    newOrder.inwib2c_Distributeur__c = codeDisMap.get(newObjScope.inwiB2C_CodeDistributeur__c);
                    newOrder.inwib2c_Partenaire__c = null;
                    neworder.inwiB2C_TempId__c = newObjScope.Id;
                    // LDA - 20211211 - Adding direct creation of Subscriptions- START
                    neworder.inwiB2C_needSubmission__c= true;
                    // LDA - 20211211 - Adding direct creation of Subscriptions- END
                    
                    listOrders.add(newOrder); */
                        // ZME - END - Create Order & OrderItems
                    //JBEN - 12012022 - Comment Order part
                    
                    // LDA - 20211211 - Adding direct creation of Subscriptions- START
                    vlocity_cmt__Subscription__c newSubscription = new vlocity_cmt__Subscription__c(
                        Name=newObjScope.inwiB2C_Mdn__c,
                    //vlocity_cmt__AccountId__c=accoutid,
                    //vlocity_cmt__BillingAccountId__c=billingaccount,
                    vlocity_cmt__SubscriptionNumber__c=newObjScope.id,
                    InwiB2C_IMSI__c=newObjScope.inwiB2C_imsi__c,
                    InwiB2C_Id_profil__c=newObjScope.inwiB2C_ProfileId__c,
                    //InwiB2C_MEI__c= newObjScope.,
                    Inwib2c_ICC__c=newObjScope.inwiB2C_Icc__c,
                    Inwib2c_Num_ro_de_la_ligne__c=newObjScope.inwiB2C_Mdn__c,
                    Inwib2c_Offre__c= ((newObjScope.inwiB2C_SegmentLevel1__c == 'D' || newObjScope.inwiB2C_SegmentLevel1__c == 'SD')&& newObjScope.inwiB2C_ProfileId__c != '20707')?GenericOrderDealer[0].InwiB2C_Offre__c:GenericOrder[0].InwiB2C_Offre__c,
                    Inwib2c_Profil__c=profileIdMap.get(newObjScope.inwiB2C_ProfileId__c),
                    Inwib2c_code_puk__c=newObjScope.inwiB2C_Puk__c,
                    inwiB2C_LegacyStatus__c='ACTIVE',
                    inwiB2C_Statut__c	='InwiB2C_Active',
                    vlocity_cmt__Status__c='Active',
                    //InwiB2C_Point_de_vente__c=codepatenaire,
                    //JBE - 20220120 - Replace activation date by ContractBulk Creation Date
                    //CHB -14-06-2023 - Replace activation date by ContractBulk DateReelDemande if not null
                    InwiB2C_Date_d_activation__c = newObjScope.InwiB2C_DateReelDemande__c != null ? newObjScope.InwiB2C_DateReelDemande__c : newObjScope.CreatedDate,
                    
                    //InwiB2C_Partenaire__c=pos,
                    //JBEN - 15122021 - Change Distrbiteur Value
                    InwiB2C_Distributeur__c=codeDisMap.get(newObjScope.inwiB2C_CodeDistributeur__c),
                    // ESY - 26/04/2024 - Handle Canal Values Correctly to prevent the error INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST
                    InwiB2C_Canal__c = refactorCanal(newObjScope.inwiB2C_Canal__c),
                    // InwiB2C_Canal__c = newObjScope.inwiB2C_IdAccount__c != null? newObjScope.inwiB2C_Canal__c: newObjScope.inwiB2C_Canal__c == 'USSD-D' ? 'inwiB2C_USSD': 'inwiB2C_'+newObjScope.inwiB2C_Canal__c,
                    // END ESY
                    //vlocity_cmt__CurrentContractId__c=contrat,
                    //InwiB2C_Contract__c=contrat,
                    Inwib2c_Type_de_forfait__c='Mobile',
                    Inwib2C_Type_Offre__c='InwiB2C_Prepaye',
                    //Inwib2c_Terminal__c=libeletterminal,
                    inwiB2C_managedInSF__c=true,
                    inwiB2C_NombreActivationClientParJour__c=0,
                    Inwib2c_SegmentLigne__c='Silver',
                    //JBEN - 17122021 - ADD CORRELAITONID
                    InwiB2C_CorrelationId__c = newObjScope.InwiB2C_CorrelationId__c,
                    //JBEN - 23122021 - ADD Dealer
                    InwiB2C_MDN_Dealer__c = newObjScope.inwiB2C_MdnDealer__c,
                    //chb 17/04/2025 begin*/
                    InwiB2C_Famille_d_offre__c='Prepaye',
                    //chb 17/04/2025 end*/
                    inwiB2C_TempId__c = newObjScope.Id,
                    vlocity_cmt__AccountId__c = newObjScope.inwiB2C_IdAccount__c != null ? newObjScope.inwiB2C_IdAccount__c: newObjScope.inwiB2C_PS_BO_ID__c != null?mapAccountByBulkId.get(newObjScope.Id) : null);
                    
                    ListSubscriptions.add(newSubscription);
                    
                    InwiB2C_Subscription_contract__c newSubContrat= new InwiB2C_Subscription_contract__c(
                        InwiB2C_Code_Article__c=newObjScope.inwiB2C_CodeArticle__c,
                    //InwiB2C_Contract__c=contrat,
                    InwiB2C_IMSI__c=newObjScope.inwiB2C_imsi__c,
                    InwiB2C_MDN__c=newObjScope.inwiB2C_Mdn__c,
                    InwiB2C_ESN_ICC__c=newObjScope.inwiB2C_Icc__c,
                    InwiB2C_N_Ligne__c=newObjScope.inwiB2C_Mdn__c,
                    //InwiB2C_Numero_Terminal__c=IMEI,
                    InwiB2C_Profil__c=newObjScope.inwiB2C_ProfileId__c,
                    InwiB2C_Date_CRM__c=Date.today(),
                    InwiB2C_akey__c=newObjScope.id,
                    InwiB2C_Type_Offre__c= ((newObjScope.inwiB2C_SegmentLevel1__c == 'D' || newObjScope.inwiB2C_SegmentLevel1__c == 'SD')&& newObjScope.inwiB2C_ProfileId__c != '20707')?GenericOrderDealer[0].InwiB2C_Offre__c:GenericOrder[0].InwiB2C_Offre__c
                        );
                    ListSubscriptionContracts.add( newSubContrat);
                    
                    // LDA - 20211211 - Adding direct creation of Subscriptions- END
                    
                    // JBE - 20211217 - Adding direct creation of Assets- START
                    if ((newObjScope.inwiB2C_SegmentLevel1__c == 'D' || newObjScope.inwiB2C_SegmentLevel1__c == 'SD') && newObjScope.inwiB2C_ProfileId__c != '20707') {
                        system.debug('Dealer'+newObjScope.inwiB2C_ProfileId__c);
                        List<Asset> ListAssetsForMapping = new List<Asset>();
                        for (Asset assetToUpdate: genericAssetsDealer){
                            
                            Asset newAsset;
                            newAsset = assetToUpdate.clone(false, true, false, true);
                            newAsset.inwiB2C_TempId__c = newObjScope.Id;
                            newAsset.accountId = newObjScope.inwiB2C_IdAccount__c;
                            newAsset.vlocity_cmt__BillingAccountId__c = newObjScope.inwiB2C_IdAccount__c;
                            
                            ListAssets.add(newAsset);
                            ListAssetsForMapping.add(newAsset);
                        }
                        if (ListAssetsForMapping.size() > 0){
                            mapAssetByTempId.put(newObjScope.Id,ListAssetsForMapping);
                        }
                        System.debug('Map Assets : '+ mapAssetByTempId);
                    }
                    //CHB 16/02/2024 Campus connecté
                    else if(newObjScope.inwiB2C_ProfileId__c == '20707'){
                        List<Asset> ListAssetsForMapping = new List<Asset>();
                        for (Asset assetToUpdate: genericAssetsTicTacCampus){
                            Asset newAsset;
                            newAsset = assetToUpdate.clone(false, true, false, true);
                            newAsset.inwiB2C_TempId__c = newObjScope.Id;
                            newAsset.accountId = newObjScope.inwiB2C_IdAccount__c;
                            newAsset.vlocity_cmt__BillingAccountId__c = newObjScope.inwiB2C_IdAccount__c;
                            
                            ListAssets.add(newAsset);
                            ListAssetsForMapping.add(newAsset);
                        }
                        if (ListAssetsForMapping.size() > 0){
                            mapAssetByTempId.put(newObjScope.Id,ListAssetsForMapping);
                        }
                        System.debug('Map Assets Campus : '+ mapAssetByTempId);
                    }
                    //Y-MH 06-12-2025 begin include Volte in MigPostPre
                    else if(newObjScope.inwib2c_Volte__c == true ){
                        List<Asset> ListAssetsForMapping = new List<Asset>();
                        for (Asset assetToUpdate: genericAssetsTicTacVolte){
                            Asset newAsset;
                            newAsset = assetToUpdate.clone(false, true, false, true);
                            newAsset.inwiB2C_TempId__c = newObjScope.Id;
                            newAsset.accountId = newObjScope.inwiB2C_IdAccount__c;
                            newAsset.vlocity_cmt__BillingAccountId__c = newObjScope.inwiB2C_IdAccount__c;
                            
                            ListAssets.add(newAsset);
                            ListAssetsForMapping.add(newAsset);
                        }
                        if (ListAssetsForMapping.size() > 0){
                            mapAssetByTempId.put(newObjScope.Id,ListAssetsForMapping);
                        }
                        System.debug('Map Assets Campus : '+ mapAssetByTempId);
                    }
                    //Y-MH end  include Volte in MigPostPre
                    else {
                        system.debug('TicTac'+newObjScope.inwiB2C_ProfileId__c);
                        List<Asset> ListAssetsForMapping = new List<Asset>();
                        for (Asset assetToUpdate: genericAssetsTicTac){
                            Asset newAsset;
                            newAsset = assetToUpdate.clone(false, true, false, true);
                            newAsset.inwiB2C_TempId__c = newObjScope.Id;
                            newAsset.accountId = newObjScope.inwiB2C_IdAccount__c;
                            newAsset.vlocity_cmt__BillingAccountId__c = newObjScope.inwiB2C_IdAccount__c;
                            
                            ListAssets.add(newAsset);
                            ListAssetsForMapping.add(newAsset);
                        }
                        if (ListAssetsForMapping.size() > 0){
                            mapAssetByTempId.put(newObjScope.Id,ListAssetsForMapping);
                        }
                        System.debug('Map Assets : '+ mapAssetByTempId);
                    }
                    
                    
                    // JBE - 20211217 - Adding direct creation of Subscriptions- END
                }
            }
        }
        
        //System.debug('5-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        
        update scope;
        // JAWAD - Build the maps of the objects with BO ID as the key
        map<String, String> accountMapBOID = new map<String, String>();
        map<String, String> addressMapBOID = new map<String, String>();
        map<String, String> addressContractMapBOID = new map<String, String>();
        map<String, String> contactMapBOID = new map<String, String>();
        map<String, String> assetMapBOID = new map<String, String>();
        map<String, String> billingAccountMapBOID = new map<String, String>();
        
        insert ListAddress;
        
        for (InwiB2C_Address__c addressObj : ListAddress)
        {
            if (! addressMapBOID.containsKey(addressobj.inwiB2C_PS_BO_ID__c)){
                addressMapBOID.put(addressObj.inwiB2C_PS_BO_ID__c, addressObj.id);
            }
        }
        
        insert ListContacts;
        
        for (Contact contactObj : ListContacts)
        {
            if (! contactMapBOID.containsKey(contactObj.inwiB2C_PS_BO_ID__c)){
                contactMapBOID.put(contactObj.inwiB2C_PS_BO_ID__c, contactObj.id);
            }
        }
        
        
        
        ListAddressContract = ListAddress.deepClone(false, false, false);
        ListAddressContract.addAll(ListExistingAddressContract);
        insert ListAddressContract;
        
        for (InwiB2C_Address__c addressContractObj : ListAddressContract)
        {
            if (! addressContractMapBOID.containsKey(addressContractObj.inwiB2C_PS_BO_ID__c)){
                addressContractMapBOID.put(addressContractObj.inwiB2C_PS_BO_ID__c, addressContractObj.id);
            }
        }
        
        //JBEN - 11042022 - CEATE BILLING ACCOUNTS
        /*for (Account accountObj : ListBillingAccounts)
        {
            
            if (addressMapBOID.containsKey(accountObj.inwiB2C_PS_BO_ID__c) && accountObj.InwiB2C_Address__c  == null) {
                accountObj.InwiB2C_Address__c = addressMapBOID.get(accountObj.inwiB2C_PS_BO_ID__c);
            }
        }*/
        
        
        for (Account accountObj : ListAccounts)
        {
            if (contactMapBOID.containsKey(accountObj.inwiB2C_PS_BO_ID__c) && accountObj.vlocity_cmt__PersonContactId__c == null) {
                accountObj.vlocity_cmt__PersonContactId__c = contactMapBOID.get(accountObj.inwiB2C_PS_BO_ID__c);
                //accountObj.vlocity_cmt__PrimaryContactId__c = contactMapBOID.get(accountObj.inwiB2C_PS_BO_ID__c).Id;
            }
            if (addressMapBOID.containsKey(accountObj.inwiB2C_PS_BO_ID__c) && accountObj.InwiB2C_Address__c == null ) {
                accountObj.InwiB2C_Address__c = addressMapBOID.get(accountObj.inwiB2C_PS_BO_ID__c);
            }
            // JBEN - 11042022 - UPDATE PARENTID WITH BILLING ACCOUNT
            /*if (mapBillingAccountByBulkId.containsKey(accountObj.inwiB2C_PS_BO_ID__c)) {
                accountObj.parentId = mapBillingAccountByBulkId.get(accountObj.inwiB2C_PS_BO_ID__c);
            }*/
            
        }
        insert ListAccounts;
        
        for (Account accountObj : ListAccounts)
        {
            if (! accountMapBOID.containsKey(accountObj.inwiB2C_PS_BO_ID__c)){
                accountMapBOID.put(accountObj.inwiB2C_PS_BO_ID__c, accountObj.id);
            }
        }
        
        for (Contact contactObj : ListContacts)
        {
            if (accountMapBOID.containsKey(contactObj.inwiB2C_PS_BO_ID__c) && contactObj.accountId == null) {
                contactObj.accountId = accountMapBOID.get(contactObj.inwiB2C_PS_BO_ID__c);
                
            }
        }
        update ListContacts;
        // END Creation of account, Contact and Address
        
        for (Account accountObj : ListBillingAccounts)
        {
            if (accountMapBOID.containsKey(accountObj.inwiB2C_PS_BO_ID__c) && accountObj.ParentId == null) {
                accountObj.ParentId = accountMapBOID.get(accountObj.inwiB2C_PS_BO_ID__c);
                
            }
            
            
            
        }
        
        insert ListBillingAccounts;
        
        for (Account billAccountObject : ListBillingAccounts)
        {
            if (! mapBillingAccountByBulkId.containsKey(billAccountObject.inwiB2C_PS_BO_ID__c)) {
                mapBillingAccountByBulkId.put(billAccountObject.inwiB2C_PS_BO_ID__c, billAccountObject.id) ;
                
            }
        }
        
        
        // ZME - BEGIN - Create Contracts
        for (Contract contractObj : ListContracts)
        {
            if (accountMapBOID.containsKey(contractObj.inwiB2C_LegacyId__c) && accountMapBOID.get(contractObj.inwiB2C_LegacyId__c) != null && contractObj.accountId == null ) {
                contractObj.accountId = accountMapBOID.get(contractObj.inwiB2C_LegacyId__c);
            }
            // START LBI - 19-09-2022
            /*else {
                contractObj.accountId = mapAccountByBulkId.get(contractObj.inwiB2C_LegacyId__c);
            }*/
            //END LBI - 19-09-2022
            if (addressContractMapBOID.containsKey(contractObj.inwiB2C_LegacyId__c)) {
                contractObj.InwiB2C_Address__c = addressContractMapBOID.get(contractObj.inwiB2C_LegacyId__c);
            }
        }
        
        insert ListContracts;
        
        map<String, String> contractMap = new map<String, String>();
        for (Contract contractObj : ListContracts)
        {
            if (! contractMap.containsKey(contractObj.inwiB2C_LegacyId__c)){
                contractMap.put(contractObj.inwiB2C_LegacyId__c, contractObj.id);
            }
        }
        
        // LDA - 20211211 - Adding direct creation of Subscriptions- START
        
        for (vlocity_cmt__Subscription__c subscriptionObj : ListSubscriptions)
        {
            if (accountMapBOID.containsKey(subscriptionObj.inwiB2C_TempId__c) && subscriptionObj.vlocity_cmt__AccountId__c == null) {
                subscriptionObj.vlocity_cmt__AccountId__c = accountMapBOID.get(subscriptionObj.inwiB2C_TempId__c);
            }
            
            // JBEN - 26022022 - Fill AccountId with already created accounts - START
            if (mapAccountByBulkId.containsKey(subscriptionObj.inwiB2C_TempId__c) && subscriptionObj.vlocity_cmt__AccountId__c == null) {
                subscriptionObj.vlocity_cmt__AccountId__c = mapAccountByBulkId.get(subscriptionObj.inwiB2C_TempId__c);
            }
            
            // JBEN - 26022022 - Fill AccountId with already created accounts - END
            
            
            
            if (mapBillingAccountByBulkId.containsKey(subscriptionObj.inwiB2C_TempId__c) && subscriptionObj.vlocity_cmt__BillingAccountId__c == null) {
                subscriptionObj.vlocity_cmt__BillingAccountId__c = mapBillingAccountByBulkId.get(subscriptionObj.inwiB2C_TempId__c);
            }
            
            
            if (contractMap.containsKey(subscriptionObj.inwiB2C_TempId__c)) {
                subscriptionObj.InwiB2C_Contract__c = contractMap.get(subscriptionObj.inwiB2C_TempId__c);
                subscriptionObj.vlocity_cmt__CurrentContractId__c = contractMap.get(subscriptionObj.inwiB2C_TempId__c);
            }
            
        }
        
        insert ListSubscriptions;
        
        for (InwiB2C_Subscription_contract__c subscriptionContractObj : ListSubscriptionContracts)
        {
            
            if (contractMap.containsKey(subscriptionContractObj.InwiB2C_akey__c)) {
                subscriptionContractObj.InwiB2C_Contract__c = contractMap.get(subscriptionContractObj.InwiB2C_akey__c);
                subscriptionContractObj.InwiB2C_akey__c = '';
            }
        }
        
        insert ListSubscriptionContracts;
        
        
        //insert ListAssets;
        
        // LDA - 20211211 - Adding direct creation of Subscriptions- END
        
        //System.debug('6-Limits.getHeapSize() : '+Limits.getHeapSize());
        // ZME - END - Create Contracts
        map<String, vlocity_cmt__Subscription__c> subscriptionsMap = new map<String, vlocity_cmt__Subscription__c>();
        map<String, Asset> assetsMap = new map<String, Asset>();
        
        for (vlocity_cmt__Subscription__c subscriptionObj : ListSubscriptions)
        {
            if (!subscriptionsMap.containsKey(subscriptionObj.inwiB2C_TempId__c)){
                subscriptionsMap.put(subscriptionObj.inwiB2C_TempId__c, subscriptionObj);
            }
            // LBI - 20220907 - Adding creation of MDN Offre Etudiant- START
            if(subscriptionObj.InwiB2C_Id_profil__c == '20707'){
                InwiB2C_MDNOffreEtudiant__c newMDNOffreEtudiant = new InwiB2C_MDNOffreEtudiant__c(
                    InwiB2C_MDN__c = subscriptionObj.Inwib2c_Num_ro_de_la_ligne__c,
                InwiB2C_SubscriptionId__c =  subscriptionObj.Id,
                InwiB2C_Statut__c = 'InwiB2C_Nouveau',
                InwiB2C_Date_de_creation__c = system.today()
                    );
                ListMDNOffreEtudiant.add(newMDNOffreEtudiant);
            }
        }
        
        Insert ListMDNOffreEtudiant;
        // LBI - 20220907 - Adding creation of MDN Offre Etudiant- END
        
        //JBEN - 12012022 - Comment Order part
        // ZME - BEGIN - Push Order & OrderItems
        /*for (Order orderObj : listOrders)
        {
            if (accountMapBOID.containsKey(orderObj.inwiB2C_TempId__c)) {
                orderObj.AccountId = accountMapBOID.get(orderObj.inwiB2C_TempId__c);
                orderObj.ContractId = contractMap.get(orderObj.inwiB2C_TempId__c);
            }
        }
        map<String, Order> ordersMap = new map<String, Order>();
        
        if(!Test.isRunningTest()) {
            insert listOrders;
            
            for (Order orderObj : listOrders)
            {
                if (!ordersMap.containsKey(orderObj.inwiB2C_TempId__c)){
                    ordersMap.put(orderObj.inwiB2C_TempId__c, orderObj);
                }
            }
        }
        
        
        for (OrderItem orderItemObj : listOrderItems) {
            if (ordersMap.containsKey(orderItemObj.InwiB2C_MDN__c)) {
                orderItemObj.OrderId = ordersMap.get(orderItemObj.InwiB2C_MDN__c).id;
                // ZME - BEGIN - 03.12.2021 - Optimization
                //orderItemObj.vlocity_cmt__BillingAccountId__c = ordersMap.get(orderItemObj.InwiB2C_MDN__c).AccountId;
                //orderItemObj.vlocity_cmt__ServiceAccountId__c = ordersMap.get(orderItemObj.InwiB2C_MDN__c).AccountId;
                string accountId = accountMapBOID.get(orderItemObj.InwiB2C_MDN__c);
                orderItemObj.vlocity_cmt__BillingAccountId__c = accountId;
                orderItemObj.vlocity_cmt__ServiceAccountId__c = accountId;
                // ZME - END - 03.12.2021 - Optimization
            }
        }
        insert listOrderItems;
        // Build map of Order Item
        Map<String,String> mapOrderItem = new Map<String,String> ();
        for(OrderItem orderItemObj: listOrderItems){
            if (! mapOrderItem.containsKey(orderItemObj.OrderId +'-'+orderItemObj.vlocity_cmt__LineNumber__c  )){
                mapOrderItem.put(orderItemObj.OrderId +'-'+orderItemObj.vlocity_cmt__LineNumber__c,orderItemObj.id);
            }
        }
        //System.debug('7-Limits.getHeapSize() : '+Limits.getHeapSize());
        
        //handle Parent OrderItem
        for (OrderItem NewOrderItem : listOrderItems)
        {
            String OrderItemParentId = mapOrderItem.get( NewOrderItem.OrderId + '-' +  '0001');
            if(NewOrderItem.vlocity_cmt__LineNumber__c.length()!= 4)
            {
                if (NewOrderItem.vlocity_cmt__LineNumber__c.length()== 9)
                {
                    NewOrderItem.vlocity_cmt__ParentItemId__c = mapOrderItem.get(NewOrderItem.OrderId + '-' + NewOrderItem.vlocity_cmt__LineNumber__c.substring(0,4));
                }
                if (NewOrderItem.vlocity_cmt__LineNumber__c.length()== 14)
                {
                    NewOrderItem.vlocity_cmt__ParentItemId__c = mapOrderItem.get(NewOrderItem.OrderId + '-' + NewOrderItem.vlocity_cmt__LineNumber__c.substring(0,9));
                }
            }
            NewOrderItem.vlocity_cmt__RootItemId__c = OrderItemParentId;
            NewOrderItem.InwiB2C_MDN__c = null;
        }
        update listOrderItems;
        
        for (vlocity_cmt__Subscription__c subscriptionObj : ListSubscriptions)
        {
            inwiB2C_OrderSubscription__c   newsubscOrder= new inwiB2C_OrderSubscription__c ();
            if (ordersMap.containsKey(subscriptionObj.vlocity_cmt__SubscriptionNumber__c)){
                newsubscOrder.inwiB2C_Order__c = ordersMap.get(subscriptionObj.vlocity_cmt__SubscriptionNumber__c).id;
            }
            
            newsubscOrder.inwiB2C_Subscription__c = subscriptionObj.id;
            ListOrderSubscriptions.add(newsubscOrder) ;
            
        }
        
        insert ListOrderSubscriptions;
        
         */
        //JBEN - 12012022 - Comment Order part
        //Insert Assets
        for (Asset assetObj : ListAssets) {
            string accountId;
            // JBEN - 26022022 - Fill AccountId with already created accounts - START
            if (mapAccountByBulkId.containsKey(assetObj.inwiB2C_TempId__c) && mapAccountByBulkId.get(assetObj.inwiB2C_TempId__c) != null && assetObj.AccountId == null ) {
                accountId = mapAccountByBulkId.get(assetObj.inwiB2C_TempId__c);
            }
            else if (assetObj.AccountId == null)
            {
                accountId = accountMapBOID.get(assetObj.inwiB2C_TempId__c);
            } else {
                accountId = assetObj.AccountId;
            }
            // JBEN - 26022022 - Fill AccountId with already created accounts - END
            //CHB 23112023
            assetObj.vlocity_cmt__BillingAccountId__c = mapBillingAccountByBulkId.get(assetObj.inwiB2C_TempId__c);
            //assetObj.vlocity_cmt__BillingAccountId__c = accountId;
            assetObj.AccountId = accountId;
            
            //JBEN - 20211227 - Remove filling th order id on the assets
            /*if (ordersMap.containsKey(assetObj.inwiB2C_TempId__c)) {
                assetObj.vlocity_cmt__OrderId__c = ordersMap.get(assetObj.inwiB2C_TempId__c).id;
            }*/
        }
        insert ListAssets;
        
        Map<String,String> mapAssetLineNumber = new Map<String,String> ();
        for (Asset assetObj : ListAssets) {
            
            //string subsriptionId = subscriptionsMap.get(assetObj.inwiB2C_TempId__c).Id;
            
            if (! mapAssetLineNumber.containsKey(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c  )){
                mapAssetLineNumber.put(assetObj.inwiB2C_TempId__c + '-' + assetObj.vlocity_cmt__LineNumber__c,assetObj.id);
            }
        }
        update ListAssets;
        
        // LDA - 20211211 - Adding direct creation of Subscriptions- START
        
        // Build map of Order Item
        
        /*for (Asset assetObj : ListAssets)
        {
            if (!assetsMap.containsKey(assetObj.inwiB2C_TempId__c)){
                assetsMap.put(assetObj.inwiB2C_TempId__c, assetObj);
            }
        }
    }*/
    
    
    
    // ZME - END - Push Order & OrderItems
    
    
    //JBEN - 20211227 - Update Assets Fields - START
    List<Asset> listUpdatedAsset = new List<Asset>();
    string assetLevel1Id;
    
    for (sObject objScope: scope) {
        inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
        
        //if (accountMapBOID.containsKey(newObjScope.id) || mapAccountByBulkId.containsKey(newObjScope.id)) {
            /* chb 28/05/2024 ano B-16073 begin */
            if (newObjScope.inwiB2C_StatutDeTraitement__c != 'inwiB2C_Erreur' && (accountMapBOID.containsKey(newObjScope.id) || mapAccountByBulkId.containsKey(newObjScope.id)|| newObjScope.inwiB2C_IdAccount__c !=null) ) {
                //if (newObjScope.inwiB2C_StatutDeTraitement__c != 'inwiB2C_Erreur' && newObjScope.inwiB2C_IdAccount__c !=null && newObjScope.inwiB2C_IdAccount__c !='') {
                    /* chb 28/05/2024 ano B-16073 end */
                    Map<String, Asset> mapAssetLevel1 = new Map<String, Asset>();
                    Map<String, Asset> mapAssetLevel2 = new Map<String, Asset>();
                    
                    List<Asset> listAssetToUpdate = new List<Asset>();
                    listAssetToUpdate = mapAssetByTempId.get(newObjScope.Id);
                    
                    string subscriptionId;
                    if (subscriptionsMap.containsKey(newObjScope.Id)){
                        subscriptionId = subscriptionsMap.get(newObjScope.Id).id;
                    }
                    
                    // JBEN - 20211124 - Get the asset parentId and update its fields - START
                    string assetLineNumber;
                    //string assetLevel2Id = mapAssetLevel2.get(newObjScope.Id).Id;
                    if(!Test.isRunningTest()) {
                        if (listAssetToUpdate != null){
                            for (Asset assetObj : listAssetToUpdate)
                            {
                                
                                if (assetObj.vlocity_cmt__LineNumber__c.length() == 4){
                                    assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                                    assetLevel1Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,4));
                                    System.debug('ASSET LEVEL 1 :'+ assetLevel1Id);
                                    assetObj.vlocity_cmt__SubscriptionId__c = subscriptionId;
                                    mapAssetParentByTempId.put(newObjScope.Id, assetLevel1Id);
                                    listUpdatedAsset.add(assetObj);
                                    break;
                                    //assetObj.RootAssetId = assetLevel1Id;
                                }
                            }
                            // JBEN - 20211124 - Get the asset parentId and update its fields - END
                            
                            for (Asset assetObj : listAssetToUpdate)
                            {
                                
                                string assetLevel2Id;
                                assetLineNumber = assetObj.vlocity_cmt__LineNumber__c;
                                
                                if (assetObj.vlocity_cmt__LineNumber__c.length() == 9){
                                    //assetObj.RootAssetId = assetLevel1Id;
                                    System.debug('HERE ASSET2 ' + assetLevel1Id);
                                    assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                                    assetObj.ParentId = assetLevel1Id;
                                    assetObj.vlocity_cmt__ParentItemId__c = assetLevel1Id;
                                    listUpdatedAsset.add(assetObj);
                                    
                                }else if (assetObj.vlocity_cmt__LineNumber__c.length() == 14){
                                    //assetObj.RootAssetId = assetLevel1Id;
                                    assetLevel2Id = mapAssetLineNumber.get(assetObj.inwiB2C_TempId__c + '-' + assetLineNumber.substring(0,9));
                                    System.debug('HERE ASSET3 '+assetLineNumber.substring(0,9) + '    ' + assetLineNumber);
                                    assetObj.vlocity_cmt__RootItemId__c = assetLevel1Id;
                                    assetObj.ParentId = assetLevel2Id;
                                    assetObj.vlocity_cmt__ParentItemId__c = assetLevel2Id;
                                    listUpdatedAsset.add(assetObj);
                                }
                                
                            }
                        }
                    }
                    else{
                        assetLevel1Id = 'TEST12345';
                    }
                    //JBEN - 20211222 - Update Assets Fields - END
                }
            }
            //JBEN - 12012022 - Comment Order part
            /*List<inwiB2C_CloneOrderEvent__e> cloneOrderListPE = new List<inwiB2C_CloneOrderEvent__e>();    */
            //JBEN - 12012022 - Comment Order part
            
            // jBE - 20211220 - Insert an event to CloneAsset - START
            List<inwiB2C_CloneAssetEvent__e> cloneAssetListPE = new List<inwiB2C_CloneAssetEvent__e>();
            // jBE - 20211220 - Insert an event to CloneAsset - END
            // JAWAD - Insert an event in the PE to CloneOrder
            for (sObject objScope: scope) {
                inwiB2C_CreateContractBulk__c newObjScope = (inwiB2C_CreateContractBulk__c)objScope;
                
                if (newObjScope.inwiB2C_StatutDeTraitement__c != 'inwiB2C_Erreur' && (accountMapBOID.containsKey(newObjScope.id) || mapAccountByBulkId.containsKey(newObjScope.id) || newObjScope.inwiB2C_IdAccount__c != null)) {
                    
                    //JBEN - 17122021 - Fill subscriptionId field on ContractBulk Object
                    string subscriptionId;
                    if (subscriptionsMap.containsKey(newObjScope.Id)){
                        subscriptionId = subscriptionsMap.get(newObjScope.Id).id;
                    }
                    //JBEN - 12012022 - Comment Order part
                    /*inwiB2C_CloneOrderEvent__e cloneOrderObj = new inwiB2C_CloneOrderEvent__e();*/
                    //JBEN - 12012022 - Comment Order part
                    
                    inwiB2C_CloneAssetEvent__e cloneAssetObj = new inwiB2C_CloneAssetEvent__e();
                    // ZME - BEGIN - 03.12.2021 - Optimization
                    //JBEN - 12012022 - Comment Order part
                    /*cloneOrderObj.inwiB2C_CustomerId__c = accountMapBOID.get(newObjScope.Id);*/
                    //JBEN - 12012022 - Comment Order part
                    //JBEN - 02032022 - MIGRATION POSTPAYE
                    /* chb 28/05/2024 ano B-16073 begin */
                    /*      if (!mapAccountByBulkId.containsKey(newObjScope.id)){
                        cloneAssetObj.inwiB2C_CustomerId__c = accountMapBOID.get(newObjScope.Id);
                    }
                    else if ( mapAccountByBulkId.containsKey(newObjScope.Id))
                    {
                        cloneAssetObj.inwiB2C_CustomerId__c = mapAccountByBulkId.get(newObjScope.Id);
                    } else {
                        cloneAssetObj.inwiB2C_CustomerId__c = newObjScope.inwiB2C_IdAccount__c;
                    }*/
                    //cloneOrderObj.inwiB2C_ContratId__c = contractMap.get(newObjScope.Id).Id;
                    cloneAssetObj.inwiB2C_CustomerId__c = newObjScope.inwiB2C_IdAccount__c;
                    /* chb 28/05/2024 ano B-16073 end */
                    //JBEN - 12012022 - Comment Order part
                    /*string orderId;
                    if (ordersMap.containsKey(newObjScope.Id)){
                        orderId = ordersMap.get(newObjScope.Id).id;
                    }*/
                    //JBEN - 12012022 - Comment Order part
                    
                    //JBEN - 20211220 - Get and pass the AssetId to the event - START
                    /* string assetId;
                    if (assetsMap.containsKey(newObjScope.Id)){
                        assetId = assetsMap.get(newObjScope.Id).id;
                    }  */
                    cloneAssetObj.inwiB2C_assetId__c = mapAssetParentByTempId.get(newObjScope.Id);
                    // JBE - 20211222 - Deactivate Create Order PE - START
                    cloneAssetObj.inwiB2C_Icc__c = newObjScope.inwiB2C_Icc__c;
                    cloneAssetObj.inwiB2C_imsi__c = newObjScope.inwiB2C_imsi__c;
                    cloneAssetObj.inwiB2C_ki__c = newObjScope.inwiB2C_Ki__c;
                    cloneAssetObj.inwiB2C_Mdn__c = newObjScope.inwiB2C_Mdn__c;
                    cloneAssetObj.inwiB2C_ProfileId__c = newObjScope.inwiB2C_ProfileId__c;
                    cloneAssetObj.inwiB2C_puk__c = newObjScope.inwiB2C_Puk__c;
                    cloneAssetObj.inwiB2C_SimOCSID__c = newObjScope.inwiB2C_OcsId__c;
                    cloneAssetObj.inwiB2C_MdnOCSID__c = newObjScope.inwiB2C_OcsId__c;
                    cloneAssetObj.inwiB2C_CodeArticle__c = newObjScope.inwiB2C_CodeArticle__c;
                    cloneAssetObj.inwiB2C_IdCreateContractBulk__c = newObjScope.id;
                    //JBEN - 20211220 - Get and pass the AssetId to the event - START
                    //JBEN - 17122021 -  Fill subscriptionId field on ContractBulk Object
                    newObjScope.inwiB2C_IdSubscription__c = subscriptionId;
                    // ZME - END - 03.12.2021 - Optimization
                    // JBE - 20211222 - Deactivate Create Order PE - START
                    //chb 20/03/2025 ano B-27310 begin
                    cloneAssetObj.inwiB2C_Volte__c = newObjScope.inwib2c_Volte__c;
                    //chb 20/03/2025 ano B-27310 end
                    //JBEN - 12012022 - Comment Order part
                    /*cloneOrderObj.inwiB2C_Icc__c = newObjScope.inwiB2C_Icc__c;
                    cloneOrderObj.inwiB2C_imsi__c = newObjScope.inwiB2C_imsi__c;
                    cloneOrderObj.inwiB2C_ki__c = newObjScope.inwiB2C_Ki__c;
                    cloneOrderObj.inwiB2C_Mdn__c = newObjScope.inwiB2C_Mdn__c;
                    cloneOrderObj.inwiB2C_ProfileId__c = newObjScope.inwiB2C_ProfileId__c;
                    cloneOrderObj.inwiB2C_puk__c = newObjScope.inwiB2C_Puk__c;
                    cloneOrderObj.inwiB2C_SimOCSID__c = newObjScope.inwiB2C_OcsId__c;
                    cloneOrderObj.inwiB2C_MdnOCSID__c = newObjScope.inwiB2C_OcsId__c;
                    cloneOrderObj.inwiB2C_CodeArticle__c = newObjScope.inwiB2C_CodeArticle__c;
                    cloneOrderObj.inwiB2C_IdCreateContractBulk__c = newObjScope.id;
                    // ZME - BEGIN - 03.12.2021 - Optimization
                    //cloneOrderObj.inwiB2C_orderId__c = ordersMap.get(newObjScope.Id).Id;
                    cloneOrderObj.inwiB2C_orderId__c = orderId;
                    // ZME - END - 03.12.2021 - Optimization
                    cloneOrderListPE.add(cloneOrderObj);
                     */
                    //JBEN - 12012022 - Comment Order part
                    
                    // JBE - 20211222 - Deactivate Create Order PE - END
                    // jBE - 20211220 - Add the Cloning Asset event to the list to Publish - START
                    cloneAssetListPE.add(cloneAssetObj);
                    // jBE - 20211220 - Add the Cloning Asset event to the list to Publish - END
                    //JBEN - 02032022 - MIGRATION POSTPAYE
                    //newObjScope.inwiB2C_IdAccount__c = accountMapBOID.get(newObjScope.Id);
                    if (accountMapBOID.containsKey(newObjScope.id) && newObjScope.inwiB2C_IdAccount__c == null){
                        newObjScope.inwiB2C_IdAccount__c = accountMapBOID.get(newObjScope.Id);
                    }
                    else if (mapAccountByBulkId.containsKey(newObjScope.id) && newObjScope.inwiB2C_IdAccount__c == null)
                    {
                        newObjScope.inwiB2C_IdAccount__c = mapAccountByBulkId.get(newObjScope.Id);
                    }
                    newObjScope.inwiB2C_IdContract__c = contractMap.get(newObjScope.Id);
                    // ZME - BEGIN - 03.12.2021 - Optimization
                    //newObjScope.inwiB2C_IdOrder__c = ordersMap.get(newObjScope.Id).Id;
                    
                    //JBEN - 12012022 - Comment Order part
                    /*newObjScope.inwiB2C_IdOrder__c = orderId;*/
                    //JBEN - 12012022 - Comment Order part
                    
                    //JBEN - 20211220 -  Fill rootAssetId field on ContractBulk Object
                    if(!Test.isRunningTest()) {
                        newObjScope.inwiB2C_RootAssetId__c = mapAssetParentByTempId.get(newObjScope.Id);
                    }
                    
                    // ZME - END - 03.12.2021 - Optimization
                    newObjScope.inwiB2C_StatutDeTraitement__c = 'inwiB2C_Termine';
                    //listCreateContractBulk.add(newObjScope);
                }
            }
            //update listCreateContractBulk;
            update scope;
            update listUpdatedAsset;
            //System.debug('9-Limits.getHeapSize() : '+Limits.getHeapSize());
            //UPDATE THE OBJBECTS : ERASE BO ID FIELD and FILL ACCOUNTID in Contact
            for (Contact contactObj : ListContacts)
            {
                contactObj.inwiB2C_PS_BO_ID__c = '';
            }
            update ListContacts;
            
            for (Account accountObj : ListAccounts)
            {
                if (!mapAccountByBulkId.containsKey(accountObj.inwiB2C_PS_BO_ID__c)){
                    accountObj.inwiB2C_PS_BO_ID__c = '';
                }
                
            }
            update ListAccounts;
            
            for (Account accountObj : ListBillingAccounts)
            {
                if (mapBillingBOIdByBulkId.containsKey(accountObj.inwiB2C_PS_BO_ID__c)){
                    accountObj.inwiB2C_PS_BO_ID__c = mapBillingBOIdByBulkId.get(accountObj.inwiB2C_PS_BO_ID__c);
                }else{
                    accountObj.inwiB2C_PS_BO_ID__c = '';
                }
                
            }
            update ListBillingAccounts;
            
            for (InwiB2C_Address__c addressObj : ListAddress)
            {
                addressObj.inwiB2C_PS_BO_ID__c = '';
            }
            update ListAddress;
            
            for (InwiB2C_Address__c addressContractObj : ListAddressContract)
            {
                addressContractObj.inwiB2C_PS_BO_ID__c = '';
            }
            update ListAddressContract;
            
            for (Contract contractObj : ListContracts)
            {
                contractObj.inwiB2C_LegacyId__c = '';
                contractObj.Status = 'Activated';
            }
            update ListContracts;
            //System.debug('10-Limits.getHeapSize() : '+Limits.getHeapSize());
            
            //INSERT THE EVENTS TO CLONE THE ORDERS
            if(!Test.isRunningTest()) {
                //JBEN - 12012022 - Comment Order part
                /*List<Database.SaveResult> results = EventBus.publish(cloneOrderListPE);*/
                //JBEN - 12012022 - Comment Order part
                // jBE - 20211220 - Publish the events to update created assets - START
                List<Database.SaveResult> resultsAssets = EventBus.publish(cloneAssetListPE);
                // jBE - 20211220 - Publish the events to update created assets - END
            }
            
            
            // ESY check the CPU time limit
            System.debug('Max CPU time allowed : ' + Limits.getLimitCpuTime());
            System.debug('Current CPU time usage : ' + Limits.getCpuTime());
        }
        
        public void finish(Database.BatchableContext BC) {
            AsyncApexJob a = [Select a.id, a.TotalJobItems, a.Status, a.NumberOfErrors,
                         a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                         a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] email = new String[]{'prod.salesforceb2c@inwi.ma'};
            mail.setToAddresses(email);
            mail.setReplyTo('prod.salesforceb2c@inwi.ma');
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Process '+a.Status);
            mail.setPlainTextBody('The Batch Apex job ('+ a.id +') processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    // ZME - END - CreateContract Bulk Batch