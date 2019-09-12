trigger AccountAdded on Account (before insert, after insert, before update, after update) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            for(Account acc : Trigger.New){
                LeadAssignment__c la = [SELECT Id,UserId__c, Zipcode__c FROM LeadAssignment__c WHERE Zipcode__c=:acc.BillingPostalCode limit 1];
                System.debug(la);
                if(acc.BillingPostalCode == la.Zipcode__c){
                    acc.OwnerId = la.UserId__c;
                }
            }
        }
    }
}