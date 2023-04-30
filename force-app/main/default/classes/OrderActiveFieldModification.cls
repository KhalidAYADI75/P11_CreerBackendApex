public with sharing class OrderActiveFieldModification {
    public static List<Account> getAccountsWithoutOrder(List<Order> orderList) {
        List<Id> accountIds = new List<Id>(); 
        for (Order odr : orderList) {
            accountIds.add(odr.AccountId); 
        }
        
        List<Account> acctsWithoutOrder = [SELECT Id,Active__c FROM Account WHERE (Id NOT IN (SELECT AccountId FROM Order) AND (Id IN : accountIds))];
        return acctsWithoutOrder;
    }
    public static void uncheckAccountActiveField(List<Account> accList) {
        List<Account> acctsFieldUnchecked = new List<Account>();
        for (Account acc : accList) {
            if (acc.Active__c) {
                acc.Active__c = false;
            	acctsFieldUnchecked.add(acc);
            }
        }
        update acctsFieldUnchecked;
    }
}

