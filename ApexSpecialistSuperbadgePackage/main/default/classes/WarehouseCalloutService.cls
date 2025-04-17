public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    
    //public static void execute(QueueableContext context) {
    //    syncInventory();
    //}
    
    //@Future(callout=true)
    public static void syncInventory(){
        List<Object> warehouseDtlsJson = makeGetCallout();
        List<Product2> sfEquipments = new List<Product2>();
        if (!warehouseDtlsJson.isEmpty()){
            for (Object warehouseDtlObj : warehouseDtlsJson){
                Product2 prd = new Product2();
                Map<String, Object> jsonObject = (Map<String, Object>) warehouseDtlObj;
                prd.Name = (String)jsonObject.get('name');
                prd.Cost__c=(Decimal)jsonObject.get('cost');
                prd.Warehouse_SKU__c=(String)jsonObject.get('_id');
                prd.Replacement_Part__c=True;
                prd.Current_Inventory__c=(Decimal)jsonObject.get('quantity');
                prd.Lifespan_Months__c=(Decimal)jsonObject.get('lifespan');
                prd.Maintenance_Cycle__c=(Decimal)jsonObject.get('maintenanceperiod');
                prd.ProductCode=(String)jsonObject.get('sku');
                sfEquipments.add(prd);
            }
        }    
        upsert sfEquipments Warehouse_SKU__c;
        
    }
    
    private static List<Object> makeGetCallout() {
        // Create an instance of the HTTPRequest class
        HttpRequest request = new HttpRequest();
        List<Object> results = null;
        // Set the endpoint URL for the request
        request.setEndpoint(WAREHOUSE_URL);
        // Set the HTTP method to GET
        request.setMethod('GET');
        // Create an instance of the HTTP class to send the request and receive the response
        Http http = new Http();
        // Send the request and receive the response
        HttpResponse response = http.send(request);
        
        // Check the response status code to ensure the request was successful
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON response body into a list of Equipment objects
            results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            // Return the list of Equipment objects
        } 
        return results;
    }
    
}