@isTest
public with sharing class OrderStatusModificationTest {
    @TestSetup static void setup(){
        Account account1 = TestDataFactory.createAccount('account1');
        Account account2 = TestDataFactory.createAccount('account2');
        Account account3 = TestDataFactory.createAccount('account3');
        Order odr1 = TestDataFactory.createOrder(account1.Id);
        Order odr2 = TestDataFactory.createOrder(account2.Id);
        Order odr3 = TestDataFactory.createOrderWithProduct(account3.Id);

    }
    @isTest
    public static void testGetListOfOrdersThatStatusFieldIsUpdatedToActive() {
        List<Order> orderList = [SELECT Id,Account.Name,Status FROM Order];
        List<Order> orderListUpdated = [SELECT Id,Account.Name,Status FROM Order];
        for (Order odrUpdated : orderListUpdated) {
            if (odrUpdated.Account.Name=='account1') {
                odrUpdated.Status = 'Activated';
            } 
        }
        Test.startTest();
        list<Order> ordersWithStatusActive = OrderStatusModification.getListOfOrdersThatStatusFieldIsUpdatedToActive(orderList,orderListUpdated);
        Test.stopTest();
        system.assertEquals(1, ordersWithStatusActive.size());
    }
    @isTest
    public static void testGetMapOfOrdersWithoutProduct() {
        List<Order> orderList = [SELECT Id FROM Order];
        Test.startTest();
        Map<id, Order> ordersWithoutProduct = new Map<id, Order>();
        ordersWithoutProduct = OrderStatusModification.getMapOfOrdersWithoutProduct(orderList);
        Test.stopTest();
        system.assertEquals(2, ordersWithoutProduct.size());
    }
    @isTest
    public static void testPreventModificationIfOrdersHasNoProduct() {
        Map<Id,Order> ordersWithoutProduct = new Map<Id,Order>();
        List<Order> orderList = [SELECT Id,(SELECT Id,OrderId FROM OrderItems) FROM Order];
        for (Order odr : orderList) {
            if (odr.OrderItems.isEmpty()) {
                ordersWithoutProduct.put(odr.Id, odr);
            }
        }
       	Test.StartTest();
        Integer NumberOfModificationsBlocked = OrderStatusModification.preventModificationIfOrdersHasNoProduct(ordersWithoutProduct,orderList);
        Test.StopTest();
		system.assertEquals(2, NumberOfModificationsBlocked);
    }
}