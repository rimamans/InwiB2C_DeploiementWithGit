@isTest
private class InwiB2C_GetBalServiceGaming_Test {

    @isTest
    static void testInvokeMethod() {
        InwiB2C_GetBalServiceGaming obj = new InwiB2C_GetBalServiceGaming();
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        // Test case when methodName is not 'getBal'
        Boolean result = obj.invokeMethod('someOtherMethod', inputMap, outMap, options);
        System.assertEquals(true, result);
        System.assertEquals(null, outMap.get('result'));
        
        // Test case when methodName is 'getBal'
       
		inputMap.put('bucket', JSON.deserializeUntyped('[{ "properties": {"M_BAL_TYPE": "e7c8ae16000cTba9daa572bd","M_BAL_AFTER": "0","M_MOTIF_RECH": "1041","M_LINE_ID": "212666867764","M_TRANSACTION": "Balance","M_BAL_DEBITEE": "3000:1000;4000:30;5041:40","M_TRANSAC_DATE": "2022-06-11 08:40:35", "M_AMOUNT_CON": "14" }, "product": [], "bucketCounter": [],"bucketBalance": []}, { "properties": {"M_BAL_TYPE": "e7c8ae16000cTba9daa572bd","M_BAL_AFTER": "0","M_MOTIF_RECH": "1041","M_LINE_ID": "212666867764","M_TRANSACTION": "Balance","M_BAL_DEBITEE": "3000:1000;4000:30;5041:40","M_TRANSAC_DATE": "2022-06-11 08:40:35", "M_AMOUNT_CON": "14" }, "product": [], "bucketCounter": [],"bucketBalance": []}]'));

        result = obj.invokeMethod('getBal', inputMap, outMap, options);
        System.assertEquals(true, result);
        System.assertNotEquals(null, outMap.get('result'));
        
        Map<String, Object> resultData = (Map<String, Object>) outMap.get('result');
        List<Object> bucketList = (List<Object>) resultData.get('bucket');
        System.assertEquals(2, bucketList.size());
        
        Map<String, Object> propertiesTest = (Map<String, Object>) bucketList[0];
        System.assertEquals('e7c8ae16000cTba9daa572bd', propertiesTest.get('M_BAL_TYPE'));
        System.assertEquals('0', propertiesTest.get('M_BAL_AFTER'));
        System.assertEquals('1041', propertiesTest.get('M_MOTIF_RECH'));
        System.assertEquals('212666867764', propertiesTest.get('M_LINE_ID'));
        System.assertEquals('Balance', propertiesTest.get('M_TRANSACTION'));
        System.assertEquals('3000:1000;4000:30;5041:40', propertiesTest.get('M_BAL_DEBITEE'));
        System.assertEquals('2022-06-11 08:40:35', propertiesTest.get('M_TRANSAC_DATE'));
        System.assertEquals('14', propertiesTest.get('M_AMOUNT_CON'));
        // System.assertEquals('LordsMobile', propertiesTest.get('M_MOTIF_RECH_LIBELLE'));
        List<Map<String, Object>> listbal = (List<Map<String, Object>>) propertiesTest.get('listbal');
        System.assertEquals(3, listbal.size());
        System.assertEquals('3000', listbal[0].get('name'));
        System.assertEquals('1000', listbal[0].get('value'));
        System.assertEquals('4000', listbal[1].get('name'));
        System.assertEquals('30', listbal[1].get('value'));
        System.assertEquals('5041', listbal[2].get('name'));
        System.assertEquals('40', listbal[2].get('value'));
    }
}