public class FinancialService {
    
    // Wrapper must be global to be visible to Flow
    public class FinancialWrapper {
        @AuraEnabled public String source;
        @AuraEnabled public String type;
        @AuraEnabled public Decimal amount; // For Income / Liability Amount
        @AuraEnabled public Decimal value;  // For Asset Value
        @AuraEnabled public String description;    // For Asset Description
        @AuraEnabled public Decimal payment;// For Liability Payment
    }

    @InvocableMethod(label='Create Financial Records')
    public static void saveFinancials(List<Request> requests) {
        Request req = requests[0];

        // 1. Deserialize the three different JSON strings
        List<FinancialWrapper> incomes = (List<FinancialWrapper>)JSON.deserialize(req.incomeJSON, List<FinancialWrapper>.class);
        List<FinancialWrapper> assets = (List<FinancialWrapper>)JSON.deserialize(req.assetJSON, List<FinancialWrapper>.class);
        List<FinancialWrapper> liabilities = (List<FinancialWrapper>)JSON.deserialize(req.liabilityJSON, List<FinancialWrapper>.class);

        // 2. Process Income
     // 2. Process Income
        List<Income__c> incToInsert = new List<Income__c>();
        for(FinancialWrapper w : incomes) {
            // Mapping to Income__c fields
            incToInsert.add(new Income__c(
                Account__c = req.accId, 
                Application__c = req.appId, 
                Income_Source__c = w.source, 
                Monthly_Amount__c = w.amount
            ));
        }
        if(!incToInsert.isEmpty()) insert incToInsert;

        // 3. Process Assets
        List<Asset__c> assetsToInsert = new List<Asset__c>();
        for(FinancialWrapper w : assets) {
            // Mapping to Asset__c fields
            assetsToInsert.add(new Asset__c(
                Account__c = req.accId, 
                Application__c = req.appId, 
                Asset_Type__c = w.type, // Make sure 'w.type' matches picklist API values
                Estimated_Value__c = w.value, 
                Description__c = w.description
            ));
        }
        if(!assetsToInsert.isEmpty()) insert assetsToInsert;

        // 4. Process Liabilities
        List<Liability__c> liabToInsert = new List<Liability__c>();
        for(FinancialWrapper w : liabilities) {
            // Mapping to Liability__c fields
            liabToInsert.add(new Liability__c(
                Account__c = req.accId, 
                Application__c = req.appId, 
                Liability_Type__c = w.type, // Make sure 'w.type' matches picklist API values
                Amount_Owed__c = w.amount, 
                Monthly_Payment__c = w.payment
            ));
        }
        if(!liabToInsert.isEmpty()) insert liabToInsert;
    }

    public class Request {
        @InvocableVariable public String accId;  
        @InvocableVariable public String appId;
        @InvocableVariable public String incomeJSON;
        @InvocableVariable public String assetJSON;
        @InvocableVariable public String liabilityJSON;
    }
}