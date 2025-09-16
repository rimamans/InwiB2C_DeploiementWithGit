({
    callUtilityBarApi: function(component) {
        const utilityBarAPI = component.find("utilityBarAPI");

        utilityBarAPI.onUtilityClick({
            eventHandler: function () {
                utilityBarAPI.minimizeUtility();

                var workspaceAPI = component.find("workspace");

                var URL = '#/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c%3Ainwib2cSearchAMnoHandlerFrench';

                workspaceAPI.openTab({
                    url: URL,
                    focus: true
                }).then(function(response) {
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "Recherche Acteur"
                    });
                });

                console.log("Utility Clicked");
            }
        });
    }
})