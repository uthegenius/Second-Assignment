trigger AccountAdded on Account (before insert, after insert, before update, after update) {
if(Trigger.isInsert){
    if(Trigger.isBefore){
        List<Lead> leads = Trigger.New;
        List<String> zipcodes = new List<String>();
        for(Lead l : leads){
            zipcodes.add(l.postalCode);
        }
            List<LeadAssignment__c> la = [SELECT Id,UserId__c, Zipcode__c FROM LeadAssignment__c WHERE Zipcode__c IN:zipcodes];
            System.debug(la);
        for(Lead l : leads){
            for(LeadAssignment__c las : la){
            if(l.postalCode == las.Zipcode__c){
                l.OwnerId = las.UserId__c;
            }
            }
        }
    }
}
}