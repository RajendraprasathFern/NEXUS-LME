public class ApplicationReportController {
    public Application__c app {get; set;}
    public List<Income__c> incomes {get; set;}
    public List<Asset__c> assets {get; set;}
    public List<Liability__c> liabilities {get; set;}
    
    // Summary Fields
    public Decimal totalIncome {get; set;}
    public Decimal totalAssets {get; set;}
    public Decimal totalLiabPay {get; set;}
    public Decimal totalDebt {get; set;}
    
    public ApplicationReportController(ApexPages.StandardController std) {
        Id appId = std.getId();
        app = [SELECT Name,Account__r.Name, Status__c FROM Application__c WHERE Id = :appId];
        
        incomes = [SELECT Income_Source__c, Monthly_Amount__c FROM Income__c WHERE Application__c = :appId];
        assets = [SELECT Asset_Type__c, Estimated_Value__c, Description__c FROM Asset__c WHERE Application__c = :appId];
        liabilities = [SELECT Liability_Type__c, Monthly_Payment__c, Amount_Owed__c FROM Liability__c WHERE Application__c = :appId];
        
        // Calculate Totals
        totalIncome = 0; for(Income__c i : incomes) totalIncome += i.Monthly_Amount__c;
        totalAssets = 0; for(Asset__c a : assets) totalAssets += a.Estimated_Value__c;
        totalLiabPay = 0; totalDebt = 0;
        for(Liability__c l : liabilities) {
            totalLiabPay += l.Monthly_Payment__c;
            totalDebt += l.Amount_Owed__c;
        }
    }
    
    public Decimal getDtiRatio() { return (totalIncome > 0) ? ((totalLiabPay / totalIncome) * 100).setScale(1) : 0; }
    public Decimal getAlRatio() { return (totalLiabPay > 0) ? (totalAssets / totalLiabPay).setScale(2) : 0; }
}