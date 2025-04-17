@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    private static void testSyncInventory(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
 		//System.enqueueJob(new WarehouseCalloutService());
        // Call the method to be tested
		WarehouseCalloutService.syncInventory();
        Test.stopTest();
        List<Product2> prds = [select Name from Product2 where Warehouse_SKU__c in ('55d66226726b611100aaf73f', '55d66226726b611100aaf740')];
        
        // Verify the results
        Assert.areEqual(2, prds.size(), 'The array should only contain 2 items.');
        
    }

}