@isTest
public class LeadAssignmentTest {
    @isTest public static void test1(){
        LeadAssignment__c la = new LeadAssignment__c(UserId__c='0052v00000btKWCAA2', Zipcode__c='8529');
        insert la;
        Lead lead = new Lead(LastName='Test', Company='Test Company', postalCode='8529');
        insert lead;
        la.UserId__c = '0052v00000dXXlRAAW';
        update la;
        System.assertEquals(1, [Select count() FROM Lead WHERE postalCode='8529' limit 1]);
    }
}