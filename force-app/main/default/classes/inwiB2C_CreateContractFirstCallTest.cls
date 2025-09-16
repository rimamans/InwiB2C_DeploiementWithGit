/*ZME INWIB2C-PHASE2-Lot 1.2 29.07.2021 BEGIN*/
@isTest
public class inwiB2C_CreateContractFirstCallTest {
    @isTest static void CreateContractFirstCallTest() {
        
        string requestBody = '{';
        requestBody += '"operation": {';
        requestBody += '"canal": "inwiB2C_FDV",';
        requestBody += '"user": "212662626262",';
        requestBody += '"uuid": "6159aed6-b8cc-41ca-9f01-2ed542cf4090"';
        requestBody += '},';
        requestBody += '"ressources": [{';
        requestBody += '"businessUnit": "CPD01",';
        requestBody += '"pos": "CPD01",';
        requestBody += '"mdn": "212648058885",';
        requestBody += '"mdnDealer": "212648058885",';
        requestBody += '"icc": "892128510050203257",';
        requestBody += '"profileId": "84001",';
        requestBody += '"imsi": "604050400056226",';
        requestBody += '"ki": "F97769DD8309EA44AD0EE2BBB7AB45CC",';
        requestBody += '"puk": "26364298",';
        requestBody += '"codeArticle": "000056826",';
        requestBody += '"ocsId": "IN2",';
        requestBody += '"DateReelDemande": "2023-06-14T14:14:59"';
        requestBody += '"typesim": "ESIM",';
        requestBody += '"businessreference":"test"';
        requestBody += '}]';
        requestBody += '}';
        
        test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/CreateContractFirstCall';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;
        inwiB2C_CreateContractFirstCall.createContract();
        test.stopTest();
    }
}
/*ZME INWIB2C-PHASE2-Lot 1.2 29.07.2021 END*/