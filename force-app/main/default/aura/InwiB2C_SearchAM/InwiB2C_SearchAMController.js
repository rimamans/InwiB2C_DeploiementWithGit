({
    handleInit: function (component, event, helper) {
        var isExeNewOS;

        

        setTimeout(function() {
            helper.callUtilityBarApi(component, isExeNewOS);
        }, 500);
    },

    handleCTIMessage: function(cmp, message) {
        // Handle CTI message without the removed attributes
        console.log("CTI message received:", message);
    },

    updateInteraction: function(component, event) {
        console.log('Interaction received:', event.getParam('interaction'));
    }
})