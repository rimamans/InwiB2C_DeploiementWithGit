({
	
    doInit: function (component, event, helper) {
		console.log("annulation commande");
		var action = component.get("c.getOrderJustificatif"); 
		console.log("action:", action);


        action.setParams({
            OrderId: component.get("v.recordId")
        });
		console.log("Record ID:", component.get("v.recordId"));

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Response state:", state);

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
				if(typeof result != "boolean"){
					console.error("Erreur de retour de la methode result:", result);
				}
                console.log("result:", result);

                component.set("v.orderState", result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error("Erreur dans isOrderJustificatif :", errors);
            }
        });

        $A.enqueueAction(action);
    }
});