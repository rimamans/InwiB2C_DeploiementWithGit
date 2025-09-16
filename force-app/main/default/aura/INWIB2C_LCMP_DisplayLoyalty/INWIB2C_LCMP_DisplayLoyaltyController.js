({
	doInit : function(component, event, helper) {
		
        var action = component.get("c.displayLoyaltySubscription");
        action.setParams({
                "subScriptionId": component.get("v.recordId")
            });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var lmResponse = response.getReturnValue();
                component.set('v.response', lmResponse);
                console.log('Display Loyalty response : '+JSON.stringify(response.getReturnValue()));
                if(lmResponse.CSOperationResultInfo.isOK == "0"){
                    var toast = $A.get("e.force:showToast");
                   	toast.setParams({
                        "mode": "sticky",
                        "title": "Error!",
                        "type": "error",
                        "message": $A.get( "information fid non disponible" )
                    });
                    toast.fire(); 
                }
            }else{
               var toast = $A.get("e.force:showToast");
               toast.setParams({
                   	"mode": "sticky",
                    "title": "Error!",
                    "type": "error",
                    "message": $A.get( "non disponible" )
                });
                toast.fire(); 
            }
        });

        // Add the server-side action to the queue
        $A.enqueueAction(action);
	}
})