trigger INWIB2C_shareKnowledgeFilesWithCommunityUsers on ContentDocumentLink (before insert) {
    for (ContentDocumentLink cdl : Trigger.new) {
          if (cdl.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Knowledge__kav') {
               cdl.visibility = 'AllUsers';
          }
     }
}