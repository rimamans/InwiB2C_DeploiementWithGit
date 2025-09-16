/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class inwiB2C_AddMinute implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        if (methodName == 'Add'){
            output.put('result', Add());
        }

        if (methodName == 'formatInput'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', FormatInput(arguments));
        }
           
        if (methodName == 'FormatInputs'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', FormatInputs(arguments));
        }

        if (methodName == 'getValuefromJson'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', getValuefromJson(arguments));
        }

        if (methodName == 'getDisplayTextfromJson'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', getDisplayTextfromJson(arguments));
        }

        if (methodName == 'getAttributesFromJson'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', getAttributesFromJson(arguments));
        }

        if (methodName == 'GetOrderEnCoursOfSubscription'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', GetOrderEnCoursOfSubscription(arguments));
        }
        if (methodName == 'getAllAttributesFromJson'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', getAllAttributesFromJson(arguments));
        }
        if (methodName == 'getAllAttributesFortaFixe'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');          
            output.put('result', getAllAttributesFortaFixe(arguments));
        }
       
         if (methodName == 'AddHoursMinute'){
            output.put('result', AddHoursMinute());
        }
 
        if (methodName == 'cycleFact'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', cycleFact(arguments));
        }
        if (methodName == 'FormatReglette'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', FormatReglette(arguments));
        }
           
        return true;
    }

    String Add(){
        return System.now().addMinutes(5).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
    }
    String FormatReglette(List<Object> arguments) {
        String regletteValue =String.valueOf(arguments[0]); 
        System.debug('newreglette'+regletteValue); 
        if (regletteValue.length()== 1) {
            return '00000' + regletteValue;
        } else if (regletteValue.length() == 2) {
            return '0000' + regletteValue;
        } else if (regletteValue.length() == 3) {
            return '000' + regletteValue;
        }  else if (regletteValue.length() == 4) {
            return '00' + regletteValue;
        }  else if (regletteValue.length() == 5) {
            return '0' + regletteValue;
        } else {
            return regletteValue;
        }
       
       
    }
    String cycleFact(List<Object> arguments) {
        System.debug('in method');
        String cycleFact =String.valueOf(arguments[0]);   
        Date sampleDate = Date.valueOf(cycleFact);
        Date x= sampleDate.addDays(-1);
        String cycleFact1 =String.valueOf(x);
        System.debug(sampleDate);
        System.debug('date: '+x);
        return cycleFact1;
     }
    List<Map<String, Object>> FormatInput(List<Object> arguments){
        List<Map<String, Object>> output = new List<Map<String, Object>>();

        for (Integer i = 0; i < arguments.size(); i++){
            Map<String, Object> item = new Map<String, Object>();
            item.put('value', arguments[i] != null && arguments[i] != 'null' ? arguments[i] : '');
            switch  on i{
                when 0{
                    item.put('code', 'DISTRIBUTOR');
                }
                when 1{
                    item.put('code', 'ENGAGEMENT');
                }
                when 2{
                    item.put('code', 'IN_TSRM');
                }
                when 3{
                    item.put('code', 'CONTRACT_TYPE');
                }
                when 4{
                    item.put('code', 'ACCESS_TECHNOLOGY');
                }
            }
            output.add(item);
        }

        return output;
    }

    String getValuefromJson(List<Object> arguments){

        String outpout = '';
        Map<String, Object> json = new Map<String, Object>();
        // Inputs

        String attribut = String.valueOf(arguments[1]);
        if (!Test.isRunningTest()){
            Id idOrderItem = (Id) arguments[0];
            System.debug('inputs --------< ' + idOrderItem);
            System.debug('inputs attribut --------< ' + attribut);
            OrderItem selectedOrderItem = [select id, vlocity_cmt__JSONAttribute__c
                                           from orderItem
                                           where id = :idOrderItem];

            System.debug('json--------<');
            System.debug(selectedOrderItem.Id);
            System.debug(selectedOrderItem.vlocity_cmt__JSONAttribute__c);
            json = (Map<String, Object>)System.JSON.deserializeUntyped(selectedOrderItem.vlocity_cmt__JSONAttribute__c);

        } else{
            attribut = 'INWIB2C_ATT_RT_ENGAGEMENT';
            String jsonString = '{ "INWIB2C_ACAT_MOBILE": [ { "attributeuniquecode__c": "INWIB2C_ATT_RT_ENGAGEMENT", "attributeRunTimeInfo": { "selectedItem": { "value": "0", "sequence": 10, "id": "102adc19-1a03-524e-4b70-c98179eea478", "displayText": "Sans engagement" } } } ] }';
            json = (Map<String, Object>)System.JSON.deserializeUntyped(jsonString);
        }
        List<Object> INWIB2C_ACAT_MOBILE = (List<Object>)json.get('INWIB2C_ACAT_MOBILE');


        for (Object itemloop : INWIB2C_ACAT_MOBILE){
            Map<String, Object> item = (Map<String, Object>)itemloop;
            if (attribut == item.get('attributeuniquecode__c')){
                Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)item.get('attributeRunTimeInfo');
                Map<String, Object> selectedItem = (Map<String, Object>)attributeRunTimeInfo.get('selectedItem');
                outpout = (String) selectedItem.get('value');
            }
        }
        return outpout;
    }

    String getDisplayTextfromJson(List<Object> arguments){

        String outpout = '';
        // Inputs
        String attribut = String.valueOf(arguments[1]);
        Map<String, Object> json = new Map<String, Object>();

        if (!Test.isRunningTest()){
            Id idOrderItem = (Id) arguments[0];
            System.debug('inputs --------< ' + idOrderItem);
            System.debug('inputs attribut --------< ' + attribut);

            OrderItem selectedOrderItem = [select id, vlocity_cmt__JSONAttribute__c
                                           from orderItem
                                           where id = :idOrderItem];

            System.debug('json--------<');
            System.debug(selectedOrderItem.Id);
            System.debug(selectedOrderItem.vlocity_cmt__JSONAttribute__c);
            json = (Map<String, Object>)System.JSON.deserializeUntyped(selectedOrderItem.vlocity_cmt__JSONAttribute__c);
        } else{
            attribut = 'INWIB2C_ATT_RT_ENGAGEMENT';
            String jsonString = '{ "INWIB2C_ACAT_MOBILE": [ { "attributeuniquecode__c": "INWIB2C_ATT_RT_ENGAGEMENT", "attributeRunTimeInfo": { "selectedItem": { "value": "0", "sequence": 10, "id": "102adc19-1a03-524e-4b70-c98179eea478", "displayText": "Sans engagement" } } } ] }';
            json = (Map<String, Object>)System.JSON.deserializeUntyped(jsonString);
        }

        List<Object> INWIB2C_ACAT_MOBILE = (List<Object>)json.get('INWIB2C_ACAT_MOBILE');


        for (Object itemloop : INWIB2C_ACAT_MOBILE){
            Map<String, Object> item = (Map<String, Object>)itemloop;
            if (attribut == item.get('attributeuniquecode__c')){
                Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)item.get('attributeRunTimeInfo');
                Map<String, Object> selectedItem = (Map<String, Object>)attributeRunTimeInfo.get('selectedItem');
                outpout = (String) selectedItem.get('displayText');
            }
        }
        return outpout;
    }

    List<Map<String, Object>> getAttributesFromJson(List<Object> arguments){

        List<Map<String, Object>> outpout = new List<Map<String, Object>>();

        //
        List<Asset> assetsHeader = new List<Asset>();
        List<Asset> assets = new List<Asset>();

        if (!Test.isRunningTest()){
            Id subscriptionId = (Id) arguments[0];
           // System.debug('inputs --------< ' + idOrderItem);

            assetsHeader = [select id,vlocity_cmt__ParentItemId__c
                      from Asset
                      where vlocity_cmt__SubscriptionId__c = :subscriptionId and vlocity_cmt__ParentItemId__c=:null
                      ];
        /* CHB 03/04/2024 SF24-014 VOLTE ROAMING OUT Begin*/             
        /* for(Asset assetH:assetsHeader ){
            assets=[select id,Name, Product2Id, vlocity_cmt__JSONAttribute__c, vlocity_cmt__Action__c from Asset 
            where vlocity_cmt__RootItemId__c =: assetH.id and ProductCode LIKE '%SRV_ROAMING%'] ;     
        }*/
        //acyl 08/08/2025 MGEN3770-Fibre Boost Complément BEGIN 
        for(Asset assetH:assetsHeader ){
            assets=[select id,Name, Product2.Name,Product2Id, vlocity_cmt__JSONAttribute__c, vlocity_cmt__Action__c from Asset 
            where vlocity_cmt__RootItemId__c =: assetH.id and vlocity_cmt__Action__c!= 'Disconnect' and (Product2.Name = 'Service Roaming' or  Product2.Name ='Volte' or Product2.ProductCode='INWIB2C_FOB2C_OFFERING_BOOST2J' or Product2.ProductCode='INWIB2C_FOB2C_OFFERING_BOOST7J' or Product2.ProductCode='INWIB2C_FOB2C_OFFERING_BOOST2002J' or Product2.ProductCode='INWIB2C_FOB2C_OFFERING_BOOST2007J')] ;     
        }//acyl 08/08/2025 MGEN3770-Fibre Boost Complément en
        //chb 13/05/2024 add boost option in request assets 
        /* CHB 03/04/2024 SF24-014 VOLTE ROAMING OUT end*/         
        } else{
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJaQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86906,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013Io7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86906","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}],"values":[{"id":"870a4b4e-1761-53bf-4990-0a29151c00d9","displayText":"Forfait 49dhs Appels","value":"86906","sequence":20},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}},"$$AttributeDefinitionEnd$$":null}]}';
            Asset asset1 = new Asset(Name = 'Test Asset', vlocity_cmt__Action__c = 'Add', vlocity_cmt__JSONAttribute__c = JsonAttr, vlocity_cmt__RecurringCharge__c = 90);
            assets.add(asset1);
        }

        List<Map<String, Object>> item_top = new List<Map<String, Object>>();
        for (Asset item_asset : assets){
            System.debug('test ' + item_asset.vlocity_cmt__JSONAttribute__c);


            Map<String, Object> map_top = new Map<String, Object>();
            map_top.put('type', 'Option');
            map_top.put('productSerialNumber', 'default');
            map_top.put('typeClient', 'B2C');
            map_top.put('baseType', 0);
            //chb ano B-16365 begin*/
            //map_top.put('Name', item_asset.Name);
            map_top.put('name', item_asset.Name);
             //chb ano B-16365 end*/
            List<Map<String, Object>> productCharacteristic = new List<Map<String, Object>>();


            if (!String.isBlank(item_asset.vlocity_cmt__JSONAttribute__c)){
                Map<String, Object> json = (Map<String, Object>)System.JSON.deserializeUntyped(item_asset.vlocity_cmt__JSONAttribute__c);
                List<Object> INWIB2C_ACAT_MOBILE = (List<Object>)json.get('INWIB2C_ACAT_MOBILE');

                for (Object attribute : INWIB2C_ACAT_MOBILE){
                    Map<String, Object> item_to_insert = new Map<String, Object>();
                    Map<String, Object> itemAttributeMap = (Map<String, Object>)attribute;
                    Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)itemAttributeMap.get('attributeRunTimeInfo');

                    item_to_insert.put('name', itemAttributeMap.get('attributeuniquecode__c'));
                    item_to_insert.put('description', itemAttributeMap.get('attributedisplayname__c'));
                    item_to_insert.put('type', itemAttributeMap.get('valuedatatype__c'));
                    item_to_insert.put('baseType', '0');

                    String attributeValue;
                    List<Object> CharListResponse = new List<Object>();

                    if (('Picklist').equals(itemAttributeMap.get('valuedatatype__c'))){
                        Map<String, Object> selectedItem = (Map<String, Object>)attributeRunTimeInfo.get('selectedItem');
                        if (selectedItem != null){
                            attributeValue = (String) selectedItem.get('value');
                        }
                        List<Object> values = (List<Object>)attributeRunTimeInfo.get('values');
                        String valueItem;
                        String IdItem;
                        for (Object charValues : values){
                            Map<String, Object> outpout1 = new Map<String, Object>();
                            Map<String, Object> itemAtt = (Map<String, Object>)charValues;

                            outpout1.put('baseType', '0');
                            outpout1.put('name', (String) itemAtt.get('displayText'));
                            outpout1.put('id', (String) itemAtt.get('value'));
                            CharListResponse.add(outpout1);
                        }

                    } else if (('Checkbox').equals(itemAttributeMap.get('valuedatatype__c'))){
                        attributeValue = (Boolean) attributeRunTimeInfo.get('value') ? 'true' : 'false';
                    } else if (('Number').equals(itemAttributeMap.get('valuedatatype__c'))){
                        Integer intAttributeValue = Integer.valueof(attributeRunTimeInfo.get('value'));
                        attributeValue = intAttributeValue == null ? null : intAttributeValue.format();
                    } else{
                        attributeValue = (String) attributeRunTimeInfo.get('value');
                    }

                    item_to_insert.put('characteristicItem', CharListResponse);


                    if (attributeValue != null){
                        item_to_insert.put('id', attributeValue);
                    }

                    productCharacteristic.add(item_to_insert);

                }

            }

            map_top.put('productCharacteristic', productCharacteristic);
            item_top.add(map_top);

        }
        if (item_top.size() > 0){
            
            return item_top;
        }else {
            Map<String, Object> emptyItem = new Map<String, Object>();
            item_top.add(emptyItem);
            return item_top;
        }
        
    }

    Map<String, Object> GetOrderEnCoursOfSubscription(List<Object> arguments){
        Map<String, Object> output = new Map<String, Object>();
        Id subscriptionId = (Id) arguments[0];
        List<inwiB2C_OrderSubscription__c> data = [SELECT id, inwib2c_order__r.inwib2c_statut__c, inwib2c_subscription__c, inwib2c_order__r.inwib2c_typedelacommande__c, inwib2c_order__r.inwib2c_typeactedegestion__c, inwib2c_order__r.inwib2c_typedemigration__c, inwib2c_order__c, inwib2c_order__r.ordernumber
                                                   FROM inwiB2C_OrderSubscription__c
                                                   WHERE (inwiB2C_Order__r.inwiB2C_Statut__c != 'inwiB2C_NonConforme' AND inwiB2C_Order__r.inwiB2C_Statut__c != 'inwiB2C_Conforme' AND inwiB2C_Order__r.inwiB2C_Statut__c != 'inwiB2C_Activee' AND inwiB2C_Order__r.inwiB2C_Statut__c != 'inwiB2C_Annulee' AND inwiB2C_Subscription__c = :subscriptionId) 
                                                   limit 1];
        System.debug(data.size());
        if (data.size() > 0){
            inwiB2C_OrderSubscription__c item = (inwiB2C_OrderSubscription__c)data[0];
            Id orderid = (id) item.inwiB2C_Order__c;
            Order selected_order = [select id, OrderNumber, inwib2c_TypeDeLaCommande__c, inwiB2C_TypeActeDeGestion__c, inwiB2C_TypeDeMigration__c, inwiB2C_Statut__c
                                    from order
                                    where id = :orderid];
            output.put('exist', true);
            output.put('id', item.id);
            output.put('orderid', item.inwiB2C_Order__c);
            output.put('inwib2c_TypeDeLaCommande__c', selected_order.inwib2c_TypeDeLaCommande__c);
            output.put('inwiB2C_TypeActeDeGestion__c', selected_order.inwiB2C_TypeActeDeGestion__c);
            output.put('inwiB2C_TypeDeMigration__c', selected_order.inwiB2C_TypeDeMigration__c);
            output.put('inwiB2C_Statut__c', selected_order.inwiB2C_Statut__c);
            output.put('OrderNumber', selected_order.OrderNumber);
        } else{
            output.put('exist', false);
        }

        return output;
    }
