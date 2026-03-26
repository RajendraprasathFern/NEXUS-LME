import { LightningElement, track, api } from 'lwc';

    export default class DynamicFinancialsForm extends LightningElement {

         @api recordId; // Account ID passed from the Quick Action
         @api varAppId;
        // We use @track so the UI updates when we modify arrays
        @track incomeList = [{ id: Date.now(), source: '', amount: null }];
        @track assetList = [{ id: Date.now(), type: '', value: null, desc: '' }];
        @track liabilityList = [{ id: Date.now(), type: '', amount: null, payment: null }];

        // Exposed for the Flow to retrieve the data
        @api 
        get incomeItems() {
            return this.incomeList.map(item => ({
                Account__c: this.recordId,
                Application__c: this.varAppId,
                Income_Source__c: item.source,
                Monthly_Amount__c: item.amount
            }));
        }

        @api 
        get assetItems() {
            return this.assetList.map(item => ({
                Account__c: this.recordId,
                Application__c: this.varAppId,
                Asset_Type__c: item.type,
                Estimated_Value__c: item.value,
                Description__c: item.desc
            }));
        }

        @api 
        get liabilityItems() {
            return this.liabilityList.map(item => ({
                Account__c: this.recordId,
                Application__c: this.varAppId,
                Liability_Type__c: item.type,
                Amount_Owed__c: item.amount,
                Monthly_Payment__c: item.payment
            }));
        }
        
        // Combobox Options to match the dropdowns in your screenshot
        get assetOptions() {
            return [
                { label: 'Real Estate', value: 'Real Estate' },
                { label: 'Savings', value: 'Savings' },
                { label: 'Investment', value: 'Investment' }
            ];
        }

        get liabilityOptions() {
            return [
                { label: 'Mortgage', value: 'Mortgage' },
                { label: 'Credit Card', value: 'Credit Card' },
                { label: 'Loan', value: 'Loan' }
            ];
        }

        // Handles Adding Rows
        handleAdd(event) {
            const type = event.target.dataset.type;
            if (type === 'income') {
                this.incomeList.push({ id: Date.now(), source: '', amount: null });
            } else if (type === 'asset') {
                this.assetList.push({ id: Date.now(), type: '', value: null, desc: '' });
            } else if (type === 'liability') {
                this.liabilityList.push({ id: Date.now(), type: '', amount: null, payment: null });
            }
        }

        // Handles Deleting Rows
        handleDelete(event) {
            const index = event.target.dataset.index;
            const type = event.target.dataset.type;
            
            if (type === 'income') {
                this.incomeList.splice(index, 1);
            } else if (type === 'asset') {
                this.assetList.splice(index, 1);
            } else if (type === 'liability') {
                this.liabilityList.splice(index, 1);
            }
        }

        // Handles all input changes
        handleChange(event) {
            const index = event.target.dataset.index;
            const type = event.target.dataset.type;
            const value = event.target.value;
            const label = event.target.label;

            if (type === 'income') {
                if (label === 'Income Source') this.incomeList[index].source = value;
                if (label === 'Monthly Amount') this.incomeList[index].amount = value;
            } 
            else if (type === 'asset') {
                if (label === 'Asset Type') this.assetList[index].type = value;
                if (label === 'Estimated Value') this.assetList[index].value = value;
                if (label === 'Description') this.assetList[index].desc = value;
            } 
            else if (type === 'liability') {
                if (label === 'Liability Type') this.liabilityList[index].type = value;
                if (label === 'Amount Owed') this.liabilityList[index].amount = value;
                if (label === 'Monthly Payment') this.liabilityList[index].payment = value;
            }
        }
    }