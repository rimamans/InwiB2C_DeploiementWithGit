@isTest
public class InwiB2C_InvokeCreateDemandeFlowTest {
    @isTest(SeeAllData=false)
    static void updateDemandeDeg(){
        INWIB2C_DEMANDE_DEGROUPAGE__c  demande = new INWIB2C_DEMANDE_DEGROUPAGE__c ();
        insert demande;
        Account account = new Account(Name='Test Account');
        insert account;
        Order order = new Order(Status = 'Draft', EffectiveDate = Date.today().addDays(-1),AccountId =account.Id);
        insert order;
        Map<String, Object> input = new Map<String, Object>();
        input.put('demandeId',demande.Id);
        input.put('orderId',order.Id);
        Map<String,Object> output = new Map<String,Object>();
    	Map<String,Object> options = new Map<String,Object>();
        //InwiB2C_InvokeCreateDemandeFlow createDemande = new InwiB2C_InvokeCreateDemandeFlow();
        InwiB2C_InvokeCreateDemandeFlow.invokeMethod('invokeFlow',input,output,options);
    }

}