@isTest
public class InwiB2C_VOCCloseTheLoopTest {
    @isTest
    static void testCallVIPAction() {

        List<String> inputs = new List<String>();
        inputs.add('{"id_enquete": "a9E3L0000002CTvUAM","cat_insatisfaction_q1": "Offres & Services","type_insatisfaction_q1": "Fid", "detail_insatisfaction_q1": "Programme Fidélin","raison_insatisfaction_q1": "1","motif_insatisfaction_q2": "1", "raison_insatisfaction_q2": "1", "mdn": "212678877899","email": "test@test.com","id_client": ""}');
        
        Test.startTest();
        InwiB2C_VOCCloseTheLoop.CallVIP(inputs);
        Test.stopTest();
        
    }
    
}