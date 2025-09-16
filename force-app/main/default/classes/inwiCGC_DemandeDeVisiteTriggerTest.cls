@isTest
public class inwiCGC_DemandeDeVisiteTriggerTest {
    @isTest
    static void inwiCGC_DemandeDeVisiteTriggerTest(){
        inwiCGC_DemandeDeVisite__c DV= new inwiCGC_DemandeDeVisite__c();
        DV.Name='Name';
        DV.Planned_End_Time__c=System.Today();
        DV.Planned_Start_Time__c=Date.today().addDays(1);
        insert DV;
        DV.Name='Analyse marché Fixe Juin 2023';
        DV.Status__c = 'inwiCGC_Valide';
        update DV;
    }
}