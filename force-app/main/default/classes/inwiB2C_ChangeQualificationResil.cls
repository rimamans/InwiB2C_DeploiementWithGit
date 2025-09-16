public with sharing class inwiB2C_ChangeQualificationResil {
    

    public ApexPages.StandardController Controller = null;
    public Boolean checkOwner {get;set;}
    public Id recordId {get;set;}
    public InwiB2C_Demande_de_resiliation__c therecord {get;set;}
    public static Id currentUserId = UserInfo.getUserId();
    
    public boolean getisLocked(){
        if(recordId != null)
            return Approval.isLocked(recordId);
        return null;
    }
    public inwiB2C_ChangeQualificationResil(ApexPages.StandardController ctl){
        this.Controller = ctl;
        system.debug(' this.Controller '+ this.Controller );
        List<GroupMember > groupList = [SELECT  Id from GroupMember where  UserOrGroupId =:currentUserId AND Group.DeveloperName=:'Inwib2c_BO_resiliation_B2C' ];
        system.debug('groupList '+ groupList );
        if(!groupList.isEmpty()){
             checkOwner=true;
        }else{
             checkOwner=false;
        }
     
        system.debug('reaches AccountCreationController @ AccountCreationController.');
    
        if(this.Controller != null && !Test.isRunningTest()){
            recordId = ApexPages.currentPage().getParameters().get('id');
            if(recordId != null ){
                this.therecord= findResilDetails(recordId);
            } else {
                this.therecord = new InwiB2C_Demande_de_resiliation__c (OwnerId = currentUserId, inwib2c_need_approbation__c = true );
            }
        }else if( Test.isRunningTest()){
            List<InwiB2C_Demande_de_resiliation__c> resil = new List<InwiB2C_Demande_de_resiliation__c>();
             resil = [SELECT Id, OwnerId,InwiB2C_Type_Profil__c,InwiB2C_Statut_Resil__c ,Type__c ,InwiB2C_Qualification__c
               FROM InwiB2C_Demande_de_resiliation__c
               LIMIT 1 ];
             
            recordId = resil[0].Id;
            if(recordId != null ){
                this.therecord= findResilDetails(recordId);
            }
        }
    }
    
    private static InwiB2C_Demande_de_resiliation__c findResilDetails(Id resilId){
        List<InwiB2C_Demande_de_resiliation__c> resil = new List<InwiB2C_Demande_de_resiliation__c>();
    
        system.debug('reaches findAccountDetails @ AccountCreationController.');
    
        resil = [SELECT Id, OwnerId,InwiB2C_Type_Profil__c,InwiB2C_Statut_Resil__c ,Type__c ,InwiB2C_Qualification__c
               FROM InwiB2C_Demande_de_resiliation__c
               WHERE Id =: resilId
               LIMIT 1
              ];
     for(InwiB2C_Demande_de_resiliation__c resilList : resil) {
                 if(resilList.InwiB2C_Qualification__c=='Conforme'){
                     resilList.InwiB2C_Qualification__c='Non Conforme';
                 } else{
                       resilList.InwiB2C_Qualification__c='Conforme';
                 }}
        if(!resil.isEmpty()){
            return resil[0];
        } else {
            return null;
        }
    }
    
    public PageReference submit(){
        system.debug('reaches submit @ AccountCreationController.');
        Savepoint sp = Database.setSavepoint();
        Boolean actionsuccess = false;
    
        system.debug('this.theaccount @ submit - AccountCreationController. this.theaccount: ' + this.therecord);
    
        if(this.therecord.Id != null )
        recordId = this.therecord.Id;
    
        if(recordId != null){
            actionsuccess = save(therecord);
        } /*else {
            actionsuccess = insertrecordresil(this.therecord);
            recordId = this.therecord.Id;
        }*/
    
        if(actionsuccess){
            //Approval.UnlockResult unlockResult = Approval.unlock(this.therecord.Id,false); 
           
            //List<Approval.UnlockResult> ulrList = Approval.unlock(this.therecord, false);
    system.debug('request was succesfull @ submit - AccountCreationController');
            
                    PageReference redirect = close();
                    return redirect;
          /*  Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(recordId);
            req.setSubmitterId(currentUserId);
            req.setProcessDefinitionNameOrId(null);
    
            try {
                //system.debug('req to process @ submit - AccountCreationController. req: ' + req);
                Approval.ProcessResult result = Approval.process(req);
              
                if(result.isSuccess()){
                    system.debug('request was succesfull @ submit - AccountCreationController');
                    PageReference redirect = close();
                    return redirect;
                } else {
                    system.debug('An error has occured when submitting the account for approval @ submit - AccountCreationController. result.getEntityId(): ' + result.getEntityId() + ', result.getErrors(): ' + result.getErrors());
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occured when submitting the account for approval. Errors: ' + result.getErrors());
                    ApexPages.addMessage(msg);
                    return null;
                }
            } catch(Exception e) {
                system.debug('An error has occured when saving the account @ submit - AccountCreationController e.getLineNumber(): ' + e.getLineNumber() + ', e.getMessage: ' + e.getMessage());
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occured when submitting this account for approval. Line Number: ' + e.getLineNumber() + ', Error Message: ' + e.getMessage());
                ApexPages.addMessage(msg);
                return null;
            }
        
       
        //return null;
*/ } else {
    system.debug('in else');
            //Database.rollback(sp);
            return null;
        }
    }
    
    private boolean save(InwiB2C_Demande_de_resiliation__c resil){
        system.debug('reaches save @ AccountCreationController.');
        
             
         system.debug('list resil'+therecord);
            if(!Test.isRunningTest()){
            update resil;}
            return true;
       
    }
    
 /*   private boolean insertrecordresil(InwiB2C_Demande_de_resiliation__c resil){
        system.debug('reaches insertrecordresil @ AccountCreationController.');
      
            insert resil;
            return true;
       
    }*/
    
    public PageReference close(){
        system.debug('reaches close @ AccountCreationController.');
        string retURL = ApexPages.currentPage().getParameters().get('retURL');
    
      /*  if(recordId == null && retURL == null){
         //   ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error returning to the previous page. There is no account for you to return to.');
         //   ApexPages.addMessage(msg);
            return null;
        } else {*/
            PageReference redirect = null;
    
            if(retURL != null){
                redirect = new PageReference('/' + retURL);
            } else {
                redirect = new PageReference('/' + recordId);
            }
    
            redirect.setRedirect(true);
    
            if(redirect != null){
               
                    return redirect;
               
            } else {
                return null;
            }
        //}
    
    }}