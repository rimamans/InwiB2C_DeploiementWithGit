/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InwiB2C_AddOptionsBash implements Database.Batchable<sObject> {

    // La méthode start est utilisée pour initialiser le traitement par batch
    global Database.QueryLocator start(Database.BatchableContext context) {
        // La requête sélectionne les enregistrements de l'objet InwiB2C_AddOptionsTemp__c
        return Database.getQueryLocator([SELECT Id, InwiB2C_Mdn__c, InwiB2C_Erreure__c, InwiB2C_Option__c, InwiB2C_Statut__c, InwiB2C_Statut_Extraction__c, InwiB2C_Subscription__c FROM InwiB2C_AddOptionsTemp__c WHERE InwiB2C_Statut__c ='New'  ]);
    }

    // La méthode execute est appelée pour chaque lot d'enregistrements
    public void execute(Database.BatchableContext context, List<InwiB2C_AddOptionsTemp__c> records) {
        List<Asset> updatedAssets = new List<Asset>();
        // Liste pour stocker les nouveaux InwiB2C_MigratedAssets__c à insérer
        List<InwiB2C_MigratedAssets__c> migratedAssets = new List<InwiB2C_MigratedAssets__c>();
        // Créer une liste d'identifiants d'actifs 
        List<Id> listOfAssetIds = new List<Id>();
        List<inwiB2C_AddOptionsTemplate__mdt> templateList= [select id,InwiB2C_AssetId__c,InwiB2C_NameOption__c,InwiB2C_Product_Code__c   from inwiB2C_AddOptionsTemplate__mdt];

      // Récupérer les valeurs nécessaires avant la boucle
      Set<String> mdnValues = new Set<String>();
       for (InwiB2C_AddOptionsTemp__c record : records) {
        mdnValues.add(record.InwiB2C_Mdn__c);
       }
      // Effectuer une seule requête SOQL pour récupérer les informations des actifs parent
       Map<String, Asset> parentAssets = new Map<String, Asset>([SELECT Id, Name, vlocity_cmt__SubscriptionId__r.vlocity_cmt__Status__c, AccountId, vlocity_cmt__BillingAccountId__c, RootAssetId, Product2Id FROM Asset WHERE vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c IN :mdnValues]);

      // Parcourir chaque actif de la liste et ajouter son identifiant à la liste d'identifiants d'actifs
      for (Asset asset : parentAssets.values()){
        listOfAssetIds.add(asset.Id);
    }
    // Récupérer une liste de relations de décomposition d'éléments d'inventaire où vlocity_cmt__SourceAssetId__c est dans listOfAssetIds
       List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listOfInventoryItemRels = [SELECT Id, vlocity_cmt__DestinationInventoryItemId__c FROM vlocity_cmt__InventoryItemDecompositionRelationship__c WHERE vlocity_cmt__SourceAssetId__c IN :listOfAssetIds];
       List<Id> listOfInventoryItemRelIds = new List<Id>();

       // Parcourir chaque relation d'élément d'inventaire de la liste et ajouter son identifiant de destination à la liste d'identifiants de relations d'éléments d'inventaire
       for (vlocity_cmt__InventoryItemDecompositionRelationship__c InventoryItemRel: listOfInventoryItemRels){

        if (!listOfInventoryItemRelIds.contains(InventoryItemRel.vlocity_cmt__DestinationInventoryItemId__c)){
    
            listOfInventoryItemRelIds.add(InventoryItemRel.vlocity_cmt__DestinationInventoryItemId__c);
    
        }
    
    }

    List<vlocity_cmt__InventoryItem__c> listInventoryItems = [SELECT id FROM vlocity_cmt__InventoryItem__c  where id in :listOfInventoryItemRelIds];

    List<Id> listOfInventoryItemIds = new List<Id>();
    
    for (vlocity_cmt__InventoryItem__c invItem: listInventoryItems){
    
        listOfInventoryItemIds.add(invItem.id);
    
    }
    
    List<vlocity_cmt__InventoryItemDecompositionRelationship__c> listOfInventoryItemRels2 = [select id, vlocity_cmt__DestinationInventoryItemId__c from vlocity_cmt__InventoryItemDecompositionRelationship__c where vlocity_cmt__DestinationInventoryItemId__c in :listOfInventoryItemIds];
    // Récupérer une liste d'éléments d'inventaire dont l'identifiant est présent dans listOfInventoryItemRelIds
    System.debug('Size listInventoryItems: ' + listInventoryItems.size());
    System.debug('Size listOfInventoryItemRels2: ' + listOfInventoryItemRels2.size());

  

List<Asset> clonedAssets = new List<Asset>(); 
Set<Id> clonedAssetIds = new Set<Id>();
// Parcours des enregistrements du lot
for (InwiB2C_AddOptionsTemp__c record : records) {
    Asset parentAsset = [SELECT Id, RootAssetId, ProductCode, Name, vlocity_cmt__SubscriptionId__r.vlocity_cmt__Status__c, AccountId, vlocity_cmt__BillingAccountId__c, Product2Id
                         FROM Asset
                         WHERE vlocity_cmt__SubscriptionId__r.Inwib2c_Num_ro_de_la_ligne__c = :record.InwiB2C_Mdn__c  AND Product2.vlocity_cmt__Type__c = 'Postpaye' AND vlocity_cmt__ParentItemId__c = null ];
    List<Asset> existingOptions =new List<Asset>();
    if(!Test.isRunningTest()) {
   		existingOptions = [SELECT Id, Name, vlocity_cmt__SubscriptionId__r.vlocity_cmt__Status__c
                                   FROM Asset
                                   WHERE RootAsset.vlocity_cmt__RootItemId__c = :parentAsset.Id
                                   AND vlocity_cmt__Action__c != 'Disconnect'
                                   AND Product2.ProductCode = :record.InwiB2C_Option__c];
    }    
    System.debug('existingOptions: ' + existingOptions);
    
    if (!existingOptions.isEmpty()) {
        // L'option existe déjà pour ce Mdn
        record.InwiB2C_Statut__c = 'Erreur';
        record.InwiB2C_Erreure__c = 'L\'option existe déjà pour ce Mdn.';
    } else { 
        for (inwiB2C_AddOptionsTemplate__mdt template : templateList) {
            List<Asset> assets = [SELECT Id, RootAssetId, ProductCode, Name, vlocity_cmt__SubscriptionId__r.vlocity_cmt__Status__c, AccountId, vlocity_cmt__BillingAccountId__c, Product2Id, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__Action__c,Price,Quantity 
                                  FROM Asset
                                  WHERE Id = :template.InwiB2C_AssetId__c 
                                  AND Product2.ProductCode = :record.InwiB2C_Option__c];
        for (Asset asset : assets) {
            Asset clonedAsset = asset.clone(false, true, false, true);
            clonedAsset.AccountId = parentAsset.AccountId;
            clonedAsset.vlocity_cmt__RootItemId__c = parentAsset.Id;     
            clonedAsset.vlocity_cmt__BillingAccountId__c = parentAsset.vlocity_cmt__BillingAccountId__c;
            clonedAsset.vlocity_cmt__ParentItemId__c = parentAsset.Id; 
            clonedAssets.add(clonedAsset); 
            
        }
    }
        
                // Créer un nouvel InwiB2C_MigratedAssets__c à insérer
                InwiB2C_MigratedAssets__c migratedAsset = new InwiB2C_MigratedAssets__c();
                migratedAsset.InwiB2C_AssetId__c = parentAsset.Id;
                migratedAsset.InwiB2C_Statut__c = 'New';
                
                migratedAssets.add(migratedAsset);
                
                // Mettre à jour le statut et l'ID de la souscription dans l'enregistrement
                record.InwiB2C_Statut__c = 'Done';
                record.InwiB2C_Subscription__c = parentAsset.vlocity_cmt__SubscriptionId__r.Id;
}     
   }
        
       // Insérer les nouveaux enregistrements clonés avec des IDs générés automatiquement
       if (!clonedAssets.isEmpty()) {
        insert clonedAssets;
   }
        
  
        // Insérer les nouveaux InwiB2C_MigratedAssets__c
        if (!migratedAssets.isEmpty()) {
            System.debug('migratedAssets: ' + migratedAssets);
            insert migratedAssets;
        }
        // Supprimer les éléments d'inventaire de la liste
       try {
           delete listOfInventoryItemRels2;
           delete listInventoryItems;
           System.debug(' listOfInventoryItemRels deleted ');
          } catch (Exception e) {
         // Gérer l'exception de suppression
        System.debug('Erreur lors de la suppression des enregistrements associés : ' + e.getMessage());
         }

        // Mettre à jour les enregistrements de l'objet InwiB2C_AddOptionsTemp__c
        System.debug('records: ' + records);
        update records;
    }

    // La méthode finish est appelée à la fin du traitement par batch
    public void finish(Database.BatchableContext context) {
        System.debug('Batch processing completed successfully.');

}
}