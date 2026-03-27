global class InterestCalculationBatch implements Database.Batchable<sObject> {

    // 1. Invocable Method so your Scheduled Flow can trigger this batch
    @InvocableMethod(label='Run Daily Interest Batch' description='Executes the daily interest calculation batch job')
    global static void runBatch() {
        Database.executeBatch(new InterestCalculationBatch());
    }

    // 2. Start Method: Query all active accounts with positive balance
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Current_Balance__c, Interest_Rate__c, Total_Interest__c 
            FROM Financial_Account__c 
            WHERE Current_Balance__c > 0 
            AND Interest_Rate__c > 0
        ]);
    }

    // 3. Execute Method: Perform the interest math
    global void execute(Database.BatchableContext BC, List<Financial_Account__c> scope) {
        List<Financial_Account__c> accountsToUpdate = new List<Financial_Account__c>();
        
        for (Financial_Account__c fa : scope) {

            Decimal currentBalance = (fa.Current_Balance__c == null) ? 0 : fa.Current_Balance__c;
            // Null check: If Total_Interest__c is null, treat it as 0
            Decimal currentInterest = (fa.Total_Interest__c == null) ? 0 : fa.Total_Interest__c;
            
            // Daily interest calculation: (Balance * (Rate / 100)) / 365
            Decimal dailyInterest = (fa.Current_Balance__c * (fa.Interest_Rate__c / 100)) / 365;
            
            // Accumulate
            fa.Total_Interest__c = currentInterest + dailyInterest;
            
            accountsToUpdate.add(fa);
        }
        
        // Bulk update
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }


    global void finish(Database.BatchableContext BC) {
       system.debug('Batch job completed successfully');
    }
}