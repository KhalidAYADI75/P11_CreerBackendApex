trigger OrderTriggerHandler on Order (before update, after delete) {   
    if (trigger.isBefore && trigger.isUpdate) {
    	list<Order> orderList = trigger.new;
       	list<Order> oldOrderList = trigger.old;
       	list<Order> ordersWithStatusActive = OrderStatusModification.getListOfOrdersThatStatusFieldIsUpdatedToActive(oldOrderList,orderList);
       	Map<id,Order> ordersWithoutProduct = OrderStatusModification.getMapOfOrdersWithoutProduct(ordersWithStatusActive);
       	Integer Counter = OrderStatusModification.preventModificationIfOrdersHasNoProduct(ordersWithoutProduct,orderList);       
    }
     if (trigger.isAfter && trigger.isDelete) {
        list<Order> oldOrderList = trigger.old;
    	List<Account> acctsWihoutOrder = OrderActiveFieldModification.getAccountsWithoutOrder(oldOrderList);
        OrderActiveFieldModification.uncheckAccountActiveField(acctsWihoutOrder);
     }
}