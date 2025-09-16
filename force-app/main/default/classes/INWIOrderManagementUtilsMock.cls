@isTest
global class INWIOrderManagementUtilsMock implements HttpCalloutMock
{
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest req){
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String body ='>>>"CSOperationResultInfo": {"correlationId": null,"errorCode": "FAULT","errorMessage": "Internal Server Error : Message part {http://bscs.inwi.com}createCustomer was not recognized.  (Does it exist in service WSDL?)","isOK": "0","uuid": "7373465a-c5c8-3eec-4487-efc030d3acea"}}';
        res.setBody(body);
       
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}