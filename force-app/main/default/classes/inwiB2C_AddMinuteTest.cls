@isTest
public class inwiB2C_AddMinuteTest{
  @isTest(SeeAllData = true)
  static void addminute(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    boolean result = cls.invokeMethod('Add', inputMap, outMap, options);
  }

  @isTest(SeeAllData = true)
  static void addminuteTestformatInput(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    List<Object> data = new List<Object>();
    data.add('a');
    data.add('b');
    data.add('c');
    data.add('d');
    inputMap.put('arguments', data);

    boolean result = cls.invokeMethod('formatInput', inputMap, outMap, options);
  }

  @isTest(SeeAllData = true)
  static void addminuteTestgetValuefromJson(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    List<Object> data = new List<Object>();
    data.add('test');
    data.add('test');
    inputMap.put('arguments', data);

    boolean result = cls.invokeMethod('getValuefromJson', inputMap, outMap, options);
  }

  @isTest(SeeAllData = true)
  static void addminuteTestgetDisplayTextfromJson(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    List<Object> data = new List<Object>();
    data.add('test');
    data.add('test');
    inputMap.put('arguments', data);

    boolean result = cls.invokeMethod('getDisplayTextfromJson', inputMap, outMap, options);
  }

  @isTest(SeeAllData = true)
  static void addminuteTestgetAttributesFromJson(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    List<Object> data = new List<Object>();
    // data.add('test');
    // Account testAccount = new Account();
    // testAccount.Name = 'TestJson';
    // insert testAccount;
    // Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'INWIB2C_OFFERING_49DH_APL');
    // insert prod;

    // // Subscription
    // vlocity_cmt__Subscription__c newSubsc1 = new vlocity_cmt__Subscription__c(Inwib2c_Offre__c = 'offer1', vlocity_cmt__SubscriptionNumber__c = '0611223344', Inwib2c_Num_ro_de_la_ligne__c = '0611223344', Name = 'TEST', inwiB2C_LegacyStatus__c = 'ACTIVE', inwiB2C_Statut__c = 'InwiB2C_Active', vlocity_cmt__Status__c = 'Active', vlocity_cmt__AccountId__c = testAccount.Id);
    // Insert newSubsc1;

    // String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJaQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86906,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013Io7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86906","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}],"values":[{"id":"870a4b4e-1761-53bf-4990-0a29151c00d9","displayText":"Forfait 49dhs Appels","value":"86906","sequence":20},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}},"$$AttributeDefinitionEnd$$":null}]}';


    // Asset asset1 = new Asset(Name = 'Test Asset', vlocity_cmt__Action__c= 'Add', AccountId = testAccount.Id, vlocity_cmt__SubscriptionId__c = newSubsc1.Id, Product2Id = prod.Id, vlocity_cmt__JSONAttribute__c = JsonAttr, vlocity_cmt__RecurringCharge__c = 90);
    // insert asset1;
    //data.add(newSubsc1.Id);
    data.add('id');
    inputMap.put('arguments', data);

    boolean result = cls.invokeMethod('getAttributesFromJson', inputMap, outMap, options);
  }

  @isTest(SeeAllData = true)
  static void addminuteTestGetOrderEnCoursOfSubscription(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    List<Object> data = new List<Object>();

    //
    Account testAccount = new Account();
    testAccount.Name = 'Test Account';
    insert testAccount;

    List<Order> ListOrders = new List<Order>();
    order neworder1 = new Order(inwiB2C_Statut__c = 'inwiB2C_EnCours', EffectiveDate = Date.today().addDays(-1), inwiB2C_TypeActeDeGestion__c = 'inwiB2C_Resiliation', inwib2c_TypeDeLaCommande__c = 'inwiB2C_Modification', Status = 'Draft', AccountId = testAccount.Id);
    insert neworder1;

    vlocity_cmt__Subscription__c ligne = new vlocity_cmt__Subscription__c(Inwib2c_Num_ro_de_la_ligne__c = '212612345678', vlocity_cmt__SubscriptionNumber__c = '999', Inwib2c_Offre__c = 'Mobile a la carte', inwiB2C_LegacyStatus__c = 'ACTIVE');
    insert ligne;

    inwiB2C_OrderSubscription__c orderSubscription = new inwiB2C_OrderSubscription__c( inwiB2C_Order__c = neworder1.Id, inwiB2C_Subscription__c = ligne.Id);
    insert orderSubscription;

    data.add(ligne.id);
    inputMap.put('arguments', data);

    boolean result = cls.invokeMethod('GetOrderEnCoursOfSubscription', inputMap, outMap, options);
  }
 @isTest(SeeAllData = true)
  static void TestgetAllAttributesFromJson(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    List<Object> data = new List<Object>();
    data.add('id');
    inputMap.put('arguments', data);

    boolean result = cls.invokeMethod('getAllAttributesFromJson', inputMap, outMap, options);
  }
   @isTest(SeeAllData = true)
      static void TestAddHoursMinute(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
    boolean result = cls.invokeMethod('AddHoursMinute', inputMap, outMap, options);
  }

  @isTest(SeeAllData = true)
      static void TestcycleFact(){
    inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, Object> inputMap = new Map<String, Object>();
      List<Object> data = new List<Object>();
    data.add('2023-03-28 17:48:22');
    inputMap.put('arguments', data);
    boolean result = cls.invokeMethod('cycleFact', inputMap, outMap, options);
  }
    //chb 15/05/2024 begin */
    
   @isTest(SeeAllData = true)
      static void FormatReglette(){
            inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
            Map<String, Object> options = new Map<String, Object>();
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            List<Object> data = new List<Object>();
            data.add('id');
            inputMap.put('arguments', data);
            boolean result = cls.invokeMethod('FormatReglette', inputMap, outMap, options);
      }
     @isTest(SeeAllData = true)
      static void FormatInputs(){
            inwiB2C_AddMinute cls = new inwiB2C_AddMinute();
            Map<String, Object> options = new Map<String, Object>();
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            List<Object> data = new List<Object>();
            data.add('nd');
           	data.add('ndOperateur');
           	data.add('ndPrecedent');
            inputMap.put('arguments', data);
            boolean result = cls.invokeMethod('FormatInputs', inputMap, outMap, options);
      }
      //chb 15/05/2024 end */
}