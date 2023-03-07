@isTest
public with sharing class OrderActiveFieldModificationTest {

    @testSetup static void setup() {
        Account accountWithOrder = TestDataFactory.createAccount('accWithOrder');
        Order odr = TestDataFactory.createOrder(accountWithOrder.id);
        Account accountWithOrderToDelete = TestDataFactory.createAccount('accountWithOrderToDelete');
        Order otherOdr = TestDataFactory.createOrder(accountWithOrderToDelete.id);
    }
    @isTest
    static void testGetAccountsWithoutOrder() {
        List<Order> orderList = [SELECT Id,Account.Name FROM Order];
        for (Order odr : orderList) {
            if (odr.Account.Name == 'accountWithOrderToDelete') {
                delete odr;
            }
        }
        Test.startTest();
        List<Account> acctsWihoutOrder = OrderActiveFieldModification.getAccountsWithoutOrder(orderList);
        Test.stopTest();
        System.assertEquals(1, acctsWihoutOrder.size());
    }
    @isTest
    static void testUncheckAccountActiveField(){
       List<Order> orderList = [SELECT Id,Account.Name FROM Order];
        for (Order odr : orderList) {
            if (odr.Account.Name == 'accountWithOrderToDelete') {
                delete odr;
            }
        }
        List<Account> acctsWihoutOrder = [SELECT Id,Active__c FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)];
        Test.startTest();
        OrderActiveFieldModification.uncheckAccountActiveField(acctsWihoutOrder);
        Test.stopTest();
        List<Account> acctsList = [SELECT Id FROM Account WHERE Active__c=false];
        system.assertEquals(1, acctsList.size());
    }
}