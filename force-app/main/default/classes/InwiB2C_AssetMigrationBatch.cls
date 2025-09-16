global class InwiB2C_AssetMigrationBatch implements Database.Batchable<sObject>{
        String query;
        String email;
        Id toUserId;
        Id fromUserId;

        private DateTime myLastModifiedDate;
        private Integer LevelParam;

        global InwiB2C_AssetMigrationBatch(DateTime LastModifiedDate, Integer TheChosenLevel) {
            myLastModifiedDate = LastModifiedDate;
            LevelParam = TheChosenLevel;
        }
        
        public Database.querylocator start(Database.BatchableContext BC){
            if(!Test.isRunningTest()) {
                return Database.getQueryLocator(
                    'SELECT ProductCode, Id, ParentId, vlocity_cmt__ParentItemId__c, RootAssetId, vlocity_cmt__RootItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where inwiB2C_Legacy_Id__c != null and CreatedDate >= :myLastModifiedDate and AssetLevel = :LevelParam'
                );
            }
            else
            {
                return Database.getQueryLocator(
                    'SELECT ProductCode, Id, ParentId, vlocity_cmt__ParentItemId__c, RootAssetId, vlocity_cmt__RootItemId__c, inwiB2C_Legacy_Id__c, vlocity_cmt__ProductHierarchyPath__c, AssetLevel,Product2Id,  Parent.Product2Id, Parent.Parent.Product2Id, vlocity_cmt__ProductHierarchyGroupKeyPath__c, vlocity_cmt__ProductGroupKey__c, parent.vlocity_cmt__ProductGroupKey__c, Parent.Parent.vlocity_cmt__ProductGroupKey__c from ASSET where inwiB2C_Legacy_Id__c != null and CreatedDate >= :myLastModifiedDate and AssetLevel = :LevelParam limit 10'
                );
            }
            
        }

         
        public void execute(Database.BatchableContext BC, List<Asset> scope){

            for (Asset assetToUpdate: scope){
                assetToUpdate.vlocity_cmt__ParentItemId__c = assetToUpdate.ParentId;
                assetToUpdate.vlocity_cmt__RootItemId__c = assetToUpdate.RootAssetId;

                if (assetToUpdate.AssetLevel == 1){
                    assetToUpdate.vlocity_cmt__ProductHierarchyPath__c = assetToUpdate.Product2Id;
                    assetToUpdate.vlocity_cmt__ProductHierarchyGroupKeyPath__c = assetToUpdate.vlocity_cmt__ProductGroupKey__c;
        
                }else if (assetToUpdate.AssetLevel == 2){
                    assetToUpdate.vlocity_cmt__ProductHierarchyPath__c = assetToUpdate.Parent.Product2Id + '<' + assetToUpdate.Product2Id;
                    assetToUpdate.vlocity_cmt__ProductHierarchyGroupKeyPath__c = assetToUpdate.Parent.vlocity_cmt__ProductGroupKey__c + '<' + assetToUpdate.vlocity_cmt__ProductGroupKey__c ;
        
                }else if (assetToUpdate.AssetLevel == 3){
                    assetToUpdate.vlocity_cmt__ProductHierarchyPath__c =  assetToUpdate.Parent.Parent.Product2Id + '<' + assetToUpdate.Parent.Product2Id + '<' + assetToUpdate.Product2Id ;
                    assetToUpdate.vlocity_cmt__ProductHierarchyGroupKeyPath__c = assetToUpdate.Parent.Parent.vlocity_cmt__ProductGroupKey__c + '<' + assetToUpdate.Parent.vlocity_cmt__ProductGroupKey__c + '<' + assetToUpdate.vlocity_cmt__ProductGroupKey__c ;
        
                }
                //Update assetToUpdate;
            }

            update scope;
            
        }
        public void finish(Database.BatchableContext BC){
                  AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
              a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
              a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         
        String[] email = new String[]{'jawad.bentaybi@atos.net'};
        mail.setToAddresses(email);
        mail.setReplyTo('jawad.bentaybi@atos.net');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed'+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures '+' Job Itemprocessed are '+a.JobItemsProcessed);
         
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
        }