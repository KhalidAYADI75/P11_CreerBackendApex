@isTest
public with sharing class TestDataFactory {
    public static Account createAccount(String accountName) {
        Account account = new Account(Name = accountName);
        insert account;
        return account;
    }
    public static Order createOrder(ID accountId) {
        Order odr = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId()
            );
        insert odr;
        return odr;
    }
    public static Order createOrderWithProduct(ID accountId) {
        Product2 produit = createProduct('MyFirstProduct');
        PricebookEntry pbEntry = createPriceBookEntry(produit);
        Order odr = createOrder(accountId);
        OrderItem odrItem = createOrderItem(odr,pbEntry,10,100);
        return odr;
    }
    public static Product2 createProduct(String nameOfProduct) {
        Product2 product = new Product2(Name = nameOfProduct);
        insert product;
        return product;
    }
    public static PricebookEntry createPriceBookEntry(Product2 product) {
    	PricebookEntry priceBookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        Insert priceBookEntry;
        return priceBookEntry;
    }   
    public static OrderItem createOrderItem(Order order , PriceBookEntry priceBookEntry, Integer TotalNumber, decimal Price) {
    	OrderItem odrItem = new OrderItem (
            OrderId = order.Id, 
            PricebookEntryId = priceBookEntry.Id, 
            Quantity=TotalNumber, 
            UnitPrice = Price
        );
        insert odrItem;
        return odrItem;
    }
    public static Task createTaskWithoutReminder(ID accountId) {
        Task newTask = new Task() ;
        newTask.Subject = 'Call';
        newTask.ActivityDate = datetime.now().addDays(1).date();
        newTask.Status = 'New';
        newTask.Priority = 'Normale';
        newTask.IsReminderSet = false ;
        newTask.WhatId = accountId;
        insert newTask;
        return newTask;
    }
    public static Task createTaskWithReminder(ID accountId) {
        Task newTask = new Task() ;
        newTask.Subject = 'Call';
        newTask.ActivityDate = datetime.now().addDays(1).date();
        newTask.Status = 'New';
        newTask.Priority = 'Normale';
        newTask.IsReminderSet = true ;
        newTask.ReminderDateTime = datetime.now().addDays(6);
        newTask.WhatId = accountId;
        insert newTask;
        return newTask;
    }

}