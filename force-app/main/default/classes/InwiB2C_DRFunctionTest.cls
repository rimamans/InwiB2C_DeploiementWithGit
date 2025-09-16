@isTest
public class InwiB2C_DRFunctionTest{
    
    @isTest
    static void toLabelTest(){
        InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Case requete = new Case(InwiB2C_CanalUser__c='InwiB2C_CRC');
        insert requete;
        List<Object> arguments = new List<Object>();
        arguments.add('Case');
        arguments.add('InwiB2C_CanalUser__c');
        arguments.add(requete.Id);
        Map<String, Object> input= new Map<String, Object>();
        input.put('arguments', arguments);
    	Map<String,Object> output = new Map<String,Object>();
    	Map<String,Object> options = new Map<String,Object>();
    	boolean result = cls.invokeMethod('toLabel',input,output,options);
    }
    /*B-15152 21/05/2024 Ila Start*/
    @isTest
    static void elligibleCHT(){
        InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        InwiB2C_Commande_de_degroupage__c commande1 = new InwiB2C_Commande_de_degroupage__c();
        insert commande1;
        InwiB2C_Commande_de_degroupage__c commande2 = new InwiB2C_Commande_de_degroupage__c();
        insert commande2;
        INWIB2C_DEMANDE_DEGROUPAGE__c demande1 = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commande1.Id,InwiB2C_ndOperateur__c='0522324455',InwiB2C_Statutdegroupage__c='REU',InwiB2C_typeCommande__c='CT');
        insert demande1;
        INWIB2C_DEMANDE_DEGROUPAGE__c demande2 = new INWIB2C_DEMANDE_DEGROUPAGE__c(InwiB2C_Commande_de_degroupage__c=commande2.Id,InwiB2C_ndOperateur__c='0522324455',InwiB2C_Statutdegroupage__c='REJ',InwiB2C_typeCommande__c='CT');
        insert demande2;
        List<Object> data = new List<Object>();
        data.add('0522324455');
        inputMap.put('arguments', data);
        boolean result = cls.invokeMethod('elligibleCHT', inputMap, outMap, options);
    }
    /*B-15152 21/05/2024 Ila End*/
    
    @isTest
    static void formatInputImxTest(){
        InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        List<Object> data = new List<Object>();
        data.add('a');
        data.add('b');
        data.add('c');
        data.add('ADSL');
        data.add('d');
        data.add('e');
        inputMap.put('arguments', data);
        boolean result = cls.invokeMethod('formatInputImx', inputMap, outMap, options);
    }
    /*Boost FTTH ILA 05/06/2024  Start */
    @isTest
    static void eligibileBoostFTTHTest(){
         InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
        Account testAccount = new Account(Name='client');
        insert testAccount;
        Account testBillingAccount = new Account(Name='billing',Inwib2c_Type_d_offre__c='Postpayé',vlocity_cmt__BillCycle__c='18');
        insert testBillingAccount;
        vlocity_cmt__Subscription__c ligne=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='0611223344',vlocity_cmt__AccountId__c=testAccount.id, vlocity_cmt__BillingAccountId__c=testBillingAccount.id);
        insert ligne;
        Product2 prodTerminal = new Product2(Name = 'FTTH', ProductCode='INWIB2C_OFFERING_FTTH20MG_249DH');
        insert prodTerminal;
        Asset assetFTTH = new Asset( Name = 'Test Asset',Status = 'Installed',AccountId = testAccount.Id,InstallDate = System.Today(),UsageEndDate = System.Today(), vlocity_cmt__SubscriptionId__c = ligne.Id);
        insert assetFTTH;
        InwiB2C_Historique_Boost_FTTH__c hist = new InwiB2C_Historique_Boost_FTTH__c (InwiB2C_Prix__c=50,InwiB2C_Account__c=testAccount.id,InwiB2C_Date_activation__c=System.today());
        insert hist;
        
        List<Object> data = new List<Object>();
        data.add(ligne.id);
        inputMap.put('arguments', data);
        boolean result = cls.invokeMethod('eligibileBoostFTTH', inputMap, outMap, options);
        
        
    }
    /*Boost FTTH ILA 05/06/2024  End */
     /**Confirmation MES 25/09/2024 Start */
    @istest
    static void HoursDiffTest(){
        InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        List<Object> data = new List<Object>();
        DateTime dt1 = DateTime.now().addDays(-1);
		DateTime dt2 = DateTime.now();
        data.add(dt1.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
        data.add(dt2.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
        inputMap.put('arguments', data);
        boolean result = cls.invokeMethod('HoursDiff', inputMap, outMap, options);
        
    }
    
    @istest
    static void calculWorkingDayTest(){
        InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        List<Object> data = new List<Object>();
        DateTime dt1 = system.now();
        data.add(dt1.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
        data.add('5');
        inputMap.put('arguments', data);
        boolean result = cls.invokeMethod('calculWorkingDay', inputMap, outMap, options);
        
    }
    
       @istest
    static void WorkDayCounterTest(){
        InwiB2C_DRFunction cls = new InwiB2C_DRFunction();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        List<Object> data = new List<Object>();
        DateTime dt1 = system.now();
        data.add(dt1.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
        inputMap.put('arguments', data);
        boolean result = cls.invokeMethod('WorkDayCounter', inputMap, outMap, options);
        
    }
     /**Confirmation MES 25/09/2024 End */
    
    

}