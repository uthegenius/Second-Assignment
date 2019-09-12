trigger AccountNPI on Account (before insert, before update, after update) {
    if(Trigger.isInsert){
        for(Account acc : Trigger.New){
            acc.Account_NPI__c = acc.Name+'_' + acc.NPI__c;
            System.debug(acc.Account_NPI__c);
        }
    }
    else if(Trigger.isUpdate){
        System.debug('In isupdate condition');
        if(Trigger.isBefore){
            System.debug('In isupdate before condition');
            for(Account acc : Trigger.New){
                if(String.isBlank(acc.Account_NPI__c) && String.isNotBlank(acc.NPI__c)){
                    acc.Account_NPI__c = acc.Name +'_'+acc.NPI__c;
                }
            }
        } 
        if(Trigger.isAfter){
            System.debug('In isupdate after condition');
            List<String> disabledAccountIds = new List<String>();
            List<String> activeAccountIds = new List<String>();
            for(Account acc : Trigger.New){
                Account oldAccount = Trigger.oldMap.get(acc.ID);
                if(acc.IsActive__c == false && oldAccount.IsActive__c != acc.IsActive__c){
                    disabledAccountIds.add(acc.Id);
                } else if(acc.IsActive__c == true && oldAccount.IsActive__c != acc.IsActive__c){
                    activeAccountIds.add(acc.Id);
                }
            }
            if(disabledAccountIds.size() > 0){
                List<Contact> contacts = [SELECT Id, IsActive__c FROM contact WHERE accountId IN:disabledAccountIds];
                for(Contact contact : contacts){
                    contact.IsActive__c = false;
                }
                update contacts;
            }
            if(activeAccountIds.size() > 0){
                List<Contact> contacts = [SELECT Id, IsActive__c FROM contact WHERE accountId IN:activeAccountIds];
                for(Contact contact : contacts){
                    contact.IsActive__c = true;
                }
                update contacts;
            }
        }
    }
}