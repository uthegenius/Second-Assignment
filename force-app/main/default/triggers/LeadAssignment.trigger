trigger LeadAssignment on LeadAssignment__c (before insert, after insert, before update, after update) {
if(Trigger.isUpdate){
    if(Trigger.isAfter){
        List<LeadAssignment__c> las = Trigger.New;
        List<String> zipcodes = new List<String>();
        for(LeadAssignment__c l : las){
            zipcodes.add(l.Zipcode__c);
        }
            List<Account> accounts = [SELECT Id, OwnerId FROM Account WHERE BillingPostalCode IN:zipcodes];
        for(LeadAssignment__c la : las){
            LeadAssignment__c oldLead = Trigger.oldMap.get(la.ID);
            System.debug('Old User ID of Lead Assignment Object: '+oldLead.UserId__c);
            if(oldLead.UserId__c != la.UserId__c){
            System.debug(accounts);
            for(Account acc : accounts){
                acc.OwnerId = la.UserId__c;
            }
            }
        }
        
            update accounts;
    }
}
}