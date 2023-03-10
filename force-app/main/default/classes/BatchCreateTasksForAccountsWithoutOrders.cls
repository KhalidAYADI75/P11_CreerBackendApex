public with sharing class BatchCreateTasksForAccountsWithoutOrders implements Database.Batchable<sObject> , Schedulable {
    public Database.Querylocator start(Database.BatchableContext bc){
        return Database.getQuerylocator('SELECT Id,(SELECT Id,AccountId,IsReminderSet FROM Tasks),(SELECT Id,AccountId FROM Orders) FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)');
    } 
    //requête soql impossible sur tasks , obligé de découper en plusieurs opérations
    //Entity 'Task' is not supported for semi join inner selects
    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Account> accList = AccountService.getAccountsWithoutOrderAndTask(scope);
        List<Task> taskList = AccountService.createTaskForAccounts(accList); 
    }
    public void finish(Database.BatchableContext bc){
    
    }

    public void execute(SchedulableContext sc) {
        ID BatchId = Database.executeBatch(new BatchCreateTasksForAccountsWithoutOrders());
    }

    public static void executeSchedule() {
        BatchCreateTasksForAccountsWithoutOrders BatchSchedule = new BatchCreateTasksForAccountsWithoutOrders();
        String cronExpression = '0 0 1 ? * 2#1 *';
        if (Test.isRunningTest()) {
            System.schedule('Test Batch Schedule', cronExpression, BatchSchedule);
        } else {
             System.schedule('Batch Schedule', cronExpression, BatchSchedule);
        }
    }
 
}