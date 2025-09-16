public with sharing class inwiB2C_CustomerInteractionMgt {
    
    public static String createCustomerInteraction(Id AccountId, Map<String , Object> ctiInput ){

        try {

            String status;

            //System.debug(JSON.serialize(ctiInput));

            String ctiIteractionNumber = (String) ctiInput.get('ctiIteractionNumber');
            Map<String , Object> data = (Map<String , Object>) ctiInput.get('data');

            vlocity_cmt__CustomerInteraction__c customerInteraction = new vlocity_cmt__CustomerInteraction__c();

            if (data != null){

                String ctiSource = (String) data.get('ctiSource');
                String ctiEmailSource = (String) data.get('ctiEmailSource');
                String ctiFacebookId = (String) data.get('ctiFacebookId');
                String ctiTwitterId = (String) data.get('ctiTwitterId');
                String ctiMDN = (String) data.get('ctiMDN');
                String unhandledCall = (String) data.get('unhandledCall');
                String transferedCall = (String) data.get('transferedCall');
                status = (String) data.get('status');

                customerInteraction.inwiB2C_CTI_Media__c = ctiSource;
                customerInteraction.inwiB2C_SourceEmail__c = ctiEmailSource;
                customerInteraction.inwiB2C_FacebookId__c = ctiFacebookId;
                customerInteraction.inwiB2C_TwitterId__c = ctiTwitterId;
                customerInteraction.inwiB2C_CTI_MDN__c = ctiMDN;
                customerInteraction.inwiB2C_unhandledCall__c = unhandledCall;
                customerInteraction.inwiB2C_TransferedCall__c = transferedCall;

            }

            if (AccountId != null) {
                Account account = [SELECT Id, vlocity_cmt__PersonContactId__c FROM Account WHERE Id = :AccountId];

                customerInteraction.vlocity_cmt__AccountId__c = AccountId;
                customerInteraction.vlocity_cmt__ContactId__c = account.vlocity_cmt__PersonContactId__c;

            }

            String contactId = (String) data.get('contactId');

            if (contactId != null){

                customerInteraction.vlocity_cmt__ContactId__c = contactId;

            }


            
           
            customerInteraction.vlocity_cmt__Channel__c = 'Contact Center';
        
            customerInteraction.vlocity_cmt__StartDateTime__c = Datetime.now();
            customerInteraction.vlocity_cmt__Status__c = (status == null) ?'In Progress':status;
            customerInteraction.vlocity_cmt__Type__c = 'Call';
            customerInteraction.inwiB2C_CTIInteractionId__c = ctiIteractionNumber;

            if (status != null && status.equals('Completed')) {
                customerInteraction.vlocity_cmt__EndDateTime__c = Datetime.now();
            }
            

            Insert customerInteraction;

            return customerInteraction.id;


        }catch (Exception e){
            System.debug(e.getMessage());
            return null;
        }



    }

    public static void updateCustomerInteraction(Id VlocityInteractionId, String unhandledCall, String transferedCall ){

        if (VlocityInteractionId != null) {

            vlocity_cmt__CustomerInteraction__c interaction = [SELECT Id, Name from vlocity_cmt__CustomerInteraction__c where Id = :VlocityInteractionId];

            if (interaction != null) {
                try {

                    interaction.inwiB2C_unhandledCall__c = unhandledCall;
                    interaction.inwiB2C_TransferedCall__c = transferedCall;
                    interaction.vlocity_cmt__Status__c = 'Completed';
                    interaction.vlocity_cmt__EndDateTime__c = Datetime.now();

                    update interaction;

                }catch (Exception e){
                    System.debug(e.getMessage());
                }
                


            }

        }
        
        



    }

}