@isTest
public with sharing class AccountServiceTest {
	@TestSetup static void setup() {
    	List<Account> accList = new List<Account>();
        Account account1 = TestDatafactory.createAccount('account1');
        Account account2 = TestDatafactory.createAccount('account2');
        Account account3 = TestDatafactory.createAccount('account3');
        Task taskWithReminder = TestDataFactory.createTaskWithReminder(account1.id);
        Task taskWithoutReminder = TestDataFactory.createTaskWithoutReminder(account2.id);
    }
    @isTest
    public static void testGetAccountsWithoutOrderAndTask() {
        List<Account> accList = [SELECT Id,(SELECT Id,AccountId,IsReminderSet FROM Tasks) FROM Account WHERE Name LIKE '%account%'];
        Test.startTest();
        List<Account> accListWithoutOrderAndTask = AccountService.getAccountsWithoutOrderAndTask(accList);
        Test.stopTest();
        system.assertEquals(2, accListWithoutOrderAndTask.size());
    }
    @isTest
    public static void testCreateTaskForAccounts() {
        List<Account> accList = [SELECT Id FROM Account WHERE Name LIKE '%account%'];
        Test.startTest();
        List<Task> taskList = AccountService.createTaskForAccounts(accList);
        Test.stopTest();
        system.assertEquals(3, taskList.size());
    }
}