// Practically-focused task:
// 1) Create apex class that can be lunched from Process Builder (for Account).
// 2) Apex class should make next logic: When new Account is created, create new Task object with Subject “Negotiations with {Account.Name}”, link created Account with this Task.
// 3) If Account is updated and Account has more than 3 Tasks => assign all Tasks to one User (random active User)  
// 4) Collect all code in remote git repository for review


public with sharing class TaskCreator {
        
    @InvocableMethod
    public static void task(List<Id> ids) {
        // 2) Apex class should make next logic: When new Account is created, 
        // create new Task object with Subject “Negotiations with {Account.Name}”, 
        // link created Account with this Task.
        List<Account> account = [SELECT Name FROM Account WHERE Id in :ids];        
        Task newTask = new Task(Subject='Negotiations with ' + account[0].name, WhatId=account[0].id);        
        insert newTask;
    
    
        // 3) If Account is updated - проверяет Process Builder в "Add Object"??    

        // and Account has more than 3 Tasks => assign all Tasks to one User (random active User)  
        List<Task> allAcccountTasks = [SELECT Id, Subject, WhatID from Task
                           WHERE WhatID IN :ids];  
        
        if (allAcccountTasks.size() > 3) {
            List<Task> tasksToUpdate = new List<Task>();
            String userId = UserInfo.getUserId();

            for(Task t: allAcccountTasks) {
                t.OwnerId = userId;
                tasksToUpdate.Add(t);
            }
            
            insert tasksToUpdate;
        }

    }
}