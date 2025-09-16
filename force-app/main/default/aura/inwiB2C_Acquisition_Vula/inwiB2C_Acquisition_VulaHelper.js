({
    callUtilityBarApi: function(component) {
        const utilityBarAPI = component.find("utilityBarAPI");

        utilityBarAPI.onUtilityClick({
            eventHandler: function () {
                utilityBarAPI.minimizeUtility();

                var workspaceAPI = component.find("workspace");

                var URL = '/lightning/n/EligibilityFTTH';

                workspaceAPI.openTab({
                    url: URL,
                    focus: true
                }).then(function(response) {
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "Acquisition FTTH Vula"
                    });
                });

                console.log("Utility Clicked");
            }
        });
    }
})