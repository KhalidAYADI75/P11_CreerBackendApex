@isTest
public with sharing class BatchCreateTasksForAccsWithoutOrdersTest {
    @Testsetup static void setup() {
        Account account1 = TestDataFactory.createAccount('account1');
        Account account2 = TestDataFactory.createAccount('account2');
        Account account3 = TestDataFactory.createAccount('account3');     
        Account account4 = TestDataFactory.createAccount('account4');
        Account account5 = TestDataFactory.createAccount('account5');
        Order OrderOfAccount3 = TestDataFactory.createOrder(account3.Id);
        Order OrderOfAccount4 = TestDataFactory.createOrder(account4.Id);
        Task taskOfAccount5 = TestDataFactory.createTaskWithoutReminder(account5.id);
    }
    @isTest
    public static void testBatchCreateTasks() {
        Test.startTest();
        BatchCreateTasksForAccountsWithoutOrders BatchCreateTasks = new BatchCreateTasksForAccountsWithoutOrders();
        Id BatchId = Database.executeBatch(BatchCreateTasks);
        Test.stopTest();
        List<Account> accList = [SELECT Id FROM Account WHERE Name LIKE '%account%'];       
        Set<Id> accountsId = new Set<Id>();
        for (Account acc : accList) {
            accountsId.add(acc.Id);
        }
        System.assertEquals(4, [SELECT count() FROM TASK WHERE WhatId IN : accountsId ]);
    }
    @isTest
    public static void testExecuteSchedule() {   
        Test.StartTest();  
    	BatchCreateTasksForAccountsWithoutOrders.executeSchedule();    
        Test.StopTest();
        System.assertEquals(1, [SELECT count() FROM CronTrigger WHERE CronJobDetail.Name = 'Test Batch Schedule']);
  
    }
}