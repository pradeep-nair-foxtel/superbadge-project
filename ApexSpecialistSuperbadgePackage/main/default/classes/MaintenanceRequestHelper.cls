public with sharing class MaintenanceRequestHelper {
    public static void updateworkOrders(List<Case> updWorkOrders, Map<Id,Case> nonUpdCaseMap) {
        
	//create a set of valid cases
	Set<Id> validIds = new Set<Id>();
    
    //check if case status is correct
        For (Case c : updWorkOrders) {
            if (c.Status == 'Closed' && nonUpdCaseMap.get(c.Id).Status != 'Closed') {
              if (c.Type == 'Repair' || c.Type == 'Routine Maintenance') {
                validIds.add(c.Id);
              }  
            }
        }
     
        if (!validIds.isEmpty()) {
            
         //Retrieve closed cases details incl. maintenance items
         List<Case> newCases = new List<Case>();
            Map<Id, Case> closedCasesMap = new Map<Id, Case>([
                SELECT Id, Vehicle__c, (SELECT Id, Equipment__c, Quantity__c From Equipment_Maintenance_Items__r) From Case Where Id in :validIds]);
            for (Case closedCase : closedCasesMap.values()){
                System.debug('Vehicle ID on case is '+ closedCase.Vehicle__c);
                System.debug('No of equipments on case are' + closedCasesMap.get(closedCase.Id).Equipment_Maintenance_Items__r.size());
            }
            
            Map<Id, Decimal> maintenanceCyles = new Map<Id, Decimal>();
            //Retrieve maintenance cyles and add them to a map with case id as the key
            AggregateResult[] results = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)cycle FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :validIds GROUP BY Maintenance_Request__c ];
            System.debug('Found ' + results.size() + ' equipments') ;
            for (AggregateResult ar : results){
                maintenanceCyles.put((Id) ar.get('Maintenance_Request__c'), (Decimal) ar.get('cycle'));
            }
            for (Case closedCase : closedCasesMap.values()){
                Case newCase = new Case(
                	ParentId = closedCase.Id,
                    Status = 'New',
                    Type = 'Routine Maintenance',
                    Vehicle__c = closedCase.Vehicle__c,
                    Origin = 'Web',
                    Date_Reported__c = Date.today(),
           			Date_Due__c = Date.today().addDays((Integer)maintenanceCyles.get(closedCase.Id)));
                newCases.add(newCase);
            }
            insert newCases;
            
            //now that the cases are created associate the equipment items from old case to the new case
            List<Equipment_Maintenance_Item__c> maintItems = new List<Equipment_Maintenance_Item__c>();
            for (Case newCase : newCases) {
                for (Equipment_Maintenance_Item__c item : closedCasesMap.get(newCase.ParentId).Equipment_Maintenance_Items__r) {
                    Equipment_Maintenance_Item__c clonedItem = item.clone();
                    clonedItem.Maintenance_Request__c = newCase.Id;
                    maintItems.add(clonedItem);
                }
            }
            insert maintItems;
            
        }
        
    }
}