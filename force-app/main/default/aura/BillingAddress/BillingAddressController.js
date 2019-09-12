({
    clickCreate: function(component, event, helper) {
        
            // Create the new expense
            var newExpense = component.get("v.address");
            console.log("Create Address: " + JSON.stringify(newExpense));
            var action = component.get("c.validateAddress");
            action.setParams({
            "address": newExpense
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var items = [];
                console.log(response.getReturnValue());
                var response = response.getReturnValue();
                
                console.log('Contact Inserted:'+response);
                alert(response);
                window.location.reload();
            }
            else {
                var resp = response;
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})