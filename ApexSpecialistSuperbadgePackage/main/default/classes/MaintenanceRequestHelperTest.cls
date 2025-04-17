@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    @isTest static void testMaintenanceRequest(){
        
    //    List<vehicle__c> v = [select id from vehicle__c where Model__c='Teardrop Camper'];
        List<Equipment_Maintenance_Item__c> maintItems = new List<Equipment_Maintenance_Item__c>();
        //New case
        Case c = new Case(
           Status = 'New',
           Subject = 'New automated routine maintenance',
           Type = 'Repair',
           Origin = 'Web',
           Date_Reported__c = Date.today(),
           Date_Due__c = Date.today().addDays(15)
        );
        c.Vehicle__c = 'a02dM00000C96KFQAZ';
        insert c;
        
        //List<Product2> equipments = [select Id, Name from Product2 where Name in ('Breaker 13C', 'Generator 1000 kW')];
        
        Product2 partEquipment = new Product2(Name='Test-1', Maintenance_Cycle__c=10, ProductCode='PB10C', Replacement_Part__c=True);
        insert partEquipment;
        
        Equipment_Maintenance_Item__c part = new Equipment_Maintenance_Item__c();
        part.Equipment__c = partEquipment.Id;
        part.Maintenance_Request__c = c.Id;
        maintItems.add(part);
                
        insert maintItems;
        
        c.Status='Closed';
        
        Test.startTest();
            Database.UpsertResult result = Database.upsert(c, false);
        Test.stopTest();
        
        System.assert(result.isSuccess());
    }
}