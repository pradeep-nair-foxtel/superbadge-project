public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
         // Mock JSON response
        String jsonResponse = '[{"_id":"55d66226726b611100aaf73f","replacement":false,"quantity":10,"name":"UPS 2000 VA","maintenanceperiod":180,"lifespan":60,"cost":1350,"sku":"100001"},{"_id":"55d66226726b611100aaf740","replacement":true,"quantity":194,"name":"Fuse 8A","maintenanceperiod":0,"lifespan":0,"cost":5,"sku":"100002"}]';        
        // Set the response body
        res.setBody(jsonResponse);        
        return res;  
    }
     
}