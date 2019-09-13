@isTest
public class AddressControllerTest {
    @isTest static void validateAddressTest(){
        BillingAddress__c address = new BillingAddress__c(Street__c='3301 South Greenfield Rd', State__c='AZ', Zip__c='85297');
        

        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SmartyStreetResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        String result = AddressController.validateAddress(address);
        
        System.assertEquals('Confirmed; entire address was DPV confirmed deliverable.', result);  

    }

    @isTest static void validateAddressTest2(){
        BillingAddress__c address = new BillingAddress__c(Street__c='', State__c='AZ', Zip__c='');
        

        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SmartyStreetResponse2');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        String result = AddressController.validateAddress(address);
        
        System.assertEquals('', result);  

    }

    @isTest static void validateAddressTest3(){
        BillingAddress__c address = new BillingAddress__c(Street__c='3301 South Greenfield Rd New Street', State__c='AZ', Zip__c='85297');
        

        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SmartyStreetResponse3');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        String result = AddressController.validateAddress(address);
        
        System.assertEquals('Not Confirmed; address could not be DPV confirmed as deliverable.', result);  

    }
}