//API PO ServiceNow
 List<Map<String, Object>> getAllAttributesFromJson(List<Object> arguments){

        List<Map<String, Object>> outpout = new List<Map<String, Object>>();

        //
        List<Asset> assetsHeader = new List<Asset>();
        List<Asset> assets = new List<Asset>();

        if (!Test.isRunningTest()){
            Id subscriptionId = (Id) arguments[0];
            //System.debug('inputs --------< ' + subscriptionId);
        /* chb 28/05/2024 ano B-16528 begin */
        if (subscriptionId != null ) {  
            assetsHeader = [select id,vlocity_cmt__ParentItemId__c
                    from Asset
                    WHERE vlocity_cmt__SubscriptionId__c = :subscriptionId 
                    AND vlocity_cmt__ParentItemId__c=:null 
                    ];
            List<Id> IdRootAsset = new List<Id>();
            for(Asset assetH:assetsHeader ){
                IdRootAsset.Add(assetH.Id);
            }
            assets=[select id,Name, ProductCode ,CreatedDate,Product2Id, vlocity_cmt__JSONAttribute__c, vlocity_cmt__Action__c from Asset 
            where vlocity_cmt__RootItemId__c in : IdRootAsset];  

        }} /* chb  28/05/2024 ano B-16528 end */
        else{
            String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJaQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86906,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013Io7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86906","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}],"values":[{"id":"870a4b4e-1761-53bf-4990-0a29151c00d9","displayText":"Forfait 49dhs Appels","value":"86906","sequence":20},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}},"$$AttributeDefinitionEnd$$":null}]}';
            Asset asset1 = new Asset(Name = 'Test Asset', vlocity_cmt__Action__c = 'Add', vlocity_cmt__JSONAttribute__c = JsonAttr, vlocity_cmt__RecurringCharge__c = 90);
            assets.add(asset1);
        }
        List<Map<String, Object>> item_top = new List<Map<String, Object>>();
        for (Asset item_asset : assets){
            System.debug('test ' + item_asset.vlocity_cmt__JSONAttribute__c);
        //productOrder/productOrderItem/product

            Map<String, Object> map_top = new Map<String, Object>();
            map_top.put('id', item_asset.id);
            map_top.put('code', item_asset.ProductCode);
            IF(item_asset.vlocity_cmt__Action__c=='Add'|| item_asset.vlocity_cmt__Action__c=='Existing'){
            map_top.put('state','ACTIVE');
            }else{
            map_top.put('state','SUSPENDED');
                }
            map_top.put('isSuspended','FALSE');
             if (!Test.isRunningTest()){
            String dateStr = item_asset.CreatedDate.year() + '/' + item_asset.CreatedDate.month() + '/' + item_asset.CreatedDate.day();
                 map_top.put('stateDate',dateStr);}
            map_top.put('name',item_asset.Name);
            //productOrder/productOrderItem/product/characteristic
            List<Map<String, Object>> productCharacteristic = new List<Map<String, Object>>();


            if (!String.isBlank(item_asset.vlocity_cmt__JSONAttribute__c)){
                Map<String, Object> json = (Map<String, Object>)System.JSON.deserializeUntyped(item_asset.vlocity_cmt__JSONAttribute__c);
                List<Object> INWIB2C_ACAT_MOBILE = (List<Object>)json.get('INWIB2C_ACAT_MOBILE');

                for (Object attribute : INWIB2C_ACAT_MOBILE){
                    Map<String, Object> item_to_insert = new Map<String, Object>();
                    Map<String, Object> itemAttributeMap = (Map<String, Object>)attribute;
                    Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)itemAttributeMap.get('attributeRunTimeInfo');

                    item_to_insert.put('code', itemAttributeMap.get('attributeuniquecode__c'));
                    item_to_insert.put('name', itemAttributeMap.get('attributedisplayname__c'));
                    String attributeValue;
                    if (('Picklist').equals(itemAttributeMap.get('valuedatatype__c'))){
                        Map<String, Object> selectedItem = (Map<String, Object>)attributeRunTimeInfo.get('selectedItem');
                        if (selectedItem != null){
                            attributeValue = (String) selectedItem.get('value');
                        }
                    } 
                    else if (('Checkbox').equals(itemAttributeMap.get('valuedatatype__c'))){
                        attributeValue = (Boolean) attributeRunTimeInfo.get('value') ? 'true' : 'false';
                    } //B-9726 CHB change Integer to double (83.33) 20/05/2023
                    else if (('Number').equals(itemAttributeMap.get('valuedatatype__c'))){
                        Double intAttributeValue = Double.valueof(attributeRunTimeInfo.get('value'));
                        attributeValue = intAttributeValue == null ? null : intAttributeValue.format();
                    } 
                    else{
                        attributeValue = (String) attributeRunTimeInfo.get('value');
                    }

                

                    system.debug('AttributeValue'+attributeValue);
                    if (attributeValue != null){
                        item_to_insert.put('value', attributeValue);
                    }
                    else{
                         item_to_insert.put('value', '');
                    }

                    productCharacteristic.add(item_to_insert);
                    system.debug('productCharacteristic'+productCharacteristic);
                }
            }
            map_top.put('characteristic', productCharacteristic);         
            system.debug('map_top'+map_top);
            item_top.add(map_top);
            system.debug('Item_top'+item_top);}
            if (item_top.size() > 0){
                system.debug('Item_top>0: '+item_top);
                return item_top;
            }
            else {
                Map<String, Object> emptyItem = new Map<String, Object>();
                item_top.add(emptyItem);
                system.debug('Item_top=0: '+item_top);
                return item_top;
        } 
        
    }
   // H-M TTM MC_SF24-006_Portabilité_Fix  Used to CreateContractSnow Begin 
   List<Map<String, Object>> getAllAttributesFortaFixe(List<Object> arguments) {
    List<Map<String, Object>> output = new List<Map<String, Object>>();

    List<Asset> assetsHeader = new List<Asset>();
    List<Asset> assets = new List<Asset>();

    if (!Test.isRunningTest()) {
        Id subscriptionId = (Id) arguments[0];
    
        // Vérification si le subscriptionId est valide
        if (subscriptionId != null) {
            // Effectuer la première requête
            assetsHeader = [SELECT Id, vlocity_cmt__ParentItemId__c
                            FROM Asset
                            WHERE vlocity_cmt__SubscriptionId__c = :subscriptionId 
                              AND vlocity_cmt__ParentItemId__c = null];
    
            // Récupérer les IDs des assetsHeader
            Set<Id> headerIds = new Set<Id>();
            for (Asset assetH : assetsHeader) {
                headerIds.add(assetH.Id);
            }
    
            // Récupérer tous les assets enfants en une seule requête
            if (!headerIds.isEmpty()) {
                assets = [SELECT Id, Name, ProductCode, CreatedDate, vlocity_cmt__JSONAttribute__c, vlocity_cmt__Action__c
                          FROM Asset
                          WHERE vlocity_cmt__RootItemId__c IN :headerIds];
            } else {
                System.debug('No asset headers found for Subscription ID: ' + subscriptionId);
            }
        } else {
            System.debug('Subscription ID is null or invalid.');
        }
    
    
    } else {
        String JsonAttr = '{"INWIB2C_ACAT_MOBILE":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t3M000000xuJaQAI","attributeid__c":"a0X3M000000NxlJUAS","attributecategoryid__c":"a0W3M000002oGhPUAU","categorycode__c":"INWIB2C_ACAT_MOBILE","categoryname__c":"Mobile","attributeuniquecode__c":"INWIB2C_ATT_RT_PROFIL","attributeconfigurable__c":true,"attributedisplaysequence__c":"75","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Promotion à l\'acquisition","displaysequence__c":"10","categorydisplaysequence__c":10,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":true,"valueinnumber__c":86906,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0U3M0000013Io7UAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"86906","valuedatatype__c":"Picklist","valuedescription__c":null,"attributegrouptype__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}],"values":[{"id":"870a4b4e-1761-53bf-4990-0a29151c00d9","displayText":"Forfait 49dhs Appels","value":"86906","sequence":20},{"id":"c5f27a11-ed93-8538-8f5a-c834785e9f1e","displayText":"Forfait 499dhs  tout inclus","value":"86915","sequence":130}],"selectedItem":{"displayText":"Forfait 49dhs Appels","id":"870a4b4e-1761-53bf-4990-0a29151c00d9","sequence":20,"value":"86906"}},"$$AttributeDefinitionEnd$$":null}]}';
        Asset asset1 = new Asset(Name = 'Test Asset', vlocity_cmt__Action__c = 'Add', vlocity_cmt__JSONAttribute__c = JsonAttr);
        assets.add(asset1);
    }

    List<Map<String, Object>> services = new List<Map<String, Object>>();

    for (Asset item_asset : assets) {
        Map<String, Object> serviceAttributes = new Map<String, Object>();
        Integer index = 1; // Index pour les attributs
    
        if (!String.isBlank(item_asset.vlocity_cmt__JSONAttribute__c)) {
            Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(item_asset.vlocity_cmt__JSONAttribute__c);
            List<Object> INWIB2C_ACAT_MOBILE = (List<Object>) json.get('INWIB2C_ACAT_MOBILE');
    
            for (Object attribute : INWIB2C_ACAT_MOBILE) {
                Map<String, Object> itemAttributeMap = (Map<String, Object>) attribute;
                Map<String, Object> attributeRunTimeInfo = (Map<String, Object>)itemAttributeMap.get('attributeRunTimeInfo');
                String attributeuniquecode = (String) itemAttributeMap.get('attributeuniquecode__c');
                String attributedisplayname = (String) itemAttributeMap.get('attributedisplayname__c');
    
                // Ajoutez les attributs à serviceAttributes avec les indices tabulaires
                if (!String.isBlank(attributeuniquecode) && !String.isBlank(attributedisplayname)) {
                    serviceAttributes.put('u_libelle_attribut_' + index, attributedisplayname);
                    serviceAttributes.put('u_code_attribut_' + index, attributeuniquecode);
                    
                    String attributeValue ;
                    
                    if (('Picklist').equals(itemAttributeMap.get('valuedatatype__c'))){
                        Map<String, Object> selectedItem = (Map<String, Object>) attributeRunTimeInfo.get('selectedItem');
                        if (selectedItem != null){
                            attributeValue = (String) selectedItem.get('value');
                        }
                    } 
                    else if (('Checkbox').equals(itemAttributeMap.get('valuedatatype__c'))){
                        attributeValue = (Boolean) attributeRunTimeInfo.get('value') ? 'true' : 'false';
                    } 
                    else if (('Number').equals(itemAttributeMap.get('valuedatatype__c'))){
                        Double intAttributeValue = Double.valueOf(attributeRunTimeInfo.get('value'));
                        attributeValue = intAttributeValue == null ? null : String.valueOf(intAttributeValue.format());
                    } 
                    else{
                        attributeValue = (String) attributeRunTimeInfo.get('value');
                    }
    
                      // Vérifiez si attributeValue est null, et si c'est le cas, affectez-lui une chaîne vide
                      if (attributeValue == null) {
                        attributeValue = '';
                           }
   
                           // Ajoutez la valeur d'attribut à serviceAttributes
                        serviceAttributes.put('u_valeur_attribut_' + index, attributeValue);
                              
    
                    index++; // Incrémentation de l'index uniquement 
                }
            }
        }
    
        // if (!serviceAttributes.isEmpty()) {
            serviceAttributes.put('u_code_service', item_asset.ProductCode); 
            serviceAttributes.put('u_ins_service', item_asset.id);

            services.add(serviceAttributes);
       // }
    }
    // Ajoutez la liste de services à la sortie
    output.add(new Map<String, Object>{'services' => services});

    return output;
}
  // H-M TTM MC_SF24-006_Portabilité_Fix  Used to CreateContractSnow End
    
    
    
 
//Methode Add Minute for API Cameleon 
 
  String AddHoursMinute(){
    return System.now().addhours(-24).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
 }



List<Map<String, Object>> FormatInputs(List<Object> arguments){
    List<Map<String, Object>> output = new List<Map<String, Object>>();

    for (Integer i = 0; i < arguments.size(); i++){
        Map<String, Object> item = new Map<String, Object>();
        item.put('value', arguments[i] != null && arguments[i] != 'null' ? arguments[i] : '');
        switch  on i{
            when 0{
                item.put('name', 'nd');
            }
            when 1{
                item.put('name', 'ndOperateur');
            }
            when 2{
                item.put('name', 'ndPrecedent');
            }
        }
        output.add(item);
    }

    return output;
}

}