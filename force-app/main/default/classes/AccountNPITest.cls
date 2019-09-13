@isTest
public class AccountNPITest {
    @isTest public static void test1(){
        Account account = new Account(Name='Test Account', NPI__c='12345678', IsActive__c=true);
        insert account;
        account.IsActive__c = false;
        Contact contact = new Contact(LastName='Test Contact');
        contact.AccountId = account.Id;
        insert contact;
        update account;
        System.assertEquals(0, [SELECT count() FROM contact WHERE accountId=:account.Id and IsActive__c=true]);
        
        account.IsActive__c = true;
        update account;
        System.assertEquals(1, [SELECT count() FROM contact WHERE accountId=:account.Id and IsActive__c=true]);
        Account acc = [select Account_NPI__c from account where Name='Test Account' and NPI__c='12345678' limit 1];
        System.assertEquals('Test Account_12345678', acc.Account_NPI__c);
    }
}