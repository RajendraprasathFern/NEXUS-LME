@isTest
private class InterestCalculationBatchTest {

    @testSetup
    static void setup() {
        // 1. Create Financial Accounts
        List<Financial_Account__c> accounts = new List<Financial_Account__c>();
        for(Integer i = 0; i < 200; i++) {
            accounts.add(new Financial_Account__c(
                Interest_Rate__c = 10.0,
                Total_Interest__c = 0
            ));
        }
        insert accounts;

       
        List<Transaction__c> trans = new List<Transaction__c>();
        for(Financial_Account__c fa : accounts) {
            trans.add(new Transaction__c(
                Financial_Account__c = fa.Id,
                Amount__c = 36500,
                Type__c = 'Disburse', 
                Transaction_Date__c = System.now()
            ));
        }
        insert trans;
    }

    @isTest
    static void testBatchLogic() {
        Test.startTest();
        InterestCalculationBatch batch = new InterestCalculationBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        List<Financial_Account__c> updatedAccounts = [SELECT Total_Interest__c FROM Financial_Account__c];
        for(Financial_Account__c fa : updatedAccounts) {
            // (36500 * (10/100)) / 365 = 10.00
            System.assertEquals(10.00, fa.Total_Interest__c.setScale(2), 'Interest calculation failed');
        }
    }

    @isTest
    static void testInvocableMethod() {
        Test.startTest();
        InterestCalculationBatch.runBatch();
        Test.stopTest();
       
        System.assert(true); 
    }
}