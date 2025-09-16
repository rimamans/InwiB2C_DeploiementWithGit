@isTest
public class InwiB2C_SharingRequestManagementVITest {
    @isTest
    public static void CallcloneSharingRequestTest(){
        InwiB2C_SharingRequestManagementVI.invokeMethod('cloneSharingRequest',new Map<String,Object>(),new Map<String,Object>(),new Map<String,Object>());
    }
    @isTest
    public static void CallSearchForScopedRequestTest(){
        InwiB2C_SharingRequestManagementVI.invokeMethod('searchForScopedRequest',new Map<String,Object>(),new Map<String,Object>(),new Map<String,Object>());
    }
    @isTest
    public static void CallSearchForUnScopedRequestTest(){
        InwiB2C_SharingRequestManagementVI.invokeMethod('searchForUnscopedRequest',new Map<String,Object>(),new Map<String,Object>(),new Map<String,Object>());
    }
    @isTest
    public static void CallSearchForgetRequestStatusTest(){
        InwiB2C_SharingRequestManagementVI.invokeMethod('getRequestStatus',new Map<String,Object>(),new Map<String,Object>(),new Map<String,Object>());
    }

}