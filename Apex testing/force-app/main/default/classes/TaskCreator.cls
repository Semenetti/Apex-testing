// Practically-focused task:
// 1) Create apex class that can be lunched from Process Builder (for Account).
// 2) Apex class should make next logic: When new Account is created, create new Task object with Subject “Negotiations with {Account.Name}”, link created Account with this Task.
// 3) If Account is updated and Account has more than 3 Tasks => assign all Tasks to one User (random active User)  
// 4) Collect all code in remote git repository for review


public with sharing class TaskCreator {
        
    @InvocableMethod(label='Insert new Task', category='Task')
    public static void task(List<Account> accounts) {
        // 2) .... when new Account is created 
        // как получить id Account'a, который только что создан? или можно как-то по-другому получить {Account.Name} ?               
        
        Task newTask = new Task(Subject='Negotiations with ' + Account.Name);
        
        insert newTask;
    
    
        // 3) If Account is updated - проверяет Process Builder в "Add Object"??    
        
        // and Account has more than 3 Tasks => assign all Tasks to one User (random active User)  
        String userId = UserInfo.getUserId();
        List<Task> taskList = [SELECT Id, Subject FROM Task];
        List<Task> tasksToUpdate = new List<Task>();

        if (taskList.size() > 3) {
            for(Task t: taskList) {
                t.OwnerId = userId;
                tasksToUpdate.Add(t);
            }
        }

        insert tasksToUpdate;
    }
}