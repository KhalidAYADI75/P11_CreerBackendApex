public with sharing class AccountService {
    public static List<Account> getAccountsWithoutOrderAndTask(List<Account> accListWithoutOrder) {
        List<Account> accListWithoutOrderAndTask = new List<Account>();
        for (Account acc : accListWithoutOrder) {
            boolean HasReminderTask = false;
            if (!acc.tasks.isEmpty()) {
                for (Task ts : acc.Tasks) {
                    if (ts.IsReminderSet == true) {
                    	HasReminderTask = true;
                    }
            	}            
            }
            if ((acc.tasks.isEmpty()) || (HasReminderTask == false)) {
            	accListWithoutOrderAndTask.add(acc);
            }
        }      
        return accListWithoutOrderAndTask;   
    }
    
    public static List<Task> createTaskForAccounts(List<Account> accList) {
        List<Task> taskList = new List<Task>();
        for (Account acc : accList) {
            Task newTask = new Task() ;
            newTask.Subject = 'Call';
            newTask.ActivityDate = datetime.now().addDays(1).date();
            newTask.Status = 'New';
            newTask.Priority = 'Normale';
            newTask.IsReminderSet = true ;
            newTask.WhatId = acc.Id;
            newTask.ReminderDateTime = datetime.now().addDays(6);
            taskList.add(newTask);
        }
        insert taskList;     
        return taskList;  
    }    
}