public with sharing class AddressController {
@AuraEnabled
public static String validateAddress(BillingAddress__c address){
    String message = '';
    Http http = new Http();
    System.debug(address);
HttpRequest request = new HttpRequest();
request.setEndpoint('https://us-street.api.smartystreets.com/street-address?auth-id=b84fa52b-ed14-a454-e449-2c533a570563&auth-token=RZ3BQL1duDgWcnuQTpta&'+
'street='+EncodingUtil.urlEncode(address.Street__c, 'UTF-8')+'&state='+address.State__c+'&zipcode='+address.Zip__c+'&candidates=10&match=invalid');
    System.debug('https://us-street.api.smartystreets.com/street-address?auth-id=b84fa52b-ed14-a454-e449-2c533a570563&auth-token=RZ3BQL1duDgWcnuQTpta&'+
'street='+address.Street__c+'&state='+address.State__c+'&zipcode='+address.Zip__c+'&candidates=10&match=invalid');
request.setMethod('GET');
HttpResponse response = http.send(request);
    System.debug(response);
// If the request is successful, parse the JSON response.
if (response.getStatusCode() == 200) {
// Deserialize the JSON string into collections of primitive data types.

List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
System.debug('Received the following address:'+results);
// List<Object> addresses = (List<Object>) results.get();
//     System.debug('Received the following address:'+results);
     for (Object obj: results) {
         SmartyResponse add = (SmartyResponse)SmartyResponse.parse(JSON.serialize(obj));
         System.debug(add);
         address.City__c = add.components.city_name;
         address.State__c = add.components.state_abbreviation;
         address.Street__c = add.delivery_line_1+' '+add.last_line;
         if(add.analysis.dpv_match_code == 'Y'){
             message = 'Confirmed; entire address was DPV confirmed deliverable.';
         } else if(add.analysis.dpv_match_code == 'N'){
             message = 'Not Confirmed; address could not be DPV confirmed as deliverable.';
         } else if(add.analysis.dpv_match_code == 'S'){
             message = 'Confirmed By Dropping Secondary; address was DPV confirmed by dropping all or part of the secondary info (apartment, suite, etc.).';
         } else if(add.analysis.dpv_match_code == 'D'){
             message = 'Confirmed - Missing Secondary Info; the address was DPV confirmed, but it is missing secondary information (apartment, suite, etc.).';
         } else{
             message = 'The address was not submitted for DPV. This is usually because the address does not have a ZIP Code and a +4 add-on code, or the address has already been determined to be Not Deliverable (only returned as part of the XML response).';
         }
     insert address;
     }
//     return message;

return message;
}
return '';
}
}