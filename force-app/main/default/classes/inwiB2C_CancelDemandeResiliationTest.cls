@isTest
public  class inwiB2C_CancelDemandeResiliationTest {

    @isTest
    static void testCancelDemandeResiliation() {

        InwiB2C_Demande_de_resiliation__c demande = new InwiB2C_Demande_de_resiliation__c();

        Account client = new Account();

        client.name = 'TestDemandeResil';
        client.AccountNumber = '0001111';

        insert client;

        /*Product2 product = new Product2 ();
        product.name ='TestProduct';
        product.productCode = 'TEST';

        insert product;

        Asset asset = new Asset();
        asset.accountId = client.id;
        asset.product2Id = product.id;
        asset.Name = 'Test';

        insert asset;*/

        vlocity_cmt__Subscription__c subscription = new vlocity_cmt__Subscription__c();

        subscription.Name = '21299999999';
        subscription.vlocity_cmt__AccountId__c = client.id;
        subscription.vlocity_cmt__Status__c = 'Active';
        subscription.vlocity_cmt__SubscriptionNumber__c = 'TEST012345678';


        insert subscription;

        demande.InwiB2C_Account__c = client.id;
        demande.InwiB2C_Date_de_signature__c = Date.today();
        demande.InwiB2C_Statut_Resil__c = 'En cours de validation BO';
        demande.InwiB2C_Statut_R_tention__c = 'Non Retenu';
        demande.InwiB2C_Subscription__c = subscription.id;
        demande.inwiB2C_Canal__c = 'CRC';
        demande.inwiB2C_num_Ligne__c = subscription.Name;
        demande.InwiB2C_Type_Profil__c = 'idar duo';
        demande.inwib2c_need_approbation__c = true;


        insert demande;

        /*Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(demande.id);

        Approval.ProcessResult processResult = Approval.process(req);
        //Valid values are: Approved, Rejected, Removed or Pending.
        System.assertEquals('Pending', processResult.getInstanceStatus());*/

        inwiB2C_CancelDemandeResiliation cancelDemande = new inwiB2C_CancelDemandeResiliation();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>(); 
        Map<String, Object> options = new Map<String, Object>();

        inputs.put('idrequesttocancel', demande.id);
        inputs.put('motifcancel', 'TestAnulation');

        Boolean result = cancelDemande.invokeMethod('cancelDemandeResilaition', inputs, output, options);






    }
}