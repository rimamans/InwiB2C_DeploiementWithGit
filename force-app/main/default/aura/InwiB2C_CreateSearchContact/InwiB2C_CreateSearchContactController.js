({




    handleInit: function (component, event, helper) {
        
        
        var isExeNewOS;
              
        try {
            var action = component.get("c.fetchUserProfile");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('here1')
                    var storeResponse = response.getReturnValue();
                    var userProfileName= storeResponse.Name;
                    var lastThreedigits_userProfileName= userProfileName.slice(userProfileName.length - 3); 
                    console.log('userProfileName.length::'+userProfileName.length)
                    console.log('storeResponse::'+storeResponse)
                    console.log('userProfileName::'+userProfileName)
                    console.log('lastThreedigits_userProfileName.toLowerCase()::'+lastThreedigits_userProfileName.toLowerCase())
                    console.log('here2')

                    isExeNewOS = (userProfileName == 'System Administrator' || lastThreedigits_userProfileName.toLowerCase()=='ph2') ? true : false;
                    console.log('first exec isExeNewOS::'+isExeNewOS)

                }
            });
            $A.enqueueAction(action);

        } catch (error) {
            console.log('error:: ' + error);

        }



        setTimeout(function() {
            helper.callUtilityBarApi(component,isExeNewOS);
        }, 500);

        /*component.find('auraPubSub').registerListener('omniscript_action');
        component.find('auraPubSub').registerListener('omniscript_step');*/



    },

    handleDemoClick: function (component, event, helper) {
        var isExeNewOS;
              
        try {
            var action = component.get("c.fetchUserProfile");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('here1')
                    var storeResponse = response.getReturnValue();
                    var userProfileName= storeResponse.Name;
                    var lastThreedigits_userProfileName= userProfileName.slice(userProfileName.length - 3); 
                    console.log('userProfileName.length::'+userProfileName.length)
                    console.log('storeResponse::'+storeResponse)
                    console.log('userProfileName::'+userProfileName)
                    console.log('lastThreedigits_userProfileName.toLowerCase()::'+lastThreedigits_userProfileName.toLowerCase())
                    console.log('here2')

                    isExeNewOS = (userProfileName == 'System Administrator' || lastThreedigits_userProfileName.toLowerCase()=='ph2') ? true : false;
                    console.log('first exec isExeNewOS::'+isExeNewOS)

                    console.log('here3')

                }
            });
            $A.enqueueAction(action);

        } catch (error) {
            console.log('error:: ' + error);

        }
        helper.callUtilityBarApi(component,isExeNewOS);
    },

    handleVlocityInteractionUpdate: function(cmp, message, helper) {        
        if (message != null && message.getParam("vlocityInteractionId") != null) {

            var vlocityInteractionId = message.getParam("vlocityInteractionId")

            console.log('vlocityInteractionId pp:' + vlocityInteractionId);

            cmp.set("v.vlocityInteractionId", vlocityInteractionId);
            
            //cmp.set("v.accountIdfrmMsgChannel", message.getParam("recordId"));
        }
    },

    handleCTIMessage: function(cmp, message, helper) {        
        if (message != null && message.getParam("ctiIteractionNumber") != null) {

            var ctiIteractionNumber = message.getParam("ctiIteractionNumber")

            console.log(message.getName());
            console.log(message.getSource());

            cmp.set("v.ctiIteractionNumber", ctiIteractionNumber);


            console.log('data z :' + JSON.stringify(message.getParam("data")));
            var data = message.getParam("data");

            console.log(data);

           if (data != null){
               console.log('in Data');
                
                
                
                cmp.set("v.ctiSource", data.ctiSource);
                cmp.set("v.ctiEmailSource", data.ctiEmailSource);
                cmp.set("v.ctiFacebookId", data.ctiFacebookId);
                cmp.set("v.ctiTwitterId", data.ctiTwitterId);
                cmp.set("v.vlocityInteractionId", data.vlocityInteractionId?data.vlocityInteractionId:null);
                cmp.set("v.ctiMDN", data.ctiMDN);
                
                
            }
            
            //cmp.set("v.accountIdfrmMsgChannel", message.getParam("recordId"));
        }
    },

    updateInteraction : function(component, event, helper) {
        console.log('recieved');
        console.log(event.getParam('interaction'));
		component.set("v.vlocityInteractionId",event.getParam('interaction'));
	}

})