@isTest
public class InwiB2C_OTP_Test {
@isTest 
    static void InwiB2C_OTP_Test(){
        Test.startTest(); 

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
           vlocity_cmt__Subscription__c newSubsc1=  new vlocity_cmt__Subscription__c (vlocity_cmt__SubscriptionNumber__c='testNumber',Inwib2c_Num_ro_de_la_ligne__c='212123456789',Name='TEST',inwiB2C_Statut__c='InwiB2C_Active',vlocity_cmt__Status__c='Active');
        insert newSubsc1;
        Account acc = new Account();
        acc.name = 'testacc';
		insert acc;
        order testorder = new order();
        testorder.name = 'test';
        testorder.Status = 'Draft';
        testorder.EffectiveDate = Date.today();
		testorder.AccountId = acc.Id;
		insert testorder;
        InwiB2C_Demande_de_resiliation__c resil = new InwiB2C_Demande_de_resiliation__c ();
        resil.inwiB2C_num_Ligne__c = newSubsc1.Inwib2c_Num_ro_de_la_ligne__c;
        resil.InwiB2C_Subscription__c = newSubsc1.Id;
        insert resil;
        inputMap.put('mdn','123456789');
        inputMap.put('mode','email');
        inputMap.put('email','ettahiri2016amine@gmail.com');
        inputMap.put('canal','inwiB2C_Televente');
        inputMap.put('orderid',testorder.Id);
        inputMap.put('requestresilid',resil.Id);
        
        Account testAccount = new Account();
        testAccount.Name='Test Account';
        insert testAccount;
        order neworder = new Order (inwiB2C_Statut__c ='inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId =testAccount.Id);
        insert neworder;
        inputMap.put('orderid',neworder.Id);
        new InwiB2C_OTP().invokeMethod('GenerateOtp',inputMap,outMap,options);
        InwiB2C_OTP__c OtpStatut = new InwiB2C_OTP__c();
        //OtpStatut.InwiB2C_StatutOtpTelevent__c = 'Authentifié';
		//OtpStatut.InwiB2C_MDN__c = newSubsc1.Inwib2c_Num_ro_de_la_ligne__c;
        insert OtpStatut;
        inputMap.put('mode','sms');
        
        new InwiB2C_OTP().invokeMethod('GenerateOtp',inputMap,outMap,options);
        InwiB2C_OTP__c  OTPObject = new InwiB2C_OTP__c();
        OTPObject.InwiB2C_Otp__c = 12345;
        OTPObject.InwiB2C_DateExpiration__c=datetime.now().addSeconds(5);
        OTPObject.InwiB2C_DateCreation__c = datetime.now();
        OTPObject.InwiB2C_MDN__c='212123456789';
        OTPObject.InwiB2C_StatutOtp__c= 1;
        OTPObject.InwiB2C_Email__c= 'ettahiri2016amine@gmail.com';
        insert OTPObject;
        INWIB2C_SMSPush__mdt pushsms = new INWIB2C_SMSPush__mdt(
			login__c = 'mylogin',
			password__c = 'mypassword',
			Sender__c = 'mysender',
			creator__c = 'mycreator'
			);
        
			String mdn = '0123456789';
			String message = 'Hello, Test world!';
    
     
        inputMap.put('mdn','212123456789');
        inputMap.put('codeOtp','12345');
        inputMap.put('email','ettahiri2016amine@gmail.com');
        new InwiB2C_OTP().invokeMethod('Verifie',inputMap,outMap,options);
        new InwiB2C_OTP().invokeMethod('aaaaaa',inputMap,outMap,options);
        inputMap.put('mdn','');
        inputMap.put('codeOtp','');
        inputMap.put('email','');
        //inputMap.put('canal','inwiB2C_Televente');
        
        new InwiB2C_OTP().invokeMethod('Verifie',inputMap,outMap,options);
        
        // Création d'un OTP avec le même MDN
        InwiB2C_OTP__c otpRecord = new InwiB2C_OTP__c(
            InwiB2C_Otp__c = 12345,
            InwiB2C_DateExpiration__c = DateTime.now().addMinutes(5),
            InwiB2C_DateCreation__c = DateTime.now(),
            InwiB2C_MDN__c = '123456789',
            InwiB2C_StatutOtpTelevent__c = 'En attente'
        );
        insert otpRecord;
        
        inputMap.put('mdn', '123456789');
        inputMap.put('canal', 'Televente');

        new InwiB2C_OTP().invokeMethod('GenerateOtp', inputMap, outMap, options);

        System.assert(!outMap.isEmpty(), 'L\'output map ne devrait pas être vide après la récupération de l\'OTP.');
        System.assertEquals('123456789', otpRecord.InwiB2C_MDN__c, 'Le MDN doit correspondre à celui de l\'OTP récupéré');
        Test.stopTest();
        
        
        
		
}
}