    public class FinancialWrapper {
        @AuraEnabled public String source;
        @AuraEnabled public String type;
        @AuraEnabled public Decimal amount; // For Income / Liability Amount
        @AuraEnabled public Decimal value;  // For Asset Value
        @AuraEnabled public String description;    // For Asset Description
        @AuraEnabled public Decimal payment;// For Liability Payment
    }