public with sharing class OrderStatusModification {
    public static List<Order> getListOfOrdersThatStatusFieldIsUpdatedToActive(list<Order> oldOrderList,list<Order> newOrderList) {
        List<Order> ordersUpdatedToActiveStatus = new List<Order>();
        Map<id, Order> newOrderMap = new Map<id, Order>(); 
        for (Order newOdr : newOrderList) {
	        newOrderMap.put(newOdr.id,newOdr);             
        }
        for (Order oldOdr : oldOrderList) {
            if (oldOdr.status == 'Draft') {
                if (newOrderMap.containsKey(oldOdr.Id)) {
                    if (newOrderMap.get(oldOdr.Id).status == 'Activated') {
                        ordersUpdatedToActiveStatus.add(oldOdr);
                    }
                }
            }
        }
        return ordersUpdatedToActiveStatus;
    }

    public static Map<id, Order> getMapOfOrdersWithoutProduct(list<Order> orderList) {
        List<Id> orderIds = new List<Id>(); 
        for(integer i=0; i< orderList.size(); i++){
        	orderIds.add(orderList[i].Id); 
        }
        Map<id, Order> ordersWithoutProduct = new Map<id, Order>();
        List<Order> orderAndItems=[SELECT Id,(SELECT Id FROM OrderItems) FROM Order WHERE (Id IN : orderIds AND Id NOT IN (SELECT OrderId FROM OrderItem))];
        for (Order odr : orderAndItems) {
	        ordersWithoutProduct.put(odr.id,odr);             
        }  
        return ordersWithoutProduct;
    }
	public static Integer preventModificationIfOrdersHasNoProduct(Map<id,Order> ordersWithoutProduct, List<Order> orders) {
        Integer errCounter = 0;
        for (Order odr : orders) {
             if (ordersWithoutProduct.containsKey(odr.id)) {
                errCounter ++ ;
                 odr.addError('Vous ne pouvez pas activer une commande sans produit');
             }
         }
         return errCounter;
    }
}